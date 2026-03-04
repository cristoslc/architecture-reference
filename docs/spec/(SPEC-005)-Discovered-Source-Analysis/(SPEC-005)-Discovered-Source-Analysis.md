---
title: "Cross-Source Reference Library Rewrites"
artifact: SPEC-005
status: Implemented
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-epic: EPIC-004
linked-research: []
linked-adrs: []
depends-on:
  - SPEC-004
  - SPEC-006
addresses: []
---

# Cross-Source Reference Library Rewrites

## Problem Statement

Six core reference library documents totaling ~3,700 lines remain 85-98% KataLog-only despite the evidence base expanding from 78 to 276 entries across 5 sources. Practitioners reading these files see competition-derived findings presented as if they were the complete picture, missing critical insights from production systems (AOSA), real-world applications (RealWorld), reference implementations (RefArch), and discovered repositories (Discovered).

The most impactful distortion: style rankings driven by KataLog team counts rather than production-weighted methodology. The rewrite will apply consistent scoring (20 pts per production system, 20 pts per Discovered repo, 1-4 pts per KataLog placement, 1-2 pts per RefArch implementation) and let the rankings emerge from the full evidence pool.

## External Behavior

**Inputs:**
- 276 catalog entries across 5 sources
- Existing document frameworks (section structures, table templates, dimension definitions)
- Production-weighted scoring methodology (20 pts/production system, 20 pts/Discovered repo, 1-4 pts/KataLog placement, 1-2 pts/RefArch impl)

**Outputs:**
- Rewritten versions of 6 reference library files:
  1. `docs/reference/problem-spaces.md` (1500+ lines) — system problem profiles from all sources
  2. `docs/reference/solution-spaces.md` (528 lines) — style scoreboard with production weighting
  3. `docs/reference/evidence/by-architecture-style.md` (487 lines) — cross-source evidence tables per style
  4. `docs/reference/evidence/by-quality-attribute.md` (538 lines) — cross-source quality attribute rankings
  5. `docs/reference/problem-solution-matrix.md` (248 lines) — evidence cells citing all sources
  6. `docs/reference/decision-navigator.md` (414 lines) — decision paths grounded in production evidence

**Preconditions:**
- All catalog YAMLs exist (EPIC-001, EPIC-003 complete)
- Signal files exist (SPEC-004 complete)
- Discovered source analysis exists (SPEC-006 complete)

**Postconditions:**
- Every reference file cites evidence from 3+ sources (verified by grep)
- Style scoreboard reflects production-weighted rankings
- No stale single-source references remain ("62 manually", "103 ", "four sources")
- Document frameworks preserved (dimension definitions, table structures, navigation logic)

## Acceptance Criteria

- **Given** the rewritten `solution-spaces.md`
  **When** I view the style scoreboard rankings
  **Then** rankings reflect production-weighted methodology applied to all 276 catalog entries (20 pts/production system, 20 pts/Discovered repo, 1-4 pts/KataLog placement, 1-2 pts/RefArch implementation)

- **Given** any reference library file
  **When** I search for evidence citations
  **Then** every major claim cites evidence from at least 3 sources (not just KataLog)

- **Given** the rewritten files
  **When** I run `grep -r "62 manually\|103 \|four sources" docs/reference/`
  **Then** I get zero matches (all stale references updated)

- **Given** a practitioner reading `by-architecture-style.md`
  **When** they view any architecture style section
  **Then** they see evidence rows citing multiple sources (AOSA, RealWorld, RefArch, Discovered, KataLog) — not just KataLog teams

## Scope & Constraints

**In scope:**
- Full rewrite of 6 files (~3,700 lines total)
- Production-weighted score computation
- Cross-source evidence integration
- Framework preservation (reuse section templates, dimension definitions)
- Stale reference cleanup

**Out of scope:**
- New evidence sources (no new data collection)
- Schema changes to catalog YAMLs
- Structural changes to document frameworks
- Comparative analysis features (EPIC-003 Phase 3)

**Token budget:** ~150K tokens for reading existing docs, computing scores, drafting rewrites, and validation. This is the most token-intensive SPEC in EPIC-004.

**Implementation order:** Bottom-up dependency chain to maintain consistency:
1. Layer 1 (foundational): `problem-spaces.md` — establishes system profiles
2. Layer 2 (evidence): `solution-spaces.md`, `by-architecture-style.md`, `by-quality-attribute.md` — use profiles from Layer 1
3. Layer 3 (synthesis): `problem-solution-matrix.md`, `decision-navigator.md` — use rankings and evidence from Layer 2

## Implementation Approach

### Phase 1: Foundation (Layer 1)
1. **Audit catalog data** — aggregate style/QA/pattern distributions across all 5 sources
2. **Compute production-weighted scores** — implement scoring formula (20 pts/production, 20 pts/Discovered, 1-4 pts/KataLog, 1-2 pts/RefArch)
3. **Rewrite problem-spaces.md** — expand KataLog-only profiles to cross-source system profiles covering all sources

### Phase 2: Evidence (Layer 2)
4. **Rewrite solution-spaces.md** — update style scoreboard with production-weighted rankings
5. **Rewrite by-architecture-style.md** — replace KataLog team rows with cross-source evidence tables
6. **Rewrite by-quality-attribute.md** — triangulate QA rankings across all 5 sources

### Phase 3: Synthesis (Layer 3)
7. **Rewrite problem-solution-matrix.md** — rebuild evidence cells with cross-source citations
8. **Rewrite decision-navigator.md** — update decision paths with production-system evidence

### Phase 4: Validation
9. **Stale reference cleanup** — grep for and update all stale counts/references
10. **Cross-source verification** — ensure every file cites 3+ sources
11. **Framework preservation check** — verify dimension definitions, table structures unchanged

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | 960504c | Initial creation for EPIC-004 implementation |
| Implemented | 2026-03-04 | 10a003c | Discovered source analysis created, production-weighted scoring defined |
