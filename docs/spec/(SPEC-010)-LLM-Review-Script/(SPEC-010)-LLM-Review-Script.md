---
title: "LLM Review Script"
artifact: SPEC-010
status: Testing
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-epic: EPIC-005
depends-on:
  - SPEC-002
---

# LLM Review Script

## Problem Statement

120 of 163 Discovered catalog entries sit at `Indeterminate` with `review_required: true` because the heuristic classifier's confidence fell below 0.85. Reviewing these requires manual inspection of each repo. This spec defines the core `llm-review.sh` script that automates Pass 2 (LLM review) by orchestrating `llm` CLI calls, assembling context, parsing structured JSON responses, and feeding classified results into `apply-review.py`.

## External Behavior

### Inputs

- **Catalog directory** — path to YAML catalog entries (default: `evidence-analysis/Discovered/docs/catalog/`)
- **CLI flags:**
  - `--tier <1|2|3|all>` — confidence band to process (default: all `review_required: true` entries)
  - `--max-turns <N>` — max LLM conversation turns per repo (default: 4)
  - `--model <model-id>` — LLM model to use (default: `claude-sonnet-4-6`)
  - `--clone-dir <path>` — directory for cached/on-demand repo clones
  - `--dry-run` — list entries that would be processed without calling LLM
  - `--limit <N>` — process at most N entries (for testing)

### Outputs

- **Per-repo classification** — calls `apply-review.py` for each classified repo
- **Run report** — JSON file with summary statistics (entries processed, classified, unclassifiable, escalation failures, total LLM calls)
- **Run log** — structured log of each repo's processing (turns taken, verdict, styles, confidence)

### Preconditions

- `llm` CLI installed and configured with API access
- `apply-review.py` present and functional
- Catalog YAML entries exist with valid schema

### Postconditions

- All targeted `review_required: true` entries have been processed (classified, marked unclassifiable, or logged as escalation failure)
- `apply-review.py` has been called for each classified repo, updating the catalog entry
- Run report JSON written to `pipeline/reports/`

## Acceptance Criteria

- **Given** catalog entries with `review_required: true` exist, **when** `llm-review.sh` runs, **then** each entry receives at least one LLM classification attempt
- **Given** the LLM returns a `classified` verdict with valid JSON, **when** parsing completes, **then** `apply-review.py` is called with the correct `--styles`, `--confidence`, `--summary`, and `--notes` arguments
- **Given** `--tier 1` is specified, **when** scanning for entries, **then** only entries with heuristic confidence 0.70–0.84 are processed
- **Given** `--dry-run` is specified, **when** run, **then** no LLM calls are made and no catalog entries are modified
- **Given** a run completes, **when** the report is generated, **then** it contains accurate counts matching the actual processing results
- **Given** the script is run twice on the same catalog, **when** entries are already classified (`review_required: false`), **then** they are skipped (idempotent)

## Scope & Constraints

### In scope

- Shell script (`llm-review.sh`) as the main entry point
- System prompt construction with the 13 canonical architecture styles, signal rules, and JSON response schema
- Initial context assembly (Turn 1): catalog YAML, README excerpt, repo map, manifest metadata
- JSON response parsing and verdict routing (`classified` → apply-review, `needs_info` → delegate to SPEC-011, `unclassifiable` → log)
- Tier filtering by confidence band
- Repo access: cached clone reuse or on-demand `git clone --depth 1`
- Run report generation

### Out of scope

- Multi-turn conversation management (SPEC-011 owns the escalation protocol)
- Quality validation / accuracy measurement (SPEC-012)
- Changes to `classify.py` or `apply-review.py`
- Custom model training

### Constraints

- Must use `llm` CLI (not direct API calls) — the `llm` tool handles auth, model selection, and rate limiting
- Repo map `find` command must exclude dependency/build/VCS directories per the exclusion list in EPIC-005
- README truncated to 300 lines, repo map to depth 3

## Implementation Approach

### Script structure

```
pipeline/llm-review.sh
pipeline/prompts/system-prompt.md     # LLM system prompt
pipeline/prompts/response-schema.json # JSON schema for validation
pipeline/reports/                     # Run reports directory
```

### Key functions

1. **`scan_entries()`** — find all catalog entries matching `review_required: true` and optional tier filter
2. **`assemble_context()`** — build Turn 1 payload: catalog YAML + README (300 lines) + repo map (depth 3, with exclusions) + manifest metadata
3. **`call_llm()`** — invoke `llm` CLI with system prompt + context, capture JSON response
4. **`parse_response()`** — validate JSON against schema, extract verdict type
5. **`route_verdict()`** — dispatch to `apply-review.py` (classified), escalation loop (needs_info), or log (unclassifiable)
6. **`ensure_clone()`** — check for cached clone, do on-demand shallow clone if needed
7. **`generate_report()`** — aggregate results into run report JSON

### System prompt

The system prompt (`pipeline/prompts/system-prompt.md`) must include:
- The 13 canonical architecture styles with defining structural characteristics
- Evidence-based signal rules from `skills/discover-architecture/references/signal-rules.md`
- The JSON response schema (three verdict types)
- Calibration guidance: when to classify vs. request more info vs. mark unclassifiable
- Instruction to cite specific files/directories as evidence
- Confidence scale: 0.85+ high, 0.70-0.84 moderate, below 0.70 low

### Tier mapping

| Tier | Confidence range | Description |
|------|-----------------|-------------|
| 1 | 0.70 – 0.84 | Near threshold, likely minimal LLM help needed |
| 2 | 0.50 – 0.69 | Medium ambiguity, may need multi-turn |
| 3 | 0.30 – 0.49 | High ambiguity, structural signals weak |
| all | 0.00 – 0.84 | Full run (default) |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | 334cf4a | Initial creation under EPIC-005 |
| Approved | 2026-03-04 | 5507fd8 | Implemented llm-review.sh with dry-run validation |
| Testing | 2026-03-04 | b5da2cd | Pilot: 3/3 classified, full tier-1 run in progress |
