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

Commit `b71edbe` fundamentally changed the classification pipeline: new signal categories (`service_based`, `plugin_microkernel`), a rewritten SBA scorer (5 signals / 0.8 max, up from 2 / 0.4), a new Plugin/Microkernel scorer, SBA vs MS conflict resolution, and a fix to `docker_compose_services` extraction. The 122 existing signal files and catalog entries were produced by the old pipeline and need a clean re-run.

A sample test (5 cloned repos) confirmed the new signals work: shopware SBA=0.7, temporal SBA=0.6, mastodon SBA=0.7, backstage Plugin=0.5.

### Why a clean re-run, not selective merge

The classifier changes are structural, not incremental. The old SBA scorer had a 0.4 ceiling that systematically prevented SBA detection; the old pipeline had no Plugin scorer at all; `docker_compose_services` was miscounted. Carrying forward old classifications would perpetuate these systematic errors. The right approach: re-run the full pipeline (heuristic + LLM review) from scratch, uninformed by prior results, and produce a comparison report for audit. The old catalog is archived for reference, not used as a fallback.

## External Behavior

**Input:** 122 repos from `pipeline/manifest.yaml`.

**Outputs** (all under `evidence-analysis/Discovered/`):

| Output | Path | Description |
|--------|------|-------------|
| Re-extracted signals | `signals/*.signals.yaml` | All 122 files re-extracted with new signal sections and corrected `docker_compose_services` |
| New catalog entries | `docs/catalog/*.yaml` | Full re-classification from scratch (heuristic + LLM review) |
| Comparison report | `docs/analysis/reclassification-comparison.md` | Old vs new classification for every repo, for audit |
| Updated quality report | `quality-report.md` | Recomputed statistics from new catalog |
| Updated source analysis | `docs/analysis/source-analysis.md` | Corrected style/QA distributions |
| Regenerated index | `_index.yaml` | Rebuilt from new catalog |
| Archived old catalog | `docs/catalog-archive-pre-008/` | Snapshot of catalog before re-run, for traceability |

**Preconditions:**
- `extract-signals.sh` has new signal sections (done: `b71edbe`)
- `classify.py` has improved scorers and conflict resolution (done: `b71edbe`, `81f6835`)
- Network access to GitHub + `GITHUB_TOKEN` for rate limits

## Acceptance Criteria

1. All 122 signal files contain `service_based:` and `plugin_microkernel:` YAML sections
2. `docker_compose_services` values match actual YAML service counts (not inflated line counts)
3. All 122 catalog entries re-classified from scratch (heuristic + LLM review pipeline)
4. Service-Based detected in 15+ of the 23 expected SBA repos (up from 4-6)
5. Plugin/Microkernel detected in 5+ repos (up from 0)
6. `reclassification-comparison.md` produced with old vs new styles and scores for all 122 repos
7. `quality-report.md`, `source-analysis.md`, and `_index.yaml` reflect new catalog
8. Old catalog archived in `docs/catalog-archive-pre-008/`

## Scope & Constraints

### In scope

- Re-extract signals for all 122 repos (clone + `extract-signals.sh`)
- Full re-classification: heuristic pass → LLM review for Indeterminate entries
- Comparison report (old vs new) for audit — not for merge decisions
- Archive old catalog before overwriting
- All analysis artifacts under `evidence-analysis/Discovered/`

### Out of scope

- Adding new repos to the corpus
- Changes to scorers or signals (those are done; this spec executes them)
- Updating the 6 reference library documents (see SPEC-018)

## Implementation Approach

### Step 0: Archive old catalog

Copy `docs/catalog/` to `docs/catalog-archive-pre-008/` before any changes. This preserves the old classifications for the comparison report and rollback if needed.

### Step 1: Signal extraction (parallelizable)

Clone each repo, run `extract-signals.sh`, save to `signals/`. Decouple extraction from classification so the slow network step runs independently.

**Parallelization:** Split the 122 repos across 4 agents, each handling ~30. Each agent:
1. Reads its slice of `manifest.yaml`
2. Clones repos to a temp directory (shallow, `--depth 1`)
3. Runs `extract-signals.sh` on each clone
4. Writes the signal YAML to `signals/{name}.signals.yaml`
5. Deletes the clone immediately to save disk

Agents work on disjoint repo sets — no write conflicts.

### Step 2: Heuristic classification (parallelizable)

Run `classify.py` on all 122 new signal files. This is fast (~5 min total) and produces catalog entries with `classification_method: heuristic` or `heuristic-inconclusive`. Can be parallelized across 4 agents matching Step 1's splits, since each catalog file is independent.

### Step 3: LLM review of Indeterminate entries

Run `llm-review.sh` on entries where heuristic classification is Indeterminate (expected: 60-80 repos). This is the same LLM review pipeline from EPIC-005 but with the improved heuristic candidates informing the review.

This step is the long pole — estimate ~2-4 hours depending on LLM rate limits. Can be parallelized by splitting the Indeterminate list across agents, each running `llm-review.sh` on its slice.

### Step 4: Generate analysis artifacts

1. Build comparison report: diff old catalog (from archive) against new catalog, produce `docs/analysis/reclassification-comparison.md`
2. Run `pipeline/generate-index.py` to rebuild `_index.yaml`
3. Run `pipeline/quality-report.py` to regenerate `quality-report.md`
4. Recompute `docs/analysis/source-analysis.md` from new catalog

### Step 5: Validate

1. Spot-check 5 key repos: Backstage, Gitpod, Shopware, Medusa, Temporal — verify SBA or Plugin detected
2. Diff old vs new style distributions — review any large swings
3. Verify comparison report covers all 122 repos
4. Sanity-check that no repos lost their classification entirely (every entry should have at least one non-Indeterminate style after LLM review)

### Resource estimates

| Step | Duration | Network | Disk | Parallelism |
|------|----------|---------|------|-------------|
| Archive old catalog | ~1 min | None | ~5 MB | 1 |
| Clone + extract (122 repos) | ~45 min | ~10-20 GB | ~5 GB temp | 4 agents |
| Heuristic classify | ~5 min | None | Negligible | 4 agents |
| LLM review (~70 entries) | ~2-4 hours | LLM API | Negligible | 2-4 agents |
| Analysis artifacts | ~10 min | None | Negligible | 1 agent |
| Validation | ~5 min | None | Negligible | 1 agent |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-05 | — | Initial creation |
