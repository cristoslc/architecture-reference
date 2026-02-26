# Architecture Kata Reference Library

> An evidence-based guide to software architecture decisions, derived from 78 team submissions across 11 seasons of O'Reilly Architecture Katas (Fall 2020 -- Winter 2025).

## What This Is

This is a structured reference library that maps problem characteristics to proven architectural solutions. Every claim is grounded in data from 78 real competition submissions, scored by placement (1st = 4 pts, 2nd = 3 pts, 3rd = 2 pts, Runner-up = 1 pt). Instead of relying on opinion or convention, you can look up what actually worked -- and what did not -- across 11 distinct kata challenges spanning healthcare, logistics, civic tech, travel, IoT, AI, and more.

The library is organized into three layers: **problem spaces** (classifying the challenges), **solution spaces** (cataloging the architectural approaches), and an **evidence base** (team-level data backing every finding).

## Quick Start

**"I'm starting a new architecture kata"** -- Start with the [Decision Navigator](decision-navigator.md), then check the [Kata Checklist](../templates/kata-checklist.md)

**"I need to choose an architecture style"** -- Read the [Solution Spaces](solution-spaces.md) scoreboard, then dive into [Evidence by Style](evidence/by-architecture-style.md)

**"My problem looks like X"** -- Find similar problems in [Problem Spaces](problem-spaces.md), then check the [Problem-Solution Matrix](problem-solution-matrix.md)

**"I want to see how others solved a similar kata"** -- Browse the [Challenge Analyses](../analysis/challenges/)

**"I want to add fitness functions to my architecture"** -- Read the [Fitness Functions Guide](../templates/fitness-functions-guide.md), then use the template in [Feasibility Guide](../templates/feasibility-guide.md) Section 3

**"I want templates and best practices"** -- See the [Templates](../templates/) directory

## Library Structure

### Core Reference

| Document | What It Contains | When to Use |
|----------|-----------------|-------------|
| [Problem Spaces](problem-spaces.md) | 11 challenges classified across 10 dimensions (domain type, scale, budget, compliance, integration complexity, real-time needs, edge/offline, AI/ML, greenfield/brownfield, key tension) | Identify which past challenges match your situation |
| [Solution Spaces](solution-spaces.md) | 12 architecture styles with placement-weighted scores | Compare architectural approaches with evidence |
| [Problem-Solution Matrix](problem-solution-matrix.md) | Mappings from problem dimensions to best solutions | Look up "given X, what works best?" |
| [Decision Navigator](decision-navigator.md) | Step-by-step questionnaire leading to recommendations | Get personalized architecture guidance |

### Evidence Base

| Document | What It Contains |
|----------|-----------------|
| [By Architecture Style](evidence/by-architecture-style.md) | Detailed evidence for each of 7 ranked styles with per-team tables, technology stacks, and pairing patterns |
| [By Quality Attribute](evidence/by-quality-attribute.md) | 10 quality attributes ranked by correlation with placement, with per-challenge breakdowns |

### Supporting Materials

| Directory | Contents |
|-----------|----------|
| [Challenge Analyses](../analysis/challenges/) | 11 comparative analyses (one per kata challenge): Farmacy Food, Sysops Squad, Farmacy Family, Spotlight Platform, Hey Blue!, Wildlife Watcher, Road Warrior, MonitorMe, ShopWise AI, ClearView, Certifiable Inc. |
| [Cross-Cutting Analysis](../analysis/cross-cutting.md) | Statistical patterns across all 78 teams: style vs. placement, ADR discipline, documentation completeness, team size, quality attributes, the "winning formula" scorecard |
| [Templates](../templates/) | ADR guide, C4 guide, feasibility guide, fitness functions guide, architecture selection guide, kata checklist |

### Raw Data

| Directory | Contents |
|-----------|----------|
| [Team Catalogs](../catalog/) | 78 YAML files with structured metadata per team (architecture styles, ADR counts, quality attributes, documentation artifacts, placement) |
| [Master Index](../catalog/_index.yaml) | Aggregated index of all seasons, challenges, teams, and style frequencies |
| [Evidence Pool](../../evidence-pool/TheKataLog/) | 78 team submission folders organized by `<year>-<kata challenge>/<team>/`, sourced from the [TheKataLog](https://github.com/TheKataLog) GitHub organization |

## Key Findings (Summary)

The following are the most striking patterns from the cross-cutting analysis and solution space data:

1. **Modular Monolith has the highest per-team success rate.** Despite being used by only 6 of 78 teams, it averages a 3.00 placement score (out of 4.0). All three first-place Modular Monolith teams won their competitions outright. The "start simple, evolve later" approach resonates with judges.

2. **Feasibility analysis is the strongest single predictor of placement.** Teams with feasibility analysis are 4.5x more likely to place in the top 2 than runners-up (50% vs. 11%). Yet 75.6% of all teams skip it entirely -- making it the single largest opportunity gap.

3. **ADR discipline separates winners from the pack.** First-place teams average 15.0 ADRs, nearly double the runner-up average of 8.5. Eight of 11 winners (73%) have 12 or more ADRs. Two teams with zero ADRs never placed above 3rd.

4. **Event-Driven is necessary but not sufficient.** It is the most-used style (47 of 78 teams, 60%) and accounts for 9 of 11 first-place wins. But 50% of runners-up also use it. The differentiator is pairing it with complementary patterns, thorough ADRs, and feasibility analysis.

5. **The "Scalability Trap" is real.** Scalability is the most commonly cited quality attribute (48 teams), but first-place winners cite it *less* often (55%) than runners-up (68%). Over-indexing on scalability at the expense of cost, data integrity, and simplicity appears to be a negative signal.

6. **Hybrid/evolutionary approaches win.** Of the 11 first-place winners, 8 (73%) list two or more architecture styles, compared to 52% of runners-up. Judges reward teams that propose phased evolution from MVP to target state.

7. **Team size has zero correlation with placement.** Average team sizes are nearly identical across all placements (3.6-3.9 members). Three-person teams won four first-place finishes.

8. **Fitness functions are the most underutilized winning practice.** Only ~17% of teams include fitness functions, yet 55% of first-place winners do. Teams that define falsifiable, quantitative targets for quality attributes -- the architectural equivalent of TDD -- gain a disproportionate competitive advantage. See the [Fitness Functions Guide](../templates/fitness-functions-guide.md) for patterns and evidence.

## Dataset

| Metric | Value |
|--------|-------|
| Total teams | 78 |
| Total seasons | 11 (Fall 2020 -- Winter 2025) |
| Total kata challenges | 11 |
| 1st-place finishers | 11 |
| 2nd-place finishers | 11 |
| 3rd-place finishers | 12 (including one tie) |
| Runners-up | 44 |
| Total ADRs analyzed | ~780 |
| Architecture styles identified | 12 canonical categories |
| Problem dimensions classified | 10 |
| Quality attributes tracked | 10+ |

## Methodology

**Data collection.** Each of the 78 team submissions was cataloged into a structured YAML file capturing: team name, season, challenge, placement, architecture styles, ADR count, quality attributes prioritized, documentation artifacts present (C4 diagrams, deployment views, sequence diagrams, feasibility analysis, video presentation), technology stack, and team size where available.

**Normalization.** Architecture style names were normalized across inconsistent self-reported labels (e.g., "event-driven", "Event-Driven Architecture", and "Event-Driven" all map to **Event-Driven**). Quality attributes were similarly normalized. Problem dimensions were classified by the analyst based on the challenge descriptions and team submissions.

**Scoring.** Placement scores use a simple ordinal scale (1st = 4, 2nd = 3, 3rd = 2, Runner-up = 1). Weighted scores aggregate placement points across all teams using a given style. Average placement scores normalize for popularity.

**Limitations.**
- **Sample size**: 78 teams across 11 challenges is meaningful but not statistically large. Some styles have very small samples (Modular Monolith: n=6, Multi-Agent: n=3). Findings for low-n styles should be treated as suggestive, not conclusive.
- **Judge subjectivity**: Evaluation criteria and judge panels vary across seasons. A first-place win in one season may not be directly comparable to another.
- **Self-reported data**: Architecture styles and quality attributes are extracted from team submissions, which may not reflect the actual implemented architecture. Teams may over-claim or under-document their choices.
- **Correlation vs. causation**: Winning teams may succeed for many reasons beyond their architectural style choice. ADR count, for example, may be a proxy for team rigor rather than a direct cause of success.
- **Survivorship bias**: Only submitted solutions are analyzed. Teams that dropped out or never formed are not represented.

## How to Contribute

This is a living library. New kata seasons can be added by following the established process:

1. **Create a YAML catalog file** for each team in the new season, following the schema used in `docs/catalog/`. Each file captures team name, placement, architecture styles, ADR count, quality attributes, and documentation artifacts.
2. **Update the master index** at `docs/catalog/_index.yaml` with the new season, teams, and challenge metadata.
3. **Write a challenge analysis** in `docs/analysis/challenges/` following the comparative format used by the existing 11 analyses.
4. **Re-derive the cross-cutting statistics** in `docs/analysis/cross-cutting.md` to incorporate the new data.
5. **Update the reference library documents** (problem-spaces.md, solution-spaces.md, and evidence files) to reflect any new styles, quality attributes, or problem dimensions introduced by the new challenge.

The YAML catalog format is the single source of truth. All analysis documents and reference library content are derived from it.
