---
name: architecture-advisor
description: Research how real architecture teams solved problems using evidence from 103 projects across four sources — 34 placing O'Reilly Architecture Kata teams, 12 AOSA production systems, 5 production .NET apps, and 8 reference implementations. Use when the user asks about architecture style selection, pattern trade-offs, quality attributes, ADR examples, kata preparation, or feasibility analysis. Triggers on "architecture patterns", "which architecture style", "how did teams handle", "kata preparation", "architecture evidence", "ADR examples", "feasibility analysis", "fitness functions".
license: MIT
allowed-tools: Bash, Read, Grep, Glob, Task
metadata:
  short-description: Evidence-based architecture research from 103 real-world projects
  version: 1.0.0
  source-repo: https://github.com/cristoslc/architecture-reference-repo
---

# Architecture Advisor

Research how real architecture teams solved problems, using evidence from 103 projects across four complementary sources.

## What This Is

The **architecture-reference-repo** is an evidence-based reference library containing:

- **34 placing team submissions** from 11 seasons of O'Reilly Architecture Katas (Fall 2020 -- Winter 2025) with full documentation (ADRs, C4 diagrams, deployment views, sequence diagrams, feasibility analyses, video transcripts)
- **12 production open-source systems** from The Architecture of Open Source Applications (AOSA), described by their creators
- **5 production .NET applications** (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex)
- **8 curated reference implementations** with working, deployable code
- **66 structured YAML catalog files** with metadata per project (architecture styles, quality attributes, technology stacks, key patterns)
- **A reference library** with placement-weighted scores for 12 architecture styles, 10 problem dimensions, and a decision navigator
- **11 comparative analyses** (one per kata challenge) and cross-source triangulation

Kata scoring uses a placement-weighted system: 1st = 4 pts, 2nd = 3 pts, 3rd = 2 pts.

## Locating the Data

Look for the architecture-reference-repo data in this order:

1. **Relative to this skill**: `../../evidence-analysis/` and `../../docs/` (when skill is at `skills/architecture-advisor/` within the repo)
2. **Current working directory**: Check if `evidence-analysis/TheKataLog/docs/catalog/_index.yaml` exists in the working directory
3. **Common locations**: `~/src/architecture-reference-repo/`, `~/architecture-reference-repo/`
4. **Ask the user**: If not found, ask the user for the path to their local clone of `architecture-reference-repo`

If the full repo is unavailable, you can still answer questions using the key findings and decision logic embedded in this file (see "Offline Reference" below).

## What To Do

The user gives you an architecture problem or question. Research the evidence base and return data-driven recommendations with citations.

### Step 1: Classify the question

Map the user's problem to one or more of these categories:

| Category | What to search | Key files |
|----------|---------------|-----------|
| **Style selection** | Which architecture style fits? | `docs/reference-library/solution-spaces.md`, `docs/reference-library/problem-solution-matrix.md` |
| **Pattern research** | How did teams implement a specific pattern? | `evidence-analysis/*/docs/catalog/*.yaml` (filter by style), then `evidence-pool/TheKataLog/<year>-<challenge>/<team>/` |
| **Quality attributes** | Trade-offs between quality attributes | `docs/reference-library/evidence/by-quality-attribute.md` |
| **ADR examples** | Real ADR examples for a decision type | `evidence-analysis/TheKataLog/docs/catalog/*.yaml` (filter by `adr_topics`), then team submission folders |
| **Kata preparation** | Starting a new architecture kata | `docs/templates/kata-checklist.md`, `docs/reference-library/decision-navigator.md` |
| **Feasibility analysis** | What a feasibility analysis looks like | `docs/templates/feasibility-guide.md`, teams with `has_feasibility_analysis: true` |
| **Fitness functions** | Defining quantitative architecture tests | `docs/templates/fitness-functions-guide.md` |
| **Challenge comparison** | How teams approached a specific kata | `evidence-analysis/TheKataLog/docs/analysis/challenges/<challenge-name>.md` |
| **Cross-source validation** | Does a pattern hold across competition and production? | `docs/reference-library/evidence/cross-source-reference.md`, `docs/reference-library/evidence/cross-source-analysis.md` |

### Step 2: Search structured data first

Start with the YAML catalogs — they are small, structured, and fast to scan.

**Key files to search:**

- `evidence-analysis/TheKataLog/docs/catalog/_index.yaml` — Master index of all 11 seasons, 34 placing teams, and style frequencies
- `evidence-analysis/TheKataLog/docs/catalog/<team-name>.yaml` — Per-team metadata including:
  - `architecture_styles` — List of styles used
  - `placement` / `placement_numeric` — Competition result (1st/2nd/3rd)
  - `quality_attributes_prioritized` — Quality attributes the team emphasized
  - `adr_count` / `adr_topics` — Number and topics of ADRs
  - `has_feasibility_analysis`, `has_c4_diagrams`, `has_deployment_view`, `has_sequence_diagrams` — Documentation artifacts present
  - `key_technologies` — Technology stack
  - `notable_strengths` / `notable_gaps` — Analyst assessments
  - `one_line_summary` — Quick team profile
- `evidence-analysis/AOSA/docs/catalog/_index.yaml` — 12 production open-source systems
- `evidence-analysis/RealWorldASPNET/docs/catalog/_index.yaml` — 5 production .NET apps
- `evidence-analysis/ReferenceArchitectures/docs/catalog/_index.yaml` — 8 reference implementations

**Example queries:**

- Find teams using Microservices: `grep -rl "Microservices" evidence-analysis/TheKataLog/docs/catalog/*.yaml`
- Find first-place teams: `grep -rl "placement: \"1st\"" evidence-analysis/TheKataLog/docs/catalog/*.yaml`
- Find teams with feasibility analysis: `grep -rl "has_feasibility_analysis: true" evidence-analysis/TheKataLog/docs/catalog/*.yaml`
- Cross-reference production systems: `grep -rl "event.driven" evidence-analysis/AOSA/docs/catalog/*.yaml`

### Step 3: Consult the reference library

| Document | Use When |
|----------|----------|
| `docs/reference-library/solution-spaces.md` | Comparing architecture styles by placement-weighted scores |
| `docs/reference-library/problem-spaces.md` | Classifying a problem across 10 dimensions |
| `docs/reference-library/problem-solution-matrix.md` | Mapping problem dimensions to proven solutions |
| `docs/reference-library/decision-navigator.md` | Walking through a step-by-step architecture decision |
| `docs/reference-library/evidence/by-architecture-style.md` | Deep evidence for 7 ranked styles with per-team tables |
| `docs/reference-library/evidence/by-quality-attribute.md` | 10 quality attributes ranked by correlation with placement |
| `docs/reference-library/evidence/cross-source-reference.md` | Weighted scoreboard across all 4 sources |
| `docs/reference-library/evidence/cross-source-analysis.md` | Triangulation framework and cross-source findings |
| `evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md` | Statistical patterns across all placing teams |

### Step 4: Dive into evidence

For deep research, read actual team submissions in `evidence-pool/TheKataLog/`. Submissions are organized as `<year>-<kata-challenge>/<team>/` and may contain:

- `README.md` or `submission.md` — Main architecture document
- `ADRs/` or `adr/` — Architecture Decision Records
- `diagrams/` — C4, deployment, sequence diagrams (converted to markdown descriptions)
- `video-transcript.md` — LLM-readable transcript of the team's presentation

For per-source analysis, read:

- `evidence-analysis/AOSA/docs/analysis/source-analysis.md` — Patterns across 12 AOSA projects
- `evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md` — Patterns across 5 .NET apps
- `evidence-analysis/ReferenceArchitectures/docs/analysis/source-analysis.md` — Patterns across 8 reference implementations

Spin up parallel agents to search across multiple team submissions simultaneously for broad research queries.

### Step 5: Synthesize with citations

Every recommendation MUST cite specific evidence:

- **Team name and placement** (e.g., "ArchColider, 1st place Fall 2020")
- **Production system** (e.g., "NGINX (AOSA) uses event-driven architecture for...")
- **Data points** (e.g., "teams with feasibility analysis are 4.5x more likely to place top-2")
- **Sample sizes** (e.g., "Modular Monolith: n=6, avg placement score 3.00")
- **Cross-source confirmation** (e.g., "Event-driven dominance confirmed by both kata results (9/11 winners) and AOSA production systems (7/12)")

Do not make unsupported claims. If the evidence is inconclusive or the sample size is too small, say so.

## Key Files to Search

| Pattern | What It Finds |
|---------|--------------|
| `evidence-analysis/*/docs/catalog/*.yaml` | Structured project metadata across all 4 sources |
| `evidence-analysis/*/docs/catalog/_index.yaml` | Master indexes per source |
| `docs/reference-library/*.md` | Core reference documents (problem spaces, solution spaces, decision navigator) |
| `docs/reference-library/evidence/*.md` | Evidence tables by architecture style, quality attribute, and cross-source |
| `evidence-analysis/TheKataLog/docs/analysis/challenges/*.md` | Per-challenge comparative analyses |
| `evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md` | Cross-cutting statistical patterns |
| `evidence-analysis/*/docs/analysis/*.md` | Per-source analysis documents |
| `docs/templates/*.md` | ADR guide, C4 guide, feasibility guide, fitness functions guide, kata checklist |
| `evidence-pool/TheKataLog/**/README.md` | Team submission documents |
| `evidence-pool/TheKataLog/**/ADRs/*.md` | Individual architecture decision records |

## Offline Reference

When the full repository data is not available, use these key findings to inform recommendations. All data points are derived from the evidence base.

### Architecture style rankings (by placement-weighted score, kata data)

| Rank | Style | Teams | Avg Score | Key Insight |
|------|-------|-------|-----------|-------------|
| 1 | Modular Monolith | 6 | 3.00 | Highest per-team success rate; 100% placed top-3 |
| 2 | Event-Driven | 47 | 2.02 | Most popular; 9 of 11 first-place wins use it |
| 3 | Microservices | 42 | 1.90 | Second most popular; works best when paired with Event-Driven |
| 4 | Service-Based | 17 | 1.76 | Solid middle ground between monolith and microservices |
| 5 | Domain-Driven Design | 16 | 2.13 | Strong when combined with other styles |
| 6 | CQRS | 11 | 2.09 | Effective for complex read/write separation |
| 7 | Space-Based | 5 | 1.80 | Niche but effective for high-throughput scenarios |

### Cross-source validation

Key kata findings confirmed by production systems:

- **Event-Driven dominance**: Kata winners (9/11) + AOSA production systems (7/12) + reference implementations (5/8) all confirm event-driven as the most successful pattern
- **Modular Monolith effectiveness**: Highest kata placement score (3.00) + AOSA production validation (Audacity, Eclipse) + working reference implementation (kgrzybek/modular-monolith-with-ddd)
- **Multi-style composition**: 73% of kata winners use 2+ styles; production systems average 2.3 styles; reference implementations average 2.5 styles

### Winning formula

Teams that place first typically exhibit:
- **2+ architecture styles** (73% of winners vs. 52% of runners-up)
- **15+ ADRs** (winner avg: 15.0 vs. runner-up avg: 8.5)
- **Feasibility analysis** (4.5x more likely to place top-2)
- **Fitness functions** (55% of winners vs. ~17% overall)
- **Phased evolution** (MVP → target state roadmap)

### Top quality attributes by placement correlation

1. **Workflow / Orchestration** — Highest avg placement score
2. **Cost Efficiency** — Strong positive signal (often paired with feasibility analysis)
3. **Data Integrity / Consistency** — Winners prioritize correctness
4. **Evolvability / Extensibility** — Judges reward evolutionary thinking
5. **Interoperability / Integration** — Important in complex ecosystems

### Common pitfall: The Scalability Trap

Scalability is the most commonly cited quality attribute (48 of 78 teams), but first-place winners cite it *less* often (55%) than runners-up (68%). Over-indexing on scalability at the expense of cost, data integrity, and simplicity is a negative signal.

## Version Note

Evidence spans 11 kata seasons (Fall 2020 through Winter 2025), 12 AOSA projects, 5 production .NET apps, and 8 reference implementations. When new evidence is added to the repository, the YAML catalogs and reference library are updated accordingly. Check `evidence-analysis/TheKataLog/docs/catalog/_index.yaml` for the `generated` date to confirm data freshness.
