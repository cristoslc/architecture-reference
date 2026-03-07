---
title: "Pipeline Run and Frequency Recomputation"
artifact: SPEC-022
status: Draft
author: cristos
created: 2026-03-06
last-updated: 2026-03-07
parent-epic: EPIC-012
depends-on:
  - SPEC-020
  - SPEC-021
  - SPEC-024
linked-adrs:
  - ADR-001
  - ADR-002
execution-tracking: required
---

# Pipeline Run and Frequency Recomputation

## Problem Statement

After catalog cleanup (SPEC-020) and application expansion (SPEC-021), the frequency rankings must be recomputed using only production-grade entries with equal weighting per ADR-001. The current rankings include libraries, reference implementations, and an unbalanced platform/application mix.

## External Behavior

**Input:** Cleaned and expanded catalog (~150 entries: 120 existing minus 43 removed plus 30+ new applications).

**Outputs:**

| Output | Description |
|--------|-------------|
| Production frequency table | Style frequencies computed from production-grade entries only |
| Platform frequency table | Style frequencies for platform-scope entries |
| Application frequency table | Style frequencies for application-scope entries |
| Before/after comparison | Old vs new rankings showing impact of rebalancing |
| Updated quality report | `quality-report.md` recomputed |
| Updated source analysis | `source-analysis.md` recomputed |
| Updated index | `_index.yaml` rebuilt |

## Acceptance Criteria

1. Frequency tables computed from production-grade entries only (reference excluded)
2. Separate frequency tables for platform-scope and application-scope entries
3. Combined production frequency table for overall rankings
4. Before/after comparison document showing rank changes
5. All analysis artifacts regenerated from new catalog
6. No reference or removed entries appear in frequency counts

## Implementation Approach

1. Filter catalog entries by `use_type: production`
2. Compute overall production frequency table
3. Split by `scope:` and compute platform and application frequency tables
4. Generate before/after comparison (old full-catalog vs new production-only)
5. Regenerate `quality-report.md`, `source-analysis.md`, `_index.yaml`

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-06 | 23bed6f | Initial creation |
| Implemented | 2026-03-07 | 11e4f397 | Premature — heuristic-only data for new entries |
| Draft | 2026-03-07 | f2786ab4 | Reverted per ADR-002; blocked on SPEC-024 (deep-analysis campaign) |
