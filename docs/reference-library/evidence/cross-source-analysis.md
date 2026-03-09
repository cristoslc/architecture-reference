# Cross-Source Analysis: Production Evidence Across 279 Architecture Sources

## Purpose

This document synthesizes findings across all evidence sources into cross-source insights that no single source can produce. The analytical framework is grounded in production evidence primacy: Discovered production repos (142 entries) and AOSA/RealWorld systems (17 systems) constitute the primary evidence base. KataLog competition designs (78 teams) and reference implementations (42 entries) provide qualitative annotation — valuable for understanding reasoning and practices, but not for ranking patterns.

The [cross-source-reference.md](cross-source-reference.md) provides the lookup tables and primary Discovered Frequency Rankings; this document provides the *analytical framework* and *derived findings*.

---

## Analysis Framework

### The Production Evidence Model

Production code is the primary evidence for architecture patterns. Sources are classified by their relationship to real-world systems:

```
   PRIMARY EVIDENCE                          ANNOTATION
   ────────────────                          ──────────
   Discovered (142 prod repos)               KataLog (78 teams)
   "What developers actually ship"           "What teams propose and why"
   Statistical breadth, multi-language       ADR reasoning, judge commentary

   AOSA (12) + RealWorldASPNET (5)           Reference Impls (42 repos)
   "What survives at scale, told             "How to teach the pattern"
    by its creators"                          Sample domains, annotation only
   Narrative depth, highest per-system
   authority
```

A pattern validated in 83 production repos (Microkernel) carries fundamentally higher confidence than one proposed by 47 competition teams (Event-Driven in KataLog). The number of *sources* mentioning a pattern matters less than the *nature* of that evidence — production code outweighs unbuilt designs regardless of source count.

> **Detection bias:** Discovered statistics are derived from deep-analysis source code inspection. Styles and quality attributes that leave strong code signals are more reliably detected. Styles and quality attributes that are architectural decisions invisible in code (performance tuning, testability strategies, interoperability contracts) are underdetected. KataLog competition evidence fills this specific gap — teams documented these invisible decisions in ADRs and presentations.

### Evidence Confidence Tiers

Confidence is based on **production evidence strength**, not source count. A pattern validated across 83 production repos with 6 deep case studies has higher confidence than one mentioned across 5 sources but never built.

| Tier | Criteria | Label | Confidence | Example |
|------|----------|-------|------------|---------|
| **T1** | Discovered production frequency + AOSA/RealWorld depth | Production-validated | Highest — statistical breadth confirmed by expert-authored case studies | Microkernel (83 Discovered repos + 6 AOSA/RealWorld systems) |
| **T2** | Discovered production frequency only | Code-validated | High — real production code verified by deep-analysis, but no published case study | Layered (78 Discovered repos, 1 RealWorld), Modular Monolith (57 repos, 1 RealWorld) |
| **T3** | AOSA/RealWorld only | Narrative-validated | Moderate — deep but small sample, may predate modern patterns | (No current styles fall here exclusively — all AOSA/RealWorld styles now also have Discovered presence) |
| **T4** | KataLog/RefArch only | Annotation-only | Low — never-built designs or teaching code, no production evidence | Serverless (8 KataLog teams, 0 Discovered, 0 AOSA/RealWorld) |

### Style Confidence Assessment

| Style | Discovered | AOSA/RealWorld | Tier | Assessment |
|-------|-----------|---------------|------|------------|
| **Microkernel** | 83 (58.5%) | 6 systems | T1 | Highest confidence. Statistical dominance confirmed by deep case studies. |
| **Pipeline** | 13 (9.2%) | 6 systems | T1 | High confidence. Strong production depth relative to code frequency. |
| **Event-Driven** | 17 (12.0%) | 5 systems | T1 | High confidence, but narrower in code than competition popularity suggests. |
| **Service-Based** | 7 (4.9%) | 3 systems | T1 | Moderate-to-high confidence. Production depth validates modest code frequency. |
| **Layered** | 78 (54.9%) | 1 system | T2 | High confidence. Massive code-level breadth; thin production depth narrative. |
| **Modular Monolith** | 57 (40.1%) | 1 system | T2 | High confidence. Broad code validation; strongest candidate for depth expansion. |
| **CQRS** | 1 (0.7%) | 1 system | T1/T2 | Low-to-moderate. Thin after tutorial bias correction; Squidex is the sole exemplar. |
| **Space-Based** | 1 (0.7%) | 1 system | T1/T2 | Low-to-moderate. Thin but present at production scale (Riak, dragonfly). |
| **Microservices** | 12 (8.5%) | 0 systems | T2 | Moderate. Code presence confirmed but zero AOSA/RealWorld depth. Known production use outside corpus (Netflix, Amazon). |
| **Hexagonal/Clean** | 5 (3.5%) | 0 systems | T2 | Low-to-moderate. Small code presence after tutorial correction. |
| **DDD** | 3 (2.1%) | 0 systems | T2 | Low. Dramatically deflated after tutorial bias correction. |
| **Multi-Agent** | 1 (0.7%) | 0 systems | T2/T4 | Low. Emerging pattern; only AutoGPT (182k stars) in production. |
| **Serverless** | 0 (0%) | 0 systems | T4 | Lowest. Zero production evidence across all sources. 8 KataLog teams only. |

### Analysis Dimensions

The cross-source analysis examines five dimensions:

1. **Production Frequency and Validation** — What does production code tell us about pattern prevalence, validated by depth narratives?
2. **The Proposal-Production Gap** — What do people propose (KataLog) vs what actually exists in production (Discovered + AOSA/RealWorld)?
3. **Quality Attribute Evidence** — How do quality attribute priorities differ between production code and competition designs?
4. **Practice Evidence** — Which practices predict success but are invisible in code?
5. **Evidence Coverage Map** — Where does production evidence exist and where do gaps remain?

---

## 1. Production Frequency and Validation

### The Production Landscape

The Discovered corpus (142 production repos, deep-validated via SPEC-022 deep-analysis) reveals a production landscape starkly different from what competition data alone would suggest. Three styles dominate production code:

| Rank | Style | Discovered (142) | AOSA/RealWorld (17) | Combined Production Signal |
|------|-------|------------------|--------------------|----|
| 1 | **Microkernel** | 83 (58.5%) | 6 systems (35%) | Dominant in both breadth and depth |
| 2 | **Layered** | 78 (54.9%) | 1 system (6%) | Dominant breadth, thin depth |
| 3 | **Modular Monolith** | 57 (40.1%) | 1 system (6%) | Strong breadth, thin depth |
| 4 | **Event-Driven** | 17 (12.0%) | 5 systems (29%) | Moderate breadth, strong depth |
| 5 | **Pipeline** | 13 (9.2%) | 6 systems (35%) | Moderate breadth, strong depth |

The top three styles (Microkernel, Layered, Modular Monolith) frequently co-occur in the same repositories. A well-structured application with clear layer separation, modular boundaries, and a plugin system would be classified under all three — and this is in fact the dominant pattern in production open-source software.

### AOSA/RealWorld Depth Validates Discovered Breadth

Where both sources have evidence, they converge:

- **Microkernel**: AOSA describes LLVM's pass system, SQLAlchemy's dialect framework, GStreamer's element registry. Discovered confirms this pattern in 83 production repos across compilers, ORMs, multimedia, build tools, monitoring, and more.
- **Pipeline**: AOSA describes NGINX's filter chain, LLVM's compilation pipeline, ZeroMQ's message pipeline. Discovered confirms Pipeline in 13 production repos including data processing frameworks (Airflow, dify, langchain) and network proxies (traefik).
- **Event-Driven**: AOSA describes NGINX's event loop, Twisted's reactor, ZeroMQ's messaging. Discovered finds Event-Driven in 17 repos — narrower than the 28.8% previously estimated, as deep-analysis corrected over-classification from message broker presence.

### Where Depth and Breadth Diverge

- **Pipeline**: 6 AOSA/RealWorld systems (35%) but only 13 Discovered repos (9.2%). Pipeline may be underdetected in code (processing stages don't always have distinctive structural signatures) or genuinely concentrated in infrastructure software.
- **Event-Driven**: 5 AOSA/RealWorld systems (29%) but only 17 Discovered repos (12.0%). Production systems use events tactically; the pattern's code-level footprint is smaller than its architectural significance.
- **Modular Monolith**: 57 Discovered repos (40.1%) but only 1 AOSA/RealWorld system. The code-level evidence far outstrips available depth narratives — this is the strongest candidate for expanded production case study collection.

---

## 2. The Proposal-Production Gap

The most consequential finding from cross-source analysis: **the patterns teams propose in design exercises diverge sharply from the patterns that dominate production systems.** This is not a gap between equal sources — it is a gap between aspiration and reality, between what people think they should build and what actually gets built and survives.

### The Gap Quantified

| Style | KataLog Proposals | Discovered Production | AOSA/RealWorld Production | Gap Profile |
|-------|------------------|----------------------|--------------------------|-------------|
| **Microkernel** | 2.6% (2/78) | 58.5% (83/142) | 35% (6/17) | Massively under-proposed; dominates production |
| **Layered** | 0% (0/78) | 54.9% (78/142) | 6% (1/17) | Invisible in design; second most prevalent in production |
| **Modular Monolith** | 8% (6/78) | 40.1% (57/142) | 6% (1/17) | Under-proposed; dominates well-structured code |
| **Pipeline** | 0% (0/78) | 9.2% (13/142) | 35% (6/17) | Invisible in design; proven in production |
| **Event-Driven** | 60% (47/78) | 12.0% (17/142) | 29% (5/17) | Over-proposed; narrower in code than design suggests |
| **Microservices** | 50% (39/78) | 8.5% (12/142) | 0% (0/17) | Over-proposed; zero depth validation |
| **Service-Based** | 32% (25/78) | 4.9% (7/142) | 18% (3/17) | Roughly aligned across sources |
| **Serverless** | 10% (8/78) | 0% (0/142) | 0% (0/17) | Proposed but nonexistent in production |
| **DDD** | 5% (4/78) | 2.1% (3/142) | 0% (0/17) | Tutorial bias corrected; actual adoption low |

### Three Gap Profiles

**1. Production-dominant, design-invisible.** Microkernel (58.5% of production, 2.6% of proposals), Layered (54.9% of production, 0% of proposals), and Pipeline (9.2% of production with 35% depth, 0% of proposals). These are the workhorses of production software that teams don't think to propose. The prior code-invisibility of Microkernel was a detection artifact fully resolved by deep-analysis.

**2. Design-popular, production-thin.** Microservices (50% of proposals, 8.5% of production, 0% depth) and Serverless (10% of proposals, 0% production). These patterns dominate architecture conference talks and competition entries but have thin or zero production evidence in the corpus. Competition teams default to trendy patterns without production validation.

**3. Tutorial-inflated then corrected.** DDD (17.8% to 2.1%), CQRS (10.4% to 0.7%), Hexagonal (12.3% to 3.5%). These patterns had inflated Discovered presence under prior methodology due to reference/tutorial implementations counted alongside production. ADR-002 tutorial bias correction revealed their actual production adoption to be significantly lower.

### Why the Gap Exists

Four structural factors explain the divergence:

**1. Recency bias in competition.** Microservices and Serverless became named patterns in the mid-2010s and dominate architecture conference talks, books, and certification curricula. Competition teams draw from this recent discourse. AOSA projects (2011-2012) predate the microservices naming, and most production systems evolved organically rather than being designed from a pattern catalog.

**2. Problem-domain mismatch.** KataLog challenges describe user-facing business systems (e-commerce, healthcare, travel, HR) where Microservices and Event-Driven map intuitively. AOSA covers infrastructure software (web servers, compilers, databases) where Pipeline and Microkernel solve the actual problems. Discovered spans both domains (87 platforms, 55 applications), which is why it shows counts for *both* competition-popular patterns (Microservices: 12) and production-popular patterns (Pipeline: 13, Microkernel: 83).

**3. Operational complexity filter.** Production systems shed patterns that don't justify their operational cost. Microservices require service mesh, distributed tracing, independent CI/CD pipelines, and a platform team to sustain. Production teams that could use these patterns (Bitwarden with 9 services) choose simpler decomposition (Service-Based) because the operational overhead of full microservice independence isn't worth it.

**4. Detection bias (substantially resolved by SPEC-022).** Prior automated discovery favored patterns with visible structural signals. SPEC-022 deep-analysis resolved multiple blind spots: Microkernel went from 0% (heuristic) to 58.5%; Layered rose from 19.0% to 54.9%; Event-Driven dropped from 33.1% to 12.0% as over-classification was corrected.

### Implication for Practitioners

When choosing an architecture style, competition-winning patterns are not automatically the right production choice. The production evidence suggests a **three-step evaluation**:

1. **Check the production frequency.** The Discovered Frequency Rankings in [cross-source-reference.md](cross-source-reference.md) show what actually gets built. Styles with zero or near-zero production entries should be adopted with awareness that no production system in the evidence base uses them as a primary organizing principle.

2. **Check for production depth narratives.** AOSA/RealWorld systems provide the *how* and *why* of production patterns. A style with both frequency and depth (Microkernel: 83 repos + 6 case studies) carries higher confidence than one with frequency alone.

3. **Check the competition reasoning, not the competition ranking.** KataLog's value is not which patterns rank highest, but *why* teams chose them and *how* judges evaluated trade-offs. The ADR reasoning from competition entries is genuinely useful — as annotation on production-validated patterns.

---

## 3. Quality Attribute Evidence

Quality attribute priorities shift dramatically depending on whether evidence comes from production code or competition proposals.

### Quality Attribute Ranking by Source

| Rank | Discovered (142 prod) | AOSA (infra production) | RealWorldASPNET (app production) | KataLog (competition) |
|------|-----------------------|------------------------|----------------------------------|-----------------------|
| 1 | Deployability (88.7%) | Performance (5/12) | Extensibility (3/5) | Scalability (55/78) |
| 2 | Modularity (26.8%) | Extensibility (4/12) | Security (2/5) | Security (40/78) |
| 3 | Scalability (23.2%) | Scalability (4/12) | Multi-tenancy (2/5) | Availability (43/78) |
| 4 | Fault Tolerance (14.1%) | Modularity (3/12) | Modularity (2/5) | Performance (41/78) |
| 5 | Observability (3.5%) | Fault Tolerance (2/12) | Data Integrity (1/5) | Evolvability (35/78) |

### Production-Led Quality Attribute Insights

**Deployability dominates production code.** At 88.7% detection in Discovered repos, Deployability (containerization, CI/CD, infrastructure-as-code) is the quality attribute most visibly present in production codebases. This is partly a detection artifact — Docker files and CI configs leave strong code signals — but it reflects a genuine production priority largely absent from competition designs.

**Extensibility is the most undervalued quality attribute in design exercises.** Combined across both production depth sources, extensibility appears in 7 of 17 production systems (41%) as a primary quality attribute but is rarely cited in KataLog entries. Production systems that survive a decade need to accommodate uses their creators never imagined, and extensibility (via plugins, passes, dialects, modules) is how they do it.

**The Scalability Trap is confirmed.** KataLog's own data shows first-place winners cite scalability *less often* (55%) than runners-up (68%). The production evidence explains why: AOSA and RealWorldASPNET systems achieve scalability through *specific mechanisms* (HDFS block replication, Riak consistent hashing, NGINX event loops) rather than through *architecture style selection*. Choosing Microservices "for scalability" is the design equivalent of choosing Kubernetes "for reliability" — the abstraction level is wrong.

**Multi-tenancy is a production-only concern.** Two of 5 RealWorldASPNET projects and zero KataLog challenges address multi-tenancy. Discovered adds a few multi-tenant SaaS platforms but multi-tenancy remains underrepresented relative to its real-world importance.

**Testability is a teaching-only emphasis.** Testability is the #1 quality attribute in Reference Architectures (4 of 8) but barely registers in production, competition, or Discovered sources.

> **Detection bias caveat:** Quality attributes that leave strong code signals (Deployability, Modularity) are reliably detected in Discovered repos. Quality attributes that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this specific gap — teams documented these invisible quality priorities in ADRs and presentations.

**Cost/Feasibility is the strongest single-source predictor with zero cross-source support.** KataLog finds that cost/feasibility awareness is the strongest predictor of top-2 placement (4.5x more likely), yet no other source — production, code-level, or teaching — addresses it. The practice most correlated with competition success has zero representation in the materials teams learn from.

---

## 4. Practice Evidence: KataLog's Genuine Contribution

KataLog's unique and genuinely valuable contribution is evidence about **meta-architectural practices** — practices *about* architecture decisions that are invisible in source code. This is KataLog's strength precisely because these practices cannot be detected through code inspection.

| Practice | KataLog Evidence | Production/Code Presence | Gap Severity |
|----------|-----------------|-------------------------|-------------|
| **Feasibility/Cost Analysis** | Strongest single predictor (4.5x top-2 likelihood) | 0 of 17 production systems; 0 of 142 Discovered repos | **Critical** |
| **ADR Discipline (15+ ADRs)** | 2nd-strongest predictor (73% of winners) | ~5 of 142 Discovered repos have ADR directories | **Critical** |
| **Fitness Functions** | 55% of 1st-place winners | ~3 of 142 repos have ArchUnit/fitness tests | **Severe** |
| **C4 Diagrams** | 55% of top-2 teams | N/A (code, not diagrams) | Moderate |
| **Evolutionary/Phased Approach** | 73% of winners propose 2+ styles | Some repos show migration patterns | Low |

### Why These Practices Matter

The three highest-impact KataLog practices — feasibility analysis, ADR discipline, and fitness functions — share a common trait: they are meta-architectural practices (practices *about* architecture decisions) rather than architecture *patterns*. They appear in:

- **0 of 17** production systems (for feasibility; near-zero for the others)
- **~5 of 142** Discovered production repos (only a handful include ADR directories; fitness function adoption is negligible)

Discovered data confirms what the production evidence base suggested: the gap is real and systemic. Even in a sample of 142 production open-source repositories — many of which are well-engineered projects with tens of thousands of stars — meta-architectural practices are nearly absent. Teams learn *what* to build from reference implementations and open-source examples but not *why* to build it, *what it costs to run*, or *how to verify it stays healthy*.

This is KataLog's most important contribution to the evidence base. Not style rankings (which should be led by production evidence), but the documentation that these invisible practices correlate with design quality — even though they are absent from production code, absent from teaching materials, and absent from case study narratives.

---

## 5. Evidence Coverage Map

This map shows where production evidence exists and where gaps remain. Gaps are defined as places where we lack Discovered + AOSA/RealWorld production data.

### Production Evidence Landscape

| Style | Discovered (CODE) | AOSA/RealWorld (DEPTH) | KataLog (ANNOTATION) | Production Status |
|-------|:-:|:-:|:-:|---|
| **Microkernel** | 83 repos (58.5%) | 6 systems | 2 teams | Full production evidence; dominant |
| **Layered** | 78 repos (54.9%) | 1 system | 0 teams | Strong code evidence; depth gap |
| **Modular Monolith** | 57 repos (40.1%) | 1 system | 6 teams | Strong code evidence; depth gap (highest priority for expansion) |
| **Event-Driven** | 17 repos (12.0%) | 5 systems | 47 teams | Full production evidence; annotation-heavy |
| **Pipeline** | 13 repos (9.2%) | 6 systems | 0 teams | Full production evidence; annotation gap |
| **Microservices** | 12 repos (8.5%) | 0 systems | 39 teams | Code evidence only; depth gap (highest priority) |
| **Service-Based** | 7 repos (4.9%) | 3 systems | 25 teams | Full production evidence; thin |
| **Hexagonal/Clean** | 5 repos (3.5%) | 0 systems | 4 teams | Thin code evidence after tutorial correction |
| **DDD** | 3 repos (2.1%) | 0 systems | 4 teams | Thin code evidence after tutorial correction |
| **CQRS** | 1 repo (0.7%) | 1 system | 3 teams | Thin; Squidex sole exemplar |
| **Space-Based** | 1 repo (0.7%) | 1 system | 2 teams | Thin but present at production scale |
| **Multi-Agent** | 1 repo (0.7%) | 0 systems | 3 teams | Emerging; only AutoGPT in production |
| **Serverless** | 0 repos (0%) | 0 systems | 8 teams | **No production evidence.** Annotation only. |

### SPEC-022 Detection Improvements

The most impactful contribution of SPEC-022 deep-analysis is dramatically improving production code detection accuracy and correcting tutorial bias:

| Style | Heuristic | SPEC-019 | SPEC-022 (current) | Change |
|-------|-----------|----------|---------------------|--------|
| **Microkernel** | 0% | 20.2% | 58.5% | Detection artifact fully resolved |
| **Layered** | 19.0% | 21.5% | 54.9% | Deep-analysis identifies layer separation |
| **Event-Driven** | 33.1% | 28.8% | 12.0% | Over-classification corrected |
| **DDD** | -- | 17.8% | 2.1% | Tutorial bias corrected |
| **CQRS** | -- | 10.4% | 0.7% | Tutorial bias corrected |
| **Hexagonal** | -- | 12.3% | 3.5% | Tutorial bias corrected |

### Priority Gaps for Future Evidence Collection

**Highest priority — production depth narratives needed:**
- **Modular Monolith** (57 Discovered repos, 1 AOSA/RealWorld exemplar). Despite the highest KataLog win rate (83.3%) and massive code-level breadth, production depth evidence is limited to Orchard Core.
- **Microservices** (12 Discovered repos, 0 AOSA/RealWorld exemplars). Known production use outside evidence base (Netflix, Amazon, Google) but no exemplar in corpus.

**Medium priority — production code gaps:**
- **Pipeline** and **Layered** have zero design-phase annotation (0 KataLog teams). These production-dominant patterns need inclusion in architecture kata guidance.

**Low priority — thin production evidence:**
- **DDD**, **CQRS**, **Hexagonal** have thin production evidence after tutorial bias correction. Their actual production adoption is lower than previously estimated.

---

## Cross-Source Findings Summary

### Finding 1: Production Code Reveals a Different Architecture Landscape

The three most prevalent styles in production code (Microkernel 58.5%, Layered 54.9%, Modular Monolith 40.1%) are among the least proposed in competition designs (2.6%, 0%, 8% respectively). The production architecture landscape is dominated by plugin systems, layered separation, and modular boundaries — patterns that are foundational rather than fashionable.

**Confidence:** T1 (Discovered + AOSA/RealWorld). Highest.

### Finding 2: The Microservices Inversion

Microservices is the #2 pattern by competition popularity (39/78 teams) but #6 in production code (12/142 repos, 8.5%) with zero AOSA/RealWorld depth. Predominantly a platform pattern (13% of platforms vs 2% of applications). Even Bitwarden, with 9 independently versioned services, identifies as Service-Based rather than Microservices.

This does not mean Microservices doesn't work in production — Netflix, Amazon, and Google famously use it. It means the evidence base lacks production exemplars, making this the highest-priority gap for future collection.

**Confidence:** T2 (Discovered code-validated, no depth narrative). Moderate — tempered by known production use outside the evidence base.

### Finding 3: Event-Driven Means Different Things

Event-Driven is the most competition-popular pattern (47/78 teams, 60%) but ranks #4 in production code (17/142 repos, 12.0%). It is validated by 5 AOSA/RealWorld systems, confirming genuine production use — but the *nature* of that use differs from competition proposals:

- **Competition proposals**: Event-Driven as a primary architecture style label
- **Production infrastructure**: Non-blocking I/O and concurrency (NGINX reactor, Twisted reactor)
- **Production applications**: Audit trails (Squidex event sourcing) and cross-service coordination (Bitwarden AMQP)
- **Production code**: Message broker integration (Kafka, RabbitMQ, NATS) — tactical, not structural

Teams should specify *which* Event-Driven they mean: messaging topology, data model (event sourcing), concurrency model (event loop), or integration pattern.

**Confidence:** T1 (Discovered + AOSA/RealWorld). Highest.

### Finding 4: Meta-Practices Are KataLog's Real Contribution

The three practices most predictive of KataLog success — feasibility analysis (4.5x top-2 likelihood), ADR discipline (winners average 15 ADRs), and fitness functions (55% of winners) — have near-zero representation in production code, teaching materials, or case study narratives. Discovered confirms this across 142 repos: fewer than 5 include ADR directories and fewer than 3 include fitness function tests.

KataLog's genuine contribution to the evidence base is not style ranking (which should be led by production evidence) but documentation of meta-architectural practices that are invisible in code yet correlated with design quality.

**Confidence:** KataLog-only for the success correlation. Low-to-moderate — the practices are well-established in architecture literature but their competitive advantage is validated only by competition data.

### Finding 5: Extensibility Is the Hidden Quality Attribute

Extensibility (via plugins, passes, dialects, modules) appears in 7 of 17 production systems (41%) as a primary quality attribute but is rarely cited in competition entries. Production systems that survive a decade need to accommodate uses their creators never imagined. Extensibility is how they do it — and it drives pattern choices (Microkernel, Pipeline, Modular Architecture).

**Confidence:** T1 (AOSA + RealWorldASPNET, validated by Discovered plugin-system prevalence). High confidence within production evidence.

### Finding 6: Modular Monolith — Broadest Code Validation, Thinnest Production Depth

Modular Monolith has the highest KataLog win rate (83.3%), 57 production Discovered repos (40.1%), implementation across multiple languages (Django, Spring Boot, .NET, Go, TypeScript, Python) — but only 1 AOSA/RealWorld production exemplar (Orchard Core). The gap between code-level breadth and available production depth narratives makes this the strongest candidate for expanded production evidence collection.

**Confidence:** T2 (Discovered code-validated, thin depth). High confidence directionally — the code evidence is overwhelming — but lacking the creator-authored narratives that would elevate to T1.

---

## Methodology Notes

- **Source analysis dependencies**: This document is derived from the evidence source analyses:
  - `evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md` (78 teams)
  - `evidence-analysis/AOSA/docs/analysis/source-analysis.md` (12 projects)
  - `evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md` (5 projects)
  - `evidence-analysis/Discovered/_index.yaml` and `quality-report.md` (142 production + 42 reference = 184 repos, deep-validated via SPEC-022 deep-analysis, ADR-002 recomputed)
- **Primary ranking**: The Discovered Frequency Rankings in [cross-source-reference.md](cross-source-reference.md) are the primary scoreboard. AOSA/RealWorld provides production depth validation. KataLog and RefArch provide annotation.
- **Production evidence counting**: "Production systems" counts combine AOSA (12) and RealWorldASPNET (5) for a total of 17. "Code-level repos" uses Discovered production (142). Reference implementations (42) serve as annotation examples.
- **Style name mapping**: SPEC-022 uses canonical style names: "Pipeline" (was "Pipe-and-Filter"), "Microkernel" (was "Plugin/Microkernel"). ADR-001 mandates equal weighting across all production entries.
- **Limitations**:
  - The AOSA/RealWorld production evidence base (17 systems) is small. Pipeline at 6/17 is directionally strong but not statistically conclusive.
  - AOSA projects (2011-2012) predate Microservices, Serverless, and cloud-native patterns. Their absence from AOSA may partly reflect era rather than production unsuitability.
  - RealWorldASPNET is .NET-only. Production patterns in Go, Java, Python, and Rust ecosystems may differ.
  - KataLog competition scoring varies by season and judge panel. Cross-season comparisons should be treated as approximate.
  - Discovered entries are deep-validated via SPEC-022 deep-analysis with ADR-002 recomputation. Multi-style assignments may introduce counting artifacts. Zero entries remain Indeterminate. Reference implementations are excluded from frequency counts to correct tutorial bias.
  - Detection bias: styles and quality attributes that leave strong code signals are more reliably detected. Styles invisible in code (architectural decisions, performance strategies, interoperability contracts) are underdetected. This is a known limitation of code-based evidence, partially mitigated by KataLog's documentation of invisible decisions.

---

*Generated: 2026-03-09. Derived from structured YAML catalogs and source analyses across all evidence sources (279 total entries: 142 Discovered production + 42 Discovered reference + 12 AOSA + 5 RealWorld + 78 KataLog). Primary ranking: Discovered Frequency Rankings (SPEC-022 deep-analysis, ADR-002 recomputed). Production depth: AOSA/RealWorld (17 systems). Annotation: KataLog (78 teams) + RefArch (42 repos). Zero Indeterminate entries.*
