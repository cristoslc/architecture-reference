# Cross-Source Architecture Evidence Reference

Maps the library's architecture styles to weighted evidence across all four sources. Production evidence from real-world applications is weighted most heavily.

Generated: 2026-02-26

---

## Evidence Weighting Methodology

Not all evidence is equal. A pattern proven at production scale is stronger evidence than a competition design that was never built, which is in turn stronger than a template with a sample domain. The weighting reflects this hierarchy.

### Evidence Point Values

| Source | Entry Type | Points | Rationale |
|--------|-----------|--------|-----------|
| **AOSA** | Production system described by creator | **6** | Built, deployed, operated at scale. Architecture validated by years of real-world use. |
| **RealWorldASPNET** | Production application (active) | **6** | Deployed production software with real users. Same confidence as AOSA. |
| **TheKataLog** | 1st place competition winner | 4 | Expert-judged best design for a specific problem, but never built |
| **TheKataLog** | 2nd place | 3 | Strong validated design |
| **TheKataLog** | 3rd place | 2 | Recognized quality |
| **TheKataLog** | Runner-up | 1 | Participated, design not distinguished by judges |
| **Reference Impl** | Active/maintained repo | 2 | Working code with community validation, but sample domain — not production-tested at scale |
| **Reference Impl** | Archived repo | 1 | Working code, but no longer maintained |

### Why this weighting

- **Production systems (6 pts) outweigh competition winners (4 pts).** Squidex running CQRS/Event Sourcing in production is stronger evidence than a KataLog winner proposing it on paper. NGINX serving 30% of the internet outweighs any design document.
- **Competition winners (4 pts) outweigh templates (2 pts).** Expert judges evaluated trade-offs against a real problem statement; a template demonstrates a pattern in a to-do app.
- **Volume still matters.** 47 KataLog teams using Event-Driven (94 pts total) outweigh a handful of production projects in absolute terms. The weighting corrects per-entry bias, not aggregate evidence.

---

## Combined Weighted Scoreboard

| Rank | Style | KataLog | AOSA | RealWorld | Ref Impls | Combined | Entries | vs KataLog-only |
|------|-------|---------|------|-----------|-----------|----------|---------|-----------------|
| 1 | **Event-Driven** | 94 | 18 | 12 | 9 | **133** | 57 | -- |
| 2 | **Microservices** | 67 | 0 | 0 | 9 | **76** | 44 | -- |
| 3 | **Service-Based** | 43 | 12 | 6 | 2 | **63** | 29 | -- |
| 4 | **Plugin/Microkernel** | 4 | 18 | 18 | 0 | **40** | 8 | **+7** (was #11) |
| 5 | **Pipeline** | 0 | 30 | 6 | 0 | **36** | 6 | **NEW** |
| 6 | **Modular Monolith** | 18 | 0 | 6 | 2 | **26** | 8 | -2 (was #4) |
| 7 | **CQRS/Event Sourcing** | 8 | 0 | 6 | 5 | **19** | 7 | **+1** (was #8) |
| 8 | **Domain-Driven Design** | 11 | 0 | 0 | 5 | **16** | 7 | -2 (was #6) |
| 9 | **Hexagonal/Clean** | 10 | 0 | 0 | 6 | **16** | 7 | -2 (was #7) |
| 10 | **Serverless** | 12 | 0 | 0 | 2 | **14** | 9 | -5 (was #5) |
| 11 | **Space-Based** | 4 | 6 | 0 | 0 | **10** | 3 | -1 (was #10) |
| 12 | **Multi-Agent** | 8 | 0 | 0 | 0 | **8** | 3 | -3 (was #9) |
| 13 | **Layered Architecture** | 0 | 0 | 6 | 0 | **6** | 1 | **NEW** |

### What changed with four evidence sources

1. **Plugin/Microkernel surges to #4 (was #11).** Three RealWorldASPNET production apps (Jellyfin, Orchard Core, nopCommerce) join three AOSA projects (LLVM, SQLAlchemy, GStreamer). Plugin architecture is now backed by 90% production evidence across media servers, CMS platforms, e-commerce, compilers, ORMs, and multimedia frameworks. This is the largest rank correction in the dataset.

2. **CQRS/Event Sourcing gains production evidence (was 0%, now 32%).** Squidex is the first production CQRS/ES system in the evidence pool. Every content change stored as an immutable event, with MongoDB as event store. This moves CQRS/ES from #10 to #7 and provides concrete production validation for a pattern previously supported only by competition designs and templates.

3. **Modular Monolith gains production evidence (was 0%, now 23%).** Orchard Core demonstrates modular monolith at production scale with per-tenant module activation, validating the KataLog finding that Modular Monolith has the highest competition placement score (3.00).

4. **Pipeline solidifies at #5.** Jellyfin's media transcoding pipeline (FFmpeg-based) joins AOSA projects (NGINX, LLVM, GStreamer, Graphite, ZeroMQ). Pipeline remains 100% production-backed.

5. **Serverless drops further to #10.** Still zero production evidence across all sources. 8 KataLog teams and 1 reference implementation, but no AOSA or RealWorldASPNET projects use serverless as a primary style.

6. **Layered Architecture enters at #13.** nopCommerce's four-layer architecture (Presentation → Services → Data → Core) adds this classic style. Previously only represented implicitly via SQLAlchemy (AOSA, counted under Plugin).

### Production Evidence Share

Percentage of each style's combined score from production sources (AOSA + RealWorldASPNET):

| Style | Production % | Production Sources |
|-------|-------------|-------------------|
| Pipeline | **100%** | NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin |
| Layered | **100%** | nopCommerce |
| Plugin/Microkernel | **90%** | LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce |
| Space-Based | 60% | Riak |
| CQRS/Event Sourcing | **32%** | Squidex |
| Service-Based | 29% | Selenium, Graphite, Bitwarden |
| Modular Monolith | **23%** | Orchard Core |
| Event-Driven | 23% | NGINX, Twisted, ZeroMQ, Squidex, Bitwarden |
| Microservices | 0% | (no production evidence) |
| DDD | 0% | (no production evidence) |
| Hexagonal/Clean | 0% | (no production evidence) |
| Serverless | 0% | (no production evidence) |
| Multi-Agent | 0% | (no production evidence) |

**Remaining gaps:** Microservices (the #2 style by total score) has zero production evidence — all 76 points come from competition designs and reference templates. Serverless, DDD, Hexagonal/Clean, and Multi-Agent also lack production backing. These are the highest-priority gaps for future evidence collection.

---

## Evidence Coverage by Style (Detailed)

| Style | KataLog | AOSA | RealWorldASPNET | Ref Impls | Total |
|-------|---------|------|-----------------|-----------|-------|
| **Event-Driven** | 47 | 3 (NGINX, Twisted, ZeroMQ) | 2 (Squidex, Bitwarden) | 5 | 57 |
| **Microservices** | 39 | 0 | 0 | 5 | 44 |
| **Service-Based** | 25 | 2 (Selenium, Graphite) | 1 (Bitwarden) | 1 | 29 |
| **Plugin/Microkernel** | 2 | 3 (LLVM, SQLAlchemy, GStreamer) | 3 (Jellyfin, Orchard Core, nopCommerce) | 0 | 8 |
| **Pipeline** | 0 | 5 (NGINX, LLVM, ZeroMQ, Graphite, GStreamer) | 1 (Jellyfin) | 0 | 6 |
| **Modular Monolith** | 6 | 0 | 1 (Orchard Core) | 1 | 8 |
| **CQRS/Event Sourcing** | 3 | 0 | 1 (Squidex) | 3 | 7 |
| **Domain-Driven Design** | 4 | 0 | 0 | 3 | 7 |
| **Hexagonal/Clean** | 4 | 0 | 0 | 3 | 7 |
| **Serverless** | 8 | 0 | 0 | 1 | 9 |
| **Space-Based** | 2 | 1 (Riak) | 0 | 0 | 3 |
| **Multi-Agent** | 3 | 0 | 0 | 0 | 3 |
| **Layered Architecture** | 0 | 0 | 1 (nopCommerce) | 0 | 1 |

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

| Dimension | TheKataLog | AOSA | RealWorldASPNET | Reference Impls |
|-----------|-----------|------|-----------------|-----------------|
| **Evidence type** | Competition design proposals | Book-chapter narratives by creators | Production apps with real users | Working code, sample domain |
| **Evidence weight** | **1-4 pts** (placement) | **6 pts** (production) | **6 pts** (production) | **1-2 pts** (template) |
| **Entries** | 78 teams | 12 projects | 5 projects | 8 repos |
| **Has running code?** | No | No (describes existing code) | Yes | Yes |
| **Has real users?** | No | Yes (millions) | Yes (thousands to millions) | No (developers only) |
| **Covers production scale?** | No (theoretical) | Yes | Yes | No (sample domains) |
| **Architecture styles** | 12 canonical + variants | Pipeline, Plugin, Event-Driven | CQRS/ES, Plugin, Modular Monolith | Microservices, Hexagonal, DDD |
| **Language diversity** | N/A (design only) | C, C++, Python, Java, Erlang | C# (.NET) | C#, Java, Go |
| **Strengths** | Large sample, placement data | Real-world, production insights | Modern .NET, actively maintained | Executable, testable |
| **Limitations** | Competition bias, no code | Dated (2011-2012) | .NET-only, 5 entries | Sample domains, vendor-specific |
