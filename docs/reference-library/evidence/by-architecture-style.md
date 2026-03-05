# Evidence by Architecture Style

Evidence drawn from 225 entries across 5 sources: 78 KataLog competition submissions, 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 122 Discovered open-source repositories. Styles ranked by Combined Weighted Score (production-weighted). See [cross-source-reference.md](cross-source-reference.md) for scoring methodology.

**How to read this document**: Each of the 13 styles below includes an Evidence Summary (source counts and ranking), a Cross-Source Evidence Table (specific entries from each source), a Convergence Analysis (where sources agree and disagree), and evidence-grounded When to Use / When to Avoid guidance. Production evidence (AOSA, RealWorld) is listed before competition evidence (KataLog) in all tables. For styles with large KataLog samples (Event-Driven: 47 teams, Microservices: 39 teams, Service-Based: 25 teams), only top performers are shown with a note on total count.

---

## Style Performance Rankings

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

*Production % = share of Combined Score from AOSA + RealWorldASPNET sources. Production-weighted scoring (20 pts per production system) means a single production deployment outweighs an entire Kata competition season. Discovered repos are shown for breadth context but are not included in Combined Score.*

### Key Cross-Source Findings

1. **Production evidence reshapes competition rankings.** Plugin/Microkernel (#2) and Pipeline (#3) were invisible in KataLog but dominate in production. Microservices (#5) and Serverless (#12) are popular in competitions but have zero production evidence. The production-weighted scoring corrects this bias.
2. **Styles cluster into three tiers.** Tier 1 (100+ points): Event-Driven, Plugin/Microkernel, Pipeline, Service-Based -- all with significant production evidence. Tier 2 (20-76 points): Microservices, Modular Monolith, CQRS, Space-Based, Layered -- mixed evidence. Tier 3 (below 20): DDD, Hexagonal, Serverless, Multi-Agent -- no production evidence as primary styles.
3. **Internal structure patterns (DDD, Hexagonal, CQRS) appear as secondary classifiers.** They are applied within other styles rather than standing alone. This is a classification artifact, not evidence of their irrelevance -- eShopOnContainers uses all three within its microservices architecture.
4. **Discovered evidence fills gaps.** Modular Monolith dominates Discovered (64 repos, 52% of catalog) despite ranking only #6 in curated evidence. Pipeline (19 repos) confirms AOSA production evidence. Event-Driven (63 repos) shows consistent breadth across all tiers.

---

## 1. Event-Driven

### Evidence Summary

- **Combined Weighted Score**: 203 (rank #1)
- **KataLog**: 47 teams, score 94 (48.9% win rate)
- **AOSA**: 3 systems (NGINX, Twisted, ZeroMQ)
- **RealWorld**: 2 systems (Bitwarden, Squidex)
- **RefArch**: 5 repos (eShopOnContainers, eShop, modular-monolith-with-ddd, serverless-microservices, wild-workouts)
- **Discovered**: 63 repos (52% of catalog)
- **Production %**: 49%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
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
| Discovered | 63 repos | Code-level signal | Message broker configs (Kafka, RabbitMQ) in 52% of catalog; event bus implementations across Go, Java, C#, Python |

**Top KataLog teams** (47 teams total; top performers shown):

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

### Convergence Analysis

All five sources converge on event-driven as the most broadly applicable architecture pattern. AOSA production systems (NGINX, Twisted, ZeroMQ) validate it at extreme scale -- NGINX serves 30%+ of the internet using event loops. RealWorld production apps (Bitwarden, Squidex) confirm it in modern SaaS contexts. KataLog provides the largest competition sample (47 of 78 teams), showing event-driven won in every single challenge where it appeared. Discovered repos (63, 52% of catalog) confirm it as the most common code-level pattern. No other style achieves this level of cross-source unanimity.

The sources disagree on granularity. AOSA systems use event-driven at the infrastructure level (reactor patterns, I/O loops), while KataLog teams use it at the application level (message brokers between services). RealWorld and RefArch sit between these levels, using event buses for inter-service communication. This suggests event-driven is not a single pattern but a family of patterns operating at different abstraction layers.

**What KataLog winners did differently**: Top EDA teams (BluzBrothers, Profitero Data Alchemists, Pragmatic) showed deep event-flow design -- partitioning keys, consumer group configuration, dead-letter handling, and timing proof. Runner-up teams tended to adopt event-driven patterns without the same depth. Winners consistently paired events with additional structure: service-based decomposition (Team Seven, Pragmatic, ZAITects), hexagonal ports and adapters (MonArch), modular monolith boundaries (PegasuZ), or CQRS read/write separation (Iconites).

### When to Use

- Systems with inherently asynchronous data flows -- sensor streams, email polling, notification broadcasting, analytics pipelines (NGINX: C10K connections; BluzBrothers: sub-second medical monitoring)
- Domains where multiple consumers need the same event (Bitwarden: vault sync across devices; Squidex: event sourcing for content changes)
- Real-time monitoring and alerting (MonitorMe: all 7 teams used EDA; Road Warrior: 8 of 9 teams)
- Workloads requiring loose coupling between bounded contexts (eShopOnContainers: integration events between microservices)

### When to Avoid

- Small teams with limited operational experience managing message brokers -- KataLog runner-up teams that declared event-driven without showing mechanics (topic design, partition strategy, dead-letter handling) consistently scored lower
- Problems requiring strong transactional consistency across services without complementary patterns (Saga, Outbox)
- Systems where event infrastructure cost exceeds budget -- particularly non-profit and startup contexts where simpler synchronous communication may suffice initially
- Pure event-driven without complementary structure: KataLog winners consistently paired events with service-based decomposition, hexagonal internals, or CQRS

---

## 2. Plugin/Microkernel

### Evidence Summary

- **Combined Weighted Score**: 124 (rank #2)
- **KataLog**: ~4 teams, score 4
- **AOSA**: 3 systems (LLVM, GStreamer, SQLAlchemy)
- **RealWorld**: 3 systems (Jellyfin, nopCommerce, Orchard Core)
- **RefArch**: 0
- **Discovered**: 0 (structurally undetectable by automated classification)
- **Production %**: 97%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| AOSA | LLVM | Production system | Plugin pass architecture -- optimization and analysis passes loaded dynamically; modular IR enables third-party backends; 3-phase compiler pipeline with pluggable stages |
| AOSA | GStreamer | Production system | Pipeline elements as loadable plugins; negotiation protocol between elements; plugin registry with lazy loading and caching |
| AOSA | SQLAlchemy | Production system | Dialect plugins for database backends (PostgreSQL, MySQL, SQLite, Oracle); Core layer (SQL expression) + ORM layer; engine plugins for connection customization |
| RealWorld | Jellyfin | Production app | Self-hosted media server; plugin system for metadata providers, notification targets, authentication backends; transcoding pipeline with pluggable codecs |
| RealWorld | nopCommerce | Production app | 60K+ live stores over 17-year evolution; plugin marketplace for payments, shipping, tax, widgets; four-layer architecture with plugin injection points |
| RealWorld | Orchard Core | Production app | Multi-tenant CMS; module system where each feature is an independent module (themes, widgets, content types); ASP.NET Core module loading |
| KataLog | Software Architecture Guild | 3rd, Certifiable Inc. | Microkernel with plug-in AI grading solutions; six parallel AI solutions via plug-in architecture |
| KataLog | Wonderous Toys | 3rd, Wildlife Watcher | Micro Kernel paired with modular monolith and event-driven for species identification extensions |

### Convergence Analysis

Plugin/Microkernel exhibits the sharpest divergence between production prevalence and competition visibility in the entire dataset. Six production systems across AOSA and RealWorld (97% of score from production) make it the second-highest-ranked style, yet only ~4 KataLog teams ever proposed it. Automated discovery found zero instances because plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container configs -- a fundamental blind spot in signal-based classification.

AOSA and RealWorld sources strongly agree that plugin architecture excels for long-lived products that must evolve without core rewrites. LLVM (compilers), GStreamer (media), SQLAlchemy (databases), Jellyfin (media), nopCommerce (e-commerce), and Orchard Core (CMS) span entirely different domains but converge on the same structural pattern: a stable core with a well-defined extension contract. The KataLog's near-invisibility of this pattern suggests competition contexts (time-limited, greenfield) do not surface the long-lifecycle pressures where plugin architecture proves its value.

**Cross-domain consistency**: The plugin contract varies by domain (LLVM: pass interface; GStreamer: element/pad protocol; SQLAlchemy: dialect API; nopCommerce: IPlugin interface; Orchard Core: ASP.NET Core module manifest) but the architectural invariant is identical: the core defines the contract, plugins implement it, and the core never depends on any specific plugin. This is the strongest cross-domain convergence signal in the evidence base.

### When to Use

- Products requiring third-party extensibility without core modification (nopCommerce: 60K+ stores with marketplace plugins; Orchard Core: tenant-specific feature modules)
- Systems spanning multiple backends or protocols (SQLAlchemy: dialect plugins for every major database; GStreamer: codec and element plugins for media formats)
- Compiler, build-tool, and IDE architectures (LLVM: pass-based optimization pipeline; every major IDE uses plugin architecture)
- Long-lived products (10+ years) where the domain is stable but extensions are unpredictable (nopCommerce: 17 years of evolution)

### When to Avoid

- Greenfield projects with uncertain core requirements -- the core must be stable before investing in extension contracts
- Time-limited competition contexts where the overhead of defining plugin APIs does not pay off (only 2 of 78 KataLog teams used this style)
- Systems where all functionality is known upfront and extension is not a requirement
- When the team lacks experience designing stable API contracts -- poorly designed plugin interfaces create worse coupling than monoliths

---

## 3. Pipeline

### Evidence Summary

- **Combined Weighted Score**: 120 (rank #3)
- **KataLog**: 0 teams (not a KataLog competition style)
- **AOSA**: 5 systems (LLVM, GStreamer, Graphite, NGINX, ZeroMQ)
- **RealWorld**: 1 system (Jellyfin)
- **RefArch**: 0
- **Discovered**: 19 repos (as "Pipe-and-Filter")
- **Production %**: 100%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| AOSA | NGINX | Production system | HTTP request processing pipeline: accept -> read -> parse -> process -> filter -> send; each phase is a handler in a chain; output filters for gzip, chunked encoding, SSI; serves 30%+ of internet traffic |
| AOSA | LLVM | Production system | 3-phase compiler pipeline: frontend (C/C++/Rust parsing) -> IR (optimization passes) -> backend (x86/ARM/WASM code gen); passes are composable and reorderable; foundation of Apple Clang, Rust compiler, Swift compiler |
| AOSA | GStreamer | Production system | Media pipeline: source -> demux -> decode -> filter -> encode -> sink; elements connected via pads with capability negotiation; dynamic pipeline reconfiguration |
| AOSA | Graphite | Production system | Carbon (collection with line/pickle/AMQP receivers) -> Whisper (fixed-size time-series storage) -> Graphite-Web (Django rendering/API); Carbon relay for fan-out |
| AOSA | ZeroMQ | Production system | I/O thread pipeline: socket -> session -> encoder -> engine; zero-copy message passing between stages; batch processing in pipeline for throughput |
| RealWorld | Jellyfin | Production app | Transcoding pipeline: input -> demux -> decode -> filter (scale, subtitle burn) -> encode -> mux -> output; FFmpeg-based with pluggable codec support |
| Discovered | 19 repos | Code-level signal | Data processing pipelines, ETL systems, stream processors; structural signals include stage-based directory layouts and pipeline configuration files |

### Convergence Analysis

Pipeline is the only style with 100% production evidence and 0% competition evidence. All five AOSA systems that exhibit pipeline architecture are among the most successful software projects ever built (NGINX: 30%+ of web traffic; LLVM: foundation of Apple, Google, and ARM toolchains; GStreamer: default Linux media framework; ZeroMQ: financial and telecom messaging). Jellyfin adds modern production confirmation. The 19 Discovered repos reinforce the pattern in data processing contexts (ETL systems, stream processors, data transformation tools).

The complete absence from KataLog is itself a finding: pipeline architecture solves data-transformation and request-processing problems that rarely appear in Kata problem statements (which tend toward business-domain coordination). This suggests the pattern is under-recognized in architecture education despite dominating infrastructure software. AOSA and Discovered sources agree that pipeline excels in data-flow-dominated domains; no source contradicts this.

**Composability as key differentiator**: LLVM's passes can be reordered and composed arbitrarily. GStreamer's elements connect via negotiated pads. NGINX's output filters chain transparently. In every AOSA case, the pipeline's power comes from composable stages with well-defined input/output contracts -- not from the linear topology alone but from the interchangeability of stages within that topology.

### When to Use

- Data transformation chains where each stage has a single responsibility (LLVM: parse -> optimize -> codegen; Graphite: collect -> store -> render)
- Request processing with ordered filter chains (NGINX: accept -> parse -> process -> filter -> respond)
- Media processing with format negotiation (GStreamer: source -> decode -> filter -> encode -> sink; Jellyfin: transcoding pipeline)
- ETL and stream processing systems (19 Discovered repos confirm broad adoption in data engineering)
- Systems where stages must be independently testable, replaceable, or reorderable

### When to Avoid

- Business-domain coordination problems requiring bidirectional communication between components (pipeline is inherently unidirectional)
- Systems where the processing order is not well-defined or changes dynamically per request (though GStreamer demonstrates dynamic pipeline reconfiguration is possible, it adds significant complexity)
- Interactive applications where user input drives non-linear control flow
- Architectures where stages have heavy shared state -- pipeline assumes each stage passes data forward with minimal coupling

---

## 4. Service-Based

### Evidence Summary

- **Combined Weighted Score**: 105 (rank #4)
- **KataLog**: 25 teams, score 43 (36.0% win rate)
- **AOSA**: 2 systems (Graphite, Selenium)
- **RealWorld**: 1 system (Bitwarden)
- **RefArch**: 1 repo (AKS Baseline)
- **Discovered**: 4 repos
- **Production %**: 57%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| AOSA | Graphite | Production system | Carbon (collection), Whisper (time-series storage), Graphite-Web (rendering/API) -- three coarse-grained services with clear boundaries; independently deployable but sharing a common data format |
| AOSA | Selenium | Production system | WebDriver protocol with per-browser adapter drivers; hub-node topology for distributed test execution; coarse service decomposition (hub, node, driver) |
| RealWorld | Bitwarden | Production app | Zero-knowledge vault with service-based decomposition: API, Identity, Admin, Events, Notifications; shared database with service-level access control; SOC2 certified |
| RefArch | AKS Baseline | Reference impl | Microservices + service-based on Kubernetes; AKS cluster with ingress controller, service mesh, and coarse service boundaries |
| KataLog | 25 teams (top shown below) | Competition designs | Dominant style in Sysops Squad (6/7 teams) and Certifiable Inc. (6/7 teams); chosen for budget-constrained and monolith-migration contexts |
| Discovered | 4 repos | Code-level signal | Coarse-grained service boundaries with shared database patterns |

**Top KataLog teams** (25 teams total; top performers shown):

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

### Convergence Analysis

Production and competition evidence converge strongly on service-based architecture as the pragmatic middle ground. Graphite and Selenium (AOSA) demonstrate that coarse-grained service decomposition succeeds in infrastructure software. Bitwarden (RealWorld) confirms it in modern SaaS with SOC2 compliance. KataLog provides the largest competition sample (25 teams), where service-based was the near-unanimous choice for budget-constrained contexts (Sysops Squad: 6/7, Certifiable Inc.: 6/7).

The sources agree that service-based works best when the domain model is not yet fully understood or when operational simplicity is prioritized over independent scalability. Bitwarden's shared database with service-level access control mirrors the KataLog pattern of shared databases with service-level boundaries. The low Discovered count (4 repos) suggests the pattern is harder to detect from code signals alone -- service-based architectures often look like monoliths in code structure while having service-level deployment boundaries.

**KataLog winner pattern**: Top service-based teams distinguished themselves by adding event-driven communication where async was natural (Team Seven, Pragmatic, ZAITects) while keeping the overall deployment and data model simpler than full microservices. Service-based was the dominant choice when budget constraints were explicit: Sysops Squad (6/7 teams), Certifiable Inc. (6/7 teams), and frequently as Phase 1 of an evolutionary approach with microservices as a documented future state.

### When to Use

- Monolith migration where independent deployability is needed without full microservices complexity (Sysops Squad: near-unanimous choice; Graphite: independently scalable but coarse-grained)
- Budget-constrained and non-profit contexts (ClearView, Certifiable Inc. winners chose service-based citing cost)
- AI-integration scenarios where the primary goal is adding AI capabilities to existing platforms (Certifiable Inc.: 6 of 7 teams)
- Organizations with limited DevOps maturity needing fault isolation without distributed systems overhead (Bitwarden: SOC2 with service-based)

### When to Avoid

- Systems requiring extreme independent scalability across service boundaries (Graphite eventually required relay fan-out for scale)
- Large teams (10+) that benefit from microservices-level independence for parallel development
- Domains with high throughput requirements where shared database becomes a bottleneck

---

## 5. Microservices

### Evidence Summary

- **Combined Weighted Score**: 76 (rank #5)
- **KataLog**: 39 teams, score 67 (35.9% win rate)
- **AOSA**: 0 systems
- **RealWorld**: 0 systems
- **RefArch**: 5 repos (eShopOnContainers, eShop, serverless-microservices, AKS Baseline, wild-workouts)
- **Discovered**: 26 repos
- **Production %**: 0%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| RefArch | eShopOnContainers | Reference impl | Microsoft canonical microservices sample; Catalog, Basket, Ordering, Identity as independent services; DDD aggregates, CQRS in Ordering, integration events via RabbitMQ/Azure Service Bus; Docker Compose and Kubernetes deployment; ~15K GitHub stars |
| RefArch | eShop | Reference impl | Simplified eShopOnContainers on .NET 8 Aspire; same service boundaries with reduced operational complexity; modern .NET hosting model |
| RefArch | serverless-microservices-azure | Reference impl | Serverless microservices on Azure Functions; Event Grid for inter-service communication; Durable Functions for orchestration; ride-sharing domain with Trips, Drivers, Passengers services |
| RefArch | AKS Baseline | Reference impl | Production-grade AKS cluster; service mesh (Linkerd/Istio), NGINX ingress, Azure Monitor, Key Vault integration; microservices deployment target with security and observability baseline |
| RefArch | wild-workouts-go | Reference impl | Microservices in Go; DDD bounded contexts (Training, User); Hexagonal ports/adapters per service; CQRS command/query handlers; gRPC and HTTP adapters |
| KataLog | 39 teams (top shown below) | Competition designs | Second-most popular style; winners paired with DDD and event-driven; runner-ups adopted as default without justification |
| Discovered | 26 repos | Code-level signal | Docker Compose multi-service layouts, API gateway configs, per-service databases; pruned from higher count by removing tutorials and sample apps |

**Top KataLog teams** (39 teams total; top performers shown):

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

### Convergence Analysis

Microservices presents the sharpest gap between competition popularity and production evidence in the entire dataset. It is the second-most popular KataLog style (39 teams, 67 pts) and has the most reference implementations (5 repos), yet zero production systems across AOSA and RealWorld use it as a primary style. The 26 Discovered repos confirm it is widely built in open-source but not yet validated at production scale within this evidence base.

RefArch and KataLog sources agree that microservices works best when paired with DDD, event-driven communication, and explicit bounded contexts. The strongest KataLog performers (MonArch, PegasuZ, Rapid Response) all proposed evolutionary paths starting simpler and decomposing into microservices -- not microservices from day one. The absence of AOSA production evidence is notable: AOSA systems that could be called microservices (Graphite, Selenium) are classified as service-based because their decomposition is coarser than the microservices ideal. This suggests the gap between microservices-as-designed and microservices-as-deployed is a real architectural phenomenon.

**Over-engineering signal from KataLog**: In the Sysops Squad challenge, the sole microservices team (Arch Mahal) placed as runner-up while all 6 service-based teams placed higher. In ClearView, the sole pure microservices team (Jazz Executor) placed as runner-up. This consistent underperformance of microservices in budget-constrained and migration contexts is one of the strongest negative signals in the KataLog dataset.

### When to Use

- Systems with well-understood domain boundaries where independent deployment and scaling provide clear value (eShopOnContainers: Catalog, Basket, Ordering as independent services)
- Organizations with mature DevOps capabilities and experience operating distributed systems (AKS Baseline: production-grade cluster configuration)
- When paired with DDD, event storming, or explicit evolutionary paths -- every winning KataLog team justified decomposition with domain analysis
- Large teams needing parallel development independence across service boundaries

### When to Avoid

- Greenfield projects where the domain model is still evolving -- modular monolith or service-based provides a safer starting point (MonArch, PegasuZ both proposed this)
- Small teams who cannot sustain the operational burden (Sysops Squad: 6 of 7 teams chose service-based over microservices)
- Budget-constrained contexts where the infrastructure overhead is prohibitive
- When adopted as a default without justifying the operational complexity -- KataLog runner-up microservices teams consistently scored lower when they declared the style without showing domain decomposition rationale

---

## 6. Modular Monolith

### Evidence Summary

- **Combined Weighted Score**: 40 (rank #6)
- **KataLog**: 6 teams, score 18 (83.3% win rate)
- **AOSA**: 0 explicitly
- **RealWorld**: 1 system (Orchard Core)
- **RefArch**: 1 repo (modular-monolith-with-ddd)
- **Discovered**: 64 repos (52% of catalog -- highest of any style)
- **Production %**: 50%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| RealWorld | Orchard Core | Production app | Multi-tenant CMS built as modular monolith; each feature (themes, widgets, content types, workflows) is an independent ASP.NET Core module; single deployment with module-level boundaries; Lucene-based search, liquid templates, GraphQL API |
| RefArch | modular-monolith-with-ddd | Reference impl | DDD + CQRS + Event-Driven within monolith; module-level bounded contexts (Meetings, Administration, Payments) with integration events between modules; in-process event bus with outbox pattern; strong module isolation enforced by architecture tests |
| KataLog | 6 teams (all shown) | Competition designs | Highest win rate of all styles (83.3%); 5 of 6 teams placed top-3 |
| Discovered | 64 repos | Code-level signal | Well-structured directory layouts with module boundaries; single deployment artifacts; most common pattern in pruned Discovered catalog (52% of all repos) |

**All KataLog teams** (6 teams, 83.3% win rate):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| ArchColider | 1st | Farmacy Food | Most comprehensive cost analysis; won with contrarian modular monolith against microservices field; 16 ADRs |
| MonArch | 1st | Hey Blue! | Modular monolith initial deployment with hexagonal internals; extraction along bounded-context seams |
| PegasuZ | 1st | Spotlight Platform | Modular monolith as MVP; "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" |
| Rapid Response | 2nd | Wildlife Watcher | 6 microservices designed but deployed as modular monolith initially; only Camera Feed independent |
| Wonderous Toys | 3rd | Wildlife Watcher | Microkernel + modular monolith + event-driven for species identification extensions |
| Arch8s | Runner-up | Spotlight Platform | AWS ECS + Aurora PostgreSQL + Lambda for heavy tasks; 17 ADRs |

### Convergence Analysis

Modular monolith shows a striking pattern: the highest KataLog win rate (83.3%) paired with the highest Discovered count (64 repos, 52% of catalog), yet limited curated production evidence (Orchard Core only). The Discovered dominance -- revealed after pruning removed tutorials and SDKs -- shows that well-structured open-source applications overwhelmingly exhibit modular monolith patterns. Orchard Core's multi-tenant CMS confirms the pattern works at production scale with real users.

KataLog and RefArch sources agree that modular monolith excels as a starting point with documented extraction paths. Every KataLog winner using this style explicitly documented how modules could be extracted into services later. The modular-monolith-with-ddd reference implementation demonstrates that DDD, CQRS, and event-driven patterns work within a monolith deployment, challenging the assumption that these patterns require distributed services.

**Small sample, strong signal**: With only 6 KataLog teams, the 83.3% win rate is statistically limited but directionally compelling. ArchColider (1st, Farmacy Food) won with a contrarian modular monolith choice against a field of microservices teams, producing the most comprehensive cost analysis. PegasuZ (1st, Spotlight Platform) asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" This pragmatic reasoning characterized all modular monolith winners.

### When to Use

- Greenfield startup/non-profit projects where the domain model is not yet validated (ArchColider: won against microservices field with cost analysis)
- Small teams (2-5 members) who cannot sustain microservices operational overhead
- When time-to-market and cost are primary drivers (PegasuZ: MVP-first reasoning)
- When paired with hexagonal architecture or DDD bounded contexts, providing documented extraction points (MonArch: hexagonal internals; modular-monolith-with-ddd: module-level bounded contexts)

### When to Avoid

- Systems that have proven domain boundaries and need independent deployment and scaling
- Large organizations where monolith deployment creates deployment contention across teams
- Systems with fundamentally different scaling characteristics across components (Wildlife Watcher: Camera Feed Engine needed independent scaling, forcing Rapid Response to extract it)

---

## 7. CQRS/Event Sourcing

### Evidence Summary

- **Combined Weighted Score**: 33 (rank #7)
- **KataLog**: ~5 teams, score 8
- **AOSA**: 0
- **RealWorld**: 1 system (Squidex)
- **RefArch**: 4 repos (clean-architecture-dotnet, modular-monolith-with-ddd, wild-workouts, eShopOnContainers)
- **Discovered**: 18 repos
- **Production %**: 61%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| RealWorld | Squidex | Production app | CQRS + event sourcing as primary architecture; every content change stored as immutable event; MongoDB event store; full event history enables audit trail, temporal queries, and replay; headless CMS |
| RefArch | eShopOnContainers | Reference impl | CQRS in Ordering service: separate read/write models; MediatR for command/query dispatch; integration events for cross-service eventual consistency |
| RefArch | modular-monolith-with-ddd | Reference impl | CQRS within monolith modules; separate command and query handlers per module; in-process event bus |
| RefArch | wild-workouts-go | Reference impl | CQRS in Go; command handlers for training mutations, query handlers for read models; separate write and read repositories |
| RefArch | clean-architecture-dotnet | Reference impl | CQRS with Hexagonal architecture; MediatR pipeline for commands and queries; clean separation of read/write concerns |
| KataLog | Iconites | 2nd, Road Warrior | Event-driven + space-based + CQRS read/write separation for travel itinerary management |
| KataLog | Street Fighters | Runner-up, Road Warrior | Kubernetes + message broker + CQRS for trip data |
| Discovered | 18 repos | Code-level signal | Command/query separation patterns, event store configurations, projection/read-model builders |

### Convergence Analysis

CQRS/Event Sourcing derives 61% of its score from a single production system (Squidex), making it the pattern most dependent on a single source for production validation. However, four reference implementations (the most of any pattern except Event-Driven) provide substantial code-level confirmation. Squidex demonstrates that full event sourcing works in production for content management -- every mutation is an event, enabling complete audit trails, temporal queries, and state replay.

RefArch sources agree that CQRS is most effective within bounded contexts rather than as a system-wide pattern. eShopOnContainers applies CQRS only in the Ordering service, not across all services. The modular-monolith-with-ddd reference shows CQRS works within a monolith, challenging the assumption that CQRS requires microservices. KataLog evidence is thin (~5 teams) but consistent: teams using CQRS paired it with event-driven communication. The 18 Discovered repos confirm moderate open-source adoption.

**Squidex as canonical production CQRS**: Squidex stores every content mutation as an immutable event in MongoDB. The current state is derived from event replay. This enables temporal queries ("what did this content look like on date X?"), complete audit trails, and event-based integrations with downstream systems. Squidex demonstrates that full event sourcing (not just CQRS read/write separation) is viable in production for content management domains where the event history has intrinsic business value.

### When to Use

- Systems requiring complete audit trails and temporal queries (Squidex: full event history for content management)
- Domains with asymmetric read/write loads where read models can be independently optimized (eShopOnContainers: separate read/write models in Ordering)
- Within specific bounded contexts that benefit from separate read/write models, not as a system-wide mandate (eShopOnContainers uses CQRS only in Ordering, not Catalog or Basket)
- When paired with event sourcing for domains where the event history itself is valuable (content management, financial transactions, compliance-regulated systems)

### When to Avoid

- Simple CRUD domains where the overhead of separate read/write models is not justified
- Teams unfamiliar with eventual consistency -- CQRS introduces eventual consistency between command and query sides that must be explicitly managed
- Systems where a single relational model adequately serves both reads and writes
- As a system-wide pattern applied uniformly -- every reference implementation applies it selectively

---

## 8. Space-Based

### Evidence Summary

- **Combined Weighted Score**: 24 (rank #8)
- **KataLog**: ~2 teams, score 4
- **AOSA**: 1 system (Riak)
- **RealWorld**: 0
- **RefArch**: 0
- **Discovered**: 5 repos
- **Production %**: 83%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| AOSA | Riak | Production system | Peer-to-peer distributed key-value store; consistent hashing for data partitioning; tunable consistency (read/write quorum); no single point of failure; rack-aware replica placement |
| KataLog | Iconites | 2nd, Road Warrior | Space-based + event-driven + microservices; Cosmos DB + Redis for in-memory data grid; designed for Road Warrior's 15M user peak-load scenario |
| KataLog | LowCode | 3rd (tied), MonitorMe | Distributed system with event bus and distributed appliance nodes; space-based topology for medical device data |
| Discovered | 5 repos | Code-level signal | In-memory data grid patterns, distributed caching configurations |

### Convergence Analysis

Space-based architecture has the thinnest evidence base among styles with production validation. Riak (AOSA) provides strong production evidence for the distributed data grid pattern -- peer-to-peer topology with tunable consistency serves as the canonical space-based implementation. However, Riak is a database infrastructure component, not an application architecture, which limits direct applicability.

KataLog evidence is sparse (2 teams) but targeted: both teams chose space-based for high-concurrency, peak-load scenarios (Road Warrior's 15M users, MonitorMe's distributed sensor nodes). The 5 Discovered repos confirm limited but present open-source adoption. The gap between Riak's infrastructure-level space-based architecture and the application-level space-based architecture described by Richards and Ford (in-memory data grids with processing units) remains unbridged in this evidence base.

**Riak's architectural lessons**: Riak demonstrates the core space-based principles at infrastructure scale: no master node (peer-to-peer), data distributed via consistent hashing across a ring, tunable N/R/W values allowing per-request consistency-availability trade-offs, and hinted handoff for partition tolerance. These same principles (replicated data, no central coordinator, tunable consistency) define the application-level space-based architecture pattern, making Riak both an implementation of and infrastructure for space-based systems.

### When to Use

- Systems with extreme concurrency requirements where traditional database-backed architectures create bottlenecks (Riak: peer-to-peer with no single point of failure; consistent hashing eliminates coordination overhead)
- Variable and unpredictable peak loads where elastic scaling of processing units is needed (Iconites: 15M user peak for Road Warrior; scale-out by adding nodes to the hash ring)
- Applications where in-memory data grids can eliminate database round-trips for hot data paths (session state, real-time pricing, leaderboards)
- Distributed sensor or IoT networks with local processing requirements (LowCode: distributed appliance nodes for MonitorMe medical devices)

### When to Avoid

- Systems where data consistency requirements are strict -- space-based architectures trade consistency for availability (Riak's tunable consistency still involves eventual consistency trade-offs; AP side of CAP theorem)
- Applications with small, predictable loads where the infrastructure complexity of data grids is not justified -- the operational burden of managing distributed caching, replication, and partition recovery is substantial
- Teams without experience operating distributed data infrastructure -- space-based failure modes (split-brain, replication lag, rebalancing storms) require deep operational expertise
- Domains where the data model does not partition well across processing units (highly relational data with cross-partition joins)

---

## 9. Layered Architecture

### Evidence Summary

- **Combined Weighted Score**: 20 (rank #9)
- **KataLog**: 0 (not a KataLog competition style)
- **AOSA**: 1 system (SQLAlchemy)
- **RealWorld**: 1 system (nopCommerce)
- **RefArch**: 0
- **Discovered**: 29 repos
- **Production %**: 100%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| AOSA | SQLAlchemy | Production system | Two distinct layers: Core (SQL expression language, schema definition, connection pooling) and ORM (unit of work, identity map, relationship loading); strict layer separation with Core usable independently |
| RealWorld | nopCommerce | Production app | Four-layer architecture: Web (Razor views, API controllers), Services (business logic), Data (Entity Framework, repositories), Core (domain entities, DTOs); 60K+ live stores; 17 years of evolution |
| Discovered | 29 repos | Code-level signal | Directory structures with presentation/business/data layers; dependency flow enforcement; layer-per-folder project organization |

### Convergence Analysis

Layered architecture has 100% production evidence from just two systems, but those systems represent the pattern at different scales and domains. SQLAlchemy's two-layer design (Core + ORM) demonstrates that strict layer separation enables independent layer usage -- Core can be used without ORM. nopCommerce's four-layer design proves the pattern sustains a 17-year-old e-commerce platform serving 60K+ live stores.

The 29 Discovered repos (third-highest count) confirm layered architecture remains one of the most common structural patterns in open-source applications. The absence from KataLog is expected: layered architecture is rarely proposed in competition contexts because it is seen as a default rather than an architectural choice. However, nopCommerce's longevity and SQLAlchemy's ubiquity suggest the pattern's simplicity is a feature, not a limitation -- particularly for domains where the primary concern is separation of concerns rather than distributed deployment.

**Longevity as evidence**: nopCommerce's 17-year evolution through four layers (Web, Services, Data, Core) is among the strongest evidence for any architecture style in the dataset. The architecture has survived the transition from ASP.NET Web Forms to MVC to Razor Pages to modern ASP.NET Core while maintaining the same four-layer structure. This suggests layered architecture's primary value is durability across technology generations, not performance or scalability.

### When to Use

- Applications where separation of concerns (presentation, business logic, data access) is the primary architectural driver (nopCommerce: 4 layers serving 60K+ stores)
- Library and framework design where layers must be independently usable (SQLAlchemy: Core layer usable without ORM)
- Long-lived applications where team turnover is high and structural simplicity aids onboarding (nopCommerce: 17 years of evolution)
- Domains where distributed deployment is not required and a single deployment unit is acceptable

### When to Avoid

- Systems requiring independent deployment or scaling of components -- layered architecture assumes a single deployment unit
- High-performance systems where layer-to-layer overhead (even in-process) creates latency (pipeline or event-driven may be more appropriate)
- Domains with complex cross-cutting concerns that do not map cleanly to horizontal layers
- When layer violations are likely due to team discipline issues -- without enforcement, layers degrade into a big ball of mud

---

## 10. Domain-Driven Design

### Evidence Summary

- **Combined Weighted Score**: 16 (rank #10)
- **KataLog**: ~10 teams, score 11
- **AOSA**: 0
- **RealWorld**: 0
- **RefArch**: 3 repos (eShopOnContainers, modular-monolith-with-ddd, wild-workouts)
- **Discovered**: 27 repos
- **Production %**: 0%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| RefArch | eShopOnContainers | Reference impl | Bounded contexts as microservice boundaries (Catalog, Basket, Ordering); aggregates with invariant enforcement; domain events for intra-context side effects; value objects (Address, Money); anti-corruption layers and context mapping between services |
| RefArch | modular-monolith-with-ddd | Reference impl | DDD tactical patterns within monolith modules (Meetings: aggregate root with rich domain model, Administration: simpler CRUD); each module owns its domain model; integration events for cross-module communication |
| RefArch | wild-workouts-go | Reference impl | DDD in Go idiom; Training bounded context with aggregate roots; domain events; repository pattern with interface-based ports; demonstrates DDD outside the Java/C# ecosystem |
| KataLog | ArchColider | 1st, Farmacy Food | Event sourcing + DDD bounded contexts in modular monolith; domain model as primary decomposition driver; 16 ADRs |
| KataLog | IPT | 2nd, Hey Blue! | DDD context mapping + event-driven microservices; Azure Container Apps with Event Hub; 8 ADRs |
| KataLog | Shokunin | Runner-up, Spotlight Platform | DDD + federated GraphQL; ElasticSearch + Redis for internal event messaging; 6 ADRs |
| KataLog | Miyagi's Little Forests | 2nd, Farmacy Food | DDD context maps to microservice boundaries with element catalogs; hexagonal internal structure; 6 ADRs |
| Discovered | 27 repos | Code-level signal | Aggregate root patterns, bounded context directory structures, domain event implementations; second-highest Discovered count among patterns without production evidence |

### Convergence Analysis

DDD has the widest gap between code presence and production adoption in the evidence base. 27 Discovered repos (highest among zero-production-evidence styles) and three reference implementations confirm it is widely implemented in code, but no AOSA or RealWorld system uses DDD as a primary classifiable style. This likely reflects that DDD is a design methodology applied within other styles rather than a standalone architecture -- eShopOnContainers is classified as "microservices" and modular-monolith-with-ddd as "modular monolith," with DDD as a secondary classification.

RefArch and KataLog sources agree that DDD provides the strongest decomposition rationale. The most successful KataLog microservices teams (MonArch, IPT, ArchColider) used DDD context mapping to justify service boundaries. The modular-monolith-with-ddd reference demonstrates that DDD bounded contexts work within a monolith -- they do not require microservices.

**Methodology vs. architecture**: DDD's zero production evidence likely reflects a classification artifact. Real production systems using DDD are classified by their deployment style (microservices, modular monolith) rather than their design methodology. This makes DDD a permanent secondary classifier in this evidence framework. The 27 Discovered repos -- highest among zero-production styles -- confirm that DDD tactical patterns (aggregates, value objects, domain events) are widely implemented in code even when the primary style classification captures the deployment architecture.

### When to Use

- Complex business domains where the domain model drives architectural decomposition (eShopOnContainers: bounded contexts as microservice boundaries)
- Systems requiring explicit boundaries between subdomains with anti-corruption layers (eShopOnContainers: anti-corruption layers between Catalog, Basket, Ordering)
- As a decomposition methodology within any primary style -- modular monolith, microservices, or service-based (modular-monolith-with-ddd: DDD within monolith; eShopOnContainers: DDD within microservices)
- When the team includes domain experts who can participate in ubiquitous language and context mapping

### When to Avoid

- Simple CRUD applications where the overhead of aggregates, value objects, and bounded contexts is not justified
- Domains where the business logic is thin and the complexity is in infrastructure or integration rather than domain modeling
- Teams without access to domain experts -- DDD requires continuous collaboration between developers and domain experts
- As a standalone architecture without a primary hosting style -- DDD is a methodology, not a deployment architecture

---

## 11. Hexagonal/Clean Architecture

### Evidence Summary

- **Combined Weighted Score**: 16 (rank #11)
- **KataLog**: ~6 teams, score 10
- **AOSA**: 0
- **RealWorld**: 0
- **RefArch**: 3 repos (buckpal, clean-architecture-dotnet, wild-workouts)
- **Discovered**: 16 repos
- **Production %**: 0%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| RefArch | buckpal | Reference impl | Hexagonal purity as primary goal; banking sample (Send Money use case); incoming ports (use cases), outgoing ports (persistence, external); adapters (web controller, JPA persistence, external API); dependency rule enforced via compile-time checks; Tom Hombergs' companion to "Get Your Hands Dirty on Clean Architecture" |
| RefArch | clean-architecture-dotnet | Reference impl | Hexagonal + CQRS in C#; four projects (Domain, Application, Infrastructure, Web); MediatR pipeline behaviors for cross-cutting concerns; ports as Application-layer interfaces; FluentValidation for command validation |
| RefArch | wild-workouts-go | Reference impl | Hexagonal in Go; port interfaces (TrainingRepository, UserService); adapters for HTTP, gRPC, and in-memory test implementations; DDD aggregate roots within hexagonal boundary; demonstrates idiomatic Go approach to ports-and-adapters |
| KataLog | MonArch | 1st, Hey Blue! | Hexagonal internals within modular monolith; ports and adapters ensuring each module can be extracted without rewriting business logic; 7 ADRs |
| KataLog | Miyagi's Little Forests | 2nd, Farmacy Food | Hexagonal + event-driven microservices; AWS EKS with hexagonal internal structure per service; element catalog per service; 6 ADRs |
| KataLog | Architects++ | 3rd, Farmacy Family | Hexagonal + service-based + batch processing; AWS Batch with hexagonal internal structure; 15 ADRs |
| Discovered | 16 repos | Code-level signal | Port/adapter directory structures, dependency inversion patterns, clean architecture layer organization; languages include Java, C#, Go, TypeScript, Kotlin |

### Convergence Analysis

Hexagonal/Clean architecture shares DDD's characteristic of zero production evidence despite active adoption in reference implementations and competition designs. Three reference implementations (buckpal, clean-architecture-dotnet, wild-workouts) provide high-quality code examples, each emphasizing different aspects: buckpal focuses on hexagonal purity, clean-architecture-dotnet combines hexagonal with CQRS, and wild-workouts demonstrates hexagonal in Go.

KataLog and RefArch sources agree that hexagonal architecture excels as an internal structure within other styles. MonArch (1st, Hey Blue!) used hexagonal internals within a modular monolith; Miyagi's Little Forests (2nd, Farmacy Food) used it within microservices. This pattern -- hexagonal as internal structure, not primary architecture -- is consistent across all sources. The 16 Discovered repos confirm moderate adoption in open-source, typically as directory-level clean architecture organization.

**Three reference implementations, three languages, one pattern**: buckpal (Java), clean-architecture-dotnet (C#), and wild-workouts-go (Go) implement hexagonal architecture in different languages and domains but converge on identical structural principles: domain logic at the center with no outward dependencies, port interfaces defined in the application layer, and adapters at the boundary handling infrastructure concerns. This cross-language consistency is stronger evidence for the pattern's generality than any single implementation.

### When to Use

- As internal structure within services or modules to ensure business logic independence from infrastructure (MonArch: hexagonal within modular monolith modules; Miyagi's Forests: hexagonal within microservices)
- Systems where infrastructure components (databases, message brokers, external APIs) are expected to change (buckpal: adapter swapping without domain changes)
- When testability of business logic in isolation is a hard requirement (all three RefArch implementations emphasize in-memory adapter testing)
- As a structural discipline that makes future extraction or migration safer (MonArch: hexagonal internals ensured extraction-readiness)

### When to Avoid

- Simple applications where the overhead of port/adapter indirection adds complexity without benefit
- Teams unfamiliar with dependency inversion and port/adapter patterns -- incorrect implementation creates more coupling, not less
- As a primary architecture style for system-level decomposition -- hexagonal is an internal structure pattern, not a deployment architecture
- CRUD-dominated applications where the domain logic is thin and the port/adapter ceremony provides no meaningful isolation

---

## 12. Serverless

### Evidence Summary

- **Combined Weighted Score**: 14 (rank #12)
- **KataLog**: 8 teams, score 12 (25.0% win rate)
- **AOSA**: 0
- **RealWorld**: 0
- **RefArch**: 1 repo (serverless-microservices-azure)
- **Discovered**: 6 repos
- **Production %**: 0%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| RefArch | serverless-microservices-azure | Reference impl | Azure Functions + Event Grid + Event Hubs; ride-sharing domain with serverless microservices; Durable Functions for orchestration; API Management for gateway |
| KataLog | 8 teams (top shown below) | Competition designs | Strongest in cost-sensitive contexts; best when combined with other patterns |
| Discovered | 6 repos | Code-level signal | Function-as-a-service configurations, event trigger definitions, serverless framework configs |

**Top KataLog teams** (8 teams total; top performers shown):

| Team | Placement | Challenge | Key Detail |
|------|-----------|-----------|------------|
| MonArch | 1st | Hey Blue! | GCP Cloud Run (serverless containers) + Pub/Sub; serverless as deployment model within broader architecture |
| TheGlobalVariables | 3rd | Spotlight Platform | AWS Lambda + DynamoDB; calculated per-user cost at $0.002/month with lock-in cost formula |
| It Depends | Runner-up | Hey Blue! | Serverless + event sourcing; burst-pattern economics (daytime activity, near-zero overnight) |
| Jaikaturi | Runner-up | Farmacy Food | GCP Firebase + Cloud Functions; argued serverless eliminated VM maintenance overhead |
| Los Ingenials | Runner-up | Hey Blue! | AWS EKS + Lambda hybrid; microservices with serverless for specific functions |
| Berlin Bears | Runner-up | Farmacy Family | AWS Lambda + Step Functions + DynamoDB; fully serverless stack |

### Convergence Analysis

Serverless has the second-sharpest gap between competition popularity and production evidence (after Microservices). Eight KataLog teams and one reference implementation, but zero production systems across AOSA and RealWorld. The 6 Discovered repos confirm limited open-source adoption.

KataLog evidence consistently shows serverless performs best as a component within broader architectures, not as a standalone style. MonArch (1st) used serverless containers within a modular monolith. TheGlobalVariables (3rd) achieved cost optimization but placed lower than non-serverless teams. The serverless-microservices-azure reference implementation pairs serverless with microservices and event-driven patterns. No source provides evidence of serverless as a successful standalone production architecture.

**Cost-optimization as primary driver**: Every KataLog team that chose serverless cited cost as the primary rationale. TheGlobalVariables calculated $0.002/user/month. It Depends argued Hey Blue!'s burst pattern (daytime activity, near-zero overnight) mapped to scale-to-zero economics. Jaikaturi argued serverless eliminated VM maintenance overhead. This positions serverless as an economic architecture choice rather than a structural one -- chosen for billing model, not for system organization.

### When to Use

- Non-profit and ultra-cost-sensitive contexts where pay-per-request pricing aligns with budget constraints (TheGlobalVariables: $0.002/user/month)
- Systems with highly intermittent or bursty workloads (It Depends: daytime-only pattern for Hey Blue!)
- As a deployment model for specific components within a broader architecture (MonArch: serverless containers; Los Ingenials: Lambda for specific functions)
- MVP/prototype contexts where eliminating infrastructure management accelerates delivery

### When to Avoid

- Systems requiring consistent low-latency responses (cold start penalties)
- Workloads with sustained high throughput (MonitorMe's continuous sensor streams)
- As a standalone primary architecture -- all evidence shows serverless succeeds as a component, not a system-level style
- When vendor lock-in is a significant concern and the team has not evaluated multi-cloud portability

---

## 13. Multi-Agent

### Evidence Summary

- **Combined Weighted Score**: 8 (rank #13)
- **KataLog**: ~3 teams (AI Winter 2024), score 8
- **AOSA**: 0
- **RealWorld**: 0
- **RefArch**: 0
- **Discovered**: 5 repos
- **Production %**: 0%

### Cross-Source Evidence Table

| Source | Entry | Evidence Type | Key Detail |
|--------|-------|---------------|------------|
| KataLog | ConnectedAI | 1st, ShopWise AI Assistant | Multi-agent supervisor hierarchy with LangGraph; dual-LLM cost optimization (Claude for reasoning, Gemini for routing); quantitative evaluation with Ragas + LangFuse |
| KataLog | Breakwater | 2nd, ShopWise AI Assistant | Multi-agent workflow-orchestrated with n8n; OpenAI + PostgreSQL; workflow engine as agent coordinator |
| KataLog | Usfive | Runner-up, Certifiable Inc. | Multi-agent scoring with multiple LLMs; confidence-based escalation between agents |
| Discovered | 5 repos | Code-level signal | Agent orchestration patterns, multi-model configurations, LLM chain definitions |

### Convergence Analysis

Multi-agent is the newest and least-evidenced style, appearing exclusively in the AI-focused Kata challenges (Winter 2024, Winter 2025). With zero production systems, zero reference implementations, and only 5 Discovered repos, the evidence base is the thinnest of all 13 styles. All evidence comes from competition designs and nascent open-source projects.

However, within its limited evidence, a consistent pattern emerges: successful multi-agent teams (ConnectedAI 1st, Breakwater 2nd) constrained agent autonomy through supervisor hierarchies, workflow orchestration, and confidence-based escalation. ConnectedAI was the only ShopWise team with a formal evaluation framework (Ragas + LangFuse), which separated 1st place from all others. This suggests that multi-agent architecture requires the same rigor of architectural governance as any distributed system -- perhaps more, given the non-deterministic nature of LLM-based agents.

**Architectural governance as differentiator**: ConnectedAI built a supervisor hierarchy where a routing agent delegated to specialized agents (product search, recommendation, FAQ), each with explicit capability boundaries and fallback paths. Breakwater used n8n workflow orchestration to coordinate agents with deterministic handoff points. Both approaches constrain agent autonomy -- the winning pattern is not autonomous agents but orchestrated agents with defined contracts, mirroring the plugin/microkernel pattern's core-extension relationship in an AI context.

### When to Use

- AI systems where multiple specialized models or agents must collaborate on complex tasks (ConnectedAI: supervisor hierarchy with role-specific agents)
- Domains where confidence-based escalation between AI and human reviewers is required (Usfive: multi-agent scoring with escalation)
- When different AI capabilities (reasoning, routing, extraction, evaluation) are best served by different models or prompting strategies (ConnectedAI: Claude for reasoning, Gemini for routing)
- Systems requiring formal evaluation frameworks for AI output quality

### When to Avoid

- Systems where a single model or prompt chain suffices -- multi-agent adds orchestration complexity that must be justified
- Production systems without established AI observability, guardrails, and evaluation infrastructure
- Teams without experience managing non-deterministic distributed systems -- multi-agent compounds the challenges of both distributed systems and AI uncertainty
- Any context where the pattern lacks production validation -- this is the least-proven style in the entire evidence base

---

## Source Coverage Matrix

Shows which sources provide evidence for each style. Filled cells indicate at least one entry; numbers show entry count.

| Style | KataLog | AOSA | RealWorld | RefArch | Discovered |
|-------|---------|------|-----------|---------|------------|
| Event-Driven | 47 | 3 | 2 | 5 | 63 |
| Plugin/Microkernel | ~4 | 3 | 3 | -- | -- |
| Pipeline | -- | 5 | 1 | -- | 19 |
| Service-Based | 25 | 2 | 1 | 1 | 4 |
| Microservices | 39 | -- | -- | 5 | 26 |
| Modular Monolith | 6 | -- | 1 | 1 | 64 |
| CQRS/Event Sourcing | ~5 | -- | 1 | 4 | 18 |
| Space-Based | ~2 | 1 | -- | -- | 5 |
| Layered | -- | 1 | 1 | -- | 29 |
| DDD | ~10 | -- | -- | 3 | 27 |
| Hexagonal/Clean | ~6 | -- | -- | 3 | 16 |
| Serverless | 8 | -- | -- | 1 | 6 |
| Multi-Agent | ~3 | -- | -- | -- | 5 |

**Observations**:
- Only **Event-Driven** has evidence from all 5 sources.
- **Plugin/Microkernel** covers 3 sources but is invisible to automated discovery.
- **Pipeline** covers 3 sources despite zero competition usage.
- Five styles (**Microservices, DDD, Hexagonal, Serverless, Multi-Agent**) have zero production evidence from AOSA or RealWorld.
- **Modular Monolith** and **DDD** have the largest Discovered counts among styles with limited curated production evidence, suggesting they are widely built but under-documented at the production-narrative level.

---

## Cross-Style Patterns

Several patterns emerge when comparing evidence across all 13 styles:

### Production vs. Competition Divergence

The five styles with the highest production evidence share (Pipeline 100%, Layered 100%, Plugin/Microkernel 97%, Space-Based 83%, CQRS 61%) are fundamentally different from the five styles with zero production evidence (Microservices, DDD, Hexagonal, Serverless, Multi-Agent). Production-proven styles tend to be infrastructure-level patterns (Pipeline, Plugin) or long-established structural patterns (Layered). Zero-production styles tend to be application-level design methodologies (DDD, Hexagonal) or relatively recent trends (Microservices, Serverless, Multi-Agent). This divergence suggests that the software architecture field's educational emphasis on microservices and DDD is not proportional to their production validation in this evidence base.

### Combination Outperforms Purity

Across all sources, combined styles outperform pure styles. Event-Driven + Service-Based won more KataLog challenges than either alone. Hexagonal is used as internal structure within Microservices and Modular Monolith. CQRS appears within DDD-organized services. Plugin architecture hosts Pipeline stages (GStreamer, LLVM). The evidence consistently shows that real systems combine multiple styles, with one as the primary deployment architecture and others as internal structural patterns.

### The Evolutionary Path

KataLog winners frequently proposed evolutionary architectures: Modular Monolith as initial deployment with microservices as documented future state (MonArch, PegasuZ), Service-Based as Phase 1 with microservices as Phase 3 (Pentagram). The modular-monolith-with-ddd reference implementation demonstrates that DDD, CQRS, and Event-Driven patterns work within a monolith -- enabling future extraction without requiring distributed infrastructure from day one. This pattern suggests the most robust architecture decisions are not style choices but evolution strategies.

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
| KataLog | O'Reilly Architecture Kata submissions | Competition designs (never built) | 78 teams |
| AOSA | Architecture of Open Source Applications | Production systems described by creators | 12 projects |
| RealWorld | RealWorldASPNET production apps | Production applications with real users | 5 projects |
| RefArch | Reference implementations | Working code with sample domains | 8 repos |
| Discovered | Discovered open-source repositories | Auto-classified from structural signals | 122 repos |

See [cross-source-reference.md](cross-source-reference.md) for full scoring methodology, evidence weighting rationale, and per-source quality comparison.

---

*Generated: 2026-03-05*
