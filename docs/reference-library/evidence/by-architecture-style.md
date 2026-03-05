# Evidence by Architecture Style

Per-style evidence drawn from 225 entries across 5 sources: 122 Discovered open-source repositories (primary), 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 78 KataLog competition submissions. Styles ranked by frequency in 122 real codebases. See [cross-source-reference.md](cross-source-reference.md) for scoring methodology.

**How to read this document**: Each of the 13 styles below includes an Evidence Summary opening with Discovered frequency, a Cross-Source Evidence Table (Discovered first), qualitative reasoning from KataLog teams ("Why Teams Choose This Style"), and evidence-grounded When to Use / Avoid guidance. For styles with large KataLog samples (Event-Driven: 47 teams, Microservices: 39 teams, Service-Based: 25 teams), only top performers are shown with a note on total count.

> **Detection bias:** Discovered statistics are derived from automated filesystem analysis. Styles and QAs that leave strong filesystem signals (Docker -> Deployability, module boundaries -> Modularity) are overrepresented. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this gap -- teams documented these invisible decisions in ADRs and presentations.

---

## Discovered Frequency Rankings (PRIMARY)

Styles ranked by frequency in 122 real codebases. This is the primary ranking because it represents the largest, most structurally diverse evidence sample -- how architects actually build software in practice.

| Rank | Style | Discovered Repos | % of Corpus | Top Co-occurring Styles | Domains Where Most Common |
|------|-------|-----------------|-------------|------------------------|--------------------------|
| 1 | **Modular Monolith** | 64 | 52% | Event-Driven (38 repos) | Developer Tools, E-Commerce, CMS |
| 2 | **Event-Driven** | 63 | 52% | Modular Monolith (38 repos) | Developer Tools, Messaging, Infrastructure |
| 3 | **Layered** | 29 | 24% | Modular Monolith (18 repos) | E-Commerce, Developer Tools |
| 4 | **Domain-Driven Design** | 27 | 22% | Event-Driven | E-Commerce, Developer Tools |
| 5 | **Microservices** | 26 | 21% | Event-Driven | Developer Tools, Infrastructure |
| 6 | **Pipe-and-Filter** | 19 | 16% | Event-Driven | Data Processing, Infrastructure |
| 7 | **CQRS/Event Sourcing** | 18 | 15% | Event-Driven | Developer Tools, E-Commerce |
| 8 | **Hexagonal/Clean** | 16 | 13% | Event-Driven | Developer Tools |
| 9 | **Serverless** | 6 | 5% | Event-Driven | Infrastructure |
| 10 | **Multi-Agent** | 5 | 4% | Event-Driven | AI/ML |
| 11 | **Space-Based** | 5 | 4% | Event-Driven | Data Grid |
| 12 | **Service-Based** | 4 | 3% | Event-Driven | Infrastructure |
| -- | **Plugin/Microkernel** | 0 | 0% | -- | (detection blind spot) |

### Key Statistical Findings

1. **Modular Monolith and Event-Driven are equally prevalent (52% each) and co-occur in 38 repos.** These are the dominant patterns in real codebases. Their co-occurrence (31% of the entire corpus) suggests they are complementary rather than competing -- Event-Driven communication within a Modular Monolith host is the single most common architectural configuration.

2. **Layered, DDD, and Microservices form a second tier (21-24%).** These appear in roughly one-fifth to one-quarter of repos. Layered + Modular Monolith co-occur in 18 repos, suggesting layered internal structure within modular boundaries.

3. **Plugin/Microkernel has zero Discovered entries despite being production-dominant.** Plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container orchestration. This is a known blind spot in signal-based detection. The 6 production systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce) confirm the pattern is heavily used but structurally undetectable.

4. **Service-Based has thin code presence (4 repos, 3%).** Service-based architecture is harder to detect from structural signals than microservices (fewer Docker Compose services) or event-driven (no message broker config). Yet it has 3 production systems (Selenium, Graphite, Bitwarden), confirming it is under-detected, not under-used.

5. **Microservices shows moderate code presence but zero production evidence.** 26 Discovered repos (21%) vs. 0 production systems. Pruning removed many microservices tutorials and sample apps from the original 54, but the design-production gap remains stark.

---

## Production-Weighted Rankings (SECONDARY)

The Combined Weighted Score below uses production-weighted scoring (20 pts per production system). This alternative ranking validates that Discovered frequency broadly aligns with production adoption, while surfacing styles like Plugin/Microkernel and Pipeline that are invisible to automated detection but dominant in production.

| Rank | Style | Combined Score | KataLog Score | AOSA Count | RealWorld Count | RefArch Count | Discovered Count | Production % |
|------|-------|---------------|---------------|------------|-----------------|---------------|------------------|-------------|
| 1 | Event-Driven | 203 | 94 | 3 | 2 | 5 | 63 | 49% |
| 2 | Plugin/Microkernel | 124 | 4 | 3 | 3 | 0 | 0 | 97% |
| 3 | Pipeline | 120 | 0 | 5 | 1 | 0 | 19 | 100% |
| 4 | Service-Based | 105 | 43 | 2 | 1 | 1 | 4 | 57% |
| 5 | Microservices | 76 | 67 | 0 | 0 | 5 | 26 | 0% |
| 6 | Modular Monolith | 40 | 18 | 0 | 1 | 1 | 64 | 50% |
| 7 | CQRS/Event Sourcing | 33 | 8 | 0 | 1 | 4 | 18 | 61% |
| 8 | Space-Based | 24 | 4 | 1 | 0 | 0 | 5 | 83% |
| 9 | Layered Architecture | 20 | 0 | 1 | 1 | 0 | 29 | 100% |
| 10 | Domain-Driven Design | 16 | 11 | 0 | 0 | 3 | 27 | 0% |
| 11 | Hexagonal/Clean | 16 | 10 | 0 | 0 | 3 | 16 | 0% |
| 12 | Serverless | 14 | 12 | 0 | 0 | 1 | 6 | 0% |
| 13 | Multi-Agent | 8 | 8 | 0 | 0 | 0 | 5 | 0% |

*Production % = share of Combined Score from AOSA + RealWorldASPNET sources. Production-weighted scoring (20 pts per production system) means a single production deployment outweighs an entire Kata competition season.*

---

## 1. Event-Driven

### Evidence Summary

Appears in **63 of 122** Discovered repos (**52%**). Co-occurs most frequently with Modular Monolith (38 repos). Detected through message broker configs (Kafka, RabbitMQ), event bus implementations, and async messaging patterns across Go, Java, C#, and Python.

Validated by 5 production systems: NGINX (event-driven reactor, 30%+ of internet traffic), Twisted (reactor pattern), ZeroMQ (broker-less messaging), Bitwarden (event-driven vault sync), and Squidex (event sourcing as primary persistence). 47 KataLog teams chose this style -- judges noted depth of event-flow design (partitioning keys, consumer groups, dead-letter handling) separated winners from runner-ups.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 63 repos | Statistical signal | Message broker configs (Kafka, RabbitMQ) in 52% of catalog; event bus implementations across Go, Java, C#, Python |
| AOSA | NGINX | Production system | Event-driven reactor handles C10K+; single-threaded event loop per worker process; non-blocking I/O across all connections |
| AOSA | Twisted | Production system | Reactor pattern with deferred callbacks; protocol factory for pluggable transports; single-threaded event loop with cooperative multitasking |
| AOSA | ZeroMQ | Production system | Broker-less messaging with zero-copy; multi-pattern support (pub/sub, push/pull, request/reply); lock-free async I/O thread |
| RealWorld | Bitwarden | Production app | Event-driven notifications for vault sync across devices; service-based decomposition with event bus for cross-service communication; SOC2 compliant |
| RealWorld | Squidex | Production app | Event sourcing as primary persistence -- every content change stored as immutable event; MongoDB event store; full audit trail from event replay |
| RefArch | eShopOnContainers | Reference impl | Integration events between microservices via RabbitMQ/Azure Service Bus; domain events within bounded contexts; outbox pattern for reliability |
| RefArch | eShop | Reference impl | Simplified eShopOnContainers on .NET 8; event-driven communication between catalog, basket, and ordering services |
| RefArch | modular-monolith-with-ddd | Reference impl | Domain events within modules; integration events between modules; in-process event bus with outbox |
| RefArch | serverless-microservices-azure | Reference impl | Event Grid triggers between functions; Event Hubs for telemetry ingestion; serverless event processing pipeline |
| RefArch | wild-workouts-go | Reference impl | Domain events in Go; event-driven communication between training and user services |
| KataLog | 47 teams (top shown below) | Competition designs | Most-used style across all 11 challenges; appeared in every challenge with top-3 placements |

### Why Teams Choose This Style

Top KataLog teams (47 teams total; top performers shown):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| BluzBrothers | 1st | MonitorMe | Kafka + Kubernetes + InfluxDB; proved sub-1-second end-to-end with fitness functions (693ms); 20 ADRs |
| ConnectedAI | 1st | ShopWise AI | Multi-agent + event-driven microservices; Python, LangGraph, FastAPI; 12 ADRs |
| Profitero Data Alchemists | 1st | Road Warrior | Kafka partitioning keys aligned with database; three scaling groups; compacted topics; 15 ADRs |
| Pragmatic | 1st | ClearView | Selective event-driven -- only where interoperability demanded it; service-based primary; 22 ADRs |
| Team Seven | 1st | Sysops Squad | Point-to-point guaranteed-delivery queues for ticket workflow and expert routing; 12 ADRs |
| The Archangels | 1st | Farmacy Family | AWS + Kafka + Graph Database; 18 ADRs documenting event flow |
| MonArch | 1st | Hey Blue! | GCP Pub/Sub with hexagonal internals; modular monolith initial deployment; 7 ADRs |
| ZAITects | 1st | Certifiable Inc. | Service-based + event-driven + hybrid AI pipeline; LangChain, RAG, vector search; 18 ADRs |
| PegasuZ | 1st | Spotlight Platform | Modular monolith MVP with event-driven long-term; GraphQL BFF; 12 ADRs |
| IPT | 2nd | Hey Blue! | DDD + event-driven microservices; Azure Container Apps, Event Hub; 8 ADRs |
| Katamarans | 2nd | ClearView | Event broker with third-party AI services; Azure deployment; 14 ADRs |

**What winners did differently**: Top EDA teams (BluzBrothers, Profitero Data Alchemists, Pragmatic) showed deep event-flow design -- partitioning keys, consumer group configuration, dead-letter handling, and timing proof. Runner-up teams tended to adopt event-driven patterns without the same depth. Winners consistently paired events with additional structure: service-based decomposition (Team Seven, Pragmatic, ZAITects), hexagonal ports and adapters (MonArch), modular monolith boundaries (PegasuZ), or CQRS read/write separation (Iconites).

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- Systems with inherently asynchronous data flows -- sensor streams, email polling, notification broadcasting, analytics pipelines. In the Discovered corpus, event-driven repos cluster in Messaging, Infrastructure, and Developer Tools domains. NGINX confirms the pattern at extreme scale (C10K+); BluzBrothers proved sub-second medical monitoring.
- Domains where multiple consumers need the same event (Bitwarden: vault sync across devices; Squidex: event sourcing for content changes)
- Real-time monitoring and alerting (MonitorMe: all 7 teams used EDA; Road Warrior: 8 of 9 teams)
- Workloads requiring loose coupling between bounded contexts (eShopOnContainers: integration events between microservices)

**When to avoid**:

- Small teams with limited operational experience managing message brokers -- KataLog runner-up teams that declared event-driven without showing mechanics (topic design, partition strategy, dead-letter handling) consistently scored lower
- Problems requiring strong transactional consistency across services without complementary patterns (Saga, Outbox)
- Systems where event infrastructure cost exceeds budget -- particularly non-profit and startup contexts where simpler synchronous communication may suffice initially
- Pure event-driven without complementary structure: KataLog winners consistently paired events with service-based decomposition, hexagonal internals, or CQRS

---

## 2. Modular Monolith

### Evidence Summary

Appears in **64 of 122** Discovered repos (**52%** -- highest of any style). Co-occurs most frequently with Event-Driven (38 repos). Detected through well-structured directory layouts with module boundaries and single deployment artifacts. Dominant in Developer Tools, E-Commerce, and CMS domains.

Validated by 1 production system: Orchard Core (multi-tenant CMS, independent ASP.NET Core modules). 1 reference implementation: modular-monolith-with-ddd (DDD + CQRS + Event-Driven within monolith). 6 KataLog teams chose this style with the highest win rate of any style (83.3%); judges rewarded cost analysis and pragmatic evolutionary reasoning.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 64 repos | Statistical signal | Well-structured directory layouts with module boundaries; single deployment artifacts; most common pattern in Discovered catalog (52% of all repos) |
| RealWorld | Orchard Core | Production app | Multi-tenant CMS built as modular monolith; each feature (themes, widgets, content types, workflows) is an independent ASP.NET Core module; single deployment with module-level boundaries; Lucene-based search, liquid templates, GraphQL API |
| RefArch | modular-monolith-with-ddd | Reference impl | DDD + CQRS + Event-Driven within monolith; module-level bounded contexts (Meetings, Administration, Payments) with integration events between modules; in-process event bus with outbox pattern; strong module isolation enforced by architecture tests |
| KataLog | 6 teams (all shown below) | Competition designs | Highest win rate of all styles (83.3%); 5 of 6 teams placed top-3 |

### Why Teams Choose This Style

All KataLog teams (6 teams, 83.3% win rate):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| ArchColider | 1st | Farmacy Food | Most comprehensive cost analysis; won with contrarian modular monolith against microservices field; 16 ADRs |
| MonArch | 1st | Hey Blue! | Modular monolith initial deployment with hexagonal internals; extraction along bounded-context seams |
| PegasuZ | 1st | Spotlight Platform | Modular monolith as MVP; "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" |
| Rapid Response | 2nd | Wildlife Watcher | 6 microservices designed but deployed as modular monolith initially; only Camera Feed independent |
| Wonderous Toys | 3rd | Wildlife Watcher | Microkernel + modular monolith + event-driven for species identification extensions |
| Arch8s | Runner-up | Spotlight Platform | AWS ECS + Aurora PostgreSQL + Lambda for heavy tasks; 17 ADRs |

**Small sample, strong signal**: With only 6 KataLog teams, the 83.3% win rate is statistically limited but directionally compelling. ArchColider (1st, Farmacy Food) won with a contrarian modular monolith choice against a field of microservices teams, producing the most comprehensive cost analysis. PegasuZ (1st, Spotlight Platform) asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" This pragmatic reasoning characterized all modular monolith winners.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- The Discovered corpus shows modular monolith as the most common pattern across Developer Tools, E-Commerce, and CMS domains. Its 52% frequency and co-occurrence with Event-Driven in 38 repos confirms it as the default starting architecture for most domains.
- Greenfield startup/non-profit projects where the domain model is not yet validated (ArchColider: won against microservices field with cost analysis)
- Small teams (2-5 members) who cannot sustain microservices operational overhead
- When time-to-market and cost are primary drivers (PegasuZ: MVP-first reasoning)
- When paired with hexagonal architecture or DDD bounded contexts, providing documented extraction points (MonArch: hexagonal internals; modular-monolith-with-ddd: module-level bounded contexts)

**When to avoid**:

- Systems that have proven domain boundaries and need independent deployment and scaling
- Large organizations where monolith deployment creates deployment contention across teams
- Systems with fundamentally different scaling characteristics across components (Wildlife Watcher: Camera Feed Engine needed independent scaling, forcing Rapid Response to extract it)

---

## 3. Layered Architecture

### Evidence Summary

Appears in **29 of 122** Discovered repos (**24%**). Co-occurs most frequently with Modular Monolith (18 repos). Detected through directory structures with presentation/business/data layers and dependency flow enforcement. Common in E-Commerce and Developer Tools domains.

Validated by 2 production systems: SQLAlchemy (two-layer Core + ORM, Python standard) and nopCommerce (four-layer architecture, 60K+ stores, 17 years of evolution). Zero KataLog teams proposed layered architecture -- expected, as it is seen as a default rather than an architectural choice in competition contexts.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 29 repos | Statistical signal | Directory structures with presentation/business/data layers; dependency flow enforcement; layer-per-folder project organization |
| AOSA | SQLAlchemy | Production system | Two distinct layers: Core (SQL expression language, schema definition, connection pooling) and ORM (unit of work, identity map, relationship loading); strict layer separation with Core usable independently |
| RealWorld | nopCommerce | Production app | Four-layer architecture: Web (Razor views, API controllers), Services (business logic), Data (Entity Framework, repositories), Core (domain entities, DTOs); 60K+ live stores; 17 years of evolution |

### Why Teams Choose This Style

No KataLog teams explicitly proposed layered architecture. The absence from competition contexts is itself a finding: layered architecture is the default structural approach that teams adopt implicitly rather than declare explicitly. However, nopCommerce's 17-year longevity and SQLAlchemy's ubiquity demonstrate that the pattern's simplicity is a feature, not a limitation.

**Longevity as evidence**: nopCommerce's 17-year evolution through four layers (Web, Services, Data, Core) is among the strongest evidence for any architecture style in the dataset. The architecture has survived the transition from ASP.NET Web Forms to MVC to Razor Pages to modern ASP.NET Core while maintaining the same four-layer structure. This suggests layered architecture's primary value is durability across technology generations, not performance or scalability.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, layered repos co-occur heavily with Modular Monolith (18 of 29 repos), suggesting layered internal structure within modular boundaries is a common configuration.
- Applications where separation of concerns (presentation, business logic, data access) is the primary architectural driver (nopCommerce: 4 layers serving 60K+ stores)
- Library and framework design where layers must be independently usable (SQLAlchemy: Core layer usable without ORM)
- Long-lived applications where team turnover is high and structural simplicity aids onboarding (nopCommerce: 17 years of evolution)
- Domains where distributed deployment is not required and a single deployment unit is acceptable

**When to avoid**:

- Systems requiring independent deployment or scaling of components -- layered architecture assumes a single deployment unit
- High-performance systems where layer-to-layer overhead (even in-process) creates latency (pipeline or event-driven may be more appropriate)
- Domains with complex cross-cutting concerns that do not map cleanly to horizontal layers
- When layer violations are likely due to team discipline issues -- without enforcement, layers degrade into a big ball of mud

---

## 4. Domain-Driven Design

### Evidence Summary

Appears in **27 of 122** Discovered repos (**22%**). Co-occurs most frequently with Event-Driven. Detected through aggregate root patterns, bounded context directory structures, and domain event implementations. Common in E-Commerce and Developer Tools domains.

No production systems use DDD as a primary classifiable style -- this reflects a classification artifact rather than production absence. Real production systems using DDD are classified by their deployment style (microservices, modular monolith). 3 reference implementations: eShopOnContainers (DDD within microservices), modular-monolith-with-ddd (DDD within monolith), wild-workouts-go (DDD in Go). ~10 KataLog teams applied DDD, with judges noting that DDD context mapping provided the strongest decomposition rationale among winners.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 27 repos | Statistical signal | Aggregate root patterns, bounded context directory structures, domain event implementations; second-highest Discovered count among patterns without production evidence |
| RefArch | eShopOnContainers | Reference impl | Bounded contexts as microservice boundaries (Catalog, Basket, Ordering); aggregates with invariant enforcement; domain events for intra-context side effects; value objects (Address, Money); anti-corruption layers and context mapping between services |
| RefArch | modular-monolith-with-ddd | Reference impl | DDD tactical patterns within monolith modules (Meetings: aggregate root with rich domain model, Administration: simpler CRUD); each module owns its domain model; integration events for cross-module communication |
| RefArch | wild-workouts-go | Reference impl | DDD in Go idiom; Training bounded context with aggregate roots; domain events; repository pattern with interface-based ports; demonstrates DDD outside the Java/C# ecosystem |
| KataLog | ~10 teams (top shown below) | Competition designs | Applied as decomposition methodology within other primary styles |

### Why Teams Choose This Style

Top KataLog teams applying DDD:

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| ArchColider | 1st | Farmacy Food | Event sourcing + DDD bounded contexts in modular monolith; domain model as primary decomposition driver; 16 ADRs |
| IPT | 2nd | Hey Blue! | DDD context mapping + event-driven microservices; Azure Container Apps with Event Hub; 8 ADRs |
| Shokunin | Runner-up | Spotlight Platform | DDD + federated GraphQL; ElasticSearch + Redis for internal event messaging; 6 ADRs |
| Miyagi's Little Forests | 2nd | Farmacy Food | DDD context maps to microservice boundaries with element catalogs; hexagonal internal structure; 6 ADRs |

**Methodology vs. architecture**: DDD's zero production evidence likely reflects a classification artifact. The 27 Discovered repos -- highest among zero-production styles -- confirm that DDD tactical patterns (aggregates, value objects, domain events) are widely implemented in code even when the primary style classification captures the deployment architecture. The most successful KataLog microservices teams (MonArch, IPT, ArchColider) used DDD context mapping to justify service boundaries.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered corpus, DDD repos (22%) co-occur frequently with Event-Driven, suggesting domain events are the most common DDD tactical pattern in practice.
- Complex business domains where the domain model drives architectural decomposition (eShopOnContainers: bounded contexts as microservice boundaries)
- Systems requiring explicit boundaries between subdomains with anti-corruption layers
- As a decomposition methodology within any primary style -- modular monolith, microservices, or service-based (modular-monolith-with-ddd: DDD within monolith; eShopOnContainers: DDD within microservices)
- When the team includes domain experts who can participate in ubiquitous language and context mapping

**When to avoid**:

- Simple CRUD applications where the overhead of aggregates, value objects, and bounded contexts is not justified
- Domains where the business logic is thin and the complexity is in infrastructure or integration rather than domain modeling
- Teams without access to domain experts -- DDD requires continuous collaboration between developers and domain experts
- As a standalone architecture without a primary hosting style -- DDD is a methodology, not a deployment architecture

---

## 5. Microservices

### Evidence Summary

Appears in **26 of 122** Discovered repos (**21%**). Co-occurs most frequently with Event-Driven. Detected through Docker Compose multi-service layouts, API gateway configs, and per-service databases. Pruned from a higher count by removing tutorials and sample apps. Common in Developer Tools and Infrastructure domains.

Zero production systems across AOSA and RealWorld. 5 reference implementations: eShopOnContainers, eShop, serverless-microservices-azure, AKS Baseline, wild-workouts-go. 39 KataLog teams chose this style (second-most popular); judges noted that winners paired microservices with DDD and event-driven, while runner-ups adopted it as default without justification.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 26 repos | Statistical signal | Docker Compose multi-service layouts, API gateway configs, per-service databases; pruned from higher count by removing tutorials and sample apps |
| RefArch | eShopOnContainers | Reference impl | Microsoft canonical microservices sample; Catalog, Basket, Ordering, Identity as independent services; DDD aggregates, CQRS in Ordering, integration events via RabbitMQ/Azure Service Bus; Docker Compose and Kubernetes deployment; ~15K GitHub stars |
| RefArch | eShop | Reference impl | Simplified eShopOnContainers on .NET 8 Aspire; same service boundaries with reduced operational complexity; modern .NET hosting model |
| RefArch | serverless-microservices-azure | Reference impl | Serverless microservices on Azure Functions; Event Grid for inter-service communication; Durable Functions for orchestration; ride-sharing domain with Trips, Drivers, Passengers services |
| RefArch | AKS Baseline | Reference impl | Production-grade AKS cluster; service mesh (Linkerd/Istio), NGINX ingress, Azure Monitor, Key Vault integration; microservices deployment target with security and observability baseline |
| RefArch | wild-workouts-go | Reference impl | Microservices in Go; DDD bounded contexts (Training, User); Hexagonal ports/adapters per service; CQRS command/query handlers; gRPC and HTTP adapters |
| KataLog | 39 teams (top shown below) | Competition designs | Second-most popular style; winners paired with DDD and event-driven; runner-ups adopted as default without justification |

### Why Teams Choose This Style

Top KataLog teams (39 teams total; top performers shown):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| CELUS Ceals | 1st | Wildlife Watcher | Scored microservices against 4 criteria in ADR-007; acknowledged simplicity trade-off; 15 ADRs |
| ConnectedAI | 1st | ShopWise AI | Multi-agent + event-driven microservices; Python, LangGraph, FastAPI; 12 ADRs |
| MonArch | 1st | Hey Blue! | Hexagonal internals; proposed modular monolith initial deployment with microservices extraction; 7 ADRs |
| PegasuZ | 1st | Spotlight Platform | Modular monolith MVP with documented extraction to microservices; 12 ADRs |
| Rapid Response | 2nd | Wildlife Watcher | 6 microservices designed but 5 deployed as monolith; only Camera Feed independent; 8 ADRs |
| IPT | 2nd | Hey Blue! | DDD context mapping to microservices boundaries; Azure Container Apps; 8 ADRs |
| Miyagi's Little Forests | 2nd | Farmacy Food | Hexagonal per-service structure; AWS EKS with ECR; 6 ADRs |
| The Marmots | 2nd | Spotlight Platform | Static SPA frontend with route handlers; 19 ADRs |
| Ctrl+Alt+Elite | 3rd | ClearView | AWS + Kafka event broker; Golang; 20 ADRs |

**Over-engineering signal from KataLog**: In the Sysops Squad challenge, the sole microservices team (Arch Mahal) placed as runner-up while all 6 service-based teams placed higher. In ClearView, the sole pure microservices team (Jazz Executor) placed as runner-up. The strongest KataLog performers (MonArch, PegasuZ, Rapid Response) all proposed evolutionary paths starting simpler and decomposing into microservices -- not microservices from day one.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, microservices repos (21%) cluster in Developer Tools and Infrastructure domains and co-occur with Event-Driven, confirming that microservices without async communication are rare in practice.
- Systems with well-understood domain boundaries where independent deployment and scaling provide clear value (eShopOnContainers: Catalog, Basket, Ordering as independent services)
- Organizations with mature DevOps capabilities and experience operating distributed systems (AKS Baseline: production-grade cluster configuration)
- When paired with DDD, event storming, or explicit evolutionary paths -- every winning KataLog team justified decomposition with domain analysis
- Large teams needing parallel development independence across service boundaries

**When to avoid**:

- Greenfield projects where the domain model is still evolving -- modular monolith or service-based provides a safer starting point (MonArch, PegasuZ both proposed this)
- Small teams who cannot sustain the operational burden (Sysops Squad: 6 of 7 teams chose service-based over microservices)
- Budget-constrained contexts where the infrastructure overhead is prohibitive
- When adopted as a default without justifying the operational complexity -- KataLog runner-up microservices teams consistently scored lower when they declared the style without showing domain decomposition rationale

---

## 6. Pipe-and-Filter

### Evidence Summary

Appears in **19 of 122** Discovered repos (**16%**). Co-occurs most frequently with Event-Driven. Detected through stage-based directory layouts, pipeline configuration files, and data transformation chains. Common in Data Processing and Infrastructure domains.

Validated by 6 production systems: NGINX (HTTP request processing pipeline, 30%+ of internet), LLVM (3-phase compiler pipeline), GStreamer (media pipeline), Graphite (metrics collection-storage-rendering), ZeroMQ (I/O thread pipeline), and Jellyfin (transcoding pipeline). Zero KataLog teams proposed this style -- pipeline solves data-transformation problems that rarely appear in Kata problem statements.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 19 repos | Statistical signal | Data processing pipelines, ETL systems, stream processors; structural signals include stage-based directory layouts and pipeline configuration files |
| AOSA | NGINX | Production system | HTTP request processing pipeline: accept -> read -> parse -> process -> filter -> send; each phase is a handler in a chain; output filters for gzip, chunked encoding, SSI; serves 30%+ of internet traffic |
| AOSA | LLVM | Production system | 3-phase compiler pipeline: frontend (C/C++/Rust parsing) -> IR (optimization passes) -> backend (x86/ARM/WASM code gen); passes are composable and reorderable; foundation of Apple Clang, Rust compiler, Swift compiler |
| AOSA | GStreamer | Production system | Media pipeline: source -> demux -> decode -> filter -> encode -> sink; elements connected via pads with capability negotiation; dynamic pipeline reconfiguration |
| AOSA | Graphite | Production system | Carbon (collection with line/pickle/AMQP receivers) -> Whisper (fixed-size time-series storage) -> Graphite-Web (Django rendering/API); Carbon relay for fan-out |
| AOSA | ZeroMQ | Production system | I/O thread pipeline: socket -> session -> encoder -> engine; zero-copy message passing between stages; batch processing in pipeline for throughput |
| RealWorld | Jellyfin | Production app | Transcoding pipeline: input -> demux -> decode -> filter (scale, subtitle burn) -> encode -> mux -> output; FFmpeg-based with pluggable codec support |

### Why Teams Choose This Style

No KataLog teams explicitly proposed pipeline architecture. The complete absence from competition is itself a finding: pipeline architecture solves data-transformation and request-processing problems that rarely appear in Kata problem statements (which tend toward business-domain coordination). This suggests the pattern is under-recognized in architecture education despite dominating infrastructure software.

**Composability as key differentiator**: LLVM's passes can be reordered and composed arbitrarily. GStreamer's elements connect via negotiated pads. NGINX's output filters chain transparently. In every AOSA case, the pipeline's power comes from composable stages with well-defined input/output contracts -- not from the linear topology alone but from the interchangeability of stages within that topology.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, pipeline repos cluster in Data Processing and Infrastructure domains. The 19 repos confirm broad adoption in data engineering contexts.
- Data transformation chains where each stage has a single responsibility (LLVM: parse -> optimize -> codegen; Graphite: collect -> store -> render)
- Request processing with ordered filter chains (NGINX: accept -> parse -> process -> filter -> respond)
- Media processing with format negotiation (GStreamer: source -> decode -> filter -> encode -> sink; Jellyfin: transcoding pipeline)
- Systems where stages must be independently testable, replaceable, or reorderable

**When to avoid**:

- Business-domain coordination problems requiring bidirectional communication between components (pipeline is inherently unidirectional)
- Systems where the processing order is not well-defined or changes dynamically per request (though GStreamer demonstrates dynamic pipeline reconfiguration is possible, it adds significant complexity)
- Interactive applications where user input drives non-linear control flow
- Architectures where stages have heavy shared state -- pipeline assumes each stage passes data forward with minimal coupling

---

## 7. CQRS/Event Sourcing

### Evidence Summary

Appears in **18 of 122** Discovered repos (**15%**). Co-occurs most frequently with Event-Driven. Detected through command/query separation patterns, event store configurations, and projection/read-model builders. Common in Developer Tools and E-Commerce domains.

Validated by 1 production system: Squidex (full event sourcing, MongoDB event store, headless CMS). 4 reference implementations: eShopOnContainers, modular-monolith-with-ddd, wild-workouts-go, clean-architecture-dotnet. ~5 KataLog teams applied CQRS, consistently pairing it with event-driven communication.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 18 repos | Statistical signal | Command/query separation patterns, event store configurations, projection/read-model builders |
| RealWorld | Squidex | Production app | CQRS + event sourcing as primary architecture; every content change stored as immutable event; MongoDB event store; full event history enables audit trail, temporal queries, and replay; headless CMS |
| RefArch | eShopOnContainers | Reference impl | CQRS in Ordering service: separate read/write models; MediatR for command/query dispatch; integration events for cross-service eventual consistency |
| RefArch | modular-monolith-with-ddd | Reference impl | CQRS within monolith modules; separate command and query handlers per module; in-process event bus |
| RefArch | wild-workouts-go | Reference impl | CQRS in Go; command handlers for training mutations, query handlers for read models; separate write and read repositories |
| RefArch | clean-architecture-dotnet | Reference impl | CQRS with Hexagonal architecture; MediatR pipeline for commands and queries; clean separation of read/write concerns |
| KataLog | Iconites | 2nd, Road Warrior | Event-driven + space-based + CQRS read/write separation for travel itinerary management |
| KataLog | Street Fighters | Runner-up, Road Warrior | Kubernetes + message broker + CQRS for trip data |

### Why Teams Choose This Style

KataLog evidence is thin (~5 teams) but consistent: teams using CQRS paired it with event-driven communication. Iconites (2nd, Road Warrior) used CQRS read/write separation for travel itinerary management alongside space-based and event-driven patterns.

**Squidex as canonical production CQRS**: Squidex stores every content mutation as an immutable event in MongoDB. The current state is derived from event replay. This enables temporal queries ("what did this content look like on date X?"), complete audit trails, and event-based integrations with downstream systems. Squidex demonstrates that full event sourcing (not just CQRS read/write separation) is viable in production for content management domains where the event history has intrinsic business value.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, CQRS repos (15%) co-occur with Event-Driven, confirming the patterns are complementary in practice. All 4 reference implementations apply CQRS within bounded contexts, not system-wide.
- Systems requiring complete audit trails and temporal queries (Squidex: full event history for content management)
- Domains with asymmetric read/write loads where read models can be independently optimized (eShopOnContainers: separate read/write models in Ordering)
- Within specific bounded contexts that benefit from separate read/write models, not as a system-wide mandate (eShopOnContainers uses CQRS only in Ordering, not Catalog or Basket)
- When paired with event sourcing for domains where the event history itself is valuable (content management, financial transactions, compliance-regulated systems)

**When to avoid**:

- Simple CRUD domains where the overhead of separate read/write models is not justified
- Teams unfamiliar with eventual consistency -- CQRS introduces eventual consistency between command and query sides that must be explicitly managed
- Systems where a single relational model adequately serves both reads and writes
- As a system-wide pattern applied uniformly -- every reference implementation applies it selectively

---

## 8. Hexagonal/Clean Architecture

### Evidence Summary

Appears in **16 of 122** Discovered repos (**13%**). Co-occurs most frequently with Event-Driven. Detected through port/adapter directory structures, dependency inversion patterns, and clean architecture layer organization across Java, C#, Go, TypeScript, and Kotlin.

No production systems use hexagonal as a primary classifiable style -- like DDD, it serves as an internal structure within other styles. 3 reference implementations: buckpal (Java, hexagonal purity), clean-architecture-dotnet (C# + CQRS), wild-workouts-go (Go idiom). ~6 KataLog teams applied hexagonal, consistently as internal structure within modular monolith or microservices.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 16 repos | Statistical signal | Port/adapter directory structures, dependency inversion patterns, clean architecture layer organization; languages include Java, C#, Go, TypeScript, Kotlin |
| RefArch | buckpal | Reference impl | Hexagonal purity as primary goal; banking sample (Send Money use case); incoming ports (use cases), outgoing ports (persistence, external); adapters (web controller, JPA persistence, external API); dependency rule enforced via compile-time checks; Tom Hombergs' companion to "Get Your Hands Dirty on Clean Architecture" |
| RefArch | clean-architecture-dotnet | Reference impl | Hexagonal + CQRS in C#; four projects (Domain, Application, Infrastructure, Web); MediatR pipeline behaviors for cross-cutting concerns; ports as Application-layer interfaces; FluentValidation for command validation |
| RefArch | wild-workouts-go | Reference impl | Hexagonal in Go; port interfaces (TrainingRepository, UserService); adapters for HTTP, gRPC, and in-memory test implementations; DDD aggregate roots within hexagonal boundary; demonstrates idiomatic Go approach to ports-and-adapters |
| KataLog | MonArch | 1st, Hey Blue! | Hexagonal internals within modular monolith; ports and adapters ensuring each module can be extracted without rewriting business logic; 7 ADRs |
| KataLog | Miyagi's Little Forests | 2nd, Farmacy Food | Hexagonal + event-driven microservices; AWS EKS with hexagonal internal structure per service; element catalog per service; 6 ADRs |
| KataLog | Architects++ | 3rd, Farmacy Family | Hexagonal + service-based + batch processing; AWS Batch with hexagonal internal structure; 15 ADRs |

### Why Teams Choose This Style

KataLog and RefArch sources agree that hexagonal architecture excels as an internal structure within other styles. MonArch (1st, Hey Blue!) used hexagonal internals within a modular monolith; Miyagi's Little Forests (2nd, Farmacy Food) used it within microservices. This pattern -- hexagonal as internal structure, not primary architecture -- is consistent across all sources.

**Three reference implementations, three languages, one pattern**: buckpal (Java), clean-architecture-dotnet (C#), and wild-workouts-go (Go) implement hexagonal architecture in different languages and domains but converge on identical structural principles: domain logic at the center with no outward dependencies, port interfaces defined in the application layer, and adapters at the boundary handling infrastructure concerns. This cross-language consistency is stronger evidence for the pattern's generality than any single implementation.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered corpus, hexagonal repos (13%) co-occur with Event-Driven, suggesting port/adapter patterns are common in event-driven codebases where adapters isolate message broker dependencies.
- As internal structure within services or modules to ensure business logic independence from infrastructure (MonArch: hexagonal within modular monolith modules; Miyagi's Forests: hexagonal within microservices)
- Systems where infrastructure components (databases, message brokers, external APIs) are expected to change (buckpal: adapter swapping without domain changes)
- When testability of business logic in isolation is a hard requirement (all three RefArch implementations emphasize in-memory adapter testing)
- As a structural discipline that makes future extraction or migration safer (MonArch: hexagonal internals ensured extraction-readiness)

**When to avoid**:

- Simple applications where the overhead of port/adapter indirection adds complexity without benefit
- Teams unfamiliar with dependency inversion and port/adapter patterns -- incorrect implementation creates more coupling, not less
- As a primary architecture style for system-level decomposition -- hexagonal is an internal structure pattern, not a deployment architecture
- CRUD-dominated applications where the domain logic is thin and the port/adapter ceremony provides no meaningful isolation

---

## 9. Serverless

### Evidence Summary

Appears in **6 of 122** Discovered repos (**5%**). Co-occurs most frequently with Event-Driven. Detected through function-as-a-service configurations, event trigger definitions, and serverless framework configs. Common in Infrastructure domains.

Zero production systems across AOSA and RealWorld. 1 reference implementation: serverless-microservices-azure. 8 KataLog teams chose this style (25% win rate); judges noted serverless performed best as a component within broader architectures, with cost optimization as the universal rationale.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 6 repos | Statistical signal | Function-as-a-service configurations, event trigger definitions, serverless framework configs |
| RefArch | serverless-microservices-azure | Reference impl | Azure Functions + Event Grid + Event Hubs; ride-sharing domain with serverless microservices; Durable Functions for orchestration; API Management for gateway |
| KataLog | 8 teams (top shown below) | Competition designs | Strongest in cost-sensitive contexts; best when combined with other patterns |

### Why Teams Choose This Style

Top KataLog teams (8 teams total; top performers shown):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| MonArch | 1st | Hey Blue! | GCP Cloud Run (serverless containers) + Pub/Sub; serverless as deployment model within broader architecture |
| TheGlobalVariables | 3rd | Spotlight Platform | AWS Lambda + DynamoDB; calculated per-user cost at $0.002/month with lock-in cost formula |
| It Depends | Runner-up | Hey Blue! | Serverless + event sourcing; burst-pattern economics (daytime activity, near-zero overnight) |
| Jaikaturi | Runner-up | Farmacy Food | GCP Firebase + Cloud Functions; argued serverless eliminated VM maintenance overhead |
| Los Ingenials | Runner-up | Hey Blue! | AWS EKS + Lambda hybrid; microservices with serverless for specific functions |
| Berlin Bears | Runner-up | Farmacy Family | AWS Lambda + Step Functions + DynamoDB; fully serverless stack |

**Cost-optimization as primary driver**: Every KataLog team that chose serverless cited cost as the primary rationale. TheGlobalVariables calculated $0.002/user/month. It Depends argued Hey Blue!'s burst pattern (daytime activity, near-zero overnight) mapped to scale-to-zero economics. Jaikaturi argued serverless eliminated VM maintenance overhead. This positions serverless as an economic architecture choice rather than a structural one -- chosen for billing model, not for system organization.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- Serverless repos in the Discovered corpus (5%) are rare but cluster in Infrastructure domains, co-occurring with Event-Driven -- confirming serverless works best as a component in event-driven workflows.
- Non-profit and ultra-cost-sensitive contexts where pay-per-request pricing aligns with budget constraints (TheGlobalVariables: $0.002/user/month)
- Systems with highly intermittent or bursty workloads (It Depends: daytime-only pattern for Hey Blue!)
- As a deployment model for specific components within a broader architecture (MonArch: serverless containers; Los Ingenials: Lambda for specific functions)
- MVP/prototype contexts where eliminating infrastructure management accelerates delivery

**When to avoid**:

- Systems requiring consistent low-latency responses (cold start penalties)
- Workloads with sustained high throughput (MonitorMe's continuous sensor streams)
- As a standalone primary architecture -- all evidence shows serverless succeeds as a component, not a system-level style
- When vendor lock-in is a significant concern and the team has not evaluated multi-cloud portability

---

## 10. Multi-Agent

### Evidence Summary

Appears in **5 of 122** Discovered repos (**4%**). Co-occurs most frequently with Event-Driven. Detected through agent orchestration patterns, multi-model configurations, and LLM chain definitions. Common in AI/ML domains.

Zero production systems, zero reference implementations. ~3 KataLog teams (AI-focused challenges, Winter 2024-2025); judges noted that constrained agent autonomy through supervisor hierarchies and formal evaluation frameworks separated winners from the field.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 5 repos | Statistical signal | Agent orchestration patterns, multi-model configurations, LLM chain definitions |
| KataLog | ConnectedAI | 1st, ShopWise AI | Multi-agent supervisor hierarchy with LangGraph; dual-LLM cost optimization (Claude for reasoning, Gemini for routing); quantitative evaluation with Ragas + LangFuse |
| KataLog | Breakwater | 2nd, ShopWise AI | Multi-agent workflow-orchestrated with n8n; OpenAI + PostgreSQL; workflow engine as agent coordinator |
| KataLog | Usfive | Runner-up, Certifiable Inc. | Multi-agent scoring with multiple LLMs; confidence-based escalation between agents |

### Why Teams Choose This Style

Multi-agent is the newest and least-evidenced style, appearing exclusively in the AI-focused Kata challenges. Within its limited evidence, a consistent pattern emerges: successful multi-agent teams constrained agent autonomy through supervisor hierarchies, workflow orchestration, and confidence-based escalation.

**Architectural governance as differentiator**: ConnectedAI built a supervisor hierarchy where a routing agent delegated to specialized agents (product search, recommendation, FAQ), each with explicit capability boundaries and fallback paths. Breakwater used n8n workflow orchestration to coordinate agents with deterministic handoff points. Both approaches constrain agent autonomy -- the winning pattern is not autonomous agents but orchestrated agents with defined contracts, mirroring the plugin/microkernel pattern's core-extension relationship in an AI context.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered corpus, multi-agent repos (4%) cluster in AI/ML domains. The pattern is nascent but growing.
- AI systems where multiple specialized models or agents must collaborate on complex tasks (ConnectedAI: supervisor hierarchy with role-specific agents)
- Domains where confidence-based escalation between AI and human reviewers is required (Usfive: multi-agent scoring with escalation)
- When different AI capabilities (reasoning, routing, extraction, evaluation) are best served by different models or prompting strategies (ConnectedAI: Claude for reasoning, Gemini for routing)
- Systems requiring formal evaluation frameworks for AI output quality

**When to avoid**:

- Systems where a single model or prompt chain suffices -- multi-agent adds orchestration complexity that must be justified
- Production systems without established AI observability, guardrails, and evaluation infrastructure
- Teams without experience managing non-deterministic distributed systems -- multi-agent compounds the challenges of both distributed systems and AI uncertainty
- Any context where the pattern lacks production validation -- this is the least-proven style in the entire evidence base

---

## 11. Space-Based

### Evidence Summary

Appears in **5 of 122** Discovered repos (**4%**). Co-occurs most frequently with Event-Driven. Detected through in-memory data grid patterns and distributed caching configurations. Common in Data Grid domains.

Validated by 1 production system: Riak (peer-to-peer distributed key-value store, tunable consistency, no single point of failure). ~2 KataLog teams chose this style for high-concurrency, peak-load scenarios.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 5 repos | Statistical signal | In-memory data grid patterns, distributed caching configurations |
| AOSA | Riak | Production system | Peer-to-peer distributed key-value store; consistent hashing for data partitioning; tunable consistency (read/write quorum); no single point of failure; rack-aware replica placement |
| KataLog | Iconites | 2nd, Road Warrior | Space-based + event-driven + microservices; Cosmos DB + Redis for in-memory data grid; designed for Road Warrior's 15M user peak-load scenario |
| KataLog | LowCode | 3rd (tied), MonitorMe | Distributed system with event bus and distributed appliance nodes; space-based topology for medical device data |

### Why Teams Choose This Style

KataLog evidence is sparse (2 teams) but targeted: both teams chose space-based for high-concurrency, peak-load scenarios (Road Warrior's 15M users, MonitorMe's distributed sensor nodes).

**Riak's architectural lessons**: Riak demonstrates the core space-based principles at infrastructure scale: no master node (peer-to-peer), data distributed via consistent hashing across a ring, tunable N/R/W values allowing per-request consistency-availability trade-offs, and hinted handoff for partition tolerance. These same principles (replicated data, no central coordinator, tunable consistency) define the application-level space-based architecture pattern, making Riak both an implementation of and infrastructure for space-based systems.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, space-based repos (4%) cluster in Data Grid domains, consistent with the pattern's focus on distributed in-memory data management.
- Systems with extreme concurrency requirements where traditional database-backed architectures create bottlenecks (Riak: peer-to-peer with no single point of failure)
- Variable and unpredictable peak loads where elastic scaling of processing units is needed (Iconites: 15M user peak for Road Warrior)
- Applications where in-memory data grids can eliminate database round-trips for hot data paths (session state, real-time pricing, leaderboards)
- Distributed sensor or IoT networks with local processing requirements (LowCode: distributed appliance nodes for MonitorMe medical devices)

**When to avoid**:

- Systems where data consistency requirements are strict -- space-based architectures trade consistency for availability (Riak's tunable consistency still involves eventual consistency trade-offs; AP side of CAP theorem)
- Applications with small, predictable loads where the infrastructure complexity of data grids is not justified
- Teams without experience operating distributed data infrastructure -- space-based failure modes (split-brain, replication lag, rebalancing storms) require deep operational expertise
- Domains where the data model does not partition well across processing units (highly relational data with cross-partition joins)

---

## 12. Service-Based

### Evidence Summary

Appears in **4 of 122** Discovered repos (**3%**). Co-occurs most frequently with Event-Driven. Detected through coarse-grained service boundaries with shared database patterns -- but service-based architecture is harder to detect from structural signals than microservices or event-driven, making this count likely an underestimate.

Validated by 3 production systems: Graphite (three coarse-grained services), Selenium (hub-node topology), and Bitwarden (SOC2-certified service-based decomposition). 1 reference implementation: AKS Baseline. 25 KataLog teams chose this style -- dominant in budget-constrained and monolith-migration contexts (Sysops Squad: 6/7 teams, Certifiable Inc.: 6/7 teams).

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 4 repos | Statistical signal | Coarse-grained service boundaries with shared database patterns (likely underdetected) |
| AOSA | Graphite | Production system | Carbon (collection), Whisper (time-series storage), Graphite-Web (rendering/API) -- three coarse-grained services with clear boundaries; independently deployable but sharing a common data format |
| AOSA | Selenium | Production system | WebDriver protocol with per-browser adapter drivers; hub-node topology for distributed test execution; coarse service decomposition (hub, node, driver) |
| RealWorld | Bitwarden | Production app | Zero-knowledge vault with service-based decomposition: API, Identity, Admin, Events, Notifications; shared database with service-level access control; SOC2 certified |
| RefArch | AKS Baseline | Reference impl | Microservices + service-based on Kubernetes; AKS cluster with ingress controller, service mesh, and coarse service boundaries |
| KataLog | 25 teams (top shown below) | Competition designs | Dominant style in Sysops Squad (6/7 teams) and Certifiable Inc. (6/7 teams); chosen for budget-constrained and monolith-migration contexts |

### Why Teams Choose This Style

Top KataLog teams (25 teams total; top performers shown):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| Pragmatic | 1st | ClearView | Service-based for feasibility + testability; events only where interoperability demanded it; 22 ADRs |
| Team Seven | 1st | Sysops Squad | Service-based migration from monolith; guaranteed-delivery queues for cross-domain communication; 12 ADRs |
| ZAITects | 1st | Certifiable Inc. | Service-based + event-driven + hybrid AI-human pipeline; LangChain, RAG, vector search; 18 ADRs |
| ArchElekt | 2nd | Sysops Squad | Problem-first design with clear ADR-to-problem tracing; API Gateway + persistent queue; 12 ADRs |
| Litmus | 2nd | Certifiable Inc. | RAG + LLM + ETL data pipeline in service-based topology; 18 ADRs |
| Sever Crew | 2nd | Farmacy Family | AWS + Kafka integration layer; service-based with event-driven communication; 11 ADRs |
| Architects++ | 3rd | Farmacy Family | Hexagonal + service-based + batch processing; AWS Batch; 15 ADRs |
| The Mad Katas | 3rd | Sysops Squad | Micro frontend + service-based; Graph Database (Neo4j); 17 ADRs |
| Software Arch Guild | 3rd | Certifiable Inc. | Microkernel plug-in for AI grading solutions within service-based topology; 6 ADRs |

**KataLog winner pattern**: Top service-based teams distinguished themselves by adding event-driven communication where async was natural (Team Seven, Pragmatic, ZAITects) while keeping the overall deployment and data model simpler than full microservices. Service-based was the dominant choice when budget constraints were explicit: Sysops Squad (6/7 teams), Certifiable Inc. (6/7 teams), and frequently as Phase 1 of an evolutionary approach with microservices as a documented future state.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- Service-based repos in the Discovered corpus (3%) are likely underdetected -- they look like monoliths in code structure while having service-level deployment boundaries. The 3 production systems (Selenium, Graphite, Bitwarden) confirm it is under-detected, not under-used.
- Monolith migration where independent deployability is needed without full microservices complexity (Sysops Squad: near-unanimous choice; Graphite: independently scalable but coarse-grained)
- Budget-constrained and non-profit contexts (ClearView, Certifiable Inc. winners chose service-based citing cost)
- AI-integration scenarios where the primary goal is adding AI capabilities to existing platforms (Certifiable Inc.: 6 of 7 teams)
- Organizations with limited DevOps maturity needing fault isolation without distributed systems overhead (Bitwarden: SOC2 with service-based)

**When to avoid**:

- Systems requiring extreme independent scalability across service boundaries (Graphite eventually required relay fan-out for scale)
- Large teams (10+) that benefit from microservices-level independence for parallel development
- Domains with high throughput requirements where shared database becomes a bottleneck

---

## 13. Plugin/Microkernel

### Evidence Summary

Appears in **0 of 122** Discovered repos (**0%** -- structurally undetectable by automated classification). Plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container configs. This is the most significant detection blind spot in the Discovered corpus.

Validated by 6 production systems (the most of any style except Event-Driven): LLVM (plugin pass architecture), GStreamer (pipeline elements as loadable plugins), SQLAlchemy (dialect plugins for database backends), Jellyfin (plugin system for metadata/notification/auth), nopCommerce (plugin marketplace, 60K+ stores), and Orchard Core (multi-tenant module system). Combined Weighted Score: 124 (rank #2), with 97% from production evidence. ~4 KataLog teams proposed it.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 0 repos | Detection blind spot | Plugin architectures are runtime behaviors, not filesystem signals -- known limitation of automated classification |
| AOSA | LLVM | Production system | Plugin pass architecture -- optimization and analysis passes loaded dynamically; modular IR enables third-party backends; 3-phase compiler pipeline with pluggable stages |
| AOSA | GStreamer | Production system | Pipeline elements as loadable plugins; negotiation protocol between elements; plugin registry with lazy loading and caching |
| AOSA | SQLAlchemy | Production system | Dialect plugins for database backends (PostgreSQL, MySQL, SQLite, Oracle); Core layer (SQL expression) + ORM layer; engine plugins for connection customization |
| RealWorld | Jellyfin | Production app | Self-hosted media server; plugin system for metadata providers, notification targets, authentication backends; transcoding pipeline with pluggable codecs |
| RealWorld | nopCommerce | Production app | 60K+ live stores over 17-year evolution; plugin marketplace for payments, shipping, tax, widgets; four-layer architecture with plugin injection points |
| RealWorld | Orchard Core | Production app | Multi-tenant CMS; module system where each feature is an independent module (themes, widgets, content types); ASP.NET Core module loading |
| KataLog | Software Architecture Guild | 3rd, Certifiable Inc. | Microkernel with plug-in AI grading solutions; six parallel AI solutions via plug-in architecture |
| KataLog | Wonderous Toys | 3rd, Wildlife Watcher | Micro Kernel paired with modular monolith and event-driven for species identification extensions |

### Why Teams Choose This Style

KataLog's near-invisibility of this pattern (~4 teams) suggests competition contexts (time-limited, greenfield) do not surface the long-lifecycle pressures where plugin architecture proves its value. The 6 production systems span entirely different domains -- compilers, media, databases, e-commerce, CMS -- but converge on the same structural pattern: a stable core with a well-defined extension contract.

**Cross-domain consistency**: The plugin contract varies by domain (LLVM: pass interface; GStreamer: element/pad protocol; SQLAlchemy: dialect API; nopCommerce: IPlugin interface; Orchard Core: ASP.NET Core module manifest) but the architectural invariant is identical: the core defines the contract, plugins implement it, and the core never depends on any specific plugin. This is the strongest cross-domain convergence signal in the evidence base.

### When to Use / Avoid

**When to use** -- grounded in production evidence (Discovered data unavailable due to detection blind spot):

- Products requiring third-party extensibility without core modification (nopCommerce: 60K+ stores with marketplace plugins; Orchard Core: tenant-specific feature modules)
- Systems spanning multiple backends or protocols (SQLAlchemy: dialect plugins for every major database; GStreamer: codec and element plugins for media formats)
- Compiler, build-tool, and IDE architectures (LLVM: pass-based optimization pipeline; every major IDE uses plugin architecture)
- Long-lived products (10+ years) where the domain is stable but extensions are unpredictable (nopCommerce: 17 years of evolution)

**When to avoid**:

- Greenfield projects with uncertain core requirements -- the core must be stable before investing in extension contracts
- Time-limited competition contexts where the overhead of defining plugin APIs does not pay off (only ~4 of 78 KataLog teams used this style)
- Systems where all functionality is known upfront and extension is not a requirement
- When the team lacks experience designing stable API contracts -- poorly designed plugin interfaces create worse coupling than monoliths

---

## Source Coverage Matrix

Shows which sources provide evidence for each style. Filled cells indicate at least one entry; numbers show entry count. Ordered by Discovered frequency.

| Style | Discovered | AOSA | RealWorld | RefArch | KataLog |
|-------|------------|------|-----------|---------|---------|
| Modular Monolith | 64 | -- | 1 | 1 | 6 |
| Event-Driven | 63 | 3 | 2 | 5 | 47 |
| Layered | 29 | 1 | 1 | -- | -- |
| DDD | 27 | -- | -- | 3 | ~10 |
| Microservices | 26 | -- | -- | 5 | 39 |
| Pipe-and-Filter | 19 | 5 | 1 | -- | -- |
| CQRS/Event Sourcing | 18 | -- | 1 | 4 | ~5 |
| Hexagonal/Clean | 16 | -- | -- | 3 | ~6 |
| Serverless | 6 | -- | -- | 1 | 8 |
| Multi-Agent | 5 | -- | -- | -- | ~3 |
| Space-Based | 5 | 1 | -- | -- | ~2 |
| Service-Based | 4 | 2 | 1 | 1 | 25 |
| Plugin/Microkernel | -- | 3 | 3 | -- | ~4 |

**Observations**:
- Only **Event-Driven** has evidence from all 5 sources.
- **Plugin/Microkernel** has the strongest production evidence (6 systems) but is invisible to automated discovery -- the starkest detection bias case.
- **Modular Monolith** dominates the Discovered corpus (64 repos, 52%) despite limited curated production evidence (Orchard Core only), suggesting it is widely built but under-documented at the production-narrative level.
- **Service-Based** has thin Discovered presence (4 repos) but 3 production systems, confirming it is under-detected, not under-used.
- Five styles (**Microservices, DDD, Hexagonal, Serverless, Multi-Agent**) have zero production evidence from AOSA or RealWorld.

---

## Cross-Style Patterns

Several patterns emerge when comparing evidence across all 13 styles:

### Discovered Frequency vs. Production Evidence

The Discovered corpus reveals that the two most commonly built architectural patterns -- Modular Monolith (52%) and Event-Driven (52%) -- are also the most likely to co-occur (38 repos, 31% of the entire corpus). This statistical finding, derived from 122 real codebases, provides the strongest evidence that these styles are complementary rather than competing. Production evidence confirms this: Event-Driven has 5 production systems; Modular Monolith has Orchard Core and the highest KataLog win rate (83.3%).

The production-weighted rankings surface styles invisible to automated detection: Plugin/Microkernel (#2 by combined score, 0 Discovered repos) and Pipeline (#3, 19 Discovered repos). These styles dominate in infrastructure software (LLVM, NGINX, GStreamer, SQLAlchemy) where filesystem signals alone do not capture runtime extension points or processing stage boundaries.

### Combination Outperforms Purity

Across all sources, combined styles outperform pure styles. Event-Driven + Service-Based won more KataLog challenges than either alone. Hexagonal is used as internal structure within Microservices and Modular Monolith. CQRS appears within DDD-organized services. Plugin architecture hosts Pipeline stages (GStreamer, LLVM). The evidence consistently shows that real systems combine multiple styles, with one as the primary deployment architecture and others as internal structural patterns.

### The Evolutionary Path

KataLog winners frequently proposed evolutionary architectures: Modular Monolith as initial deployment with microservices as documented future state (MonArch, PegasuZ), Service-Based as Phase 1 with microservices as Phase 3 (Pentagram). The modular-monolith-with-ddd reference implementation demonstrates that DDD, CQRS, and Event-Driven patterns work within a monolith -- enabling future extraction without requiring distributed infrastructure from day one. Discovered data supports this: the 38-repo co-occurrence of Modular Monolith + Event-Driven suggests many codebases start modular and adopt event-driven communication patterns incrementally.

### Evidence Gaps

Five styles (Microservices, DDD, Hexagonal, Serverless, Multi-Agent) have zero production evidence. Discovered data shows all five have active open-source implementations (26, 27, 16, 6, and 5 repos respectively), confirming they are widely built but not yet validated at production scale within this evidence base. DDD (27 Discovered repos) has the widest gap between code presence and production adoption. Multi-Agent (5 repos, newest style) has the thinnest evidence overall and the greatest uncertainty about production viability.

### Style Pairing Patterns

Evidence consistently shows that successful implementations combine styles. Common pairings observed across sources:

| Primary Style | Common Pairing | Evidence Sources | Example |
|---------------|---------------|------------------|---------|
| Event-Driven | + Service-Based | KataLog, RealWorld | Team Seven, Pragmatic, Bitwarden |
| Event-Driven | + Microservices | KataLog, RefArch | eShopOnContainers, Profitero Data Alchemists |
| Event-Driven | + CQRS | RealWorld, RefArch | Squidex, modular-monolith-with-ddd |
| Microservices | + DDD | KataLog, RefArch | MonArch, IPT, eShopOnContainers, wild-workouts |
| Microservices | + Hexagonal | KataLog, RefArch | Miyagi's Little Forests, wild-workouts, buckpal |
| Modular Monolith | + Hexagonal | KataLog, RefArch | MonArch, modular-monolith-with-ddd |
| Plugin | + Pipeline | AOSA | LLVM (plugin passes in compiler pipeline), GStreamer (plugin elements in media pipeline) |
| Service-Based | + Event-Driven | KataLog, AOSA | Team Seven, ZAITects, Graphite |
| Serverless | + Event-Driven | KataLog, RefArch | TheGlobalVariables, serverless-microservices-azure |

The most successful pairing across all sources is Event-Driven + Service-Based (or Microservices), appearing in winners across KataLog, RealWorld, and RefArch. The least common pairings involve Space-Based and Multi-Agent, which tend to be used in isolation.

---

## Appendix: Source Legend

| Source | Full Name | Evidence Type | Entries |
|--------|-----------|---------------|---------|
| Discovered | Discovered open-source repositories | Auto-classified from structural signals | 122 repos |
| AOSA | Architecture of Open Source Applications | Production systems described by creators | 12 projects |
| RealWorld | RealWorldASPNET production apps | Production applications with real users | 5 projects |
| RefArch | Reference implementations | Working code with sample domains | 8 repos |
| KataLog | O'Reilly Architecture Kata submissions | Competition designs (never built) | 78 teams |

See [cross-source-reference.md](cross-source-reference.md) for full scoring methodology, evidence weighting rationale, and per-source quality comparison.

---

*Generated: 2026-03-05*
