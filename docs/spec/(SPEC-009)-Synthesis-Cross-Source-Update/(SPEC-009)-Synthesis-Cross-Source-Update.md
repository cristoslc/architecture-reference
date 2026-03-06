---
title: "Synthesis Cross-Source Update"
artifact: SPEC-009
status: Abandoned
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
depends-on:
  - SPEC-006
  - SPEC-007
  - SPEC-008
---

# Synthesis Cross-Source Update

## Problem Statement

The two synthesis documents (`problem-solution-matrix.md` at 248 lines/85% KataLog and `decision-navigator.md` at 414 lines/90% KataLog) need cross-source rewrites. These are the highest-level synthesis documents that tie together problem spaces, solution spaces, and evidence.

## External Behavior

**Inputs:**
- Current `problem-solution-matrix.md` (KataLog evidence cells)
- Current `decision-navigator.md` (KataLog decision paths)
- Rewritten SPEC-006/007/008 outputs

**Outputs:**
- Rewritten `problem-solution-matrix.md` with cross-source evidence in all cells
- Rewritten `decision-navigator.md` with production-system evidence paths

**Preconditions:**
- SPEC-006, SPEC-007, SPEC-008 complete (Layer 2 foundation)

**Postconditions:**
- Every evidence cell cites 3+ sources
- All 10 decision paths cite production evidence

## Acceptance Criteria

| ID | Criterion | Verification |
|----|-----------|--------------|
| AC-1 | problem-solution-matrix.md has cross-source evidence in all cells | Scan evidence columns |
| AC-2 | decision-navigator.md has production evidence in all 10 paths | Check each decision path |
| AC-3 | Domain rows expanded beyond kata challenges | Count domain entries |

## Scope & Constraints

**In scope:**
- Rewrite problem-solution-matrix.md with cross-source cells
- Rewrite decision-navigator.md with production evidence
- Expand domain rows

**Out of scope:**
- Changing document structure/templates (framework preservation)
- New decision paths

## Implementation Approach

1. Read current synthesis documents
2. Rebuild problem-solution-matrix with cross-source evidence
3. Rewrite decision-navigator paths with production examples
4. Verify consistency with SPEC-006/007/008

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | — | Initial creation |
| Abandoned | 2026-03-05 | — | Superseded by EPIC-007 restructuring + SPEC-018 statistics update |