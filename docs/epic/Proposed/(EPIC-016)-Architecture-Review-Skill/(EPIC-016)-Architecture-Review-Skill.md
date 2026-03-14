---
title: "Architecture Review Skill"
artifact: EPIC-016
status: Proposed
author: cristos
created: 2026-03-14
last-updated: 2026-03-14
parent-vision: VISION-002
success-criteria:
  - Installable Claude skill that produces an architecture drift report from any codebase without prior configuration
  - Report includes annotated dependency/module graphs (mermaid) showing where violations occur
  - Workflow orchestrates discover-architecture → baseline lookup → drift analysis → report generation without manual intervention
  - Report is actionable — a reviewer unfamiliar with the codebase can use it as a starting point for investigation
depends-on:
  - EPIC-015
addresses: []
evidence-pool: ""
---

# Architecture Review Skill

## Goal / Objective

Package the drift detection capability as an installable `architecture-review` Claude skill. The skill orchestrates the full review workflow: invoke discover-architecture for classification, load the relevant constraint baselines, run drift analysis, and generate an annotated markdown + mermaid drift report. This is the user-facing surface of VISION-002.

## Scope Boundaries

**In scope:**
- Skill packaging (SKILL.md, installation, configuration)
- Workflow orchestration: discover-architecture → baselines → drift engine → report
- Report format: markdown with mermaid dependency/module graphs, annotated findings, severity summary
- Handling of multi-style repos (repos with 2+ detected architecture styles)
- User-declared architecture override (optional input to compare against instead of discovered style)

**Out of scope:**
- Constraint baseline computation (EPIC-014)
- Drift detection logic (EPIC-015)
- Continuous monitoring or CI/CD integration (VISION-002 non-goal)
- Automated remediation (VISION-002 non-goal)
- Static analysis tool orchestration (future concern)

## Child Specs

_Updated as Agent Specs are created under this epic._

## Key Dependencies

- EPIC-015 (drift detection engine) must be complete — the skill orchestrates it
- discover-architecture skill must be available as a dependency
- Evidence base must be accessible for baseline lookup

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-14 | b88a076c | Initial creation |
