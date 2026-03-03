# Architecture Reference Library

> An evidence-based guide to software architecture decisions, derived from 276 entries across five complementary sources: competition designs, production system narratives, production applications, reference implementations, and automated open-source discovery.

## What This Is

This is a structured reference library that maps problem characteristics to proven architectural solutions. Every claim is grounded in evidence from real projects — not opinion or convention. The evidence spans the full system lifecycle:

- **Design stage** — 78 team submissions across 11 O'Reilly Architecture Kata seasons (Fall 2020 -- Winter 2025), scored by placement
- **Code stage** — 8 curated reference implementations with deployable code, plus 173 open-source repositories classified by automated architecture discovery
- **Production stage** — 12 AOSA production system narratives written by their creators (NGINX, Git, HDFS, etc.) and 5 production .NET applications with real users (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex)

The library is organized into **problem spaces** (classifying challenges), **solution spaces** (cataloging architectural approaches), a **cross-source evidence base** (weighted scoreboard and triangulation across all 5 sources), and **practitioner templates** (ADRs, C4, feasibility, fitness functions).

## Quick Start

| I want to... | Start here |
|---|---|
| Choose an architecture style for a new project | [Decision Navigator](decision-navigator.md) |
| See which styles have the strongest evidence | [Cross-Source Reference](evidence/cross-source-reference.md) — weighted scoreboard across all 5 sources |
| Understand the design-production gap | [Cross-Source Analysis](evidence/cross-source-analysis.md) — what's popular in design but absent in production |
| See which styles correlate with winning competitions | [Solution Spaces](solution-spaces.md) |
| Find challenges similar to my problem | [Problem Spaces](problem-spaces.md) |
| Look up "given X, what works?" | [Problem-Solution Matrix](problem-solution-matrix.md) |
| Study production architectures (NGINX, Git, etc.) | [AOSA Catalog](../../evidence-analysis/AOSA/docs/catalog/) |
| Browse 173 auto-discovered architecture examples | [Discovered Catalog](../../evidence-analysis/Discovered/docs/catalog/) |
| Find working code for a pattern | [Reference Implementations](../../evidence-analysis/ReferenceArchitectures/docs/catalog/) |
| Prepare for an architecture kata | [Kata Checklist](../templates/kata-checklist.md) |

## Library Structure

### Core Reference (KataLog-derived)

| Document | What It Contains | When to Use |
|----------|-----------------|-------------|
| [Problem Spaces](problem-spaces.md) | 11 challenges classified across 10 dimensions (domain type, scale, budget, compliance, integration complexity, real-time needs, edge/offline, AI/ML, greenfield/brownfield, key tension) | Identify which past challenges match your situation |
| [Solution Spaces](solution-spaces.md) | 12 architecture styles with placement-weighted scores | Compare architectural approaches with competition evidence |
| [Problem-Solution Matrix](problem-solution-matrix.md) | Mappings from problem dimensions to best solutions | Look up "given X, what works best?" |
| [Decision Navigator](decision-navigator.md) | Step-by-step questionnaire leading to recommendations | Get personalized architecture guidance |

### Cross-Source Evidence

| Document | What It Contains |
|----------|-----------------|
| [Cross-Source Reference](evidence/cross-source-reference.md) | Weighted scoreboard mapping 13 styles across all 5 sources (276 entries) with production-weighted scoring. Includes Discovered breadth data, production evidence share, and evidence quality comparison. |
| [Cross-Source Analysis](evidence/cross-source-analysis.md) | Five-source triangulation framework, evidence depth tiers (T1-T5), the design-production gap, the three-way gap (design vs. code vs. production), quality attribute shifts across lifecycle, and 6 cross-source findings |

### Per-Source Evidence

| Document | Source | What It Contains |
|----------|--------|-----------------|
| [By Architecture Style](evidence/by-architecture-style.md) | KataLog | Detailed evidence for each ranked style with per-team tables, technology stacks, and pairing patterns |
| [By Quality Attribute](evidence/by-quality-attribute.md) | KataLog | 10 quality attributes ranked by correlation with placement, with per-challenge breakdowns |
| [KataLog Cross-Cutting Analysis](../../evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md) | KataLog | Statistical patterns across all 78 teams: style vs. placement, ADR discipline, the "winning formula" scorecard |
| [AOSA Source Analysis](../../evidence-analysis/AOSA/docs/analysis/source-analysis.md) | AOSA | Patterns across 12 production systems (Pipeline, Plugin, Event-Driven dominance) |
| [RealWorldASPNET Source Analysis](../../evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md) | RealWorldASPNET | Patterns across 5 production .NET apps (Plugin, CQRS/ES, extensibility as hidden quality attribute) |
| [Reference Architectures Source Analysis](../../evidence-analysis/ReferenceArchitectures/docs/analysis/source-analysis.md) | RefArch | Patterns across 8 reference implementations (Microservices, Hexagonal, DDD focus) |
| [Discovered Quality Report](../../evidence-analysis/Discovered/quality-report.md) | Discovered | Coverage statistics for 173 auto-classified repos (all 12 styles at n >= 10) |

### Templates

| Document | When to Use |
|----------|-------------|
| [ADR Guide](../templates/adr-guide.md) | Writing architecture decision records (the #2 predictor of competition success) |
| [C4 Guide](../templates/c4-guide.md) | Documenting architecture with C4 model diagrams |
| [Feasibility Guide](../templates/feasibility-guide.md) | Cost/feasibility analysis (the #1 predictor of competition success) |
| [Fitness Functions Guide](../templates/fitness-functions-guide.md) | Defining quantitative architecture health checks |
| [Architecture Selection Guide](../templates/architecture-selection-guide.md) | Structured process for choosing an architecture style |
| [Kata Checklist](../templates/kata-checklist.md) | End-to-end architecture kata preparation |

### Evidence Catalogs (YAML)

| Catalog | Entries | Path |
|---------|---------|------|
| KataLog teams | 78 | [`evidence-analysis/TheKataLog/docs/catalog/`](../../evidence-analysis/TheKataLog/docs/catalog/) |
| AOSA projects | 12 | [`evidence-analysis/AOSA/docs/catalog/`](../../evidence-analysis/AOSA/docs/catalog/) |
| RealWorldASPNET apps | 5 | [`evidence-analysis/RealWorldASPNET/docs/catalog/`](../../evidence-analysis/RealWorldASPNET/docs/catalog/) |
| Reference implementations | 8 | [`evidence-analysis/ReferenceArchitectures/docs/catalog/`](../../evidence-analysis/ReferenceArchitectures/docs/catalog/) |
| Discovered repos | 173 | [`evidence-analysis/Discovered/docs/catalog/`](../../evidence-analysis/Discovered/docs/catalog/) |

## Key Findings

### Cross-Source (all 5 sources)

1. **The design-production gap is real.** The patterns teams propose in competitions (Microservices, Serverless) diverge sharply from the patterns that dominate production systems (Pipeline, Plugin). Microservices: 50% of competition teams, 0% of production systems. Pipeline: 0% of competition teams, 35% of production systems. See [Cross-Source Analysis](evidence/cross-source-analysis.md).

2. **Event-Driven is the only style validated across all 5 sources** -- competition, production infrastructure, production applications, reference implementations, and open-source discovery. But it means different things at each stage: a primary style label in design, non-blocking I/O in infrastructure, audit trails in applications, and message broker integration in open-source code.

3. **Plugin/Microkernel is invisible to automated detection.** The #2 curated style (97% production evidence) has zero Discovered entries because plugin architectures are defined by runtime extension points, not directory structure. Structural signal detection has a systematic blind spot for this pattern.

4. **DDD has massive code presence but zero production evidence.** 51 Discovered repos (the 3rd-most common Discovered style) vs. 0 production systems. The most-implemented pattern without production validation.

5. **Modular Monolith has the strongest signal across the broadest evidence.** Highest KataLog win rate (83.3%), production validation (Orchard Core), and 42 Discovered repos across multiple languages. The remaining gap is production depth (only 1 exemplar).

### Competition-Specific (KataLog)

6. **Feasibility analysis is the strongest single predictor of placement.** Teams with it are 4.5x more likely to place top 2. Yet 75.6% of teams skip it.

7. **ADR discipline separates winners.** First-place teams average 15.0 ADRs, nearly double the runner-up average of 8.5.

8. **The "Scalability Trap" is real.** First-place winners cite scalability *less* often (55%) than runners-up (68%). Over-indexing on scalability is a negative signal.

9. **Fitness functions are the most underutilized winning practice.** Only ~17% of teams include them, yet 55% of first-place winners do.

## Dataset

| Metric | Value |
|--------|-------|
| Total evidence entries | 276 (78 + 12 + 5 + 8 + 173) |
| Evidence sources | 5 (KataLog, AOSA, RealWorldASPNET, Reference Impls, Discovered) |
| Architecture styles covered | 13 (12 canonical + Pipeline/Plugin from production) |
| KataLog seasons | 11 (Fall 2020 -- Winter 2025) |
| AOSA volumes | 2 (2011--2012) |
| Production systems | 17 (12 AOSA + 5 RealWorldASPNET) |
| Discovered repo languages | Go, Java, Python, C#, TypeScript, Rust, Kotlin, Ruby, Elixir |
| ADRs analyzed | ~780 (KataLog) |
| Problem dimensions classified | 10 |
| Quality attributes tracked | 10+ |

## Methodology

**Evidence collection.** Five independent evidence sources were collected and cataloged into structured YAML:
- **KataLog**: 78 team submissions cataloged with placement, architecture styles, ADR count, quality attributes, documentation artifacts, and technology stack
- **AOSA**: 12 production system narratives analyzed for architecture styles, quality attributes, and design decisions
- **RealWorldASPNET**: 5 production .NET applications analyzed from source code for architecture styles, quality attributes, and extensibility patterns
- **Reference Implementations**: 8 curated open-source repositories evaluated for architecture styles, test coverage, and documentation quality
- **Discovered**: 173 open-source repositories identified via GitHub search, classified from structural signals (Docker configs, message queues, API specs, directory structure) using automated detection with LLM review

**Weighting.** Production evidence is weighted most heavily (20 pts per system), competition placements are weighted by rank (1st = 4, 2nd = 3, 3rd = 2, Runner-up = 1), reference implementations get 1-2 pts. Discovered entries are shown as breadth counts (not point-weighted) because automated classification has inherently lower confidence than expert curation. See [Cross-Source Reference](evidence/cross-source-reference.md) for the full methodology.

**Normalization.** Architecture style names were normalized across sources (e.g., "Pipe-and-Filter" in Discovered = "Pipeline" in AOSA). Quality attributes were similarly normalized.

**Limitations.**
- **Production evidence base is small**: 17 systems. Pipeline at 6/17 is directionally strong but not statistically conclusive.
- **Era effects**: AOSA projects (2011--2012) predate Microservices, Serverless, and cloud-native patterns.
- **Language bias**: RealWorldASPNET is .NET-only. Discovered skews toward Go, Python, and Java.
- **Automated classification**: Discovered entries have high confidence (median 0.92) but are not expert-grade. Structural detection has blind spots (Plugin/Microkernel: 0 entries).
- **Competition subjectivity**: KataLog evaluation criteria and judge panels vary across seasons.
- **Correlation vs. causation**: Winning teams may succeed for reasons beyond their architectural style choice.
