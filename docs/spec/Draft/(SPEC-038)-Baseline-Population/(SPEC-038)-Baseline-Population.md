---
title: "Baseline Population"
artifact: SPEC-038
status: Draft
author: cristos
created: 2026-03-14
last-updated: 2026-03-14
type: feature
parent-epic: EPIC-014
linked-research: []
linked-adrs: []
depends-on:
  - SPEC-037
addresses: []
evidence-pool: ""
source-issue: ""
swain-do: required
---

# Baseline Population

## Problem Statement

The constraint baseline schema (SPEC-037) defines the format; this spec populates it. Each of the 10 canonical architecture styles needs a baseline file containing structural rules and statistical norms derived from the evidence base (262 catalog entries, 196 from the Discovered pipeline). Without populated baselines, the drift detection engine has nothing to compare against.

## External Behavior

**Input:** The evidence base catalogs (`skills/architecture-advisor/references/catalogs/`), the style taxonomy (`style-taxonomy.yaml`), and the constraint baseline schema (SPEC-037).

**Output:** 10 YAML baseline files (one per canonical style), each containing:

1. **Structural rules** codified from architectural knowledge:
   - Layered: unidirectional dependency (no upward calls), layer isolation
   - Modular Monolith: module boundary enforcement, explicit public API per module
   - Pipeline: ordered stage flow, no backward data flow between stages
   - Microkernel: plugin isolation, kernel API as sole extension point
   - Service-Based: service granularity (4-12), shared database access patterns
   - Event-Driven: async communication, no direct service-to-service calls for event flows
   - Space-Based: processing unit replication, in-memory data grid usage
   - Microservices: bounded contexts, independent deployment, no shared database
   - Serverless: function granularity, event triggers, statelessness
   - Multi-Agent: agent autonomy, message-passing coordination

2. **Statistical norms** computed from the evidence base:
   - Style frequency and co-occurrence patterns (from the 142 production-only repos)
   - Common quality attribute associations per style
   - Platform vs. application distribution per style
   - Typical co-occurring styles (e.g., Layered + Microkernel appears in N% of repos)

3. **Co-occurrence expectations** derived from multi-style classifications in the catalog.

**Postconditions:** All 10 baseline files validate against the SPEC-037 schema. Statistical norms cite their sample sizes and computation methodology.

## Acceptance Criteria

1. **Given** the 10 canonical architecture styles, **when** baselines are populated, **then** each style has exactly one baseline file conforming to the SPEC-037 schema.
2. **Given** a style's baseline file, **when** its structural rules are reviewed, **then** every rule is grounded in the style's architectural definition (from the taxonomy or authoritative sources), not invented.
3. **Given** a style's statistical norms, **when** the computation is traced, **then** each norm references the evidence base subset it was computed from and the sample size is stated.
4. **Given** the evidence base has styles with fewer than 5 repos (Space-Based: 1, Multi-Agent: 1, Serverless: 0), **when** baselines are populated for these styles, **then** statistical norms are marked as low-confidence with explicit sample-size warnings.
5. **Given** all 10 baseline files, **when** validated against the SPEC-037 JSON Schema, **then** all pass without errors.
6. **Given** the co-occurrence data, **when** a reviewer checks it against the evidence base's `by-architecture-style.md`, **then** the frequencies match the published production-weighted rankings.

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

- Works exclusively with the existing evidence base — no new data collection or catalog expansion.
- Statistical norms for low-sample styles (Space-Based, Multi-Agent, Serverless) will be sparse; this is acceptable — flag it, don't fabricate data.
- Structural rules are derived from established architectural knowledge (Richards & Ford, AOSA, etc.), not from LLM inference alone.
- Baseline files live alongside the style taxonomy in the architecture-advisor skill's references directory.
- Design patterns (architecture_qualifiers) are out of scope — only the 10 topology-defining styles get baselines.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-14 | — | Initial creation |
