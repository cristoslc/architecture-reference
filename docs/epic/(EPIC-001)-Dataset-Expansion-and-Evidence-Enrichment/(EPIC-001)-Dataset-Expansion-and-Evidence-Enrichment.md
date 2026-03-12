---
title: "Dataset Expansion and Evidence Enrichment"
artifact: EPIC-001
status: Complete
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-vision: VISION-001
success-criteria:
  - 4+ evidence sources integrated with structured YAML catalogs
  - _index.yaml schema supports non-Kata evidence sources
  - Cross-source analysis published, triangulating findings across competition, production, and reference sources
depends-on: []
---

# Dataset Expansion and Evidence Enrichment

## Goal / Objective

Expand the evidence base beyond O'Reilly Kata submissions by integrating multiple complementary sources — addressing the original dataset's single-source bias and lack of production validation. The expanded dataset makes the reference library's findings more robust by triangulating across competition designs, production systems, and reference implementations.

## Scope Boundaries

### In scope

- Incorporate AOSA book architectures (13 production systems) as a new evidence source alongside TheKataLog
- Add curated reference implementation repos (9 entries) as validated examples for canonical patterns
- Add Real-World ASP.NET Core production applications (6 entries) for production codebase evidence
- Expand the `_index.yaml` schema to support non-Kata evidence sources
- Publish cross-source analysis triangulating findings across all 4 sources

### Out of scope (moved to EPIC-003)

- Automated architecture discovery skill (`/discover-architecture`)
- Scaling the dataset via automated repo analysis
- Comparative analysis ("how does my architecture compare?")
- ML-based architecture classification

## Outcome

Four evidence sources integrated with 62 cataloged projects across structured YAML catalogs:

| Source | Projects | What it provides |
|--------|----------|------------------|
| TheKataLog | 34 placing teams | Competition submissions with ADRs, C4 diagrams, feasibility analyses |
| AOSA | 13 production systems | Detailed architecture narratives from system creators (NGINX, Git, Selenium, etc.) |
| ReferenceArchitectures | 9 implementations | Working, deployable code for canonical patterns (eShop, modular monolith, clean arch) |
| RealWorldASPNET | 6 production apps | Production codebases (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex) |

Cross-source analysis published in `docs/reference-library/evidence/cross-source-reference.md` and `cross-source-analysis.md`.

## Prior Art

This epic was adapted from Phase 1 of the [Dataset Expansion & Architecture Discovery Skill proposal](../../proposals/dataset-expansion-and-discovery-skill.md). Phases 2-4 (discovery skill, scaling, comparative analysis) have been split into [EPIC-003](../Complete/(EPIC-003)-Architecture-Discovery-and-Scaling/(EPIC-003)-Architecture-Discovery-and-Scaling.md).

## Child Specs

None — this epic was completed through direct data integration work without requiring Agent Specs.

## Key Dependencies

None. EPIC-002 (Architecture Advisor Skill) and EPIC-003 (Architecture Discovery and Scaling) both build on this epic's expanded evidence base.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-03 | 6883447 | Adapted from dataset-expansion-and-discovery-skill.md proposal |
| Complete | 2026-03-03 | f0ae265 | All 4 evidence sources integrated; rescoped — discovery/scaling work moved to EPIC-003 |
