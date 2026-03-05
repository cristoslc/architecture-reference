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

The Discovered classification pipeline added new signal categories (`service_based`, `plugin_microkernel`) and fixed `docker_compose_services` extraction in commit `b71edbe`, but the 122 existing signal files lack these new fields. The improved SBA and Plugin/Microkernel scorers cannot produce meaningful results until signals are re-extracted from cloned repos.

Additionally, the existing catalog entries were produced by heuristic classification + LLM review. A naive re-run of heuristic-only classification would overwrite LLM-reviewed results, causing regressions in 116/122 entries. The re-classification must preserve LLM review data and only update entries where the new scorers change the outcome.

### Signal gaps in existing files

| Signal | Status | Impact |
|--------|--------|--------|
| `service_based.monorepo_packages` | Missing (new) | SBA scorer's strongest signal unavailable |
| `service_based.db_config_count` | Missing (new) | SBA shared-database detection unavailable |
| `plugin_microkernel.*` (4 fields) | Missing (new) | Plugin scorer has zero input |
| `docker_compose_services` | Present but inflated | Old extraction counted indented lines, not YAML services |

## External Behavior

**Input:** The 122 repos listed in `pipeline/manifest.yaml`.

**Output:**
1. Updated `evidence-analysis/Discovered/signals/*.signals.yaml` — all 122 files re-extracted with new signal sections
2. Updated `evidence-analysis/Discovered/docs/catalog/*.yaml` — only entries where classification changes
3. A before/after comparison report showing which repos changed classification and why
4. Updated `evidence-analysis/Discovered/_index.yaml` with corrected style distributions

**Preconditions:**
- `extract-signals.sh` has the new `service_based` and `plugin_microkernel` signal sections (done: `b71edbe`)
- `classify.py` has the improved SBA/Plugin scorers and conflict resolution (done: `b71edbe`)
- Network access to clone 122 repos from GitHub
- `GITHUB_TOKEN` set for API rate limits

**Constraints:**
- Must not regress LLM-reviewed classifications for repos where the new heuristic doesn't produce a different result
- Must not change non-SBA/Plugin classifications unless the corrected `docker_compose_services` affects them
- Total re-extraction runtime ~2-4 hours at `-j 4` concurrency

## Acceptance Criteria

1. **Signal completeness:** All 122 signal files contain `service_based:` and `plugin_microkernel:` sections with non-default values where applicable
2. **SBA detection improvement:** Service-Based detected in 15+ of the 23 repos that `manifest.yaml` expects as SBA (up from 4-6)
3. **Plugin detection improvement:** Plugin/Microkernel detected in 5+ repos (up from 0)
4. **No regressions:** Microservices, Modular Monolith, and Event-Driven detection counts do not decrease by more than 5%
5. **Compose fix verified:** `docker_compose_services` values are accurate YAML service counts (not inflated line counts)
6. **Comparison report** produced showing every changed classification with before/after styles and scores

## Scope & Constraints

### In scope

- Re-extract signals for all 122 repos via `run-pipeline.sh --force`
- Re-classify using heuristic scorer only (no LLM review re-run)
- Merge strategy: only update catalog entries where the new heuristic produces a confident classification that differs from the existing entry
- Produce comparison report as markdown
- Regenerate `_index.yaml` with corrected statistics

### Out of scope

- Re-running LLM review on all 122 repos (EPIC-005 territory — would take days)
- Adding new repos to the corpus
- Changes to non-SBA/Plugin scorers (unless docker_compose_services fix causes cascading changes)
- Updating the 6 reference library documents (separate task under EPIC-008)

## Implementation Approach

### Phase A: Re-extract signals (bulk operation)

```bash
# Clone all 122 repos and re-extract signals only (no classification)
# Modify run-pipeline.sh to support --signals-only mode, or:
# Loop through manifest, clone each repo, run extract-signals.sh, save to signals/
```

Options:
1. **Full pipeline re-run** (`run-pipeline.sh --force`): clones, extracts, classifies, writes catalog. Simple but overwrites LLM-reviewed catalog entries.
2. **Signals-only extraction**: Clone each repo, run `extract-signals.sh`, save signals but don't classify. Then run classification separately with merge logic. Safer but requires a new script.

**Recommended: Option 2** — signals-only extraction, then selective classification.

### Phase B: Selective re-classification

```python
# For each repo:
# 1. Load new signals from re-extracted file
# 2. Run classify.py to get new heuristic result
# 3. Compare with existing catalog entry
# 4. If new result differs AND confidence >= 0.85, update catalog
# 5. If new result is Indeterminate, keep existing catalog entry (LLM-reviewed)
# 6. Log the comparison either way
```

### Phase C: Validation and reporting

1. Compare before/after style distributions
2. Spot-check the 5 key misclassification targets: Backstage, Gitpod, Shopware, Medusa, Temporal
3. Verify no regressions in MS/MM/EDA counts
4. Generate comparison report markdown

### Phase D: Index regeneration

1. Run `generate-index.py` to rebuild `_index.yaml` from updated catalog entries
2. Update `quality-report.md` and `source-analysis.md` with corrected counts

### Resource estimates

| Step | Duration | Network | Disk |
|------|----------|---------|------|
| Clone 122 repos (shallow, `-j 4`) | ~1-2 hours | ~10-20 GB download | ~5 GB temp |
| Extract signals | ~30 min | None | Negligible |
| Classify + merge | ~5 min | None | Negligible |
| Validation + report | ~10 min | None | Negligible |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-05 | — | Initial creation |
