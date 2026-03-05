# Solution Space Taxonomy

A cross-source, evidence-based catalog of architectural approaches, production-weighted by evidence from 225 entries across 5 sources: 78 KataLog competition submissions, 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 122 Discovered open-source repositories.

> **Cross-references.** For the raw evidence tables and weighting methodology, see [Cross-Source Evidence Reference](evidence/cross-source-reference.md). For the analytical framework, gap analysis, and lifecycle-stage mapping, see [Cross-Source Analysis](evidence/cross-source-analysis.md). For per-style KataLog breakdowns, see [Evidence by Architecture Style](evidence/by-architecture-style.md). For the problem-domain perspective (which challenges favor which styles), see [Problem Spaces](problem-spaces.md).

---

## How to Use This Document

This document maps the **solution space** of software architecture: which architectural styles appear in competition designs, production systems, reference implementations, and open-source codebases, and how those styles perform under each type of evidence.

**Two scoring systems, one document:**

1. **Combined Weighted Scoreboard** (PRIMARY). Production-weighted scoring where a single production system (20 pts) outweighs an entire Kata competition season (~13 pts). This is the primary ranking because production evidence is categorically stronger than design proposals. See the full methodology in [cross-source-reference.md](evidence/cross-source-reference.md#evidence-weighting-methodology).

2. **KataLog Competition Scoreboard** (SECONDARY). Placement-based scoring (1-4 pts per team) across 78 O'Reilly Architecture Kata submissions. Valuable for understanding what expert judges reward in design exercises but subject to competition bias -- teams optimize for judges, not production.

**Reading each style profile:**
- **Combined score breakdown** shows how evidence distributes across sources. High production % means battle-tested; high KataLog % means design-validated but potentially unproven at scale.
- **Production evidence** (AOSA + RealWorld) is highlighted first. These are systems built, deployed, and operated under real-world conditions.
- **Design evidence** (KataLog) shows competition teams, placements, and ADR counts. This is design-phase validation by expert judges.
- **Code evidence** (Discovered + RefArch) shows breadth of adoption in open-source codebases. Discovered repos are auto-classified and not weighted in the combined score.
- **Quality attributes** are drawn from all sources, with production-observed attributes taking precedence.

**Limitations:**
- Correlation is not causation. Winning teams may succeed for many reasons beyond their style choice.
- Each KataLog team may list multiple styles; counts are not mutually exclusive.
- The KataLog dataset is 78 teams across 11 challenges. Some styles have very small sample sizes (n < 5).
- AOSA projects date from 2011-2012; technology specifics may be dated even though architectural patterns remain valid.
- RealWorldASPNET is .NET-only (5 entries). Discovered repos span 9+ languages but classification is automated.
- Production evidence covers 17 systems. Absence from production sources does not prove a style is unsuitable for production -- it means the evidence base hasn't captured it yet.

---

## Scoring Methodology

### Production-Weighted Scoring (Primary)

Each entry receives points based on evidence quality. Production systems receive the highest weight because code running under real conditions is a different class of evidence from a design proposal.

| Source | Entry Type | Points | Rationale |
|--------|-----------|--------|-----------|
| **AOSA** | Production system described by creator | **20** | Built, deployed, operated at scale. Validated by years of real-world use. |
| **RealWorldASPNET** | Production application (active) | **20** | Deployed production software with real users. |
| **TheKataLog** | 1st place competition winner | 4 | Expert-judged best design, but never built |
| **TheKataLog** | 2nd place | 3 | Strong validated design |
| **TheKataLog** | 3rd place | 2 | Recognized quality |
| **TheKataLog** | Runner-up | 1 | Participated, not distinguished by judges |
| **Reference Impl** | Active/maintained repo | 2 | Working code with community validation, sample domain |
| **Reference Impl** | Archived repo | 1 | Working code, no longer maintained |

**Why this weighting:** A single production system (20 pts) outweighs an entire Kata competition season (~13 pts across all placements). NGINX serving 30% of the internet is categorically stronger evidence than all teams in any single Kata season combined.

**Discovered repos** (122 entries) are not included in combined scores. They provide breadth context -- "how many open-source codebases exhibit this pattern?" -- but automated classification quality varies. See [cross-source-reference.md](evidence/cross-source-reference.md#discovered-evidence-breadth-not-depth) for details.

### KataLog Competition Scoring (Secondary)

Each team receives a placement score based on competitive result:

| Placement | Points | Rationale |
|-----------|--------|-----------|
| 1st Place | 4 | Clear winner, validated by expert judges |
| 2nd Place | 3 | Strong runner-up, close to winning |
| 3rd Place | 2 | Recognized quality, notable strengths |
| Runner-up | 1 | Participated but did not place in top 3 |

**Weighted Score** = sum of all placement points for teams using that style. **Average Placement Score** = Weighted Score / Number of Teams. **Placement distribution** across 78 teams: 11 first-place, 11 second-place, 12 third-place, 44 runners-up.

---

## Combined Weighted Scoreboard

| Rank | Style | KataLog | AOSA | RealWorld | Ref Impls | Combined | Production % | Discovered | vs KataLog-only |
|------|-------|---------|------|-----------|-----------|----------|-------------|------------|-----------------|
| 1 | **Event-Driven** | 94 | 60 | 40 | 9 | **203** | 49% | 63 | -- |
| 2 | **Plugin/Microkernel** | 4 | 60 | 60 | 0 | **124** | 97% | 0 | +9 (was #11) |
| 3 | **Pipeline** | 0 | 100 | 20 | 0 | **120** | 100% | 19 | NEW |
| 4 | **Service-Based** | 43 | 40 | 20 | 2 | **105** | 57% | 4 | -1 (was #3) |
| 5 | **Microservices** | 67 | 0 | 0 | 9 | **76** | 0% | 26 | -3 (was #2) |
| 6 | **Modular Monolith** | 18 | 0 | 20 | 2 | **40** | 50% | 64 | -2 (was #4) |
| 7 | **CQRS/Event Sourcing** | 8 | 0 | 20 | 5 | **33** | 61% | 18 | +1 (was #8) |
| 8 | **Space-Based** | 4 | 20 | 0 | 0 | **24** | 83% | 5 | +2 (was #10) |
| 9 | **Layered** | 0 | 0 | 20 | 0 | **20** | 100% | 29 | NEW |
| 10 | **Domain-Driven Design** | 11 | 0 | 0 | 5 | **16** | 0% | 27 | -4 (was #6) |
| 11 | **Hexagonal/Clean** | 10 | 0 | 0 | 6 | **16** | 0% | 16 | -4 (was #7) |
| 12 | **Serverless** | 12 | 0 | 0 | 2 | **14** | 0% | 6 | -7 (was #5) |
| 13 | **Multi-Agent** | 8 | 0 | 0 | 0 | **8** | 0% | 5 | -4 (was #9) |

**What the production weighting reveals:**

1. **Plugin/Microkernel surges to #2 (was #11 in KataLog-only).** Six production systems across compilers, ORMs, multimedia, media servers, CMS, and e-commerce. 97% production evidence. Only 2 Kata teams ever used this pattern.
2. **Pipeline rises to #3 (invisible in KataLog).** Five AOSA projects plus Jellyfin. 100% production evidence. Zero Kata teams proposed pipeline as a primary style.
3. **Microservices drops to #5 (was #2).** Zero production evidence across all sources. Every point from competition designs and reference templates.
4. **Serverless drops to #12 (was #5).** Zero production evidence. The gap between competition popularity and production adoption is second only to Microservices.
5. **Layered enters at #9 (invisible in KataLog).** nopCommerce's four-layer architecture plus 29 Discovered repos. 100% production evidence in the curated score.

---

## KataLog Competition Scoreboard

| Style | Teams Using | Weighted Score | Avg Placement | 1st Place Uses | Top Challenge Fit |
|-------|-------------|----------------|---------------|----------------|-------------------|
| **Event-Driven Architecture** | 47 | 94 | 2.00 | 9 | ShopWise AI (4.0), Sysops Squad (2.5), Certifiable Inc. (2.5) |
| **Microservices** | 39 | 67 | 1.72 | 4 | ShopWise AI (4.0), Hey Blue! (2.2), Wildlife Watcher (2.2) |
| **Service-Based Architecture** | 25 | 43 | 1.72 | 3 | Certifiable Inc. (2.0), ClearView (2.0), Sysops Squad (2.0) |
| **Modular Monolith** | 6 | 18 | 3.00 | 3 | Farmacy Food (4.0), Hey Blue! (4.0), Spotlight (2.5) |
| **Serverless** | 8 | 12 | 1.50 | 1 | Hey Blue! (2.0), Spotlight (1.5) |
| **Domain-Driven Design** | 4 | 11 | 2.75 | 1 | Farmacy Food (3.5), Hey Blue! (3.0) |
| **Hexagonal/Clean Architecture** | 4 | 10 | 2.50 | 1 | Hey Blue! (4.0), Farmacy Food (3.0) |
| **CQRS/Event Sourcing** | 3 | 8 | 2.67 | 1 | Farmacy Food (3.5) |
| **Multi-Agent** | 3 | 8 | 2.67 | 1 | ShopWise AI (3.5) |
| **Space-Based Architecture** | 2 | 4 | 2.00 | 0 | Road Warrior (3.0) |
| **Microkernel/Plugin** | 2 | 4 | 2.00 | 0 | Certifiable Inc. (2.0), Wildlife Watcher (2.0) |

**Key insight**: Modular Monolith has the highest average placement score (3.00) of any style despite low adoption. Event-Driven dominates in absolute terms (9 first-place wins) but its popularity dilutes its average. Pipeline and Layered have zero KataLog representation -- they are invisible to competition data entirely.

---

## Detailed Style Profiles

### #1 -- Event-Driven Architecture

**Combined rank**: #1 (203 pts) | **Evidence tier**: T5 (all 5 sources) | **Production %**: 49%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 94 | 47 teams, 9 first-place wins |
| AOSA | 60 | NGINX, Twisted, ZeroMQ |
| RealWorld | 40 | Squidex, Bitwarden |
| Ref Impls | 9 | eShopOnContainers, eShop, Modular Monolith w/DDD, Serverless Microservices, Wild Workouts |

**Production evidence (AOSA + RealWorld):**
- **NGINX** (AOSA Vol. 2): Event-driven reactor pattern with non-blocking I/O. Serves ~30% of internet traffic. The event loop processes thousands of connections per worker process without threading.
- **Twisted** (AOSA Vol. 2): Python event-driven networking framework using the reactor pattern. Underlies numerous Python network applications.
- **ZeroMQ** (AOSA Vol. 2): Broker-less messaging library with actor model (socket-as-actor). Used in financial trading systems with microsecond-level latency requirements.
- **Squidex** (RealWorld): Headless CMS using event sourcing -- every content change stored as an immutable event with MongoDB as event store. ~2,300 GitHub stars.
- **Bitwarden** (RealWorld): Password management server using AMQP for cross-service event coordination alongside service-based decomposition. ~16,000 GitHub stars.

**Design evidence (KataLog):**
- **Usage**: 47 of 78 teams (60.3%)
- **Placement distribution**: 9 first / 6 second / 8 third / 24 runner-up
- **Average placement score**: 2.00
- **Most successful in**: ShopWise AI Assistant (avg 4.0), Sysops Squad (avg 2.5), Certifiable Inc. (avg 2.5), Hey Blue! (avg 2.2), ClearView (avg 2.2)
- **Commonly paired with**: Microservices (29 teams), Service-Based (10), Serverless (5), Hexagonal/Clean (3), Modular Monolith (3)
- **Key technologies**: Apache Kafka, RabbitMQ, AWS SNS/SQS, Azure Event Hub, GCP Pub/Sub

**Code evidence:**
- **Discovered**: 63 repos (52% of all Discovered entries) -- Kafka-based stream processing, RabbitMQ message buses, event sourcing frameworks, and reactive systems. Tied with Modular Monolith as the most common Discovered style.
- **Ref Impls**: 5 repositories spanning C#, Java, and Go.

**Quality attributes supported**: Scalability, Fault Tolerance, Availability, Evolvability, Performance, Responsiveness
**Quality attributes traded off**: Simplicity, Cognitive Simplicity, Consistency (eventual consistency trade-off)

**Best example systems:**
- **NGINX** (production): Event-driven reactor with non-blocking I/O serving 30% of web traffic
- **BluzBrothers** (1st, MonitorMe): Pure event-driven with Kafka, 20 ADRs, quantitative fitness functions, infrastructure sizing proof
- **The Archangels** (1st, Farmacy Family): Event-driven with Kafka, 18 ADRs, crypto-shredding, full C4 modeling
- **Profitero Data Alchemists** (1st, Road Warrior): Event-driven with Rozanski/Woods viewpoints, 15 ADRs, three scaling groups

**Cross-source insight**: Event-Driven is universally adopted, but its *role* shifts across the lifecycle. In competition designs, it is the primary organizing principle. In production (NGINX, Twisted), it solves specific technical problems -- non-blocking I/O, event-loop concurrency, immutable audit trails. Teams proposing "Event-Driven Architecture" should specify which aspect they mean: event-based communication, event sourcing as data model, event-loop concurrency, or integration pattern.

**When to use**: Systems requiring asynchronous decoupling, high throughput, fault tolerance, or temporal decoupling between producers and consumers. The dominant architectural style across all evidence tiers.

**When NOT to use**: Event-driven appeared at high rates across all KataLog placements (50% of runners-up also use it). It is necessary but not sufficient. Teams that adopted EDA without complementary patterns (event storming, proper ADR documentation, feasibility analysis) did not consistently place well. In the Wildlife Watcher challenge, EDA teams averaged only 1.3 -- suggesting it may be over-applied in IoT/edge contexts where simpler patterns suffice.

---

### #2 -- Plugin/Microkernel

**Combined rank**: #2 (124 pts) | **Evidence tier**: T3 (KataLog, AOSA, RealWorld) | **Production %**: 97%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 4 | 2 teams, 0 first-place wins |
| AOSA | 60 | LLVM, SQLAlchemy, GStreamer |
| RealWorld | 60 | Jellyfin, Orchard Core, nopCommerce |
| Ref Impls | 0 | (none) |

**Production evidence (AOSA + RealWorld):**
- **LLVM** (AOSA Vol. 1): Compiler infrastructure with a plugin/pass architecture. Each optimization and transformation is a plugin that slots into the compilation pipeline. Used by Apple (Clang/Swift), Rust, and hundreds of language frontends.
- **SQLAlchemy** (AOSA Vol. 2): Python ORM with a layered plugin architecture. Dialect plugins support multiple database backends (PostgreSQL, MySQL, SQLite, Oracle). Extensions for caching, versioning, and migration.
- **GStreamer** (AOSA Vol. 2): Multimedia framework where every codec, filter, demuxer, and output device is a plugin. Over 250 plugins in the base distribution. Core provides the host framework; all media processing is plugin-supplied.
- **Jellyfin** (RealWorld): Media server with a plugin system for metadata providers, authentication schemes, notification services, and media encoders. ~38,000 GitHub stars. .NET production evidence for plugin architecture (AOSA examples are C/C++/Python).
- **Orchard Core** (RealWorld): CMS/application framework built as a modular monolith with a plugin (module) architecture. Modules provide features (blog, commerce, forms) that can be enabled/disabled at runtime. ~7,500 GitHub stars.
- **nopCommerce** (RealWorld): E-commerce platform with a 17-year track record. Plugin system for payment gateways, shipping providers, tax calculators, and widgets. ~9,500 GitHub stars.

**Design evidence (KataLog):**
- **Usage**: 2 of 78 teams (2.6%)
- **Placement distribution**: 0 first / 0 second / 2 third / 0 runner-up
- **Average placement score**: 2.00
- **Most successful in**: Certifiable Inc. (2.0), Wildlife Watcher (2.0)
- **Commonly paired with**: Event-Driven (1), Modular Monolith (1), Service-Based (1)

**Code evidence:**
- **Discovered**: 0 repos. Plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container orchestration. This is a blind spot in automated structural detection -- the #2 curated style is structurally undetectable.
- **Ref Impls**: 0 repositories.

**Quality attributes supported**: Extensibility, Independent Evolution, Experimentation (A/B testing of plugins), Vendor Neutrality, Long-Term Adaptability
**Quality attributes traded off**: Plugin Interface Stability, Integration Testing Complexity, Plugin Isolation

**Best example systems:**
- **LLVM** (production): Plugin/pass architecture enabling hundreds of language frontends and optimization passes
- **GStreamer** (production): 250+ plugins for codecs, filters, demuxers -- all media processing via plugins
- **Jellyfin** (production): .NET plugin system for media server extensibility (38K stars)
- **Software Architecture Guild** (3rd, Certifiable Inc.): Microkernel for AI assistants enabling 6 parallel AI solution variants
- **Wonderous Toys** (3rd, Wildlife Watcher): Microkernel for integration extensibility combined with modular monolith

**Cross-source insight**: Plugin/Microkernel is the largest rank correction in the dataset (+9 positions from KataLog-only to combined). It is the most production-validated style relative to its design-phase awareness. Six production systems across compilers, ORMs, multimedia, media servers, CMS, and e-commerce demonstrate that plugin architecture is how long-lived systems achieve extensibility. Yet competition teams almost never propose it, and automated code discovery cannot detect it.

**When to use**: Systems requiring third-party extensibility, independent feature evolution, or the ability to accommodate uses the creators never imagined. Especially strong for platforms (LLVM, GStreamer, Orchard Core) and products with ecosystem strategies (nopCommerce payment gateways, Jellyfin metadata providers).

**When NOT to use**: Systems without clear extension points or where all functionality is first-party. Plugin architecture adds interface design overhead that is wasted if no third-party or independent-team extension is planned. In KataLog, both teams placed 3rd -- the pattern may lack the structural completeness judges expect at the system level without complementary styles.

---

### #3 -- Pipeline / Pipe-and-Filter

**Combined rank**: #3 (120 pts) | **Evidence tier**: T3 (AOSA, RealWorld, Discovered) | **Production %**: 100%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 0 | 0 teams |
| AOSA | 100 | NGINX, LLVM, ZeroMQ, Graphite, GStreamer |
| RealWorld | 20 | Jellyfin |
| Ref Impls | 0 | (none) |

**Production evidence (AOSA + RealWorld):**
- **NGINX** (AOSA Vol. 2): HTTP request processing as a pipeline of filter modules (gzip, SSL, rewrite, proxy pass). Each module processes the request/response and passes it to the next stage. The pipeline architecture enables NGINX's extraordinary throughput -- modules are composed without per-request memory allocation overhead.
- **LLVM** (AOSA Vol. 1): Compilation as a multi-stage pipeline: frontend (parsing) -> IR generation -> optimization passes -> backend (code generation). Each stage transforms the representation, and passes can be composed, reordered, or omitted. The pipeline+plugin combination enables LLVM's reuse across hundreds of languages.
- **ZeroMQ** (AOSA Vol. 2): Message processing pipelines with push/pull socket patterns for fan-out/fan-in workload distribution. Pipeline topology is a first-class concept in the ZeroMQ socket model.
- **Graphite** (AOSA Vol. 1): Metrics pipeline: Carbon (ingestion) -> Whisper (storage) -> Graphite-web (rendering). Three independent components connected by well-defined data contracts. Also classified as Service-Based.
- **GStreamer** (AOSA Vol. 2): Media processing pipeline where elements (sources, filters, sinks) are connected into directed graphs. Audio/video data flows through the pipeline with automatic format negotiation. Also classified as Plugin.
- **Jellyfin** (RealWorld): Media transcoding pipeline for real-time video/audio conversion. Media flows through decode -> filter -> encode stages. Also classified as Plugin. ~38,000 GitHub stars.

**Design evidence (KataLog):**
- **Usage**: 0 of 78 teams.
- Pipeline was not proposed as a primary style by any KataLog competition team across 11 challenges and 9 seasons. This is the sharpest design-production gap in the dataset -- the #3 overall style is completely absent from design exercises.

**Code evidence:**
- **Discovered**: 19 repos (16% of Discovered entries) -- data processing pipelines, ETL systems, stream processors. Code-level and production-level evidence converge for this style.
- **Ref Impls**: 0 repositories.

**Quality attributes supported**: Throughput, Composability, Independent Stage Evolution, Testability (per-stage), Reusability of stages
**Quality attributes traded off**: Latency (multi-stage overhead for single items), Complexity (error handling across stages), Interactivity (pipeline assumes unidirectional flow)

**Best example systems:**
- **NGINX** (production): HTTP filter pipeline serving 30% of web traffic
- **LLVM** (production): Compiler pipeline enabling hundreds of language frontends
- **GStreamer** (production): Multimedia processing pipeline with 250+ element plugins
- **Graphite** (production): Carbon -> Whisper -> Graphite-web metrics pipeline
- **ZeroMQ** (production): Push/pull message processing pipelines for distributed workloads

**Cross-source insight**: Pipeline is the most "production-invisible" style in design exercises. Zero KataLog teams proposed it, yet it underpins some of the most successful production systems ever built. The gap exists because KataLog challenges describe user-facing business systems where Microservices and Event-Driven map intuitively, while pipeline architecture solves infrastructure problems (request processing, compilation, media transcoding, metrics ingestion) that competition prompts rarely address.

**When to use**: Systems where data flows through ordered transformation stages: compilers, media processing, HTTP request handling, ETL/data ingestion, metrics pipelines, CI/CD systems. Especially powerful when combined with Plugin architecture (LLVM, GStreamer) so that pipeline stages are independently replaceable.

**When NOT to use**: Interactive or request-response systems where bidirectional communication is primary. Pipeline assumes unidirectional data flow; forcing interactive patterns into a pipeline creates unnecessary complexity. Not appropriate when stages have complex interdependencies that break the linear flow assumption.

---

### #4 -- Service-Based Architecture

**Combined rank**: #4 (105 pts) | **Evidence tier**: T5 (all 5 sources) | **Production %**: 57%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 43 | 25 teams, 3 first-place wins |
| AOSA | 40 | Selenium, Graphite |
| RealWorld | 20 | Bitwarden |
| Ref Impls | 2 | AKS Baseline Cluster |

**Production evidence (AOSA + RealWorld):**
- **Selenium WebDriver** (AOSA Vol. 1): Service-based with adapter pattern. Per-browser drivers (ChromeDriver, GeckoDriver) are independent services coordinated by the WebDriver protocol. Each service is coarser-grained than a microservice but independently deployable.
- **Graphite** (AOSA Vol. 1): Three independent services (Carbon, Whisper, Graphite-web) connected by well-defined data contracts. Services can be replaced independently -- Carbon can be swapped for StatsD without changing Whisper or the web frontend. Also classified as Pipeline.
- **Bitwarden** (RealWorld): Password management platform with 9 services (API, Identity, Admin, Portal, Icons, Notifications, Events, SSO, Key Connector) that share a single database. Explicitly chose service-based over microservices to avoid operational overhead of fully independent data stores. ~16,000 GitHub stars.

**Design evidence (KataLog):**
- **Usage**: 25 of 78 teams (32.1%)
- **Placement distribution**: 3 first / 3 second / 3 third / 16 runner-up
- **Average placement score**: 1.72
- **Most successful in**: Certifiable Inc. (avg 2.0), ClearView (avg 2.0), Sysops Squad (avg 2.0), Farmacy Family (avg 2.0)
- **Commonly paired with**: Event-Driven (10 teams), Microservices (3), Hybrid/Evolutionary (1), Serverless (1)
- **Key technologies**: AWS services, message queues, API Gateway, REST APIs

**Code evidence:**
- **Discovered**: 4 repos (3% of Discovered entries). Thin code presence -- service-based architecture is harder to detect from structural signals than microservices (fewer Docker Compose services) or event-driven (no message broker config).
- **Ref Impls**: 1 repository (AKS Baseline Cluster -- infrastructure-focused).

**Quality attributes supported**: Maintainability, Reliability, Availability, Testability, Cost Efficiency
**Quality attributes traded off**: Scalability (bounded), Elasticity (less granular), Independent Deployability (limited vs. microservices)

**Best example systems:**
- **Bitwarden** (production): 9 services with shared database, explicitly choosing service-based over microservices for operational simplicity (16K stars)
- **Selenium** (production): Per-browser driver services coordinated by WebDriver protocol
- **Pragmatic** (1st, ClearView): Service-based with selective event-driven, 22 ADRs, AI feasibility analysis, DDD/Event Storming
- **ZAITects** (1st, Certifiable Inc.): Service-based with event-driven hybrid, 18 ADRs, comprehensive LLM production stack
- **Team Seven** (1st, Sysops Squad): Service-based with event-driven message queues, 12 ADRs, phased migration plan

**Cross-source insight**: Service-Based is one of only two styles (with Event-Driven) that has evidence across all five source types. Bitwarden's explicit choice of service-based over microservices -- citing operational overhead -- validates the KataLog finding that Event-Driven + Service-Based (avg 2.57) outperforms Event-Driven + Microservices (avg 1.29) as a combination. Production evidence confirms that coarser-grained service decomposition with a shared database is a deliberate, pragmatic choice, not a compromise.

**When to use**: Business applications needing independent deployability without the operational overhead of full microservices. Particularly effective when services share a database (Bitwarden pattern) and teams lack the platform engineering capacity for service mesh, distributed tracing, and per-service CI/CD.

**When NOT to use**: Service-Based had weak KataLog showings in Road Warrior (avg 1.0) and Wildlife Watcher (avg 1.0), challenges requiring high scalability and real-time processing that push beyond service-based architecture's sweet spot.

---

### #5 -- Microservices

**Combined rank**: #5 (76 pts) | **Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production %**: 0%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 67 | 39 teams, 4 first-place wins |
| AOSA | 0 | (no production evidence) |
| RealWorld | 0 | (no production evidence) |
| Ref Impls | 9 | eShopOnContainers, eShop, Wild Workouts, Serverless Microservices, AKS Baseline |

**Production evidence (AOSA + RealWorld):**
None. Microservices has zero production evidence across both production sources. This is the sharpest signal that competition popularity does not equal production adoption. Systems that could use microservices (Bitwarden with 9 services) explicitly choose simpler decomposition (Service-Based) because the operational overhead of full microservice independence is not justified.

**Design evidence (KataLog):**
- **Usage**: 39 of 78 teams (50.0%)
- **Placement distribution**: 4 first / 6 second / 4 third / 25 runner-up
- **Average placement score**: 1.72
- **Most successful in**: ShopWise AI (avg 4.0), Hey Blue! (avg 2.2), Wildlife Watcher (avg 2.2), Spotlight (avg 2.0)
- **Commonly paired with**: Event-Driven (29 teams), Hexagonal/Clean (3), Modular Monolith (3), Service-Based (3), Serverless (3)
- **Key technologies**: Kubernetes, Docker, AWS EKS/ECS, API Gateway, REST APIs, GraphQL

**Code evidence:**
- **Discovered**: 26 repos (21% of Discovered entries). Down from 54 after pruning tutorials and sample apps, confirming that much of the "microservices" presence in open source is educational rather than production-grade.
- **Ref Impls**: 5 repositories (highest count of any style in RefArch). Microservices dominates teaching materials.

**Quality attributes supported**: Scalability, Elasticity, Deployability, Evolvability, Fault Isolation
**Quality attributes traded off**: Simplicity, Cost, Cognitive Load, Data Consistency, Operational Complexity

**Best example teams:**
- **CELUS Ceals** (1st, Wildlife Watcher): Microservices with iterative delivery, 15 ADRs, extensive C4 modeling, thorough 3rd-party integration analysis
- **MonArch** (1st, Hey Blue!): Microservices with hexagonal architecture per service, modular monolith initial phase, C4 modeling, event storming
- **The Marmots** (2nd, Spotlight): Pure microservices with 19 ADRs, layered separation, market sizing analysis

**Cross-source insight**: Microservices has the largest design-production gap in the evidence base. The second-most popular competition style (50% of teams) has zero production exemplars across 17 production systems. The gap exists because: (1) AOSA projects predate the microservices naming convention; (2) production teams that could adopt microservices choose simpler decomposition (Bitwarden: Service-Based); (3) the operational overhead filter removes microservices where the benefit of independent deployability does not justify the cost of service mesh, distributed tracing, and per-service data stores. Discovered data reinforces this: many microservices repos are tutorials/samples, not production systems.

**Critical finding**: Microservices-only teams (no EDA) averaged 1.70 KataLog points. EDA-only teams (no Microservices) averaged 2.44 points. Runners-up cite microservices at 55% -- the same rate as second-place teams. The cross-cutting analysis identifies microservices as "popular but not predictive."

**When to use**: Systems where independent team deployability is a genuine organizational requirement (Conway's Law alignment), where individual services need independent scaling, and where the organization has platform engineering capacity for the operational overhead.

**When NOT to use**: Pure synchronous microservices (without EDA) create tight coupling through REST chains. KataLog evidence shows Microservices without EDA averages 1.70 pts. Avoid defaulting to microservices for "scalability" -- production systems achieve scalability through specific mechanisms (NGINX event loops, Riak consistent hashing) rather than through architecture style selection.

---

### #6 -- Modular Monolith

**Combined rank**: #6 (40 pts) | **Evidence tier**: T4 (KataLog, RealWorld, RefArch, Discovered) | **Production %**: 50%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 18 | 6 teams, 3 first-place wins |
| AOSA | 0 | (none) |
| RealWorld | 20 | Orchard Core |
| Ref Impls | 2 | Modular Monolith with DDD |

**Production evidence (AOSA + RealWorld):**
- **Orchard Core** (RealWorld): CMS/application framework built as a modular monolith with a plugin (module) architecture. Modules provide features (blog, commerce, forms) that can be enabled/disabled at runtime. Demonstrates that modular monolith and plugin architecture are complementary -- the monolith provides the host, modules provide the plugins. ~7,500 GitHub stars.

**Design evidence (KataLog):**
- **Usage**: 6 of 78 teams (7.7%)
- **Placement distribution**: 3 first / 1 second / 1 third / 1 runner-up
- **Average placement score**: 3.00 (highest of any style)
- **Most successful in**: Farmacy Food (avg 4.0), Hey Blue! (avg 4.0), Spotlight (avg 2.5), Wildlife Watcher (avg 2.5)
- **Commonly paired with**: Microservices (3 teams -- as evolution target), Event-Driven (3), Serverless (2), Hexagonal/Clean (1)
- **Key technologies**: AWS, DynamoDB, RabbitMQ, event sourcing, DDD strategic design

**Code evidence:**
- **Discovered**: 64 repos (52% of Discovered entries) -- the highest count for any single style. Django apps, Go monoliths, modular .NET systems, well-structured full-stack applications. Pruning revealed that well-structured open-source applications overwhelmingly exhibit modular monolith patterns.
- **Ref Impls**: 1 repository (Modular Monolith with DDD, C#).

**Quality attributes supported**: Cognitive Simplicity, Cost Efficiency, Deployability, Testability, Modifiability
**Quality attributes traded off**: Scalability (initially), Elasticity (initially), Independent Deployability

**Best example systems:**
- **Orchard Core** (production): Modular monolith CMS where modules are independently toggleable features (7.5K stars)
- **ArchColider** (1st, Farmacy Food): Modular monolith + event sourcing + DDD, pioneering cost analysis with 3 growth scenarios
- **MonArch** (1st, Hey Blue!): Modular monolith as initial phase evolving to microservices, C4 modeling, event storming
- **PegasuZ** (1st, Spotlight): Modular monolith MVP with microservices + event-driven long-term target, evolutionary roadmap

**Cross-source insight**: Modular Monolith dominates the Discovered catalog (64 repos, 52%) yet ranks only #6 in curated scoring. This reveals that well-structured open-source applications overwhelmingly exhibit modular monolith patterns -- it is the default architecture of competently-built software. The KataLog win rate (83.3%, highest of any style) validates its effectiveness. The "start simple, evolve deliberately" approach is the strongest single architectural signal in the KataLog dataset.

**When to use**: Nearly all greenfield projects should start as a modular monolith. Every winning KataLog team that used it proposed it as an intentional initial phase with a documented evolution path to distributed styles. Especially effective when combined with DDD (ArchColider) or plugin architecture (Orchard Core).

**When NOT to use**: Very small KataLog sample (n=6). Notably absent from Road Warrior (2M active users) and MonitorMe (medical device monitoring) -- challenges with strict latency and throughput requirements that may exceed a monolith's initial capacity.

---

### #7 -- CQRS/Event Sourcing

**Combined rank**: #7 (33 pts) | **Evidence tier**: T4 (KataLog, RealWorld, RefArch, Discovered) | **Production %**: 61%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 8 | 3 teams, 1 first-place win |
| AOSA | 0 | (none) |
| RealWorld | 20 | Squidex |
| Ref Impls | 5 | eShopOnContainers, Modular Monolith w/DDD, Clean Architecture Template, Wild Workouts |

**Production evidence (AOSA + RealWorld):**
- **Squidex** (RealWorld): Headless CMS where every content change is stored as an immutable event. MongoDB serves as the event store; read models are projected from events. The first production CQRS/Event Sourcing evidence in the library, providing 61% of the style's combined score. ~2,300 GitHub stars.

**Design evidence (KataLog):**
- **Usage**: 3 of 78 teams (3.8%)
- **Placement distribution**: 1 first / 1 second / 0 third / 1 runner-up
- **Average placement score**: 2.67
- **Most successful in**: Farmacy Food (avg 3.5)
- **Commonly paired with**: Microservices (2), Event-Driven (2), Hexagonal/Clean (2), DDD (2)

**Code evidence:**
- **Discovered**: 18 repos -- AxonFramework, EventStoreDB integrations, Marten-based systems, and other event sourcing frameworks.
- **Ref Impls**: 4 repositories (C#, Java, Go). Highest RefArch representation relative to KataLog usage.

**Quality attributes supported**: Auditability, Scalability (independent read/write scaling), Event Replay, Data Integrity, Temporal Query
**Quality attributes traded off**: Complexity, Eventual Consistency, Learning Curve

**Best example systems:**
- **Squidex** (production): Every content change as an immutable event, MongoDB event store, projected read models (2.3K stars)
- **ArchColider** (1st, Farmacy Food): Event sourcing as core storage pattern combined with modular monolith and DDD
- **Miyagi's Little Forests** (2nd, Farmacy Food): CQRS with hexagonal architecture and DDD context mapping

**When to use**: Systems requiring full audit trails, temporal queries, or independent read/write scaling. Squidex demonstrates that CQRS/ES is viable for content management where every change must be tracked and replayed. Strongest when paired with DDD and Event-Driven.

**When NOT to use**: KataLog evidence shows CQRS/ES only appeared in Farmacy Food and Spotlight challenges. Teams in 2023-2025 seasons did not adopt it, suggesting perceived complexity without sufficient payoff for most challenge contexts. Avoid unless the domain genuinely requires immutable event histories or independent read/write models.

---

### #8 -- Space-Based Architecture

**Combined rank**: #8 (24 pts) | **Evidence tier**: T3 (KataLog, AOSA, Discovered) | **Production %**: 83%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 4 | 2 teams, 0 first-place wins |
| AOSA | 20 | Riak |
| RealWorld | 0 | (none) |
| Ref Impls | 0 | (none) |

**Production evidence (AOSA + RealWorld):**
- **Riak** (AOSA Vol. 1): Distributed key-value store using consistent hashing (Dynamo model) with in-memory data partitioning across a peer-to-peer cluster. No master node -- all nodes are equal. Eventual consistency with tunable read/write quorums. The canonical production example of space-based/tuple-space-inspired architecture.

**Design evidence (KataLog):**
- **Usage**: 2 of 78 teams (2.6%)
- **Placement distribution**: 0 first / 1 second / 0 third / 1 runner-up
- **Average placement score**: 2.00
- **Most successful in**: Road Warrior (avg 3.0)
- **Commonly paired with**: Microservices (2), Event-Driven (2), Hexagonal/Clean (1), CQRS (1)
- **Key technologies**: In-memory data grids, partitioned caching, Redis, CosmosDB (distributed)

**Code evidence:**
- **Discovered**: 5 repos -- Hazelcast integrations, Orleans-based systems, actor frameworks, distributed caches.
- **Ref Impls**: 0 repositories.

**Quality attributes supported**: Extreme Scalability, Low Latency, High Throughput, Elasticity
**Quality attributes traded off**: Complexity, Cost, Data Consistency (eventual)

**Best example systems:**
- **Riak** (production): Masterless distributed key-value store with consistent hashing and tunable consistency
- **Iconites** (2nd, Road Warrior): Space-based combined with microservices and event-driven, Cosmos DB global distribution

**When to use**: Systems demanding extreme scalability, near-zero latency, and elastic capacity. Riak demonstrates the pattern at database infrastructure level. Only appropriate when traffic patterns require in-memory data partitioning across distributed nodes.

**When NOT to use**: Extremely rare in practice (n=2 KataLog, 1 AOSA, 5 Discovered). Only appeared in challenges demanding extreme scalability. The complexity and cost overhead are unjustified for most application architectures.

---

### #9 -- Layered Architecture

**Combined rank**: #9 (20 pts) | **Evidence tier**: T2 (RealWorld, Discovered) | **Production %**: 100%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 0 | 0 teams |
| AOSA | 0 | (none directly; SQLAlchemy is classified as Layered+Plugin) |
| RealWorld | 20 | nopCommerce |
| Ref Impls | 0 | (none) |

**Production evidence (AOSA + RealWorld):**
- **nopCommerce** (RealWorld): E-commerce platform with a classic four-layer architecture: Presentation (web UI/API) -> Services (business logic) -> Data (persistence) -> Core (domain entities/interfaces). Layers enforce dependency direction -- upper layers depend on lower layers, never the reverse. 17-year production track record, ~9,500 GitHub stars. Also classified as Plugin (plugin system for extensions operates within the layered structure).

**Design evidence (KataLog):**
- **Usage**: 0 of 78 teams.
- Layered architecture was not proposed as a primary style by any KataLog competition team. Like Pipeline, it is invisible in design exercises. This likely reflects the perception that layered architecture is "too simple" for a competition context where judges reward architectural sophistication, even though layered architecture demonstrably works in long-lived production systems.

**Code evidence:**
- **Discovered**: 29 repos -- Django applications, Spring Boot services, Rails applications, and traditional n-tier codebases. The code-level evidence confirms that layered architecture remains one of the most common structural patterns in well-built applications.
- **Ref Impls**: 0 repositories.

**Quality attributes supported**: Simplicity, Separation of Concerns, Testability (per-layer), Maintainability, Onboarding Speed
**Quality attributes traded off**: Performance (cross-layer overhead), Scalability (monolithic deployment), Flexibility (rigid layer boundaries)

**Best example systems:**
- **nopCommerce** (production): Four-layer e-commerce platform with a 17-year track record and plugin extensibility (9.5K stars)

**Cross-source insight**: Layered architecture's 100% production evidence share (20 pts from nopCommerce alone) plus 29 Discovered repos suggests it remains widely adopted in practice despite being invisible in competition data and reference implementations. Combined with Plugin architecture (as in nopCommerce), layered systems can achieve extensibility while maintaining structural clarity.

**When to use**: Business applications where separation of concerns, team onboarding speed, and maintainability are primary concerns. Effective as the internal structure within each module of a modular monolith. nopCommerce demonstrates that layered + plugin is a viable long-term production combination.

**When NOT to use**: Systems requiring independent deployment of components, elastic scaling of individual layers, or cross-cutting functionality that does not fit cleanly into a single layer. Not appropriate as the sole architecture for systems with extreme scalability or real-time requirements.

---

### #10 -- Domain-Driven Design

**Combined rank**: #10 (16 pts) | **Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production %**: 0%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 11 | 4 teams, 1 first-place win |
| AOSA | 0 | (no production evidence) |
| RealWorld | 0 | (no production evidence) |
| Ref Impls | 5 | eShopOnContainers, Modular Monolith w/DDD, Wild Workouts |

**Production evidence (AOSA + RealWorld):**
None. DDD has zero production evidence across both production sources. However, 27 Discovered repos suggest widespread code-level adoption. The gap suggests DDD is frequently built but not yet captured surviving production pressure in this evidence base.

**Design evidence (KataLog):**
- **Usage**: 4 of 78 teams (5.1%) as explicit architectural approach
- **Placement distribution**: 1 first / 2 second / 0 third / 1 runner-up
- **Average placement score**: 2.75
- **Most successful in**: Farmacy Food (avg 3.5), Hey Blue! (avg 3.0)
- **Commonly paired with**: Microservices (3), CQRS/Event Sourcing (2), Event-Driven (2), Hexagonal/Clean (1)
- **Key technologies**: Event Storming (process), bounded contexts, context maps, strategic domain design

**Code evidence:**
- **Discovered**: 27 repos -- the widest gap between code presence (27) and production adoption (0) of any style. DDD patterns are widely implemented in open source but unvalidated at production scale within this evidence base.
- **Ref Impls**: 3 repositories (C#, Java, Go).

**Quality attributes supported**: Extensibility, Modifiability, Domain Alignment, Cognitive Clarity
**Quality attributes traded off**: Time-to-market (upfront analysis cost), Simplicity (for simple domains)

**Best example systems:**
- **ArchColider** (1st, Farmacy Food): DDD strategic design with core/supportive/generic domain classification, event sourcing
- **Miyagi's Little Forests** (2nd, Farmacy Food): DDD context map to microservices mapping, hexagonal reference architecture
- **IPT** (2nd, Hey Blue!): DDD with event storming, domain capability diagrams, GDPR compliance

**Note**: While only 4 teams explicitly list DDD as an architecture style, many more use DDD tactical patterns (event storming, bounded contexts, domain decomposition). The cross-cutting analysis identifies event storming as a common practice among KataLog winners.

**When to use**: Complex business domains with rich domain logic, especially greenfield projects. DDD appeared most valuable in KataLog contexts with complex business rules (Farmacy Food, Hey Blue!). No DDD team placed poorly.

**When NOT to use**: DDD is under-reported in KataLog data (many teams use DDD concepts without listing it as a style). The upfront analysis cost is significant. Avoid for simple CRUD domains or systems where the primary complexity is technical rather than domain-based.

---

### #11 -- Hexagonal/Clean Architecture

**Combined rank**: #11 (16 pts) | **Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production %**: 0%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 10 | 4 teams, 1 first-place win |
| AOSA | 0 | (no production evidence) |
| RealWorld | 0 | (no production evidence) |
| Ref Impls | 6 | Clean Architecture Solution Template, BuckPal, Wild Workouts |

**Production evidence (AOSA + RealWorld):**
None. Hexagonal/Clean has zero production evidence. However, 16 Discovered repos and strong RefArch presence (3 repos, highest point contribution of any style from RefArch alone) suggest it is widely taught and implemented as a within-service structural pattern.

**Design evidence (KataLog):**
- **Usage**: 4 of 78 teams (5.1%)
- **Placement distribution**: 1 first / 1 second / 1 third / 1 runner-up
- **Average placement score**: 2.50
- **Most successful in**: Hey Blue! (avg 4.0), Farmacy Food (avg 3.0)
- **Commonly paired with**: Microservices (3), Event-Driven (3), CQRS/Event Sourcing (2), Space-Based (1)
- **Key technologies**: Port/adapter patterns, dependency inversion, domain isolation

**Code evidence:**
- **Discovered**: 16 repos -- Clean Architecture templates, hexagonal examples across Java, C#, Go, and TypeScript.
- **Ref Impls**: 3 repositories (C#, Java, Go). Highest per-style RefArch representation.

**Quality attributes supported**: Testability, Maintainability, Domain Isolation, Replaceability
**Quality attributes traded off**: Simplicity (additional layers), Initial Development Speed

**Best example systems:**
- **MonArch** (1st, Hey Blue!): Hexagonal architecture applied at each microservice level with C4 component modeling
- **Miyagi's Little Forests** (2nd, Farmacy Food): Hexagonal reference architecture for internal bounded context structure
- **Architects++** (3rd, Farmacy Family): Hexagonal architecture with partnership-over-build approach, HIPAA compliance

**When to use**: As a within-service structural pattern for domain isolation and testability. Functions best inside a broader system-level architecture (MonArch applied hexagonal within each microservice). All 4 KataLog teams placed competitively.

**When NOT to use**: Small KataLog sample (n=4), all teams placed competitively -- no clear negative signal. The pattern adds structural overhead that may not be justified for simple CRUD services or short-lived systems.

---

### #12 -- Serverless

**Combined rank**: #12 (14 pts) | **Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production %**: 0%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 12 | 8 teams, 1 first-place win |
| AOSA | 0 | (no production evidence) |
| RealWorld | 0 | (no production evidence) |
| Ref Impls | 2 | Serverless Microservices Reference Architecture |

**Production evidence (AOSA + RealWorld):**
None. Serverless has zero production evidence across both production sources. No AOSA or RealWorldASPNET project uses serverless as a primary style. The gap between competition popularity (8 teams, #5 in KataLog) and production adoption (0%) is second only to Microservices.

**Design evidence (KataLog):**
- **Usage**: 8 of 78 teams (10.3%)
- **Placement distribution**: 1 first / 0 second / 1 third / 6 runner-up
- **Average placement score**: 1.50
- **Most successful in**: Hey Blue! (avg 2.0), Spotlight (avg 1.5)
- **Commonly paired with**: Event-Driven (5), Microservices (3), Modular Monolith (2)
- **Key technologies**: AWS Lambda, AWS Step Functions, Google Cloud Functions, Firebase

**Code evidence:**
- **Discovered**: 6 repos (mostly AWS SAM/CDK deployments). Below the n>=10 target for robust classification.
- **Ref Impls**: 1 repository (C# Serverless Microservices).

**Quality attributes supported**: Elasticity, Cost Efficiency (pay-per-use), Deployability, Automatic Scalability
**Quality attributes traded off**: Performance (cold starts), Control, Vendor Lock-in, Debugging Complexity

**Best example systems:**
- **MonArch** (1st, Hey Blue!): Serverless as one component of a broader multi-style architecture
- **TheGlobalVariables** (3rd, Spotlight): Serverless microservices on AWS Amplify with detailed cost-of-ownership analysis ($0.002/user/month)

**When to use**: As a supporting pattern within a broader architecture, especially for event-triggered background processing, scheduled tasks, or lightweight APIs. Cost-effective for variable-load workloads.

**When NOT to use**: Serverless as the primary/sole style (Berlin Bears, Team Pacman) consistently produced runner-up KataLog results. The style performs better as a supporting pattern than as the primary structural approach.

---

### #13 -- Multi-Agent

**Combined rank**: #13 (8 pts) | **Evidence tier**: T2 (KataLog, Discovered) | **Production %**: 0%

**Combined score breakdown:**
| Source | Points | Details |
|--------|--------|---------|
| KataLog | 8 | 3 teams, 1 first-place win |
| AOSA | 0 | (no production evidence) |
| RealWorld | 0 | (no production evidence) |
| Ref Impls | 0 | (none) |

**Production evidence (AOSA + RealWorld):**
None. Multi-Agent is the newest style in the taxonomy (first appeared Fall 2024) and has no production evidence across any source.

**Design evidence (KataLog):**
- **Usage**: 3 of 78 teams (3.8%)
- **Placement distribution**: 1 first / 1 second / 0 third / 1 runner-up
- **Average placement score**: 2.67
- **Most successful in**: ShopWise AI Assistant (avg 3.5), Certifiable Inc. (avg 1.0)
- **Commonly paired with**: Service-Based (1), Microservices (1), Event-Driven (1)
- **Key technologies**: LangGraph, LangChain, n8n workflows, supervisor-agent hierarchy, role-based AI personas

**Code evidence:**
- **Discovered**: 5 repos -- AutoGPT, CrewAI, LangGraph-based systems, CAMEL, smolagents. Below the n>=10 target. The first code-level validation of the pattern.
- **Ref Impls**: 0 repositories.

**Quality attributes supported**: Accuracy (specialized agents), Extensibility (add new agents), Responsible AI (separation of concerns per agent)
**Quality attributes traded off**: Complexity, Latency (multi-hop), Cost (multiple LLM calls), Debugging Difficulty

**Best example systems:**
- **ConnectedAI** (1st, ShopWise AI): Multi-agent supervisor architecture with LangGraph, quantitative LLM evaluation using Ragas, full working prototype
- **Breakwater** (2nd, ShopWise AI): Low-code multi-agent workflow on n8n with three-agent topology

**When to use**: AI-focused systems where different reasoning capabilities (retrieval, analysis, planning, execution) benefit from specialized agents. Requires an AI-centric problem context.

**When NOT to use**: This is an AI-era-specific pattern (first appeared Fall 2024). In the Certifiable Inc. challenge, where the problem was more structured (certification grading), a multi-agent approach placed as runner-up while simpler service-based approaches won 1st and 2nd.

---

## Communication Patterns

Communication pattern choices, derived from architecture styles and technology selections across all sources:

| Pattern | KataLog Teams | KataLog Weighted Score | KataLog Avg | 1st Place | Production Examples |
|---------|---------------|----------------------|-------------|-----------|-------------------|
| **Asynchronous Messaging** | 47 | 94 | 2.00 | 9 | NGINX (event-driven I/O), ZeroMQ (broker-less pub/sub), Bitwarden (AMQP), Squidex (event sourcing) |
| **Synchronous REST/API** | ~55 | ~100 | ~1.82 | 10 | Bitwarden (REST API), Selenium (WebDriver protocol), all RealWorld apps |
| **Hybrid Sync+Async** | ~30 | ~60 | ~2.00 | 7 | Bitwarden (REST + AMQP), Graphite (REST query + pipeline ingestion) |
| **Pipeline/Streaming** | 0 | 0 | -- | 0 | NGINX (filter chain), LLVM (pass pipeline), GStreamer (element graph), Graphite (Carbon ingestion) |
| **GraphQL** | 5 | 9 | 1.80 | 1 | (no production evidence in this base) |
| **MQTT/IoT Protocols** | 3 | 5 | 1.67 | 0 | (no production evidence in this base) |
| **WebSockets/SSE** | 4 | 8 | 2.00 | 1 | (no production evidence in this base) |

**Key finding**: Synchronous REST is near-universal. The differentiating factor is whether teams also incorporate asynchronous messaging. Winners explicitly designed for async communication at 73% rates (vs. ~50% for runners-up). Production systems heavily favor pipeline/streaming patterns (4 of 12 AOSA projects) that are completely absent from competition designs.

---

## Data Strategy Patterns

| Strategy | KataLog Teams | KataLog Weighted Score | KataLog Avg | Top Exemplar | Production Evidence |
|----------|---------------|----------------------|-------------|--------------|-------------------|
| **Relational (PostgreSQL/MySQL/RDS)** | ~18 | 30 | 1.67 | Team Seven (1st), Pragmatic (1st) | nopCommerce (SQL Server), Bitwarden (SQL Server/PostgreSQL) |
| **NoSQL (DynamoDB/MongoDB/CosmosDB)** | ~17 | 35 | 2.06 | ArchColider (1st), ConnectedAI (1st) | Squidex (MongoDB event store), Riak (distributed key-value) |
| **Time-Series (InfluxDB)** | 3 | 8 | 2.67 | BluzBrothers (1st) | Graphite (Whisper time-series DB) |
| **Graph Database (Neo4j/Neptune)** | 4 | 6 | 1.50 | The Archangels (1st) | (no production evidence in this base) |
| **Event Sourcing** | 3 | 8 | 2.67 | ArchColider (1st) | Squidex (immutable event store on MongoDB) |
| **CQRS (read/write separation)** | 4 | 7 | 1.75 | Miyagi's Little Forests (2nd) | Squidex (read models projected from events) |
| **Vector DB/RAG** | ~8 | 21 | 2.63 | ZAITects (1st) | (no production evidence in this base) |
| **Shared Database** | ~25 | 43 | 1.72 | Team Seven (1st) | Bitwarden (9 services, shared database) |

**Key finding**: NoSQL databases have a higher KataLog average (2.06) than relational (1.67). Production evidence shows both in heavy use: nopCommerce and Bitwarden on relational; Squidex and Riak on NoSQL. Bitwarden's shared-database pattern (9 services, one database) validates the Service-Based approach over Microservices' database-per-service orthodoxy. Time-series databases achieve the highest per-team KataLog average (2.67), confirmed by Graphite's production Whisper storage.

---

## Deployment Patterns

| Pattern | KataLog Teams | Weighted Score | Avg Score | 1st Place Uses | Production Evidence |
|---------|---------------|----------------|-----------|----------------|-------------------|
| **Cloud-Native** (AWS/Azure/GCP specified) | 46 | 76 | 1.65 | 5 | Bitwarden (self-hosted + cloud), Squidex (Docker/cloud) |
| **Cloud-Agnostic/Unspecified** | 30 | 65 | 2.17 | 6 | NGINX (bare metal/container/cloud), Riak (on-premises clusters) |
| **On-Premises** | 2 | 4 | 2.00 | 0 | Jellyfin (self-hosted media), nopCommerce (on-premises + cloud) |
| **Plugin-Based Deployment** | 0 | 0 | -- | 0 | LLVM (plugins loaded by host), GStreamer (plugins discovered at runtime), Jellyfin (plugin packages) |

**Cloud provider breakdown** (KataLog teams specifying a provider):

| Provider | Teams | Weighted Score | 1st Place |
|----------|-------|----------------|-----------|
| **AWS** | 40+ | 130 | 7 |
| **Azure** | 8 | 22 | 0 |
| **GCP** | 6 | 18 | 3 |

**Key finding**: Cloud-agnostic KataLog teams score higher on average (2.17) than cloud-native teams (1.65), suggesting judges reward architectural thinking over vendor-specific implementation. Production evidence shows deployment diversity: NGINX runs everywhere (bare metal to Kubernetes), Jellyfin is primarily self-hosted, while Bitwarden offers both self-hosted and cloud. Plugin-based deployment -- where extensions are dynamically loaded at runtime rather than deployed as independent services -- is a production-dominant pattern (LLVM, GStreamer, Jellyfin) invisible in competition data.

---

## Style Combination Patterns

Teams frequently combine multiple architecture styles. Cross-source evidence reveals which combinations work.

### Top Style Combinations by Weighted Score (KataLog)

| Combination | Teams | Weighted Score | Avg Score | Notable Results |
|-------------|-------|----------------|-----------|-----------------|
| **Event-Driven + Service-Based** | 7 | 18 | 2.57 | 3 first-place teams (Pragmatic, ZAITects, Team Seven) |
| **Event-Driven + Microservices** | 17 | 22 | 1.29 | Most common combo, but lowest avg score |
| **CQRS/Event Sourcing + DDD + Modular Monolith** | 1 | 4 | 4.00 | ArchColider (1st) |
| **Event-Driven + Microservices + Multi-Agent** | 1 | 4 | 4.00 | ConnectedAI (1st) |
| **Event-Driven + Modular Monolith (evolving to Microservices)** | 1 | 4 | 4.00 | PegasuZ (1st) |

### Production Style Combinations (AOSA + RealWorld)

| Combination | Systems | Evidence |
|-------------|---------|----------|
| **Pipeline + Plugin** | LLVM, GStreamer, Jellyfin | The dominant production combination. Pipeline provides the processing flow; plugins provide independently replaceable stages. Combined score: 244 pts. |
| **Plugin + Layered** | nopCommerce | Layered internal structure with plugin extensibility for payments, shipping, taxes. |
| **Plugin + Modular Monolith** | Orchard Core | Monolith host with module/plugin architecture for feature composition. |
| **Event-Driven + Service-Based** | Bitwarden | AMQP events for cross-service coordination within a service-based decomposition. |
| **Pipeline + Service-Based** | Graphite | Three independent pipeline stages (Carbon, Whisper, web) deployable as separate services. |
| **Event-Driven + Pipeline** | NGINX | Event loop dispatches requests into the filter pipeline. |

**Key findings:**

1. **Pipeline + Plugin is the dominant production combination** (LLVM, GStreamer, Jellyfin) -- yet it has zero KataLog representation. This is the sharpest design-production gap for combinations.
2. **Event-Driven + Service-Based** (avg 2.57 in KataLog) dramatically outperforms **Event-Driven + Microservices** (avg 1.29). Bitwarden's production architecture confirms this: service-based + events beats microservices + events.
3. **Three or more complementary styles** (avg 2.36-2.67 in KataLog) outperform single-style or two-style approaches. Winners combine styles thoughtfully.
4. **Every first-place KataLog winner with Modular Monolith** combined it with at least one other style as an evolution target. The "Modular Monolith + [distributed target]" pattern is undefeated.

### Number of Styles vs. Placement (KataLog)

| Style Count | Teams | Weighted Score | Avg Score |
|-------------|-------|----------------|-----------|
| 0 canonical styles | 2 | 3 | 1.50 |
| 1 style | 30 | 56 | 1.87 |
| 2 styles | 31 | 51 | 1.65 |
| 3 styles | 11 | 26 | 2.36 |
| 5 styles | 3 | 8 | 2.67 |

---

## Anti-Patterns: What Doesn't Work

Based on evidence from all five sources, these patterns consistently correlate with poor outcomes.

### 1. Microservices Without Event-Driven Architecture
**KataLog evidence**: 10 teams used Microservices without EDA. Average placement score: 1.70 (vs. 2.00 for EDA teams overall). Only 1 first-place win.
**Production evidence**: Systems that could adopt microservices (Bitwarden with 9 services) choose service-based with event-driven instead. Zero production systems in the evidence base use microservices as a primary style.
**Why it fails**: Pure synchronous microservices create tight coupling through REST chains. Production systems demonstrate that asynchronous decoupling is essential for the quality attributes microservices are supposed to deliver.

### 2. Over-Reliance on Scalability as Primary Quality Attribute
**KataLog evidence**: Scalability is cited by 68% of runners-up but only 55% of first-place winners. The "Scalability Trap."
**Production evidence**: AOSA and RealWorldASPNET systems achieve scalability through *specific mechanisms* (HDFS block replication, Riak consistent hashing, NGINX event loops, nopCommerce caching layers) rather than through architecture style selection. Discovered reinforces this -- scalability is the most-cited quality attribute, yet repos achieve it through infrastructure choices (Kubernetes, Redis) rather than architectural structure.
**Why it fails**: Choosing Microservices "for scalability" is the design equivalent of choosing Kubernetes "for reliability" -- the abstraction level is wrong.

### 3. Zero ADRs or Minimal Decision Documentation
**KataLog evidence**: Teams with zero ADRs never placed higher than Runner-up/3rd. Teams averaging fewer than 5 ADRs rarely place in top 2.
**Cross-source evidence**: Only ~5 of 122 Discovered repos have ADR directories. 1 of 8 Reference Architectures includes ADRs. The practice most correlated with success has minimal representation in learning materials across all five sources.
**Why it fails**: ADRs demonstrate architectural reasoning. Without them, judges cannot evaluate trade-off thinking.

### 4. Technology-First Architecture
**KataLog evidence**: Teams like Los Ingenials (21 ADRs, runner-up) specified extensive technology stacks but placed as runners-up. Flagged as "possibly over-engineered."
**Production evidence**: Production systems use pragmatic technology choices aligned to their domain. Bitwarden uses a shared SQL database despite having 9 services. Graphite uses three simple components. Technology selection follows architecture, not the reverse.
**Why it fails**: Listing AWS services or naming every framework does not demonstrate architectural judgment. Winners focus on the "why" (quality attribute trade-offs) rather than the "what" (specific products).

### 5. Big-Bang Architecture Without Evolution Path
**KataLog evidence**: 73% of winners list two or more architecture styles and propose phased approaches. Teams proposing only a target-state architecture rarely placed in top 2.
**Production evidence**: Production systems evolved organically. LLVM's pass/plugin architecture enables incremental addition of language frontends and optimization passes. Orchard Core's module system allows features to be added without modifying the host. Production longevity requires evolutionary capability.
**Why it fails**: Judges value pragmatism. A perfect target without a realistic path from the present is less valuable than an achievable initial architecture with a clear evolution roadmap.

### 6. Ignoring Production-Proven Patterns
**Cross-source evidence**: Pipeline (#3 overall) and Plugin (#2 overall) are invisible in KataLog yet dominate production. Teams defaulting to Microservices + Event-Driven without considering Pipeline (for data flow problems) or Plugin (for extensibility problems) miss patterns that have been validated at massive scale.
**Why it fails**: Competition discourse creates a recency bias toward named patterns (Microservices, Serverless). The most battle-tested patterns (Pipeline in NGINX/LLVM/GStreamer, Plugin in LLVM/SQLAlchemy/Jellyfin) predate modern architecture naming conventions but solve real problems more effectively.

### 7. Missing Deployment View
**KataLog evidence**: 82% of first-place teams include a deployment view vs. 50% of runners-up.
**Production evidence**: Every AOSA and RealWorld system has a concrete deployment model. Production forces deployment decisions that design exercises allow teams to defer.
**Why it fails**: A deployment view demonstrates that the architecture has been thought through to implementation level. Its absence suggests the architecture exists only in the abstract.

---

## Appendix: Per-Challenge Style Performance

### Farmacy Food (Fall 2020, 10 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Microservices | 6 | 9 | No (ArchColider used Modular Monolith) |
| Event-Driven | 5 | 8 | No |
| Modular Monolith | 1 | 4 | **Yes** (ArchColider, 1st) |
| DDD | 2 | 7 | **Yes** |
| CQRS/Event Sourcing | 2 | 7 | **Yes** |
| Serverless | 2 | 2 | No |

### Sysops Squad (Spring 2021, 7 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Service-Based | 6 | 14 | **Yes** (Team Seven, 1st) |
| Event-Driven | 2 | 5 | **Yes** |
| Microservices | 2 | 2 | No |

### Farmacy Family (Fall 2021, 7 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Event-Driven | 4 | 9 | **Yes** (The Archangels, 1st) |
| Service-Based | 3 | 6 | No (2nd, Runner-up) |
| Hexagonal/Clean | 1 | 2 | No (3rd) |
| Serverless | 1 | 1 | No |

### Spotlight Platform (Spring 2022, 8 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Microservices | 6 | 12 | **Yes** (PegasuZ, 1st) |
| Event-Driven | 5 | 9 | **Yes** (PegasuZ long-term) |
| Modular Monolith | 2 | 5 | **Yes** (PegasuZ MVP) |
| CQRS | 1 | 1 | No |
| Hexagonal | 1 | 1 | No |
| Serverless | 2 | 3 | No |

### Hey Blue! (Fall 2022, 6 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Event-Driven | 5 | 11 | **Yes** (MonArch, 1st) |
| Microservices | 4 | 9 | **Yes** |
| Modular Monolith | 1 | 4 | **Yes** (initial phase) |
| Hexagonal/Clean | 1 | 4 | **Yes** |
| Serverless | 3 | 6 | **Yes** |
| DDD | 1 | 3 | No (IPT, 2nd) |

### Wildlife Watcher (Fall 2023, 6 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Microservices | 4 | 9 | **Yes** (CELUS Ceals, 1st) |
| Event-Driven | 3 | 4 | No |
| Modular Monolith | 2 | 5 | No |
| Microkernel/Plugin | 1 | 2 | No |
| Service-Based | 1 | 1 | No |

### Road Warrior (Fall 2023 External, 9 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Event-Driven | 8 | 14 | **Yes** (Profitero Data Alchemists, 1st) |
| Microservices | 7 | 10 | No (winner used only EDA) |
| Space-Based | 1 | 3 | No (Iconites, 2nd) |
| Service-Based | 1 | 1 | No |

### MonitorMe (Winter 2024, 7 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Event-Driven | 7 | 14 | **Yes** (BluzBrothers, 1st) |
| Microservices | 3 | 5 | No |
| Service-Based | 1 | 1 | No |

### ShopWise AI Assistant (AI Winter 2024, 4 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Multi-Agent | 2 | 7 | **Yes** (ConnectedAI, 1st) |
| Event-Driven | 1 | 4 | **Yes** |
| Microservices | 1 | 4 | **Yes** |

### ClearView (Fall 2024, 7 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Event-Driven | 5 | 11 | **Yes** (Pragmatic, 1st -- selective) |
| Service-Based | 3 | 6 | **Yes** |
| Microservices | 3 | 4 | No |

### Certifiable Inc. (Winter 2025, 7 teams)
| Style | Teams | Weighted Score | Winner Used? |
|-------|-------|----------------|--------------|
| Service-Based | 6 | 14 | **Yes** (ZAITects, 1st) |
| Event-Driven | 2 | 5 | **Yes** |
| Microservices | 1 | 1 | No |
| Microkernel/Plugin | 1 | 2 | No (3rd) |
| Multi-Agent | 1 | 1 | No (runner-up) |

---

*Generated: 2026-03-05 from 225 entries across 5 evidence sources: 78 KataLog competition submissions (Fall 2020 -- Winter 2025), 12 AOSA production systems (Volumes 1-2, 2011-2012), 5 RealWorldASPNET production applications, 8 reference implementations, and 122 Discovered open-source repositories.*
