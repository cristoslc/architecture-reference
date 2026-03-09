---
title: "Discovered-First Evidence Hierarchy"
artifact: ADR-004
status: Adopted
author: cristos
created: 2026-03-09
last-updated: 2026-03-09
linked-epics:
  - EPIC-007
  - EPIC-012
linked-specs:
  - SPEC-018
  - SPEC-023
depends-on:
  - ADR-001
  - ADR-002
---

# Discovered-First Evidence Hierarchy

## Context

The reference library draws from five evidence sources: Discovered (142 production repos), AOSA (12 production systems), RealWorldASPNET (5 production systems), KataLog (78 competition teams), and RefArch (8 reference implementations + 42 Discovered reference entries).

Prior to this decision, the documents treated all five sources as co-equal under a "Five-Source Triangulation Model." The Combined Weighted Scoreboard gave Discovered zero points, assigned KataLog placements 1-4 points each, and AOSA/RealWorld 20 points each. Despite per-entry weighting favoring production systems, KataLog dominated the combined score by volume (78 teams generating dense placement data vs. 17 production systems). Discovered — the largest evidence pool and the only one derived from actual production codebases at scale — was footnoted as "breadth context, not weighted."

This inversion meant the reference library's primary rankings reflected what competition teams proposed in never-built designs, not what practitioners actually ship. EPIC-007 identified and corrected this structural problem.

## Decision

**Real-world production evidence is the only primary evidence.** All reference library documents follow this hierarchy:

### Tier 1 — Primary Evidence (production code)

| Source | Role | Basis |
|--------|------|-------|
| **Discovered production repos** (142 entries) | Statistical baseline — frequency rankings, co-occurrence patterns, domain distributions | Largest, most linguistically diverse corpus of real production code. Deep-analysis validated (ADR-002). Zero Indeterminate. |
| **AOSA production systems** (12 systems) | Narrative depth — architectural reasoning from system creators | Published case studies of systems operating at scale (NGINX, HDFS, ZeroMQ). Highest per-system authority. |
| **RealWorldASPNET production systems** (5 systems) | Narrative depth — production application evidence | Real deployed applications with documented architecture. .NET-ecosystem only. |

### Tier 2 — Annotation and Explanation (not primary evidence)

| Source | Role | Value | Limitation |
|--------|------|-------|------------|
| **KataLog competition** (78 teams) | Qualitative reasoning — explains *why* teams chose patterns | Judge commentary, team ADR documentation, cost projections, comparative reasoning across teams solving the same problem | Never-built designs. Teams optimize for judges, not production. Only 11 challenge domains. |
| **RefArch reference implementations** (8 + 42 entries) | Structural examples — shows *how* to implement a pattern | Concrete code examples of recommended patterns | Teaching code. Not representative of production constraints. |

### Application rules

1. **Every ranking table and statistical claim leads with Discovered production data.** Discovered frequency is the primary scoreboard. Other sources annotate and explain.
2. **AOSA/RealWorld validates and enriches** the Discovered statistical patterns with deep production narratives. These sources are co-primary with Discovered for production evidence.
3. **KataLog evidence is labeled as qualitative annotation** under headers like "Why This Works: Team Reasoning" or "Qualitative Evidence: Competition Insights." KataLog placement scores, win rates, and team tables appear in clearly labeled secondary sections, never in primary rankings.
4. **RefArch entries are annotation examples** illustrating how to implement patterns. They carry zero weight in frequency rankings (per ADR-001).
5. **Detection bias must be disclosed** in every document: Discovered statistics are derived from deep-analysis source code inspection. Styles and QAs that leave strong code signals are more reliably detected. KataLog competition evidence fills this specific gap for architectural decisions invisible in code (performance tuning, testability strategies, interoperability contracts).

## Alternatives Considered

1. **Keep the Five-Source Triangulation Model with equal weighting.** Rejected because it treats never-built competition designs as co-equal with 142 production codebases. Source count is not evidence strength.

2. **Weight Discovered in the Combined Weighted Scoreboard (20 pts per repo).** Rejected because it would make the scoreboard a Discovered-only ranking by sheer volume (142 repos x 20 pts = 2840 pts vs. KataLog's ~200 pts total). The right solution is to make Discovered the primary ranking directly, not to fold it into a scoring formula designed for smaller sources.

3. **Drop KataLog entirely.** Rejected because KataLog's qualitative evidence (ADR reasoning, cost projections, judge feedback) is genuinely valuable and unavailable from any other source. The problem is hierarchy, not inclusion.

## Consequences

**Positive:**
- Reference library rankings reflect what production systems actually use, not what competition teams propose
- KataLog's genuine strengths (qualitative reasoning, cost analysis) are preserved and properly framed
- Detection bias is honestly disclosed rather than hidden behind multi-source averaging
- Consistent with ADR-001 (production-only frequency rankings) and ADR-002 (deep-analysis as sole classification source)

**Negative:**
- Styles popular in competition but rare in production (Microservices, Serverless, DDD) receive less prominence, which may surprise practitioners familiar with conference discourse
- Detection bias in Discovered means some architecturally significant patterns (performance optimization, testability strategies) are underrepresented in primary rankings

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Adopted | 2026-03-09 | — | Codifies decision from EPIC-007; supersedes implicit five-source-equal model |
