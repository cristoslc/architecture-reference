---
title: "Dataset Expansion and Evidence Enrichment"
artifact: EPIC-001
status: Proposed
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-vision: VISION-001
success-criteria:
  - 4+ evidence sources integrated with structured YAML catalogs
  - 200+ cataloged projects (up from 78)
  - _index.yaml schema supports non-Kata evidence sources
  - Cross-source analysis published, triangulating findings across competition, production, and reference sources
  - Per-style sample sizes reach n >= 10 for all 12 architecture styles
depends-on: []
---

# Dataset Expansion and Evidence Enrichment

## Goal / Objective

Expand the evidence base from 78 O'Reilly Kata submissions to 200+ projects from multiple complementary sources — addressing the current dataset's single-source bias, small sample sizes, and lack of production validation. The expanded dataset will make the reference library's statistical findings more robust and its recommendations more credible.

## Scope Boundaries

### In scope

- **Phase 1 — Enrich existing dataset (no new tooling):** Incorporate AOSA book architectures, curated reference implementation repos, and cloud provider patterns (Azure, GCP, AWS) as new evidence sources alongside TheKataLog. Expand the `_index.yaml` schema to support non-Kata evidence sources. Cross-reference cloud provider patterns against existing style taxonomy.
- **Phase 2 — Build the discovery skill (MVP):** Implement `/discover-architecture` for local repos. Focus on structural pattern detection (directory layout, dependency graph, config files). Output YAML catalog entries + markdown summaries. Calibrate against known-architecture repos.
- **Phase 3 — Scale the dataset:** Run discovery against top open-source repos (by GitHub stars, by domain). Add evolutionary analysis (git history mining). Correlate with production metrics where available.
- **Phase 4 — Comparative analysis:** "How does my architecture compare to successful repos in this domain?" Statistical analysis across the expanded dataset.

### Out of scope

- ML-based architecture classification (heuristics + LLM, not trained models)
- Code quality / linting functionality (not competing with CodeScene or SonarQube)
- Prescriptive architecture enforcement
- Community contribution pipeline (future work beyond Phase 3)

## Prior Art

This epic is adapted from the [Dataset Expansion & Architecture Discovery Skill proposal](../../proposals/dataset-expansion-and-discovery-skill.md), which identifies specific data sources, provides a tiered assessment of value, and proposes the `/discover-architecture` skill workflow.

### Key data sources identified

| Tier | Source | Value |
|------|--------|-------|
| 1 | AOSA books (~50 production systems) | Production architecture narratives from system creators |
| 1 | Azure/GCP/AWS Architecture Centers | Production-tested reference architectures with code |
| 1 | chanakaudaya/solution-architecture-patterns | Industry-vertical patterns (telecom, healthcare, retail) |
| 2 | awesome-software-architecture curated lists | Cross-referencing material organized by pattern |
| 3 | Microservices Project List (378 real-world repos) | Academic, peer-reviewed production microservice data |
| 3 | Kaggle architecture styles dataset | Statistical/data-mining classification data |
| 4 | Reference implementations (eShop, modular-monolith-with-ddd, etc.) | Working, deployable code for canonical patterns |

## Child Specs

_Updated as Agent Specs are created under this epic._

None yet.

## Key Dependencies

No blocking dependencies. This epic can begin immediately — Phase 1 requires no new tooling and uses only the existing YAML catalog schema (with extensions).

EPIC-002 (Architecture Advisor Skill) benefits from this epic's expanded evidence base but does not block on it.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-03 | 6883447 | Adapted from dataset-expansion-and-discovery-skill.md proposal |
