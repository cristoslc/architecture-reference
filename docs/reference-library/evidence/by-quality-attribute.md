# Evidence by Quality Attribute

Evidence drawn from 225 entries across 5 sources: 78 KataLog competition submissions, 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 122 Discovered open-source repositories. Quality attributes ranked by cross-source frequency and production validation. See [cross-source-reference.md](cross-source-reference.md) for scoring methodology.

Generated: 2026-03-05

---

## Quality Attribute Rankings

| Rank | Quality Attribute | KataLog Teams | AOSA Systems | RealWorld Apps | RefArch Repos | Discovered Repos | Cross-Source Validation |
|------|-------------------|---------------|--------------|----------------|---------------|------------------|------------------------|
| 1 | Scalability | 55 of 78 | 4 (HDFS, Riak, Graphite, NGINX) | 1 (Squidex) | 2 (eShopOnContainers, serverless-microservices) | 33 (27%) | 5/5 sources |
| 2 | Extensibility/Evolvability | 35 of 78 | 5 (LLVM, GStreamer, SQLAlchemy, Selenium, Twisted) | 4 (Jellyfin, nopCommerce, Orchard Core, Squidex) | 2 (eShopOnContainers, modular-monolith-with-ddd) | 2 (2%) | 5/5 sources |
| 3 | Availability/Fault Tolerance | 43 of 78 | 2 (HDFS, Riak) | -- | -- | 18 (15%) | 3/5 sources |
| 4 | Security | 40 of 78 | -- | 1 (Bitwarden) | 1 (AKS Baseline) | -- | 3/5 sources |
| 5 | Deployability | low | low | 2 (Bitwarden, nopCommerce) | 2 (eShop, eShopOnContainers) | 108 (89%) | 3/5 sources |
| 6 | Modularity | -- | 3 (LLVM, GStreamer, SQLAlchemy) | 1 (Orchard Core) | 1 (modular-monolith-with-ddd) | 41 (34%) | 4/5 sources |
| 7 | Performance | 41 of 78 | 4 (NGINX, LLVM, ZeroMQ, Git) | -- | -- | 0 | 2/5 sources |
| 8 | Observability | 11 of 78 | -- | -- | 1 (eShop) | 4 (3%) | 3/5 sources |
| 9 | Testability | -- | -- | -- | 4 (buckpal, clean-architecture-dotnet, wild-workouts, modular-monolith-with-ddd) | -- | 1/5 sources |
| 10 | Data Integrity/Consistency | 20 of 78 | 2 (Git, HDFS) | -- | -- | -- | 2/5 sources |
| 11 | Interoperability | 15 of 78 | 2 (Selenium, SQLAlchemy) | -- | -- | -- | 2/5 sources |
| 12 | Cost/Feasibility | 26 of 78 | -- | -- | -- | -- | 1/5 sources |
| 13 | Simplicity | 6 of 78 | 2 (Graphite, ZeroMQ) | -- | 1 (buckpal) | -- | 3/5 sources |

> **Detection bias note (Discovered):** Deployability at 89% is inflated by Docker/Kubernetes signal detection -- the presence of a Dockerfile or Helm chart is a strong filesystem signal that automated classification reliably detects. Performance is absent because performance optimization leaves no consistent filesystem signature (it lives in algorithmic choices, caching strategies, and runtime configuration). These are detection limits, not reflections of actual QA prevalence in open-source codebases.

---

## 1. Scalability

**Cross-Source Validation: 5/5 sources** -- the only quality attribute validated across every evidence source, from production distributed systems to competition designs to open-source codebases.

### Cross-Source Evidence Summary

Scalability appears in all five sources: 55 KataLog teams (71% of all submissions), 4 AOSA production systems, 1 RealWorld application, 2 reference implementations, and 33 Discovered repositories. This breadth makes scalability the most universally prioritized quality attribute in the dataset. However, the nature of scalability evidence varies dramatically by source -- AOSA systems demonstrate proven horizontal scaling under real load, while KataLog teams often cite scalability aspirationally without proving their designs would actually scale.

### Production Evidence

**AOSA systems (4):**
- **NGINX** -- Event-driven, non-blocking architecture handles 10,000+ concurrent connections per worker process. Master-worker process model scales horizontally across CPU cores. Serves over 30% of all websites globally.
- **HDFS** -- Block-based distributed filesystem designed for petabyte-scale storage. NameNode/DataNode architecture with configurable replication factor. Default 128MB block size optimized for throughput over latency.
- **Riak** -- Dynamo-inspired distributed key-value store. Consistent hashing ring distributes data across nodes with no single point of failure. Designed for linear horizontal scaling.
- **Graphite** -- Carbon daemon with relay architecture for horizontal write scaling. Whisper storage engine with configurable retention policies. Federation model for multi-cluster deployments.

**RealWorld systems (1):**
- **Squidex** -- API-first headless CMS designed for multi-tenant SaaS deployment. MongoDB-backed event store supports horizontal scaling of content operations.

### Competition Evidence

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

### Code-Level Evidence

**Reference implementations (2):**
- **eShopOnContainers** -- Canonical microservices reference demonstrating horizontal scaling through container orchestration, API gateway patterns, and per-service database isolation.
- **serverless-microservices** -- Azure Functions-based implementation demonstrating auto-scaling through serverless compute with event-driven triggers.

**Discovered repositories (33, 27%):** Scalability signals detected via container orchestration configs (Kubernetes HPA, Docker Swarm), message queue infrastructure (RabbitMQ, Kafka), and database sharding configurations.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | Discovered Repos | Cross-Source Pattern |
|-------------------|---------------|--------------|------------------|---------------------|
| Event-Driven | 36 (41.7% top-3) | NGINX, Graphite | 63 | Strongest cross-source support; async decoupling enables independent scaling |
| Microservices | 32 (31.2% top-3) | -- | 26 | Popular in competition; absent from AOSA production evidence |
| Service-Based | 17 (23.5% top-3) | Graphite | 4 | Moderate competition support; Graphite's relay model validates |
| Modular Monolith | 3 (66.7% top-3) | -- | 64 | High KataLog win rate; dominant in Discovered but scales differently |
| Pipeline | -- | NGINX, HDFS, Graphite | 19 | Invisible in competition; proven at extreme production scale |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Distributed storage | AOSA | HDFS (petabyte-scale), Riak (linear horizontal scaling) |
| Web infrastructure | AOSA | NGINX (30% of internet traffic) |
| Monitoring/metrics | AOSA, KataLog | Graphite (time-series at scale), MonitorMe (medical monitoring) |
| Travel/logistics | KataLog | Road Warrior (2M active users), Farmacy Food (smart fridge network) |
| Content management | RealWorld | Squidex (multi-tenant SaaS) |
| E-commerce | RefArch | eShopOnContainers (per-service scaling) |

**Cross-Source Convergence:** Production systems (NGINX, HDFS, Riak) achieve scalability through fundamentally different mechanisms than competition designs propose. NGINX scales through event-driven non-blocking I/O within a single process; HDFS scales through data partitioning across commodity hardware. Competition teams overwhelmingly propose microservices-based horizontal scaling, yet zero AOSA production systems use microservices as a primary style. The gap suggests competition teams over-index on microservices for scalability when simpler patterns (pipeline, event-driven worker pools) are proven at far greater scale.

---

## 2. Extensibility/Evolvability

**Cross-Source Validation: 5/5 sources** -- validated across all five sources, with particularly strong production evidence from plugin-based systems.

### Cross-Source Evidence Summary

Extensibility appears in 35 KataLog teams, 5 AOSA production systems (the most for any QA in AOSA), 4 RealWorld applications (the most for any QA in RealWorld), 2 reference implementations, and 2 Discovered repositories. This is the quality attribute with the strongest production validation -- systems like LLVM, GStreamer, and Jellyfin have proven their extensibility models over years of real-world plugin development.

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

### Competition Evidence

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

### Code-Level Evidence

**Reference implementations (2):**
- **eShopOnContainers** -- Demonstrates service extraction as an evolutionary pattern; services can be independently versioned and replaced.
- **modular-monolith-with-ddd** -- Module boundaries enforced at compilation; modules communicate through explicit integration events, enabling future extraction to separate services.

**Discovered repositories (2, 2%):** Low detection rate reflects the difficulty of detecting extensibility from filesystem signals alone -- plugin architectures are identifiable, but general evolvability (loose coupling, well-defined interfaces) requires deeper code analysis.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | RealWorld Apps | Cross-Source Pattern |
|-------------------|---------------|--------------|----------------|---------------------|
| Plugin/Microkernel | 2 (100% top-3) | LLVM, GStreamer, SQLAlchemy | Jellyfin, nopCommerce, Orchard Core | Dominant production pattern for extensibility |
| Event-Driven | 23 (43.5% top-3) | Twisted | Squidex | Event-based decoupling enables independent evolution |
| Modular Monolith | 2 (100% top-3) | -- | Orchard Core | Module boundaries enable evolution without distribution cost |
| Microservices | 20 (45.0% top-3) | -- | -- | Popular in competition; no production extensibility evidence |
| Pipeline | -- | LLVM, GStreamer | Jellyfin | Phase-based design inherently extensible at each stage |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Compilers/toolchains | AOSA | LLVM (30+ language frontends) |
| Multimedia | AOSA, RealWorld | GStreamer (250+ plugins), Jellyfin (community plugins) |
| E-commerce | RealWorld | nopCommerce (3,000+ marketplace plugins) |
| Content management | RealWorld | Orchard Core (dynamic modules), Squidex (API-first) |
| ORM/database | AOSA | SQLAlchemy (dialect system for arbitrary backends) |
| Healthcare/food | KataLog | Farmacy Food (evolving smart fridge integrations) |

**Cross-Source Convergence:** Production evidence overwhelmingly favors plugin/microkernel architectures for extensibility, while competition teams overwhelmingly propose microservices. Six production systems (LLVM, GStreamer, SQLAlchemy, Jellyfin, nopCommerce, Orchard Core) use plugin architectures; zero use microservices for extensibility. This is the largest gap between competition preference and production reality in the entire dataset. Plugin/Microkernel rose from rank #11 to #2 in the cross-source weighted scoreboard specifically because of this extensibility evidence.

---

## 3. Availability/Fault Tolerance

**Cross-Source Validation: 3/5 sources** -- strong in competition and production distributed systems, with additional code-level evidence from Discovered repositories.

### Cross-Source Evidence Summary

Availability appears in 43 KataLog teams (the second most-cited QA), 2 AOSA distributed storage systems, and 18 Discovered repositories. It is absent from RealWorld and RefArch sources, which focus on application-level concerns rather than infrastructure resilience. The AOSA evidence is particularly deep -- HDFS and Riak were specifically designed to tolerate hardware failures as a normal operating condition.

### Production Evidence

**AOSA systems (2):**
- **HDFS** -- Default 3x replication across DataNodes on different racks. Automatic re-replication when nodes fail. NameNode high availability through standby NameNode with shared edit log (JournalNode quorum). Designed for commodity hardware where failures are expected, not exceptional.
- **Riak** -- Dynamo-inspired availability model: hinted handoff for temporary node failures, read repair for consistency recovery, configurable N/R/W values (default N=3, R=2, W=2). Sloppy quorum ensures writes succeed even during partitions. Explicitly prioritizes availability over consistency (AP in CAP).

### Competition Evidence

**KataLog summary:** 43 of 78 teams cited availability (55%). Average placement score: 1.79. Top-3 rate: 39.5%.

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

### Code-Level Evidence

**Discovered repositories (18, 15%):** Fault tolerance signals detected via circuit breaker patterns (Polly, Hystrix), retry policies, health check endpoints, and redundant service configurations in Kubernetes manifests.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | Discovered Repos | Cross-Source Pattern |
|-------------------|---------------|--------------|------------------|---------------------|
| Event-Driven | 29 (41.4% top-3) | -- | 63 | Async decoupling provides natural fault isolation |
| Microservices | 23 (34.8% top-3) | -- | 26 | Service isolation limits blast radius; no production HA evidence |
| Service-Based | 14 (28.6% top-3) | -- | 4 | Coarser granularity trades some isolation for simplicity |
| Space-Based | -- | -- | 5 | Replicated processing units; Riak validates the underlying model |
| Pipeline | -- | HDFS | 19 | HDFS replication pipeline: data written to 3 nodes in sequence |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Distributed storage | AOSA | HDFS (rack-aware replication), Riak (hinted handoff) |
| Medical monitoring | KataLog | MonitorMe (life-critical vital sign alerts) |
| Travel | KataLog | Road Warrior (99.99% SLA across time zones) |
| IT operations | KataLog | Sysops Squad (ticketing must survive component failures) |

**Cross-Source Convergence:** AOSA production evidence reveals a crucial distinction: HDFS and Riak achieve availability through data replication and consensus protocols at the storage layer, not through microservices decomposition at the application layer. Competition teams typically propose availability through service redundancy (multiple instances behind load balancers). Both approaches are valid but operate at different levels of the stack. The pattern that consistently predicts placement in KataLog is explicit graceful degradation modeling -- documenting what capabilities degrade at each failure level -- rather than claiming generic "high availability."

---

## 4. Security

**Cross-Source Validation: 3/5 sources** -- broadly cited in competition but with limited production evidence depth.

### Cross-Source Evidence Summary

Security appears in 40 KataLog teams (51%), 1 RealWorld application with deep compliance evidence, and 1 reference implementation. It is absent from AOSA (infrastructure systems treat security at the deployment layer, not as an architectural driver) and Discovered (security practices are invisible to filesystem-based detection). Security is unique in that it is nearly universal as a stated concern but rarely a differentiating architectural driver -- it functions more as a hygiene factor.

### Production Evidence

**RealWorld systems (1):**
- **Bitwarden** -- Zero-knowledge architecture where the server never has access to unencrypted vault data. Client-side encryption with PBKDF2-SHA256 (600,000+ iterations) or Argon2id. SOC2 Type II, GDPR, CCPA, and HIPAA compliant. Annual third-party security audits. Supports FIDO2/WebAuthn, TOTP, and hardware security keys. Open-source client and server for community audit.

**Reference implementations (1):**
- **AKS Baseline** -- Microsoft's reference for secure Kubernetes deployment. Network policies, pod security standards, managed identity, Azure AD integration, and ingress controller hardening.

### Competition Evidence

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

### Code-Level Evidence

Security leaves minimal filesystem signatures. Authentication middleware, authorization policies, and encryption configurations are code-level concerns that automated classification cannot reliably detect from repository structure alone.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | RealWorld Apps | Cross-Source Pattern |
|-------------------|---------------|----------------|---------------------|
| Modular Monolith | 4 (100% top-3) | -- | Smaller attack surface; centralized security enforcement |
| Service-Based | 10 (40.0% top-3) | Bitwarden | Bitwarden validates; fewer network boundaries to secure |
| Event-Driven | 27 (40.7% top-3) | -- | Async communication reduces direct attack vectors |
| Microservices | 21 (23.8% top-3) | -- | More network boundaries increase attack surface |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Password management | RealWorld | Bitwarden (zero-knowledge, multi-compliance) |
| Healthcare | KataLog | Farmacy Family (HIPAA, GDPR, crypto-shredding) |
| Non-profit/social | KataLog | Hey Blue! (PII protection), ClearView (resume anonymization) |
| AI/ML | KataLog | Certifiable Inc. (LLM security, OWASP Top 10 for AI) |
| Infrastructure | RefArch | AKS Baseline (network policies, pod security) |

**Cross-Source Convergence:** Bitwarden provides the deepest security evidence in the entire dataset -- zero-knowledge architecture, multiple compliance certifications, and annual audits. Competition teams cite security broadly but differentiate only when backing it with specific architectural decisions (zero trust, crypto-shredding, mutual TLS). The pattern that predicts placement is security-as-architecture (specific ADRs addressing concrete security decisions) rather than security-as-checklist (listing encryption and authentication as requirements).

---

## 5. Deployability

**Cross-Source Validation: 3/5 sources** -- dominated by Discovered signal (89% detection rate), with production validation from RealWorld and RefArch.

### Cross-Source Evidence Summary

Deployability is the most detected quality attribute in the Discovered source (108 of 122 repos, 89%) but appears infrequently in KataLog and AOSA. This inversion reveals a detection bias: Docker/Kubernetes configurations are the strongest filesystem signal in automated classification, making deployability artificially prominent in code-level analysis. Nevertheless, the RealWorld and RefArch evidence validates that deployability is a genuine architectural concern for production systems -- it simply was not a priority in the AOSA era (2004-2012) or in time-limited architecture competitions.

### Production Evidence

**RealWorld systems (2):**
- **Bitwarden** -- Supports cloud-hosted (bitwarden.com), self-hosted (Docker Compose or Kubernetes), and air-gapped deployment. Unified codebase with deployment-specific configuration. This deployment flexibility is a core product differentiator -- enterprises choose Bitwarden specifically because they can self-host.
- **nopCommerce** -- Supports deployment to Windows/Linux, Docker containers, and Azure App Service. One-click Azure deployment templates. Web-based installation wizard handles database setup and initial configuration.

### Competition Evidence

Deployability was rarely cited as a top-3 quality attribute in KataLog competitions, where time-limited design exercises focus on logical architecture over operational concerns. However, winning teams that addressed deployment demonstrated operational maturity: BluzBrothers (1st, MonitorMe) documented specific deployment topology with duplicate instances (ADR-018/020).

### Code-Level Evidence

**Reference implementations (2):**
- **eShop** -- .NET Aspire-based deployment with built-in observability. Docker Compose for local development, Kubernetes manifests for production.
- **eShopOnContainers** -- Canonical Docker + Kubernetes deployment reference. Helm charts, GitHub Actions CI/CD, and multi-environment configuration.

**Discovered repositories (108, 89%):** The dominant detection signal. Dockerfile presence (nearly universal in modern .NET repos), docker-compose.yml for multi-service orchestration, Kubernetes manifests, Helm charts, and CI/CD pipeline definitions (.github/workflows, azure-pipelines.yml). This high detection rate reflects modern development practices -- containerization has become default tooling -- rather than intentional architectural prioritization of deployability.

### Architecture Styles That Best Support It

| Architecture Style | RefArch Evidence | Discovered Repos | Cross-Source Pattern |
|-------------------|-----------------|------------------|---------------------|
| Microservices | eShopOnContainers | 26 | Per-service containers; independent deployment is a defining trait |
| Modular Monolith | -- | 64 | Single deployable unit simplifies pipeline; Docker makes it trivial |
| Event-Driven | -- | 63 | Message infrastructure (RabbitMQ, Kafka) drives compose complexity |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Security/compliance | RealWorld | Bitwarden (air-gapped deployment for regulated industries) |
| E-commerce | RealWorld, RefArch | nopCommerce (one-click Azure), eShopOnContainers (Helm charts) |
| Enterprise | Discovered | 89% of repos include containerization regardless of domain |

**Cross-Source Convergence:** Deployability is the quality attribute most distorted by detection methodology. The 89% Discovered rate reflects that Dockerfiles are ubiquitous in modern .NET development, not that 89% of projects architecturally prioritize deployability. The meaningful evidence comes from RealWorld systems where deployment flexibility is a product feature (Bitwarden's self-hosted model) or from RefArch repos where deployment topology is the primary teaching objective (eShopOnContainers). Competition teams rarely cite deployability because architecture katas focus on logical design, not operational concerns.

---

## 6. Modularity

**Cross-Source Validation: 4/5 sources** -- strong across AOSA, RealWorld, RefArch, and Discovered. Absent from KataLog because modularity is an implicit architectural property rather than a stated quality attribute.

### Cross-Source Evidence Summary

Modularity appears in 3 AOSA production systems, 1 RealWorld application, 1 reference implementation, and 41 Discovered repositories. It is absent from KataLog because competition teams state quality attributes like "evolvability" or "maintainability" rather than "modularity" directly -- though many winning architectures implicitly achieve modularity. The AOSA evidence is particularly valuable: LLVM, GStreamer, and SQLAlchemy each demonstrate different approaches to achieving modularity in production.

### Production Evidence

**AOSA systems (3):**
- **LLVM** -- Three-layer modular design: frontends (language parsing), optimizer passes (reusable across all languages), and backends (target-specific code generation). Each layer has a well-defined IR (Intermediate Representation) boundary. New passes can be added to the optimizer pipeline without modifying frontends or backends.
- **GStreamer** -- Element-based modularity where each processing step (demuxing, decoding, filtering, encoding, output) is an independent element with typed pads. Elements are loaded dynamically from shared libraries. The framework does not need to know about specific media formats.
- **SQLAlchemy** -- Two-layer architecture: Core (SQL expression language, connection pooling, dialect system) and ORM (unit of work, identity map, eager/lazy loading). Either layer can be used independently. Dialect modules encapsulate database-specific SQL differences.

**RealWorld systems (1):**
- **Orchard Core** -- ASP.NET Core modular application framework. Features are implemented as modules that can be enabled/disabled per tenant. Content types composed from reusable content parts. Modules can extend the admin UI, define routes, and register services.

### Competition Evidence

Modularity is implicit in competition architectures but rarely stated as a named quality attribute. Winning teams demonstrate modularity through bounded contexts, service boundaries, and module decomposition diagrams. The modular monolith style (3 KataLog teams, 66.7% top-3 rate) is the most direct competition expression of modularity as a priority.

### Code-Level Evidence

**Reference implementations (1):**
- **modular-monolith-with-ddd** -- Modules communicate exclusively through integration events. Module boundaries enforced at compilation through project references. Each module owns its database schema. Demonstrates that modularity can be achieved without distribution.

**Discovered repositories (41, 34%):** Modularity signals detected via project structure (separate assemblies/projects per module), explicit dependency injection configuration, and internal NuGet package references. Second-most detected QA after deployability.

### Architecture Styles That Best Support It

| Architecture Style | AOSA Systems | RealWorld Apps | Discovered Repos | Cross-Source Pattern |
|-------------------|--------------|----------------|------------------|---------------------|
| Plugin/Microkernel | LLVM, GStreamer, SQLAlchemy | Orchard Core | 0 | Production-dominant pattern for modularity |
| Modular Monolith | -- | Orchard Core | 64 | Module boundaries without distribution cost |
| Pipeline | LLVM, GStreamer | -- | 19 | Pipeline stages are natural module boundaries |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Compilers | AOSA | LLVM (frontend/optimizer/backend separation) |
| Multimedia | AOSA | GStreamer (250+ independently loadable plugins) |
| ORM/database | AOSA | SQLAlchemy (Core and ORM independently usable) |
| Content management | RealWorld | Orchard Core (per-tenant module configuration) |

**Cross-Source Convergence:** The production evidence strongly favors plugin/microkernel and pipeline architectures for achieving modularity, both of which were nearly invisible in KataLog competitions. LLVM and GStreamer demonstrate that modularity at production scale is achieved through well-defined intermediate representations and typed interfaces between components -- not through service decomposition over a network. The Discovered evidence reinforces this: 64 repos exhibit modular monolith patterns (project-level module boundaries) versus 26 using microservices (network-level module boundaries).

---

## 7. Performance

**Cross-Source Validation: 2/5 sources** -- deep production evidence from AOSA, strong competition evidence from KataLog, but absent from RealWorld, RefArch, and Discovered.

### Cross-Source Evidence Summary

Performance appears in 41 KataLog teams and 4 AOSA production systems but is absent from RealWorld, RefArch, and Discovered sources. The absence from Discovered is a detection limitation: performance optimization lives in algorithmic choices, data structure selection, caching strategies, and runtime configuration -- none of which leave filesystem signatures detectable by automated classification. The AOSA evidence is deep: NGINX, LLVM, ZeroMQ, and Git each demonstrate performance engineering at a level competition designs can only aspire to.

### Production Evidence

**AOSA systems (4):**
- **NGINX** -- Event-driven architecture eliminates per-connection thread/process overhead. Single worker process handles thousands of concurrent connections through epoll/kqueue. Shared memory zones for caching, rate limiting, and session storage. Zero-copy sendfile for static content.
- **LLVM** -- Multi-pass optimization pipeline where each pass operates on a well-defined IR. Passes can be independently enabled/disabled for compile-time vs. runtime performance trade-offs. JIT compilation support for runtime code generation (used in Julia, Rust, Swift).
- **ZeroMQ** -- Lock-free queue implementation for inter-thread messaging. Batching of small messages to amortize syscall overhead. Zero-copy message passing through reference counting. Protocol-agnostic transport (inproc, IPC, TCP, multicast) with the same API.
- **Git** -- Content-addressable object store with delta compression for space efficiency. Packfile format with sliding window delta compression. Index file (staging area) as memory-mapped data structure for fast status operations.

### Competition Evidence

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

### Code-Level Evidence

Performance optimization is largely invisible to automated code analysis. No RefArch repositories focus primarily on performance as a quality attribute, and Discovered classification cannot detect algorithmic optimization, caching strategies, or I/O patterns from filesystem structure alone.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|---------------|--------------|---------------------|
| Event-Driven | 30 (53.3% top-3) | NGINX | Non-blocking I/O eliminates thread overhead |
| Pipeline | -- | NGINX, LLVM, ZeroMQ, Git | All 4 AOSA performance systems use pipeline patterns |
| Modular Monolith | 3 (100% top-3) | -- | Avoids network hops; in-process calls are faster |
| Microservices | 22 (40.9% top-3) | -- | Network overhead is a performance cost |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Web servers | AOSA | NGINX (C10K problem solved through event-driven design) |
| Compilers | AOSA | LLVM (multi-pass optimization, JIT support) |
| Messaging | AOSA | ZeroMQ (lock-free queues, zero-copy, batching) |
| Version control | AOSA | Git (content-addressable store, delta compression) |
| Medical monitoring | KataLog | MonitorMe (1-second SLA for vital sign alerts) |
| Travel | KataLog | Road Warrior (sub-second dashboard updates) |

**Cross-Source Convergence:** The AOSA evidence reveals that extreme performance is achieved through low-level engineering decisions (event loops, lock-free data structures, zero-copy I/O, memory-mapped files) rather than architectural style selection. All four AOSA performance systems use pipeline patterns internally, yet zero KataLog teams proposed pipeline as a primary style. Competition teams address performance through architectural choices (CQRS read models, caching layers, async processing) that operate at a higher abstraction level than the systems-programming techniques proven in production. Both levels matter, but production evidence suggests the pipeline pattern is the most underappreciated performance enabler.

---

## 8. Observability

**Cross-Source Validation: 3/5 sources** -- emerging as a cross-cutting concern in modern architectures.

### Cross-Source Evidence Summary

Observability appears in 11 KataLog teams, 1 reference implementation, and 4 Discovered repositories. It is absent from AOSA (most AOSA systems predate the modern observability movement) and RealWorld. Despite low absolute numbers, observability is increasingly critical in distributed and AI-integrated systems. The KataLog evidence shows observability as a differentiator primarily in AI-focused challenges.

### Production Evidence

No AOSA or RealWorld systems cite observability as a primary quality attribute. This reflects the publication era of AOSA systems (2004-2012), before modern observability platforms (Prometheus, Grafana, OpenTelemetry) became standard infrastructure.

### Competition Evidence

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

### Code-Level Evidence

**Reference implementations (1):**
- **eShop** -- .NET Aspire-based implementation with built-in OpenTelemetry integration, structured logging, distributed tracing, and health check dashboards.

**Discovered repositories (4, 3%):** Low detection rate reflects that observability is implemented through NuGet packages and configuration (Serilog, OpenTelemetry SDK) rather than distinctive filesystem structures.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | RefArch Evidence | Cross-Source Pattern |
|-------------------|---------------|------------------|---------------------|
| Service-Based | 4 (50.0% top-3) | -- | Moderate service count makes tracing manageable |
| Event-Driven | 8 (37.5% top-3) | eShop | Async flows require distributed tracing |
| Microservices | 6 (33.3% top-3) | eShopOnContainers | Many services demand observability; also make it harder |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| AI/ML systems | KataLog | ShopWise (LangFuse), Certifiable Inc. (Langwatch) |
| IT operations | KataLog | Sysops Squad (monitoring is the product) |
| E-commerce | RefArch | eShop (OpenTelemetry, health checks) |

**Cross-Source Convergence:** Observability is the quality attribute most likely to grow in cross-source validation as the dataset expands. Its current 3-source presence understates its production importance -- modern systems universally implement observability, but the AOSA systems predate the observability movement, and RealWorld applications treat it as operational infrastructure rather than an architectural driver. The KataLog evidence suggests observability is becoming a first-class architectural concern specifically in AI-integrated systems where LLM behavior monitoring requires purpose-built tooling.

---

## 9. Testability

**Cross-Source Validation: 1/5 sources** -- RefArch-dominated. This is what reference implementations are specifically optimized for.

### Cross-Source Evidence Summary

Testability appears in 4 reference implementations but is absent from KataLog, AOSA, RealWorld, and Discovered sources. This does not mean testability is unimportant in production -- rather, it reflects that reference implementations exist specifically to demonstrate testable architecture patterns, while production systems and competition designs focus on runtime quality attributes. Testability is an internal quality attribute (affecting developers) rather than an external one (affecting users), which explains its absence from user-facing evidence sources.

### Production Evidence

No AOSA or RealWorld systems cite testability as a primary quality attribute. Production systems optimize for runtime characteristics (performance, scalability, availability); testability is achieved through code organization and dependency management that these sources do not document architecturally.

### Competition Evidence

KataLog teams rarely cite testability as a quality attribute. Competition time constraints focus designs on runtime characteristics and stakeholder-visible qualities.

### Code-Level Evidence

**Reference implementations (4):**
- **buckpal** -- Hexagonal architecture reference that demonstrates port/adapter isolation for unit testing without infrastructure dependencies. Domain logic testable in complete isolation.
- **clean-architecture-dotnet** -- Uncle Bob's Clean Architecture in .NET. Use cases (application services) testable through dependency inversion. Infrastructure concerns injected at composition root.
- **wild-workouts** -- Go-based clean architecture demonstrating test isolation through interface-driven design. Application and domain layers testable without HTTP or database dependencies.
- **modular-monolith-with-ddd** -- Integration tests per module verify module contracts. Module boundaries enforced at compilation prevent accidental coupling that would compromise testability.

### Architecture Styles That Best Support It

| Architecture Style | RefArch Evidence | Cross-Source Pattern |
|-------------------|------------------|---------------------|
| Hexagonal/Clean Architecture | buckpal, clean-architecture-dotnet, wild-workouts | Port/adapter separation enables infrastructure-free testing |
| Modular Monolith | modular-monolith-with-ddd | Module boundaries create natural test boundaries |
| Domain-Driven Design | modular-monolith-with-ddd | Domain model testable in isolation from infrastructure |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Financial/accounting | RefArch | buckpal (account transfer domain) |
| Content management | RefArch | clean-architecture-dotnet (CRUD operations) |
| Fitness/booking | RefArch | wild-workouts (reservation system) |

**Cross-Source Convergence:** Testability's RefArch-only presence is itself a finding: reference implementations exist specifically to demonstrate how architectural patterns support testability. Hexagonal/Clean Architecture patterns dominate RefArch evidence precisely because their port/adapter separation makes testing the primary architectural benefit. In production systems, testability is achieved through the same patterns but is not documented as an architectural driver -- it is a consequence of good structure rather than a stated goal.

---

## 10. Data Integrity/Consistency

**Cross-Source Validation: 2/5 sources** -- KataLog and AOSA provide complementary evidence from competition design and production systems.

### Cross-Source Evidence Summary

Data integrity appears in 20 KataLog teams and 2 AOSA production systems. The AOSA evidence demonstrates two different production approaches: Git's content-addressable integrity model and HDFS's replication-based durability. Competition evidence focuses on consistency challenges in distributed systems.

### Production Evidence

**AOSA systems (2):**
- **Git** -- Content-addressable object store where every object (blob, tree, commit) is identified by its SHA-1 hash. Any corruption is immediately detectable because the content no longer matches its address. Immutable objects -- once written, objects are never modified. Pack files use delta compression but verify checksums on read.
- **HDFS** -- Block-level checksums verified on every read. Automatic checksum repair through block re-replication from uncorrupted replicas. DataNode block scanner runs periodic integrity checks in background. Write pipeline confirms receipt at each DataNode before acknowledging to client.

### Competition Evidence

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

### Code-Level Evidence

Data integrity is implemented through database constraints, transaction boundaries, and validation logic that leave no distinctive filesystem signature for automated detection.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|---------------|--------------|---------------------|
| Service-Based | 4 (75.0% top-3) | -- | Fewer distributed transactions; easier to maintain consistency |
| Event-Driven | 16 (56.2% top-3) | -- | Event sourcing provides immutable audit trail |
| Pipeline | -- | Git, HDFS | Content-addressable storage and block checksums |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Version control | AOSA | Git (content-addressable integrity, immutable objects) |
| Distributed storage | AOSA | HDFS (block checksums, automatic repair) |
| Medical monitoring | KataLog | MonitorMe (vital sign data must not be corrupted or lost) |
| Certification | KataLog | Certifiable Inc. (audit trail integrity) |
| Financial | KataLog | Sysops Squad (billing data consistency) |

**Cross-Source Convergence:** Git and HDFS demonstrate fundamentally different approaches to data integrity that competition teams could learn from. Git achieves integrity through content-addressable storage (corruption is structurally impossible because addresses are derived from content). HDFS achieves integrity through redundancy and verification (checksums on every read, automatic re-replication). Competition teams typically address data integrity through consistency patterns (saga, two-phase commit, eventual consistency) that operate at the application layer -- valid but at a different level than the storage-layer integrity proven in production.

---

## 11. Interoperability

**Cross-Source Validation: 2/5 sources** -- KataLog and AOSA provide evidence from integration-heavy challenges and systems.

### Cross-Source Evidence Summary

Interoperability appears in 15 KataLog teams and 2 AOSA production systems. It is most critical in systems that must integrate with diverse external services, hardware, or protocols. The AOSA evidence demonstrates interoperability at the protocol and API level.

### Production Evidence

**AOSA systems (2):**
- **Selenium** -- WebDriver protocol provides a standardized API across all major browsers (Chrome, Firefox, Safari, Edge). Language bindings for Java, Python, C#, Ruby, JavaScript, and Kotlin generated from a shared specification. Browser-specific drivers (ChromeDriver, GeckoDriver) encapsulate differences behind the WebDriver interface.
- **SQLAlchemy** -- Dialect system enables the same Python ORM code to run against PostgreSQL, MySQL, SQLite, Oracle, MS SQL Server, and others. Each dialect handles SQL syntax differences, type mapping, and connection semantics. DBAPI abstraction layer supports multiple database drivers per database engine.

### Competition Evidence

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

### Code-Level Evidence

Interoperability patterns (API adapters, protocol translators, format converters) are implemented through code that does not leave distinctive filesystem signatures for automated detection.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | Cross-Source Pattern |
|-------------------|---------------|--------------|---------------------|
| Event-Driven | 12 (75.0% top-3) | -- | Event-based integration decouples system boundaries |
| Service-Based | 5 (40.0% top-3) | Selenium, SQLAlchemy | Adapter pattern at service boundaries |
| Plugin/Microkernel | -- | Selenium, SQLAlchemy | Dialect/driver plugins encapsulate integration differences |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Browser automation | AOSA | Selenium (WebDriver protocol across all browsers) |
| Database access | AOSA | SQLAlchemy (dialect system for 6+ database engines) |
| HR/recruiting | KataLog | ClearView (diverse HR system integration) |
| Healthcare | KataLog | Farmacy Family (health provider data exchange) |
| Conservation | KataLog | Wildlife Watcher (camera trap and labeling platform integration) |

**Cross-Source Convergence:** Both AOSA systems (Selenium, SQLAlchemy) achieve interoperability through the same fundamental pattern: a protocol/dialect abstraction that encapsulates external system differences behind a stable internal interface. Competition teams propose the same pattern (adapter-based integration) but at the service level rather than the driver/dialect level. The cross-source evidence suggests that interoperability is best achieved through plugin/adapter patterns that isolate integration-specific code, regardless of whether the architecture is monolithic or distributed.

---

## 12. Cost/Feasibility

**Cross-Source Validation: 1/5 sources** -- largely competition-only. Cost analysis does not appear as an architectural concern in production systems or reference implementations.

### Cross-Source Evidence Summary

Cost/feasibility appears in 26 KataLog teams but is absent from AOSA, RealWorld, RefArch, and Discovered sources. This makes it the most competition-specific quality attribute. In production, cost manifests through infrastructure choices and operational budgets rather than as an architectural quality attribute. In competition, cost analysis was the strongest predictor of placement in non-profit and startup challenges.

### Production Evidence

No production sources cite cost as a primary architectural quality attribute. Cost is an operational concern managed through infrastructure selection, right-sizing, and FinOps practices rather than through architecture style selection. However, the architecture styles proven in production (pipeline, plugin/microkernel, service-based) are typically less expensive to operate than competition-popular styles (microservices, serverless) due to simpler infrastructure requirements.

### Competition Evidence

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

### Code-Level Evidence

Cost optimization leaves no filesystem signature. Infrastructure cost is determined by deployment configuration, cloud service selection, and operational practices -- not by code structure.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | Top-3 Rate | Cross-Source Pattern |
|-------------------|---------------|-----------|---------------------|
| Modular Monolith | 5 | 80.0% | Simplest deployment model, lowest infrastructure cost |
| Serverless | 3 | 66.7% | Pay-per-invocation model for low-traffic systems |
| Service-Based | 6 | 50.0% | Fewer services than microservices, lower operational overhead |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Non-profit | KataLog | Hey Blue! (community engagement, limited budget) |
| Startup | KataLog | Spotlight Platform (MVP-first approach) |
| Healthcare non-profit | KataLog | Farmacy Food (three-scenario costing) |
| AI integration | KataLog | Certifiable Inc. (LLM API token cost estimation) |

**Cross-Source Convergence:** Cost/feasibility is the most competition-specific quality attribute. Its absence from production sources does not mean cost is unimportant -- rather, production systems manage cost through operational practices (right-sizing, reserved instances, auto-scaling policies) rather than through architectural style selection. The KataLog evidence does reveal a strong correlation: modular monolith teams cite cost most frequently and achieve the highest placement rate when cost is a factor. This aligns with the production-weighted scoreboard where simpler architectural styles (pipeline, service-based, modular monolith) dominate the top rankings.

---

## 13. Simplicity

**Cross-Source Validation: 3/5 sources** -- KataLog, AOSA, and RefArch provide complementary perspectives on simplicity as architectural virtue.

### Cross-Source Evidence Summary

Simplicity appears in 6 KataLog teams, 2 AOSA production systems, and 1 reference implementation. Despite low absolute numbers, the evidence is high-quality: Graphite and ZeroMQ are production systems that made simplicity a deliberate architectural decision, and buckpal is a reference implementation specifically designed to demonstrate the simplest viable clean architecture.

### Production Evidence

**AOSA systems (2):**
- **Graphite** -- Deliberately simple architecture: Carbon (receive metrics), Whisper (store metrics), Graphite-web (render graphs). No clustering complexity in the core -- scaling handled through Carbon relay for fanout. Whisper storage format is a fixed-size, round-robin database that self-manages retention without garbage collection or compaction. Creator Chris Davis explicitly chose simplicity over features, reasoning that a monitoring system that is itself complex to operate defeats its purpose.
- **ZeroMQ** -- "Socket API that acts like a framework." Eliminates broker complexity by embedding messaging patterns (pub/sub, req/rep, push/pull) directly into the library. No central server, no configuration files, no daemon processes. The simplicity is structural: ZeroMQ is a library, not a service, which eliminates an entire category of operational complexity.

### Competition Evidence

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

### Code-Level Evidence

**Reference implementations (1):**
- **buckpal** -- Deliberately minimal hexagonal architecture implementation. Single module, clear package structure (adapter/in, adapter/out, application/port/in, application/port/out, domain). Demonstrates that Clean Architecture does not require complexity -- the simplest implementation is a single deployable with well-organized packages.

### Architecture Styles That Best Support It

| Architecture Style | KataLog Teams | AOSA Systems | RefArch Evidence | Cross-Source Pattern |
|-------------------|---------------|--------------|------------------|---------------------|
| Modular Monolith | 3 (66.7% top-3) | -- | buckpal | Single deployable unit; minimal operational complexity |
| Service-Based | 4 (25.0% top-3) | Graphite | -- | Few services with clear boundaries |
| Pipeline | -- | Graphite, ZeroMQ | -- | Linear data flow is inherently simple to reason about |
| Hexagonal/Clean | -- | -- | buckpal | Structure without infrastructure complexity |

### Domains That Most Demand It

| Domain | Source | Examples |
|--------|--------|----------|
| Monitoring/metrics | AOSA | Graphite (simple by design -- monitoring tools must not be complex) |
| Messaging | AOSA | ZeroMQ (library, not service -- eliminates operational complexity) |
| Non-profit/startup | KataLog | Wildlife Watcher, Spotlight Platform, ClearView |
| Teaching/reference | RefArch | buckpal (minimal viable clean architecture) |

**Cross-Source Convergence:** Graphite and ZeroMQ demonstrate that simplicity is not the absence of capability -- it is a deliberate architectural decision to limit complexity by constraining scope and eliminating operational overhead. Graphite chose a fixed-size round-robin database format that sacrifices flexibility for zero-maintenance storage. ZeroMQ eliminated the message broker entirely by embedding patterns into a library. In competition, simplicity as a stated priority consistently led teams toward modular monolith, service-based, or buy-over-build decisions. Across all sources, simplicity correlates strongly with pipeline and plugin patterns -- both of which achieve powerful capabilities through simple, composable abstractions rather than complex distributed coordination.

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
2. **Security** -- 40 KataLog teams but only 1 production system (Bitwarden) where security is the core product. Most production systems handle security at the deployment layer.
3. **Availability** -- 43 KataLog teams but only 2 AOSA systems (both distributed storage). Competition teams over-state availability needs.

### QAs most under-represented in competition vs. production

1. **Modularity** -- Zero KataLog teams cite it directly, but 4 AOSA production systems and 41 Discovered repos demonstrate it. Competition teams describe the symptoms (evolvability, maintainability) rather than the structural property (modularity).
2. **Deployability** -- Near-zero in KataLog, but 108 Discovered repos and 4 production/reference systems prioritize it. Competition time limits exclude operational concerns.
3. **Testability** -- Zero KataLog teams, but 4 RefArch repos exist specifically to demonstrate it. Reference implementations fill the gap that competitions and production documentation leave.

### Detection bias summary

The Discovered source (122 repositories with automated classification) has systematic detection strengths and blind spots:

| Detectable (filesystem signals) | Undetectable (code-level concerns) |
|-------------------------------|-------------------------------------|
| Deployability (Docker, K8s, Helm) | Performance (algorithms, caching) |
| Modularity (project structure) | Security (auth middleware, encryption) |
| Scalability (message queues, HPA) | Data Integrity (transactions, constraints) |
| Fault Tolerance (circuit breakers, retries) | Testability (test patterns, DI) |
| Observability (logging config, OTel) | Interoperability (API adapters) |

This bias means Discovered evidence is most reliable for infrastructure-level quality attributes and least reliable for application-level quality attributes. Cross-source validation corrects for this by combining Discovered breadth with AOSA/RealWorld depth.

---

Generated: 2026-03-05
