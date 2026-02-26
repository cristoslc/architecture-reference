# Cross-Source Architecture Evidence Reference

Maps the library's 12 canonical architecture styles to evidence across all three sources: competition submissions (TheKataLog), production narratives (AOSA), and reference implementations (ReferenceArchitectures). Also maps relevant cloud provider patterns for each style.

Generated: 2026-02-26

---

## Evidence Coverage by Style

| Style | KataLog Teams | AOSA Projects | Reference Impls | Total Evidence |
|-------|--------------|---------------|-----------------|----------------|
| **Event-Driven** | 47 | 3 (NGINX, Twisted, ZeroMQ) | 5 (eShopOnContainers, eShop, Modular Monolith w/DDD, Serverless Microservices, Wild Workouts Go) | 55 |
| **Microservices** | 39 | 0 | 5 (eShopOnContainers, eShop, Wild Workouts Go, Serverless Microservices, AKS Baseline) | 44 |
| **Service-Based** | 25 | 2 (Selenium, Graphite) | 1 (AKS Baseline) | 28 |
| **Modular Monolith** | 6 | 0 | 1 (Modular Monolith w/DDD) | 7 |
| **Serverless** | 8 | 0 | 1 (Serverless Microservices Azure) | 9 |
| **Domain-Driven Design** | 4 | 0 | 3 (eShopOnContainers, Modular Monolith w/DDD, Wild Workouts Go) | 7 |
| **Hexagonal/Clean** | 4 | 0 | 3 (Clean Architecture .NET, BuckPal, Wild Workouts Go) | 7 |
| **CQRS/Event Sourcing** | 3 | 0 | 3 (eShopOnContainers, Modular Monolith w/DDD, Clean Architecture .NET) | 6 |
| **Pipeline** | 0 | 5 (NGINX, LLVM, ZeroMQ, Graphite, GStreamer) | 0 | 5 |
| **Plugin/Microkernel** | 2 | 3 (LLVM, SQLAlchemy, GStreamer) | 0 | 5 |
| **Multi-Agent** | 3 | 0 | 0 | 3 |
| **Space-Based** | 2 | 1 (Riak) | 0 | 3 |

### Key Observations

1. **Pipeline and Plugin styles are entirely new to the library.** Before adding AOSA evidence, these patterns had zero or minimal coverage. NGINX, LLVM, GStreamer, and Graphite fill a significant gap.

2. **Modular Monolith now has production-code evidence.** The kgrzybek/modular-monolith-with-ddd repo validates the KataLog finding that Modular Monolith has the highest average placement score (3.00).

3. **Hexagonal/Clean Architecture gains working examples.** Previously only 4 KataLog teams cited it; now 3 reference implementations demonstrate it with deployable code.

4. **Multi-Agent remains thin.** No AOSA or reference implementation coverage — this is the newest pattern (emerged in the AI Winter 2024 season).

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
| **Entries** | 78 teams | 12 projects | 8 repos |
| **Has running code?** | No | No (describes existing code) | Yes |
| **Has placement ranking?** | Yes (1st-4th/runner-up) | No | No (community validation via GitHub stars) |
| **Covers production scale?** | No (theoretical designs) | Yes (describes real deployments) | Partial (reference-grade, not prod deployments) |
| **Architecture styles** | 12 canonical + variants | Mostly Pipeline, Plugin, Event-Driven | Mostly Microservices, Event-Driven, Hexagonal, DDD |
| **Strengths** | Large sample, placement data, comparable (same format) | Real-world validation, production insights | Executable, testable, copy-and-deploy |
| **Limitations** | Competition bias, no code | Dated (2011-2012), no code | Small sample domains, vendor-specific |
