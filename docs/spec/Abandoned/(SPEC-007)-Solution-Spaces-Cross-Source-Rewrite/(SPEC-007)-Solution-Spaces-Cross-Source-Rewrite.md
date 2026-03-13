---
title: "Solution-Spaces Cross-Source Rewrite"
artifact: SPEC-007
status: Abandoned
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
depends-on:
  - SPEC-004
  - SPEC-005
  - SPEC-013
---

# Solution-Spaces Cross-Source Rewrite

## Problem Statement

The `docs/reference-library/solution-spaces.md` document (528 lines) is 95% KataLog-only with rankings based on competition placement (1st=4pts, 2nd=3pts, etc.). This needs a full rewrite with production-weighted scoring (20 pts per AOSA/RealWorld/Discovered, 1-4 pts per KataLog placement) to reflect what actually works in production systems.

## External Behavior

**Inputs:**
- Current `solution-spaces.md` (KataLog-only rankings)
- All 276 catalog entries from 5 sources
- Production-weighted scoring methodology from EPIC-004

**Outputs:**
- Rewritten `solution-spaces.md` with production-weighted rankings
- New style scoreboard reflecting production reality

**Preconditions:**
- SPEC-004 (signals) and SPEC-005 (source analysis) complete

**Postconditions:**
- Style rankings reflect production systems, not competition wins
- Evidence tables cite all 5 sources

## Acceptance Criteria

| ID | Criterion | Verification |
|----|-----------|--------------|
| AC-1 | Style scoreboard rankings reflect production-weighted methodology applied to full 276-entry evidence pool | Verify scoring formula applied (20 pts/production, 20 pts/Discovered, 1-4 pts/KataLog, 1-2 pts/RefArch) |
| AC-2 | Every style profile cites evidence from 3+ distinct sources | Manual scan of evidence citations |
| AC-3 | No stale single-source references remain | grep for "62 manually", "103 ", "four sources" returns no hits |
| AC-4 | Document framework preserved (section templates, dimension definitions) | Compare structure before/after |

## Scope & Constraints

**In scope:**
- Recompute all style rankings with production weighting
- Rewrite evidence tables with cross-source citations
- Update "why this works" narratives

**Out of scope:**
- Changing style profile templates (framework preservation)
- Adding new architecture styles

## Implementation Approach

1. Read current solution-spaces.md framework
2. Apply production-weighted scoring to all catalog entries
3. Recompute style rankings
4. Rewrite evidence tables with cross-source rows
5. Update narratives to reflect production insights

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | — | Initial creation |
| Active | 2026-03-04 | ec39055 | Dependencies satisfied (SPEC-004, SPEC-005 implemented), awaiting problem-spaces.md rewrite |
| Abandoned | 2026-03-05 | fdc0ef9 | Superseded by EPIC-007 restructuring + SPEC-018 statistics update |