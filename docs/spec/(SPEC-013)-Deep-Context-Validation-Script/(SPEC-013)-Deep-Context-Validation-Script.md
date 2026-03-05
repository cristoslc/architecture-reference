---
title: "Deep-Context Validation Script"
artifact: SPEC-013
status: Implemented
author: cristos
created: 2026-03-04
last-updated: 2026-03-05
parent-epic: EPIC-006
depends-on:
  - SPEC-010
  - SPEC-011
---

# Deep-Context Validation Script

## Problem Statement

The existing `llm-review.sh` pipeline (SPEC-010) classified repos using metadata alone — catalog YAML, README excerpts, and directory trees from signal extraction reports. Many entries had no clone available, and 43 entries were classified by the heuristic alone without any LLM review. A second pass with cloned repos and deep context assembly will catch misclassifications and validate existing results.

## External Behavior

### Inputs

- **Catalog directory** — YAML entries to validate
- **Priority flag** — which population to process (P1: heuristic-only, P2: low-confidence LLM, P3: high-confidence LLM, P4: unclassifiable)
- **Clone directory** — cached shallow clones (or clones on-demand)
- **Existing classification** — current styles, confidence, and method from catalog YAML

### Outputs

- **Updated catalog entries** — reclassified entries via `apply-review.py --method deep-validation`
- **Verification report** — `pipeline/reports/validation-deep-TIMESTAMP.json` with per-entry verdicts
- **Console summary** — counts of confirmed/reclassified/downgraded/upgraded/promoted entries

### Preconditions

- `llm` CLI installed and configured
- Catalog entries exist with prior classifications (heuristic or LLM)
- Network access for cloning repos

### Postconditions

- Each processed entry has a deep-validation verdict
- Catalog entries updated per override rules (SPEC-014)
- Verification report saved to `pipeline/reports/`

## Acceptance Criteria

- **Given** `--priority 1` flag, **when** the script runs, **then** only heuristic-only entries (no `classification_method: llm-review`) are processed
- **Given** an entry with `classification_method: heuristic`, **when** the LLM classifies it differently, **then** the verdict is `reclassified` and the catalog is updated
- **Given** `--dry-run` flag, **when** the script runs, **then** matching entries are listed but not processed
- **Given** a repo URL in the catalog, **when** processing the entry, **then** the repo is always cloned (shallow, cached) before context assembly
- **Given** a cloned repo, **when** assembling context, **then** docker-compose.yml, Dockerfiles, key config files, and architecture docs are included alongside the standard catalog YAML + README + tree

## Implementation Approach

### Deep Context Assembly

Beyond the standard Turn 1 context from `llm-review.sh`, the validation script assembles:

| Source | Content | Size limit |
|--------|---------|------------|
| Catalog YAML | Full entry including existing classification | Full |
| README | First 300 lines | ~300 lines |
| Repo map | `find` tree depth **4** (not 3) | ~300 lines |
| docker-compose.yml | Full contents if present | ~200 lines |
| Dockerfiles | All Dockerfiles (root + subdirs) | ~100 lines each |
| Config files | serverless.yml, k8s manifests, terraform/*.tf | ~200 lines each |
| Source structure | Top-level src dirs with file counts per language | ~50 lines |
| Architecture docs | ARCHITECTURE.md, docs/adr/*.md | ~300 lines |
| Existing classification | Current styles, confidence, method (notes stripped to prevent anchoring) | Inline in prompt |

### Priority Population Selection

```bash
--priority 1   # Heuristic-only: classification_method != llm-review, review_required = false
--priority 2   # LLM low-confidence: classification_method = llm-review, confidence < 0.85
--priority 3   # LLM high-confidence: classification_method = llm-review, confidence >= 0.85
--priority 4   # Unclassifiable: architecture_styles = [Indeterminate], review_required = false
--priority all  # All of the above
```

### Verdict Comparison Logic

```python
if new_styles == existing_styles:
    verdict = "confirmed"
elif existing_styles == ["Indeterminate"]:
    verdict = "promoted"
elif len(new_styles) < len(existing_styles):
    verdict = "downgraded"
elif len(new_styles) > len(existing_styles):
    verdict = "upgraded"
else:
    verdict = "reclassified"
```

### CLI Interface

```bash
pipeline/llm-validate.sh [OPTIONS]

Options:
  --priority <1|2|3|4|all>  Population to validate (default: all)
  --limit <N>               Process at most N entries
  --entry <name.yaml>       Process a single specific entry
  --model <ID>              LLM model (default: from llm config)
  --clone-dir <PATH>        Directory for cached repo clones
  --dry-run                 List entries without processing
  --catalog <PATH>          Catalog directory
  --verbose                 Show detailed progress
```

## Critical Files

| File | Action |
|------|--------|
| `pipeline/llm-validate.sh` | **New** — main validation script |
| `pipeline/prompts/validation-prompt.md` | **New** — validation-specific prompt template |
| `pipeline/prompts/system-prompt.md` | Read — reused for architecture style definitions |
| `pipeline/llm-review.sh` | Reference — reuse patterns for context assembly, parsing |
| `pipeline/apply-review.py` | Dependency — called with `--method deep-validation` |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | — | Initial creation under EPIC-006 |
