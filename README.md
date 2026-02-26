# Architecture Reference Repository

An evidence-based knowledge base for software architecture, drawing on four complementary sources: **78 competition submissions** from [O'Reilly Architecture Katas](https://learning.oreilly.com/featured/architectural-katas/) (Fall 2020 -- Winter 2025), **12 production system narratives** from [The Architecture of Open Source Applications](https://aosabook.org/en/) (AOSA), **5 production .NET applications** (RealWorldASPNET), and **8 curated reference implementations** with working, deployable code.

## What This Is

This repository turns real-world architecture data into actionable guidance. Rather than relying on opinion or convention, every recommendation is grounded in evidence from four distinct vantage points:

- **Competition designs** (TheKataLog) -- 78 teams solving 11 kata challenges, with placement-weighted scoring. Shows what judges reward and what patterns correlate with winning.
- **Production narratives** (AOSA) -- architectural descriptions of systems like NGINX, Git, HDFS, and ZeroMQ, written by their creators. Shows what actually works at scale.
- **Production applications** (RealWorldASPNET) -- 5 open-source .NET applications with real users (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex). Shows what modern production systems actually look like.
- **Reference implementations** (curated repos) -- working codebases for patterns like Microservices, Modular Monolith, Hexagonal Architecture, and CQRS. Shows how to build it.

Raw sources are preserved in an **evidence pool**, structured analyses and YAML catalogs live in an **evidence analysis** layer, and distilled guidance lives in the **docs** layer as a reference library with cross-source evidence and reusable templates.

## Quick Start

| I want to... | Start here |
|---|---|
| Choose an architecture style for a new project | [Decision Navigator](docs/reference-library/decision-navigator.md) |
| See which styles correlate with winning | [Solution Spaces](docs/reference-library/solution-spaces.md) |
| Find challenges similar to my problem | [Problem Spaces](docs/reference-library/problem-spaces.md) |
| Look up "given X, what works?" | [Problem-Solution Matrix](docs/reference-library/problem-solution-matrix.md) |
| Prepare for an architecture kata | [Kata Checklist](docs/templates/kata-checklist.md) |
| Browse how teams solved a specific kata | [Challenge Analyses](evidence-analysis/TheKataLog/docs/analysis/challenges/) |
| See cross-cutting patterns across all 78 teams | [Cross-Cutting Analysis](evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md) |
| Compare evidence across all four sources | [Cross-Source Reference](docs/reference-library/evidence/cross-source-reference.md) |
| Read the cross-source analysis | [Cross-Source Analysis](docs/reference-library/evidence/cross-source-analysis.md) |
| Study production architectures (NGINX, Git, etc.) | [AOSA Catalog](evidence-analysis/AOSA/docs/catalog/) |
| See patterns across 12 production systems | [AOSA Source Analysis](evidence-analysis/AOSA/docs/analysis/source-analysis.md) |
| Find working code for a pattern | [Reference Implementations Catalog](evidence-analysis/ReferenceArchitectures/docs/catalog/) |
| See patterns across 8 reference implementations | [Reference Architectures Source Analysis](evidence-analysis/ReferenceArchitectures/docs/analysis/source-analysis.md) |
| Study production .NET applications | [RealWorldASPNET Catalog](evidence-analysis/RealWorldASPNET/docs/catalog/) |
| See patterns across 5 production .NET apps | [RealWorldASPNET Source Analysis](evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md) |

## Key Findings

1. **Modular Monolith has the highest per-team success rate** -- averaging 3.00/4.0 placement score despite only 6 of 78 teams using it. All three first-place Modular Monolith teams won outright.
2. **Feasibility analysis is the strongest predictor of placement** -- teams with it are 4.5x more likely to finish top 2, yet 75.6% of teams skip it.
3. **ADR discipline separates winners** -- first-place teams average 15.0 ADRs, nearly double the runner-up average of 8.5.
4. **Event-Driven is necessary but not sufficient** -- used by 60% of teams and 9 of 11 winners, but differentiators are complementary patterns, ADRs, and feasibility work.
5. **The "Scalability Trap" is real** -- first-place winners cite scalability *less* often (55%) than runners-up (68%). Over-indexing on scalability at the expense of cost, data integrity, and simplicity appears to be a negative signal.
6. **Hybrid/evolutionary approaches win** -- 73% of first-place winners propose two or more architecture styles.
7. **Fitness functions are the most underutilized winning practice** -- only ~17% of teams include them, yet 55% of first-place winners do.
8. **Team size has zero correlation with placement** -- three-person teams won four first-place finishes.

## Repository Structure

```
.
├── docs/
│   ├── reference-library/          # Distilled, evidence-based guidance
│   │   ├── README.md               # Library overview and quick-start
│   │   ├── problem-spaces.md       # 11 challenges classified across 10 dimensions
│   │   ├── solution-spaces.md      # 12 architecture styles with placement scores
│   │   ├── problem-solution-matrix.md  # Problem dimension → best solution mappings
│   │   ├── decision-navigator.md   # Step-by-step questionnaire → recommendations
│   │   └── evidence/
│   │       ├── by-architecture-style.md    # Per-style evidence with team tables
│   │       ├── by-quality-attribute.md     # 10 quality attributes ranked by placement correlation
│   │       ├── cross-source-reference.md   # Weighted scoreboard + coverage across all 4 sources
│   │       └── cross-source-analysis.md   # Triangulation framework + cross-source findings
│   ├── templates/                  # Reusable guides and checklists
│   │   ├── adr-guide.md            # How to write effective ADRs
│   │   ├── architecture-selection-guide.md  # Structured style selection process
│   │   ├── c4-guide.md             # C4 model documentation guide
│   │   ├── feasibility-guide.md    # Feasibility analysis template
│   │   ├── fitness-functions-guide.md  # Architecture fitness functions
│   │   └── kata-checklist.md       # End-to-end kata preparation checklist
│   └── proposals/                  # Future roadmap proposals
│       └── dataset-expansion-and-discovery-skill.md
│
├── evidence-analysis/              # Derived analyses (from evidence data)
│   ├── TheKataLog/                 # O'Reilly Architecture Kata submissions
│   │   └── docs/
│   │       ├── analysis/
│   │       │   ├── challenges/     # 11 per-challenge comparative analyses
│   │       │   └── cross-cutting.md  # Statistical patterns across all 78 teams
│   │       └── catalog/
│   │           ├── _index.yaml     # Master index of all seasons/teams/styles
│   │           └── *.yaml          # 78 structured team metadata files
│   ├── AOSA/                       # Architecture of Open Source Applications
│   │   └── docs/
│   │       ├── analysis/
│   │       │   └── source-analysis.md  # Patterns across 12 production systems
│   │       └── catalog/
│   │           ├── _index.yaml     # Index of 12 AOSA projects
│   │           ├── SCHEMA.yaml     # YAML schema for AOSA entries
│   │           └── *.yaml          # Per-project catalogs (nginx, git, hdfs, etc.)
│   ├── ReferenceArchitectures/     # Curated reference implementations
│   │   └── docs/
│   │       ├── analysis/
│   │       │   └── source-analysis.md  # Patterns across 8 reference implementations
│   │       └── catalog/
│   │           ├── _index.yaml     # Index of 8 reference repos
│   │           ├── SCHEMA.yaml     # YAML schema for reference impl entries
│   │           └── *.yaml          # Per-repo catalogs (eShop, buckpal, etc.)
│   └── RealWorldASPNET/           # Production .NET applications
│       └── docs/
│           ├── analysis/
│           │   └── source-analysis.md  # Patterns across 5 production .NET apps
│           └── catalog/
│               ├── _index.yaml     # Index of 5 production apps
│               ├── SCHEMA.yaml     # YAML schema for production app entries
│               └── *.yaml          # Per-app catalogs (bitwarden, jellyfin, etc.)
│
├── evidence-pool/                  # Raw source submissions (read-only reference)
│   └── TheKataLog/
│       ├── 2020-Farmacy-Food/      # 10 teams
│       ├── 2021-Farmacy-Family/    #  7 teams
│       ├── 2021-Sysops-Squad/      #  7 teams
│       ├── 2022-Hey-Blue/          #  6 teams
│       ├── 2022-Spotlight-Platform/ #  8 teams
│       ├── 2023-Road-Warrior/      #  9 teams
│       ├── 2023-Wildlife-Watcher/  #  6 teams
│       ├── 2024-ClearView/         #  7 teams
│       ├── 2024-MonitorMe/         #  7 teams
│       ├── 2024-ShopWise-AI/       #  4 teams
│       └── 2025-Certifiable-Inc/   #  7 teams
│
└── AGENTS.md                       # Documentation lifecycle conventions
```

### Layer Overview

| Layer | Path | Purpose |
|---|---|---|
| **Reference Library** | `docs/reference-library/` | Distilled guidance: problem/solution mappings, decision navigator, cross-source evidence breakdowns. Start here for recommendations. |
| **Templates** | `docs/templates/` | Reusable guides for ADRs, C4 diagrams, feasibility studies, fitness functions, and kata preparation. |
| **Proposals** | `docs/proposals/` | Roadmap proposals for expanding the dataset and building new capabilities (e.g., architecture discovery skill). |
| **Evidence Analysis** | `evidence-analysis/` | Structured YAML catalogs and comparative analyses derived from evidence sources. Four sub-collections: TheKataLog (78 competition teams), AOSA (12 production systems), RealWorldASPNET (5 production .NET apps), and ReferenceArchitectures (8 working codebases). |
| **Evidence Pool** | `evidence-pool/` | Raw team submissions organized by `<year>-<challenge>/<team>/`. 78 folders sourced from [TheKataLog](https://github.com/TheKataLog) GitHub organization. |

## Evidence Sources

| Source | Type | Entries | What it provides |
|---|---|---|---|
| **[TheKataLog](https://github.com/TheKataLog)** | Competition designs | 78 teams | Placement-weighted scoring across 11 challenges; shows what judges reward |
| **[AOSA](https://aosabook.org/en/)** | Production narratives | 12 projects | Architectural descriptions by creators of NGINX, Git, HDFS, ZeroMQ, LLVM, and others; shows what works at scale |
| **RealWorldASPNET** | Production applications | 5 projects | Open-source .NET applications with real users: Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex |
| **Reference Implementations** | Working code | 8 repos | Deployable codebases for Microservices, Modular Monolith, Hexagonal, CQRS, Serverless, and DDD patterns |

### Dataset Summary

| Metric | Value |
|---|---|
| Total evidence entries | 103 (78 + 12 + 5 + 8) |
| KataLog seasons | 11 (Fall 2020 -- Winter 2025) |
| Kata challenges | 11 |
| AOSA volumes | 2 (2011--2012) |
| Reference impl languages | C#, Java, Go, Bicep |
| Architecture styles identified | 12 canonical categories + production-only styles (Pipeline, Plugin, Reactor, etc.) |
| ADRs analyzed | ~780 |
| Problem dimensions classified | 10 |
| Quality attributes tracked | 10+ |

## Kata Challenges Covered

| Year | Challenge | Domain | Teams |
|---|---|---|---|
| 2020 | Farmacy Food | Healthcare / meal delivery | 10 |
| 2021 | Sysops Squad | IT ticketing / field service | 7 |
| 2021 | Farmacy Family | Healthcare / community wellness | 7 |
| 2022 | Hey Blue! | Civic tech / community policing | 6 |
| 2022 | Spotlight Platform | Non-profit / career platform | 8 |
| 2023 | Road Warrior | Travel / trip management | 9 |
| 2023 | Wildlife Watcher | Conservation / IoT sensors | 6 |
| 2024 | MonitorMe | Healthcare / patient monitoring | 7 |
| 2024 | ClearView | HR / AI-driven resume matching | 7 |
| 2024 | ShopWise AI | Retail / AI shopping assistant | 4 |
| 2025 | Certifiable Inc. | Education / AI certification grading | 7 |

## AOSA Projects Covered

| Project | Domain | Key Styles |
|---|---|---|
| NGINX | Web infrastructure | Event-Driven, Pipeline |
| Git | Version control | Content-Addressable Storage, DAG |
| HDFS | Distributed storage / big data | Primary-Secondary, Data Replication |
| LLVM | Compiler infrastructure | Pipeline, Modular, Plugin |
| Riak | Distributed database | Peer-to-Peer, Eventual Consistency |
| ZeroMQ | Messaging / distributed systems | Broker-less Messaging, Pipeline, Actor Model |
| Twisted | Networking framework | Event-Driven, Reactor Pattern |
| SQLAlchemy | Database / ORM | Layered Architecture, Plugin |
| Selenium | Testing / browser automation | Service-Based, Adapter Pattern |
| Graphite | Monitoring / metrics | Pipeline, Service-Based |
| Puppet | Configuration management | Declarative Configuration, Client-Server |
| GStreamer | Multimedia / streaming | Pipeline, Plugin |

## Reference Implementations Covered

| Project | Language | Key Styles | Status |
|---|---|---|---|
| eShop | C# | Microservices, Event-Driven | Active |
| eShopOnContainers | C# | Microservices, Event-Driven, DDD, CQRS | Archived |
| Modular Monolith with DDD | C# | Modular Monolith, DDD, CQRS, Event-Driven | Maintained |
| Clean Architecture Template | C# | Hexagonal, CQRS | Active |
| BuckPal | Java | Hexagonal Architecture | Maintained |
| Wild Workouts Go | Go | DDD, Hexagonal, CQRS, Microservices | Maintained |
| Serverless Microservices | C# | Serverless, Microservices, Event-Driven | Maintained |
| AKS Baseline Cluster | Bicep | Microservices, Service-Based | Active |

## How to Use This Repository

**For architects and developers:** Use the [Decision Navigator](docs/reference-library/decision-navigator.md) to get tailored architecture recommendations based on your project's characteristics. Cross-reference with the [Problem-Solution Matrix](docs/reference-library/problem-solution-matrix.md), then validate findings against production systems via the [Cross-Source Reference](docs/reference-library/evidence/cross-source-reference.md) and browse [working code](evidence-analysis/ReferenceArchitectures/docs/catalog/) for your chosen style.

**For kata competitors:** Start with the [Kata Checklist](docs/templates/kata-checklist.md), review how past winners approached similar challenges in the [Challenge Analyses](evidence-analysis/TheKataLog/docs/analysis/challenges/), and use the templates for ADRs, C4 diagrams, and feasibility studies.

**For educators and students:** Browse the [Evidence Pool](evidence-pool/TheKataLog/) to study competition submissions side-by-side, compare them to real production architectures in the [AOSA Catalog](evidence-analysis/AOSA/docs/catalog/), or use the [Cross-Cutting Analysis](evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md) to teach evidence-based architecture decision-making.

## Contributing

This is a living repository. Each evidence source has its own YAML schema and contribution path:

**Adding a new kata season (TheKataLog):**
1. Create a YAML catalog file per team following the schema in `evidence-analysis/TheKataLog/docs/catalog/`
2. Update the master index at `evidence-analysis/TheKataLog/docs/catalog/_index.yaml`
3. Write a challenge analysis in `evidence-analysis/TheKataLog/docs/analysis/challenges/`
4. Re-derive cross-cutting statistics in `evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md`

**Adding an AOSA project or reference implementation:**
1. Create a YAML catalog file following the schema in the relevant `SCHEMA.yaml`
2. Update the corresponding `_index.yaml`
3. Update the [Cross-Source Reference](docs/reference-library/evidence/cross-source-reference.md) coverage table

After any addition, update reference library documents to reflect new styles, quality attributes, or problem dimensions. The YAML catalogs are the single source of truth -- all analysis and reference content is derived from them.

See the [Dataset Expansion Proposal](docs/proposals/dataset-expansion-and-discovery-skill.md) for the roadmap on future evidence sources and the planned `/discover-architecture` skill.

## Acknowledgments

- **TheKataLog** evidence pool is sourced from [The Kata Log](https://github.com/TheKataLog), curated by [Jacqui Read](https://jacquiread.com/). The O'Reilly Architecture Katas are hosted by [Neal Ford](http://nealford.com/) and [Mark Richards](https://developertoarchitect.com/).
- **AOSA** content is derived from [The Architecture of Open Source Applications](https://aosabook.org/en/) (CC BY 3.0), edited by Amy Brown and Greg Wilson.
- **Reference implementations** are cataloged from their respective open-source repositories (see individual YAML entries for links and licenses).
