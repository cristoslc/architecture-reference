# Evidence by Architecture Style

> **Evidence hierarchy (Discovered-first, per EPIC-007).** Discovered production repos (142 entries, deep-validated via SPEC-022 deep-analysis with ADR-002 recomputation) provide the **primary statistical layer** -- all rankings and tables are led by Discovered frequency. AOSA and RealWorld production systems (17 systems) provide **production depth** -- deep case studies with the highest per-system authority. KataLog competition submissions (78 teams) provide **qualitative annotation** -- never-built designs valued for judge commentary and team ADR reasoning. Reference implementations (42 entries) serve as **annotation examples** (teaching code, excluded from frequency counts).

Per-style evidence drawn from 279 entries across 5 sources: 142 Discovered production open-source repositories (primary), 42 Discovered reference implementations (annotation examples only, not counted in frequencies), 12 AOSA production systems, 5 RealWorldASPNET production apps, and 78 KataLog competition submissions. See [cross-source-reference.md](cross-source-reference.md) for scoring methodology.

**How to read this document**: Each of the 13 styles below includes an Evidence Summary opening with Discovered frequency, a Cross-Source Evidence Table (Discovered first), qualitative reasoning from KataLog teams ("Why Teams Choose This Style"), and evidence-grounded When to Use / Avoid guidance. For styles with large KataLog samples (Event-Driven: 47 teams, Microservices: 39 teams, Service-Based: 25 teams), only top performers are shown with a note on total count. Notable projects are cited by GitHub star count to indicate real-world adoption. Reference implementations (42 entries) serve as annotation examples throughout but are not counted in frequency statistics.

> **Detection methodology (SPEC-022 deep-analysis, ADR-002 recomputed):** Discovered statistics are derived from source code inspection with multi-turn LLM validation. The dataset of 184 total repos is split into **142 production entries** (87 platforms, 55 applications, ratio 1.58:1) and **42 reference implementations** (annotation examples only, excluded from frequency counts per ADR-002). ADR-001 mandates equal weighting across all production entries. Unlike the prior SPEC-019 corpus (163 repos with 24 Indeterminate at 14.7%), SPEC-022 deep-analysis eliminated all Indeterminate classifications and excluded tutorial/reference repos from frequency counts, correcting tutorial bias that previously inflated DDD, CQRS, and Hexagonal Architecture frequencies. Remaining biases: styles expressed purely through runtime behavior or deployment topology may still be underrepresented.

> **Detection bias:** Discovered statistics are derived from deep-analysis source code inspection. Styles and QAs that leave strong code signals are more reliably detected. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this specific gap -- teams documented these invisible decisions in ADRs and presentations.

---

## Discovered Frequency Rankings (PRIMARY)

Styles ranked by frequency in 142 production-only entries (SPEC-022 deep-analysis, ADR-002 recomputed). This is the primary ranking because it represents production software -- how architects actually build and ship software in practice. Reference implementations (42 entries) are excluded from frequency counts but serve as annotation examples. Percentages represent any-position frequency (repos tagged with a style in any position). Zero entries remain Indeterminate.

| Rank | Style | Production Repos | % of 142 | Top Co-occurring Styles | Domains Where Most Common |
|------|-------|-----------------|----------|------------------------|---------------------------|
| 1 | **Microkernel** | 83 | 58.5% | Modular Monolith, Layered | Developer Tools, Infrastructure, CMS |
| 2 | **Layered** | 78 | 54.9% | Modular Monolith, Microkernel | E-Commerce, CMS, Social/Community |
| 3 | **Modular Monolith** | 57 | 40.1% | Microkernel, Layered, Event-Driven | Developer Tools, E-Commerce, CMS |
| 4 | **Event-Driven** | 17 | 12.0% | Modular Monolith | Messaging, Infrastructure, Developer Tools |
| 5 | **Pipeline** | 13 | 9.2% | Event-Driven | Data Processing, AI/ML, Infrastructure |
| 6 | **Microservices** | 12 | 8.5% | Event-Driven | Developer Tools, Infrastructure |
| 7 | **Service-Based** | 7 | 4.9% | Event-Driven | Social/Community, Infrastructure |
| 8 | **Hexagonal Architecture** | 5 | 3.5% | DDD | Media, Identity/Auth |
| 9 | **Domain-Driven Design** | 3 | 2.1% | Hexagonal | E-Commerce |
| 10 | **Multi-Agent** | 1 | 0.7% | Event-Driven | AI/ML |
| 11 | **Space-Based** | 1 | 0.7% | Event-Driven | Infrastructure |
| 12 | **CQRS** | 1 | 0.7% | DDD | -- |

Notable projects by GitHub stars: Microkernel -- n8n (177k), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), strapi (71k). Layered -- nocodb (62k), traefik (62k), maybe (54k), mastodon (49k), discourse (46k). Modular Monolith -- AutoGPT (182k), n8n (177k), langchain (128k), elasticsearch (76k). Event-Driven -- AutoGPT (182k), n8n (177k), dify (131k). Pipeline -- dify (131k), langchain (128k), localstack (64k). Microservices -- supabase (98k), dapr (25k). Service-Based -- dify (131k), mastodon (49k), temporal (18k).

Zero entries remain Indeterminate (ADR-002 deep-analysis eliminated all prior Indeterminate classifications).

### Platform vs Application Breakdown

The 142 production entries split into 87 platforms and 55 applications (ratio 1.58:1). Platforms include frameworks, developer tools, and infrastructure; applications include end-user products and services.

| Style | Platforms (87) | % | Applications (55) | % |
|-------|----------|---|-------------|---|
| Microkernel | 53 | 61% | 30 | 55% |
| Layered | 41 | 47% | 37 | 67% |
| Modular Monolith | 36 | 41% | 21 | 38% |
| Event-Driven | 7 | 8% | 10 | 18% |
| Pipeline | 11 | 13% | 2 | 4% |
| Microservices | 11 | 13% | 1 | 2% |
| Service-Based | 4 | 5% | 3 | 5% |
| Hexagonal Architecture | 3 | 3% | 2 | 4% |
| Domain-Driven Design | 2 | 2% | 1 | 2% |
| Multi-Agent | 0 | 0% | 1 | 2% |
| Space-Based | 1 | 1% | 0 | 0% |
| CQRS | 0 | 0% | 1 | 2% |

**Key observations**: Microkernel dominates both platforms (61%) and applications (55%). Layered is significantly more common in applications (67%) than platforms (47%). Pipeline and Microservices are predominantly platform patterns (13% each) with minimal application representation (4% and 2% respectively). Event-Driven skews toward applications (18%) over platforms (8%).

### Ecosystem Frequency Rankings (SPEC-026)

11 ecosystem entries curated in SPEC-026 capture emergent architecture patterns visible only at the multi-repo composition level. These frequencies are reported separately from single-repo rankings per SPIKE-001 (scope axis drives table structure).

| Style | Ecosystems (11) | % | Example Ecosystems |
|-------|----------------|---|-------------------|
| Service-Based | 5 | 45% | *arr Media Stack, Grafana LGTM, HashiCorp, Fediverse, Temporal |
| Microservices | 3 | 27% | Istio/Envoy, Sentry, Supabase |
| Pipeline | 2 | 18% | ELK Stack, Apache Data Ecosystem |
| Event-Driven | 1 | 9% | Apache Data Ecosystem (secondary) |
| Space-Based | 1 | 9% | Apache Data Grid |

**Key observation**: Service-Based dominates ecosystem evidence (45%) despite ranking 7th in single-repo frequency (4.9%). This confirms SPIKE-001's finding that Service-Based is underrepresented at the single-repo level — many real-world Service-Based systems are ecosystems of independent repos. Ecosystem evidence provides the strongest justification for Service-Based as a distinct and practically important style.

### Key Statistical Findings

1. **Microkernel is the most prevalent style (58.5%).** 83 of 142 production repos use Microkernel, led by n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). This is a dramatic rise from the old corpus (0% under heuristic detection, 20.2% under SPEC-019 deep-validation). SPEC-022 deep-analysis properly identifies plugin architectures and runtime extension points that old heuristics missed.

2. **Layered is the second most prevalent style (54.9%).** 78 of 142 production repos use Layered architecture. This rose from 19.0% in the old corpus as deep-analysis properly identifies layered patterns (presentation/business/data layer separation) that were previously under-detected. Layered skews toward applications (67%) versus platforms (47%).

3. **Modular Monolith remains broadly prevalent (40.1%).** 57 of 142 production repos, essentially stable from the prior 38.7%. AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k) lead. It co-occurs frequently with Microkernel and Layered, confirming it serves as a host architecture for other patterns.

4. **Event-Driven dropped sharply (12.0%, down from 33.1%).** 17 of 142 production repos. The old corpus over-classified repos with message broker presence as Event-Driven. Deep-analysis now requires event-driven communication as a genuine architectural pattern, not just infrastructure presence. Event-Driven skews toward applications (18%) over platforms (8%).

5. **Tutorial bias correction: DDD (2.1%), CQRS (0.7%), Hexagonal (3.5%).** These styles were previously inflated by reference/tutorial implementations now excluded from frequency counts. DDD dropped from 8.5% to 2.1%, CQRS from 7.0% to 0.7%, and Hexagonal held at 3.5%. The old counts included tutorial repos that demonstrated these patterns but were not production software.

6. **Pipeline is now properly named (9.2%).** The old "Pipe-and-Filter" (23.2%) has been reclassified into the canonical style name "Pipeline" at 9.2% of production repos. The reduction reflects stricter production-only counting.

7. **Microservices stable at 8.5%.** 12 of 142 production repos, down slightly from 9.8%. Predominantly a platform pattern (13% of platforms vs 2% of applications). Zero production systems in AOSA or RealWorld were classified as microservices.

---

## Production-Weighted Rankings (SECONDARY)

The Combined Weighted Score below is a **secondary validation layer** -- it uses production-weighted scoring (20 pts per production system) to confirm that Discovered frequency aligns with production adoption. The primary ranking is always the Discovered Frequency Rankings table above. Production weighting validates that the Discovered signal is consistent with deep production case studies. With SPEC-022 deep-analysis, Microkernel is now the most prevalent Discovered style (83 repos, 58.5%) and also ranks #2 by combined score. Reference implementations are shown as annotation context but not counted in the Discovered column.

| Rank | Style | Combined Score | KataLog Score | AOSA Count | RealWorld Count | Discovered Count (142 prod) | Production % |
|------|-------|---------------|---------------|------------|-----------------|----------------------------|-------------|
| 1 | Event-Driven | 187 | 94 | 3 | 2 | 17 | 53% |
| 2 | Microkernel | 157 | 4 | 3 | 3 | 83 | 77% |
| 3 | Pipeline | 126 | 0 | 5 | 1 | 13 | 95% |
| 4 | Service-Based | 112 | 43 | 2 | 1 | 7 | 54% |
| 5 | Modular Monolith | 41 | 18 | 0 | 1 | 57 | 49% |
| 6 | Microservices | 66 | 67 | 0 | 0 | 12 | 0% |
| 7 | CQRS | 32 | 8 | 0 | 1 | 1 | 63% |
| 8 | Space-Based | 24 | 4 | 1 | 0 | 1 | 83% |
| 9 | Layered Architecture | 20 | 0 | 1 | 1 | 78 | 100% |
| 10 | Domain-Driven Design | 16 | 11 | 0 | 0 | 3 | 0% |
| 11 | Hexagonal/Clean | 16 | 10 | 0 | 0 | 5 | 0% |
| 12 | Multi-Agent | 8 | 8 | 0 | 0 | 1 | 0% |

*Production % = share of Combined Score from AOSA + RealWorldASPNET sources. Production-weighted scoring (20 pts per production system) means a single production deployment outweighs an entire Kata competition season. Discovered Count uses 142 production-only entries (ADR-002); reference implementations excluded from counts. Serverless removed from rankings (zero production entries after tutorial exclusion).*

---

## 1. Event-Driven

### Evidence Summary

17 of 142 production repos (**12.0%**) use Event-Driven architecture -- down from 28.8% in the prior corpus as deep-analysis corrected over-classification from message broker presence. Notable projects: AutoGPT (182k stars), n8n (177k), dify (131k), elasticsearch (76k). Event-Driven skews toward applications (10/55, 18%) over platforms (7/87, 8%). Detected through genuine event-driven architectural patterns, not merely message broker infrastructure presence. Event-Driven is a cross-cutting concern -- adopted within other primary styles rather than standing alone.

Validated by 5 AOSA/RealWorld production systems: NGINX (event-driven reactor, 30%+ of internet traffic), Twisted (reactor pattern), ZeroMQ (broker-less messaging), Bitwarden (event-driven vault sync), and Squidex (event sourcing as primary persistence). 47 KataLog teams chose this style (qualitative annotation); judges noted that depth of event-flow design (partitioning keys, consumer groups, dead-letter handling) separated winners from runner-ups.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 17 production repos | Statistical signal | Message broker configs (Kafka, RabbitMQ) in 12.0% of production catalog; event bus implementations across Go, Java, C#, Python; skews toward applications (18%) over platforms (8%) |
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

### Why Teams Choose This Style (Qualitative Annotation)

These qualitative insights from KataLog competition teams explain the reasoning behind the statistical pattern observed in the Discovered corpus. Competition designs are never-built; their value lies in documented ADR reasoning and judge commentary.

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

### Ecosystem Evidence (SPEC-026)

1 of 11 curated ecosystems exhibits Event-Driven as a secondary architecture style alongside Pipeline.

| Ecosystem | Members | Composition Pattern | Key Integration Evidence |
|-----------|---------|--------------------|-----------------------|
| **Apache Data Ecosystem** | Kafka, Flink, Spark, Airflow, NiFi | Stage pipeline with event backbone | Kafka serves as the event backbone connecting pipeline stages; producers and consumers use Kafka's binary protocol for real-time streaming; Flink and Spark consume Kafka topics for stream/batch processing |

> **Why this matters**: Event-Driven at the ecosystem level manifests as the *event backbone* that connects independently developed pipeline stages. Kafka's role in the Apache data ecosystem is the canonical example -- it provides the event-driven communication fabric that enables loose coupling between data processing tools that would otherwise require point-to-point integration.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations, production validation, and ecosystem evidence:

- Systems with inherently asynchronous data flows -- sensor streams, email polling, notification broadcasting, analytics pipelines. In the Discovered corpus, event-driven repos cluster in Messaging, Infrastructure, and Developer Tools domains. NGINX confirms the pattern at extreme scale (C10K+); BluzBrothers proved sub-second medical monitoring.
- Multi-repo data ecosystems needing an event backbone to decouple pipeline stages (Apache data ecosystem: Kafka as the event fabric connecting Flink, Spark, NiFi, Airflow)
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

57 of 142 production repos (**40.1%**) use Modular Monolith -- the third most prevalent style (after Microkernel and Layered). Notable projects: AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k), nest (74k), redis (73k). Co-occurs frequently with Microkernel and Layered. Detected through well-structured directory layouts with module boundaries and single deployment artifacts. Dominant in Developer Tools, E-Commerce, and CMS domains. Platforms: 36/87 (41%); applications: 21/55 (38%).

Validated by 1 AOSA/RealWorld production system: Orchard Core (multi-tenant CMS, independent ASP.NET Core modules). 1 reference implementation (annotation): modular-monolith-with-ddd (DDD + CQRS + Event-Driven within monolith). 6 KataLog teams chose this style (qualitative annotation) with the highest win rate of any style (83.3%); judges rewarded cost analysis and pragmatic evolutionary reasoning.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 57 production repos | Statistical signal | Well-structured directory layouts with module boundaries; single deployment artifacts; 40.1% of production catalog; platforms 41%, applications 38% |
| RealWorld | Orchard Core | Production app | Multi-tenant CMS built as modular monolith; each feature (themes, widgets, content types, workflows) is an independent ASP.NET Core module; single deployment with module-level boundaries; Lucene-based search, liquid templates, GraphQL API |
| RefArch | modular-monolith-with-ddd | Reference impl | DDD + CQRS + Event-Driven within monolith; module-level bounded contexts (Meetings, Administration, Payments) with integration events between modules; in-process event bus with outbox pattern; strong module isolation enforced by architecture tests |
| KataLog | 6 teams (all shown below) | Competition designs | Highest win rate of all styles (83.3%); 5 of 6 teams placed top-3 |

### Why Teams Choose This Style (Qualitative Annotation)

These qualitative insights explain the reasoning behind the statistical pattern observed in the Discovered corpus.

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

- The Discovered corpus shows modular monolith as one of the three most prevalent patterns (40.1%) across Developer Tools, E-Commerce, and CMS domains. Its broad adoption alongside Microkernel and Layered confirms it as a default starting architecture for most domains.
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

78 of 142 production repos (**54.9%**) use Layered Architecture -- a dramatic rise from 19.0% in the prior corpus as deep-analysis properly identifies layered patterns. Notable projects: nocodb (62k stars), traefik (62k), maybe (54k), mastodon (49k), discourse (46k), outline (37k). Co-occurs frequently with Modular Monolith and Microkernel. Detected through directory structures with presentation/business/data layers and dependency flow enforcement. Layered skews heavily toward applications (37/55, 67%) over platforms (41/87, 47%).

Validated by 2 AOSA/RealWorld production systems: SQLAlchemy (two-layer Core + ORM, Python standard) and nopCommerce (four-layer architecture, 60K+ stores, 17 years of evolution). Zero KataLog teams proposed layered architecture (qualitative annotation). This absence is expected -- layered architecture is seen as a default rather than an explicit architectural choice in competition contexts.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 78 production repos | Statistical signal | Directory structures with presentation/business/data layers; dependency flow enforcement; layer-per-folder project organization; 54.9% of production catalog; applications 67%, platforms 47% |
| AOSA | SQLAlchemy | Production system | Two distinct layers: Core (SQL expression language, schema definition, connection pooling) and ORM (unit of work, identity map, relationship loading); strict layer separation with Core usable independently |
| RealWorld | nopCommerce | Production app | Four-layer architecture: Web (Razor views, API controllers), Services (business logic), Data (Entity Framework, repositories), Core (domain entities, DTOs); 60K+ live stores; 17 years of evolution |

### Why Teams Choose This Style (Qualitative Annotation)

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

3 of 142 production repos (**2.1%**) use DDD -- down sharply from 17.8% (29/163) in the prior corpus. Notable production project: saleor (22k stars). The dramatic decline reflects tutorial bias correction: many repos previously counted (CleanArchitecture, domain-driven-hexagon, abp) are reference/tutorial implementations now excluded from frequency counts per ADR-002. These continue to serve as annotation examples. Detected through aggregate root patterns, bounded context directory structures, and domain event implementations.

3 reference implementations (annotation examples, not counted) demonstrate DDD in practice: eShopOnContainers (DDD within microservices), modular-monolith-with-ddd (DDD within monolith), and wild-workouts-go (DDD in Go). ~10 KataLog teams applied DDD (qualitative annotation); judges noted that DDD context mapping provided the strongest decomposition rationale among winners.

> **Tutorial bias correction:** The prior 17.8% DDD frequency was inflated by reference/tutorial repos (CleanArchitecture, domain-driven-hexagon, modular-monolith-with-ddd, etc.) that demonstrate DDD patterns but are not production software. ADR-002 excludes these from frequency counts, revealing that DDD as a primary classifiable style appears in only 2.1% of production repos. This reflects a classification artifact rather than production absence -- real production systems using DDD are classified by their deployment style (microservices, modular monolith).

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 3 production repos (+ reference examples) | Statistical signal | Aggregate root patterns, bounded context directory structures, domain event implementations; 2.1% of production catalog (down from 17.8% after tutorial bias correction) |
| RefArch | eShopOnContainers | Reference impl | Bounded contexts as microservice boundaries (Catalog, Basket, Ordering); aggregates with invariant enforcement; domain events for intra-context side effects; value objects (Address, Money); anti-corruption layers and context mapping between services |
| RefArch | modular-monolith-with-ddd | Reference impl | DDD tactical patterns within monolith modules (Meetings: aggregate root with rich domain model, Administration: simpler CRUD); each module owns its domain model; integration events for cross-module communication |
| RefArch | wild-workouts-go | Reference impl | DDD in Go idiom; Training bounded context with aggregate roots; domain events; repository pattern with interface-based ports; demonstrates DDD outside the Java/C# ecosystem |
| KataLog | ~10 teams (top shown below) | Competition designs | Applied as decomposition methodology within other primary styles |

### Why Teams Choose This Style (Qualitative Annotation)

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

- In the Discovered production corpus, DDD is rare (2.1%) but reference implementations demonstrate extensive DDD adoption with Hexagonal and CQRS. These tactical patterns cluster together in practice, confirming they are complementary methodology choices.
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

12 of 142 production repos (**8.5%**) use Microservices. Notable projects: supabase (98k stars), dapr (25k), microservices-demo (19k), server (18k). Predominantly a platform pattern: 11/87 platforms (13%) vs 1/55 applications (2%). Detected through Docker Compose multi-service layouts, API gateway configs, and per-service databases. Common in Developer Tools and Infrastructure domains.

5 reference implementations (annotation): eShopOnContainers, eShop, serverless-microservices-azure, AKS Baseline, wild-workouts-go. Zero production systems across AOSA and RealWorld. 39 KataLog teams chose this style (qualitative annotation, second-most popular); judges noted that winners paired microservices with DDD and event-driven, while runner-ups adopted it as default without justification.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 12 production repos | Statistical signal | Docker Compose multi-service layouts, API gateway configs, per-service databases; 8.5% of production catalog; predominantly platforms (13%) vs applications (2%) |
| RefArch | eShopOnContainers | Reference impl | Microsoft canonical microservices sample; Catalog, Basket, Ordering, Identity as independent services; DDD aggregates, CQRS in Ordering, integration events via RabbitMQ/Azure Service Bus; Docker Compose and Kubernetes deployment; ~15K GitHub stars |
| RefArch | eShop | Reference impl | Simplified eShopOnContainers on .NET 8 Aspire; same service boundaries with reduced operational complexity; modern .NET hosting model |
| RefArch | serverless-microservices-azure | Reference impl | Serverless microservices on Azure Functions; Event Grid for inter-service communication; Durable Functions for orchestration; ride-sharing domain with Trips, Drivers, Passengers services |
| RefArch | AKS Baseline | Reference impl | Production-grade AKS cluster; service mesh (Linkerd/Istio), NGINX ingress, Azure Monitor, Key Vault integration; microservices deployment target with security and observability baseline |
| RefArch | wild-workouts-go | Reference impl | Microservices in Go; DDD bounded contexts (Training, User); Hexagonal ports/adapters per service; CQRS command/query handlers; gRPC and HTTP adapters |
| KataLog | 39 teams (top shown below) | Competition designs | Second-most popular style; winners paired with DDD and event-driven; runner-ups adopted as default without justification |

### Why Teams Choose This Style (Qualitative Annotation)

These qualitative insights explain the reasoning behind the statistical pattern observed in the Discovered corpus.

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

### Ecosystem Evidence (SPEC-026)

3 of 11 curated ecosystems (27%) exhibit Microservices architecture -- each demonstrating a different microservices composition pattern.

| Ecosystem | Members | Composition Pattern | Key Integration Evidence |
|-----------|---------|--------------------|-----------------------|
| **Istio/Envoy Mesh** | Istio, Envoy | Control-plane/data-plane via xDS protocol | Envoy subscribes to configuration updates from Istio via gRPC-based xDS API; Istio translates high-level routing rules into Envoy-native configuration; sidecar proxy topology |
| **Sentry Platform** | Sentry, Snuba, Relay, self-hosted | Event pipeline with service specialization | Services communicate via Kafka topics (Relay publishes events, Sentry consumers process them, Snuba indexes into ClickHouse) and HTTP APIs (Sentry queries Snuba for analytics) |
| **Supabase Platform** | Supabase, PostgREST, Auth, Realtime, Storage | Polyglot services unified by PostgreSQL and API gateway | Kong API gateway routes to PostgREST, Auth, Realtime, and Storage; PostgreSQL as shared state layer; HTTP/WebSocket inter-service APIs |

> **Why this matters**: Single-repo microservices detection (8.5%) captures monorepo microservice deployments. Ecosystem evidence reveals three distinct microservices composition patterns: control-plane/data-plane separation (Istio/Envoy), event-pipeline specialization (Sentry), and API-gateway-unified polyglot services (Supabase). These ecosystems provide positive evidence of what real multi-service systems look like -- ecosystem members ARE independently deployed by definition.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations, production validation, and ecosystem evidence:

- In the Discovered corpus, microservices repos (8.5%) cluster in Developer Tools and Infrastructure domains, predominantly as platforms (13% of platforms vs 2% of applications).
- Systems with well-understood domain boundaries where independent deployment and scaling provide clear value (eShopOnContainers: Catalog, Basket, Ordering as independent services)
- Control-plane/data-plane separations where the two planes have fundamentally different concerns (Istio/Envoy: policy vs proxying)
- Polyglot service compositions unified by a shared data layer and API gateway (Supabase: PostgREST, Auth, Realtime, Storage behind Kong)
- Organizations with mature DevOps capabilities and experience operating distributed systems (AKS Baseline: production-grade cluster configuration)
- When paired with DDD, event storming, or explicit evolutionary paths -- every winning KataLog team justified decomposition with domain analysis
- Large teams needing parallel development independence across service boundaries

**When to avoid**:

- Greenfield projects where the domain model is still evolving -- modular monolith or service-based provides a safer starting point (MonArch, PegasuZ both proposed this)
- Small teams who cannot sustain the operational burden (Sysops Squad: 6 of 7 teams chose service-based over microservices)
- Budget-constrained contexts where the infrastructure overhead is prohibitive
- When adopted as a default without justifying the operational complexity -- KataLog runner-up microservices teams consistently scored lower when they declared the style without showing domain decomposition rationale

---

## 6. Pipeline

### Evidence Summary

13 of 142 production repos (**9.2%**) use Pipeline (canonical style name, previously "Pipe-and-Filter"). Notable projects: dify (131k stars), langchain (128k), localstack (64k), traefik (62k), airflow (44k). Predominantly a platform pattern: 11/87 platforms (13%) vs 2/55 applications (4%). Detected through stage-based directory layouts, pipeline configuration files, and data transformation chains. Common in Data Processing, AI/ML, and Infrastructure domains.

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
| Discovered | 13 production repos | Statistical signal | Data processing pipelines, ETL systems, stream processors, AI/ML chains; 9.2% of production catalog; predominantly platforms (13%) vs applications (4%) |
| AOSA | NGINX | Production system | HTTP request processing pipeline: accept -> read -> parse -> process -> filter -> send; each phase is a handler in a chain; output filters for gzip, chunked encoding, SSI; serves 30%+ of internet traffic |
| AOSA | LLVM | Production system | 3-phase compiler pipeline: frontend (C/C++/Rust parsing) -> IR (optimization passes) -> backend (x86/ARM/WASM code gen); passes are composable and reorderable; foundation of Apple Clang, Rust compiler, Swift compiler |
| AOSA | GStreamer | Production system | Media pipeline: source -> demux -> decode -> filter -> encode -> sink; elements connected via pads with capability negotiation; dynamic pipeline reconfiguration |
| AOSA | Graphite | Production system | Carbon (collection with line/pickle/AMQP receivers) -> Whisper (fixed-size time-series storage) -> Graphite-Web (Django rendering/API); Carbon relay for fan-out |
| AOSA | ZeroMQ | Production system | I/O thread pipeline: socket -> session -> encoder -> engine; zero-copy message passing between stages; batch processing in pipeline for throughput |
| RealWorld | Jellyfin | Production app | Transcoding pipeline: input -> demux -> decode -> filter (scale, subtitle burn) -> encode -> mux -> output; FFmpeg-based with pluggable codec support |

### Why Teams Choose This Style (Qualitative Annotation)

No KataLog teams explicitly proposed pipeline architecture. The complete absence from competition is itself a finding: pipeline architecture solves data-transformation and request-processing problems that rarely appear in Kata problem statements (which tend toward business-domain coordination). This suggests the pattern is under-recognized in architecture education despite dominating infrastructure software.

**Composability as key differentiator**: LLVM's passes can be reordered and composed arbitrarily. GStreamer's elements connect via negotiated pads. NGINX's output filters chain transparently. In every AOSA case, the pipeline's power comes from composable stages with well-defined input/output contracts -- not from the linear topology alone but from the interchangeability of stages within that topology.

### Ecosystem Evidence (SPEC-026)

2 of 11 curated ecosystems (18%) exhibit Pipeline architecture -- both demonstrating stage pipeline composition across independently developed repos.

| Ecosystem | Members | Composition Pattern | Key Integration Evidence |
|-----------|---------|--------------------|-----------------------|
| **ELK Stack** | Elasticsearch, Kibana, Logstash, Beats | Stage pipeline (ingest -> store -> visualize) | Beats ships via Lumberjack/HTTP to Logstash; Logstash outputs via Elasticsearch bulk API; Kibana reads via Elasticsearch query API |
| **Apache Data Ecosystem** | Kafka, Flink, Spark, Airflow, NiFi | Stage pipeline with event backbone | Kafka's binary protocol for streaming; REST/Thrift APIs for job submission (Flink, Spark); NiFi's FlowFile abstraction for data routing |

> **Why this matters**: Pipeline architecture at single-repo level (9.2%) captures individual data processing tools. Ecosystem evidence reveals the *composition* pattern -- how these tools chain into multi-stage pipelines where each independently-developed repo is a stage. The ELK stack (ingest -> store -> visualize) and Apache data ecosystem (collect -> stream -> process -> orchestrate -> route) are canonical examples of pipeline architecture that are invisible at the single-repo level.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations, production validation, and ecosystem evidence:

- In the Discovered corpus, pipeline repos (9.2%) cluster in Data Processing, AI/ML, and Infrastructure domains, predominantly as platforms (13%) vs applications (4%). Includes high-profile projects like dify (131k), langchain (128k).
- Multi-repo data processing stacks where each component is a pipeline stage (ELK: Beats -> Logstash -> Elasticsearch -> Kibana; Apache: NiFi -> Kafka -> Flink/Spark -> Airflow)
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

1 of 142 production repos (**0.7%**) use CQRS -- down sharply from 10.4% (17/163) in the prior corpus. The dramatic decline reflects tutorial bias correction: most repos previously counted (CleanArchitecture, domain-driven-hexagon, modular-monolith-with-ddd, eShop) are reference/tutorial implementations now excluded from frequency counts per ADR-002. These continue to serve as annotation examples. Detected through command/query separation patterns, event store configurations, and projection/read-model builders.

Validated by 1 RealWorld production system: Squidex (full event sourcing, MongoDB event store, headless CMS). 4 reference implementations (annotation examples, not counted): eShopOnContainers, modular-monolith-with-ddd, wild-workouts-go, clean-architecture-dotnet. ~5 KataLog teams applied CQRS (qualitative annotation), consistently pairing it with event-driven communication.

> **Tutorial bias correction:** The prior 10.4% CQRS frequency was inflated by reference/tutorial repos that demonstrate CQRS patterns but are not production software. ADR-002 excludes these from frequency counts, revealing CQRS at 0.7% of production repos.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 1 production repo (+ reference examples) | Statistical signal | Command/query separation patterns, event store configurations, projection/read-model builders; 0.7% of production catalog (down from 10.4% after tutorial bias correction) |
| RealWorld | Squidex | Production app | CQRS + event sourcing as primary architecture; every content change stored as immutable event; MongoDB event store; full event history enables audit trail, temporal queries, and replay; headless CMS |
| RefArch | eShopOnContainers | Reference impl | CQRS in Ordering service: separate read/write models; MediatR for command/query dispatch; integration events for cross-service eventual consistency |
| RefArch | modular-monolith-with-ddd | Reference impl | CQRS within monolith modules; separate command and query handlers per module; in-process event bus |
| RefArch | wild-workouts-go | Reference impl | CQRS in Go; command handlers for training mutations, query handlers for read models; separate write and read repositories |
| RefArch | clean-architecture-dotnet | Reference impl | CQRS with Hexagonal architecture; MediatR pipeline for commands and queries; clean separation of read/write concerns |
| KataLog | Iconites | 2nd, Road Warrior | Event-driven + space-based + CQRS read/write separation for travel itinerary management |
| KataLog | Street Fighters | Runner-up, Road Warrior | Kubernetes + message broker + CQRS for trip data |

### Why Teams Choose This Style (Qualitative Annotation)

KataLog evidence is thin (~5 teams) but consistent: teams using CQRS paired it with event-driven communication. Iconites (2nd, Road Warrior) used CQRS read/write separation for travel itinerary management alongside space-based and event-driven patterns.

**Squidex as canonical production CQRS**: Squidex stores every content mutation as an immutable event in MongoDB. The current state is derived from event replay. This enables temporal queries ("what did this content look like on date X?"), complete audit trails, and event-based integrations with downstream systems. Squidex demonstrates that full event sourcing (not just CQRS read/write separation) is viable in production for content management domains where the event history has intrinsic business value.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations and production validation:

- In the Discovered production corpus, CQRS is rare (0.7%) but reference implementations demonstrate the pattern extensively. All 4 reference implementations apply CQRS within bounded contexts, not system-wide.
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

5 of 142 production repos (**3.5%**) use Hexagonal Architecture -- unchanged from the prior 3.5% but now on a production-only base. Notable projects: jellyfin (49k stars), keycloak (33k). Many repos previously counted (CleanArchitecture, domain-driven-hexagon, buckpal) are reference/tutorial implementations now excluded from frequency counts per ADR-002. Detected through port/adapter directory structures, dependency inversion patterns, and clean architecture layer organization across Java, C#, Go, TypeScript, and Kotlin.

3 reference implementations (annotation examples, not counted): buckpal (Java, hexagonal purity), clean-architecture-dotnet (C# + CQRS), wild-workouts-go (Go idiom). ~6 KataLog teams applied hexagonal (qualitative annotation), consistently as internal structure within modular monolith or microservices.

> **Tutorial bias note:** Hexagonal's absolute percentage held at 3.5% despite the denominator change (163 to 142), but its old count (20 repos) was inflated by tutorial implementations. The production count (5 repos) reflects genuine production adoption. Like DDD, Hexagonal serves as an internal structure within other styles.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 5 production repos (+ reference examples) | Statistical signal | Port/adapter directory structures, dependency inversion patterns, clean architecture layer organization; 3.5% of production catalog (down from 12.3% in count after tutorial bias correction) |
| RefArch | buckpal | Reference impl | Hexagonal purity as primary goal; banking sample (Send Money use case); incoming ports (use cases), outgoing ports (persistence, external); adapters (web controller, JPA persistence, external API); dependency rule enforced via compile-time checks; Tom Hombergs' companion to "Get Your Hands Dirty on Clean Architecture" |
| RefArch | clean-architecture-dotnet | Reference impl | Hexagonal + CQRS in C#; four projects (Domain, Application, Infrastructure, Web); MediatR pipeline behaviors for cross-cutting concerns; ports as Application-layer interfaces; FluentValidation for command validation |
| RefArch | wild-workouts-go | Reference impl | Hexagonal in Go; port interfaces (TrainingRepository, UserService); adapters for HTTP, gRPC, and in-memory test implementations; DDD aggregate roots within hexagonal boundary; demonstrates idiomatic Go approach to ports-and-adapters |
| KataLog | MonArch | 1st, Hey Blue! | Hexagonal internals within modular monolith; ports and adapters ensuring each module can be extracted without rewriting business logic; 7 ADRs |
| KataLog | Miyagi's Little Forests | 2nd, Farmacy Food | Hexagonal + event-driven microservices; AWS EKS with hexagonal internal structure per service; element catalog per service; 6 ADRs |
| KataLog | Architects++ | 3rd, Farmacy Family | Hexagonal + service-based + batch processing; AWS Batch with hexagonal internal structure; 15 ADRs |

### Why Teams Choose This Style (Qualitative Annotation)

KataLog and RefArch sources agree that hexagonal architecture excels as an internal structure within other styles. MonArch (1st, Hey Blue!) used hexagonal internals within a modular monolith; Miyagi's Little Forests (2nd, Farmacy Food) used it within microservices. This pattern -- hexagonal as internal structure, not primary architecture -- is consistent across all sources.

**Three reference implementations, three languages, one pattern**: buckpal (Java), clean-architecture-dotnet (C#), and wild-workouts-go (Go) implement hexagonal architecture in different languages and domains but converge on identical structural principles: domain logic at the center with no outward dependencies, port interfaces defined in the application layer, and adapters at the boundary handling infrastructure concerns. This cross-language consistency is stronger evidence for the pattern's generality than any single implementation.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered production corpus, hexagonal repos (3.5%) include jellyfin (49k) and keycloak (33k). Reference implementations demonstrate the pattern extensively across Java, C#, and Go.
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

0 of 142 production repos use Serverless -- the style has no production representation in the Discovered corpus after tutorial/reference exclusion. The prior 1.8% (3/163) included reference implementations (aws-serverless-airline-booking, azure-functions-host) now excluded per ADR-002.

1 reference implementation (annotation example, not counted): serverless-microservices-azure. Zero production systems across AOSA and RealWorld. 8 KataLog teams chose this style (qualitative annotation, 25% win rate); judges noted serverless performed best as a component within broader architectures, with cost optimization as the universal rationale.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 0 production repos (reference examples only) | Statistical signal | Function-as-a-service configurations, event trigger definitions, serverless framework configs; zero production entries after tutorial/reference exclusion |
| RefArch | serverless-microservices-azure | Reference impl | Azure Functions + Event Grid + Event Hubs; ride-sharing domain with serverless microservices; Durable Functions for orchestration; API Management for gateway |
| KataLog | 8 teams (top shown below) | Competition designs | Strongest in cost-sensitive contexts; best when combined with other patterns |

### Why Teams Choose This Style (Qualitative Annotation)

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

- Serverless has zero production entries in the Discovered corpus after tutorial/reference exclusion, confirming it works best as a component in event-driven workflows rather than a standalone production pattern.
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

1 of 142 production repos (**0.7%**) use Multi-Agent -- down from 6.7% (11/163) in the prior corpus. Notable production project: AutoGPT (182k stars). Most repos previously counted (langchain, autogen, crewAI, semantic-kernel) are reference/framework implementations now excluded from frequency counts per ADR-002. Multi-Agent appears exclusively in applications (1/55, 2%) with zero platform representation.

Zero AOSA/RealWorld production systems and zero reference implementations. ~3 KataLog teams (qualitative annotation, AI-focused challenges, Winter 2024-2025); judges noted that constrained agent autonomy through supervisor hierarchies and formal evaluation frameworks separated winners from the field.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 1 production repo (+ reference examples) | Statistical signal | Agent orchestration patterns, multi-model configurations, LLM chain definitions; 0.7% of production catalog; applications only (2%) |
| KataLog | ConnectedAI | 1st, ShopWise AI | Multi-agent supervisor hierarchy with LangGraph; dual-LLM cost optimization (Claude for reasoning, Gemini for routing); quantitative evaluation with Ragas + LangFuse |
| KataLog | Breakwater | 2nd, ShopWise AI | Multi-agent workflow-orchestrated with n8n; OpenAI + PostgreSQL; workflow engine as agent coordinator |
| KataLog | Usfive | Runner-up, Certifiable Inc. | Multi-agent scoring with multiple LLMs; confidence-based escalation between agents |

### Why Teams Choose This Style (Qualitative Annotation)

Multi-agent is the newest and least-evidenced style, appearing exclusively in the AI-focused Kata challenges. Within its limited evidence, a consistent pattern emerges: successful multi-agent teams constrained agent autonomy through supervisor hierarchies, workflow orchestration, and confidence-based escalation.

**Architectural governance as differentiator**: ConnectedAI built a supervisor hierarchy where a routing agent delegated to specialized agents (product search, recommendation, FAQ), each with explicit capability boundaries and fallback paths. Breakwater used n8n workflow orchestration to coordinate agents with deterministic handoff points. Both approaches constrain agent autonomy -- the winning pattern is not autonomous agents but orchestrated agents with defined contracts, mirroring the plugin/microkernel pattern's core-extension relationship in an AI context.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations:

- In the Discovered production corpus, multi-agent is rare (0.7%, 1 repo) but reference implementations include some of the most-starred projects on GitHub (langchain 128k, autogen 55k). The pattern is growing rapidly in the AI/ML domain.
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

1 of 142 production repos (**0.7%**) use Space-Based architecture -- down from 3.1% (5/163). Notable production project: dragonfly (30k stars). Most repos previously counted (hazelcast, ignite, geode, infinispan) may have been reclassified or excluded. Space-Based appears exclusively in platforms (1/87, 1%) with zero application representation.

Validated by 1 AOSA production system: Riak (peer-to-peer distributed key-value store, tunable consistency, no single point of failure). ~2 KataLog teams chose this style (qualitative annotation) for high-concurrency, peak-load scenarios.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 1 production repo | Statistical signal | In-memory data grid patterns, distributed caching configurations; 0.7% of production catalog; dragonfly (30k); platforms only (1%) |
| AOSA | Riak | Production system | Peer-to-peer distributed key-value store; consistent hashing for data partitioning; tunable consistency (read/write quorum); no single point of failure; rack-aware replica placement |
| KataLog | Iconites | 2nd, Road Warrior | Space-based + event-driven + microservices; Cosmos DB + Redis for in-memory data grid; designed for Road Warrior's 15M user peak-load scenario |
| KataLog | LowCode | 3rd (tied), MonitorMe | Distributed system with event bus and distributed appliance nodes; space-based topology for medical device data |

### Why Teams Choose This Style (Qualitative Annotation)

KataLog evidence is sparse (2 teams) but targeted: both teams chose space-based for high-concurrency, peak-load scenarios (Road Warrior's 15M users, MonitorMe's distributed sensor nodes).

**Riak's architectural lessons**: Riak demonstrates the core space-based principles at infrastructure scale: no master node (peer-to-peer), data distributed via consistent hashing across a ring, tunable N/R/W values allowing per-request consistency-availability trade-offs, and hinted handoff for partition tolerance. These same principles (replicated data, no central coordinator, tunable consistency) define the application-level space-based architecture pattern, making Riak both an implementation of and infrastructure for space-based systems.

### Ecosystem Evidence (SPEC-026)

1 of 11 curated ecosystems exhibits Space-Based architecture.

| Ecosystem | Members | Composition Pattern | Key Integration Evidence |
|-----------|---------|--------------------|-----------------------|
| **Apache Data Grid** | Geode, Ignite | Alternative implementations of space-based pattern | Both implement data partitioned across nodes with processing co-located where data lives (data affinity); cluster coordination via membership protocols; parallel implementations rather than complementary services |

> **Why this matters**: The Apache Data Grid ecosystem is unusual -- it documents two independent implementations of the same space-based pattern (Geode and Ignite) rather than complementary services. This provides comparative architectural evidence: both projects converged on the same fundamental design (partitioned data, co-located processing, membership coordination) despite independent development, strengthening the case for space-based as a coherent architectural pattern.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations, production validation, and ecosystem evidence:

- In the Discovered production corpus, space-based is rare (0.7%, 1 repo: dragonfly 30k stars) but consistent with the pattern's focus on distributed in-memory data management. The Apache Data Grid ecosystem (Geode, Ignite) provides additional evidence of the pattern's implementation in production data grid infrastructure.
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

7 of 142 production repos (**4.9%**) use Service-Based architecture. Notable projects: dify (131k stars), mastodon (49k), temporal (18k), linkerd2 (11k). Evenly split: platforms 4/87 (5%), applications 3/55 (5%). Detected through coarse-grained service boundaries with shared database patterns.

Validated by 3 AOSA/RealWorld production systems: Graphite (three coarse-grained services), Selenium (hub-node topology), and Bitwarden (SOC2-certified service-based decomposition). 1 reference implementation (annotation): AKS Baseline. 25 KataLog teams chose this style (qualitative annotation), dominant in budget-constrained and monolith-migration contexts; in the Sysops Squad challenge, 6 of 7 teams chose it; in Certifiable Inc., 6 of 7 teams chose it.

> **Detection note:** Deep-analysis improved Service-Based detection to 4.9% (7/142 production repos), but the style may still be underrepresented since it can resemble a monolith in code structure while having service-level deployment boundaries.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 7 production repos | Statistical signal | Coarse-grained service boundaries with shared database patterns; 4.9% of production catalog; platforms 5%, applications 5% |
| AOSA | Graphite | Production system | Carbon (collection), Whisper (time-series storage), Graphite-Web (rendering/API) -- three coarse-grained services with clear boundaries; independently deployable but sharing a common data format |
| AOSA | Selenium | Production system | WebDriver protocol with per-browser adapter drivers; hub-node topology for distributed test execution; coarse service decomposition (hub, node, driver) |
| RealWorld | Bitwarden | Production app | Zero-knowledge vault with service-based decomposition: API, Identity, Admin, Events, Notifications; shared database with service-level access control; SOC2 certified |
| RefArch | AKS Baseline | Reference impl | Microservices + service-based on Kubernetes; AKS cluster with ingress controller, service mesh, and coarse service boundaries |
| KataLog | 25 teams (top shown below) | Competition designs | Dominant style in Sysops Squad (6/7 teams) and Certifiable Inc. (6/7 teams); chosen for budget-constrained and monolith-migration contexts |

### Why Teams Choose This Style (Qualitative Annotation)

These qualitative insights explain the reasoning behind the statistical pattern observed in the Discovered corpus.

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

### Ecosystem Evidence (SPEC-026)

5 of 11 curated ecosystems (45%) exhibit Service-Based architecture -- the dominant ecosystem style. This is the strongest evidence that Service-Based is underrepresented in single-repo analysis.

| Ecosystem | Members | Composition Pattern | Key Integration Evidence |
|-----------|---------|--------------------|-----------------------|
| ***arr Media Stack** | Overseerr, Sonarr, Radarr, Prowlarr, Lidarr | Hub-and-spoke via REST APIs | Each service owns its domain (TV, movies, music, indexing, requests); separate databases; REST API integration with API key auth |
| **Grafana LGTM Stack** | Grafana, Loki, Tempo, Mimir | Service composition with unified query frontend | Each service handles one observability signal (dashboards, logs, traces, metrics); connected via data source plugin interfaces (LogQL, TraceQL, PromQL) |
| **HashiCorp Stack** | Consul, Vault, Nomad, Terraform | Cross-service API integration | Each service owns an infrastructure domain (discovery, secrets, scheduling, provisioning); Raft consensus per service; HTTP/gRPC APIs with mTLS |
| **Fediverse** | Mastodon, Discourse, Forem, Lemmy | Federated protocol interoperation | W3C ActivityPub protocol defines the integration contract; each service is independently deployed with own database and auth; federated distribution model |
| **Temporal Platform** | Temporal, sdk-go | Orchestration server with worker SDK | Server provides durable workflow orchestration; SDKs run worker runtimes that poll tasks via gRPC; server/worker separation is Service-Based |

> **Why this matters**: At 4.9% of single-repo entries, Service-Based appears uncommon. But 45% of ecosystems are Service-Based -- because the pattern's defining characteristic (independently deployed coarse-grained services) is only visible when examining how multiple repos compose. Ecosystem evidence transforms Service-Based from a statistically marginal style to one with strong real-world production representation.

### When to Use / Avoid

**When to use** -- grounded in Discovered domain correlations, production validation, and ecosystem evidence:

- Service-based repos in the Discovered production corpus (4.9%, 7 repos) are led by dify (131k), mastodon (49k), and temporal (18k). Combined with 3 AOSA/RealWorld production systems (Selenium, Graphite, Bitwarden) and 5 ecosystem entries, the evidence strongly confirms service-based architecture in practice.
- Multi-repo product ecosystems where each component owns a domain (*arr stack: media type per service; HashiCorp: infrastructure domain per tool; Grafana LGTM: observability signal per service)
- Monolith migration where independent deployability is needed without full microservices complexity (Sysops Squad: near-unanimous choice; Graphite: independently scalable but coarse-grained)
- Budget-constrained and non-profit contexts (ClearView, Certifiable Inc. winners chose service-based citing cost)
- AI-integration scenarios where the primary goal is adding AI capabilities to existing platforms (Certifiable Inc.: 6 of 7 teams)
- Organizations with limited DevOps maturity needing fault isolation without distributed systems overhead (Bitwarden: SOC2 with service-based)
- Federated systems where participants interoperate via a shared protocol (Fediverse: ActivityPub-based federation)

**When to avoid**:

- Systems requiring extreme independent scalability across service boundaries (Graphite eventually required relay fan-out for scale)
- Large teams (10+) that benefit from microservices-level independence for parallel development
- Domains with high throughput requirements where shared database becomes a bottleneck

---

## 13. Microkernel

### Evidence Summary

83 of 142 production repos (**58.5%**) use Microkernel -- the most prevalent style in the production corpus, a dramatic rise from 0% in heuristic detection and 20.2% under SPEC-019 (under old name "Plugin/Microkernel"). Notable projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), strapi (71k). Dominates both platforms (53/87, 61%) and applications (30/55, 55%). SPEC-022 deep-analysis properly identifies runtime extension points, plugin registries, and host-plugin contracts that old heuristics missed.

Additionally validated by 6 production systems (the most of any style except Event-Driven):
- LLVM (plugin pass architecture)
- GStreamer (pipeline elements as loadable plugins)
- SQLAlchemy (dialect plugins for database backends)
- Jellyfin (plugin system for metadata/notification/auth)
- nopCommerce (plugin marketplace, 60K+ stores)
- Orchard Core (multi-tenant module system)

Combined Weighted Score: 157 (rank #2). ~4 KataLog teams proposed it (qualitative annotation).

> **Detection history:** Plugin architectures were a complete blind spot in heuristic analysis (0 of 122 repos). SPEC-019 deep-validation resolved this to 20.2%. SPEC-022 deep-analysis with canonical style name normalization ("Microkernel") and improved detection raised this to 58.5% -- the largest style in the production corpus. This reflects the ubiquity of plugin/extension patterns in well-engineered open-source software.

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| Discovered | 83 production repos | Statistical signal | Plugin registries, extension points, host-plugin contracts; 58.5% of production catalog; platforms 61%, applications 55%; includes n8n (177k), elasticsearch (76k), nest (74k), redis (73k), grafana (72k), strapi (71k) |
| AOSA | LLVM | Production system | Plugin pass architecture -- optimization and analysis passes loaded dynamically; modular IR enables third-party backends; 3-phase compiler pipeline with pluggable stages |
| AOSA | GStreamer | Production system | Pipeline elements as loadable plugins; negotiation protocol between elements; plugin registry with lazy loading and caching |
| AOSA | SQLAlchemy | Production system | Dialect plugins for database backends (PostgreSQL, MySQL, SQLite, Oracle); Core layer (SQL expression) + ORM layer; engine plugins for connection customization |
| RealWorld | Jellyfin | Production app | Self-hosted media server; plugin system for metadata providers, notification targets, authentication backends; transcoding pipeline with pluggable codecs |
| RealWorld | nopCommerce | Production app | 60K+ live stores over 17-year evolution; plugin marketplace for payments, shipping, tax, widgets; four-layer architecture with plugin injection points |
| RealWorld | Orchard Core | Production app | Multi-tenant CMS; module system where each feature is an independent module (themes, widgets, content types); ASP.NET Core module loading |
| KataLog | Software Architecture Guild | 3rd, Certifiable Inc. | Microkernel with plug-in AI grading solutions; six parallel AI solutions via plug-in architecture |
| KataLog | Wonderous Toys | 3rd, Wildlife Watcher | Micro Kernel paired with modular monolith and event-driven for species identification extensions |

### Why Teams Choose This Style (Qualitative Annotation)

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

Shows which sources provide evidence for each style. Filled cells indicate at least one entry; numbers show entry count. Discovered column shows production-only counts (142 entries, SPEC-022). Reference implementations (42 entries) serve as annotation examples but are not counted.

| Style | Discovered (142 prod) | AOSA | RealWorld | KataLog |
|-------|----------------------|------|-----------|---------|
| Microkernel | 83 | 3 | 3 | ~4 |
| Layered | 78 | 1 | 1 | -- |
| Modular Monolith | 57 | -- | 1 | 6 |
| Event-Driven | 17 | 3 | 2 | 47 |
| Pipeline | 13 | 5 | 1 | -- |
| Microservices | 12 | -- | -- | 39 |
| Service-Based | 7 | 2 | 1 | 25 |
| Hexagonal/Clean | 5 | -- | -- | ~6 |
| DDD | 3 | -- | -- | ~10 |
| Multi-Agent | 1 | -- | -- | ~3 |
| Space-Based | 1 | 1 | -- | ~2 |
| CQRS | 1 | -- | 1 | ~5 |

**Observations**:
- **Microkernel** is now the most prevalent Discovered style (83 repos, 58.5%) with the strongest combined evidence (6 AOSA/RealWorld production systems). SPEC-022 deep-analysis dramatically improved detection of plugin architectures.
- **Layered** rose to the second most prevalent style (78 repos, 54.9%), up from 21.5%, as deep-analysis properly identifies layered patterns.
- **Modular Monolith** remains broadly prevalent (57 repos, 40.1%), essentially stable from prior estimates.
- **Tutorial bias corrected**: DDD (2.1%), CQRS (0.7%), and Hexagonal (3.5%) dropped significantly after excluding reference/tutorial implementations from frequency counts per ADR-002.
- **Event-Driven** dropped from 28.8% to 12.0% as deep-analysis corrected over-classification from message broker presence.
- Zero entries remain Indeterminate (ADR-002 eliminated all prior Indeterminate classifications).
- Four styles (**Microservices, DDD, Hexagonal, Multi-Agent**) have zero production evidence from AOSA or RealWorld.

---

## Cross-Style Patterns

Several patterns emerge when comparing evidence across all 13 styles:

### Discovered Frequency vs. Production Evidence

Microkernel (58.5%) is the most prevalent style in the production corpus, followed by Layered (54.9%) and Modular Monolith (40.1%). These three styles form the foundational triad of production open-source software. Event-Driven dropped to 12.0% after deep-analysis corrected over-classification.

Production evidence confirms these findings. Microkernel has 6 AOSA/RealWorld production systems -- the most of any style. Event-Driven has 5. Modular Monolith has Orchard Core and the highest KataLog win rate (83.3%).

The production-weighted rankings now align closely with Discovered frequency. Microkernel ranks #2 by combined score with dominant Discovered presence (83 repos) and dominant production evidence. Pipeline ranks #3 with 13 Discovered production repos. These styles dominate in infrastructure software (LLVM, NGINX, GStreamer, SQLAlchemy, n8n, elasticsearch, grafana).

### Combination Outperforms Purity

Across all sources, combined styles outperform pure styles. Event-Driven + Service-Based won more KataLog challenges than either alone. Hexagonal is used as internal structure within Microservices and Modular Monolith. CQRS appears within DDD-organized services. Plugin architecture hosts Pipeline stages (GStreamer, LLVM). The high co-occurrence rates in the production corpus confirm this: Microkernel (58.5%), Layered (54.9%), and Modular Monolith (40.1%) overlap extensively, as most well-structured production repos exhibit multiple styles simultaneously. The evidence consistently shows that real systems combine multiple styles, with one as the primary deployment architecture and others as internal structural patterns.

### The Evolutionary Path

KataLog winners frequently proposed evolutionary architectures: Modular Monolith as initial deployment with microservices as documented future state (MonArch, PegasuZ), Service-Based as Phase 1 with microservices as Phase 3 (Pentagram). The modular-monolith-with-ddd reference implementation demonstrates that DDD, CQRS, and Event-Driven patterns work within a monolith -- enabling future extraction without requiring distributed infrastructure from day one. Discovered production data supports this: the high co-occurrence of Modular Monolith with Microkernel and Layered suggests many codebases start modular and adopt plugin extension patterns incrementally.

### Evidence Gaps

Four styles have zero AOSA/RealWorld production evidence: Microservices (12 production repos), DDD (3 production repos), Hexagonal (5 production repos), and Multi-Agent (1 production repo). Serverless has zero production entries after tutorial/reference exclusion.

Microservices has the widest gap between competition popularity (39 KataLog teams) and production validation (0 systems). DDD and CQRS frequencies dropped sharply after tutorial bias correction, revealing that their prior code-level presence was inflated by reference implementations.

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

| Source | Full Name | Evidence Type | Hierarchy Role | Entries |
|--------|-----------|---------------|----------------|---------|
| Discovered | Discovered open-source repositories | Deep-validated via SPEC-022 deep-analysis (ADR-002) | **PRIMARY EVIDENCE** -- leads all rankings | 142 production + 42 reference = 184 repos |
| AOSA | Architecture of Open Source Applications | Production systems described by creators | **PRODUCTION DEPTH** -- highest per-system authority | 12 projects |
| RealWorld | RealWorldASPNET production apps | Production applications with real users | **PRODUCTION DEPTH** -- highest per-system authority | 5 projects |
| KataLog | O'Reilly Architecture Kata submissions | Competition designs (never built) | **ANNOTATION ONLY** -- valued for ADR reasoning, judge commentary | 78 teams |

See [cross-source-reference.md](cross-source-reference.md) for full scoring methodology, evidence weighting rationale, and per-source quality comparison.

---

*Generated: 2026-03-09 (SPEC-022 deep-analysis, ADR-002 recomputed, 142 production entries)*
