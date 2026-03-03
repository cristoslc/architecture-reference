---
title: "Architecture Discovery and Scaling"
artifact: EPIC-003
status: Proposed
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-vision: VISION-001
success-criteria:
  - /discover-architecture skill produces valid YAML catalog entries for local repos
  - Discovery calibrated against known-architecture reference repos with >= 80% classification accuracy
  - 200+ cataloged projects in the evidence base (up from 62)
  - Comparative analysis available ("how does my architecture compare to similar projects?")
depends-on: []
---

# Architecture Discovery and Scaling

## Goal / Objective

Build automated tooling to discover and classify architecture patterns from source code repositories, then use it to scale the evidence base from 62 manually cataloged projects to 200+. This enables the reference library to provide statistically significant findings across all architecture styles and supports a new use case: "How does my repo's architecture compare to best practices?"

## Scope Boundaries

### In scope

- **Phase 1 — Build the discovery skill (MVP):** Implement `/discover-architecture` for local repos. Focus on structural pattern detection (directory layout, dependency graph, config files). Output YAML catalog entries + markdown summaries. Calibrate against known-architecture repos.
- **Phase 2 — Scale the dataset:** Run discovery against top open-source repos (by GitHub stars, by domain). Add evolutionary analysis (git history mining via code-maat patterns). Correlate with production metrics where available (GitHub issues, incident data).
- **Phase 3 — Comparative analysis:** "How does my architecture compare to successful repos in this domain?" Statistical analysis across the expanded dataset (n=200+ instead of n=62).

### Out of scope

- ML-based architecture classification (heuristics + LLM, not trained models)
- Code quality / linting functionality (not competing with CodeScene or SonarQube)
- Prescriptive architecture enforcement
- Community contribution pipeline (future work beyond Phase 2)

## Prior Art

This epic continues Phases 2-4 of the [Dataset Expansion & Architecture Discovery Skill proposal](../../proposals/dataset-expansion-and-discovery-skill.md). Phase 1 (manual data enrichment) was completed as [EPIC-001](../\(EPIC-001\)-Dataset-Expansion-and-Evidence-Enrichment/\(EPIC-001\)-Dataset-Expansion-and-Evidence-Enrichment.md).

### Discovery skill design (from proposal)

The `/discover-architecture` skill would analyze a repository and produce a structured YAML catalog entry:

- **Signal extraction:** Module boundaries, dependency graphs, layer separation, messaging infrastructure, API gateway presence, event schemas, container orchestration, IaC patterns, CI/CD pipeline, ADR presence, test coverage structure, monitoring/observability, documentation completeness
- **Classification output:** Primary style, secondary styles, quality attributes, maturity signals, confidence score
- **Scope:** Top 5 ecosystems (JS/TS, Python, Java, Go, .NET)
- **Approach:** Heuristic-based signal extraction + LLM-assisted classification (not ML models)

### Key data sources for scaling

| Tier | Source | Value |
|------|--------|-------|
| 1 | chanakaudaya/solution-architecture-patterns | Industry-vertical patterns (telecom, healthcare, retail) |
| 2 | awesome-software-architecture curated lists | Cross-referencing material organized by pattern |
| 3 | Microservices Project List (378 real-world repos) | Academic, peer-reviewed production microservice data |
| 3 | Kaggle architecture styles dataset | Statistical/data-mining classification data |
| 3 | Software Heritage Graph Dataset | 16B+ files from 250M+ projects |

### Architecture mining tools

| Tool | What it does |
|------|--------------|
| code-maat | VCS mining: evolutionary coupling, hotspots, social patterns from git history |
| Code2DFD | Generates data flow diagrams from source code |
| EventCatalog | Architecture catalog for distributed systems (domains, services, events, schemas) |
| Architecture Recovery Tools (arXiv 2024) | Comparative study of 13 static analysis architecture recovery tools |

## Child Specs

_Updated as Agent Specs are created under this epic._

None yet.

## Key Dependencies

No blocking dependencies. EPIC-001 (Dataset Expansion) provides the evidence base and YAML schema this epic builds on — that work is complete.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-03 | f0ae265 | Split from EPIC-001; covers Phases 2-4 of original dataset expansion proposal |
