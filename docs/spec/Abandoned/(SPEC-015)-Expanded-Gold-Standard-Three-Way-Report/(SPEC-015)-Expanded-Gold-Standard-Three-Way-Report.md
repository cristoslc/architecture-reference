---
title: "Expanded Gold Standard & Three-Way Report"
artifact: SPEC-015
status: Abandoned
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-epic: EPIC-006
depends-on:
  - SPEC-013
---

# Expanded Gold Standard & Three-Way Report

## Problem Statement

The current gold standard has 17 manually verified entries — enough to validate EPIC-005's 85% accuracy target, but insufficient for fine-grained analysis across methods. With deep-context validation (SPEC-013) producing a third classification signal, we can expand the gold standard with entries where all three methods (heuristic, `llm-review`, `deep-validation`) agree, and produce a three-way comparison report showing method-level accuracy.

## External Behavior

### Inputs

- **Existing gold standard** — `pipeline/gold-standard/gold-standard.yaml` (17 entries)
- **Catalog entries** — YAML files with classifications from all three methods
- **Verification report** — `pipeline/reports/validation-deep-*.json` from SPEC-013

### Outputs

- **Expanded gold standard** — 40+ entries where all methods agree (auto-expanded) plus manually reviewed additions
- **Three-way comparison report** — per-method accuracy, agreement rates, and per-style breakdown
- **Extended `validate-review.py`** — accepts `--methods` flag for multi-method comparison

### Postconditions

- Gold standard has 40+ entries covering 12+ architecture styles
- Three-way report shows accuracy of each classification method
- `validate-review.py --methods heuristic,llm-review,deep-validation` produces comparison

## Acceptance Criteria

- **Given** entries where heuristic, llm-review, and deep-validation all agree, **when** expanding the gold standard, **then** those entries are added as candidates (subject to manual confirmation)
- **Given** the expanded gold standard, **when** `validate-review.py --methods all` runs, **then** a three-way comparison report shows per-method accuracy
- **Given** a per-method report, **when** a method has accuracy below 85%, **then** the report flags which styles that method struggles with
- **Given** the three-way report, **when** comparing methods, **then** the report shows agreement rates between each pair of methods

## Implementation Approach

### Gold Standard Expansion

1. Identify entries where all three methods agree on primary style
2. Add these as gold standard candidates
3. Manually verify a subset to confirm accuracy
4. Expand from 17 to 40+ entries

### validate-review.py Extension

Add `--methods` flag:

```bash
# Single method (existing behavior)
python3 pipeline/validate-review.py

# Three-way comparison
python3 pipeline/validate-review.py --methods heuristic,llm-review,deep-validation
```

When `--methods` is provided, the script:
1. Groups catalog entries by `classification_method`
2. Computes accuracy for each method against gold standard
3. Computes pairwise agreement rates
4. Produces a combined report with per-method sections

### Three-Way Report Format

```
============================================================
THREE-WAY COMPARISON REPORT
============================================================
Gold standard entries:  42
Methods compared:       heuristic, llm-review, deep-validation

Per-method accuracy:
  heuristic:        78.6% (33/42)
  llm-review:       88.1% (37/42)
  deep-validation:  92.9% (39/42)

Pairwise agreement:
  heuristic vs llm-review:       81.0%
  heuristic vs deep-validation:  79.0%
  llm-review vs deep-validation: 90.5%

All three agree:  75.0% (31/42)
```

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | — | Initial creation under EPIC-006 |
| Abandoned | 2026-03-07 | — | Obsolete per ADR-002: heuristic classification dropped |
