---
title: "Evidence-Based Architecture Decision Platform"
artifact: VISION-001
status: Active
author: cristos
created: 2026-03-03
last-updated: 2026-03-06
depends-on: []
---

# Evidence-Based Architecture Decision Platform

## Target Audience

Software architects, engineering leaders, and development teams making architecture decisions — whether in competition (O'Reilly Architecture Katas) or production. This includes both humans consulting the reference library directly and AI agents consuming it programmatically through the architecture-advisor skill.

## Value Proposition

Replace opinion-driven architecture selection with evidence-grounded guidance. By cataloging what actually worked across hundreds of real architecture projects — competition submissions, production open-source systems, cloud provider reference architectures, and academic datasets — and making that evidence searchable, comparable, and actionable through both human-readable docs and AI-consumable tools, architects can make confident decisions backed by data rather than convention or hype.

Architecture patterns exist at two scales: **application-level** (how a single deployable system is organized) and **ecosystem/platform-level** (how independently-developed repos compose into a coherent system). The evidence library and advisor skill must serve both contexts, recognizing that different architectural concerns, trade-offs, and style distributions apply at each scale.

## Success Metrics

- Evidence base covers 200+ cataloged projects across 4+ complementary sources (up from 78 from a single source)
- Architecture advisor skill installable and functional in external repos via remote-skill-manager
- All architecture styles in the taxonomy have statistically meaningful sample sizes (n >= 10)
- Cross-source analysis published, triangulating findings across competition, production, and reference sources
- Ecosystem-level entries captured alongside single-repo entries, with clear statistical separation
- Advisor skill distinguishes platform-centric from application-centric contexts when providing guidance

## Non-Goals

- Not a code linter or static analysis tool — CodeScene and SonarQube serve that purpose
- Not a prescriptive enforcement engine — the library classifies what IS, the user decides what SHOULD BE
- Not a replacement for architectural judgment — evidence informs, it does not dictate
- Not a project management or execution tracking system
- Not a catalog of library or framework architectures — the evidence base is scoped to platforms/ecosystems and applications with deployable architectures. Libraries and frameworks may be added in a future scope expansion.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Active | 2026-03-03 | 6883447 | Created from existing project direction; skipped Draft as vision is well-established |
