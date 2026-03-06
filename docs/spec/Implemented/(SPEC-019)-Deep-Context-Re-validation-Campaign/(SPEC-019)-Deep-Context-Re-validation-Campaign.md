---
title: "Deep-Context Re-validation Campaign"
artifact: SPEC-019
status: Implemented
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-epic: EPIC-006
depends-on:
  - SPEC-013
  - SPEC-017
execution-tracking: required
---

# Deep-Context Re-validation Campaign

## Problem Statement

SPEC-017 re-ran the Discovery pipeline from scratch with improved SBA and Plugin/Microkernel scorers, producing a fresh 163-repo catalog classified by heuristic + LLM review. However, 80 entries in the previous catalog had `deep-validation` classifications — source-code-informed verdicts from EPIC-006's first validation campaign (SPEC-013) that read actual Dockerfiles, config files, architecture docs, and source directory structures. The SPEC-017 re-run intentionally discarded those results to avoid contaminating the new pipeline with old-scorer artifacts.

The reclassification comparison report (SPEC-017, AC6) flagged 30 regressions where a `deep-validation` classification was replaced by a `heuristic` or `llm-review` result. Examples:

| Repo | Old (deep-validation) | New (heuristic/llm-review) |
|------|----------------------|---------------------------|
| backstage | Modular Monolith | Microservices |
| grafana | Modular Monolith | Microservices |
| airflow | Pipe-and-Filter | Microservices |
| conductor | Microservices | Modular Monolith |
| hazelcast | Space-Based | Event-Driven |

These regressions are expected — heuristic scoring over-weights Docker/k8s signals toward Microservices, and the LLM review sees only metadata. Deep-context validation reads the actual source code and is the highest-fidelity classification method in the pipeline. The new 163-repo catalog needs a fresh deep-validation pass before its statistics can be trusted for reference library updates (SPEC-018).

### What changed since SPEC-013

- **Corpus grew**: 122 to 163 repos (41 new entries that have never been deep-validated)
- **New signal sections**: `service_based`, `plugin_microkernel`, `shared_library`, `workspace_config` — the validation prompt should reference these
- **New architecture styles to validate**: SBA and Plugin/Microkernel detections need deep-context confirmation
- **Tooling option**: Claude Code subagents with Opus can perform deep-context validation directly, without requiring the `llm` CLI. Each subagent clones a repo, assembles context, and classifies — leveraging the same prompt and override logic but executed natively in the agent runtime.

## External Behavior

**Input:** 163 catalog entries from SPEC-017's re-classification, plus their signal files.

**Outputs:**

| Output | Path | Description |
|--------|------|-------------|
| Updated catalog entries | `evidence-analysis/Discovered/docs/catalog/*.yaml` | Entries updated with `classification_method: deep-validation` where the validation changes or confirms the classification |
| Verification report | `pipeline/reports/validation-deep-TIMESTAMP.json` | Per-entry verdicts: confirmed, reclassified, downgraded, upgraded, promoted |
| Regression resolution report | `docs/analysis/regression-resolution.md` | Disposition of the 30 SPEC-017 regressions — resolved, confirmed, or escalated |
| Updated quality report | `evidence-analysis/Discovered/quality-report.md` | Recomputed from post-validation catalog |

**Preconditions:**
- SPEC-017 complete (catalog re-extracted and re-classified)
- SPEC-013 tooling available (`llm-validate.sh` or equivalent subagent workflow)
- Network access for cloning repos
- `ANTHROPIC_API_KEY` or Claude Code session for subagent execution

## Acceptance Criteria

1. All 163 catalog entries processed with deep-context validation (clone + source inspection + classification)
2. The 30 SPEC-017 regressions each have a documented disposition (deep-validation confirms new result, restores old result, or produces a third classification)
3. 41 new entries (not in old catalog) receive their first deep-validation
4. Classification accuracy >= 90% against the gold standard (per EPIC-006 success criteria)
5. No entry has `classification_method: heuristic-inconclusive` after validation (all Indeterminate entries either classified or confirmed as libraries/frameworks)
6. `quality-report.md` regenerated from post-validation catalog
7. Verification report produced with per-entry verdicts and LLM call counts

## Scope & Constraints

### In scope

- Deep-context validation of all 163 catalog entries
- Regression triage for the 30 entries flagged in SPEC-017's comparison report
- Updating catalog entries with deep-validation results via `apply-review.py --method deep-validation`
- Regenerating quality report post-validation
- Using Claude Code subagents (Opus) as the primary validation runtime — each subagent clones a repo, assembles deep context, and classifies

### Out of scope

- Changes to scorers or signal extraction (EPIC-008 scope, already complete)
- Override rules engine (SPEC-014 — this spec applies existing override logic, doesn't change it)
- Gold standard expansion (SPEC-015)
- Reference library statistics update (SPEC-018 — consumes this spec's output)

## Implementation Approach

### Execution model: Claude Code subagents

Instead of the `llm` CLI pipeline from SPEC-013, this campaign uses Claude Code subagents with Opus for validation. Each subagent:

1. **Clones the repo** (shallow, `--depth 1`) to a temp directory
2. **Assembles deep context** using the same sources as SPEC-013:
   - Catalog YAML with existing classification
   - README (first 300 lines)
   - Repo map (`find` tree, depth 4)
   - `docker-compose.yml` / Dockerfile contents
   - Key config files (serverless.yml, k8s manifests, terraform)
   - Source directory structure with file counts
   - Architecture docs (ARCHITECTURE.md, ADRs)
   - Signal file (including new `service_based`, `plugin_microkernel` sections)
3. **Classifies** using the system prompt and validation prompt from `pipeline/prompts/`
4. **Produces a verdict**: confirmed, reclassified, downgraded, upgraded, or promoted
5. **Updates the catalog entry** via `apply-review.py --method deep-validation`

**Do NOT use the `llm` CLI to call Claude models.** Use Claude Code's native Agent tool with subagents, which runs Opus directly.

### Parallelization

Split the 163 entries across batches of subagents (4-8 concurrent). Each subagent handles ~20-40 entries sequentially. Subagents write results to a shared reports directory; the orchestrator merges them into the final verification report.

### Priority ordering

Process in this order to maximize impact:
1. **30 regression entries** (highest priority — these are known quality gaps)
2. **41 new entries** (never deep-validated)
3. **47 heuristic-only entries** (classified by heuristic without LLM review)
4. **45 remaining LLM-reviewed entries** (confirm or improve existing classifications)

### Post-validation steps

1. Regenerate `quality-report.md` from updated catalog
2. Regenerate `_index.yaml` from updated catalog
3. Produce regression resolution report
4. Run specwatch scan

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-06 | beb158f | Initial creation; depends on SPEC-017 (complete) and SPEC-013 (tooling) |
| Implemented | 2026-03-06 | e99ac10 | 163/163 repos deep-validated via Claude Code subagents (Opus). 17.8% heuristic agreement. Signal files stamped with both heuristic and deep-validation blocks. |
