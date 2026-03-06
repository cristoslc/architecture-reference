# Evidence by Architecture Style

Per-style evidence drawn from 266 entries across 5 sources: 163 Discovered open-source repositories (primary, deep-validated via SPEC-019 source code inspection), 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 78 KataLog competition submissions. Styles ranked by frequency in 163 real codebases. See [cross-source-reference.md](cross-source-reference.md) for scoring methodology.

**How to read this document**: Each of the 13 styles below includes an Evidence Summary opening with Discovered frequency, a Cross-Source Evidence Table (Discovered first), qualitative reasoning from KataLog teams ("Why Teams Choose This Style"), and evidence-grounded When to Use / Avoid guidance. For styles with large KataLog samples (Event-Driven: 47 teams, Microservices: 39 teams, Service-Based: 25 teams), only top performers are shown with a note on total count. Notable projects are cited by GitHub star count to indicate real-world adoption.

> **Detection methodology (SPEC-019 deep-validated):** Discovered statistics are derived from source code inspection with multi-turn LLM validation across 163 repositories. Unlike the prior heuristic-only approach (122 repos), SPEC-019 deep-validation examines actual source code, module boundaries, runtime extension points, and architectural patterns -- not just filesystem signals. This resolved previous blind spots (e.g., Plugin/Microkernel now detected at 20.2%). Remaining biases: styles expressed purely through runtime behavior or deployment topology may still be underrepresented. 24 repos (14.7%) are classified as Indeterminate -- libraries/frameworks with no classifiable application architecture. KataLog competition evidence continues to fill gaps for styles invisible in code.

---

## Discovered Frequency Rankings (PRIMARY)

Styles ranked by frequency in 163 deep-validated codebases (SPEC-019). This is the primary ranking because it represents the largest, most structurally diverse evidence sample -- how architects actually build software in practice. Percentages represent any-position frequency (repos tagged with a style in any position).

| Rank | Style | Discovered Repos | % of Corpus | Notable Projects (by GitHub stars) | Top Co-occurring Styles |
|------|-------|-----------------|-------------|-------------------------------------|------------------------|
| 1 | **Modular Monolith** | 65 | 39.9% | AutoGPT (182k), n8n (177k), langchain (128k), elasticsearch (76k), nest (74k), redis (73k) | Event-Driven (25 repos), Plugin/Microkernel (19 repos) |
| 2 | **Event-Driven** | 47 | 28.8% | AutoGPT (182k), n8n (177k), dify (131k), elasticsearch (76k), appwrite (55k), mastodon (49k) | Modular Monolith (25 repos), DDD (14 repos) |
| 3 | **Layered** | 35 | 21.5% | nocodb (62k), traefik (62k), maybe (54k), mastodon (49k), discourse (46k), outline (37k) | Modular Monolith (16 repos) |
| 4 | **Plugin/Microkernel** | 33 | 20.2% | n8n (177k), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), strapi (71k) | Modular Monolith (19 repos) |
| 5 | **Domain-Driven Design** | 29 | 17.8% | saleor (22k), CleanArchitecture (19k), server (18k), domain-driven-hexagon (14k), abp (14k) | Hexagonal (15 repos), CQRS (15 repos), Event-Driven (14 repos) |
| 6 | **Pipe-and-Filter** | 26 | 16.0% | dify (131k), langchain (128k), localstack (64k), traefik (62k), llama_index (47k), airflow (44k) | Event-Driven |
| 7 | **Hexagonal Architecture** | 20 | 12.3% | jellyfin (49k), keycloak (33k), CleanArchitecture (19k), domain-driven-hexagon (14k) | DDD (15 repos) |
| 8 | **CQRS** | 17 | 10.4% | CleanArchitecture (19k), domain-driven-hexagon (14k), modular-monolith-with-ddd (13k), eShop (10k) | DDD (15 repos) |
| 9 | **Microservices** | 16 | 9.8% | supabase (98k), dapr (25k), microservices-demo (19k), server (18k), gitpod (13k) | Event-Driven |
| 10 | **Multi-Agent** | 11 | 6.7% | AutoGPT (182k), langchain (128k), autogen (55k), crewAI (45k), semantic-kernel (27k) | Event-Driven |
| 11 | **Service-Based** | 11 | 6.7% | dify (131k), mastodon (49k), temporal (18k), linkerd2 (11k), nhost (9k) | Event-Driven |
| 12 | **Space-Based** | 5 | 3.1% | dragonfly (30k), hazelcast (6k), ignite (5k), geode (2k), infinispan (1k) | Event-Driven |
| 13 | **Serverless** | 3 | 1.8% | aws-serverless-airline-booking (2k), azure-functions-host (2k) | Event-Driven |

24 repos (14.7%) are classified as **Indeterminate** -- libraries and frameworks with no classifiable application architecture.

### Key Statistical Findings

1. **Modular Monolith is the most prevalent style (39.9%).** 65 of 163 repos use Modular Monolith, led by projects like AutoGPT (182k stars), n8n (177k), and langchain (128k). It co-occurs most frequently with Event-Driven (25 repos) and Plugin/Microkernel (19 repos), confirming it serves as a host architecture for other patterns.

2. **Event-Driven is the most common secondary style (28.8%) but rare as primary.** 47 of 163 repos use Event-Driven architecture, but only 4.3% use it as a primary style. This is a cross-cutting concern -- event-driven communication is adopted within modular monoliths, service-based systems, and microservices rather than standing alone. The Event-Driven + Modular Monolith pair (25 repos) is the most common co-occurrence.

3. **Plugin/Microkernel is now detected at 20.2% (previously 0%).** Deep-validation via source code inspection resolved the prior detection blind spot. 33 repos exhibit plugin architectures, led by n8n (177k), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), and strapi (71k). Plugin/Microkernel + Modular Monolith co-occur in 19 repos, the second-most common pair.

4. **Service-Based is now detected at 6.7% (previously 3%).** 11 repos including dify (131k), mastodon (49k), and temporal (18k). Combined with 3 production systems (Selenium, Graphite, Bitwarden), the style is better represented than prior heuristic detection suggested.

5. **DDD and Hexagonal form tight pairs.** DDD + Hexagonal co-occurs in 15 repos; CQRS + DDD co-occurs in 15 repos. These tactical patterns cluster together in practice, confirming they are complementary methodology choices.

6. **Microservices dropped from 21% to 9.8%.** Deep-validation pruned many repos previously classified as microservices that were actually modular monoliths or service-based systems. 16 repos remain, led by supabase (98k), but zero production systems in AOSA or RealWorld were classified as microservices.

7. **Top co-occurring pairs (by repo count):** Event-Driven + Modular Monolith (25), Modular Monolith + Plugin/Microkernel (19), Layered + Modular Monolith (16), DDD + Hexagonal (15), CQRS + DDD (15), DDD + Event-Driven (14).

---

## Production-Weighted Rankings (SECONDARY)

The Combined Weighted Score below uses production-weighted scoring (20 pts per production system). This alternative ranking validates that Discovered frequency broadly aligns with production adoption, while surfacing styles like Plugin/Microkernel and Pipeline that have strong production evidence. With SPEC-019 deep-validation, Plugin/Microkernel is now visible in the Discovered corpus (33 repos, 20.2%) as well.

| Rank | Style | Combined Score | KataLog Score | AOSA Count | RealWorld Count | RefArch Count | Discovered Count | Production % |
|------|-------|---------------|---------------|------------|-----------------|---------------|------------------|-------------|
| 1 | Event-Driven | 187 | 94 | 3 | 2 | 5 | 47 | 53% |
| 2 | Plugin/Microkernel | 157 | 4 | 3 | 3 | 0 | 33 | 77% |
| 3 | Pipeline | 126 | 0 | 5 | 1 | 0 | 26 | 95% |
| 4 | Service-Based | 112 | 43 | 2 | 1 | 1 | 11 | 54% |
| 5 | Modular Monolith | 41 | 18 | 0 | 1 | 1 | 65 | 49% |
| 6 | Microservices | 66 | 67 | 0 | 0 | 5 | 16 | 0% |
| 7 | CQRS/Event Sourcing | 32 | 8 | 0 | 1 | 4 | 17 | 63% |
| 8 | Space-Based | 24 | 4 | 1 | 0 | 0 | 5 | 83% |
| 9 | Layered Architecture | 20 | 0 | 1 | 1 | 0 | 35 | 100% |
| 10 | Domain-Driven Design | 16 | 11 | 0 | 0 | 3 | 29 | 0% |
| 11 | Hexagonal/Clean | 16 | 10 | 0 | 0 | 3 | 20 | 0% |
| 12 | Serverless | 11 | 12 | 0 | 0 | 1 | 3 | 0% |
| 13 | Multi-Agent | 8 | 8 | 0 | 0 | 0 | 11 | 0% |

*Production % = share of Combined Score from AOSA + RealWorldASPNET sources. Production-weighted scoring (20 pts per production system) means a single production deployment outweighs an entire Kata competition season.*

---

## 1. Event-Driven

### Evidence Summary

47 of 163 Discovered repos (**28.8%**) use Event-Driven architecture -- the most common secondary style but rare as primary (4.3%). Notable projects: AutoGPT (182k stars), n8n (177k), dify (131k), elasticsearch (76k), appwrite (55k), mastodon (49k). Co-occurs most frequently with Modular Monolith (25 repos) and DDD (14 repos). Detected through message broker configs (Kafka, RabbitMQ), event bus implementations, and async messaging patterns across Go, Java, C#, and Python. Event-Driven is a cross-cutting concern -- adopted within other primary styles rather than standing alone.

Validated by 5 production systems: NGINX (event-driven reactor, 30%+ of internet traffic), Twisted (reactor pattern), ZeroMQ (broker-less messaging), Bitwarden (event-driven vault sync), and Squidex (event sourcing as primary persistence). 47 KataLog teams chose this style. Judges noted that depth of event-flow design (partitioning keys, consumer groups, dead-letter handling) separated winners from runner-ups.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 47 repos | Statistical signal | Message broker configs (Kafka, RabbitMQ) in 28.8% of catalog; event bus implementations across Go, Java, C#, Python; most common secondary style, rare as primary (4.3%) |
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

65 of 163 Discovered repos (**39.9%**) use Modular Monolith -- the highest of any style. Notable projects: AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k), nest (74k), redis (73k). Co-occurs most frequently with Event-Driven (25 repos) and Plugin/Microkernel (19 repos). Detected through well-structured directory layouts with module boundaries and single deployment artifacts. Dominant in Developer Tools, E-Commerce, and CMS domains.

Validated by 1 production system: Orchard Core (multi-tenant CMS, independent ASP.NET Core modules). 1 reference implementation: modular-monolith-with-ddd (DDD + CQRS + Event-Driven within monolith). 6 KataLog teams chose this style with the highest win rate of any style (83.3%). Judges rewarded cost analysis and pragmatic evolutionary reasoning.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 65 repos | Statistical signal | Well-structured directory layouts with module boundaries; single deployment artifacts; most common pattern in Discovered catalog (39.9% of all repos) |
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

- The Discovered corpus shows modular monolith as the most common pattern across Developer Tools, E-Commerce, and CMS domains. Its 39.9% frequency and co-occurrence with Event-Driven in 25 repos and Plugin/Microkernel in 19 repos confirms it as the default starting architecture for most domains.
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

35 of 163 Discovered repos (**21.5%**) use Layered Architecture. Notable projects: nocodb (62k stars), traefik (62k), maybe (54k), mastodon (49k), discourse (46k), outline (37k). Co-occurs most frequently with Modular Monolith (16 repos). Detected through directory structures with presentation/business/data layers and dependency flow enforcement. Common in E-Commerce and Developer Tools domains.

Validated by 2 production systems: SQLAlchemy (two-layer Core + ORM, Python standard) and nopCommerce (four-layer architecture, 60K+ stores, 17 years of evolution). Zero KataLog teams proposed layered architecture. This absence is expected -- layered architecture is seen as a default rather than an explicit architectural choice in competition contexts.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 35 repos | Statistical signal | Directory structures with presentation/business/data layers; dependency flow enforcement; layer-per-folder project organization |
| AOSA | SQLAlchemy | Production system | Two distinct layers: Core (SQL expression language, schema definition, connection pooling) and ORM (unit of work, identity map, relationship loading); strict layer separation with Core usable independently |
| RealWorld | nopCommerce | Production app | Four-layer architecture: Web (Razor views, API controllers), Services (business logic), Data (Entity Framework, repositories), Core (domain entities, DTOs); 60K+ live stores; 17 years of evolution |

### Why Teams Choose This Style

No KataLog teams explicitly proposed layered architecture. The absence from competition contexts is itself a finding: layered architecture is the default structural approach that teams adopt implicitly rather than declare explicitly. However, nopCommerce's 17-year longevity and SQLAlchemy's ubiquity demonstrate that the pattern's simplicity is a feature, not a limitation.

**Longevity as evidence**: nopCommerce's 17-year evolution through four layers (Web, Services, Data, Core) is among the strongest evidence for any architecture style in the dataset. The architecture has survived the transition from ASP.NET Web Forms to MVC to Razor Pages to modern ASP.NET Core while maintaining the same four-layer structure. This suggests layered architecture's primary value is durability across technology generations, not performance or scalability.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, layered repos co-occur heavily with Modular Monolith (16 of 35 repos), suggesting layered internal structure within modular boundaries is a common configuration.
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

29 of 163 Discovered repos (**17.8%**) use DDD. Notable projects: saleor (22k stars), CleanArchitecture (19k), server (18k), domain-driven-hexagon (14k), abp (14k). Co-occurs most frequently with Hexagonal (15 repos), CQRS (15 repos), and Event-Driven (14 repos). Detected through aggregate root patterns, bounded context directory structures, and domain event implementations. Common in E-Commerce and Developer Tools domains.

3 reference implementations demonstrate DDD in practice: eShopOnContainers (DDD within microservices), modular-monolith-with-ddd (DDD within monolith), and wild-workouts-go (DDD in Go). ~10 KataLog teams applied DDD; judges noted that DDD context mapping provided the strongest decomposition rationale among winners.

> **Classification note:** No production systems use DDD as a primary classifiable style. This reflects a classification artifact rather than production absence -- real production systems using DDD are classified by their deployment style (microservices, modular monolith).

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 29 repos | Statistical signal | Aggregate root patterns, bounded context directory structures, domain event implementations; co-occurs tightly with Hexagonal (15 repos) and CQRS (15 repos) |
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

**Methodology vs. architecture**: DDD's zero production evidence likely reflects a classification artifact. 29 Discovered repos confirm that DDD tactical patterns (aggregates, value objects, domain events) are widely implemented in code. The primary style classification simply captures the deployment architecture instead.

The most successful KataLog microservices teams (MonArch, IPT, ArchColider) used DDD context mapping to justify service boundaries.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered corpus, DDD repos (17.8%) co-occur tightly with Hexagonal (15 repos) and CQRS (15 repos), confirming these tactical patterns are adopted together in practice. DDD + Event-Driven (14 repos) shows domain events remain a common DDD pattern.
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

16 of 163 Discovered repos (**9.8%**) use Microservices -- a significant reduction from the prior heuristic count (26 of 122, 21%) due to deep-validation reclassification. Notable projects: supabase (98k stars), dapr (25k), microservices-demo (19k), server (18k), gitpod (13k). Co-occurs most frequently with Event-Driven. Detected through Docker Compose multi-service layouts, API gateway configs, and per-service databases. Common in Developer Tools and Infrastructure domains.

5 reference implementations: eShopOnContainers, eShop, serverless-microservices-azure, AKS Baseline, wild-workouts-go. Zero production systems across AOSA and RealWorld. 39 KataLog teams chose this style (second-most popular). Judges noted that winners paired microservices with DDD and event-driven, while runner-ups adopted it as default without justification.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 16 repos | Statistical signal | Docker Compose multi-service layouts, API gateway configs, per-service databases; deep-validated down from 26 by reclassifying repos that were actually modular monoliths or service-based |
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

**Over-engineering signal from KataLog**: In the Sysops Squad challenge, the sole microservices team (Arch Mahal) placed as runner-up while all 6 service-based teams placed higher. In ClearView, the sole pure microservices team (Jazz Executor) also placed as runner-up.

The strongest KataLog performers (MonArch, PegasuZ, Rapid Response) all proposed evolutionary paths starting simpler and decomposing into microservices -- not microservices from day one.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, microservices repos (9.8%) cluster in Developer Tools and Infrastructure domains and co-occur with Event-Driven, confirming that microservices without async communication are rare in practice. The drop from 21% (heuristic) to 9.8% (deep-validated) suggests many repos previously classified as microservices were actually modular monoliths or service-based systems.
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

26 of 163 Discovered repos (**16.0%**) use Pipe-and-Filter. Notable projects: dify (131k stars), langchain (128k), localstack (64k), traefik (62k), llama_index (47k), airflow (44k). Co-occurs most frequently with Event-Driven. Detected through stage-based directory layouts, pipeline configuration files, and data transformation chains. Common in Data Processing, AI/ML, and Infrastructure domains.

Validated by 6 production systems -- the second-highest production count of any style:
- NGINX (HTTP request processing pipeline, 30%+ of internet)
- LLVM (3-phase compiler pipeline)
- GStreamer (media pipeline)
- Graphite (metrics collection-storage-rendering)
- ZeroMQ (I/O thread pipeline)
- Jellyfin (transcoding pipeline)

Zero KataLog teams proposed this style. Pipeline solves data-transformation problems that rarely appear in Kata problem statements.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 26 repos | Statistical signal | Data processing pipelines, ETL systems, stream processors, AI/ML chains; structural signals include stage-based directory layouts and pipeline configuration files |
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

- In the Discovered corpus, pipeline repos cluster in Data Processing, AI/ML, and Infrastructure domains. The 26 repos confirm broad adoption in data engineering and AI pipeline contexts, including high-profile AI projects like dify (131k), langchain (128k), and llama_index (47k).
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

17 of 163 Discovered repos (**10.4%**) use CQRS. Notable projects: CleanArchitecture (19k stars), domain-driven-hexagon (14k), modular-monolith-with-ddd (13k), eShop (10k). Co-occurs most frequently with DDD (15 repos) and Event-Driven. Detected through command/query separation patterns, event store configurations, and projection/read-model builders. Common in Developer Tools and E-Commerce domains.

Validated by 1 production system: Squidex (full event sourcing, MongoDB event store, headless CMS). 4 reference implementations: eShopOnContainers, modular-monolith-with-ddd, wild-workouts-go, clean-architecture-dotnet. ~5 KataLog teams applied CQRS, consistently pairing it with event-driven communication.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 17 repos | Statistical signal | Command/query separation patterns, event store configurations, projection/read-model builders; co-occurs tightly with DDD (15 repos) |
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

- In the Discovered corpus, CQRS repos (10.4%) co-occur tightly with DDD (15 repos) and Event-Driven, confirming the patterns are complementary in practice. All 4 reference implementations apply CQRS within bounded contexts, not system-wide.
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

20 of 163 Discovered repos (**12.3%**) use Hexagonal Architecture. Notable projects: jellyfin (49k stars), keycloak (33k), CleanArchitecture (19k), domain-driven-hexagon (14k). Co-occurs most frequently with DDD (15 repos). Detected through port/adapter directory structures, dependency inversion patterns, and clean architecture layer organization across Java, C#, Go, TypeScript, and Kotlin.

3 reference implementations: buckpal (Java, hexagonal purity), clean-architecture-dotnet (C# + CQRS), wild-workouts-go (Go idiom). ~6 KataLog teams applied hexagonal, consistently as internal structure within modular monolith or microservices.

> **Classification note:** No production systems use hexagonal as a primary classifiable style. Like DDD, it serves as an internal structure within other styles.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 20 repos | Statistical signal | Port/adapter directory structures, dependency inversion patterns, clean architecture layer organization; languages include Java, C#, Go, TypeScript, Kotlin; co-occurs tightly with DDD (15 repos) |
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

- In the Discovered corpus, hexagonal repos (12.3%) co-occur tightly with DDD (15 repos), confirming ports-and-adapters as the preferred structural pattern for DDD implementations. Notable projects include jellyfin (49k) and keycloak (33k).
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

3 of 163 Discovered repos (**1.8%**) use Serverless. Notable projects: aws-serverless-airline-booking (2k stars), azure-functions-host (2k). Co-occurs most frequently with Event-Driven. Detected through function-as-a-service configurations, event trigger definitions, and serverless framework configs.

1 reference implementation: serverless-microservices-azure. Zero production systems across AOSA and RealWorld. 8 KataLog teams chose this style (25% win rate). Judges noted serverless performed best as a component within broader architectures, with cost optimization as the universal rationale.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 3 repos | Statistical signal | Function-as-a-service configurations, event trigger definitions, serverless framework configs |
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

- Serverless repos in the Discovered corpus (1.8%) are the rarest classified style, co-occurring with Event-Driven -- confirming serverless works best as a component in event-driven workflows.
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

11 of 163 Discovered repos (**6.7%**) use Multi-Agent. Notable projects: AutoGPT (182k stars), langchain (128k), autogen (55k), crewAI (45k), semantic-kernel (27k). Co-occurs most frequently with Event-Driven. Detected through agent orchestration patterns, multi-model configurations, and LLM chain definitions. Common in AI/ML domains. The more than doubling from the prior count (5 repos) reflects both corpus growth and improved detection of agent orchestration patterns.

Zero production systems and zero reference implementations. ~3 KataLog teams (AI-focused challenges, Winter 2024-2025). Judges noted that constrained agent autonomy through supervisor hierarchies and formal evaluation frameworks separated winners from the field.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 11 repos | Statistical signal | Agent orchestration patterns, multi-model configurations, LLM chain definitions; includes AutoGPT (182k), langchain (128k), autogen (55k), crewAI (45k), semantic-kernel (27k) |
| KataLog | ConnectedAI | 1st, ShopWise AI | Multi-agent supervisor hierarchy with LangGraph; dual-LLM cost optimization (Claude for reasoning, Gemini for routing); quantitative evaluation with Ragas + LangFuse |
| KataLog | Breakwater | 2nd, ShopWise AI | Multi-agent workflow-orchestrated with n8n; OpenAI + PostgreSQL; workflow engine as agent coordinator |
| KataLog | Usfive | Runner-up, Certifiable Inc. | Multi-agent scoring with multiple LLMs; confidence-based escalation between agents |

### Why Teams Choose This Style

Multi-agent is the newest and least-evidenced style, appearing exclusively in the AI-focused Kata challenges. Within its limited evidence, a consistent pattern emerges: successful multi-agent teams constrained agent autonomy through supervisor hierarchies, workflow orchestration, and confidence-based escalation.

**Architectural governance as differentiator**: ConnectedAI built a supervisor hierarchy where a routing agent delegated to specialized agents (product search, recommendation, FAQ), each with explicit capability boundaries and fallback paths. Breakwater used n8n workflow orchestration to coordinate agents with deterministic handoff points. Both approaches constrain agent autonomy -- the winning pattern is not autonomous agents but orchestrated agents with defined contracts, mirroring the plugin/microkernel pattern's core-extension relationship in an AI context.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered corpus, multi-agent repos (6.7%) cluster in AI/ML domains, led by some of the most-starred projects on GitHub (AutoGPT 182k, langchain 128k, autogen 55k). The pattern is growing rapidly.
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

5 of 163 Discovered repos (**3.1%**) use Space-Based architecture. Notable projects: dragonfly (30k stars), hazelcast (6k), ignite (5k), geode (2k), infinispan (1k). Co-occurs most frequently with Event-Driven. Detected through in-memory data grid patterns and distributed caching configurations. Common in Data Grid domains.

Validated by 1 production system: Riak (peer-to-peer distributed key-value store, tunable consistency, no single point of failure). ~2 KataLog teams chose this style for high-concurrency, peak-load scenarios.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 5 repos | Statistical signal | In-memory data grid patterns, distributed caching configurations; includes dragonfly (30k), hazelcast (6k), ignite (5k) |
| AOSA | Riak | Production system | Peer-to-peer distributed key-value store; consistent hashing for data partitioning; tunable consistency (read/write quorum); no single point of failure; rack-aware replica placement |
| KataLog | Iconites | 2nd, Road Warrior | Space-based + event-driven + microservices; Cosmos DB + Redis for in-memory data grid; designed for Road Warrior's 15M user peak-load scenario |
| KataLog | LowCode | 3rd (tied), MonitorMe | Distributed system with event bus and distributed appliance nodes; space-based topology for medical device data |

### Why Teams Choose This Style

KataLog evidence is sparse (2 teams) but targeted: both teams chose space-based for high-concurrency, peak-load scenarios (Road Warrior's 15M users, MonitorMe's distributed sensor nodes).

**Riak's architectural lessons**: Riak demonstrates the core space-based principles at infrastructure scale: no master node (peer-to-peer), data distributed via consistent hashing across a ring, tunable N/R/W values allowing per-request consistency-availability trade-offs, and hinted handoff for partition tolerance. These same principles (replicated data, no central coordinator, tunable consistency) define the application-level space-based architecture pattern, making Riak both an implementation of and infrastructure for space-based systems.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered corpus, space-based repos (3.1%) cluster in Data Grid domains, consistent with the pattern's focus on distributed in-memory data management. Notable examples include dragonfly (30k stars, Redis-compatible in-memory store) and hazelcast (6k).
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

11 of 163 Discovered repos (**6.7%**) use Service-Based architecture -- more than doubled from the prior heuristic count (4 of 122, 3%). Notable projects: dify (131k stars), mastodon (49k), temporal (18k), linkerd2 (11k), nhost (9k). Co-occurs most frequently with Event-Driven. Detected through coarse-grained service boundaries with shared database patterns.

Validated by 3 production systems: Graphite (three coarse-grained services), Selenium (hub-node topology), and Bitwarden (SOC2-certified service-based decomposition). 1 reference implementation: AKS Baseline. 25 KataLog teams chose this style, dominant in budget-constrained and monolith-migration contexts. In the Sysops Squad challenge, 6 of 7 teams chose it. In Certifiable Inc., 6 of 7 teams chose it.

> **Detection note:** Deep-validation improved Service-Based detection from 3% to 6.7%, but the style may still be underrepresented since it can resemble a monolith in code structure while having service-level deployment boundaries.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 11 repos | Statistical signal | Coarse-grained service boundaries with shared database patterns; includes dify (131k), mastodon (49k), temporal (18k) |
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

- Service-based repos in the Discovered corpus (6.7%) are now better detected through deep-validation, led by dify (131k), mastodon (49k), and temporal (18k). Combined with 3 production systems (Selenium, Graphite, Bitwarden), the evidence confirms service-based architecture is widely used in practice.
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

33 of 163 Discovered repos (**20.2%**) use Plugin/Microkernel -- a dramatic increase from 0% in the prior heuristic analysis. Notable projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), strapi (71k). Co-occurs most frequently with Modular Monolith (19 repos). Deep-validation via source code inspection resolved the prior detection blind spot by identifying runtime extension points, plugin registries, and host-plugin contracts that are invisible to filesystem-only analysis.

Additionally validated by 6 production systems (the most of any style except Event-Driven):
- LLVM (plugin pass architecture)
- GStreamer (pipeline elements as loadable plugins)
- SQLAlchemy (dialect plugins for database backends)
- Jellyfin (plugin system for metadata/notification/auth)
- nopCommerce (plugin marketplace, 60K+ stores)
- Orchard Core (multi-tenant module system)

Combined Weighted Score: 157 (rank #2). ~4 KataLog teams proposed it.

> **Detection history:** Plugin architectures were a complete blind spot in the prior heuristic analysis (0 of 122 repos). SPEC-019 deep-validation via source code inspection resolved this, revealing Plugin/Microkernel as the fourth most common style (20.2%). This is the largest single correction in the SPEC-019 validation effort.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 33 repos | Statistical signal | Plugin registries, extension points, host-plugin contracts; includes n8n (177k), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), strapi (71k); resolved from 0 by SPEC-019 deep-validation |
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

**When to use** -- grounded in Discovered domain correlations and production validation:

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

Shows which sources provide evidence for each style. Filled cells indicate at least one entry; numbers show entry count. Ordered by Discovered frequency (SPEC-019 deep-validated, 163 repos).

| Style | Discovered | AOSA | RealWorld | RefArch | KataLog |
|-------|------------|------|-----------|---------|---------|
| Modular Monolith | 65 | -- | 1 | 1 | 6 |
| Event-Driven | 47 | 3 | 2 | 5 | 47 |
| Layered | 35 | 1 | 1 | -- | -- |
| Plugin/Microkernel | 33 | 3 | 3 | -- | ~4 |
| DDD | 29 | -- | -- | 3 | ~10 |
| Pipe-and-Filter | 26 | 5 | 1 | -- | -- |
| Hexagonal/Clean | 20 | -- | -- | 3 | ~6 |
| CQRS | 17 | -- | 1 | 4 | ~5 |
| Microservices | 16 | -- | -- | 5 | 39 |
| Multi-Agent | 11 | -- | -- | -- | ~3 |
| Service-Based | 11 | 2 | 1 | 1 | 25 |
| Space-Based | 5 | 1 | -- | -- | ~2 |
| Serverless | 3 | -- | -- | 1 | 8 |

**Observations**:
- Only **Event-Driven** has evidence from all 5 sources.
- **Plugin/Microkernel** now has both strong Discovered presence (33 repos, 20.2%) and the strongest production evidence (6 systems). SPEC-019 deep-validation resolved the prior detection blind spot (previously 0 repos).
- **Modular Monolith** dominates the Discovered corpus (65 repos, 39.9%) despite limited curated production evidence (Orchard Core only), suggesting it is widely built but under-documented at the production-narrative level.
- **Service-Based** improved from 4 to 11 Discovered repos through deep-validation, and has 3 production systems, confirming it is well-represented across sources.
- **Microservices** dropped from 26 to 16 repos through deep-validation reclassification, with zero production evidence from AOSA or RealWorld.
- Four styles (**Microservices, DDD, Hexagonal, Multi-Agent**) have zero production evidence from AOSA or RealWorld.

---

## Cross-Style Patterns

Several patterns emerge when comparing evidence across all 13 styles:

### Discovered Frequency vs. Production Evidence

Modular Monolith (39.9%) is the most commonly built pattern. Event-Driven (28.8%) is the most common secondary style but rare as primary (4.3%) -- it is a cross-cutting concern adopted within other styles. They co-occur in 25 of 163 repos, the most common pair. Plugin/Microkernel (20.2%) emerged as the fourth most common style after SPEC-019 deep-validation resolved its prior detection blind spot (0%).

Production evidence confirms these findings. Event-Driven has 5 production systems. Plugin/Microkernel has 6 production systems. Modular Monolith has Orchard Core and the highest KataLog win rate (83.3%).

The production-weighted rankings now align more closely with Discovered frequency. Plugin/Microkernel ranks #2 by combined score with both strong Discovered presence (33 repos) and dominant production evidence. Pipeline ranks #3 with 26 Discovered repos. These styles dominate in infrastructure software (LLVM, NGINX, GStreamer, SQLAlchemy, n8n, elasticsearch, grafana).

### Combination Outperforms Purity

Across all sources, combined styles outperform pure styles. Event-Driven + Service-Based won more KataLog challenges than either alone. Hexagonal is used as internal structure within Microservices and Modular Monolith. CQRS appears within DDD-organized services. Plugin architecture hosts Pipeline stages (GStreamer, LLVM). The top co-occurring pairs in the Discovered corpus confirm this: Event-Driven + Modular Monolith (25), Modular Monolith + Plugin/Microkernel (19), Layered + Modular Monolith (16), DDD + Hexagonal (15), CQRS + DDD (15). The evidence consistently shows that real systems combine multiple styles, with one as the primary deployment architecture and others as internal structural patterns.

### The Evolutionary Path

KataLog winners frequently proposed evolutionary architectures: Modular Monolith as initial deployment with microservices as documented future state (MonArch, PegasuZ), Service-Based as Phase 1 with microservices as Phase 3 (Pentagram). The modular-monolith-with-ddd reference implementation demonstrates that DDD, CQRS, and Event-Driven patterns work within a monolith -- enabling future extraction without requiring distributed infrastructure from day one. Discovered data supports this: the 25-repo co-occurrence of Modular Monolith + Event-Driven and 19-repo co-occurrence of Modular Monolith + Plugin/Microkernel suggest many codebases start modular and adopt event-driven communication or plugin extension patterns incrementally.

### Evidence Gaps

Four styles have zero production evidence: Microservices (16 repos), DDD (29 repos), Hexagonal (20 repos), and Multi-Agent (11 repos). All four have active open-source implementations, confirming they are widely built but not yet validated at production scale within this evidence base. Serverless (3 repos, zero AOSA/RealWorld) has the thinnest Discovered presence.

DDD has the widest gap between code presence and production adoption -- 29 Discovered repos but 0 production systems. Multi-Agent has rapidly growing code presence (11 repos, up from 5) led by some of the highest-starred projects on GitHub, but the greatest uncertainty about production viability.

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
| Discovered | Discovered open-source repositories | Deep-validated via SPEC-019 source code inspection | 163 repos |
| AOSA | Architecture of Open Source Applications | Production systems described by creators | 12 projects |
| RealWorld | RealWorldASPNET production apps | Production applications with real users | 5 projects |
| RefArch | Reference implementations | Working code with sample domains | 8 repos |
| KataLog | O'Reilly Architecture Kata submissions | Competition designs (never built) | 78 teams |

See [cross-source-reference.md](cross-source-reference.md) for full scoring methodology, evidence weighting rationale, and per-source quality comparison.

---

*Generated: 2026-03-06 (SPEC-019 deep-validated)*
