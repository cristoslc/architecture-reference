# Cross-Source Analysis: Triangulating Evidence Across 266 Architecture Sources

## Purpose

This document synthesizes findings from the five independent evidence source analyses into cross-source insights that no single source can produce. The [cross-source-reference.md](cross-source-reference.md) provides the lookup tables and weighted scoreboard; this document provides the *analytical framework* and the *derived findings*.

---

## Analysis Framework

### The Five-Source Triangulation Model

Each evidence source observes architecture from a different vantage point in the system lifecycle:

```
   DESIGN                     CODE                      PRODUCTION
   ──────                     ────                      ──────────
   TheKataLog (78)    →   Reference Impls (8)   →   AOSA (12) + RealWorldASPNET (5)
   "What judges reward"   "How to build it"         "What survives at scale"
                               ↑
                       Discovered (163)
                       "What developers actually build"

   Competition designs      Teaching codebases         Real users, real failures,
   with placement data      with sample domains        real operational pressure
                            + 163 open-source repos
                            deep-validated via source
                            code inspection (SPEC-019)
```

A pattern validated at all three lifecycle stages carries fundamentally higher confidence than one validated at only one. The framework classifies each insight by **evidence depth** — the number of independent sources that support it.

The addition of Discovered (163 repos, deep-validated via source code inspection per SPEC-019) expands the CODE stage from 8 reference implementations to 171 code-level entries, filling the most significant gap in the original four-source model.

### Evidence Depth Tiers

| Tier | Sources | Label | Confidence | Example |
|------|---------|-------|------------|---------|
| **T1** | 1 source | Single-source | Low — may reflect source bias | Serverless in Discovered (3 entries — thin representation) |
| **T2** | 2 sources | Corroborated | Moderate — validated from two vantage points | Multi-Agent (KataLog + Discovered) |
| **T3** | 3 sources | Triangulated | High — consistent across design, code, and production | Pipeline (AOSA + RealWorld + Discovered) |
| **T4** | 4 sources | Strongly validated | Very high — converged across most evidence types | Modular Monolith (KataLog + RealWorld + RefArch + Discovered) |
| **T5** | 5 sources | Fully validated | Highest — converged across all evidence types | Event-Driven (all five sources) |

### Analysis Dimensions

The cross-source analysis examines five dimensions:

1. **Style Convergence/Divergence** — Where do sources agree and disagree on which patterns matter?
2. **The Design-Production Gap** — What's popular in competition but absent in production, and vice versa?
3. **Quality Attribute Triangulation** — How do quality attribute priorities shift across the lifecycle?
4. **Practice-Evidence Gap** — Which practices predict success but lack support in teaching materials?
5. **Lifecycle-Stage Evidence** — Which patterns have evidence at which lifecycle stages?

---

## 1. Style Convergence and Divergence

### T5: Styles Validated Across All Five Sources

**Event-Driven** is the only pattern appearing in all five evidence sources. It is the single most broadly validated pattern in the dataset.

| Source | Event-Driven Evidence |
|--------|----------------------|
| **KataLog** | 47 of 78 teams (60%); 9 of 11 first-place winners; highest weighted score (94) |
| **AOSA** | NGINX (30% of web traffic), Twisted (Python networking), ZeroMQ (financial trading) |
| **RealWorldASPNET** | Squidex (event sourcing), Bitwarden (AMQP cross-service events) |
| **RefArch** | eShopOnContainers, eShop, Modular Monolith w/DDD, Serverless Microservices, Wild Workouts |
| **Discovered** | 47 of 163 repos (28.8%) — the second most common style after Modular Monolith. Notable projects: AutoGPT (182k stars), n8n (177k), dify (131k), elasticsearch (76k), appwrite (55k). Spans Kafka-based stream processing, RabbitMQ message buses, event sourcing frameworks, and reactive systems |

**Cross-source insight**: Event-Driven is universally adopted, but its *role* shifts across the lifecycle:

- In **design** (KataLog): chosen as the primary organizing principle — "our system is event-driven"
- In **teaching** (RefArch): demonstrated as an integration pattern between bounded contexts
- In **production** (AOSA/RealWorld): used for specific technical purposes — non-blocking I/O (NGINX reactor, Twisted reactor), immutable audit trails (Squidex event sourcing), cross-service coordination (Bitwarden AMQP)
- In **open-source code** (Discovered): message queues, event buses, and pub/sub patterns appear in 28.8% of all deep-validated repositories

The evidence suggests that teams proposing "Event-Driven Architecture" as a primary style should specify *which aspect* they mean: event-based communication, event sourcing as data model, event-loop concurrency, or integration pattern. Production systems use events tactically; competition teams often adopt the label strategically. Discovered confirms this: most repos classified as Event-Driven use message brokers (Kafka, RabbitMQ, NATS) for inter-service communication, not event sourcing as a primary data model.

**Service-Based** also appears in all five sources (KataLog 25 teams, AOSA 2, RealWorld 1, RefArch 1 [AKS], Discovered 11), but its RefArch representation is infrastructure-focused (AKS Baseline) rather than application-focused. Notable Discovered projects: dify (131k stars), mastodon (49k), temporal (18k), linkerd2 (11k). It is borderline T5/T4.

### T4: Styles Validated Across Four Sources

| Style | Sources | Missing From | Cross-Source Insight |
|-------|---------|-------------|---------------------|
| **Modular Monolith** | KataLog (6), RealWorld (1), RefArch (1), Discovered (65) | AOSA | Highest KataLog win rate (83.3%). Discovered adds massive code-level validation: 65 repos (the most common Discovered style, 39.9%). Notable projects: AutoGPT (182k), n8n (177k), langchain (128k), elasticsearch (76k). Still no AOSA-era production exemplar. |
| **Plugin/Microkernel** | KataLog (2), AOSA (3), RealWorld (3), Discovered (33) | RefArch | Now T4 (was T3): deep source-code validation resolved the detection blind spot, adding 33 Discovered repos (20.2%). Notable: n8n (177k), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). Production workhorse now confirmed at the code level. |
| **CQRS/Event Sourcing** | KataLog (3), RealWorld (1), RefArch (3), Discovered (17) | AOSA | 17 Discovered repos confirm code-level adoption. Notable: CleanArchitecture (19k), modular-monolith-with-ddd (13k). Production evidence remains thin (Squidex only). |
| **Microservices** | KataLog (39), RefArch (5), Discovered (16) | AOSA, RealWorld | Design-production divergence persists: 16 Discovered repos (down from 26 after deep validation). Notable: supabase (98k), dapr (25k), microservices-demo (19k). Still zero production evidence. |
| **DDD** | KataLog (4), RefArch (3), Discovered (29) | AOSA, RealWorld | 29 Discovered repos confirm code adoption. Notable: saleor (22k), CleanArchitecture (19k), server (18k), domain-driven-hexagon (14k). Zero production validation. |
| **Hexagonal/Clean** | KataLog (4), RefArch (3), Discovered (20) | AOSA, RealWorld | 20 Discovered repos add code-level breadth. Notable: jellyfin (49k), keycloak (33k), CleanArchitecture (19k). Still no production evidence. |
| **Serverless** | KataLog (8), RefArch (1), Discovered (3) | AOSA, RealWorld | Only 3 Discovered repos after deep validation. Notable: aws-serverless-airline-booking (2k), azure-functions-host (2k). Still no production evidence. |

### T3: Styles Validated Across Three Sources

| Style | Sources | Missing From | Cross-Source Insight |
|-------|---------|-------------|---------------------|
| **Pipeline / Pipe-and-Filter** | AOSA (5), RealWorld (1), Discovered (26) | KataLog, RefArch | 26 Discovered repos (16.0%) reinforce AOSA's production evidence. Notable: dify (131k), langchain (128k), localstack (64k), traefik (62k), airflow (44k). Code-level and production-level evidence converge here. Still zero design-phase representation. |
| **Space-Based** | KataLog (2), AOSA (1: Riak), Discovered (5) | RealWorld, RefArch | Discovered shows 5 repos (3.1%). Notable: dragonfly (30k), hazelcast (6k), ignite (5k). Thin but now present at design, code, and production stages. |

### T2: Styles Validated by Two Sources

| Style | Sources | Evidence | Assessment |
|-------|---------|----------|------------|
| **Multi-Agent** | KataLog (3), Discovered (11) | Design + code only | Emerged in AI Winter 2024. Discovered now shows 11 repos (6.7%) — significant code-level validation. Notable: AutoGPT (182k stars), langchain (128k), autogen (55k), crewAI (45k). Still no production or teaching evidence. |
| **Layered Architecture** | RealWorld (1: nopCommerce), Discovered (35) | Production + code | 35 Discovered repos (21.5%) fill the code gap. Notable: nocodb (62k), traefik (62k), maybe (54k), mastodon (49k), discourse (46k). Combined with nopCommerce's production evidence, Layered has solid code-level breadth but still minimal curated validation. |

---

## 2. The Design-Production Gap

The most consequential finding from cross-source analysis: **the patterns teams propose in design exercises diverge sharply from the patterns that dominate production systems.**

### The Gap Quantified

| Style | KataLog Adoption | Production Adoption | Discovered Code Adoption | Gap Direction |
|-------|-----------------|--------------------|----|---|
| **Pipeline** | 0% (0/78 teams) | 35% (6/17 production) | 16.0% (26/163 repos) | Massively under-proposed; code validates production |
| **Plugin/Microkernel** | 2.6% (2/78 teams) | 35% (6/17 production) | 20.2% (33/163 repos) | Under-proposed; now visible in code after deep validation |
| **Microservices** | 50% (39/78 teams) | 0% (0/17 production) | 9.8% (16/163 repos) | Over-proposed; code presence far lower than prior estimates |
| **Serverless** | 10% (8/78 teams) | 0% (0/17 production) | 1.8% (3/163 repos) | Over-proposed |
| **Event-Driven** | 60% (47/78 teams) | 29% (5/17 production) | 28.8% (47/163 repos) | Over-proposed in design; proportional in code and production |
| **Service-Based** | 32% (25/78 teams) | 18% (3/17 production) | 6.7% (11/163 repos) | Roughly aligned in design + production; growing in code |
| **Modular Monolith** | 8% (6/78 teams) | 6% (1/17 production) | 39.9% (65/163 repos) | Under-proposed; dominates well-structured code |
| **DDD** | 5% (4/78 teams) | 0% (0/17 production) | 17.8% (29/163 repos) | Under-proposed; code-heavy but unproven |

### The Three-Way Gap

Adding the Discovered code dimension reveals a third axis of divergence. Three distinct gap profiles emerge:

**1. Production-validated and now code-visible: Plugin/Microkernel.** 35% of production systems, 2.6% of competition designs, and now 20.2% of Discovered repos (33/163) after SPEC-019 deep validation. Notable projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). The prior code-invisibility was a detection artifact, not a real absence -- deep source-code inspection revealed plugin extension points that filesystem analysis missed.

**2. Code-present but production-unvalidated: Microservices, DDD.** These patterns have open-source presence (16 and 29 Discovered repos after deep validation) and competition representation (39 and 4 KataLog teams) but zero production exemplars. Deep validation reduced Microservices from 26 to 16 repos -- many were reclassified as Service-Based or Modular Monolith. The gap suggests that developers enjoy *building* these patterns but the evidence base hasn't captured them *surviving* production pressure.

**3. Code-and-production-validated but design-invisible: Pipeline.** 26 Discovered repos (16.0%) + 6 production systems but 0 KataLog teams. Notable projects: dify (131k), langchain (128k), localstack (64k), traefik (62k), airflow (44k). Both the code and production evidence converge: pipeline/pipe-and-filter is widely built and production-proven, yet teams don't propose it in design exercises.

### Why the Gap Exists

Four structural factors explain the divergence (updated from three with Discovered data):

**1. Recency bias in competition.** Microservices and Serverless became named patterns in the mid-2010s and dominate architecture conference talks, books, and certification curricula. Competition teams draw from this recent discourse. AOSA projects (2011--2012) predate the microservices naming, and RealWorldASPNET projects evolved organically rather than being designed from a pattern catalog.

**2. Problem-domain mismatch.** KataLog challenges describe user-facing business systems (e-commerce, healthcare, travel, HR) where Microservices and Event-Driven map intuitively. AOSA covers infrastructure software (web servers, compilers, databases) where Pipeline and Plugin solve the actual problems. Discovered spans both domains, which is why it shows counts for *both* competition-popular patterns (Microservices: 26) and production-popular patterns (Pipeline: 19).

**3. Operational complexity filter.** Production systems shed patterns that don't justify their operational cost. Microservices require service mesh, distributed tracing, independent CI/CD pipelines, and a platform team to sustain. Production teams that could use these patterns (Bitwarden with 9 services) choose simpler decomposition (Service-Based) because the operational overhead of full microservice independence isn't worth it.

**4. Structural detection bias (partially resolved by SPEC-019).** Prior automated discovery favored patterns with visible structural signals: Docker Compose files (Microservices, Service-Based), message broker configs (Event-Driven), directory structures like `/domain/` or `/bounded-context/` (DDD, Modular Monolith). Deep source-code inspection (SPEC-019) resolved the most significant blind spot: Plugin/Microkernel went from 0 to 33 Discovered repos (20.2%), and Microservices dropped from 26 to 16 repos as over-classified repos were corrected.

### Implication for Practitioners

When choosing an architecture style, competition-winning patterns (Event-Driven + Microservices) are not automatically the right production choice. The five-source evidence suggests a **three-step evaluation**:

1. **Would this pattern survive contact with production?** Check the Production Evidence Share table in [cross-source-reference.md](cross-source-reference.md). Styles with 0% production evidence (Microservices, Serverless, DDD, Hexagonal, Multi-Agent) should be adopted with awareness that no production system in the evidence base uses them as a primary organizing principle.

2. **Am I overlooking production-proven patterns?** Pipeline and Plugin are the most underconsidered patterns in design exercises, yet they dominate production. If your system processes data through ordered stages or needs extensibility via third-party modules, these should be on your shortlist.

3. **Is the code-level evidence robust?** Deep-validated Discovered shows that some patterns are widely built in open source (Modular Monolith: 65 repos, Layered: 35, Plugin: 33, DDD: 29) even when competition and production evidence is thin. Code-level breadth suggests community momentum but not production readiness.

---

## 3. Quality Attribute Triangulation

Quality attribute priorities shift dramatically depending on the evidence source:

### Quality Attribute Ranking by Source

| Rank | KataLog (competition) | AOSA (infra production) | RealWorldASPNET (app production) | RefArch (teaching) | Discovered (code-level) |
|------|-----------------------|------------------------|----------------------------------|-------------------|------------------------|
| 1 | Scalability (55/78) | Performance (5/12) | Extensibility (3/5) | Testability (4/8) | Scalability (dominant) |
| 2 | Security (40/78) | Extensibility (4/12) | Security (2/5) | Maintainability (3/8) | Performance |
| 3 | Availability (43/78) | Scalability (4/12) | Multi-tenancy (2/5) | Scalability (3/8) | Modularity |
| 4 | Performance (41/78) | Modularity (3/12) | Modularity (2/5) | Deployability (3/8) | Extensibility |
| 5 | Evolvability (35/78) | Fault Tolerance (2/12) | Data Integrity (1/5) | Evolvability (2/8) | Fault Tolerance |

### Cross-Source Insights

**Extensibility is the most undervalued quality attribute in design exercises.**

- AOSA: #2 (4 of 12 projects)
- RealWorldASPNET: #1 (3 of 5 projects)
- KataLog: rarely cited (buried under "Evolvability" umbrella)
- RefArch: not a primary focus
- Discovered: appears as a quality attribute in repos with plugin systems and modular architectures, but less prominent than in production sources

Combined across both production sources, extensibility appears in **7 of 17 production systems** (41%). In KataLog, it's an afterthought. The production reality is clear: long-lived systems must accommodate uses their creators never imagined, and extensibility (via plugins, passes, dialects, modules) is how they do it.

**The Scalability Trap is confirmed across sources.**

The KataLog cross-cutting analysis identified the "Scalability Trap" — first-place winners cite scalability *less often* (55%) than runners-up (68%). The production evidence explains why: AOSA and RealWorldASPNET systems achieve scalability through *specific mechanisms* (HDFS block replication, Riak consistent hashing, NGINX event loops, nopCommerce's caching layers) rather than through *architecture style selection*. Discovered reinforces this: scalability is the most-cited quality attribute in Discovered repos, yet the repos often achieve it through infrastructure choices (Kubernetes, Redis, message brokers) rather than architectural structure. Choosing Microservices "for scalability" is the design equivalent of choosing Kubernetes "for reliability" — the abstraction level is wrong.

**Multi-tenancy is a production-only concern.**

Two of 5 RealWorldASPNET projects and zero KataLog challenges address multi-tenancy. Discovered adds a few multi-tenant SaaS platforms but it remains underrepresented relative to its real-world importance. This is a common real-world architectural challenge that competition exercises and open-source tutorials largely miss.

**Testability is a teaching-only emphasis.**

Testability is the #1 quality attribute in Reference Architectures (4 of 8) but barely registers in production, competition, or Discovered sources. This reflects the purpose of reference implementations (teach good testing practices) rather than a real-world architectural priority.

**Cost/Feasibility is the strongest single-source predictor with zero cross-source support.**

The KataLog finding that cost/feasibility awareness is the strongest predictor of top-2 placement (4.5x more likely) is unsupported by any other source. No Reference Architecture includes cost analysis. No AOSA chapter discusses infrastructure costs. No RealWorldASPNET catalog quantifies operational spend. No Discovered repo includes cost modeling. The practice most correlated with competition success has zero representation in the materials teams learn from — across all five sources.

---

## 4. The Practice-Evidence Gap

The cross-source analysis reveals a systematic disconnect: **the practices that most predict success in KataLog competition have the least support in teaching, production, and code-level materials.**

| Practice | KataLog Evidence | RefArch Support | Production Exemplars | Discovered Support | Gap |
|----------|-----------------|-----------------|---------------------|-------------------|-----|
| **Feasibility/Cost Analysis** | Strongest single predictor (4.5x top-2 likelihood) | 0 of 8 include it | 0 of 17 include it | 0 of 163 include it | **Critical** |
| **ADR Discipline (15+ ADRs)** | 2nd-strongest predictor (73% of winners) | 1 of 8 has ADRs | N/A (different format) | ~5 of 163 have ADR directories | **Critical** |
| **Fitness Functions** | 55% of 1st-place winners | 1 of 8 (ArchUnit tests) | 0 of 17 include them | ~3 of 163 have ArchUnit/fitness tests | **Severe** |
| **C4 Diagrams** | 55% of top-2 teams | N/A (code, not diagrams) | N/A | N/A | Moderate |
| **Evolutionary/Phased Approach** | 73% of winners propose 2+ styles | eShopOnContainers → eShop | Multiple AOSA refactors | Some repos show migration patterns | Low (implicitly supported) |

### The Critical Practice Gap

The three highest-impact practices in KataLog — feasibility analysis, ADR discipline, and fitness functions — share a common trait: they are **meta-architectural practices** (practices *about* architecture decisions) rather than architecture *patterns*. They appear in:

- **0 of 8** Reference Architectures (for feasibility; 1 of 8 for ADRs; 1 of 8 for fitness functions)
- **0 of 17** production systems
- **~5 of 163** Discovered repos (only a handful include ADR directories; fitness function adoption is negligible)

Discovered data confirms what the four-source analysis suggested: the gap is real and systemic. Even in a sample of 163 deep-validated open-source repositories — many of which are well-engineered projects with tens of thousands of stars — meta-architectural practices are nearly absent. Teams learn *what* to build from reference implementations and open-source examples but not *why* to build it, *what it costs to run*, or *how to verify it stays healthy*. The cross-source evidence strongly suggests that the largest opportunity for improving architecture outcomes is not adopting a different pattern but adopting these meta-practices.

---

## 5. Lifecycle-Stage Evidence Map

Each architecture style has evidence at different lifecycle stages. This map shows where each style has been validated and where gaps remain.

| Style | Design (KataLog) | Code (RefArch + Discovered) | Production (AOSA + RealWorld) | Assessment |
|-------|:-:|:-:|:-:|---|
| **Event-Driven** | 47 teams | 5 + 47 = 52 repos | 5 systems | Full lifecycle coverage; broad code-level evidence |
| **Microservices** | 39 teams | 5 + 16 = 21 repos | 0 systems | Design + code only; zero production |
| **Service-Based** | 25 teams | 1 + 11 = 12 repos | 3 systems | Full lifecycle coverage; code evidence growing |
| **Pipeline / Pipe-and-Filter** | 0 teams | 0 + 26 = 26 repos | 6 systems | Code + production; Discovered fills the code gap |
| **Plugin/Microkernel** | 2 teams | 0 + 33 = 33 repos | 6 systems | Now full lifecycle; blind spot resolved by SPEC-019 |
| **Modular Monolith** | 6 teams | 1 + 65 = 66 repos | 1 system | Full lifecycle; highest code-level count |
| **CQRS/Event Sourcing** | 3 teams | 3 + 17 = 20 repos | 1 system | Full lifecycle; code-heavy |
| **Domain-Driven Design** | 4 teams | 3 + 29 = 32 repos | 0 systems | Design + code; code:production imbalance |
| **Hexagonal/Clean** | 4 teams | 3 + 20 = 23 repos | 0 systems | Design + code; no production evidence |
| **Serverless** | 8 teams | 1 + 3 = 4 repos | 0 systems | Design + code; thin and no production evidence |
| **Layered Architecture** | 0 teams | 0 + 35 = 35 repos | 1 system | Code + production; Discovered fills the code gap |
| **Space-Based** | 2 teams | 0 + 5 = 5 repos | 1 system | Full lifecycle; thin across all stages |
| **Multi-Agent** | 3 teams | 0 + 11 = 11 repos | 0 systems | Design + code; growing rapidly |

### Lifecycle Coverage Changes from Discovered

The most impactful contribution of Discovered is filling the **CODE stage gap** that was the weakest link in the four-source model:

**Styles that gained full lifecycle coverage (Design + Code + Production):**
- **Modular Monolith** (66 code-level repos — highest of any style)
- **CQRS/Event Sourcing** (20 code-level repos)
- **Space-Based** (5 code-level repos)
- **Plugin/Microkernel** (33 code-level repos — blind spot fully resolved by SPEC-019 deep validation)

**Styles where code gap was filled but production gap remains:**
- **Pipeline** (26 code repos — code + production without design)
- **Layered** (35 code repos — code + production without design)
- **Multi-Agent** (11 code repos — design + code without production, growing rapidly)

**SPEC-019 detection blind spot resolution:**
- **Plugin/Microkernel** — previously 0 code-level repos despite being the #2 curated style (6 production systems). SPEC-019 deep source-code inspection revealed 33 repos (20.2%) with plugin extension points invisible to directory-structure analysis. Notable projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). This was the most significant detection correction in the deep validation process.

### Remaining Lifecycle Gaps

**Patterns with strong production evidence but no design support:**
- Pipeline (6 production, 26 code, 0 design)

This pattern needs: inclusion in architecture kata guidance so teams consider it.

**Patterns with strong design/code evidence but no production validation:**
- Microservices (39 design, 21 code, 0 production)
- DDD (4 design, 32 code, 0 production)
- Hexagonal/Clean (4 design, 23 code, 0 production)
- Serverless (8 design, 4 code, 0 production)

These patterns need: production case studies demonstrating operational viability at scale. Deep-validated Discovered confirms they are widely *built* — the evidence gap is specifically at the production lifecycle stage.

**Pattern with evidence at all stages but thin production:**
- Modular Monolith (6 design, 66 code, 1 production)

Despite the highest KataLog win rate (83.3%) and now 66 code repos (highest of any style), the production evidence is still a single system (Orchard Core). This is the strongest candidate for expanded production evidence collection.

---

## Cross-Source Findings Summary

### Finding 1: The Plugin/Pipeline Blind Spot

The two most common production patterns (Pipeline: 6/17, Plugin: 6/17) are the two most absent from architecture design exercises (Pipeline: 0/78, Plugin: 2/78) and teaching materials (both: 0/8). SPEC-019 deep validation now confirms both at the code level: **Pipeline at 26 repos (16.0%) and Plugin at 33 repos (20.2%).** Pipeline's blind spot is cultural (teams don't think to propose it); Plugin's prior code-level blind spot was structural (automated tools couldn't detect it) but is now resolved.

**Evidence depth**: Pipeline T3 (AOSA + RealWorld + Discovered); Plugin now T4 (KataLog + AOSA + RealWorld + Discovered). High confidence.

### Finding 2: The Microservices Inversion

Microservices is the #2 pattern by competition popularity (39/78 teams), #1 by reference implementation count (5 repos), but present in only **16 Discovered repos (9.8% of 163)** after deep validation — and has **zero production evidence** across 17 production systems spanning AOSA and RealWorldASPNET. Even Bitwarden, with 9 independently versioned services, identifies as Service-Based. Notable MS projects: supabase (98k stars), dapr (25k), microservices-demo (19k).

Deep source-code validation reduced Discovered Microservices from 26 to 16 repos, as many were reclassified to Service-Based or Modular Monolith. The design-production gap is wider than previously estimated.

This does not mean Microservices doesn't work in production (Netflix, Amazon, and Google famously use it). It means the evidence base lacks production exemplars for this style, which remains the highest-priority gap for future collection.

**Evidence depth**: T4 (KataLog + RefArch + Discovered + absence-of-evidence from AOSA/RealWorld). Moderate-to-high confidence — tempered by known production use outside the evidence base.

### Finding 3: Event-Driven Means Different Things

Event-Driven is the only T5 (fully validated) pattern, but it means something different at each lifecycle stage:
- **Competition**: A primary architecture style label
- **Teaching**: An integration mechanism between bounded contexts
- **Production infrastructure**: Non-blocking I/O and concurrency (NGINX reactor, Twisted reactor)
- **Production applications**: Audit trails (Squidex event sourcing) and cross-service coordination (Bitwarden AMQP)
- **Open-source code**: Message broker integration (Kafka, RabbitMQ, NATS) — 28.8% of deep-validated Discovered repos exhibit this pattern

Teams should specify *which* Event-Driven they mean: messaging topology, data model (event sourcing), concurrency model (event loop), or integration pattern. Discovered confirms that the vast majority of code-level Event-Driven implementations are message-broker-based integration patterns, not event sourcing as a primary data model.

**Evidence depth**: T5 (all five sources). Highest confidence.

### Finding 4: The Practice-Evidence Gap

The three practices most predictive of KataLog success — feasibility analysis (4.5x top-2 likelihood), ADR discipline (winners average 15 ADRs), and fitness functions (55% of winners) — have near-zero representation in teaching, production, and code-level materials. Deep-validated Discovered data confirms this across 163 repos: fewer than 5 include ADR directories and fewer than 3 include fitness function tests.

Teams learn *what* to build from reference implementations and open-source examples but not *why* to build it, *what it costs*, or *how to verify it stays healthy*.

**Evidence depth**: T1 (KataLog only for the success correlation). Low-to-moderate confidence — the practices are well-established in architecture literature but their competitive advantage is validated only by KataLog data. Discovered confirms the gap exists in code-level materials.

### Finding 5: Extensibility Is the Hidden Quality Attribute

Extensibility (via plugins, passes, dialects, modules) appears in 7 of 17 production systems (41%) as a primary quality attribute but is rarely cited in competition entries. Discovered repos frequently cite modularity and extensibility in their descriptions, but this is concentrated in Plugin-like systems and framework projects. The broader Discovered population (CRUD apps, microservices templates, tutorial projects) rarely prioritizes extensibility as an architectural driver.

Production systems that survive a decade need to accommodate uses their creators never imagined. Extensibility is how they do it — and it's architecturally significant because it drives pattern choices (Plugin, Pipeline, Modular Architecture).

**Evidence depth**: T2 (AOSA + RealWorldASPNET). High confidence within production evidence; low visibility in design, code, and teaching contexts.

### Finding 6: Modular Monolith — Strongest Signal, Broadest Code Validation

Modular Monolith has the highest KataLog win rate (83.3%), has production validation (Orchard Core), has code-level references (kgrzybek's project), and now has **65 deep-validated Discovered repos** — making it the **most common Discovered style** (39.9% of all entries). Notable projects: AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k), nest (74k), redis (73k).

The deep-validated Discovered evidence shows Modular Monolith implemented across multiple languages and frameworks (Django, Spring Boot, .NET, Go, TypeScript, Python), confirming it is not a .NET-only phenomenon. It co-occurs with Plugin/Microkernel in 19 repos and Event-Driven in 25 repos — the two most common co-occurring pairs.

The remaining gap is production depth: only 1 production exemplar (Orchard Core) despite 6 design teams, 1 reference implementation, and 65 Discovered repos. Expanding production evidence for Modular Monolith remains the highest-priority collection target.

**Evidence depth**: T4 (KataLog + RealWorld + RefArch + Discovered). High confidence — directionally strong with broad code validation. Missing: AOSA production exemplar.

---

## Methodology Notes

- **Source analysis dependencies**: This document is derived from the five evidence source analyses:
  - `evidence-analysis/TheKataLog/docs/analysis/cross-cutting.md` (78 teams)
  - `evidence-analysis/AOSA/docs/analysis/source-analysis.md` (12 projects)
  - `evidence-analysis/ReferenceArchitectures/docs/analysis/source-analysis.md` (8 repos)
  - `evidence-analysis/RealWorldASPNET/docs/analysis/source-analysis.md` (5 projects)
  - `evidence-analysis/Discovered/_index.yaml` and `quality-report.md` (163 repos, deep-validated via source code inspection per SPEC-019)
- **Weighted scoring**: The Combined Weighted Scoreboard in [cross-source-reference.md](cross-source-reference.md) uses point weights for the four curated sources. Discovered is shown as entry counts (not point-weighted) because even deep-validated classification has inherently lower confidence than expert curation. See the "Discovered evidence: breadth, not depth" section in the reference for rationale.
- **Triangulation counting**: "Production systems" counts combine AOSA (12) and RealWorldASPNET (5) for a total of 17. Production adoption percentages use this base. "Code-level repos" counts combine RefArch (8) and Discovered (163) for a total of 171.
- **Style name mapping**: Discovered uses "Pipe-and-Filter" as the canonical name for the same pattern AOSA calls "Pipeline." Both names appear in this document depending on context.
- **Limitations**:
  - The production evidence base (17 systems) is small. Pipeline at 6/17 is directionally strong but not statistically conclusive.
  - AOSA projects (2011--2012) predate Microservices, Serverless, and cloud-native patterns. Their absence from AOSA may partly reflect era rather than production unsuitability.
  - RealWorldASPNET is .NET-only. Production patterns in Go, Java, Python, and Rust ecosystems may differ.
  - KataLog competition scoring varies by season and judge panel. Cross-season comparisons should be treated as approximate.
  - Discovered entries are now deep-validated via source code inspection per SPEC-019, a significant improvement over prior automated filesystem classification. Multi-style assignments may still introduce counting artifacts. 24 repos (14.7%) remain Indeterminate (libraries/frameworks without clear architectural style).
  - Prior structural detection bias has been substantially reduced by deep validation. The most significant correction: Plugin/Microkernel went from 0 to 33 repos (20.2%), and Microservices dropped from 26 to 16 repos (9.8%) as over-classified repos were corrected.

---

*Generated: 2026-03-06. Derived from structured YAML catalogs and source analyses across all five evidence sources (266 total entries). Discovered corpus deep-validated via source code inspection per SPEC-019.*
