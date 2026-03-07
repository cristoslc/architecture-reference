---
title: "Validation Run Execution"
artifact: SPEC-016
status: Abandoned
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-epic: EPIC-006
depends-on:
  - SPEC-013
  - SPEC-014
---

# Validation Run Execution

## Problem Statement

SPEC-013 delivers the `llm-validate.sh` script and SPEC-014 defines the override rules, but neither specifies the operational plan for running validation across all four priority populations. Without a defined run plan, there is no structure for incremental rollout, no criteria for when to proceed from one population to the next, and no checkpoint for evaluating whether the tooling works before committing LLM budget to 100+ entries.

## External Behavior

### Inputs

- **`pipeline/llm-validate.sh`** — validated and functional (SPEC-013)
- **Override rules** — implemented in the script (SPEC-014)
- **Catalog entries** — 163 entries across four priority populations
- **LLM API access** — configured via `llm` CLI

### Outputs

- **Per-population verification reports** — `pipeline/reports/validation-deep-*.json` for each priority run
- **Disagreement reports** — markdown reports for flagged entries requiring manual review
- **Updated catalog entries** — auto-accepted reclassifications applied to YAML files
- **Run log** — console output documenting each population's processing

### Preconditions

- `llm-validate.sh --priority 1 --limit 5 --dry-run` succeeds (entry selection verified)
- `llm-validate.sh --priority 1 --limit 5 --verbose` succeeds end-to-end (pilot run)
- `apply-review.py --method deep-validation` correctly sets `classification_method`

### Postconditions

- All four priority populations processed (or explicitly deferred with rationale)
- Verification reports archived in `pipeline/reports/`
- Disagreement entries reviewed and resolved (accepted, overridden, or deferred)
- Gold standard expansion candidates identified (entries where all methods agree)

## Acceptance Criteria

- **Given** the pilot run (P1, limit 5), **when** it completes, **then** at least 3 of 5 entries produce a valid verdict (confirmed, reclassified, downgraded, or upgraded) and the verification report is well-formed JSON
- **Given** a successful pilot, **when** the full P1 run executes, **then** all 43 heuristic-only entries are processed and the report shows the verdict distribution
- **Given** P1 and P2 are complete, **when** reviewing results, **then** the override decision breakdown (auto-accept / flag / defer) is documented and flagged entries have been manually reviewed
- **Given** all runs are complete, **when** running `validate-review.py --methods heuristic,llm-review,deep-validation`, **then** the three-way comparison report shows per-method accuracy against the gold standard
- **Given** entries where all three methods agree, **when** identified, **then** they are listed as gold standard expansion candidates for SPEC-015

## Scope & Constraints

### In scope

- Pilot run: P1 (5 entries) to validate tooling end-to-end
- Full P1 run: all 43 heuristic-only entries
- P2 run: LLM-classified entries with confidence < 0.85
- P3 run: LLM-classified entries with confidence >= 0.85
- P4 run: spot-check of unclassifiable entries
- Manual review of disagreement reports after each population
- Three-way comparison after all populations complete

### Out of scope

- Modifying the validation script (that's SPEC-013)
- Changing override rules (that's SPEC-014)
- Expanding the gold standard (that's SPEC-015 — but this spec identifies candidates)
- Prompt tuning or model switching based on results

### Constraints

- Each population should complete before starting the next (incremental rollout)
- Flagged entries from each run should be reviewed before proceeding
- Clone caching (`--clone-dir`) should be used to avoid redundant clones across runs
- Budget awareness: each entry costs 1 LLM call; full run is ~163 calls

## Implementation Approach

### Run Plan

| Phase | Command | Expected Entries | Gate Criteria |
|-------|---------|-----------------|---------------|
| **Pilot** | `llm-validate.sh --priority 1 --limit 5 --verbose --clone-dir /tmp/deep-clones` | 5 | Valid verdicts for >= 3 entries, well-formed report |
| **P1 Full** | `llm-validate.sh --priority 1 --clone-dir /tmp/deep-clones --verbose` | 43 | Report generated, disagreements reviewed |
| **P2** | `llm-validate.sh --priority 2 --clone-dir /tmp/deep-clones --verbose` | ~20 | Report generated, disagreements reviewed |
| **P3** | `llm-validate.sh --priority 3 --clone-dir /tmp/deep-clones --verbose` | ~37 | Report generated |
| **P4** | `llm-validate.sh --priority 4 --limit 10 --clone-dir /tmp/deep-clones --verbose` | 10 | Spot-check: any false negatives? |

### Gate Criteria Between Phases

1. **Pilot → P1 Full:** Pilot produces valid JSON report. At least 3/5 entries get a verdict (not `clone_failed` or `error`). No script crashes.
2. **P1 → P2:** P1 report reviewed. Flagged disagreements resolved. Auto-accept rate is reasonable (> 50%).
3. **P2 → P3:** P2 disagreements reviewed. No systematic prompt failures.
4. **P3 → P4:** P3 complete. Three-way comparison run shows deep-validation accuracy >= 85%.

### Post-Run Checklist

After each population run:

1. Review the verification report (`pipeline/reports/validation-deep-*.json`)
2. Review the disagreement report if generated (`pipeline/reports/disagreements-*.md`)
3. For flagged entries: inspect the catalog YAML and decide accept/override/defer
4. Run `validate-review.py` to check accuracy against gold standard
5. Note gold standard expansion candidates (all methods agree)

### Final Deliverable

After all populations complete:

```bash
# Three-way comparison
python3 pipeline/validate-review.py \
  --methods heuristic,llm-review,deep-validation

# Summary stats
echo "Reports generated:"
ls -la pipeline/reports/validation-deep-*.json
ls -la pipeline/reports/disagreements-*.md
```

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | — | Initial creation under EPIC-006 |
| Abandoned | 2026-03-07 | — | Obsolete per ADR-002: heuristic classification dropped |
