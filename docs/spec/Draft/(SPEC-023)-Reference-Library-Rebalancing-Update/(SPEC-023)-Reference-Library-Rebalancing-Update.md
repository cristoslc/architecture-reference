---
title: "Reference Library Rebalancing Update"
artifact: SPEC-023
status: Draft
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-epic: EPIC-012
depends-on:
  - SPEC-022
linked-adrs:
  - ADR-001
execution-tracking: required
---

# Reference Library Rebalancing Update

## Problem Statement

SPEC-022 produces corrected production-only frequency rankings with platform/application splits. The 8 reference library documents still show pre-rebalancing statistics that include libraries, reference implementations, and an unbalanced corpus. These documents are the primary user-facing output of the evidence base.

## External Behavior

**Input:** Production-only frequency tables and platform/application splits from SPEC-022.

**Outputs** (all under `docs/reference-library/`):

| Document | What changes |
|----------|-------------|
| `solution-spaces.md` | Frequency Scoreboard uses production-only counts; platform vs application breakdown |
| `problem-spaces.md` | Domain-style distributions recomputed from balanced corpus |
| `evidence/by-architecture-style.md` | Frequency Rankings updated; annotation examples from reference implementations |
| `evidence/by-quality-attribute.md` | QA detection frequencies recomputed |
| `problem-solution-matrix.md` | Matrix cells updated with production-only data |
| `decision-navigator.md` | Statistical basis updated; platform vs application guidance paths |
| `evidence/cross-source-reference.md` | Discovered column uses production-only counts |
| `evidence/cross-source-analysis.md` | Tier tables updated |

## Acceptance Criteria

1. All 8 documents reflect production-only frequency rankings
2. Reference implementations appear as annotation examples (not counted in frequencies)
3. Platform vs application style distributions presented where relevant
4. Cross-document statistical consistency verified (all cite same counts)
5. Tutorial bias correction noted where rankings changed significantly (DDD, Hexagonal, CQRS)

## Implementation Approach

1. Extract updated statistics from SPEC-022 outputs
2. Update documents in parallel (3 agents by layer, matching SPEC-018 approach)
3. Cross-document consistency check
4. Note methodology change (production-only, equal weight, ADR-001) in each document

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-06 | 23bed6f | Initial creation |
