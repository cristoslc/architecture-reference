# Cross-Source Architecture Evidence Reference

Production evidence from real-world code is the primary basis for all rankings. The Discovered corpus (142 production open-source repositories, deep-validated via SPEC-022 deep-analysis, ADR-002 recomputed) provides the statistically primary ranking. AOSA/RealWorld production systems (17 systems) provide production depth validation. KataLog competition designs (78 teams) and reference implementations (42 entries) serve as qualitative annotation only.

Generated: 2026-03-09

---

## Evidence Weighting Methodology

Not all evidence is equal. The evidence hierarchy reflects the primacy of real-world production code over never-built designs and teaching examples.

### The Production Evidence Hierarchy

1. **Discovered production repos (142 entries)** — PRIMARY EVIDENCE. The largest, most diverse corpus of real production code. 87 platforms, 55 applications across Go, Java, Python, C#, TypeScript, Rust, Kotlin, Ruby, Elixir. Deep-validated via SPEC-022 deep-analysis with ADR-002 frequency recomputation. Zero Indeterminate entries. This corpus leads all rankings.

2. **AOSA/RealWorld production systems (17 systems)** — PRODUCTION DEPTH. Deep case studies written by system creators (AOSA: 12 projects) and actively maintained production applications (RealWorldASPNET: 5 projects). Small sample but highest individual authority per system. A single production system described by its creator carries more weight than any number of competition designs.

3. **KataLog competition (78 teams)** — QUALITATIVE ANNOTATION. Never-built designs evaluated by expert judges. Valued for: judge commentary on trade-offs, team ADR reasoning documenting *why* a style was chosen, and placement data showing what design experts reward. Not primary evidence — no code was ever built or deployed.

4. **RefArch reference implementations (42 repos)** — TEACHING ANNOTATION. Working code with sample domains. Useful as concrete examples of how patterns are implemented, but not representative of production architecture. Excluded from frequency counts per ADR-002.

### Why This Hierarchy

- **Production code is a different class of evidence from design proposals.** NGINX serving 30% of the internet, or elasticsearch powering search at global scale, tells us more about architecture viability than any competition entry. Discovered repos have real users, real operational pressure, and real evolutionary history.
- **Statistical breadth (142 repos) provides ranking authority.** The Discovered corpus spans enough projects to establish reliable frequency patterns. AOSA/RealWorld (17 systems) provides deep narratives that validate and explain these patterns.
- **Competition designs reveal reasoning, not reality.** KataLog teams document their architectural reasoning in ADRs and presentations — this is genuinely valuable for understanding *why* practitioners reach for certain patterns. But the designs were never built, tested, or operated. They cannot rank patterns.

> **Detection bias:** Discovered statistics are derived from deep-analysis source code inspection. Styles and quality attributes that leave strong code signals are more reliably detected. Styles and quality attributes that are architectural decisions invisible in code (performance tuning, testability strategies, interoperability contracts) are underdetected. KataLog competition evidence fills this specific gap — teams documented these invisible decisions in ADRs and presentations.

---

## Discovered Frequency Rankings (PRIMARY)

The primary scoreboard. Rankings are based on 142 production open-source repositories deep-validated via SPEC-022 deep-analysis (ADR-002 recomputed). Platform/application split: 87 platforms, 55 applications (ratio 1.58:1). Entry counts per style sum to more than 142 because each repo may exhibit multiple styles.

| Rank | Style | Count | % | Platform % | App % | AOSA/RealWorld Depth | KataLog Teams |
|------|-------|-------|---|------------|-------|---------------------|---------------|
| 1 | **Microkernel** | 83 | 58.5% | 61% | 55% | 6 systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce) | 2 |
| 2 | **Layered** | 78 | 54.9% | 47% | 67% | 1 system (nopCommerce) | 0 |
| 3 | **Modular Monolith** | 57 | 40.1% | 41% | 38% | 1 system (Orchard Core) | 6 |
| 4 | **Event-Driven** | 17 | 12.0% | 8% | 18% | 5 systems (NGINX, Twisted, ZeroMQ, Squidex, Bitwarden) | 47 |
| 5 | **Pipeline** | 13 | 9.2% | 13% | 4% | 6 systems (NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin) | 0 |
| 6 | **Microservices** | 12 | 8.5% | 13% | 2% | 0 systems | 39 |
| 7 | **Service-Based** | 7 | 4.9% | -- | -- | 3 systems (Selenium, Graphite, Bitwarden) | 25 |
| 8 | **Hexagonal/Clean** | 5 | 3.5% | -- | -- | 0 systems | 4 |
| 9 | **Domain-Driven Design** | 3 | 2.1% | -- | -- | 0 systems | 4 |
| 10 | **Multi-Agent** | 1 | 0.7% | -- | -- | 0 systems | 3 |
| 11 | **Space-Based** | 1 | 0.7% | -- | -- | 1 system (Riak) | 2 |
| 12 | **CQRS** | 1 | 0.7% | -- | -- | 1 system (Squidex) | 3 |

*Serverless removed: zero production entries after reference/tutorial exclusion per ADR-002.*

### What the Rankings Reveal

1. **Microkernel is the most prevalent production style.** 83 repos (58.5%) — a dramatic rise from 20.2% under SPEC-019 and 0% under heuristic detection. Notable projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). Validated by 6 AOSA/RealWorld production systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce). Only 2 KataLog teams ever proposed this pattern — competition data alone made it nearly invisible.

2. **Layered is the second most prevalent.** 78 repos (54.9%) — up from 21.5% under SPEC-019. Deep-analysis properly identifies layered patterns (presentation/business/data layer separation). Skews toward applications (67%) over platforms (47%). Notable projects: nocodb (62k), traefik (62k), maybe (54k), mastodon (49k). Zero KataLog teams proposed Layered as a primary style.

3. **Modular Monolith is broadly prevalent.** 57 repos (40.1%) — stable from prior 38.7%. Notable projects: AutoGPT (182k), n8n (177k), langchain (128k), elasticsearch (76k). Highest KataLog win rate (83.3%) among the 6 teams that proposed it. Well-structured open-source applications overwhelmingly exhibit modular monolith patterns.

4. **Event-Driven is narrower than previously estimated.** 17 repos (12.0%) — down from 28.8% under SPEC-019 as deep-analysis corrected over-classification from message broker presence. Despite being the most popular KataLog style (47 of 78 teams, 60%), its code-level presence is modest. Validated by 5 AOSA/RealWorld production systems, confirming it is genuinely used in production — but tactically, not as a primary organizing principle.

5. **Tutorial bias corrected: DDD, CQRS, Hexagonal.** DDD dropped from 17.8% to 2.1% (3 repos), CQRS from 10.4% to 0.7% (1 repo), Hexagonal held at 3.5% (5 repos). These styles were inflated by reference/tutorial implementations now excluded per ADR-002. Their actual production adoption is significantly lower than previously estimated.

6. **Pipeline and Layered are production-proven but design-invisible.** Zero KataLog teams proposed either pattern, yet Pipeline appears in 13 production repos and is validated by 6 AOSA/RealWorld systems, while Layered appears in 78 production repos. These are the strongest examples of the proposal-production gap.

---

## Production Depth: AOSA/RealWorld Evidence

Deep narratives from 17 production systems, grouped by style. These validate and enrich the statistical patterns from the Discovered rankings.

### Production Evidence by Style

| Style | Production Systems | Discovered Validation | Narrative Insight |
|-------|-------------------|----------------------|-------------------|
| **Pipeline** | NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin (6) | 13 repos (9.2%) | Data flows through ordered processing stages. Underpins some of the most successful production systems ever built. |
| **Microkernel** | LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce (6) | 83 repos (58.5%) | Plugin/extension architecture. The statistical dominance in Discovered confirms AOSA/RealWorld evidence at massive scale. |
| **Event-Driven** | NGINX, Twisted, ZeroMQ, Squidex, Bitwarden (5) | 17 repos (12.0%) | Used tactically: non-blocking I/O (NGINX reactor), immutable audit trails (Squidex), cross-service coordination (Bitwarden AMQP). |
| **Service-Based** | Selenium, Graphite, Bitwarden (3) | 7 repos (4.9%) | Coarse-grained service decomposition. Even Bitwarden (9 services) chose Service-Based over full Microservices. |
| **Space-Based** | Riak (1) | 1 repo (0.7%) | Distributed data grid. Thin evidence but present at production scale. |
| **CQRS** | Squidex (1) | 1 repo (0.7%) | Every content change stored as immutable event, MongoDB as event store. Thin production evidence after tutorial bias correction. |
| **Modular Monolith** | Orchard Core (1) | 57 repos (40.1%) | Code-level breadth far exceeds the single AOSA/RealWorld exemplar. Strongest candidate for expanded production depth evidence. |
| **Layered** | nopCommerce (1) | 78 repos (54.9%) | Four-layer architecture. Code-level breadth massively validates the single production exemplar. |

### Styles with Zero AOSA/RealWorld Production Evidence

| Style | Discovered Count | KataLog Teams | Assessment |
|-------|-----------------|---------------|------------|
| **Microservices** | 12 (8.5%) | 39 | Highest-priority gap. Known production use outside evidence base (Netflix, Amazon) but no exemplar in corpus. |
| **DDD** | 3 (2.1%) | 4 | Tutorial bias corrected. Actual production adoption much lower than previously estimated. |
| **Hexagonal/Clean** | 5 (3.5%) | 4 | Tutorial bias corrected. |
| **Multi-Agent** | 1 (0.7%) | 3 | Emerging pattern (AI Winter 2024). Only AutoGPT (182k stars) in production. |
| **Serverless** | 0 (0%) | 8 | Zero production evidence across all sources. |

---

## Qualitative Context: Competition Insights

KataLog competition data provides qualitative annotation for the production rankings. Teams never built their designs, but their reasoning — documented in ADRs, presentations, and judge commentary — explains *why* practitioners reach for certain patterns.

### Competition Reasoning by Style

| Style | KataLog Teams | Placement Signal | Qualitative Value |
|-------|--------------|-----------------|-------------------|
| **Event-Driven** | 47 (60%) | 9 of 11 first-place winners | Teams articulate *why* event-driven feels like the right primary organizing principle — even though production evidence shows it's used tactically. Judge commentary validates the reasoning quality. |
| **Microservices** | 39 (50%) | Strong showing, no production backing | The sharpest proposal-production gap. Competition reasoning reveals why teams default to microservices (scalability narrative, decomposition intuition) despite thin production evidence. |
| **Service-Based** | 25 (32%) | Consistent mid-tier | Teams that chose Service-Based over Microservices often documented the rationale in ADRs — this reasoning is the pattern's most valuable KataLog contribution. |
| **Modular Monolith** | 6 (8%) | 83.3% win rate | Highest win rate of any style. When teams chose it, judges rewarded it. The ADR reasoning from these winning teams is exceptionally well-documented. |
| **Microkernel** | 2 (3%) | Present but rare | Almost invisible in competition despite dominating production. The 2 teams that proposed it provide useful design reasoning for an otherwise design-documentation-poor style. |
| **Pipeline** | 0 (0%) | Absent | Zero design-phase representation despite strong production evidence. KataLog contributes nothing here — a genuine annotation gap. |

### KataLog's Unique Contribution: Meta-Architectural Practices

KataLog's strongest evidence contribution is not style ranking but **meta-architectural practices** — practices *about* architecture decisions that are invisible in code:

| Practice | KataLog Evidence | Production/Code Presence | Why KataLog Matters Here |
|----------|-----------------|-------------------------|-------------------------|
| **Feasibility/Cost Analysis** | Strongest single predictor of top-2 placement (4.5x likelihood) | 0 of 17 production systems; 0 of 142 Discovered repos | Only source documenting this practice's competitive advantage |
| **ADR Discipline (15+ ADRs)** | 2nd-strongest predictor (73% of winners) | ~5 of 142 Discovered repos have ADR directories | Competition entries are the richest ADR corpus available |
| **Fitness Functions** | 55% of 1st-place winners | ~3 of 142 repos have ArchUnit/fitness tests | Only source correlating fitness functions with design quality |

---

## Evidence Coverage by Style (Detailed)

| Style | Discovered (142 prod) | AOSA | RealWorldASPNET | KataLog | Total |
|-------|----------------------|------|-----------------|---------|-------|
| **Microkernel** | 83 | 3 (LLVM, SQLAlchemy, GStreamer) | 3 (Jellyfin, Orchard Core, nopCommerce) | 2 | 91 |
| **Layered Architecture** | 78 | 0 | 1 (nopCommerce) | 0 | 79 |
| **Modular Monolith** | 57 | 0 | 1 (Orchard Core) | 6 | 64 |
| **Event-Driven** | 17 | 3 (NGINX, Twisted, ZeroMQ) | 2 (Squidex, Bitwarden) | 47 | 69 |
| **Pipeline** | 13 | 5 (NGINX, LLVM, ZeroMQ, Graphite, GStreamer) | 1 (Jellyfin) | 0 | 19 |
| **Microservices** | 12 | 0 | 0 | 39 | 51 |
| **Service-Based** | 7 | 2 (Selenium, Graphite) | 1 (Bitwarden) | 25 | 35 |
| **Hexagonal/Clean** | 5 | 0 | 0 | 4 | 9 |
| **Domain-Driven Design** | 3 | 0 | 0 | 4 | 7 |
| **CQRS** | 1 | 0 | 1 (Squidex) | 3 | 5 |
| **Multi-Agent** | 1 | 0 | 0 | 3 | 4 |
| **Space-Based** | 1 | 1 (Riak) | 0 | 2 | 4 |

**Source totals:** Discovered 142 production repos (+ 42 reference implementations as annotation examples), AOSA 12 projects, RealWorldASPNET 5 projects, KataLog 78 teams = **279 entries** across all sources.

Note: Entry counts per style sum to more than total entries because each entry may exhibit multiple styles. Discovered uses canonical style names per SPEC-022 (e.g., "Pipeline" replaces "Pipe-and-Filter", "Microkernel" replaces "Plugin/Microkernel"). Zero Discovered entries remain Indeterminate (ADR-002). Reference implementations (42 entries) are excluded from the Discovered column but serve as annotation examples throughout the evidence layer. Serverless removed: zero production entries after reference/tutorial exclusion.

---

## Cloud Provider Pattern Mapping

Maps cloud provider design pattern documentation to the library's architecture styles.

### Event-Driven Architecture

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Event-Driven Architecture | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-decomposing-monoliths/event-driven.html) |
| AWS | Saga Pattern (choreography) | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/saga.html) |
| Azure | Event-Driven Architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) |
| Azure | Competing Consumers | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers) |
| Azure | Publisher-Subscriber | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber) |
| GCP | Event-Driven Architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/event-driven) |

### Microservices

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Decompose by business capability | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/decomposition.html) |
| AWS | API Gateway pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/api-gateway.html) |
| Azure | Microservices architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) |
| Azure | Sidecar pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar) |
| Azure | Ambassador pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/ambassador) |
| GCP | Microservices architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/microservices-architecture-introduction) |

### Service-Based Architecture

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | Web-Queue-Worker | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/web-queue-worker) |
| Azure | N-tier architecture | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier) |
| AWS | Strangler Fig pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/strangler-fig.html) |

### CQRS/Event Sourcing

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | CQRS pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) |
| Azure | Event Sourcing pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) |
| Azure | Materialized View pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/materialized-view) |
| AWS | CQRS pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/cqrs.html) |

### Serverless

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Serverless architecture patterns | [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-architecture.html) |
| Azure | Serverless architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/serverless) |
| GCP | Serverless architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/serverless-overview) |

### Resilience / Cross-Cutting (Applies to Multiple Styles)

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | Circuit Breaker | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker) |
| Azure | Retry pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry) |
| Azure | Bulkhead pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead) |
| AWS | Throttling pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/throttling.html) |
| All | Health Endpoint Monitoring | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) |

---

## Evidence Quality Comparison

| Dimension | Discovered | AOSA | RealWorldASPNET | TheKataLog | Reference Impls |
|-----------|------------|------|-----------------|-----------|-----------------|
| **Evidence type** | Working open-source code, deep-validated via SPEC-022 deep-analysis | Book-chapter narratives by creators | Production apps with real users | Competition design proposals (never built) | Working code, sample domain |
| **Evidence role** | **Primary ranking** (statistical breadth) | **Production depth** (narrative authority) | **Production depth** (modern .NET) | **Qualitative annotation** (reasoning, ADRs) | **Teaching annotation** (examples) |
| **Entries** | 142 production repos | 12 projects | 5 projects | 78 teams | 42 repos (annotation) |
| **Has running code?** | Yes | No (describes existing code) | Yes | No | Yes |
| **Has real users?** | Varies (production repos verified) | Yes (millions) | Yes (thousands to millions) | No | No (developers only) |
| **Covers production scale?** | Production entries only (87 platforms, 55 applications) | Yes | Yes | No (theoretical) | No (sample domains) |
| **Architecture styles** | 12 styles detected; zero Indeterminate (ADR-002) | Pipeline, Plugin, Event-Driven | CQRS/ES, Plugin, Modular Monolith | 12 canonical + variants | Microservices, Hexagonal, DDD |
| **Language diversity** | Go, Java, Python, C#, TypeScript, Rust, Kotlin, Ruby, Elixir | C, C++, Python, Java, Erlang | C# (.NET) | N/A (design only) | C#, Java, Go |
| **Strengths** | Production-only breadth, all styles, multi-language, zero Indeterminate | Real-world, production insights, creator narratives | Modern .NET, actively maintained | Large sample, placement data, ADR reasoning, meta-practices | Executable, testable |
| **Limitations** | Detection bias (styles invisible in code are underdetected) | Dated (2011-2012) | .NET-only, 5 entries | Competition bias, no code built | Sample domains, vendor-specific |

---

## Historical: Combined Weighted Scoreboard (Deprecated)

> **Status: Deprecated.** This scoreboard was the primary ranking under the original Five-Source Triangulation methodology. It has been superseded by the Discovered Frequency Rankings above, which implement the production-first evidence hierarchy mandated by EPIC-007. The Combined Weighted Scoreboard is preserved below for historical reference and traceability.

The original scoring gave AOSA/RealWorld 20 points per system, KataLog 1-4 points by placement, and reference implementations 1-2 points. Discovered production repos were shown as a side column but received zero points in the combined score — effectively inverting the evidence hierarchy by allowing competition placement data to dominate rankings.

| Rank | Style | KataLog | AOSA | RealWorld | Ref Impls | Combined | Entries | Discovered (142 prod) |
|------|-------|---------|------|-----------|-----------|----------|---------|----------------------|
| 1 | **Event-Driven** | 94 | 60 | 40 | 9 | **203** | 57 | 17 |
| 2 | **Microkernel** | 4 | 60 | 60 | 0 | **124** | 8 | 83 |
| 3 | **Pipeline** | 0 | 100 | 20 | 0 | **120** | 6 | 13 |
| 4 | **Service-Based** | 43 | 40 | 20 | 2 | **105** | 29 | 7 |
| 5 | **Microservices** | 67 | 0 | 0 | 9 | **76** | 44 | 12 |
| 6 | **Modular Monolith** | 18 | 0 | 20 | 2 | **40** | 8 | 57 |
| 7 | **CQRS** | 8 | 0 | 20 | 5 | **33** | 7 | 1 |
| 8 | **Space-Based** | 4 | 20 | 0 | 0 | **24** | 3 | 1 |
| 9 | **Layered Architecture** | 0 | 0 | 20 | 0 | **20** | 1 | 78 |
| 10 | **Domain-Driven Design** | 11 | 0 | 0 | 5 | **16** | 7 | 3 |
| 11 | **Hexagonal/Clean** | 10 | 0 | 0 | 6 | **16** | 7 | 5 |
| 12 | **Multi-Agent** | 8 | 0 | 0 | 0 | **8** | 3 | 1 |

**Why this scoreboard was superseded:** The Combined scoring gave Discovered production repos — the largest and most diverse evidence corpus — zero weight, while giving KataLog competition placements 1-4 points each. This allowed 47 never-built Event-Driven competition entries (94 KataLog points) to dominate 83 production Microkernel repos (0 points). The Discovered Frequency Rankings correct this by making production code the primary ranking authority.
