---
title: "Architecture Review and Drift Detection"
artifact: VISION-002
status: Active
product-type: personal
author: cristos
created: 2026-03-13
last-updated: 2026-03-13
depends-on: []
evidence-pool: ""
---

# Architecture Review and Drift Detection

## Target Audience

Developers and consultants examining unfamiliar codebases — whether onboarding onto a new project, conducting an architecture review for a client, or evaluating a repo for acquisition or integration. The operator may or may not own the codebase; they need to understand its structural health quickly.

## Value Proposition

When you look at a codebase today, you can classify its architecture and compare it to production norms. What you can't do is answer: "does this codebase actually follow the architecture it claims (or appears) to have?" This vision enables a new `architecture-review` skill that audits a repo's structural consistency — finding where the code diverges from its intended, discovered, or statistically expected architecture — and surfaces those findings as an annotated drift report.

## Problem Statement

Architecture classification tells you *what* a codebase is. It doesn't tell you whether it's *coherent*. A repo can be classified as Layered + Microkernel while containing modules that violate layering constraints, plugins that bypass the kernel API, or shared state mechanisms (flat files, S3 buckets, databases used as message buses) that contradict the declared architecture entirely. These inconsistencies are invisible to style classification but are exactly what matters during a review.

No existing tool covers this gap:

- **Rule-based structural tools** (ArchUnit, Dependency-Cruiser, jqAssistant) require the reviewer to write rules upfront — they enforce a known architecture, they don't discover violations in an unknown one.
- **Commercial platforms** (Sigrid, CodeScene) provide opaque scores without evidence-grounded baselines or LLM-powered judgment.
- **Static analysis** catches code-level issues but not architectural misalignment.

The missing capability is *architecture-aware structural analysis*: examining a codebase through the lens of its detected (or declared) architecture styles and flagging where reality diverges from intent.

## Existing Landscape

| Tool / Approach | What it does well | Where it falls short |
|----------------|-------------------|---------------------|
| ArchUnit / Dependency-Cruiser | Enforces explicit dependency rules | Must know the rules before you start; no discovery |
| jqAssistant / Neo4j | Graph-based structural queries | Powerful but requires setup and query expertise |
| CodeScene | Git-history behavioral analysis | Finds hotspots, not architectural misalignment |
| Sigrid (SIG) | Maintainability scoring | Opaque methodology, no evidence-grounded baselines |
| discover-architecture (ours) | LLM-powered style classification | Classifies but doesn't audit consistency |
| architecture-advisor (ours) | Evidence-based architecture guidance | Recommends but doesn't inspect for drift |

## Build vs. Buy

**Tier 3: Build from scratch** — no existing tool combines LLM-powered structural judgment with a statistical evidence base for baseline comparison. However, the build surface is smaller than it appears:

- `discover-architecture` already performs deep repo examination (entrypoints, module boundaries, communication patterns, deployment configs). The review skill extends this from "classify" to "audit."
- The evidence base (142 production repos, 11 ecosystems) already provides statistical norms for what's typical per style and domain.
- Static analysis tools (ArchUnit, Dependency-Cruiser) can be incorporated as optional data sources rather than rebuilt — the skill orchestrates them, it doesn't replace them.

The novel work is the *drift analysis engine*: comparing discovered structure against baselines and producing actionable findings.

## Maintenance Budget

Low-to-moderate. The skill should:

- Leverage discover-architecture's repo examination rather than reimplementing it
- Use the existing evidence base for statistical baselines (no separate data pipeline)
- Produce static reports (markdown + mermaid diagrams), not a running service
- Incorporate static analysis tools opportunistically (if installed), not as hard dependencies

Ongoing maintenance is primarily keeping the drift heuristics aligned as the evidence base and style taxonomy evolve.

## Success Metrics

1. The `architecture-review` skill can examine an unfamiliar repo and produce a drift report identifying structural inconsistencies against its detected architecture, without requiring the reviewer to write rules or declare the intended architecture upfront.
2. Drift findings are grounded in evidence — each finding cites either a violated architectural constraint (from the detected style), a statistical norm (from the evidence base), or a user-declared intention.
3. The report includes annotated dependency or module graphs showing where violations occur, not just a text list.
4. False positive rate is low enough that a reviewer trusts the report as a starting point for investigation, not a source of noise.

## Non-Goals

- **Continuous monitoring**: This is a point-in-time review skill, not a CI/CD gate or dashboard. Ongoing drift monitoring is a separate concern.
- **Automated remediation**: The skill identifies drift; it does not refactor code or generate migration plans.
- **Language-specific deep analysis**: The skill operates at the architectural level (modules, boundaries, communication patterns), not at the code-quality level (linting, type safety, test coverage).
- **Replacing static analysis tools**: ArchUnit, Dependency-Cruiser, etc. remain valuable for rule enforcement. This skill operates at a higher level of abstraction and may incorporate their output.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-13 | — | Initial creation from brainstorming session |
| Active | 2026-03-13 | b0af60d2 | Approved — vision aligns with project direction |
