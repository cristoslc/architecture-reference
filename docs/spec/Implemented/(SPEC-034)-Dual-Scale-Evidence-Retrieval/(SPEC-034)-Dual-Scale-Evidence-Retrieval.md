---
title: "Dual-Scale Evidence Retrieval"
artifact: SPEC-034
status: Implemented
author: cristos
created: 2026-03-12
last-updated: 2026-03-12
parent-epic: EPIC-011
linked-research: []
linked-adrs:
  - ADR-004
depends-on:
  - SPEC-033
  - EPIC-010
addresses:
  - "Research priority table is application-centric only; no ecosystem evidence retrieval path"
evidence-pool: ""
swain-do: required
---

# Dual-Scale Evidence Retrieval

## Problem Statement

The architecture-advisor skill's Step 3 (Research the evidence) has a single research priority table designed for application-centric queries. Once SPEC-033 detects a platform context, the skill has no way to prioritize ecosystem-level evidence -- ecosystem frequency rankings, ecosystem catalog entries, and platform decision paths are absent from the research flow. Step 4 (Synthesize) also lacks citation patterns for ecosystem evidence.

## External Behavior

### Input

- Context classification from SPEC-033 (`application`, `platform`, or `hybrid`)
- User's architecture question

### Output

- Context-appropriate evidence retrieved in priority order
- Citations using ecosystem-specific patterns (ecosystem catalog entries, composition patterns)
- Ecosystem frequency rankings available in offline reference

### Preconditions

- SPEC-033 context detection is implemented
- Ecosystem catalog entries exist (EPIC-010)

### Postconditions

- Step 3 has three context-variant research priority tables (application, platform, hybrid)
- Step 4 has ecosystem-specific citation patterns
- Offline reference includes ecosystem frequency rankings (11 entries)

## Acceptance Criteria

- **Given** a platform context, **when** the advisor researches evidence, **then** it consults ecosystem frequency rankings as Priority 1, ecosystem catalog entries as Priority 2, and platform decision paths as Priority 3
- **Given** an application context, **when** the advisor researches evidence, **then** it uses the existing priority order (unchanged)
- **Given** a hybrid context, **when** the advisor researches evidence, **then** it merges both pools with provenance labels (single-repo, ecosystem, production system)
- **Given** ecosystem evidence, **when** the advisor synthesizes recommendations, **then** it cites ecosystem entries specifically (e.g., "The ELK Stack ecosystem uses Pipeline + Event-Driven composition")
- **Given** no synced reference data, **when** the advisor operates in offline mode, **then** ecosystem frequency rankings (11 entries) are available in the offline reference section

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|
| Three context-variant tables in Step 3 | SKILL.md Step 3 contains separate research priority tables for application, platform, and hybrid contexts | Pass |
| Platform priorities correct | Platform table: P1 ecosystem frequency, P2 ecosystem catalog, P3 decision navigator platform paths, P4 single-repo member patterns | Pass |
| Ecosystem citation patterns in Step 4 | Two new citation patterns added: ecosystem evidence and composition patterns | Pass |
| Offline ecosystem frequency table | Offline Reference section contains 11-entry ecosystem frequency ranking table with Service-Based at 45% | Pass |
| Key insight documented | Offline reference notes Service-Based dominance in ecosystems (45%) vs. single-repo (4.9%) | Pass |

## Scope & Constraints

### In scope

- Splitting Step 3 into context-variant research priorities
- Adding ecosystem citation patterns to Step 4
- Adding ecosystem frequency rankings to offline reference
- Provenance labeling for hybrid context

### Out of scope

- Context detection (that is SPEC-033)
- Platform decision paths in the navigator (that is SPEC-035)
- Statistical modeling of ecosystem entries (that is SPIKE-001)

## Implementation Approach

1. Split Step 3's research priority table into application/platform/hybrid variants
2. Add ecosystem-specific citation patterns to Step 4
3. Add ecosystem frequency rankings table to the offline reference section, immediately after the production frequency rankings
4. Add provenance labeling instructions for hybrid context

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Implemented | 2026-03-12 | — | Context-variant research tables, ecosystem citations, and offline ecosystem rankings added to SKILL.md |
