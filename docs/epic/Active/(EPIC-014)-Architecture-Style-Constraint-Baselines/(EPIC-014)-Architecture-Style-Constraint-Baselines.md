---
title: "Architecture Style Constraint Baselines"
artifact: EPIC-014
status: Active
author: cristos
created: 2026-03-14
last-updated: 2026-03-14
parent-vision: VISION-002
success-criteria:
  - Every architecture style in the taxonomy has a documented set of structural constraints (boundary rules, dependency direction, coupling expectations)
  - Constraint baselines are derived from statistical analysis of the evidence base, not invented from theory alone
  - Baselines include confidence intervals or frequency data so drift detection can distinguish "unusual" from "violation"
depends-on: []
addresses: []
evidence-pool: ""
---

# Architecture Style Constraint Baselines

## Goal / Objective

Derive per-architecture-style structural expectations from the evidence base (142+ production repos, 11 ecosystems). For each style in the taxonomy, define what "structurally correct" looks like: typical dependency patterns, boundary conventions, coupling characteristics, and communication mechanisms. These baselines serve as the comparison target for drift detection.

## Scope Boundaries

**In scope:**
- Extracting structural norms from the evidence base for each architecture style
- Documenting constraints per style (e.g., Layered: no upward dependencies; Microkernel: plugins only through kernel API)
- Statistical characterization (how common is each constraint across repos of that style)
- Machine-readable constraint format consumable by the drift detection engine

**Out of scope:**
- Drift detection logic (EPIC-015)
- Static analysis tool integration (future concern)
- New data collection or catalog expansion — works with the existing evidence base

## Child Specs

| Spec | Title | Status | Depends On |
|------|-------|--------|------------|
| SPEC-037 | Constraint Baseline Schema | Approved | — |
| SPEC-038 | Baseline Population | Draft | SPEC-037 |

## Key Dependencies

- Depends on the existing evidence base and architecture taxonomy from VISION-001
- discover-architecture skill provides the classification output format that baselines must align with

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-14 | b88a076c | Initial creation |
| Active | 2026-03-14 | 81e4d03a | Child specs created, starting implementation |
