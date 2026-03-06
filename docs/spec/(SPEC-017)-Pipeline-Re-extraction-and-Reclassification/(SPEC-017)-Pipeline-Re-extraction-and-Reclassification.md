---
title: "Pipeline Re-extraction and Re-classification"
artifact: SPEC-017
status: Draft
author: cristos
created: 2026-03-05
last-updated: 2026-03-05
parent-epic: EPIC-008
depends-on:
  - SPEC-002
---

# Pipeline Re-extraction and Re-classification

## Problem Statement

Commit `b71edbe` added new signal categories (`service_based`, `plugin_microkernel`) to `extract-signals.sh` and new scorers to `classify.py`, but the 122 existing signal files were extracted before these changes. The new SBA and Plugin/Microkernel scorers read zeroes from every signal file because the YAML sections don't exist yet.

A sample test (5 cloned repos) confirmed the new signals work: shopware SBA=0.7, temporal SBA=0.6, mastodon SBA=0.7, backstage Plugin=0.5. The full corpus needs re-extraction to realize these improvements.

The existing catalog entries were produced by heuristic + LLM review. Re-running heuristic-only classification would overwrite LLM-reviewed results (116/122 entries would regress to Indeterminate). The re-classification must be selective: only update entries where the new scorers produce a confident, different outcome.

### Why selective merge matters

The heuristic classifier alone produces `confidence < 0.85` for most repos — that's by design, since the LLM review step adds the classification intelligence. Blindly overwriting catalog entries with heuristic results destroys months of LLM review work. The merge strategy preserves LLM-reviewed classifications as the default and only overwrites when the new heuristic is both confident and different.

## External Behavior

**Input:** 122 repos from `pipeline/manifest.yaml`, existing signals and catalog in `evidence-analysis/Discovered/`.

**Outputs** (all under `evidence-analysis/Discovered/`):

| Output | Path | Description |
|--------|------|-------------|
| Re-extracted signals | `signals/*.signals.yaml` | All 122 files updated with `service_based:` and `plugin_microkernel:` sections, plus corrected `docker_compose_services` |
| Updated catalog entries | `docs/catalog/*.yaml` | Only entries where classification actually changes |
| Comparison report | `docs/analysis/reclassification-comparison.md` | Before/after for every repo, highlighting changes |
| Updated quality report | `quality-report.md` | Recomputed statistics from corrected catalog |
| Updated source analysis | `docs/analysis/source-analysis.md` | Corrected style/QA distributions |
| Regenerated index | `_index.yaml` | Rebuilt from updated catalog |

**Preconditions:**
- `extract-signals.sh` has new signal sections (done: `b71edbe`)
- `classify.py` has improved scorers and conflict resolution (done: `b71edbe`, `81f6835`)
- Network access to GitHub + `GITHUB_TOKEN` for rate limits

## Acceptance Criteria

1. All 122 signal files contain `service_based:` and `plugin_microkernel:` YAML sections
2. `docker_compose_services` values match actual YAML service counts (not inflated line counts)
3. Service-Based detected in 15+ of the 23 expected SBA repos (up from 4-6)
4. Plugin/Microkernel detected in 5+ repos (up from 0)
5. Microservices, Modular Monolith, and Event-Driven detection counts do not decrease by more than 5%
6. `reclassification-comparison.md` produced with before/after styles and scores for every changed repo
7. `quality-report.md` and `source-analysis.md` reflect corrected counts
8. `_index.yaml` matches the updated catalog

## Scope & Constraints

### In scope

- Re-extract signals for all 122 repos (clone + `extract-signals.sh`)
- Selective re-classification with merge logic (preserve LLM-reviewed entries)
- All analysis artifacts under `evidence-analysis/Discovered/`

### Out of scope

- Re-running LLM review (EPIC-005 — would take days, separate decision)
- Adding new repos to the corpus
- Updating the 6 reference library documents (see SPEC-018)

## Implementation Approach

### Step 1: Signals-only extraction (parallelizable)

Clone each repo, run `extract-signals.sh`, save to `signals/`. Do not classify during extraction — this decouples the slow network step from the fast classification step.

**Parallelization:** Split the 122 repos across 4 agents, each handling ~30. Each agent:
1. Reads its slice of `manifest.yaml`
2. Clones repos to a temp directory (shallow, `--depth 1`)
3. Runs `extract-signals.sh` on each clone
4. Writes the signal YAML to `evidence-analysis/Discovered/signals/{name}.signals.yaml`
5. Deletes the clone immediately to save disk

Agents work on disjoint repo sets so there are no write conflicts on signal files.

### Step 2: Selective re-classification (sequential)

A single script processes all 122 signal files:

```
For each repo:
  1. Load new signals
  2. Run classify.py → new heuristic result
  3. Load existing catalog entry
  4. Decision:
     - If new styles differ AND new confidence >= 0.85 → update catalog
     - If new result is Indeterminate → keep existing (LLM-reviewed)
     - If new styles match existing → keep existing
  5. Log the comparison (old styles, new styles, new scores, decision)
```

### Step 3: Generate analysis artifacts

1. Run `pipeline/generate-index.py` to rebuild `_index.yaml`
2. Run `pipeline/quality-report.py` to regenerate `quality-report.md`
3. Recompute `docs/analysis/source-analysis.md` style/QA tables from updated catalog
4. Write `docs/analysis/reclassification-comparison.md` from Step 2 logs

### Step 4: Validate

1. Spot-check 5 key repos: Backstage, Gitpod, Shopware, Medusa, Temporal
2. Diff before/after style distributions — flag any regression > 5%
3. Verify comparison report is complete (122 rows)

### Resource estimates

| Step | Duration | Network | Disk | Parallelism |
|------|----------|---------|------|-------------|
| Clone + extract (122 repos) | ~45 min | ~10-20 GB | ~5 GB temp | 4 agents |
| Classify + merge | ~5 min | None | Negligible | 1 agent |
| Analysis artifacts | ~10 min | None | Negligible | 1 agent |
| Validation | ~5 min | None | Negligible | 1 agent |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-05 | — | Initial creation |
