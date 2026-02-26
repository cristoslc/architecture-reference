# Cross-Source Architecture Evidence Reference

Maps the library's architecture styles to weighted evidence across all three sources: competition submissions (TheKataLog), production system narratives (AOSA), and reference implementations (ReferenceArchitectures). Production evidence is weighted most heavily.

Generated: 2026-02-26

---

## Evidence Weighting Methodology

Not all evidence is equal. A pattern proven at production scale by its creator is stronger evidence than a competition design that was never built, which is in turn stronger than a template with a sample domain. The weighting reflects this hierarchy.

### Evidence Point Values

| Source | Entry Type | Points | Rationale |
|--------|-----------|--------|-----------|
| **AOSA** | Production system described by creator | **6** | Built, deployed, operated at scale. Architecture validated by years of real-world use. Highest confidence. |
| **TheKataLog** | 1st place competition winner | 4 | Expert-judged best design for a specific problem, but never built |
| **TheKataLog** | 2nd place | 3 | Strong validated design |
| **TheKataLog** | 3rd place | 2 | Recognized quality |
| **TheKataLog** | Runner-up | 1 | Participated, design not distinguished by judges |
| **Reference Impl** | Active/maintained repo | 2 | Working code with community validation, but sample domain — not production-tested at scale |
| **Reference Impl** | Archived repo | 1 | Working code, but no longer maintained |

### Why this weighting

- **A single NGINX (6 pts) outweighs a single KataLog winner (4 pts)** — NGINX serves 30% of the internet. A competition design that was never built cannot match that, regardless of how many judges liked it.
- **A KataLog winner (4 pts) outweighs a reference template (2 pts)** — expert judges evaluated trade-offs against a real problem statement; a template demonstrates a pattern in a to-do app.
- **Volume still matters.** 47 KataLog teams using Event-Driven (94 pts total) outweigh 3 AOSA projects (18 pts) in absolute terms. The weighting corrects per-entry bias, not aggregate evidence.

---

## Combined Weighted Scoreboard

| Rank | Style | KataLog (pts) | AOSA (pts) | Ref Impls (pts) | Combined Score | Entries | Rank Change vs KataLog-only |
|------|-------|--------------|------------|-----------------|----------------|---------|---------------------------|
| 1 | **Event-Driven** | 94 | 18 | 9 | **121** | 55 | -- |
| 2 | **Microservices** | 67 | 0 | 9 | **76** | 44 | -- |
| 3 | **Service-Based** | 43 | 12 | 2 | **57** | 28 | -- |
| 4 | **Pipeline** | 0 | 30 | 0 | **30** | 5 | **NEW** |
| 5 | **Plugin/Microkernel** | 4 | 18 | 0 | **22** | 5 | **+6** (was #11) |
| 6 | **Modular Monolith** | 18 | 0 | 2 | **20** | 7 | -2 (was #4) |
| 7 | **Domain-Driven Design** | 11 | 0 | 5 | **16** | 7 | -1 (was #6) |
| 8 | **Hexagonal/Clean** | 10 | 0 | 6 | **16** | 7 | -1 (was #7) |
| 9 | **Serverless** | 12 | 0 | 2 | **14** | 9 | -4 (was #5) |
| 10 | **CQRS/Event Sourcing** | 8 | 0 | 5 | **13** | 6 | -2 (was #8) |
| 11 | **Space-Based** | 4 | 6 | 0 | **10** | 3 | -1 (was #10) |
| 12 | **Multi-Agent** | 8 | 0 | 0 | **8** | 3 | -3 (was #9) |

### What changed when production evidence is weighted

1. **Pipeline enters the scoreboard at #4.** Invisible in competition data (zero KataLog teams named it), Pipeline is the dominant pattern in proven production systems: NGINX, LLVM, GStreamer, Graphite, and ZeroMQ all use pipeline architectures. This is the single largest correction from adding production evidence.

2. **Plugin/Microkernel jumps from #11 to #5.** Only 2 KataLog teams used it (both placed 3rd), but LLVM, SQLAlchemy, and GStreamer demonstrate that plugin architectures are foundational in production systems that need extensibility — compilers, ORMs, and multimedia frameworks.

3. **Serverless drops from #5 to #9.** With 8 KataLog teams but zero production AOSA evidence and only one reference implementation, Serverless was over-represented in competition data relative to its presence in the production evidence pool.

4. **Multi-Agent drops from #9 to #12.** Competition-only evidence (emerged in AI Winter 2024) with no production or reference implementation corroboration yet. This doesn't mean the pattern is bad — it means it's too new for production evidence to exist.

5. **Top 3 unchanged.** Event-Driven, Microservices, and Service-Based remain dominant across all evidence types. Their KataLog volume is large enough that production evidence reinforces rather than disrupts their ranking.

### Production Evidence Share

How much of each style's score comes from production (AOSA) evidence:

| Style | Production % | Interpretation |
|-------|-------------|----------------|
| Pipeline | **100%** | Entirely production-validated; absent from competition data |
| Plugin/Microkernel | **82%** | Overwhelmingly production-validated |
| Space-Based | 60% | Riak provides strong production evidence |
| Service-Based | 21% | Selenium + Graphite add real-world grounding |
| Event-Driven | 15% | NGINX, Twisted, ZeroMQ supplement large KataLog base |
| Microservices | 0% | Competition + reference impls only; no AOSA coverage |
| Modular Monolith | 0% | Strong KataLog signal, no AOSA coverage yet |
| DDD | 0% | No production narratives |
| Hexagonal/Clean | 0% | No production narratives |
| Serverless | 0% | No production narratives |
| CQRS/Event Sourcing | 0% | No production narratives |
| Multi-Agent | 0% | No production or reference evidence |

**Takeaway:** Styles with 0% production evidence have their rankings supported entirely by competition designs and/or templates. Future AOSA-style evidence additions (e.g., production microservices case studies) could significantly shift these rankings.

---

## Evidence Coverage by Style (Detailed)

| Style | KataLog Teams | AOSA Projects | Reference Impls | Total Entries |
|-------|--------------|---------------|-----------------|---------------|
| **Event-Driven** | 47 | 3 (NGINX, Twisted, ZeroMQ) | 5 (eShopOnContainers, eShop, Modular Monolith w/DDD, Serverless Microservices, Wild Workouts Go) | 55 |
| **Microservices** | 39 | 0 | 5 (eShopOnContainers, eShop, Wild Workouts Go, Serverless Microservices, AKS Baseline) | 44 |
| **Service-Based** | 25 | 2 (Selenium, Graphite) | 1 (AKS Baseline) | 28 |
| **Pipeline** | 0 | 5 (NGINX, LLVM, ZeroMQ, Graphite, GStreamer) | 0 | 5 |
| **Plugin/Microkernel** | 2 | 3 (LLVM, SQLAlchemy, GStreamer) | 0 | 5 |
| **Modular Monolith** | 6 | 0 | 1 (Modular Monolith w/DDD) | 7 |
| **Domain-Driven Design** | 4 | 0 | 3 (eShopOnContainers, Modular Monolith w/DDD, Wild Workouts Go) | 7 |
| **Hexagonal/Clean** | 4 | 0 | 3 (Clean Architecture .NET, BuckPal, Wild Workouts Go) | 7 |
| **Serverless** | 8 | 0 | 1 (Serverless Microservices Azure) | 9 |
| **CQRS/Event Sourcing** | 3 | 0 | 3 (eShopOnContainers, Modular Monolith w/DDD, Clean Architecture .NET) | 6 |
| **Space-Based** | 2 | 1 (Riak) | 0 | 3 |
| **Multi-Agent** | 3 | 0 | 0 | 3 |

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

| Dimension | TheKataLog | AOSA | Reference Impls |
|-----------|-----------|------|-----------------|
| **Evidence type** | Competition design proposals | Book-chapter narratives by creators | Working, deployable code |
| **Evidence weight** | **1-4 pts** (placement-based) | **6 pts per project** (production-proven) | **1-2 pts** (sample domain) |
| **Entries** | 78 teams | 12 projects | 8 repos |
| **Has running code?** | No | No (describes existing code) | Yes |
| **Has placement ranking?** | Yes (1st-4th/runner-up) | No | No (community validation via GitHub stars) |
| **Covers production scale?** | No (theoretical designs) | Yes (describes real deployments) | Partial (reference-grade, not prod deployments) |
| **Architecture styles** | 12 canonical + variants | Mostly Pipeline, Plugin, Event-Driven | Mostly Microservices, Event-Driven, Hexagonal, DDD |
| **Strengths** | Large sample, placement data, comparable format | Real-world validation, production insights, highest confidence | Executable, testable, copy-and-deploy |
| **Limitations** | Competition bias, no code, designs never built | Dated (2011-2012), no executable code | Small sample domains, often vendor-specific |
