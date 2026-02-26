# Cross-Source Analysis: Triangulating Evidence Across 103 Architecture Sources

## Purpose

This document synthesizes findings from the four independent 1st-degree source analyses into cross-source insights that no single source can produce. The [cross-source-reference.md](cross-source-reference.md) provides the lookup tables and weighted scoreboard; this document provides the *analytical framework* and the *derived findings*.

---

## Analysis Framework

### The Four-Source Triangulation Model

Each evidence source observes architecture from a different vantage point in the system lifecycle:

```
   DESIGN                     CODE                      PRODUCTION
   ──────                     ────                      ──────────
   TheKataLog (78)    →   Reference Impls (8)   →   AOSA (12) + RealWorldASPNET (5)
   "What judges reward"   "How to build it"         "What survives at scale"

   Competition designs      Teaching codebases         Real users, real failures,
   with placement data      with sample domains        real operational pressure
```

A pattern validated at all three lifecycle stages carries fundamentally higher confidence than one validated at only one. The framework classifies each insight by **evidence depth** — the number of independent sources that support it.

### Evidence Depth Tiers

| Tier | Sources | Label | Confidence | Example |
|------|---------|-------|------------|---------|
| **T1** | 1 source | Single-source | Low — may reflect source bias | Multi-Agent (KataLog only) |
| **T2** | 2 sources | Corroborated | Moderate — validated from two vantage points | Modular Monolith (KataLog + RefArch) |
| **T3** | 3 sources | Triangulated | High — consistent across design, code, and production | Plugin Architecture (AOSA + RealWorld + KataLog) |
| **T4** | 4 sources | Fully validated | Very high — converged across all evidence types | Event-Driven (all four sources) |

### Analysis Dimensions

The cross-source analysis examines five dimensions:

1. **Style Convergence/Divergence** — Where do sources agree and disagree on which patterns matter?
2. **The Design-Production Gap** — What's popular in competition but absent in production, and vice versa?
3. **Quality Attribute Triangulation** — How do quality attribute priorities shift across the lifecycle?
4. **Practice-Evidence Gap** — Which practices predict success but lack support in teaching materials?
5. **Lifecycle-Stage Evidence** — Which patterns have evidence at which lifecycle stages?

---

## 1. Style Convergence and Divergence

### T4: Styles Validated Across All Four Sources

Only **Event-Driven** appears in all four evidence sources. This is the single most broadly validated pattern in the dataset.

| Source | Event-Driven Evidence |
|--------|----------------------|
| **KataLog** | 47 of 78 teams (60%); 9 of 11 first-place winners; highest weighted score (94) |
| **AOSA** | NGINX (30% of web traffic), Twisted (Python networking), ZeroMQ (financial trading) |
| **RealWorldASPNET** | Squidex (event sourcing), Bitwarden (AMQP cross-service events) |
| **RefArch** | eShopOnContainers, eShop, Modular Monolith w/DDD, Serverless Microservices, Wild Workouts |

**Cross-source insight**: Event-Driven is universally adopted, but its *role* shifts across the lifecycle:

- In **design** (KataLog): chosen as the primary organizing principle — "our system is event-driven"
- In **teaching** (RefArch): demonstrated as an integration pattern between bounded contexts
- In **production** (AOSA/RealWorld): used for specific technical purposes — non-blocking I/O (NGINX), immutable audit trails (Squidex), cross-service coordination (Bitwarden)

The evidence suggests that teams proposing "Event-Driven Architecture" as a primary style should specify *which aspect* they mean: event-based communication, event sourcing as data model, or event-loop concurrency. Production systems use events tactically; competition teams often adopt the label strategically.

### T3: Styles Validated Across Three Sources

| Style | Sources | Missing From | Cross-Source Insight |
|-------|---------|-------------|---------------------|
| **Plugin/Microkernel** | AOSA (3), RealWorld (3), KataLog (2) | RefArch | Production workhorse (6 production systems) nearly invisible in competition (2/78 teams). Teaching materials don't cover it at all. |
| **Service-Based** | KataLog (25), AOSA (2), RealWorld (1) | — (in RefArch as AKS only) | Consistent mid-tier performer. The pragmatic choice for cost-sensitive and brownfield contexts across all sources. |

### T2: Styles Validated Across Two Sources

| Style | Sources | Missing From | Cross-Source Insight |
|-------|---------|-------------|---------------------|
| **Modular Monolith** | KataLog (6), RealWorld (1), RefArch (1) | AOSA | Highest KataLog win rate (83.3%) with Orchard Core as production proof. Thin evidence base overall (n=8). |
| **Pipeline** | AOSA (5), RealWorld (1) | KataLog, RefArch | The #1 production pattern with zero design-phase representation. Teams don't propose it; systems evolve into it. |
| **CQRS/Event Sourcing** | KataLog (3), RealWorld (1), RefArch (3) | AOSA | Well-represented in code (4 implementations) but only 1 production exemplar (Squidex). Design evidence is thin (3 teams). |
| **Hexagonal/Clean** | KataLog (4), RefArch (3) | AOSA, RealWorld | Widely taught (3 reference implementations, 17K stars) but no production evidence. A pedagogical pattern that hasn't been validated operationally. |
| **Microservices** | KataLog (39), RefArch (5) | AOSA, RealWorld | The sharpest design-production divergence. #2 in competition popularity, #1 in reference implementations, zero production evidence across both production sources. |

### T1: Styles Validated by a Single Source

| Style | Source | Evidence | Assessment |
|-------|--------|----------|------------|
| **Multi-Agent** | KataLog (3) | Emerged in AI Winter 2024 | Too new for production evidence; watch this space |
| **Space-Based** | AOSA (1: Riak) + KataLog (2) | Very thin | Insufficient evidence to draw conclusions |
| **Layered Architecture** | RealWorld (1: nopCommerce) | Single exemplar | Production-proven but only one data point |

---

## 2. The Design-Production Gap

The most consequential finding from cross-source analysis: **the patterns teams propose in design exercises diverge sharply from the patterns that dominate production systems.**

### The Gap Quantified

| Style | KataLog Adoption | Production Adoption | Gap Direction |
|-------|-----------------|--------------------|----|
| **Pipeline** | 0% (0/78 teams) | 35% (6/17 production) | Massively under-proposed |
| **Plugin/Microkernel** | 2.6% (2/78 teams) | 35% (6/17 production) | Massively under-proposed |
| **Microservices** | 50% (39/78 teams) | 0% (0/17 production) | Massively over-proposed |
| **Serverless** | 10% (8/78 teams) | 0% (0/17 production) | Over-proposed |
| **Event-Driven** | 60% (47/78 teams) | 29% (5/17 production) | Over-proposed (but present) |
| **Service-Based** | 32% (25/78 teams) | 18% (3/17 production) | Roughly aligned |
| **Modular Monolith** | 8% (6/78 teams) | 6% (1/17 production) | Roughly aligned |

### Why the Gap Exists

Three structural factors explain the divergence:

**1. Recency bias in competition.** Microservices and Serverless became named patterns in the mid-2010s and dominate architecture conference talks, books, and certification curricula. Competition teams draw from this recent discourse. AOSA projects (2011--2012) predate the microservices naming, and RealWorldASPNET projects evolved organically rather than being designed from a pattern catalog.

**2. Problem-domain mismatch.** KataLog challenges describe user-facing business systems (e-commerce, healthcare, travel, HR) where Microservices and Event-Driven map intuitively. AOSA covers infrastructure software (web servers, compilers, databases) where Pipeline and Plugin solve the actual problems. The gap partly reflects different problem domains — but competition teams rarely consider whether infrastructure patterns apply to their challenges.

**3. Operational complexity filter.** Production systems shed patterns that don't justify their operational cost. Microservices require service mesh, distributed tracing, independent CI/CD pipelines, and a platform team to sustain. Production teams that could use these patterns (Bitwarden with 9 services) choose simpler decomposition (Service-Based) because the operational overhead of full microservice independence isn't worth it.

### Implication for Practitioners

When choosing an architecture style, competition-winning patterns (Event-Driven + Microservices) are not automatically the right production choice. The cross-source evidence suggests a **two-step evaluation**:

1. **Would this pattern survive contact with production?** Check the Production Evidence Share table in [cross-source-reference.md](cross-source-reference.md). Styles with 0% production evidence (Microservices, Serverless, DDD, Hexagonal, Multi-Agent) should be adopted with awareness that no production system in the evidence base uses them as a primary organizing principle.

2. **Am I overlooking production-proven patterns?** Pipeline and Plugin are the most underconsidered patterns in design exercises, yet they dominate production. If your system processes data through ordered stages or needs extensibility via third-party modules, these should be on your shortlist.

---

## 3. Quality Attribute Triangulation

Quality attribute priorities shift dramatically depending on the evidence source:

### Quality Attribute Ranking by Source

| Rank | KataLog (competition) | AOSA (infra production) | RealWorldASPNET (app production) | RefArch (teaching) |
|------|-----------------------|------------------------|----------------------------------|-------------------|
| 1 | Scalability (55/78) | Performance (5/12) | Extensibility (3/5) | Testability (4/8) |
| 2 | Security (40/78) | Extensibility (4/12) | Security (2/5) | Maintainability (3/8) |
| 3 | Availability (43/78) | Scalability (4/12) | Multi-tenancy (2/5) | Scalability (3/8) |
| 4 | Performance (41/78) | Modularity (3/12) | Modularity (2/5) | Deployability (3/8) |
| 5 | Evolvability (35/78) | Fault Tolerance (2/12) | Data Integrity (1/5) | Evolvability (2/8) |

### Cross-Source Insights

**Extensibility is the most undervalued quality attribute in design exercises.**

- AOSA: #2 (4 of 12 projects)
- RealWorldASPNET: #1 (3 of 5 projects)
- KataLog: rarely cited (buried under "Evolvability" umbrella)
- RefArch: not a primary focus

Combined across both production sources, extensibility appears in **7 of 17 production systems** (41%). In KataLog, it's an afterthought. The production reality is clear: long-lived systems must accommodate uses their creators never imagined, and extensibility (via plugins, passes, dialects, modules) is how they do it.

**The Scalability Trap is confirmed across sources.**

The KataLog cross-cutting analysis identified the "Scalability Trap" — first-place winners cite scalability *less often* (55%) than runners-up (68%). The production evidence explains why: AOSA and RealWorldASPNET systems achieve scalability through *specific mechanisms* (HDFS block replication, Riak consistent hashing, NGINX event loops, nopCommerce's caching layers) rather than through *architecture style selection*. Choosing Microservices "for scalability" is the design equivalent of choosing Kubernetes "for reliability" — the abstraction level is wrong.

**Multi-tenancy is a production-only concern.**

Two of 5 RealWorldASPNET projects and zero KataLog challenges address multi-tenancy. This is a common real-world architectural challenge that competition exercises entirely miss. Architects designing SaaS systems will find no guidance in the KataLog evidence.

**Testability is a teaching-only emphasis.**

Testability is the #1 quality attribute in Reference Architectures (4 of 8) but barely registers in production or competition. This reflects the purpose of reference implementations (teach good testing practices) rather than a real-world architectural priority. Production systems are tested, but testability is not typically a primary *architecture driver*.

**Cost/Feasibility is the strongest single-source predictor with zero cross-source support.**

The KataLog finding that cost/feasibility awareness is the strongest predictor of top-2 placement (4.5x more likely) is unsupported by any other source. No Reference Architecture includes cost analysis. No AOSA chapter discusses infrastructure costs. No RealWorldASPNET catalog quantifies operational spend. The practice most correlated with competition success has zero representation in the materials teams learn from.

---

## 4. The Practice-Evidence Gap

The cross-source analysis reveals a systematic disconnect: **the practices that most predict success in KataLog competition have the least support in teaching and production materials.**

| Practice | KataLog Evidence | RefArch Support | Production Exemplars | Gap |
|----------|-----------------|-----------------|---------------------|-----|
| **Feasibility/Cost Analysis** | Strongest single predictor (4.5x top-2 likelihood) | 0 of 8 include it | 0 of 17 include it | **Critical** |
| **ADR Discipline (15+ ADRs)** | 2nd-strongest predictor (73% of winners) | 1 of 8 has ADRs | N/A (different format) | **Critical** |
| **Fitness Functions** | 55% of 1st-place winners | 1 of 8 (ArchUnit tests) | 0 of 17 include them | **Severe** |
| **C4 Diagrams** | 55% of top-2 teams | N/A (code, not diagrams) | N/A | Moderate |
| **Evolutionary/Phased Approach** | 73% of winners propose 2+ styles | eShopOnContainers → eShop | Multiple AOSA refactors | Low (implicitly supported) |

### The Critical Practice Gap

The three highest-impact practices in KataLog — feasibility analysis, ADR discipline, and fitness functions — share a common trait: they are **meta-architectural practices** (practices *about* architecture decisions) rather than architecture *patterns*. They appear in:

- **0 of 8** Reference Architectures (for feasibility; 1 of 8 for ADRs; 1 of 8 for fitness functions)
- **0 of 17** production systems

This means teams learning architecture from reference codebases and production examples will see *what was built* but never *why it was built that way*, *what it costs to run*, or *how to verify it stays healthy*. The cross-source evidence strongly suggests that the largest opportunity for improving architecture outcomes is not adopting a different pattern but adopting these meta-practices — and that the teaching materials are systematically failing to demonstrate them.

---

## 5. Lifecycle-Stage Evidence Map

Each architecture style has evidence at different lifecycle stages. This map shows where each style has been validated and where gaps remain.

| Style | Design (KataLog) | Code (RefArch) | Production (AOSA + RealWorld) | Assessment |
|-------|:-:|:-:|:-:|---|
| **Event-Driven** | 47 teams | 5 repos | 5 systems | Full lifecycle coverage |
| **Service-Based** | 25 teams | 1 repo | 3 systems | Strong at design + production; weak code examples |
| **Plugin/Microkernel** | 2 teams | 0 repos | 6 systems | Strong production; no teaching materials |
| **Pipeline** | 0 teams | 0 repos | 6 systems | Production-only; invisible in design and teaching |
| **Microservices** | 39 teams | 5 repos | 0 systems | Design + code only; no production validation |
| **Modular Monolith** | 6 teams | 1 repo | 1 system | Thin but present at all stages |
| **CQRS/Event Sourcing** | 3 teams | 3 repos | 1 system | Code-heavy; thin design and production evidence |
| **Hexagonal/Clean** | 4 teams | 3 repos | 0 systems | Design + code; no production evidence |
| **Serverless** | 8 teams | 1 repo | 0 systems | Design + code; no production evidence |
| **DDD** | 4 teams | 3 repos | 0 systems | Design + code; no production evidence |
| **Multi-Agent** | 3 teams | 0 repos | 0 systems | Design-only; too new |
| **Space-Based** | 2 teams | 0 repos | 1 system | Thin everywhere |
| **Layered** | 0 teams | 0 repos | 1 system | Production-only; single exemplar |

### Lifecycle Coverage Gaps

**Patterns with strong production evidence but no design/teaching support:**
- Pipeline (6 production, 0 elsewhere)
- Plugin (6 production, 0 teaching, 2 design)

These patterns need: reference implementations showing how to build them, and inclusion in architecture kata guidance so teams consider them.

**Patterns with strong design/teaching evidence but no production validation:**
- Microservices (39 design, 5 teaching, 0 production)
- Hexagonal/Clean (4 design, 3 teaching, 0 production)
- Serverless (8 design, 1 teaching, 0 production)

These patterns need: production case studies demonstrating operational viability at scale.

**Pattern with evidence at all stages but thin everywhere:**
- Modular Monolith (6 design, 1 teaching, 1 production)

Despite the highest KataLog win rate (83.3%), the total evidence base is only 8 entries. This is the strongest candidate for expanded evidence collection.

---

## Cross-Source Findings Summary

### Finding 1: The Plugin/Pipeline Blind Spot

The two most common production patterns (Pipeline: 6/17, Plugin: 6/17) are the two most absent from architecture design exercises (Pipeline: 0/78, Plugin: 2/78) and teaching materials (both: 0/8). **The patterns that production systems actually use are invisible in the materials architects learn from.**

**Evidence depth**: T3 (AOSA + RealWorldASPNET + partial KataLog). High confidence.

### Finding 2: The Microservices Inversion

Microservices is the #2 pattern by competition popularity (39/78 teams) and #1 by reference implementation count (5 repos), but has **zero production evidence** across 17 production systems spanning AOSA and RealWorldASPNET. Even Bitwarden, with 9 independently versioned services, identifies as Service-Based.

This does not mean Microservices doesn't work in production (Netflix, Amazon, and Google famously use it). It means the evidence base lacks production exemplars for this style, which is the highest-priority gap for future collection.

**Evidence depth**: T2 (KataLog + RefArch only). Moderate confidence — tempered by known production use outside the evidence base.

### Finding 3: Event-Driven Means Different Things

Event-Driven is the only T4 (fully validated) pattern, but it means something different at each lifecycle stage:
- **Competition**: A primary architecture style label
- **Teaching**: An integration mechanism between bounded contexts
- **Production infrastructure**: Non-blocking I/O and concurrency (NGINX reactor, Twisted reactor)
- **Production applications**: Audit trails (Squidex event sourcing) and cross-service coordination (Bitwarden AMQP)

Teams should specify *which* Event-Driven they mean: messaging topology, data model (event sourcing), concurrency model (event loop), or integration pattern.

**Evidence depth**: T4 (all four sources). Very high confidence.

### Finding 4: The Practice-Evidence Gap

The three practices most predictive of KataLog success — feasibility analysis (4.5x top-2 likelihood), ADR discipline (winners average 15 ADRs), and fitness functions (55% of winners) — have near-zero representation in teaching and production materials. Teams learn *what* to build from reference implementations but not *why* to build it, *what it costs*, or *how to verify it stays healthy*.

**Evidence depth**: T1 (KataLog only for the success correlation). Low-to-moderate confidence — the practices are well-established in architecture literature but their competitive advantage is validated only by KataLog data.

### Finding 5: Extensibility Is the Hidden Quality Attribute

Extensibility (via plugins, passes, dialects, modules) appears in 7 of 17 production systems (41%) as a primary quality attribute but is rarely cited in competition entries. Production systems that survive a decade need to accommodate uses their creators never imagined. Extensibility is how they do it — and it's architecturally significant because it drives pattern choices (Plugin, Pipeline, Modular Architecture).

**Evidence depth**: T2 (AOSA + RealWorldASPNET). High confidence within production evidence; low visibility in design contexts.

### Finding 6: Modular Monolith — Strongest Signal, Thinnest Evidence

Modular Monolith has the highest KataLog win rate (83.3%), has production validation (Orchard Core), and has a code-level reference (kgrzybek's project) — but only 8 total entries across all sources. It is the pattern where the signal-to-noise ratio is highest but the sample size is lowest. Expanding this evidence base (more production exemplars, more reference implementations in Java/Go/Python) would either confirm or temper the strongest finding in the dataset.

**Evidence depth**: T3 (KataLog + RealWorld + RefArch). Moderate confidence — directionally strong but small n.

---

## Methodology Notes

- **Source analysis dependencies**: This document is derived from the four 1st-degree source analyses:
  - `evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md` (78 teams)
  - `evidence-analysis/AOSA/docs/analysis/source-analysis.md` (12 projects)
  - `evidence-analysis/ReferenceArchitectures/docs/analysis/source-analysis.md` (8 repos)
  - `evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md` (5 projects)
- **Weighted scoring**: The Combined Weighted Scoreboard and Production Evidence Share tables are in [cross-source-reference.md](cross-source-reference.md).
- **Triangulation counting**: "Production systems" counts combine AOSA (12) and RealWorldASPNET (5) for a total of 17. Production adoption percentages use this base.
- **Limitations**:
  - The production evidence base (17 systems) is small. Pipeline at 6/17 is directionally strong but not statistically conclusive.
  - AOSA projects (2011--2012) predate Microservices, Serverless, and cloud-native patterns. Their absence from AOSA may partly reflect era rather than production unsuitability.
  - RealWorldASPNET is .NET-only. Production patterns in Go, Java, Python, and Rust ecosystems may differ.
  - KataLog competition scoring varies by season and judge panel. Cross-season comparisons should be treated as approximate.

---

*Generated: 2026-02-26. Derived from structured YAML catalogs and 1st-degree source analyses across all four evidence sources.*
