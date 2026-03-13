# Architecture Reference Library

> An evidence-based guide to software architecture decisions, grounded in 142 production codebases (Discovered) and 17 production system case studies (AOSA/RealWorld), with qualitative annotation from 78 competition team submissions (KataLog) and 50 reference implementations.

## What This Is

This is a structured reference library that maps problem characteristics to proven architectural solutions. Every claim is grounded in evidence from real production systems — not opinion, convention, or never-built designs.

The evidence hierarchy (per [ADR-004](../adr/Adopted/(ADR-004)-Discovered-First-Evidence-Hierarchy/(ADR-004)-Discovered-First-Evidence-Hierarchy.md)):

- **Primary evidence** — 142 production-grade open-source repositories classified via deep-analysis source code inspection (ADR-002), plus 17 production system case studies (12 AOSA + 5 RealWorldASPNET) with published architectural reasoning
- **Qualitative annotation** — 78 KataLog competition team submissions valued for ADR documentation, judge commentary, cost projections, and "why this works" reasoning unavailable in code
- **Teaching examples** — 8 curated reference implementations and 42 Discovered reference entries, useful as concrete examples but not counted in frequency rankings (ADR-001)

The library is organized into **problem spaces** (classifying challenges), **solution spaces** (cataloging architectural approaches), a **cross-source evidence base** (production frequency rankings and analysis), and **practitioner templates** (ADRs, C4, feasibility, fitness functions).

## Quick Start

| I want to... | Start here |
|---|---|
| Look up a term or definition | [Glossary](glossary.md) |
| Choose an architecture style for a new project | [Decision Navigator](decision-navigator.md) |
| See which styles are most common in production code | [Cross-Source Reference](evidence/cross-source-reference.md) — Discovered frequency rankings |
| Understand the proposal-production gap | [Cross-Source Analysis](evidence/cross-source-analysis.md) — what's proposed in competition but absent in production |
| Explore style frequency and evidence profiles | [Solution Spaces](solution-spaces.md) |
| Find challenges similar to my problem | [Problem Spaces](problem-spaces.md) |
| Look up "given X, what works?" | [Problem-Solution Matrix](problem-solution-matrix.md) |
| Study production architectures (NGINX, Git, etc.) | [AOSA Catalog](../../evidence-analysis/AOSA/docs/catalog/) |
| Browse 142 production architecture examples | [Discovered Catalog](../../evidence-analysis/Discovered/docs/catalog/) |
| Find working code for a pattern | [Reference Implementations](../../evidence-analysis/ReferenceArchitectures/docs/catalog/) |
| Prepare for an architecture kata | [Kata Checklist](../templates/kata-checklist.md) |

## Library Structure

### Glossary

| Document | What It Contains |
|----------|-----------------|
| [Glossary](glossary.md) | Definitions of all 12 architecture styles, 13 quality attributes, 5 evidence sources, 10 problem dimensions, and key terms (tutorial bias, detection bias, proposal-production gap, etc.) |

### Core Reference (Discovered-first)

| Document | What It Contains | When to Use |
|----------|-----------------|-------------|
| [Problem Spaces](problem-spaces.md) | 47 domains classified across 10 dimensions, led by Discovered production domain distribution (142 repos) | Identify which real-world domains match your situation |
| [Solution Spaces](solution-spaces.md) | 12 architecture styles ranked by production frequency (Discovered) with production depth (AOSA/RealWorld) and qualitative annotation (KataLog) | Compare architectural approaches with production evidence |
| [Problem-Solution Matrix](problem-solution-matrix.md) | Mappings from problem dimensions to proven solutions, led by Discovered domain-style correlations | Look up "given X, what works in production?" |
| [Decision Navigator](decision-navigator.md) | Step-by-step questionnaire with recommendations grounded in Discovered frequency data | Get personalized architecture guidance |

### Cross-Source Evidence

| Document | What It Contains |
|----------|-----------------|
| [Cross-Source Reference](evidence/cross-source-reference.md) | Discovered frequency rankings (PRIMARY) for 12 styles across 142 production repos, with platform/application split. AOSA/RealWorld production depth validation. KataLog qualitative context. |
| [Cross-Source Analysis](evidence/cross-source-analysis.md) | Production evidence model, evidence confidence tiers, the proposal-production gap, quality attribute evidence across sources, and 6 cross-source findings |

### Per-Source Evidence

| Document | Source | What It Contains |
|----------|--------|-----------------|
| [By Architecture Style](evidence/by-architecture-style.md) | Discovered (primary) | 12 styles ranked by production frequency, with per-style evidence summaries, platform/application breakdowns, AOSA/RealWorld depth, and KataLog qualitative annotation |
| [By Quality Attribute](evidence/by-quality-attribute.md) | Discovered (primary) | QA detection rankings from 142 production repos, with detection bias caveat, AOSA/RealWorld validation, and KataLog annotation for QAs invisible in code |
| [KataLog Cross-Cutting Analysis](../../evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md) | KataLog | Statistical patterns across 78 teams: ADR discipline, cost analysis, the "winning formula" scorecard |
| [AOSA Source Analysis](../../evidence-analysis/AOSA/docs/analysis/source-analysis.md) | AOSA | Patterns across 12 production systems (Pipeline, Microkernel, Event-Driven dominance) |
| [RealWorldASPNET Source Analysis](../../evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md) | RealWorldASPNET | Patterns across 5 production .NET apps (Microkernel, CQRS/ES, extensibility as hidden quality attribute) |
| [Reference Architectures Source Analysis](../../evidence-analysis/ReferenceArchitectures/docs/analysis/source-analysis.md) | RefArch | Patterns across 8 reference implementations (Microservices, Hexagonal, DDD focus) — annotation only |
| [Discovered Source Analysis](../../evidence-analysis/Discovered/docs/analysis/source-analysis.md) | Discovered | Production-only frequency rankings (142 entries), platform/application split, domain coverage, deep-analysis methodology |

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
| Discovered repos | 184 (142 production + 42 reference) | [`evidence-analysis/Discovered/docs/catalog/`](../../evidence-analysis/Discovered/docs/catalog/) |
| AOSA projects | 12 | [`evidence-analysis/AOSA/docs/catalog/`](../../evidence-analysis/AOSA/docs/catalog/) |
| RealWorldASPNET apps | 5 | [`evidence-analysis/RealWorldASPNET/docs/catalog/`](../../evidence-analysis/RealWorldASPNET/docs/catalog/) |
| KataLog teams | 78 | [`evidence-analysis/TheKataLog/docs/catalog/`](../../evidence-analysis/TheKataLog/docs/catalog/) |
| Reference implementations | 8 | [`evidence-analysis/ReferenceArchitectures/docs/catalog/`](../../evidence-analysis/ReferenceArchitectures/docs/catalog/) |

## Key Findings

### Production Evidence (Discovered + AOSA/RealWorld)

1. **Microkernel is the most prevalent production pattern.** 83 of 142 production repos (58.5%) exhibit Microkernel architecture after SPEC-022 deep-analysis resolved prior detection blind spots. Platforms (61%) and applications (55%) both show strong adoption. Notable projects: n8n, elasticsearch, nest, redis, grafana. Validated by 6 AOSA/RealWorld production systems.

2. **Layered is the second most prevalent.** 78 of 142 production repos (54.9%), skewing toward applications (67%) over platforms (47%). Notable projects: nocodb, traefik, maybe, mastodon, discourse. Combined with nopCommerce's AOSA/RealWorld evidence, Layered has massive production breadth.

3. **The proposal-production gap is real.** Patterns teams propose in competitions diverge sharply from production reality. Microservices: 50% of competition teams, 8.5% of production repos, 0% of AOSA/RealWorld systems. Pipeline: 0% of competition teams, 9.2% of production repos, 35% of AOSA/RealWorld systems.

4. **Tutorial bias inflated DDD, CQRS, and Hexagonal.** Prior methodology counted reference/tutorial implementations alongside production code. After ADR-001 correction: DDD dropped from 17.8% to 2.1%, CQRS from 10.4% to 0.7%. These patterns are well-documented in teaching materials but rare in production.

5. **Modular Monolith has broad production validation.** 57 of 142 production repos (40.1%) across multiple languages and frameworks. Notable projects: AutoGPT, n8n, langchain, elasticsearch. The remaining gap is AOSA/RealWorld depth (only 1 exemplar: Orchard Core).

### Competition-Specific (KataLog — qualitative annotation)

6. **Feasibility analysis is the strongest single predictor of placement.** Teams with it are 4.5x more likely to place top 2. Yet 75.6% of teams skip it.

7. **ADR discipline separates winners.** First-place teams average 15.0 ADRs, nearly double the runner-up average of 8.5.

8. **The "Scalability Trap" is real.** First-place winners cite scalability *less* often (55%) than runners-up (68%). Over-indexing on scalability is a negative signal.

9. **Fitness functions are the most underutilized winning practice.** Only ~17% of teams include them, yet 55% of first-place winners do.

## Dataset

| Metric | Value |
|--------|-------|
| Production evidence entries | 159 (142 Discovered production + 12 AOSA + 5 RealWorldASPNET) |
| Annotation entries | 128 (78 KataLog + 42 Discovered reference + 8 RefArch) |
| Total evidence entries | 287 |
| Architecture styles covered | 12 canonical |
| Production repo languages | Go, Java, Python, C#, TypeScript, Rust, Kotlin, Ruby, PHP, C/C++ |
| Production systems (case studies) | 17 (12 AOSA + 5 RealWorldASPNET) |
| Platform/application ratio | 1.58:1 (87 platforms, 55 applications) |
| ADRs analyzed | ~780 (KataLog) |
| Problem dimensions classified | 10 |
| Quality attributes tracked | 13 |

## Methodology

**Evidence hierarchy (ADR-004).** Production evidence leads all rankings. Discovered production repos (142 entries, deep-analysis validated per ADR-002) provide the statistical baseline. AOSA/RealWorld production systems (17 entries) provide narrative depth. KataLog competition submissions (78 teams) provide qualitative annotation — ADR reasoning, judge commentary, cost projections. Reference implementations provide teaching examples. See [ADR-004](../adr/Adopted/(ADR-004)-Discovered-First-Evidence-Hierarchy/(ADR-004)-Discovered-First-Evidence-Hierarchy.md).

**Classification (ADR-002).** Deep-analysis source code inspection is the sole classification source. Heuristic classification is not counted. All 184 Discovered entries are deep-analysis classified with zero Indeterminate results.

**Taxonomy (ADR-001).** Every catalog entry is tagged with scope (platform/application) and use-type (production/reference). Only production-grade entries count in frequency rankings. Reference implementations appear as annotation examples with zero weight.

**Normalization.** Architecture style names use canonical forms: "Pipeline" (was "Pipe-and-Filter"), "Microkernel" (was "Plugin/Microkernel"). Quality attributes were similarly normalized across sources.

> **Detection bias:** Discovered statistics are derived from deep-analysis source code inspection. Styles and QAs that leave strong code signals are more reliably detected. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this specific gap — teams documented these invisible decisions in ADRs and presentations.

**Limitations.**
- **Production evidence base**: 17 AOSA/RealWorld case studies is small. Pipeline at 6/17 is directionally strong but not statistically conclusive.
- **Era effects**: AOSA projects (2011--2012) predate Microservices, Serverless, and cloud-native patterns.
- **Language bias**: RealWorldASPNET is .NET-only. Discovered spans 10+ languages but skews toward Go, Python, Java, and TypeScript.
- **Detection bias**: Deep-analysis substantially improved detection (Microkernel rose from 0% to 58.5%) but some patterns remain harder to detect than others.
- **Competition subjectivity**: KataLog evaluation criteria and judge panels vary across seasons. Competition evidence is annotation only (ADR-004).
- **Correlation vs. causation**: Production frequency does not imply suitability for all contexts.
