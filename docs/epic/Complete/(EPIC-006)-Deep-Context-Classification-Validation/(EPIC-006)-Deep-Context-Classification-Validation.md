---
title: "Deep-Context Classification Validation"
artifact: EPIC-006
status: Complete
author: cristos
created: 2026-03-04
last-updated: 2026-03-08
parent-vision: VISION-001
success-criteria:
  - All classifiable entries (100+) re-validated with cloned repo context
  - Verification report with per-entry verdicts (confirmed/reclassified/downgraded/upgraded)
  - Deep-analysis is the sole classification source per ADR-002
depends-on:
  - EPIC-005
---

# Deep-Context Classification Validation

## Goal / Objective

EPIC-005 classified 120 Indeterminate catalog entries using `llm` CLI with Minimax 2.5 — but **without cloning repos**. The LLM saw only pre-assembled metadata: catalog YAML, README excerpts from signal extraction, and directory trees from the signals report. Many entries had no clone available, so the LLM classified based on metadata alone.

The remaining 43 entries were classified by the heuristic alone (confidence >= 0.85) and were never reviewed by any LLM at all.

This EPIC runs a **second validation pass** using the same `llm` CLI + Minimax 2.5, but with **cloned repos** — feeding actual source files, full directory trees, docker-compose contents, and architecture-relevant code to the LLM for a much richer classification.

## Scope Boundaries

### In scope

- **Deep-context validation script** (`pipeline/llm-validate.sh`) that always clones repos before classifying
- **Deep context assembly** — beyond Turn 1 basics: full `find` tree (depth 4), docker-compose.yml / Dockerfile contents, key config files (serverless.yml, k8s manifests, terraform), top-level source directory structure with file counts, architecture docs (ARCHITECTURE.md, ADRs)
- **Validation prompt** — includes existing classification + evidence, asks LLM to verify or correct
- **Comparison logic** — categorizes results as confirmed, reclassified, downgraded, upgraded, promoted
- **Override rules** — superseded by ADR-002 (deep-analysis is sole source; no override needed)
- **Gold standard / three-way comparison** — superseded by ADR-002 (no heuristic or LLM review stages to compare against)

### Out of scope

- Heuristic classification (dropped per ADR-002)
- Training custom models
- Modifying the catalog YAML schema

## Populations to Validate

| Population | Count | Risk | Priority |
|-----------|-------|------|----------|
| Not yet deep-validated | ~45 | Highest — heuristic-only, unreliable per ADR-002 | P1 |
| Previously deep-validated (SPEC-019) | ~120 | Low — already classified via source code inspection | P2 (spot-check only) |

## Pipeline Design

### Architecture

```
+-----------------------------------------------------------+
|  llm-validate.sh                                           |
|                                                            |
|  1. Scan catalog by priority population                    |
|  2. For each entry:                                        |
|     +--------------------------------------------------+   |
|     |  Always Clone (git clone --depth 1, cached)      |   |
|     +--------------------------------------------------+   |
|                    |                                       |
|     +--------------------------------------------------+   |
|     |  Deep Context Assembly                           |   |
|     |  - catalog YAML (existing classification)        |   |
|     |  - README (first 300 lines)                      |   |
|     |  - repo map (depth 4, not 3)                     |   |
|     |  - docker-compose.yml / Dockerfile contents      |   |
|     |  - key config files (serverless, k8s, terraform) |   |
|     |  - source directory structure with file counts   |   |
|     |  - architecture docs (ARCHITECTURE.md, ADRs)     |   |
|     +--------------------------------------------------+   |
|                    |                                       |
|     +--------------------------------------------------+   |
|     |  Validation Prompt                               |   |
|     |  "Current classification: X (confidence Y)       |   |
|     |   Based on: Z evidence                           |   |
|     |   Verify or correct with this deep context."     |   |
|     +--------------------------------------------------+   |
|                    |                                       |
|     +--------------------------------------------------+   |
|     |  Comparison Logic                                |   |
|     |  confirmed / reclassified / downgraded /         |   |
|     |  upgraded / promoted                             |   |
|     +--------------------------------------------------+   |
|                                                            |
|  3. Generate verification report                           |
+-----------------------------------------------------------+
```

### Verdict Categories

| Verdict | Definition |
|---------|-----------|
| `confirmed` | New classification matches existing styles |
| `reclassified` | Different primary style identified |
| `downgraded` | Fewer styles found (heuristic over-classification corrected) |
| `upgraded` | Additional styles found with deep context |
| `promoted` | Previously unclassifiable entry now classified |

## Child Specs

| ID | Title | Status |
|----|-------|--------|
| [SPEC-013](../../spec/(SPEC-013)-Deep-Context-Validation-Script/(SPEC-013)-Deep-Context-Validation-Script.md) | Deep-Context Validation Script | Implemented |
| ~~SPEC-014~~ | ~~Override Rules & Disagreement Report~~ | Abandoned (ADR-002) |
| ~~SPEC-015~~ | ~~Expanded Gold Standard & Three-Way Report~~ | Abandoned (ADR-002) |
| ~~SPEC-016~~ | ~~Validation Run Execution~~ | Abandoned (ADR-002) |
| [SPEC-019](../../spec/Implemented/(SPEC-019)-Deep-Context-Re-validation-Campaign/(SPEC-019)-Deep-Context-Re-validation-Campaign.md) | Deep-Context Re-validation Campaign | Implemented |

## Validation

Before transitioning EPIC-006 to Active, run a pilot to confirm the tooling works end-to-end:

```bash
# Pilot: 5 heuristic-only entries
pipeline/llm-validate.sh --priority 1 --limit 5 --verbose --clone-dir /tmp/deep-clones
```

**Gate criteria:** at least 3 of 5 entries produce a valid verdict (not `clone_failed` or `error`), verification report is well-formed JSON, and `apply-review.py --method deep-validation` correctly updates catalog entries.

## Key Dependencies

- **EPIC-005** — The LLM classification pipeline whose results we are validating
- **EPIC-003** — The discovery pipeline and catalog schema
- **`llm` CLI** — Must be installed and configured with API access
- **`apply-review.py`** — Extended with `--method` flag for `deep-validation`
- **Repo access** — Ability to shallow-clone all catalog repos

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-04 | — | 43 heuristic-only + 57 LLM-classified entries awaiting deep-context validation |
