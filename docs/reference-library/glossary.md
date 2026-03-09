# Glossary

Definitions of architecture styles, quality attributes, evidence sources, problem dimensions, and key terms used throughout the reference library.

---

## Architecture Styles

The 12 canonical styles, ordered by production frequency (Discovered, 142 production repos).

### Microkernel

**Also known as:** Plugin Architecture

A host application that provides extension points through which independently deployable plugins extend core functionality. The core framework handles lifecycle management, configuration, and shared services; plugins provide domain-specific behavior and can be added, removed, or replaced without modifying the core.

- **Production frequency:** 83/142 repos (58.5%) — most prevalent style
- **Platform/application split:** 61% / 55%
- **Production depth:** 6 AOSA/RealWorld systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce)
- **Distinguishing signals:** Plugin registries, extension point contracts, dynamic module loading, host/plugin separation

### Layered Architecture

**Also known as:** N-Tier

Horizontal separation of concerns into layers (typically presentation, business logic, data access), where each layer depends only on the layer below it. Enforces a strict dependency direction that simplifies reasoning about change impact.

- **Production frequency:** 78/142 repos (54.9%)
- **Platform/application split:** 47% / 67% — skews toward applications
- **Production depth:** 1 AOSA/RealWorld system (nopCommerce: Web/Services/Data/Core)
- **Distinguishing signals:** Layer-named directories, dependency flow from upper to lower layers, service/repository separation

### Modular Monolith

A single deployable unit organized into well-defined, cohesive modules with clear boundaries. Modules are logically independent but share the same process, memory, and deployment artifact. Enables independent module development and testing while avoiding distributed system complexity.

- **Production frequency:** 57/142 repos (40.1%)
- **Platform/application split:** 41% / 38%
- **Production depth:** 1 AOSA/RealWorld system (Orchard Core: multi-tenant CMS with independently toggleable features)
- **Distinguishing signals:** Module-per-directory structure, module registries, internal API boundaries, feature toggles
- **Note:** Highest KataLog win rate (83.3%) among competition teams

### Event-Driven Architecture

**Also known as:** Pub/Sub, Message-Driven

Components communicate through events rather than direct synchronous calls. Producers emit events without knowledge of consumers; consumers listen and react independently. Decouples components temporally and logically.

- **Production frequency:** 17/142 repos (12.0%)
- **Platform/application split:** 8% / 18% — skews toward applications
- **Production depth:** 5 AOSA/RealWorld systems (NGINX reactor, Twisted reactor, ZeroMQ, Squidex event sourcing, Bitwarden AMQP)
- **Distinguishing signals:** Message broker configs (Kafka, RabbitMQ, NATS), event bus implementations, async handlers
- **Note:** The only style validated across all evidence sources. Means different things in different contexts: event-loop concurrency, event sourcing as data model, message-based integration, or pub/sub communication.

### Pipeline

**Also known as:** Pipe-and-Filter

Data flows through ordered processing stages (filters), with the output of one stage feeding the input of the next. Each stage is independent, specialized for a particular transformation, and replaceable without affecting others.

- **Production frequency:** 13/142 repos (9.2%)
- **Platform/application split:** 13% / 4% — strongly platform-oriented
- **Production depth:** 6 AOSA/RealWorld systems (NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin)
- **Distinguishing signals:** Stage-based directory layouts, pipeline configuration, data transformation chains, middleware stacks
- **Note:** Zero KataLog teams proposed this style despite strong production evidence — the most design-invisible production pattern.

### Microservices

Independent, loosely coupled services that can be deployed, scaled, and developed independently. Each service owns its data, runs in its own process, and communicates via APIs or asynchronous messaging. Requires significant operational infrastructure (service mesh, distributed tracing, independent CI/CD).

- **Production frequency:** 12/142 repos (8.5%)
- **Platform/application split:** 13% / 2% — almost exclusively platforms
- **Production depth:** 0 AOSA/RealWorld systems
- **Distinguishing signals:** Docker Compose multi-service layouts, API gateway configs, per-service databases, independent deployment containers
- **Note:** Largest proposal-production gap. 50% of competition teams propose it; 0% of AOSA/RealWorld production systems use it.

### Service-Based Architecture

Coarse-grained service decomposition where multiple services often share a database and communicate through simple APIs. Less distributed than microservices — trades some scalability and independence for dramatically lower operational complexity.

- **Production frequency:** 7/142 repos (4.9%)
- **Platform/application split:** 5% / 5%
- **Production depth:** 3 AOSA/RealWorld systems (Selenium, Graphite, Bitwarden with 9 shared-database services)
- **Distinguishing signals:** Multiple services sharing infrastructure, coarse service boundaries, shared database patterns

### Hexagonal Architecture

**Also known as:** Ports and Adapters, Clean Architecture, Onion Architecture

Core business logic isolated in the center with dependencies pointing inward. External concerns (UI, databases, APIs) connect through ports (interfaces) and adapters (implementations), ensuring the domain model has no knowledge of infrastructure.

- **Production frequency:** 5/142 repos (3.5%)
- **Platform/application split:** 3% / 4%
- **Production depth:** 0 AOSA/RealWorld systems
- **Distinguishing signals:** Port/adapter directory structures, dependency inversion enforcement, domain layer with no external imports

### Domain-Driven Design

**Also known as:** DDD

Architectural and design methodology that organizes code around business domains (bounded contexts) using ubiquitous language. Emphasizes domain logic over technical concerns, with patterns like aggregates, domain events, and repositories structuring the domain layer.

- **Production frequency:** 3/142 repos (2.1%)
- **Platform/application split:** 2% / 2%
- **Production depth:** 0 AOSA/RealWorld systems
- **Distinguishing signals:** Aggregate root patterns, bounded context directories, domain event implementations
- **Note:** Tutorial bias significantly inflated prior estimates (17.8% → 2.1%). Well-documented in teaching materials but rare in production.

### Multi-Agent

Multiple autonomous agents collaborate to solve complex problems. Each agent has specialized capabilities (retrieval, analysis, planning, execution) and they coordinate through message passing or supervisor hierarchies. An emerging pattern primarily in AI-focused systems.

- **Production frequency:** 1/142 repos (0.7%)
- **Platform/application split:** 0% / 2%
- **Production depth:** 0 AOSA/RealWorld systems
- **Distinguishing signals:** Agent role definitions, multi-agent coordination protocols, tool-use registries

### Space-Based Architecture

In-memory distributed data grid with peer-to-peer replication. Data is replicated across multiple processing units without a central database, favoring availability and partition tolerance over strong consistency.

- **Production frequency:** 1/142 repos (0.7%)
- **Platform/application split:** 1% / 0%
- **Production depth:** 1 AOSA/RealWorld system (Riak: peer-to-peer consistent hashing)
- **Distinguishing signals:** Distributed in-memory grids, consistent hashing, masterless replication, eventual consistency

### CQRS

**Also known as:** Command Query Responsibility Segregation, CQRS/Event Sourcing

Separation of read and write models. Commands modify state and may produce events; queries operate on separate read-optimized projections. Often paired with event sourcing, where state changes are stored as an immutable sequence of events.

- **Production frequency:** 1/142 repos (0.7%)
- **Platform/application split:** 0% / 2%
- **Production depth:** 1 AOSA/RealWorld system (Squidex: MongoDB event store)
- **Distinguishing signals:** Command/query separation, event store configurations, projection builders
- **Note:** Tutorial bias significantly inflated prior estimates (10.4% → 0.7%).

---

## Quality Attributes

Quality attributes (also called "-ilities") are system properties that constrain or shape architectural decisions. Detection from source code varies significantly — some attributes leave strong filesystem signals, others are invisible in code.

### Detectable in Code

| Quality Attribute | Definition | Detection Rate | Detection Method |
|-------------------|-----------|---------------|-----------------|
| **Deployability** | Ease and flexibility of deploying changes to production; support for multiple deployment targets | 88.7% | Docker, Kubernetes, Helm, CI/CD configs |
| **Modularity** | Organization into well-defined modules with clear boundaries, responsibilities, and interfaces | 26.8% | Project structure, assembly boundaries, DI configuration |
| **Scalability** | Ability to handle increased load by adding resources (horizontal) or capacity (vertical) | 23.2% | Message queues, HPA configs, sharding strategies |
| **Fault Tolerance** | Resilience to component failures; graceful degradation and recovery under stress | 14.1% | Circuit breakers, retry policies, health checks |
| **Observability** | Ability to understand internal system state through metrics, structured logs, and distributed traces | 3.5% | Logging frameworks, OpenTelemetry packages |
| **Evolvability** | Ease of modifying and extending the architecture over time without major refactoring | 2.1% | Plugin systems, extension points (partially visible via Microkernel) |

> **Detection bias caveat:** Deployability (88.7%) is inflated — Docker and CI configs are universal tooling conventions, not architectural decisions. The detection rates above reflect what is *detectable* in code, not what is *important* to architects.

### Invisible in Code

These quality attributes are architecturally significant but cannot be reliably detected from source code analysis. KataLog competition evidence is particularly valuable here, as teams document these concerns in ADRs and presentations.

| Quality Attribute | Definition | Why Invisible |
|-------------------|-----------|---------------|
| **Performance** | Response latency and throughput characteristics | Algorithmic choices, caching strategies, runtime configuration |
| **Security** | Resistance to unauthorized access and data breaches | Auth middleware, encryption policies, threat models |
| **Data Integrity** | Protection of data consistency, correctness, and validity | Transaction boundaries, constraints, validation rules |
| **Testability** | Ease of writing and running meaningful tests at all levels | Test patterns, DI conventions, architectural boundary clarity |
| **Interoperability** | Ability to integrate with external systems, standards, and protocols | API adapters, protocol translators, format converters |
| **Cost/Feasibility** | Operational and infrastructure costs; organizational capacity to build and maintain | Entirely an operational/organizational concern |
| **Simplicity** | Cognitive load, implementation complexity, and learning curve | An architectural judgment, not a code artifact |

---

## Evidence Sources

Ordered by evidence hierarchy (ADR-004).

### Tier 1 — Primary Evidence (production code)

**Discovered Production Repos (142 entries)**
Open-source repositories with real users in production. Classified via deep-analysis source code inspection (ADR-002) with zero Indeterminate results. Spans 47 domains, 10+ programming languages, 87 platforms and 55 applications. This is the statistical baseline for all frequency rankings.

**AOSA Production Systems (12 entries)**
Architecture of Open Source Applications (volumes 1-2, 2011-2012). Systems described by their creators: NGINX, LLVM, Git, Riak, SQLAlchemy, Twisted, ZeroMQ, GStreamer, Selenium, Graphite, Puppet, HDFS. Highest individual authority per system — published architectural reasoning from people who built and operated them.

**RealWorldASPNET Production Applications (5 entries)**
Actively maintained production .NET applications with real users: Squidex, Bitwarden, Jellyfin, Orchard Core, nopCommerce. Modern technology stack, real operational pressure.

### Tier 2 — Annotation (qualitative reasoning and teaching examples)

**KataLog Competition Submissions (78 teams)**
O'Reilly Architecture Kata submissions across 11 challenges (Fall 2020 - Winter 2025). Never-built designs evaluated by expert judges. Valued for: ADR documentation (winners average 15 ADRs), judge commentary, cost projections, comparative reasoning across teams solving the same problem, and meta-architectural practices (feasibility analysis, fitness functions). Not primary evidence because no submission was ever deployed.

**Reference Implementations (8 curated + 42 Discovered reference entries)**
Teaching and demonstration repositories showing how to implement specific patterns. Working, deployable code with sample domains. Excluded from frequency rankings per ADR-001. Useful as concrete examples for learning.

---

## Problem Dimensions

The 10 classification dimensions used in [Problem Spaces](problem-spaces.md) to characterize architectural challenges.

| Dimension | Definition | Scale |
|-----------|-----------|-------|
| **Domain Type** | Industry or functional area the system serves | Categorical: Healthcare, E-Commerce, IoT, FinTech, DevTools, etc. |
| **Scale** | Expected user base, transaction volume, or data throughput at maturity | Small → Medium → Large → Very Large |
| **Budget Context** | Financial constraints and organizational type | Startup, Non-Profit, Enterprise, Open-Source Community |
| **Compliance** | Regulatory, legal, and ethical constraints | HIPAA, GDPR, PCI-DSS, SOX, or none |
| **Integration Complexity** | Number and heterogeneity of external systems | Low (1-2) → Medium (3-5) → High (5-8) → Very High (8+) |
| **Real-time Needs** | Latency requirements for data processing | None → Low (minutes) → Medium (seconds) → High (sub-second) → Critical (lives depend on it) |
| **Edge/Offline** | Whether system must operate disconnected or resource-constrained | Yes (smart devices, field operations) / No (cloud-only) |
| **AI/ML Component** | Role of AI or machine learning in the system | None → Peripheral → Supporting → Central |
| **Greenfield/Brownfield** | Building from scratch vs. extending/replacing existing systems | Greenfield, Brownfield (migration), Brownfield (extension), Hybrid |
| **Key Tension** | Central architectural trade-off that, if resolved wrong, undermines the entire system | Free text: e.g., "scalability vs. cost", "consistency vs. availability" |

---

## Key Terms

**Co-occurrence**
Multiple architecture styles present simultaneously in a single repository. Most production repos exhibit 2 styles (74%); style counts per rank sum to more than 142 because repos are multi-style.

**Deep-analysis**
SPEC-022 classification methodology: multi-turn LLM-based source code inspection that examines actual code structure, dependency graphs, and architectural patterns. Replaced heuristic classification (ADR-002). Detects runtime extension points and architectural patterns invisible to filesystem-based analysis.

**Detection bias**
Styles and quality attributes that leave strong code signals (Docker configs, message broker presence, module directories) are more reliably detected than those that are architectural decisions invisible in code (performance tuning, testability strategies). Discovered rankings reflect what is detectable, not necessarily what is most important.

**Evidence confidence tier**
Rating of production evidence strength for a given style. T1: Discovered frequency + AOSA/RealWorld depth (highest). T2: Discovered frequency only. T3: AOSA/RealWorld only. T4: KataLog/RefArch only (lowest).

**Platform vs. Application**
Two values on the scope axis (ADR-001). *Platforms* are infrastructure, frameworks, tools, and SDKs built for other developers (87 entries). *Applications* are end-user products with direct business value (55 entries). Ratio: 1.58:1.

**Production-grade vs. Reference**
Two values on the use-type axis (ADR-001). *Production-grade* entries are real systems used by real users. *Reference* entries are educational, demo, template, or starter code. Only production-grade entries count in frequency rankings.

**Proposal-production gap**
Divergence between which patterns teams propose in competition designs vs. which patterns appear in production code. Sharpest examples: Microservices (50% of teams vs. 8.5% of production repos), Pipeline (0% of teams vs. 9.2% of production repos), Layered (0% of teams vs. 54.9% of production repos).

**Tutorial bias**
Over-representation of certain styles (DDD, CQRS, Hexagonal) when reference/tutorial implementations are counted alongside production code. Corrected by ADR-001 (production-only frequency counts). DDD: 17.8% → 2.1%. CQRS: 10.4% → 0.7%.

---

*Generated: 2026-03-09. All statistics from SPEC-022 production-only frequency recomputation (142 entries, deep-analysis validated per ADR-002). Evidence hierarchy per ADR-004.*
