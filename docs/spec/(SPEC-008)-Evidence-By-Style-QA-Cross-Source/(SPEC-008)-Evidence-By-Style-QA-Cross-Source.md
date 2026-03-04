---
title: "Evidence Cross-Source Update"
artifact: SPEC-008
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
depends-on:
  - SPEC-006
  - SPEC-007
---

# Evidence Cross-Source Update

## Problem Statement

The two evidence synthesis documents (`evidence/by-architecture-style.md` at 487 lines/92% KataLog and `evidence/by-quality-attribute.md` at 538 lines/90% KataLog) need cross-source rewrites. Both present KataLog-only evidence tables that need to be replaced with cross-source evidence.

## External Behavior

**Inputs:**
- Current `evidence/by-architecture-style.md` (KataLog team evidence)
- Current `evidence/by-quality-attribute.md` (KataLog rankings)
- All 276 catalog entries from 5 sources

**Outputs:**
- Rewritten `evidence/by-architecture-style.md` with cross-source evidence
- Rewritten `evidence/by-quality-attribute.md` with cross-source triangulated QA

**Preconditions:**
- SPEC-006 (problem-spaces) and SPEC-007 (solution-spaces) complete

**Postconditions:**
- Evidence tables cite all 5 sources
- Quality attribute rankings reflect production data

## Acceptance Criteria

| ID | Criterion | Verification |
|----|-----------|--------------|
| AC-1 | by-architecture-style.md cites 3+ sources per style | Manual scan |
| AC-2 | by-quality-attribute.md shows cross-source QA triangulation | Check QA sections |
| AC-3 | KataLog team rows replaced with cross-source evidence rows | Compare before/after |

## Scope & Constraints

**In scope:**
- Rewrite by-architecture-style.md evidence tables
- Rewrite by-quality-attribute.md with production-weighted rankings
- Update per-style and per-QA sections

**Out of scope:**
- New evidence sources
- New architecture styles or quality attributes

## Implementation Approach

1. Read current evidence documents
2. Extract cross-source evidence for each architecture style
3. Rewrite by-architecture-style.md with production evidence
4. Recompute QA rankings from all sources
5. Rewrite by-quality-attribute.md with triangulated data

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | — | Initial creation |