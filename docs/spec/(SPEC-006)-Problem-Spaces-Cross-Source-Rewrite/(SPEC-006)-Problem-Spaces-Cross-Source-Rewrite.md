---
title: "Problem-Spaces Cross-Source Rewrite"
artifact: SPEC-006
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
depends-on:
  - SPEC-004
  - SPEC-005
---

# Problem-Spaces Cross-Source Rewrite

## Problem Statement

The `docs/reference-library/problem-spaces.md` document (1500+ lines) is 98% KataLog-only — it classifies problems based on KataLog kata challenges rather than synthesizing problem classifications across all 5 evidence sources. This document needs a full cross-source rewrite to reflect the expanded 276-entry evidence base.

## External Behavior

**Inputs:**
- Current `problem-spaces.md` (KataLog-only)
- All 276 catalog entries from 5 sources (KataLog, AOSA, RealWorld, RefArch, Discovered)
- Problem dimension definitions from existing document

**Outputs:**
- Rewritten `problem-spaces.md` with cross-source problem classifications
- Problem profiles covering systems from all 5 evidence sources (not just KataLog kata challenges)

**Preconditions:**
- SPEC-004 (signals) and SPEC-005 (source analysis) complete (foundational layer)
- All catalog entries accessible

**Postconditions:**
- Document cites evidence from 3+ sources for each problem classification
- Problem space similarity matrix includes production systems

## Acceptance Criteria

| ID | Criterion | Verification |
|----|-----------|--------------|
| AC-1 | Document cites 3+ sources for major problem categories | Manual scan of evidence citations |
| AC-2 | Problem profiles include systems from all 5 evidence sources | Verify profiles exist for KataLog, AOSA, RealWorld, RefArch, and Discovered entries |
| AC-3 | Similarity matrix includes production systems (AOSA/RealWorld/Discovered) | Check matrix includes non-KataLog entries |
| AC-4 | Document framework preserved (dimension definitions, per-profile template) | Compare structure before/after |

## Scope & Constraints

**In scope:**
- Rewrite problem classification sections
- Expand problem profiles with cross-source systems
- Update similarity matrix

**Out of scope:**
- Changing problem dimension definitions (framework preservation)
- Adding new problem dimensions

## Implementation Approach

1. Read current problem-spaces.md to understand framework
2. Extract problem classifications from all catalog entries
3. Map each problem to multiple evidence sources
4. Rewrite sections with cross-source evidence
5. Expand profiles to include production systems
6. Update similarity matrix with cross-source data

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | — | Initial creation |