# Evidence by Quality Attribute

Evidence drawn from 225 entries across 5 sources: 122 Discovered open-source repositories (primary statistical layer), 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 78 KataLog competition submissions. Quality attributes ranked by detection frequency in the Discovered corpus, validated by production systems, and enriched with qualitative reasoning from competition teams. See [cross-source-reference.md](cross-source-reference.md) for scoring methodology.

> **Evidence hierarchy (Discovered-first).** Discovered frequency rankings provide the primary statistical layer (122 repos, automated signal detection with multi-turn LLM validation). AOSA and RealWorld production systems provide depth validation (17 systems with published architectural reasoning). KataLog competition evidence provides qualitative reasoning -- team ADRs, judge commentary, and cost projections that explain *why* architects prioritize certain quality attributes. Reference implementations confirm recommended patterns.

Generated: 2026-03-05

---

## Discovered QA Detection Rankings (PRIMARY)

Rankings by detection frequency in 122 open-source repositories classified through automated filesystem analysis with multi-turn LLM validation.

| Rank | Quality Attribute | Discovered Repos | % of Corpus | Detection Method | Detection Bias Notes |
|------|-------------------|------------------|-------------|------------------|----------------------|
| 1 | Deployability | 108 | 89% | Docker/Compose/K8s/Helm/CI configs | Inflated -- Docker presence near-universal in modern repos |
| 2 | Modularity | 41 | 34% | Project structure, assembly boundaries, DI config | Moderate confidence -- structural signals are reliable |
| 3 | Scalability | 33 | 27% | Message queues, HPA, sharding configs | Moderate confidence -- infrastructure signals detectable |
| 4 | Fault Tolerance | 18 | 15% | Circuit breakers, retry policies, health checks | Moderate confidence -- resilience patterns leave traces |
| 5 | Observability | 4 | 3% | Logging config, OpenTelemetry packages | Underdetected -- implemented via NuGet packages, not structure |
| 6 | Evolvability | 2 | 2% | Plugin architectures | Severely underdetected -- loose coupling invisible in filesystem |
| -- | Performance | 0 | 0% | Not detectable | Invisible -- algorithmic choices, caching, runtime config |
| -- | Security | 0 | 0% | Not detectable | Invisible -- auth middleware, encryption, policies |
| -- | Data Integrity | 0 | 0% | Not detectable | Invisible -- transactions, constraints, validation |
| -- | Testability | 0 | 0% | Not detectable | Invisible -- test patterns, DI conventions |
| -- | Interoperability | 0 | 0% | Not detectable | Invisible -- API adapters, protocol translators |
| -- | Cost/Feasibility | 0 | 0% | Not detectable | Invisible -- operational concern, not code-level |
| -- | Simplicity | 0 | 0% | Not detectable | Invisible -- architectural decision, not filesystem signal |

### Detection Bias Caveat

> **Detection bias:** Discovered statistics are derived from automated filesystem analysis. Styles and QAs that leave strong filesystem signals (Docker --> Deployability, module boundaries --> Modularity) are overrepresented. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this gap -- teams documented these invisible decisions in ADRs and presentations.

**These rankings reflect what is *detectable* in code, not what is *important* to architects.** 7 of 13 quality attributes in this document have zero Discovered detection -- not because they are rare in production, but because they leave no filesystem signature.

The Discovered layer is most reliable for infrastructure-level QAs (Deployability, Modularity, Scalability, Fault Tolerance). It is least reliable for application-level QAs (Performance, Security, Data Integrity, Testability, Interoperability). Cross-source validation corrects for this by combining Discovered breadth with AOSA/RealWorld depth and KataLog qualitative reasoning.

| Detectable (filesystem signals) | Undetectable (code-level concerns) |
|-------------------------------|-------------------------------------|
| Deployability (Docker, K8s, Helm) | Performance (algorithms, caching) |
| Modularity (project structure) | Security (auth middleware, encryption) |
| Scalability (message queues, HPA) | Data Integrity (transactions, constraints) |
| Fault Tolerance (circuit breakers, retries) | Testability (test patterns, DI) |
| Observability (logging config, OTel) | Interoperability (API adapters) |

---

## Cross-Source QA Validation

The same quality attributes viewed across all five evidence sources. Cross-source validation is essential for this document because Discovered detection bias is strongest in the QA domain.

| Quality Attribute | Discovered (122 repos) | AOSA (12 systems) | RealWorld (5 apps) | RefArch (8 repos) | KataLog (78 teams) | Sources Present |
|-------------------|------------------------|--------------------|--------------------|--------------------|--------------------|-----------------|
| Deployability | 108 (89%) | low | 2 | 2 | low | 3/5 |
| Modularity | 41 (34%) | 3 | 1 | 1 | -- | 4/5 |
| Scalability | 33 (27%) | 4 | 1 | 2 | 55 | 5/5 |
| Fault Tolerance | 18 (15%) | 2 | -- | -- | 43 | 3/5 |
| Observability | 4 (3%) | -- | -- | 1 | 11 | 3/5 |
| Evolvability | 2 (2%) | 5 | 4 | 2 | 35 | 5/5 |
| Performance | 0 | 4 | -- | -- | 41 | 2/5 |
| Security | 0 | -- | 1 | 1 | 40 | 3/5 |
| Data Integrity | 0 | 2 | -- | -- | 20 | 2/5 |
| Testability | 0 | -- | -- | 4 | -- | 1/5 |
| Interoperability | 0 | 2 | -- | -- | 15 | 2/5 |
| Cost/Feasibility | 0 | -- | -- | -- | 26 | 1/5 |
| Simplicity | 0 | 2 | -- | 1 | 6 | 3/5 |

**Key pattern:** The quality attributes with the strongest Discovered detection (Deployability, Modularity) have the weakest KataLog representation. Conversely, the quality attributes with the strongest KataLog representation (Scalability, Fault Tolerance, Performance, Security) have weak or zero Discovered detection.

This inversion demonstrates exactly why cross-source validation matters -- no single source captures the full QA landscape.

---

## 1. Deployability

### Statistical Basis

**Detected in 108 of 122 Discovered repos (89%).** The most detected quality attribute by a wide margin. Detection signals: Dockerfile presence, docker-compose.yml for multi-service orchestration, Kubernetes manifests, Helm charts, and CI/CD pipeline definitions (.github/workflows, azure-pipelines.yml). Common across all domains.

> **Detection bias:** The 89% rate is inflated by Docker/Kubernetes signal prevalence. Dockerfile presence is near-universal in modern .NET repos, and a Dockerfile or Helm chart is a strong filesystem signal that automated classification reliably detects. This high rate reflects modern tooling conventions rather than intentional deployability engineering.

### Production Evidence

**RealWorld systems (2):**
- **Bitwarden** -- Supports cloud-hosted (bitwarden.com), self-hosted (Docker Compose or Kubernetes), and air-gapped deployment. Unified codebase with deployment-specific configuration. This deployment flexibility is a core product differentiator -- enterprises choose Bitwarden specifically because they can self-host.
- **nopCommerce** -- Supports deployment to Windows/Linux, Docker containers, and Azure App Service. One-click Azure deployment templates. Web-based installation wizard handles database setup and initial configuration.

**Reference implementations (2):**
- **eShop** -- .NET Aspire-based deployment with built-in observability. Docker Compose for local development, Kubernetes manifests for production.
- **eShopOnContainers** -- Canonical Docker + Kubernetes deployment reference. Helm charts, GitHub Actions CI/CD, and multi-environment configuration.

### Qualitative Evidence: Why This QA Matters

Deployability was rarely cited as a top-3 quality attribute in KataLog competitions. Time-limited design exercises focus on logical architecture over operational concerns. However, winning teams that addressed deployment demonstrated operational maturity: BluzBrothers (1st, MonitorMe) documented specific deployment topology with duplicate instances (ADR-018/020).

The low KataLog citation rate does not indicate deployability is unimportant -- it indicates that competition formats exclude operational concerns from scoring.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | RefArch Evidence | Cross-Source Pattern |
|-------------------|------------------|------------------|---------------------|
| Modular Monolith | 64 | -- | Single deployable unit simplifies pipeline; Docker makes it trivial |
| Event-Driven | 63 | -- | Message infrastructure (RabbitMQ, Kafka) drives compose complexity |
| Microservices | 26 | eShopOnContainers | Per-service containers; independent deployment is a defining trait |

**Cross-Source Convergence:** Deployability is the quality attribute most distorted by detection methodology. The 89% Discovered rate reflects that Dockerfiles are ubiquitous in modern .NET development, not that 89% of projects architecturally prioritize deployability.

The meaningful evidence comes from RealWorld systems where deployment flexibility is a product feature (Bitwarden's self-hosted model) or from RefArch repos where deployment topology is the primary teaching objective (eShopOnContainers). Competition teams rarely cite deployability because architecture katas focus on logical design, not operational concerns.

---

## 2. Modularity

### Statistical Basis

**Detected in 41 of 122 Discovered repos (34%).** Second-most detected quality attribute. Detection signals: separate assemblies/projects per module, explicit dependency injection configuration, internal NuGet package references, and project structure indicating bounded module boundaries. Most common in Developer Tools and E-Commerce domains -- codebases large enough to require explicit modular organization.

### Production Evidence

**AOSA systems (3):**
- **LLVM** -- Three-layer modular design: frontends (language parsing), optimizer passes (reusable across all languages), and backends (target-specific code generation). Each layer has a well-defined IR (Intermediate Representation) boundary. New passes can be added to the optimizer pipeline without modifying frontends or backends.
- **GStreamer** -- Element-based modularity where each processing step (demuxing, decoding, filtering, encoding, output) is an independent element with typed pads. Elements are loaded dynamically from shared libraries. The framework does not need to know about specific media formats.
- **SQLAlchemy** -- Two-layer architecture: Core (SQL expression language, connection pooling, dialect system) and ORM (unit of work, identity map, eager/lazy loading). Either layer can be used independently. Dialect modules encapsulate database-specific SQL differences.

**RealWorld systems (1):**
- **Orchard Core** -- ASP.NET Core modular application framework. Features are implemented as modules that can be enabled/disabled per tenant. Content types composed from reusable content parts. Modules can extend the admin UI, define routes, and register services.

### Qualitative Evidence: Why This QA Matters

Modularity is implicit in competition architectures but rarely stated as a named quality attribute. Winning teams demonstrate modularity through bounded contexts, service boundaries, and module decomposition diagrams. The modular monolith style (3 KataLog teams, 66.7% top-3 rate) is the most direct competition expression of modularity as a priority.

Zero KataLog teams cite modularity directly, yet the strongest competition designs achieve it. Competition teams describe the symptoms (evolvability, maintainability) rather than the structural property (modularity).

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | AOSA Systems | RealWorld Apps | Cross-Source Pattern |
|-------------------|------------------|--------------|----------------|---------------------|
| Modular Monolith | 64 | -- | Orchard Core | Module boundaries without distribution cost |
| Pipeline | 19 | LLVM, GStreamer | -- | Pipeline stages are natural module boundaries |
| Plugin/Microkernel | 0 | LLVM, GStreamer, SQLAlchemy | Orchard Core | Production-dominant pattern for modularity |

**Cross-Source Convergence:** The production evidence strongly favors plugin/microkernel and pipeline architectures for achieving modularity. Both were nearly invisible in KataLog competitions.

LLVM and GStreamer demonstrate that modularity at production scale is achieved through well-defined intermediate representations and typed interfaces between components -- not through service decomposition over a network. The Discovered evidence reinforces this: 64 repos exhibit modular monolith patterns (project-level module boundaries) versus 26 using microservices (network-level module boundaries).

---

## 3. Scalability

### Statistical Basis

**Detected in 33 of 122 Discovered repos (27%).** Third-most detected quality attribute. Detection signals: container orchestration configs (Kubernetes HPA, Docker Swarm), message queue infrastructure (RabbitMQ, Kafka), and database sharding configurations. Most common in E-Commerce, Infrastructure, and Data Processing domains.

### Production Evidence

**AOSA systems (4):**
- **NGINX** -- Event-driven, non-blocking architecture handles 10,000+ concurrent connections per worker process. Master-worker process model scales horizontally across CPU cores. Serves over 30% of all websites globally.
- **HDFS** -- Block-based distributed filesystem designed for petabyte-scale storage. NameNode/DataNode architecture with configurable replication factor. Default 128MB block size optimized for throughput over latency.
- **Riak** -- Dynamo-inspired distributed key-value store. Consistent hashing ring distributes data across nodes with no single point of failure. Designed for linear horizontal scaling.
- **Graphite** -- Carbon daemon with relay architecture for horizontal write scaling. Whisper storage engine with configurable retention policies. Federation model for multi-cluster deployments.

**RealWorld systems (1):**
- **Squidex** -- API-first headless CMS designed for multi-tenant SaaS deployment. MongoDB-backed event store supports horizontal scaling of content operations.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 55 of 78 teams cited scalability (71%). Average placement score: 1.75. Top-3 rate: 32.7%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| The Archangels | 1st | Farmacy Family | Event-Driven |
| ConnectedAI | 1st | ShopWise AI Assistant | Multi-Agent, Event-Driven |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP), Microservices + Event-Driven (Long Term) |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |

**Key insight from MonitorMe:** BluzBrothers (1st) deliberately downplayed scalability (ADR-008) since the system had a fixed 500-patient ceiling. This mature scoping decision was noted as a strength -- scalability is not always the right priority.

**Key insight from Wildlife Watcher:** AnimAI initially rejected scalability (ADR-001) then revised (ADR-017 "Need Scalability to Some Degree"), showing thoughtful recalibration rather than reflexive inclusion.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|---------------------|
| Event-Driven | 63 | 36 (41.7% top-3) | NGINX, Graphite | Strongest cross-source support; async decoupling enables independent scaling |
| Modular Monolith | 64 | 3 (66.7% top-3) | -- | Dominant in Discovered; scales differently than distributed styles |
| Microservices | 26 | 32 (31.2% top-3) | -- | Popular in competition; absent from AOSA production evidence |
| Pipeline | 19 | -- | NGINX, HDFS, Graphite | Invisible in competition; proven at extreme production scale |
| Service-Based | 4 | 17 (23.5% top-3) | Graphite | Moderate competition support; Graphite's relay model validates |

**Cross-Source Convergence:** Production systems (NGINX, HDFS, Riak) achieve scalability through fundamentally different mechanisms than competition designs propose. NGINX scales through event-driven non-blocking I/O within a single process. HDFS scales through data partitioning across commodity hardware.

Competition teams overwhelmingly propose microservices-based horizontal scaling, yet zero AOSA production systems use microservices as a primary style. The gap suggests competition teams over-index on microservices for scalability when simpler patterns (pipeline, event-driven worker pools) are proven at far greater scale.

---

## 4. Fault Tolerance

### Statistical Basis

**Detected in 18 of 122 Discovered repos (15%).** Detection signals: circuit breaker patterns (Polly, Hystrix), retry policies, health check endpoints, and redundant service configurations in Kubernetes manifests. Most common in Infrastructure and E-Commerce domains where service reliability is a hard requirement.

### Production Evidence

**AOSA systems (2):**
- **HDFS** -- Default 3x replication across DataNodes on different racks. Automatic re-replication when nodes fail. NameNode high availability through standby NameNode with shared edit log (JournalNode quorum). Designed for commodity hardware where failures are expected, not exceptional.
- **Riak** -- Dynamo-inspired availability model: hinted handoff for temporary node failures, read repair for consistency recovery, configurable N/R/W values (default N=3, R=2, W=2). Sloppy quorum ensures writes succeed even during partitions. Explicitly prioritizes availability over consistency (AP in CAP).

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 43 of 78 teams cited availability/fault tolerance (55%). Average placement score: 1.79. Top-3 rate: 39.5%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| BluzBrothers | 1st | MonitorMe | Event-Driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP) |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven |

**Key insight from MonitorMe:** LowCode (3rd tied) designed the most explicit graceful degradation model -- 3-node, 2-node, 1-node failure states with documented capability loss at each level. BluzBrothers (1st) addressed availability at the deployment level (duplicate instances, ADR-018/020) rather than letting it drive architecture style selection.

**Most demanding challenges:** Road Warrior (8 teams, 99.99% SLA requirement), MonitorMe (7 teams, medical monitoring), Sysops Squad (7 teams, ticketing system).

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|---------------------|
| Event-Driven | 63 | 29 (41.4% top-3) | -- | Async decoupling provides natural fault isolation |
| Microservices | 26 | 23 (34.8% top-3) | -- | Service isolation limits blast radius; no production HA evidence |
| Pipeline | 19 | -- | HDFS | HDFS replication pipeline: data written to 3 nodes in sequence |
| Service-Based | 4 | 14 (28.6% top-3) | -- | Coarser granularity trades some isolation for simplicity |
| Space-Based | 5 | -- | -- | Replicated processing units; Riak validates the underlying model |

**Cross-Source Convergence:** AOSA production evidence reveals a crucial distinction. HDFS and Riak achieve availability through data replication and consensus protocols at the storage layer, not through microservices decomposition at the application layer. Competition teams typically propose availability through service redundancy (multiple instances behind load balancers). Both approaches are valid but operate at different levels of the stack.

The pattern that consistently predicts placement in KataLog is explicit graceful degradation modeling -- documenting what capabilities degrade at each failure level -- rather than claiming generic "high availability."

---

## 5. Observability

### Statistical Basis

**Detected in 4 of 122 Discovered repos (3%).** Detection signals: logging configuration files and OpenTelemetry package references.

> **Detection bias:** The low detection rate reflects that observability is implemented through NuGet packages and configuration (Serilog, OpenTelemetry SDK) rather than distinctive filesystem structures. Most modern repos implement observability, but the signals are package-level rather than structural.

### Production Evidence

No AOSA or RealWorld systems cite observability as a primary quality attribute. This reflects the publication era of AOSA systems (2004-2012), before modern observability platforms (Prometheus, Grafana, OpenTelemetry) became standard infrastructure.

**Reference implementations (1):**
- **eShop** -- .NET Aspire-based implementation with built-in OpenTelemetry integration, structured logging, distributed tracing, and health check dashboards.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 11 of 78 teams cited observability (14%). Average placement score: 2.0. Top-3 rate: 45.5%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| ZAITects | 1st | Certifiable Inc. | Service-Based, Event-Driven |
| ArchElekt | 2nd | Sysops Squad | Service-Based |
| IPT | 2nd | Hey Blue! | Microservices, Event-Driven |
| Ctrl+Alt+Elite | 3rd | ClearView | Event-Driven, Microservices (supporting) |

**AI-specific observability:** ConnectedAI (1st, ShopWise) was the only team with LLM-specific observability (LangFuse) for AI system tracing. ZAITects (1st, Certifiable Inc.) used Langwatch for LLM observability. Observability appeared as a differentiator primarily in AI-focused katas where LLM behavior monitoring was a production requirement.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | RefArch Evidence | Cross-Source Pattern |
|-------------------|------------------|---------------|------------------|---------------------|
| Event-Driven | 63 | 8 (37.5% top-3) | eShop | Async flows require distributed tracing |
| Service-Based | 4 | 4 (50.0% top-3) | -- | Moderate service count makes tracing manageable |
| Microservices | 26 | 6 (33.3% top-3) | eShopOnContainers | Many services demand observability; also make it harder |

**Cross-Source Convergence:** Observability is the quality attribute most likely to grow in cross-source validation as the dataset expands. Its current 3-source presence understates its production importance.

Modern systems universally implement observability, but the AOSA systems predate the observability movement, and RealWorld applications treat it as operational infrastructure rather than an architectural driver. The KataLog evidence suggests observability is becoming a first-class architectural concern specifically in AI-integrated systems where LLM behavior monitoring requires purpose-built tooling.

---

## 6. Extensibility/Evolvability

### Statistical Basis

**Detected in 2 of 122 Discovered repos (2%).** The 2% rate dramatically understates the actual prevalence of evolvability-aware design in the corpus. Plugin architectures are identifiable from filesystem signals, but general evolvability (loose coupling, well-defined interfaces, modular boundaries designed for change) requires deeper code analysis.

> **Detection bias:** Evolvability is one of the most important quality attributes in production systems (5 AOSA systems, 4 RealWorld apps) yet one of the least detectable through automated analysis. This is the clearest example of where KataLog qualitative evidence is essential to fill the detection gap.

### Production Evidence

**AOSA systems (5):**
- **LLVM** -- Three-phase compiler design (frontend/optimizer/backend) where each phase is independently extensible. New languages added as frontends, new targets as backends. Over 30 language frontends built by the community.
- **GStreamer** -- Plugin-based multimedia framework. Over 250 plugins in the standard distribution. Pipeline elements can be composed at runtime with type-safe pad negotiation.
- **SQLAlchemy** -- Layered ORM with Core (SQL expression language) and ORM layers independently usable. Dialect system supports arbitrary database backends. Event system enables cross-cutting behavior injection.
- **Selenium** -- WebDriver protocol abstracts browser differences. Language bindings generated from a shared specification. New browser support added without core changes.
- **Twisted** -- Protocol-agnostic event loop with pluggable protocol implementations. New protocols (HTTP, SSH, DNS) added as independent modules atop the reactor pattern.

**RealWorld systems (4):**
- **Jellyfin** -- Plugin architecture with NuGet-based distribution. Community plugins for hardware transcoding, authentication providers, metadata agents, and notification services. Fork of Emby specifically to enable extensibility.
- **nopCommerce** -- Plugin system supporting payment methods, shipping providers, tax calculators, and widgets. Over 3,000 plugins in the marketplace. Plugin isolation through separate assemblies.
- **Orchard Core** -- Module system built on ASP.NET Core features. Modules can define content types, provide admin UI, register services, and extend the data model. Supports dynamic module loading.
- **Squidex** -- API-first design makes the entire CMS extensible through its REST/GraphQL APIs. Rule system enables event-driven integrations. Custom editors loaded as iframes.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 35 of 78 teams cited evolvability/extensibility (45%). Average placement score: 1.89. Top-3 rate: 42.9%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |
| Team Seven | 1st | Sysops Squad | Service-Based, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP), Microservices + Event-Driven (Long Term) |

**Key insight:** Profitero Data Alchemists (1st, Road Warrior) chose evolvability over elasticity as their third characteristic, reasoning that startup adaptability was paramount. Wonderous Toys (3rd, Wildlife Watcher) used microkernel for integration plugins. Software Architecture Guild (3rd, Certifiable Inc.) used microkernel to run six parallel AI solutions.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | RealWorld Apps | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|----------------|---------------------|
| Event-Driven | 63 | 23 (43.5% top-3) | Twisted | Squidex | Event-based decoupling enables independent evolution |
| Modular Monolith | 64 | 2 (100% top-3) | -- | Orchard Core | Module boundaries enable evolution without distribution cost |
| Plugin/Microkernel | 0 | 2 (100% top-3) | LLVM, GStreamer, SQLAlchemy | Jellyfin, nopCommerce, Orchard Core | Dominant production pattern for extensibility |
| Pipeline | 19 | -- | LLVM, GStreamer | Jellyfin | Phase-based design inherently extensible at each stage |
| Microservices | 26 | 20 (45.0% top-3) | -- | -- | Popular in competition; no production extensibility evidence |

**Cross-Source Convergence:** Production evidence overwhelmingly favors plugin/microkernel architectures for extensibility. 6 production systems (LLVM, GStreamer, SQLAlchemy, Jellyfin, nopCommerce, Orchard Core) use plugin architectures. Zero use microservices for extensibility.

This is the largest gap between competition preference and production reality in the entire dataset. Competition teams overwhelmingly propose microservices instead. Plugin/Microkernel rose from rank #11 to #2 in the cross-source weighted scoreboard specifically because of this extensibility evidence.

---

## 7. Performance

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Performance lives in algorithmic choices, data structure selection, caching strategies, and runtime configuration -- none of which leave filesystem signatures.

> **Detection bias:** The zero detection rate is a detection limitation, not a prevalence finding. 41 of 78 KataLog teams (53%) cited performance, making it the fourth most-cited quality attribute. 4 AOSA production systems provide deep engineering evidence. This QA relies entirely on production and competition evidence.

### Production Evidence

**AOSA systems (4):**
- **NGINX** -- Event-driven architecture eliminates per-connection thread/process overhead. Single worker process handles thousands of concurrent connections through epoll/kqueue. Shared memory zones for caching, rate limiting, and session storage. Zero-copy sendfile for static content.
- **LLVM** -- Multi-pass optimization pipeline where each pass operates on a well-defined IR. Passes can be independently enabled/disabled for compile-time vs. runtime performance trade-offs. JIT compilation support for runtime code generation (used in Julia, Rust, Swift).
- **ZeroMQ** -- Lock-free queue implementation for inter-thread messaging. Batching of small messages to amortize syscall overhead. Zero-copy message passing through reference counting. Protocol-agnostic transport (inproc, IPC, TCP, multicast) with the same API.
- **Git** -- Content-addressable object store with delta compression for space efficiency. Packfile format with sliding window delta compression. Index file (staging area) as memory-mapped data structure for fast status operations.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 41 of 78 teams cited performance (53%). Average placement score: 1.93. Top-3 rate: 48.8% -- the highest top-3 rate of any quality attribute.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| BluzBrothers | 1st | MonitorMe | Event-Driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| ConnectedAI | 1st | ShopWise AI Assistant | Multi-Agent, Event-Driven |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| Profitero Data Alchemists | 1st | Road Warrior | Event-Driven Architecture |

**Quantitative performance analysis in winners:** BluzBrothers (1st, MonitorMe) provided end-to-end timing proof of 693ms against a 1-second SLA. Street Fighters (Runner-up, Road Warrior) conducted quantitative load analysis (25 requests/second, 1,000 reservation updates/second). Teams that quantified performance with specific calculations placed higher than teams that listed performance without numbers.

**Time-series databases:** InfluxDB was the consensus choice for performance-sensitive vital sign storage in MonitorMe, chosen for high-throughput writes and native temporal querying.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|---------------------|
| Event-Driven | 63 | 30 (53.3% top-3) | NGINX | Non-blocking I/O eliminates thread overhead |
| Pipeline | 19 | -- | NGINX, LLVM, ZeroMQ, Git | All 4 AOSA performance systems use pipeline patterns |
| Modular Monolith | 64 | 3 (100% top-3) | -- | Avoids network hops; in-process calls are faster |
| Microservices | 26 | 22 (40.9% top-3) | -- | Network overhead is a performance cost |

**Cross-Source Convergence:** The AOSA evidence reveals that extreme performance is achieved through low-level engineering decisions (event loops, lock-free data structures, zero-copy I/O, memory-mapped files) rather than architectural style selection. All four AOSA performance systems use pipeline patterns internally, yet zero KataLog teams proposed pipeline as a primary style.

Competition teams address performance through architectural choices (CQRS read models, caching layers, async processing) that operate at a higher abstraction level than the systems-programming techniques proven in production. Both levels matter, but production evidence suggests the pipeline pattern is the most underappreciated performance enabler.

---

## 8. Security

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Authentication middleware, authorization policies, and encryption configurations are code-level concerns invisible to filesystem-based detection.

> **Detection bias:** The zero detection rate reflects detection limitations, not security absence. 40 of 78 KataLog teams (51%) cited security, making it the fourth most-cited quality attribute. Bitwarden provides the deepest security evidence in the entire dataset.

### Production Evidence

**RealWorld systems (1):**
- **Bitwarden** -- Zero-knowledge architecture where the server never has access to unencrypted vault data. Client-side encryption with PBKDF2-SHA256 (600,000+ iterations) or Argon2id. SOC2 Type II, GDPR, CCPA, and HIPAA compliant. Annual third-party security audits. Supports FIDO2/WebAuthn, TOTP, and hardware security keys. Open-source client and server for community audit.

**Reference implementations (1):**
- **AKS Baseline** -- Microsoft's reference for secure Kubernetes deployment. Network policies, pod security standards, managed identity, Azure AD integration, and ingress controller hardening.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 40 of 78 teams cited security (51%). Average placement score: 1.82. Top-3 rate: 37.5%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| The Archangels | 1st | Farmacy Family | Event-Driven |
| Pragmatic | 1st | ClearView | Service-Based, Event-Driven (selective) |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |

**Differentiating approaches:** ArchColider's zero trust from day one (ADR-006), The Mad Katas' zero trust with performance-aware authentication (ADR-011), Archangels' crypto-shredding for GDPR (ADR-005), Wildlife Watchers' internal CA with Mutual TLS for camera authentication. In AI contexts, ZAITects (1st, Certifiable Inc.) performed an OWASP Top 10 security analysis specifically for LLM integration.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | RealWorld Apps | Cross-Source Pattern |
|-------------------|------------------|---------------|----------------|---------------------|
| Event-Driven | 63 | 27 (40.7% top-3) | -- | Async communication reduces direct attack vectors |
| Modular Monolith | 64 | 4 (100% top-3) | -- | Smaller attack surface; centralized security enforcement |
| Microservices | 26 | 21 (23.8% top-3) | -- | More network boundaries increase attack surface |
| Service-Based | 4 | 10 (40.0% top-3) | Bitwarden | Bitwarden validates; fewer network boundaries to secure |

**Cross-Source Convergence:** Bitwarden provides the deepest security evidence in the entire dataset -- zero-knowledge architecture, multiple compliance certifications, and annual audits.

Competition teams cite security broadly but differentiate only when backing it with specific architectural decisions (zero trust, crypto-shredding, mutual TLS). The pattern that predicts placement is security-as-architecture (specific ADRs addressing concrete security decisions) rather than security-as-checklist (listing encryption and authentication as requirements).

---

## 9. Data Integrity/Consistency

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Data integrity is implemented through database constraints, transaction boundaries, and validation logic that leave no distinctive filesystem signature for automated detection.

### Production Evidence

**AOSA systems (2):**
- **Git** -- Content-addressable object store where every object (blob, tree, commit) is identified by its SHA-1 hash. Any corruption is immediately detectable because the content no longer matches its address. Immutable objects -- once written, objects are never modified. Pack files use delta compression but verify checksums on read.
- **HDFS** -- Block-level checksums verified on every read. Automatic checksum repair through block re-replication from uncorrupted replicas. DataNode block scanner runs periodic integrity checks in background. Write pipeline confirms receipt at each DataNode before acknowledging to client.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 20 of 78 teams cited data integrity (26%). Average placement score: 2.2. Top-3 rate: 60.0% -- the highest top-3 rate of any quality attribute, suggesting that teams who recognize data integrity requirements tend to produce stronger designs.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| The Archangels | 1st | Farmacy Family | Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP) |
| Pragmatic | 1st | ClearView | Service-Based, Event-Driven (selective) |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices |
| Iconites | 2nd | Road Warrior | Microservices, Event-Driven |

**Key insight:** Pragmatic (1st, ClearView) deliberately "downplayed" data integrity (ADR-004) to keep architecture simpler, acknowledging the trade-off. This transparency was noted as a strength. Mighty Orbots (2nd, MonitorMe) used an ELT pipeline decision that prioritized data integrity by loading raw data immediately and transforming later.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|---------------------|
| Event-Driven | 63 | 16 (56.2% top-3) | -- | Event sourcing provides immutable audit trail |
| Pipeline | 19 | -- | Git, HDFS | Content-addressable storage and block checksums |
| Service-Based | 4 | 4 (75.0% top-3) | -- | Fewer distributed transactions; easier to maintain consistency |

**Cross-Source Convergence:** Git and HDFS demonstrate fundamentally different approaches to data integrity. Git achieves integrity through content-addressable storage -- corruption is structurally impossible because addresses are derived from content. HDFS achieves integrity through redundancy and verification -- checksums on every read and automatic re-replication.

Competition teams typically address data integrity through consistency patterns (saga, two-phase commit, eventual consistency) that operate at the application layer. These are valid but at a different level than the storage-layer integrity proven in production.

---

## 10. Testability

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Testability is an internal quality attribute implemented through test patterns and dependency injection conventions that leave no distinctive filesystem signature.

> **Detection bias:** The zero rate does not mean testability is absent. Reference implementations exist specifically to demonstrate testable architecture patterns.

### Production Evidence

No AOSA or RealWorld systems cite testability as a primary quality attribute. Production systems optimize for runtime characteristics (performance, scalability, availability); testability is achieved through code organization and dependency management that these sources do not document architecturally.

**Reference implementations (4):**
- **buckpal** -- Hexagonal architecture reference that demonstrates port/adapter isolation for unit testing without infrastructure dependencies. Domain logic testable in complete isolation.
- **clean-architecture-dotnet** -- Uncle Bob's Clean Architecture in .NET. Use cases (application services) testable through dependency inversion. Infrastructure concerns injected at composition root.
- **wild-workouts** -- Go-based clean architecture demonstrating test isolation through interface-driven design. Application and domain layers testable without HTTP or database dependencies.
- **modular-monolith-with-ddd** -- Integration tests per module verify module contracts. Module boundaries enforced at compilation prevent accidental coupling that would compromise testability.

### Qualitative Evidence: Why This QA Matters

KataLog teams rarely cite testability as a quality attribute. Competition time constraints focus designs on runtime characteristics and stakeholder-visible qualities. Testability is an internal quality attribute (affecting developers) rather than an external one (affecting users), which explains its absence from both competition and automated detection sources.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | RefArch Evidence | Cross-Source Pattern |
|-------------------|------------------|------------------|---------------------|
| Hexagonal/Clean Architecture | 16 | buckpal, clean-architecture-dotnet, wild-workouts | Port/adapter separation enables infrastructure-free testing |
| Modular Monolith | 64 | modular-monolith-with-ddd | Module boundaries create natural test boundaries |
| Domain-Driven Design | 27 | modular-monolith-with-ddd | Domain model testable in isolation from infrastructure |

**Cross-Source Convergence:** Testability's RefArch-only presence is itself a finding: reference implementations exist specifically to demonstrate how architectural patterns support testability. Hexagonal/Clean Architecture patterns dominate RefArch evidence precisely because their port/adapter separation makes testing the primary architectural benefit.

In production systems, testability is achieved through the same patterns but is not documented as an architectural driver. It is a consequence of good structure rather than a stated goal.

---

## 11. Interoperability

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Interoperability patterns (API adapters, protocol translators, format converters) are implemented through code that does not leave distinctive filesystem signatures for automated detection.

### Production Evidence

**AOSA systems (2):**
- **Selenium** -- WebDriver protocol provides a standardized API across all major browsers (Chrome, Firefox, Safari, Edge). Language bindings for Java, Python, C#, Ruby, JavaScript, and Kotlin generated from a shared specification. Browser-specific drivers (ChromeDriver, GeckoDriver) encapsulate differences behind the WebDriver interface.
- **SQLAlchemy** -- Dialect system enables the same Python ORM code to run against PostgreSQL, MySQL, SQLite, Oracle, MS SQL Server, and others. Each dialect handles SQL syntax differences, type mapping, and connection semantics. DBAPI abstraction layer supports multiple database drivers per database engine.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 15 of 78 teams cited interoperability (19%). Average placement score: 2.07. Top-3 rate: 60.0%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| The Archangels | 1st | Farmacy Family | Event-Driven |
| Pragmatic | 1st | ClearView | Service-Based, Event-Driven (selective) |
| Iconites | 2nd | Road Warrior | Microservices, Event-Driven |
| Katamarans | 2nd | ClearView | Event-Driven Architecture |
| Sever Crew | 2nd | Farmacy Family | Service-Based, Event-Driven |

**Most demanding challenges:** ClearView (5 teams -- HR system integration), Wildlife Watcher (conservation platform integration), Farmacy Family (health provider integration).

**Key insight:** Pragmatic (1st, ClearView) named interoperability as their top quality attribute, designing adapter-based HR integration with event-driven triggers. CELUS Ceals (1st, Wildlife Watcher) produced detailed comparative analysis of third-party tools, evaluating labeling platforms across deployment model, API availability, and upload mechanisms.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|---------------------|
| Event-Driven | 63 | 12 (75.0% top-3) | -- | Event-based integration decouples system boundaries |
| Service-Based | 4 | 5 (40.0% top-3) | Selenium, SQLAlchemy | Adapter pattern at service boundaries |
| Plugin/Microkernel | 0 | -- | Selenium, SQLAlchemy | Dialect/driver plugins encapsulate integration differences |

**Cross-Source Convergence:** Both AOSA systems (Selenium, SQLAlchemy) achieve interoperability through the same fundamental pattern: a protocol/dialect abstraction that encapsulates external system differences behind a stable internal interface. Competition teams propose the same pattern (adapter-based integration) but at the service level rather than the driver/dialect level.

The cross-source evidence suggests that interoperability is best achieved through plugin/adapter patterns that isolate integration-specific code, regardless of whether the architecture is monolithic or distributed.

---

## 12. Cost/Feasibility

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Cost optimization leaves no filesystem signature. Infrastructure cost is determined by deployment configuration, cloud service selection, and operational practices -- not by code structure. This is the most competition-specific quality attribute in the dataset.

### Production Evidence

No production sources cite cost as a primary architectural quality attribute. Cost is an operational concern managed through infrastructure selection, right-sizing, and FinOps practices rather than through architecture style selection. However, the architecture styles proven in production (pipeline, plugin/microkernel, service-based) are typically less expensive to operate than competition-popular styles (microservices, serverless) due to simpler infrastructure requirements.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 26 of 78 teams cited cost/feasibility (33%). Average placement score: 2.0. Top-3 rate: 50.0%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| MonArch | 1st | Hey Blue! | Microservices, Event-Driven |
| PegasuZ | 1st | Spotlight Platform | Modular Monolith (MVP) |
| Pragmatic | 1st | ClearView | Service-Based, Event-Driven (selective) |
| ZAITects | 1st | Certifiable Inc. | Service-Based, Event-Driven |

**Concrete cost analyses from winners:** ArchColider: three-scenario cost model ($12K-$23K/year). MonArch: $2,780/month GCP breakdown. TheGlobalVariables (3rd, Spotlight Platform): $0.002/user/month. Pragmatic: token estimation with AI expert interview.

**Key insight:** Every 1st-place team in non-profit/startup challenges included some form of cost analysis. The absence of cost analysis in non-profit contexts was consistently noted as a gap by challenge analyses.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | Top-3 Rate | Cross-Source Pattern |
|-------------------|------------------|---------------|-----------|---------------------|
| Modular Monolith | 64 | 5 | 80.0% | Simplest deployment model, lowest infrastructure cost |
| Service-Based | 4 | 6 | 50.0% | Fewer services than microservices, lower operational overhead |
| Serverless | 6 | 3 | 66.7% | Pay-per-invocation model for low-traffic systems |

**Cross-Source Convergence:** Cost/feasibility is the most competition-specific quality attribute. Its absence from production sources does not mean cost is unimportant. Rather, production systems manage cost through operational practices (right-sizing, reserved instances, auto-scaling policies) rather than through architectural style selection.

The KataLog evidence reveals a strong correlation: modular monolith teams cite cost most frequently and achieve the highest placement rate when cost is a factor. This aligns with the Discovered frequency data where Modular Monolith is the most prevalent style (52% of repos).

---

## 13. Simplicity

### Statistical Basis

**Detected in 0 of 122 Discovered repos (0%).** Simplicity is an architectural decision that leaves no filesystem signature. A simple architecture and a complex architecture may have identical directory structures. Detection would require semantic analysis of design decisions, not filesystem scanning.

### Production Evidence

**AOSA systems (2):**
- **Graphite** -- Deliberately simple architecture: Carbon (receive metrics), Whisper (store metrics), Graphite-web (render graphs). No clustering complexity in the core -- scaling handled through Carbon relay for fanout. Whisper storage format is a fixed-size, round-robin database that self-manages retention without garbage collection or compaction. Creator Chris Davis explicitly chose simplicity over features, reasoning that a monitoring system that is itself complex to operate defeats its purpose.
- **ZeroMQ** -- "Socket API that acts like a framework." Eliminates broker complexity by embedding messaging patterns (pub/sub, req/rep, push/pull) directly into the library. No central server, no configuration files, no daemon processes. The simplicity is structural: ZeroMQ is a library, not a service, which eliminates an entire category of operational complexity.

**Reference implementations (1):**
- **buckpal** -- Deliberately minimal hexagonal architecture implementation. Single module, clear package structure (adapter/in, adapter/out, application/port/in, application/port/out, domain). Demonstrates that Clean Architecture does not require complexity -- the simplest implementation is a single deployable with well-organized packages.

### Qualitative Evidence: Why This QA Matters

**KataLog summary:** 6 of 78 teams cited simplicity (8%). Average placement score: 1.83. Top-3 rate: 50.0%.

**Top-performing teams:**

| Team | Placement | Challenge | Architecture Style |
|------|-----------|-----------|-------------------|
| ArchColider | 1st | Farmacy Food | Modular Monolith, Event Sourcing |
| Software Architecture Guild | 3rd | Certifiable Inc. | Microkernel, Service-Based |
| Wonderous Toys | 3rd | Wildlife Watcher | Modular Monolith, Microkernel |
| AnimAI | Runner-up | Wildlife Watcher | Service-Based |
| Equi Hire Architects | Runner-up | ClearView | Service-Based |

**Key insight:** Equihire Architects (Runner-up, ClearView) explicitly chose service-based over microservices and event-driven because "cost and simplicity were the main characteristics which made the difference." Architects++ (3rd, Farmacy Family) adopted a partnership-over-build philosophy, choosing Facebook Groups, Eventbrite, and WordPress over custom development.

### Architecture Styles That Best Support It

| Architecture Style | Discovered Repos | KataLog Teams | AOSA Systems | RefArch Evidence | Cross-Source Pattern |
|-------------------|------------------|---------------|--------------|------------------|---------------------|
| Modular Monolith | 64 | 3 (66.7% top-3) | -- | buckpal | Single deployable unit; minimal operational complexity |
| Pipeline | 19 | -- | Graphite, ZeroMQ | -- | Linear data flow is inherently simple to reason about |
| Service-Based | 4 | 4 (25.0% top-3) | Graphite | -- | Few services with clear boundaries |
| Hexagonal/Clean | 16 | -- | -- | buckpal | Structure without infrastructure complexity |

**Cross-Source Convergence:** Graphite and ZeroMQ demonstrate that simplicity is not the absence of capability -- it is a deliberate architectural decision to limit complexity by constraining scope and eliminating operational overhead. Graphite chose a fixed-size round-robin database format that sacrifices flexibility for zero-maintenance storage. ZeroMQ eliminated the message broker entirely by embedding patterns into a library.

In competition, simplicity as a stated priority consistently led teams toward modular monolith, service-based, or buy-over-build decisions. Across all sources, simplicity correlates strongly with pipeline and plugin patterns -- both achieve powerful capabilities through simple, composable abstractions rather than complex distributed coordination.

---

## Cross-Source Quality Attribute Patterns

### QAs most validated by production evidence

| Quality Attribute | Production Systems (AOSA + RealWorld) | Total Production Points |
|------------------|---------------------------------------|------------------------|
| Extensibility/Evolvability | 9 systems | 180 |
| Scalability | 5 systems | 100 |
| Performance | 4 systems | 80 |
| Modularity | 4 systems | 80 |
| Data Integrity | 2 systems | 40 |
| Fault Tolerance | 2 systems | 40 |
| Interoperability | 2 systems | 40 |
| Simplicity | 3 systems (2 AOSA + 1 RefArch) | 42 |
| Security | 2 systems (1 RealWorld + 1 RefArch) | 22 |
| Deployability | 2 systems (RealWorld only) | 40 |

### QAs most over-represented in competition vs. production

1. **Cost/Feasibility** -- 26 KataLog teams, zero production evidence. Entirely competition-specific.
2. **Security** -- 40 KataLog teams but only 1 production system (Bitwarden), where security is the core product. Most production systems handle security at the deployment layer rather than the architecture layer.
3. **Availability** -- 43 KataLog teams but only 2 AOSA systems (both distributed storage). Competition teams tend to over-state availability needs.

### QAs most under-represented in competition vs. production

1. **Modularity** -- Zero KataLog teams cite it directly, but 4 AOSA production systems and 41 Discovered repos demonstrate it. Competition teams describe the symptoms (evolvability, maintainability) rather than the structural property.
2. **Deployability** -- Near-zero KataLog citations, but 108 Discovered repos and 4 production/reference systems prioritize it. Competition time limits exclude operational concerns.
3. **Testability** -- Zero KataLog teams cite it, but 4 RefArch repos exist specifically to demonstrate it. Reference implementations fill the gap that competitions and production documentation leave.

### QAs most distorted by Discovered detection bias

1. **Deployability** (89%) -- Grossly inflated. Docker/CI presence is a modern tooling convention, not an architectural decision.
2. **Evolvability** (2%) -- Severely underdetected. The most production-validated QA (9 systems) is nearly invisible to filesystem analysis. KataLog qualitative evidence is essential here.
3. **Performance** (0%) -- Completely undetectable. The fourth most-cited QA in competition, validated by 4 AOSA systems. Architectural performance decisions leave no filesystem trace.

---

Generated: 2026-03-05
