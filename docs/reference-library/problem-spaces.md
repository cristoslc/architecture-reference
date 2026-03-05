# Problem Space Taxonomy

A reference classification of problem profiles derived from 122 production codebases across 35 domains, validated by 17 production-narrated systems and structured competition reasoning from 78 team submissions. Use this document to find the problem profile that most closely resembles your own, then study the corresponding solution patterns in the [Solution Space Taxonomy](solution-spaces.md) and [Problem-Solution Matrix](problem-solution-matrix.md).

---

## How to Use This Document

1. **Start with the Discovered domain distribution.** The Classification Matrix opens with statistical evidence from 122 real codebases organized into 35 domains. Find the domain cluster closest to your problem. The "Top Styles" column shows which architecture styles actually appear in production systems solving that kind of problem.

2. **Check for production-validated depth.** If an AOSA or RealWorld production system matches your domain, read its Detailed Problem Profile. These 17 systems have published architectural reasoning from their creators -- the highest-authority evidence in the library.

3. **Study competition reasoning for trade-off analysis.** The 11 KataLog competition challenges provide structured problem decomposition rarely available in production repos -- explicit requirements, constraint documentation, cost projections, and judge commentary. These qualitative insights explain *why* certain patterns work.

4. **Use the Problem Similarity Clusters.** The similarity analysis groups profiles by shared problem dimensions across all 5 sources, grounded in Discovered domain clusters. If your problem matches one profile strongly, the cluster members provide additional solution evidence from different evidence types.

5. **Explore the Dimension Deep Dives.** The deep-dive sections group profiles by each dimension and extract the architectural patterns that emerge at each tier, leading with Discovered domain statistics and supplemented by production and competition evidence.

6. **Cross-reference other library docs.** The [Evidence by Architecture Style](evidence/by-architecture-style.md) and [Evidence by Quality Attribute](evidence/by-quality-attribute.md) documents provide complementary views. The [Cross-Source Analysis](evidence/cross-source-analysis.md) shows where evidence sources agree or disagree.

> **Detection bias:** Discovered statistics are derived from automated filesystem analysis. Styles and QAs that leave strong filesystem signals (Docker -> Deployability, module boundaries -> Modularity) are overrepresented. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this gap -- teams documented these invisible decisions in ADRs and presentations.

---

## Dimension Definitions

| Dimension | Definition | Scale | Examples |
|-----------|-----------|-------|----------|
| **Domain Type** | The industry or functional area the system serves | Categorical | Healthcare, E-Commerce, IoT, FinTech, DevTools, Media, Infrastructure |
| **Scale** | Expected user base, transaction volume, or data throughput at maturity | Ordinal: Small / Small-Medium / Medium / Medium-Large / Large / Very Large | Small: single store; Medium: thousands of users; Large: millions; Very Large: 15M+ users |
| **Budget Context** | The financial constraints and organizational type shaping architecture decisions | Categorical | Startup, Non-Profit, Established Enterprise, Open-Source Community |
| **Compliance** | Regulatory, legal, and ethical constraints the architecture must satisfy | Varies | HIPAA, GDPR, PCI-DSS, SOX, food safety, certification integrity, geoprivacy |
| **Integration Complexity** | Number and heterogeneity of external systems the architecture must connect to | Ordinal: Low / Medium / High / Very High | Low: 1-2 systems; Medium: 3-5; High: 5-8; Very High: 8+ or unbounded |
| **Real-time Needs** | Whether the system requires sub-second or near-real-time data processing | Ordinal: None / Low / Medium / High / Critical | None: batch only; Low: minutes acceptable; Medium: seconds acceptable; High: sub-second needed; Critical: lives depend on latency |
| **Edge/Offline** | Whether the system must operate in disconnected or resource-constrained environments | Boolean + context | Yes: smart fridges, wildlife cameras, hospital appliances; No: cloud-only |
| **AI/ML Component** | The role of AI or machine learning in the system | Ordinal: None / Peripheral / Supporting / Central | None: no AI; Peripheral: recommendation engine as nice-to-have; Supporting: AI enhances core workflow; Central: AI is the core value proposition |
| **Greenfield/Brownfield** | Whether the system is being built from scratch or extending/replacing an existing system | Categorical | Greenfield, Brownfield (migration), Brownfield (extension), Hybrid |
| **Key Tension** | The central architectural trade-off that teams must resolve | Free text | The one dilemma that, if resolved wrong, undermines the entire architecture |

---

## Classification Matrix

### Discovered Domain Distribution (122 repos, 35 domains)

Evidence type: **automated discovery** -- architecture signals extracted from 122 public GitHub repositories via the dataset scaling pipeline. This is the primary problem taxonomy: domains derived from actual production codebases answer the question "what problems do real systems solve?"

| Domain Cluster | Repos | Top Styles | Representative Repos |
|----------------|-------|------------|---------------------|
| **Developer Tools** | 36 | Event-Driven (21), DDD (13), CQRS (11), Hexagonal (10), Modular Monolith (9), Layered (9) | ABP, Backstage, Dapr, GitLab, Supabase, Appwrite, LocalStack, serverless frameworks, clean architecture templates |
| **E-Commerce** | 11 | Event-Driven (6), CQRS (4), Microservices (4), Modular Monolith (4), DDD (3) | eShop, eShopOnContainers, Medusa, nopCommerce, Saleor, Shopware, Spree |
| **Infrastructure** | 7 | Microservices (4), Event-Driven (4), Pipe-and-Filter (4) | Consul, Envoy, Istio, Linkerd2, Traefik, Zuul, Eureka |
| **AI/ML** | 6 | Event-Driven (5), Multi-Agent (4), Layered (3) | AutoGPT, autogen, camel, crewAI, dify, letta |
| **Data Grid** | 6 | Space-Based (5), Event-Driven (4), Modular Monolith (2) | Redis, Dragonfly, Hazelcast, Ignite, Infinispan, Geode |
| **Workflow Orchestration** | 5 | Event-Driven (5), Microservices (4), DDD (4) | Airflow, Argo Workflows, Conductor, Prefect, Temporal |
| **Data Processing** | 5 | Microservices (5), Event-Driven (5), Pipe-and-Filter (4) | Apache Beam, Apache Flink, Dagster, Mage AI, Pachyderm |
| **Messaging** | 5 | Event-Driven (4), Modular Monolith (2), Microservices (2) | NATS, Pulsar, RabbitMQ, Redpanda, Mattermost |
| **CMS** | 4 | Modular Monolith (3), Layered (2), Event-Driven (2) | Squidex, OrchardCore, Directus, Strapi |
| **Social Media** | 4 | Event-Driven (4), Layered (3), Modular Monolith (2) | ddd-forum, Discourse, Forem, Mastodon |
| **Observability** | 3 | Microservices (2), Event-Driven (2), Pipe-and-Filter (2) | Grafana, Elasticsearch, Sentry (self-hosted) |
| *25 more domains* | 30 | Varies | Banking (2), Customer Support (2), Database (2), Data Integration (2), Food Delivery (2), Finance (2), + 19 single-repo domains |

**Key statistical findings:**
- Developer Tools dominates at 30% of the corpus (36/122), suggesting that architecture frameworks and templates are the most common open-source contribution pattern
- E-Commerce is the most cross-validated domain (evidence from 4 of 5 sources)
- Event-Driven appears in the top styles for 9 of the 10 largest domain clusters
- The long tail of 25 domains with 1-3 repos each accounts for 25% of the corpus, reflecting the diversity of real-world problem spaces

---

### Production-Validated Profiles (AOSA + RealWorld, 17 systems)

Evidence type: **production narrative** -- architectural descriptions written by system creators who built, deployed, and operated these systems. Highest individual authority per system.

| System | Source | Domain | Scale | Styles | Key Tension |
|--------|--------|--------|-------|--------|-------------|
| LLVM | AOSA | Compiler Infrastructure | Very Large | Pipeline, Modular, Plugin | Extensibility of IR vs. compilation performance across dozens of targets |
| HDFS | AOSA | Distributed Storage | Very Large | Primary-Secondary, Data Replication | Fault tolerance at commodity hardware scale vs. write throughput |
| Riak | AOSA | Distributed Database | Large | Peer-to-Peer, Eventual Consistency | Availability vs. consistency in partitioned networks (CAP) |
| Selenium WebDriver | AOSA | Testing / Browser Automation | Very Large | Service-Based, Adapter Pattern | Unified API vs. browser-specific behavior divergence |
| Graphite | AOSA | Monitoring / Metrics | Large | Pipeline, Service-Based | Storage efficiency vs. query flexibility for time-series data |
| NGINX | AOSA | Web Infrastructure | Very Large | Event-Driven, Pipeline | C10K concurrency vs. memory efficiency on single machines |
| Git | AOSA | Version Control | Very Large | Content-Addressable, DAG | Distributed workflow integrity vs. repository scale and merge complexity |
| ZeroMQ | AOSA | Messaging | Large | Broker-less Messaging, Pipeline | Zero-copy performance vs. multi-pattern messaging flexibility |
| Twisted | AOSA | Networking Framework | Large | Event-Driven, Reactor Pattern | Async programming complexity vs. protocol diversity support |
| SQLAlchemy | AOSA | Database / ORM | Large | Layered, Plugin | ORM convenience vs. SQL expressiveness and database portability |
| Puppet | AOSA | Config Management | Large | Declarative Configuration, Client-Server | Declarative simplicity vs. imperative escape hatches |
| GStreamer | AOSA | Multimedia / Streaming | Large | Pipeline, Plugin | Pipeline flexibility vs. real-time media performance guarantees |
| Squidex | RealWorld | Headless CMS | Medium-Large | CQRS, Event Sourcing, Event-Driven | Event sourcing complexity vs. content management flexibility |
| Bitwarden Server | RealWorld | Security / Password Mgmt | Very Large | Service-Based, Event-Driven | Zero-knowledge encryption vs. usable cross-device sync at scale |
| Jellyfin | RealWorld | Media Server | Large | Plugin, Pipeline, Client-Server | Plugin extensibility vs. real-time transcoding performance |
| Orchard Core | RealWorld | CMS / App Framework | Medium-Large | Modular Monolith, Plugin | Module isolation vs. shared-state performance |
| nopCommerce | RealWorld | E-Commerce | Large | Plugin, Layered | Plugin ecosystem stability vs. framework evolution over 17 years |

**Discovered domain coverage of production systems:** 12 of 17 production systems have Discovered repos in matching domains (E-Commerce: 11, Infrastructure: 7, Messaging: 5, CMS: 4, Developer Tools: 36, Observability: 3). This cross-validation strengthens confidence in both Discovered patterns and production narratives.

---

### Competition Problem Profiles (KataLog, 11 challenges, 78 team submissions)

Evidence type: **competition design** -- teams designed architectures under time constraints for fictional scenarios. These competition challenges provide structured problem decomposition rarely available in production repos: explicit requirement enumeration, constraint documentation, cost projections, and judging criteria. Valued for qualitative reasoning about trade-offs.

| Challenge | Domain Type | Scale | Budget | Key Tension | Teams | Qualitative Insight |
|-----------|-------------|-------|--------|-------------|-------|-------------------|
| Farmacy Food | Food / Logistics | Small-Large | Startup | Scale cheaply now vs. architect for national growth | 8 | Winner chose modular monolith to avoid premature distributed complexity |
| Sysops Squad | Enterprise IT / Field Service | Large | Enterprise | Migrate a failing monolith without losing the business | 7 | 6/7 teams converged on service-based; transition path > destination |
| Farmacy Family | Health / Community | Small-Medium | Startup | Startup budget vs. enterprise-grade health compliance | 7 | Kafka as integration backbone in 5/7 submissions |
| Spotlight Platform | Non-Profit / HR Tech | Medium | Non-Profit | Non-profit budget vs. platform ambition | 7 | Winner projected $0.002/user/month; cost analysis separated winners |
| Hey Blue! | Civic Tech / Social Impact | Large-Very Large | Non-Profit | Real-time officer safety vs. community engagement at scale | 7 | In-memory graph DB for O(log n) proximity lookups |
| Wildlife Watcher | Conservation / IoT | Small-Medium | Non-Profit | Ultra-constrained edge hardware vs. cloud AI sophistication | 7 | 512KB Flash + LoRaWAN = architecture-defining constraint |
| Road Warrior | Travel / Consumer | Very Large | Startup | 99.99% availability at startup cost | 5 | 4,000 email filtering requests/second drove architecture |
| MonitorMe | Healthcare / MedTech | Medium | Enterprise | Life-critical latency on constrained on-premises hardware | 4 | 693ms end-to-end latency proven via fitness functions |
| ShopWise AI | Retail / E-Commerce | Small | Not specified | AI accuracy and cost vs. rapid prototyping | 4 | All teams converged on text-to-SQL; dual-LLM for cost |
| ClearView | HR / AI Bias Reduction | Medium | Non-Profit | LLM cost/non-determinism vs. bias-free hiring at non-profit budget | 4 | Deterministic matching reduced LLM calls from O(n*m) to O(n+m) |
| Certifiable Inc. | EdTech / Certification | Medium-Large | Enterprise (thin margins) | AI autonomy vs. career-affecting accuracy in high-stakes grading | 4 | Universal human-in-the-loop; no team proposed fully autonomous AI |

---

### Reference Architecture Profiles (RefArch, 8 repos)

Evidence type: **reference implementation** -- curated repositories serving as canonical pattern examples with working, deployable code.

| Project | Domain Type | Scale | Styles | Key Tension |
|---------|-------------|-------|--------|-------------|
| eShopOnContainers | E-Commerce | Medium-Large | Microservices, Event Bus, CQRS | Microservices coordination complexity vs. domain isolation |
| eShop | E-Commerce | Medium-Large | Simplified Microservices | Modern .NET simplification vs. distributed systems patterns |
| Modular Monolith w/ DDD | Conference Management | Medium | Modular Monolith, DDD, CQRS | Module boundary enforcement vs. cross-cutting concern sharing |
| Clean Architecture Template | Task Management | Small-Medium | Clean/Hexagonal | Clean Architecture purity vs. pragmatic shortcuts |
| BuckPal | Banking / Money Transfer | Small | Hexagonal | Hexagonal port abstraction overhead vs. domain model purity |
| Wild Workouts | Fitness / Workout Scheduling | Small-Medium | Microservices, DDD | DDD tactical patterns overhead vs. Go idioms |
| Serverless Microservices | Ride-Sharing | Medium-Large | Serverless, Event-Driven | Serverless cold-start latency vs. event-driven scalability |
| AKS Baseline Cluster | Container Platform | Large | Kubernetes | Kubernetes operational complexity vs. workload isolation |

---

## Detailed Problem Profiles

### Discovered Domain Cluster Profiles

#### Developer Tools Cluster (36 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: The largest domain cluster in the corpus, representing 30% of all 122 repos. Event-Driven is the most common style (21 repos), followed by Domain-Driven Design (13), CQRS (11), Hexagonal Architecture (10), Modular Monolith (9), and Layered (9).

**Representative projects**: ABP, Backstage, Dapr, GitLab, Supabase, Appwrite, NocoDB, Gitpod, LocalStack, serverless frameworks, clean architecture templates (11 repos across C#, Go, Java, TypeScript).

**Problem profile**: Developer tools and frameworks face a unique problem: they must be extensible enough for diverse use cases while maintaining opinionated enough defaults to be useful out of the box. The 36 repos split into two sub-clusters:
- **Framework/platform tools** (ABP, Backstage, Dapr, Supabase, Appwrite): Microservices or Service-Based with Event-Driven integration. These are tools developers deploy as infrastructure.
- **Clean architecture templates** (11+ repos): Hexagonal Architecture, DDD, CQRS. These are educational/starter implementations that demonstrate patterns.

**Key tension**: Framework extensibility vs. opinionated conventions. The most successful tools (Backstage at confidence 1.0, Dapr at 1.0) achieve both through plugin/extension models.

**Production depth**: AOSA provides the foundational production evidence -- Git (developer tool), SQLAlchemy (developer framework), GStreamer (plugin-based framework) all demonstrate how successful developer tools balance extensibility with coherence. RefArch's Clean Architecture Template serves the same audience as the Discovered template repos.

---

#### E-Commerce Cluster (11 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 11 repos (9% of corpus), the most cross-validated domain with evidence from 4 of 5 sources. Event-Driven (6 repos), CQRS (4), Microservices (4), Modular Monolith (4), DDD (3).

**Representative projects**: eShop, eShopOnContainers, eShopOnWeb, go-ecommerce-microservices, Medusa, NorthwindTraders, nopCommerce, Saleor, Shopware, Spree, microservices-demo.

**Problem profile**: The Discovered cluster reveals a clear architectural spectrum: simple layered monoliths (eShopOnWeb) -> modular monoliths (Medusa, Saleor, Shopware, Spree) -> microservices (eShop, go-ecommerce-microservices, microservices-demo). This spectrum matches the KataLog finding that scale drives architecture style selection.

**Key tension**: The monolith-to-microservices migration path. The cluster contains examples at every point on the spectrum, making it the best domain for studying evolutionary architecture.

**Production depth**: nopCommerce (RealWorld) demonstrates 17 years of evolution within the Plugin + Layered approach. eShopOnContainers -> eShop shows Microsoft's own migration from complex microservices to simplified microservices.

**Competition reasoning**: KataLog's ShopWise AI explored AI engineering in e-commerce (text-to-SQL, multi-agent). KataLog's Farmacy Food tested food logistics at startup scale.

---

#### Infrastructure Cluster (7 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 7 repos (6% of corpus). Microservices (4), Event-Driven (4), Pipe-and-Filter (4). All operate at Very Large scale with High real-time performance requirements.

**Representative projects**: Consul, Envoy, Istio, Linkerd2, Traefik, Zuul, Eureka.

**Problem profile**: Service mesh, API gateway, and service discovery tools that sit in the critical path of every request in a microservices deployment. These systems must add observability, traffic control, and security without introducing unacceptable latency overhead.

**Key tension**: Proxy overhead vs. observability and traffic control. Every millisecond of proxy latency is multiplied by every request in the system. Envoy and Istio (both at confidence 1.0) demonstrate the sidecar proxy pattern; Traefik demonstrates the edge proxy pattern; Consul and Eureka demonstrate service discovery without proxy overhead.

**Production depth**: AOSA's NGINX is the foundational production evidence for high-performance request processing. RefArch's AKS Baseline Cluster demonstrates Kubernetes-native infrastructure. Puppet (AOSA) demonstrates the declarative infrastructure management pattern these tools build upon.

---

#### AI/ML Cluster (6 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 6 repos (5% of corpus), the newest domain cluster. Event-Driven (5 repos), Multi-Agent (4), Layered (3). The Multi-Agent style (4 of 6 repos) is unique to this cluster -- it does not appear in any other source.

**Representative projects**: AutoGPT, autogen, camel, crewAI, dify, letta.

**Problem profile**: AI agent frameworks and platforms that orchestrate LLM-powered agents for complex tasks. All repos emerged post-2023. The Multi-Agent style is unique to this cluster.

**Key tension**: Multi-agent coordination vs. single-agent simplicity. AutoGPT and crewAI represent the multi-agent extreme; dify represents the pipeline/workflow approach to AI orchestration.

**Competition reasoning**: KataLog's AI katas (ShopWise AI, ClearView, Certifiable Inc.) explored this same tension through competition designs. ShopWise AI's multi-agent vs. pipeline comparison, ClearView's deterministic boundaries around non-deterministic AI, and Certifiable Inc.'s LLM-as-a-Judge pattern provide the qualitative reasoning for trade-offs that Discovered's code-level evidence cannot capture.

---

#### Data Grid Cluster (6 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 6 repos (5% of corpus). Space-Based (5 repos), Event-Driven (4), Modular Monolith (2). Space-Based architecture is nearly exclusive to this cluster -- 5 of 7 total Space-Based repos in the corpus are data grids.

**Representative projects**: Redis, Dragonfly, Hazelcast, Apache Ignite, Infinispan, Apache Geode.

**Problem profile**: In-memory data grids and caching systems that provide sub-millisecond data access at extreme scale. These systems prioritize memory efficiency and data distribution over persistence durability.

**Key tension**: Memory efficiency vs. data distribution and consistency. Redis and Dragonfly use single-threaded event loops (like NGINX) for simplicity; Hazelcast and Geode use partitioned data distribution for scale. Consistency models range from strong (Ignite) to eventual (Redis).

**Production depth**: AOSA's Riak demonstrates the same availability-vs-consistency trade-off at the database level. AOSA's NGINX demonstrates the same event-driven single-thread model that Redis uses.

**Competition reasoning**: KataLog profiles requiring real-time data (Hey Blue!'s proximity lookup, MonitorMe's vital signs) would benefit from Space-Based patterns proven in this cluster.

---

#### Workflow Orchestration Cluster (5 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 5 repos (4% of corpus). Event-Driven (5 repos), Microservices (4), DDD (4). The cluster splits between DAG-based orchestrators (Airflow, Argo, Prefect) and event-driven workflow engines (Temporal, Conductor).

**Representative projects**: Airflow, Argo Workflows, Conductor, Prefect, Temporal.

**Problem profile**: Systems that define, schedule, and execute complex multi-step workflows. All face the fundamental challenge of making workflows reliable when individual steps can fail, retry, or timeout.

**Key tension**: Workflow definition flexibility vs. execution reliability. Airflow's Python-based DAG definitions maximize flexibility but can create untestable workflows. Temporal's deterministic replay model maximizes reliability but constrains workflow definition patterns.

**Production depth**: Puppet (AOSA) demonstrates the declarative-vs-imperative trade-off in infrastructure workflows. RefArch's Serverless Microservices reference uses event-driven orchestration for ride-sharing.

**Competition reasoning**: KataLog profiles with complex workflows (Sysops Squad ticket routing, Certifiable Inc. grading pipeline) face similar orchestration decisions.

---

#### Data Processing Cluster (5 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 5 repos (4% of corpus). Microservices (5 repos), Event-Driven (5), Pipe-and-Filter (4), DDD (2). Pipe-and-Filter is the defining pattern, reflecting the domain's inherent nature: data flows through transformation stages.

**Representative projects**: Apache Beam, Apache Flink, Dagster, Mage AI, Pachyderm.

**Problem profile**: Stream and batch data processing frameworks that handle high-throughput data transformation. These systems must balance processing guarantees (exactly-once, at-least-once) against throughput requirements.

**Key tension**: Exactly-once processing guarantees vs. throughput. Beam and Flink provide exactly-once semantics at the cost of complexity; simpler systems like Mage AI trade guarantees for developer experience.

**Production depth**: AOSA's LLVM demonstrates Pipeline at compilation scale. AOSA's Graphite demonstrates Pipeline for metrics ingestion. GStreamer (AOSA) demonstrates Pipeline for media processing.

---

#### Messaging Cluster (5 repos) [CODE-LEVEL EVIDENCE]

**Discovered prevalence**: 5 repos (4% of corpus). Event-Driven (4 repos), Modular Monolith (2), Microservices (2). The cluster splits between high-throughput log-based brokers (Pulsar, Redpanda) and traditional message brokers (RabbitMQ, NATS).

**Representative projects**: NATS, Apache Pulsar, RabbitMQ, Redpanda, Mattermost.

**Problem profile**: Message brokers and event buses that provide reliable asynchronous communication between distributed components. Mattermost represents application-level messaging (team chat) built on similar infrastructure patterns.

**Key tension**: Delivery guarantees vs. throughput and latency. Pulsar and Redpanda provide durable, ordered message delivery at the cost of latency; NATS provides ultra-low-latency at-most-once delivery for use cases where message loss is acceptable.

**Production depth**: AOSA's ZeroMQ provides the foundational production evidence for broker-less messaging -- a third approach beyond the broker-based patterns in this cluster.

**Competition reasoning**: KataLog teams extensively used messaging infrastructure: Kafka appeared in 5 of 7 Farmacy Family submissions; Road Warrior required event-driven update propagation; MonitorMe required real-time vital sign streaming.

---

### Production-Validated Profiles

#### LLVM -- Compiler Infrastructure [PRODUCTION-VALIDATED]

**Discovered prevalence**: Compiler infrastructure as a domain is not directly represented in the Discovered corpus, though Pipe-and-Filter (the underlying pattern) appears in 32 of 122 repos across Data Processing, Infrastructure, and Developer Tools domains.

**Domain**: Compiler infrastructure serving dozens of language frontends and hardware targets.
**Architecture styles**: Pipeline, Modular Architecture, Plugin Architecture.
**Scale**: One of the most widely deployed compiler infrastructures in the world (Clang, Rust, Swift all use LLVM as a backend).
**Key architectural insight**: The three-phase design (frontend -> optimizer -> backend) with a language-agnostic Intermediate Representation (IR) is the canonical example of Pipeline architecture. The IR acts as the decoupling layer that enables N frontends to target M backends through a single optimization pipeline, avoiding the N*M problem.

---

#### HDFS -- Distributed Storage [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Data Grid cluster (6 repos) and Database domain (2 repos: CockroachDB, qdrant) demonstrate modern variants of the distributed storage problem. HDFS's Primary-Secondary model contrasts with the masterless patterns prevalent in the Discovered corpus.

**Domain**: Distributed file system for Big Data workloads, core component of the Hadoop ecosystem.
**Architecture styles**: Primary-Secondary (Master-Slave), Data Replication.
**Scale**: Deployed at petabyte scale across thousands of commodity machines at Yahoo!, Facebook, and others.
**Key architectural insight**: The NameNode (single master) design traded availability for simplicity -- a pragmatic choice that worked for batch workloads but became the system's primary limitation. The Data Grid cluster in Discovered (Redis, Dragonfly, Hazelcast) demonstrates the alternative: masterless replication for availability.

---

#### Riak -- Distributed Database [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Data Grid cluster (6 repos) explores the same availability-vs-consistency trade-off. Redis chose availability; Ignite chose strong consistency. CockroachDB (Database domain) chose strong consistency with partition tolerance.

**Domain**: Distributed key-value store designed for high availability.
**Architecture styles**: Peer-to-Peer (Masterless), Eventual Consistency.
**Scale**: Deployed at enterprise scale for applications requiring always-available writes.
**Key architectural insight**: Riak chose the opposite side of the CAP trade-off from HDFS -- favoring availability and partition tolerance over strong consistency. The ring-based consistent hashing, vector clocks for conflict detection, and read-repair demonstrate how to build systems that tolerate network partitions gracefully.

---

#### Selenium WebDriver -- Testing Infrastructure [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Adapter Pattern for heterogeneous integration appears across multiple Discovered domains -- Data Integration (Debezium, NiFi), Infrastructure (Consul, Envoy), and Developer Tools (Backstage, Dapr).

**Domain**: Browser automation framework serving the global QA/testing ecosystem.
**Architecture styles**: Service-Based, Adapter Pattern (per-browser drivers).
**Scale**: The dominant browser automation framework, with millions of daily test executions worldwide.
**Key architectural insight**: The Adapter Pattern (one driver per browser) is a textbook solution for heterogeneous integration. The WebDriver wire protocol acts as the unified API that abstracts browser-specific behavior.

**Competition reasoning**: ClearView's adapter pattern for HR systems (KataLog) and Wildlife Watcher's integration plugin pattern directly parallel Selenium's approach.

---

#### Graphite -- Monitoring Infrastructure [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Observability domain has 3 repos in Discovered (Grafana, Elasticsearch, Sentry self-hosted). Grafana evolved from a Graphite dashboard tool to a full observability platform, demonstrating how Pipeline architectures grow.

**Domain**: Time-series metrics collection, storage, and visualization.
**Architecture styles**: Pipeline, Service-Based.
**Scale**: Deployed at scale for infrastructure monitoring across thousands of servers.
**Key architectural insight**: Graphite's three-component pipeline (Carbon collector -> Whisper storage -> Graphite-web rendering) demonstrates how Pipeline architecture naturally emerges for monitoring domains.

---

#### NGINX -- Web Infrastructure [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Infrastructure cluster (7 repos: Envoy, Istio, Traefik, Linkerd2, Consul, Zuul, Eureka) provides the modern successors to NGINX's patterns. All 7 use Event-Driven or Pipe-and-Filter architectures that trace their lineage to NGINX's worker model.

**Domain**: High-performance HTTP server, reverse proxy, and load balancer.
**Architecture styles**: Event-Driven, Pipeline.
**Scale**: Serves a substantial fraction of global web traffic. The C10K problem solution.
**Key architectural insight**: NGINX's event-driven, non-blocking architecture with worker processes is the production proof that Event-Driven architecture solves the concurrent connection problem.

---

#### Git -- Version Control [PRODUCTION-VALIDATED]

**Discovered prevalence**: Developer Tools is the largest Discovered domain (36 repos). Git's content-addressable storage model and offline-first design influenced many tools in this cluster.

**Domain**: Distributed version control system.
**Architecture styles**: Content-Addressable Storage, Directed Acyclic Graph (DAG).
**Scale**: The dominant version control system globally.
**Key architectural insight**: Git's content-addressable storage and DAG-based history model enable fully offline operation with efficient distributed sync. This is the strongest production evidence for offline-first architecture.
**Edge/offline relevance**: Directly relevant to KataLog profiles with edge/offline requirements (Wildlife Watcher, MonitorMe, Farmacy Food smart fridges) and RealWorld profiles (Bitwarden offline vault, Jellyfin local media server).

---

#### ZeroMQ -- Messaging Infrastructure [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Messaging cluster (5 repos: NATS, Pulsar, RabbitMQ, Redpanda, Mattermost) are all broker-based, contrasting with ZeroMQ's broker-less approach. The broker vs. broker-less trade-off is a fundamental messaging architecture decision.

**Domain**: High-performance asynchronous messaging library.
**Architecture styles**: Broker-less Messaging, Pipeline, Actor Model (socket-as-actor).
**Scale**: Deployed in latency-sensitive trading systems, scientific computing, and distributed applications.
**Key architectural insight**: ZeroMQ's broker-less design eliminates the message broker as a single point of failure and latency bottleneck.

---

#### Twisted -- Networking Framework [PRODUCTION-VALIDATED]

**Discovered prevalence**: Event-Driven is the most prevalent style in the Discovered corpus (78 of 122 repos, 64%). All these repos trace their architectural lineage to patterns proven by Twisted and NGINX.

**Domain**: Event-driven networking engine for Python.
**Architecture styles**: Event-Driven, Reactor Pattern.
**Scale**: Production framework for multi-protocol network servers.
**Key architectural insight**: Twisted's Reactor Pattern (event loop + protocol handlers) is the Python implementation of the same architecture that makes NGINX performant.

---

#### SQLAlchemy -- Database/ORM [PRODUCTION-VALIDATED]

**Discovered prevalence**: Layered Architecture appears in 30 of 122 Discovered repos (25%). SQLAlchemy's approach -- layers that can be used independently -- is the production-validated version of what many Discovered repos implement (ABP, ASP.NET Boilerplate, eShopOnWeb).

**Domain**: SQL toolkit and Object-Relational Mapper for Python.
**Architecture styles**: Layered Architecture, Plugin Architecture.
**Scale**: The dominant Python ORM, used in production across thousands of applications.
**Key architectural insight**: SQLAlchemy's dual-layer design (Core SQL expression layer + ORM layer on top) allows developers to choose their abstraction level.

---

#### Puppet -- Configuration Management [PRODUCTION-VALIDATED]

**Discovered prevalence**: The declarative-vs-imperative tension appears directly in the Workflow Orchestration cluster (Airflow, Argo Workflows, Temporal, Prefect, Conductor) where workflow definitions face the same trade-off. Kubernetes (AKS Baseline in RefArch) uses the same declarative model.

**Domain**: Infrastructure automation and configuration management.
**Architecture styles**: Declarative Configuration, Client-Server.
**Scale**: Deployed to manage tens of thousands of servers at enterprise scale.
**Key architectural insight**: Puppet's declarative model (describe desired state, not steps) is an architecture pattern in itself.

---

#### GStreamer -- Multimedia Framework [PRODUCTION-VALIDATED]

**Discovered prevalence**: The Pipeline + Plugin combination appears in the Data Processing cluster (Beam, Flink, Dagster) and in Jellyfin (Media domain). GStreamer is the production proof that Plugin Architecture + Pipeline handles multimedia complexity.

**Domain**: Multimedia processing framework for audio and video.
**Architecture styles**: Pipeline, Plugin Architecture.
**Scale**: The standard multimedia framework for Linux desktop and embedded systems.
**Key architectural insight**: GStreamer's pipeline-of-plugins architecture handles heterogeneous media processing by composing independently developed plugins.

---

### RealWorld Production Profiles

#### Squidex -- Headless CMS [PRODUCTION-VALIDATED]

**Discovered prevalence**: The CMS domain has 4 repos in Discovered (Squidex, OrchardCore, Directus, Strapi). Squidex appears in both RealWorld and Discovered catalogs, providing cross-validated evidence. The dominant style for CMS repos is Modular Monolith (3 of 4).

**Architecture styles**: CQRS, Event Sourcing, Event-Driven.
**Scale**: ~2,300 GitHub stars, multi-tenant SaaS deployment.
**Key architectural insight**: Squidex is the first production CQRS/Event Sourcing evidence in the catalog. The event-sourced content model enables full audit trails and temporal queries that traditional CMS architectures cannot provide.
**Evidence gap filled**: CQRS/Event Sourcing went from 0% to 61% production evidence with Squidex's inclusion.

---

#### Bitwarden Server -- Password Management [PRODUCTION-VALIDATED]

**Discovered prevalence**: Security/password management is not directly represented in the Discovered corpus. Bitwarden's zero-knowledge architecture is unique in the entire catalog.

**Architecture styles**: Service-Based, Event-Driven.
**Scale**: ~16,000 GitHub stars, millions of users across browser extensions, desktop apps, and mobile clients.
**Key architectural insight**: Zero-knowledge encryption (server never sees plaintext) shapes every architectural decision. Bitwarden's offline vault access demonstrates how to architect for offline-first in a security-sensitive context.

---

#### Jellyfin -- Media Server [PRODUCTION-VALIDATED]

**Discovered prevalence**: Jellyfin appears in both RealWorld and Discovered catalogs (cross-validated). The Media domain has 1 Discovered repo, but Pipeline + Plugin patterns appear across Data Processing (5 repos) and Infrastructure (7 repos).

**Architecture styles**: Plugin Architecture, Pipeline, Client-Server.
**Scale**: ~38,000 GitHub stars, the largest project in the RealWorld source by community size.
**Key architectural insight**: Jellyfin provides .NET Plugin Architecture production evidence that was previously C/C++ only (from AOSA's GStreamer).

---

#### Orchard Core -- CMS/Application Framework [PRODUCTION-VALIDATED]

**Discovered prevalence**: Orchard Core appears in both RealWorld and Discovered catalogs. The CMS domain (4 Discovered repos) shows Modular Monolith as the dominant style (3 of 4 repos), validating Orchard Core's architectural approach.

**Architecture styles**: Modular Monolith, Plugin Architecture.
**Scale**: ~7,500 GitHub stars, used as a foundation for custom CMS deployments.
**Key architectural insight**: Orchard Core provides the first Modular Monolith production evidence. Module isolation within a single deployment unit is achieved through feature flags, dependency injection scoping, and convention-based module discovery.

**Competition reasoning**: The KataLog winner for Farmacy Food (ArchColider) and Spotlight Platform (PegasuZ) both chose Modular Monolith -- Orchard Core validates that choice in production.

---

#### nopCommerce -- E-Commerce Platform [PRODUCTION-VALIDATED]

**Discovered prevalence**: nopCommerce appears in both RealWorld and Discovered catalogs. The E-Commerce domain (11 Discovered repos) is the most cross-validated domain in the entire catalog, with evidence from 4 of 5 sources.

**Architecture styles**: Plugin Architecture, Layered Architecture.
**Scale**: ~9,500 GitHub stars, powering thousands of live storefronts.
**Key architectural insight**: nopCommerce's 17-year evolution demonstrates how Plugin Architecture sustains long-lived e-commerce platforms. The plugin ecosystem decouples the platform from vendor-specific integrations.

---

### Qualitative Evidence: Competition Problem Profiles

#### Farmacy Food (Fall 2020)

**Discovered context**: The Food Delivery domain has 2 repos in the corpus (ftgo-application, go-food-delivery-microservices), both using Microservices + Event-Driven. Farmacy Food's modular monolith choice was deliberately simpler, validated by the winner's reasoning.

**Domain**: Food tech / Ghost kitchen logistics
**Scale trajectory**: Single city (Detroit) to national expansion -- hundreds to thousands of customers
**Budget context**: Startup with limited funding. ArchColider's cost model projected $12K-$23K/year infrastructure costs across three growth scenarios.
**Compliance needs**: Food safety (expiry management, allergen tracking), PCI-DSS. Future HIPAA concerns if health data integration proceeds.
**Integration complexity**: HIGH -- Byte Technology smart fridges (RFID, cloud API), Toast POS kiosks, ChefTec kitchen management, QuickBooks accounting.
**Real-time needs**: Medium -- inventory sync between fridges and central system must handle eventual consistency.
**Edge/offline needs**: Yes -- smart fridges must authenticate customers and release meals even without internet. Jaikaturi designed a CDN-based offline authentication using hashed credit card subsets.
**AI/ML component**: None in core requirements.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: How to build a system cheaply enough for a startup but with enough structural integrity to scale nationally. The winner chose a modular monolith specifically to avoid premature distributed systems complexity.

---

#### Sysops Squad (Spring 2021)

**Discovered context**: No direct domain match in Discovered, but the monolith-to-microservices migration pattern is extensively documented in the E-Commerce cluster (11 repos showing the full spectrum from monolith to microservices).

**Domain**: Enterprise IT / Field service management
**Scale trajectory**: Existing nationwide operation -- large-scale consumer electronics retailer.
**Budget context**: Established enterprise. Cost is a concern but not existential -- the business line will be shut down if the architecture is not fixed.
**Compliance needs**: PCI-DSS. Teams universally separated billing into its own domain.
**Integration complexity**: Medium -- payment processing, notification, existing monolithic database.
**Real-time needs**: Medium -- ticket routing should be responsive; reporting can be batch.
**Edge/offline needs**: No.
**AI/ML component**: None in core requirements.
**Greenfield/brownfield**: Brownfield (migration) -- the entire challenge is about decomposing a failing monolith. Team Seven's winning approach centered on the transition architecture, not just the target state.
**Key architectural tension**: How to migrate from a monolith to a decomposed architecture without disrupting an active nationwide business.

---

#### Farmacy Family (Fall 2021)

**Discovered context**: The CMS and Social Media domains (8 repos combined) show similar community-platform patterns. The health data integration challenge has no Discovered parallel -- competition evidence is the primary source for HIPAA-constrained architecture reasoning.

**Domain**: Health / Community engagement platform
**Scale trajectory**: Small to medium -- extending an existing startup's customer base.
**Budget context**: Startup. Architects++ explicitly chose Facebook Groups, Eventbrite, and WordPress to minimize custom build surface.
**Compliance needs**: HIPAA (medical data sharing), GDPR (data privacy). The Archangels addressed GDPR via crypto-shredding.
**Integration complexity**: HIGH -- existing Farmacy Foods system, health data APIs, community platforms. Kafka appeared in 5 of 7 submissions as the integration backbone.
**Real-time needs**: Low -- community engagement and analytics are not latency-sensitive.
**Edge/offline needs**: No.
**AI/ML component**: Peripheral -- dietary recommendations.
**Greenfield/brownfield**: Brownfield (extension).
**Key architectural tension**: Startup budget vs. enterprise-grade health compliance.

---

#### Spotlight Platform (Spring 2022)

**Discovered context**: No direct domain match in Discovered. The non-profit budget constraint and HR matching problem are best documented through competition evidence.

**Domain**: Non-profit / HR tech / Diversity & inclusion
**Scale trajectory**: Medium -- connecting underrepresented candidates with training organizations.
**Budget context**: Non-profit (501(c)(3)). PegasuZ asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" TheGlobalVariables calculated $0.002/user/month.
**Compliance needs**: GDPR (candidate PII).
**Integration complexity**: Medium -- non-profit systems, content management, notification.
**Real-time needs**: Low.
**Edge/offline needs**: No.
**AI/ML component**: Peripheral -- candidate matching and recommendation.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: Non-profit budget vs. platform ambition. The winner (PegasuZ) resolved this by starting with a modular monolith MVP.

---

#### Hey Blue! (Fall 2022)

**Discovered context**: The Data Grid cluster (6 repos) provides the in-memory data structure patterns needed for O(log n) proximity lookups at scale. The Infrastructure cluster (7 repos) provides service mesh patterns for the geolocation backend.

**Domain**: Civic tech / Community-police relations
**Scale trajectory**: Large to Very Large -- target of 1.2 billion annual connections.
**Budget context**: Non-profit, grant-funded. MonArch projected $2,780/month for 50K MAU.
**Compliance needs**: GDPR, officer safety/privacy. It Depends deliberately deviated from requirements to protect officer locations.
**Integration complexity**: Medium -- social media APIs, retail systems, charity platforms.
**Real-time needs**: High -- officer proximity detection, WebSocket location streaming.
**Edge/offline needs**: No, though QR code approach bypassed geolocation for in-person interactions.
**AI/ML component**: None.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: Real-time officer safety vs. community engagement at scale.

---

#### Wildlife Watcher (Fall 2023)

**Discovered context**: No direct IoT/edge domain match in Discovered. Git (AOSA) is the strongest evidence for offline-first architecture; Bitwarden (RealWorld) demonstrates offline vault access in a security context. Competition evidence is the primary source for ultra-constrained edge architecture reasoning.

**Domain**: Conservation technology / IoT / Edge computing
**Scale trajectory**: Small to medium -- hundreds of cameras and users.
**Budget context**: Non-profit (Wildlife.ai charitable trust).
**Compliance needs**: Geoprivacy for endangered species (AnimAI identified poacher risk).
**Integration complexity**: VERY HIGH -- 8+ external platforms (iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite).
**Real-time needs**: Medium -- conservation observation workflows tolerate minutes of delay.
**Edge/offline needs**: Yes -- the defining constraint. 512KB Flash, LoRaWAN at 1kbps, satellite. AI inference must run on-device.
**AI/ML component**: Supporting -- on-device AI for species identification.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: Ultra-constrained edge hardware vs. cloud AI sophistication.

---

#### Road Warrior (Fall 2023 External)

**Discovered context**: The Travel domain has 1 Discovered repo (aws-serverless-airline-booking), using Serverless + Event-Driven. Road Warrior's Very Large scale (15M users) aligns with Infrastructure cluster patterns (Envoy, Istio, Traefik) and Data Grid patterns (Redis, Dragonfly) for the caching and service mesh layers.

**Domain**: Travel / Consumer technology
**Scale trajectory**: Very Large -- 15 million total users, 2 million active weekly.
**Budget context**: Startup. Iconites proposed tiered business model with $496.95/month initial infrastructure.
**Compliance needs**: GDPR, PCI-DSS. Street Fighters produced a comprehensive GDPR ADR.
**Integration complexity**: HIGH -- SABRE, APOLLO, email providers, social media, analytics.
**Real-time needs**: High -- travel updates within 5 minutes, web response under 800ms, 99.99% availability.
**Edge/offline needs**: No.
**AI/ML component**: None.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: 99.99% availability for millions of users at startup cost.

---

#### MonitorMe (Winter 2024)

**Discovered context**: No direct MedTech domain match in Discovered. The Data Processing cluster (5 repos) provides pipeline patterns applicable to vital sign processing. GStreamer (AOSA) demonstrates real-time pipeline processing for heterogeneous data sources. Competition evidence is the primary source for life-critical latency reasoning.

**Domain**: Healthcare / Medical device monitoring
**Scale trajectory**: Medium -- up to 500 patients per installation, 4,000 events/sec.
**Budget context**: Established enterprise.
**Compliance needs**: HIPAA excluded. Security acknowledged but deferred.
**Integration complexity**: Medium -- 2 cloud products + 8 device types with different sampling rates.
**Real-time needs**: CRITICAL -- sub-1-second response time. BluzBrothers proved 693ms end-to-end latency.
**Edge/offline needs**: Yes -- on-premises hospital appliance. LowCode designed a 3-node appliance with graceful degradation.
**AI/ML component**: None -- threshold rules, not ML.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: Life-critical latency on constrained on-premises hardware.

---

#### ShopWise AI Assistant (AI Winter 2024)

**Discovered context**: The AI/ML cluster (6 repos) demonstrates that Multi-Agent is the emerging dominant pattern for AI orchestration. The E-Commerce domain (11 repos) provides the transactional patterns underlying the product catalog.

**Domain**: Retail / E-commerce / AI chatbot
**Scale trajectory**: Small -- single e-commerce store.
**Budget context**: Implicit cost consciousness around LLM API costs.
**Compliance needs**: None explicit.
**Integration complexity**: Low -- product/order database + LLM API providers.
**Real-time needs**: Low -- conversational response times.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- the AI chatbot IS the product. All four teams converged on text-to-SQL. ConnectedAI implemented a multi-agent supervisor hierarchy with four specialist agents.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: AI accuracy and cost vs. rapid prototyping.

---

#### ClearView (Fall 2024)

**Discovered context**: The AI/ML cluster (6 repos) and the Adapter Pattern in Developer Tools (Backstage, Dapr) and Data Integration (Debezium, NiFi) provide code-level evidence for ClearView's two core patterns: AI orchestration and HR system integration.

**Domain**: HR / AI for bias reduction in recruitment
**Scale trajectory**: Medium -- Equihire Architects scoped to 5,000 candidates.
**Budget context**: Non-profit. Katamarans calculated $0.06 per candidate. DevExperts estimated $8,448/year total infrastructure.
**Compliance needs**: PII protection, anti-bias requirements.
**Integration complexity**: HIGH -- unbounded HR systems. Every team identified HR integration as a first-class concern using adapter/connector patterns.
**Real-time needs**: Low -- batch or near-batch processes.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- AI performs resume anonymization, candidate story construction, and job matching. Pragmatic's deterministic matching reduced LLM calls from O(n*m) to O(n+m).
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: LLM cost and non-determinism vs. bias-free hiring at non-profit budget.

---

#### Certifiable Inc. (Winter 2025)

**Discovered context**: The Workflow Orchestration cluster (5 repos: Airflow, Argo Workflows, Conductor, Prefect, Temporal) provides the pipeline and orchestration patterns applicable to grading workflows. The AI/ML cluster provides Multi-Agent patterns for AI-assisted evaluation.

**Domain**: EdTech / AI-assisted certification grading
**Scale trajectory**: Medium to Large -- 200 candidates/week, projected 1,000-2,000/week.
**Budget context**: Established organization with thin margins. ZAITects projected 80% cost reduction.
**Compliance needs**: Certification integrity -- errors can derail careers.
**Integration complexity**: Low -- existing SoftArchCert platform + LLM providers.
**Real-time needs**: Low -- grading is batch.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- highest-stakes AI challenge in the kata series. ZAITects separated the Grader from the Judge (LLM-as-a-Judge pattern). Software Architecture Guild ran six parallel AI solution variants via microkernel architecture.
**Greenfield/brownfield**: Brownfield (extension).
**Key architectural tension**: AI autonomy vs. career-affecting accuracy.

---

## Problem Dimension Deep Dives

### By Domain Type

**Discovered domain statistics drive this section.** The 35 domains observed in 122 production codebases reveal where real systems concentrate. KataLog competition challenges fill gaps in domains not well-represented in the Discovered corpus (Healthcare, Civic Tech, Conservation/IoT).

**Developer Tools** (Discovered: 36 repos -- 30% of corpus)
The dominant domain by volume. Developer tools and frameworks split into platform tools (ABP, Backstage, Dapr, Supabase) using Microservices/Service-Based + Event-Driven, and clean architecture templates (11+ repos) using Hexagonal/DDD/CQRS. The key insight: framework extensibility vs. opinionated conventions is the universal tension. Production depth: AOSA provides Git, SQLAlchemy, GStreamer as foundational evidence.

**E-Commerce** (Discovered: 11 repos; RealWorld: nopCommerce; RefArch: eShop*; KataLog: ShopWise AI, Farmacy Food)
The most cross-validated domain (4 of 5 sources). The Discovered cluster reveals the full monolith-to-microservices spectrum. nopCommerce proves plugin-based e-commerce at 17-year production scale. KataLog tested AI engineering (text-to-SQL, multi-agent) in the e-commerce context.

**Infrastructure / Service Mesh** (Discovered: 7 repos; AOSA: NGINX)
Service mesh, proxy, and discovery tools in the critical path of every microservices request. NGINX (AOSA) proved the event-driven model; Envoy, Istio, and Traefik extend it with modern service mesh capabilities.

**AI/ML** (Discovered: 6 repos; KataLog: ShopWise AI, ClearView, Certifiable Inc.)
The newest and fastest-growing domain. Discovered shows Multi-Agent as the emerging dominant pattern (4 of 6 repos). KataLog provides the strongest trade-off analysis -- competition teams documented reasoning about AI non-determinism, cost optimization, and human-in-the-loop patterns that are invisible in code.

**Data Grid / In-Memory** (Discovered: 6 repos; AOSA: HDFS, Riak)
Space-Based architecture is nearly exclusive to this cluster (5 of 7 total Space-Based repos). Provides sub-millisecond data access at extreme scale. AOSA's HDFS and Riak demonstrate the consistency-vs-availability trade-off at the database level.

**Workflow Orchestration** (Discovered: 5 repos; AOSA: Puppet)
DAG-based orchestrators vs. event-driven workflow engines. Puppet (AOSA) demonstrates the declarative-vs-imperative tension. KataLog profiles with complex workflows (Sysops Squad, Certifiable Inc.) face similar decisions.

**Data Processing** (Discovered: 5 repos; AOSA: LLVM, Graphite, GStreamer)
Pipe-and-Filter is the defining pattern (4 of 5 repos). AOSA provides the foundational Pipeline evidence across three different domains (compilation, metrics, multimedia).

**Messaging** (Discovered: 5 repos; AOSA: ZeroMQ)
Broker-based (RabbitMQ, Pulsar, Redpanda, NATS) vs. broker-less (ZeroMQ). KataLog teams extensively used messaging: Kafka in 5/7 Farmacy Family submissions.

**CMS / Content Management** (Discovered: 4 repos; RealWorld: Squidex, Orchard Core)
Modular Monolith dominates (3 of 4 Discovered repos). Squidex proves CQRS/Event Sourcing for CMS; Orchard Core proves Modular Monolith.

**Social Media** (Discovered: 4 repos)
Event-Driven is universal (4 of 4 repos). Layered (3) and Modular Monolith (2) also prevalent. Representatives: ddd-forum, Discourse, Forem, Mastodon.

**Food / Logistics** (KataLog: Farmacy Food; Discovered: 2 Food Delivery repos)
Domain-specific constraints: physical-digital bridge (RFID, smart fridges, POS), food safety. Event-driven inventory propagation is universal when physical goods are involved. Competition reasoning fills gaps not visible in the 2 Discovered Food Delivery repos.

**Healthcare / MedTech** (KataLog: MonitorMe, Farmacy Family; RealWorld: Bitwarden for security parallels)
Not represented in Discovered. Competition evidence is the primary source for life-critical latency and HIPAA-constrained architecture reasoning.

**Enterprise IT / Field Service** (KataLog: Sysops Squad)
Not represented in Discovered. The monolith migration constraint drove convergence on service-based architecture (6/7 teams). The E-Commerce cluster's monolith-to-microservices spectrum provides the closest Discovered parallel.

**Non-Profit / HR Tech** (KataLog: Spotlight Platform, ClearView)
Not represented in Discovered. Cost analysis separated winners from runners-up: $0.002/user/month (Spotlight Platform) and $0.06/candidate (ClearView) are the kinds of numbers that make architectures credible.

**Civic Tech / Social Impact** (KataLog: Hey Blue!)
Not represented in Discovered. Officer safety was the domain-specific constraint no generic pattern addresses. Data Grid cluster patterns support proximity lookups.

**Conservation / IoT** (KataLog: Wildlife Watcher)
Not represented in Discovered. 512KB Flash + LoRaWAN = architecture-defining constraint. Git (AOSA) provides the strongest offline-first evidence.

**Travel / Consumer** (KataLog: Road Warrior; Discovered: 1 repo)
Minimally represented in Discovered (aws-serverless-airline-booking). Infrastructure cluster (7 repos) provides service mesh patterns needed at Road Warrior's scale.

**Compiler Infrastructure** (AOSA: LLVM)
Not in Discovered by domain, but Pipeline pattern appears in 32 Discovered repos. The three-phase design is the archetype for all data transformation domains.

**Distributed Storage** (AOSA: HDFS, Riak; Discovered: Data Grid cluster)
HDFS (master-based) and Riak (masterless) represent the two fundamental approaches; the Data Grid cluster provides modern in-memory variants.

**Web Infrastructure** (AOSA: NGINX; Discovered: Infrastructure cluster)
NGINX proved the event-driven model; 7 Discovered Infrastructure repos extend it with service mesh capabilities.

**Security / Password Management** (RealWorld: Bitwarden)
Unique in the catalog -- no other source covers the security domain with zero-knowledge encryption.

**Media Server / Streaming** (RealWorld: Jellyfin; AOSA: GStreamer; Discovered: 1 Media repo)
Cross-validated between AOSA (C/C++) and RealWorld (.NET). Pipeline + Plugin handles multimedia complexity.

---

### By Scale Requirements

Profiles ordered from smallest to largest expected scale, grounded in Discovered domain cluster sizes and validated by production and competition evidence:

| Tier | Profile | Source | User/Transaction Scale | What Changes Architecturally |
|------|---------|--------|----------------------|------------------------------|
| **Small** | ShopWise AI | KataLog | Single store | Monolithic pipeline viable; focus on AI quality over infrastructure |
| **Small** | BuckPal | RefArch | Reference only | Hexagonal ports/adapters work cleanly at small scale |
| **Small-Medium** | Farmacy Food (initial) | KataLog | Hundreds in Detroit | Modular monolith wins; startup simplicity over distributed systems |
| **Small-Medium** | Wildlife Watcher | KataLog | Hundreds of cameras/users | Edge constraints dominate; scale is secondary to connectivity |
| **Small-Medium** | Farmacy Family | KataLog | Low thousands | Batch processing for analytics; compliance dominates |
| **Medium** | Spotlight Platform | KataLog | Thousands | Cost-per-user matters more than raw throughput; serverless excels |
| **Medium** | ClearView | KataLog | Thousands of candidates | LLM cost scales linearly; deterministic matching reduces cost |
| **Medium** | MonitorMe | KataLog | 500 patients (4,000 events/sec) | Data throughput matters more than user count; time-series essential |
| **Medium** | Squidex | RealWorld | Multi-tenant CMS | CQRS handles read/write asymmetry in content platforms |
| **Medium** | Modular Monolith w/ DDD | RefArch | Reference | Module boundaries proven at medium scale |
| **Medium-Large** | Certifiable Inc. | KataLog | 200-2,000 candidates/week | Grading throughput, not concurrent users, is the scaling dimension |
| **Medium-Large** | Orchard Core | RealWorld | ~7,500 stars community | Modular Monolith handles framework-level extensibility |
| **Medium-Large** | eShopOnContainers | RefArch | Reference e-commerce | Microservices coordination overhead justified |
| **Large** | Sysops Squad | KataLog | Nationwide retailer | Migration architecture must handle current load while transitioning |
| **Large** | nopCommerce | RealWorld | ~9,500 stars, thousands of stores | Plugin ecosystem stability over 17 years; Layered Architecture endures |
| **Large** | Graphite | AOSA | Thousands of servers | Pipeline architecture scales monitoring horizontally |
| **Large** | Jellyfin | RealWorld | ~38,000 stars community | Plugin Architecture + Pipeline handles media at scale |
| **Large** | Riak | AOSA | Enterprise deployment | Masterless replication scales writes linearly |
| **Large-Very Large** | Hey Blue! | KataLog | Millions of users | Real-time geolocation at scale; space-based patterns needed |
| **Very Large** | Road Warrior | KataLog | 15M users, 2M active | 99.99% availability; CQRS mandatory; multiple scaling groups |
| **Very Large** | NGINX | AOSA | Global web traffic | Event-driven + worker processes solve C10K at single-machine scale |
| **Very Large** | HDFS | AOSA | Petabyte-scale storage | Primary-Secondary replication at commodity hardware scale |
| **Very Large** | Bitwarden | RealWorld | ~16K stars, millions of users | Service-Based with zero-knowledge encryption at scale |
| **Very Large** | LLVM | AOSA | Global compiler infra | Pipeline IR decouples N*M frontend/backend combinations |
| **Very Large** | Git | AOSA | Global developer tool | Content-addressable storage + DAG enables distributed scale |
| **Very Large** | Data Grid Cluster | Discovered | Sub-ms latency at scale | Space-Based patterns for in-memory data distribution |
| **Very Large** | Messaging Cluster | Discovered | Millions msg/sec | Log-based (Pulsar, Redpanda) vs. traditional (RabbitMQ, NATS) |
| **Very Large** | Data Processing Cluster | Discovered | Stream processing at scale | Pipe-and-Filter with exactly-once guarantees |

**Architectural transitions by scale tier (Discovered statistics + production validation):**
- **Small**: Single-process or monolithic architectures are not only acceptable but preferred. In the Discovered corpus, Layered and Hexagonal repos tend to be smaller-scale. Production evidence: BuckPal (RefArch), clean architecture templates (Discovered).
- **Medium**: Modular Monolith is the sweet spot -- 29 of 122 Discovered repos use it, often combined with Event-Driven. Production evidence: Squidex (RealWorld), Orchard Core (RealWorld). Competition reasoning: winners at Spotlight Platform and Farmacy Food both chose modular monolith.
- **Large**: Microservices become justified -- 45 of 122 Discovered repos use them. Event-Driven becomes pervasive. Production evidence: nopCommerce (RealWorld), Jellyfin (RealWorld), Graphite (AOSA), Riak (AOSA).
- **Very Large**: Space-Based patterns (7 Discovered repos, concentrated in Data Grid), in-memory data grids, event-driven pipelines, and aggressive caching become necessary. Production evidence: NGINX (AOSA), HDFS (AOSA), Git (AOSA), Bitwarden (RealWorld), Redis/Dragonfly (Discovered).

---

### By Integration Complexity

| Tier | Profile | Source | External Systems | Pattern That Emerges |
|------|---------|--------|-----------------|---------------------|
| **Low** | ShopWise AI | KataLog | LLM APIs only | Direct API calls; abstraction layer for model swapping |
| **Low** | Certifiable Inc. | KataLog | Platform + LLM APIs | Extension architecture; AI gateway pattern |
| **Low** | BuckPal | RefArch | Hexagonal ports | Port/adapter abstraction; clean domain model |
| **Low** | Git | AOSA | Content-addressable | Self-contained; integration via protocol (HTTP, SSH) |
| **Medium** | Sysops Squad | KataLog | Payment, notification, DB | Internal decomposition harder than external integration |
| **Medium** | Spotlight Platform | KataLog | Non-profit systems, content | BFF pattern; standard REST/webhook integrations |
| **Medium** | MonitorMe | KataLog | 2 cloud products + 8 devices | Device protocol heterogeneity; edge gateway pattern |
| **Medium** | Hey Blue! | KataLog | Social media, retail, charity | Microkernel/Plugin for diverse business capabilities |
| **Medium** | Squidex | RealWorld | APIs, webhooks, scripting | Event-driven integration with content delivery |
| **Medium** | Puppet | AOSA | Managed infrastructure | Agent-catalog model for heterogeneous infrastructure |
| **High** | Farmacy Food | KataLog | Smart fridges, POS, ChefTec | Eventual consistency; vendor research as architecture |
| **High** | Farmacy Family | KataLog | Platform, health APIs | Kafka as universal integration backbone (5/7 teams) |
| **High** | Road Warrior | KataLog | SABRE, APOLLO, email | Dual-speed polling; email integration is hardest |
| **High** | ClearView | KataLog | Unbounded HR systems + LLM | Adapter/connector pattern universal |
| **High** | NGINX | AOSA | Upstream servers, modules | Module-based extensibility for request processing |
| **High** | SQLAlchemy | AOSA | Multi-database backends | Layered abstraction; dialect system per database |
| **High** | Graphite | AOSA | Any metric source | Pipeline ingestion with protocol adapters |
| **High** | nopCommerce | RealWorld | Payment, shipping, tax, plugins | Plugin ecosystem for vendor integration |
| **High** | Jellyfin | RealWorld | Media formats, clients, metadata | Plugin Architecture for codec/client diversity |
| **Very High** | Wildlife Watcher | KataLog | 8+ scientific/ML platforms | Microkernel plugin architecture; comparative analysis essential |
| **Very High** | Selenium | AOSA | Per-browser drivers | Adapter Pattern with wire protocol unification |
| **Very High** | GStreamer | AOSA | Codecs, devices, protocols | Pipeline of plugins for heterogeneous media |
| **Very High** | Infrastructure Cluster | Discovered | All services in mesh | Sidecar proxy pattern; universal service interception |
| **Very High** | Data Processing Cluster | Discovered | Connectors for all sources | Connector framework (Beam, Flink, Debezium) |

**Patterns by integration tier (Discovered statistics + production evidence):**
- **Low**: Direct API calls with abstraction layers. In Discovered, Hexagonal Architecture (15 repos) provides the port/adapter pattern. Production: Git's protocol-based integration (AOSA).
- **Medium**: Adapter pattern, dedicated integration services. In Discovered, Event-Driven (78 repos) is the dominant integration pattern. Production: Puppet's agent-catalog model (AOSA), Squidex's webhook-based events (RealWorld).
- **High**: Event-driven integration backbone, dedicated modules per system. In Discovered, DDD (39 repos) provides bounded context isolation for integration boundaries. Production: NGINX's module system (AOSA), nopCommerce's plugin ecosystem (RealWorld).
- **Very High**: Microkernel/plugin architecture for extensibility; protocol-based abstraction. In Discovered, Pipe-and-Filter (32 repos) and Microservices (45 repos) combine for connector frameworks. Production: Selenium's wire protocol (AOSA), GStreamer's pipeline-of-plugins (AOSA).

---

### By Compliance/Regulatory Load

| Profile | Source | Compliance Regime | How It Constrained Solutions |
|---------|--------|------------------|-----------------------------|
| ShopWise AI | KataLog | None explicit | Freed teams to focus on AI accuracy |
| Most AOSA projects | AOSA | None explicit | Open-source projects; compliance as a user concern |
| Developer Tools Cluster | Discovered | None typical | Frameworks delegate compliance to users |
| Wildlife Watcher | KataLog | Geoprivacy (informal) | AnimAI identified poacher risk; user vetting added |
| MonitorMe | KataLog | HIPAA excluded | Teams deferred security; focused on performance |
| Spotlight Platform | KataLog | GDPR (PII) | Data purging workflows; consent management |
| Hey Blue! | KataLog | GDPR + Officer Safety | IPT elevated GDPR to top-level ADR; requirements deviated for safety |
| Road Warrior | KataLog | GDPR + PCI-DSS | Comprehensive GDPR ADR; universal payment delegation |
| Farmacy Food | KataLog | Food Safety + PCI | Expiry management, allergen tracking; Stripe universal |
| nopCommerce | RealWorld | PCI | Plugin-based payment gateway isolation; 17 years of PCI evolution |
| Squidex | RealWorld | Multi-tenant isolation | Event-sourced audit trails; tenant data boundaries |
| Farmacy Family | KataLog | HIPAA + GDPR | Crypto-shredding; HIPAA-eligible services; honest deferral |
| Bitwarden | RealWorld | SOC 2 + security audits | Zero-knowledge encryption shapes every architectural decision |
| ClearView | KataLog | PII + Anti-bias | Architecture must constrain AI bias, not just process data |
| Certifiable Inc. | KataLog | Certification Integrity | Universal human-in-the-loop; confidence-based escalation |
| Puppet | AOSA | Compliance as a feature | Declarative configuration enables compliance-as-code auditing |
| AKS Baseline | RefArch | Enterprise compliance | Network policies, pod security, Azure Policy integration |

**Key finding**: Compliance-constrained domains are underrepresented in the Discovered corpus (most open-source repos have none/minimal compliance). This is where competition evidence provides unique value -- KataLog teams documented compliance decisions with specific ADRs and referenced specific standards (HIPAA, GDPR, PCI-DSS). Production systems (Bitwarden, Puppet, nopCommerce) demonstrate that compliance constraints become permanent architectural forces.

---

### By AI/ML Component

**Discovered context**: The AI/ML cluster (6 repos) emerged entirely post-2023, representing 5% of the corpus. Multi-Agent (4 repos) is the dominant pattern, unique to this cluster.

The evolution of AI across all sources traces a clear arc:

**Phase 1: No AI (traditional systems)**
- KataLog 2020-2022: Farmacy Food, Sysops Squad, Farmacy Family, Spotlight Platform, Hey Blue!
- All AOSA projects (2011-2012 era, pre-modern-AI)
- Most RealWorld projects: nopCommerce, Orchard Core, Squidex, Jellyfin
- All RefArch projects
- Architecture dominated by traditional distributed systems concerns

**Phase 2: IoT/Edge AI (2023)**
- KataLog: Wildlife Watcher (on-device species identification)
- AI constrained by hardware (512KB Flash) and connectivity (LoRaWAN)
- The challenge was deploying AI to the edge, not building AI systems

**Phase 3: AI as the Product (2024-2025)**
- KataLog: ShopWise AI (text-to-SQL, multi-agent), ClearView (bias-free hiring), Certifiable Inc. (high-stakes grading)
- Discovered AI/ML cluster (6 repos): AutoGPT, autogen, camel, crewAI, dify, letta
- Multi-Agent emerges as the dominant pattern for AI orchestration

**What changed architecturally with AI (cross-source evidence):**

| Concern | Pre-AI Systems | AI-Era Systems |
|---------|---------------|----------------|
| **Primary style** | Microservices, Service-Based, Event-Driven (KataLog, AOSA, RealWorld, RefArch) | Service-Based + Event-Driven + Multi-Agent, Pipe-and-Filter (KataLog AI katas, Discovered AI cluster) |
| **Cost optimization** | Infrastructure costs (all sources) | LLM API costs -- per-token pricing, model selection by task (KataLog AI katas) |
| **Testing** | Deterministic tests (all sources) | Non-deterministic evaluation frameworks -- Ragas, LangFuse (KataLog AI katas) |
| **Key risk** | Over-engineering, premature scaling (KataLog, RefArch) | AI non-determinism, cost runaway, bias, hallucination (KataLog AI katas, Discovered AI cluster) |
| **Production evidence** | Extensive -- AOSA, RealWorld, RefArch, Discovered | Emerging -- Discovered AI cluster only; no AOSA/RealWorld AI production evidence yet |

---

## Problem Similarity Clusters

Similarity is organized into clusters of profiles that share 3+ problem dimensions, grounded in Discovered domain clusters and supplemented by production and competition evidence from matching domains.

### Cluster 1: Edge/IoT/Constrained Hardware

**Members**: Wildlife Watcher (KataLog), MonitorMe (KataLog), Git (AOSA), Bitwarden (RealWorld), Jellyfin (RealWorld), GStreamer (AOSA)

**Discovered grounding**: No dedicated IoT/edge domain in the Discovered corpus. Jellyfin appears in Discovered (Media domain). The absence of edge/IoT repos in Discovered reflects the detection bias -- constrained hardware systems often have non-standard build systems that automated analysis misses.

**Shared dimensions**: Edge/offline operation, device/hardware constraints, real-time data processing from constrained environments.

**Why this cluster matters**: These profiles all face the fundamental tension of operating sophisticated software on limited hardware or in disconnected environments. Git proves that fully offline distributed systems work at global scale. Bitwarden proves offline-first works in security-sensitive contexts. MonitorMe and GStreamer prove real-time processing from heterogeneous devices. Wildlife Watcher represents the extreme case (512KB Flash, LoRaWAN).

**Strongest internal pairings**:
- Wildlife Watcher / MonitorMe (score 3): Both involve hardware/device integration, edge computing, event-driven architectures.
- GStreamer / Jellyfin (score 4): Both process heterogeneous media through plugin-based pipelines with real-time constraints.
- Git / Bitwarden (score 3): Both architect for fully offline operation with eventual sync.

### Cluster 2: AI-Centric Systems

**Members**: ShopWise AI (KataLog), ClearView (KataLog), Certifiable Inc. (KataLog), AutoGPT (Discovered), crewAI (Discovered), autogen (Discovered), dify (Discovered), letta (Discovered), camel (Discovered)

**Discovered grounding**: 6 Discovered repos form the statistical basis. Multi-Agent appears in 4 of 6, Event-Driven in 5 of 6. KataLog provides the trade-off reasoning invisible in code (cost projections, non-determinism management, human-in-the-loop decisions).

**Shared dimensions**: Central AI/ML component, LLM integration, non-deterministic output management, cost optimization.

**Why this cluster matters**: The fastest-growing cluster and the one with the least production evidence. KataLog provides the strongest trade-off reasoning. Discovered provides code-level evidence of emerging patterns (Multi-Agent dominance). No AOSA or RealWorld entries exist yet -- this represents the evidence frontier.

**Strongest internal pairings**:
- ShopWise AI / Certifiable Inc. (score 4): Both AI-centric with text understanding. Certifiable adds high-stakes accountability.
- ClearView / Certifiable Inc. (score 3): Both require AI to make consequential decisions about people's lives/careers.
- ShopWise AI / ClearView (score 3): Both LLM-integrated, both face cost optimization challenges.
- Discovered AI repos form a tight sub-cluster: 4 of 6 use Multi-Agent architecture, all use Event-Driven.

### Cluster 3: E-Commerce / Transactional Systems

**Members**: Farmacy Food (KataLog), ShopWise AI (KataLog), nopCommerce (RealWorld), eShopOnContainers (RefArch), eShop (RefArch), eShopOnWeb (Discovered), go-ecommerce-microservices (Discovered), Medusa (Discovered), Saleor (Discovered), Shopware (Discovered), Spree (Discovered), microservices-demo (Discovered), NorthwindTraders (Discovered), BuckPal (RefArch)

**Discovered grounding**: 11 Discovered repos -- the strongest statistical basis of any cluster. Event-Driven (6), CQRS (4), Microservices (4), Modular Monolith (4) are the top styles.

**Shared dimensions**: Transactional integrity, payment processing (PCI), catalog/inventory management, plugin-based extensibility.

**Why this cluster matters**: The most cross-validated domain in the catalog (4 of 5 sources). Contains examples at every point on the monolith-to-microservices spectrum. nopCommerce's 17-year track record is the strongest long-term evolution evidence.

**Architectural spectrum within cluster**:
1. Layered monolith: eShopOnWeb, nopCommerce
2. Modular Monolith: Medusa, Saleor, Shopware, Spree
3. Hexagonal: BuckPal, NorthwindTraders
4. Microservices: eShop, eShopOnContainers, go-ecommerce-microservices, microservices-demo

### Cluster 4: Non-Profit / Cost-Constrained Platforms

**Members**: Spotlight Platform (KataLog), Hey Blue! (KataLog), ClearView (KataLog), Wildlife Watcher (KataLog), Farmacy Food (KataLog), Farmacy Family (KataLog)

**Discovered grounding**: Most Discovered repos are open-source projects with implicit cost consciousness, but none document budget constraints explicitly. Competition evidence is the primary source for cost-driven architecture decisions.

**Shared dimensions**: Severe budget constraints, non-profit or startup context, cost-per-user as a primary architectural driver.

**Why this cluster matters**: Six of 11 KataLog challenges operate under tight budget constraints. The winning pattern across all of them is evolutionary architecture: start with the simplest viable architecture (modular monolith or service-based) and plan for growth rather than building for scale on day one. Discovered evidence supports this -- Modular Monolith appears in 29 of 122 repos, often as the foundation for systems that later evolved.

**Key cost benchmarks from competition evidence**:
- $0.002/user/month (Spotlight Platform, TheGlobalVariables)
- $0.06/candidate (ClearView, Katamarans)
- $2,780/month for 50K MAU (Hey Blue!, MonArch)
- $12K-23K/year infrastructure (Farmacy Food, ArchColider)
- $8,448/year total infrastructure (ClearView, DevExperts)

### Cluster 5: High-Performance / Real-Time Systems

**Members**: MonitorMe (KataLog), Road Warrior (KataLog), Hey Blue! (KataLog), NGINX (AOSA), ZeroMQ (AOSA), GStreamer (AOSA), Twisted (AOSA), Jellyfin (RealWorld), Data Grid cluster (Discovered), Messaging cluster (Discovered), Infrastructure cluster (Discovered)

**Discovered grounding**: Event-Driven is the most prevalent style in the Discovered corpus -- 78 of 122 repos (64%). The Data Grid (6 repos), Messaging (5 repos), and Infrastructure (7 repos) clusters provide the statistical basis: 18 Discovered repos focused on real-time performance.

**Shared dimensions**: Sub-second latency requirements, high concurrency, event-driven architecture as the dominant pattern.

**Why this cluster matters**: Event-Driven is the most prevalent architecture style across all sources. The AOSA entries (NGINX, ZeroMQ, Twisted) provide foundational theory; the Discovered entries provide modern implementations; KataLog provides trade-off reasoning.

### Cluster 6: Developer Platforms / Extensible Frameworks

**Members**: Developer Tools cluster (36 Discovered repos), Selenium (AOSA), SQLAlchemy (AOSA), GStreamer (AOSA), LLVM (AOSA), Puppet (AOSA), nopCommerce (RealWorld), Orchard Core (RealWorld), Jellyfin (RealWorld), Clean Architecture Template (RefArch)

**Discovered grounding**: 36 Discovered repos -- the largest statistical basis. Plugin/extension architecture is the unifying pattern. Event-Driven (21 repos), DDD (13), CQRS (11) are the top styles in the Developer Tools domain.

**Shared dimensions**: Plugin/extension architecture, framework extensibility, multi-platform support, developer experience as a quality attribute.

**Why this cluster matters**: Plugin Architecture is one of the most cross-validated patterns in the catalog. AOSA provides the deepest production narratives (GStreamer, LLVM, SQLAlchemy). RealWorld proves it in .NET contexts (Jellyfin, nopCommerce, Orchard Core). Discovered shows it at scale across 36 developer tool repos.

### Cluster 7: Distributed Data / Storage Systems

**Members**: HDFS (AOSA), Riak (AOSA), Data Grid cluster (Discovered: Redis, Dragonfly, Hazelcast, Ignite, Infinispan, Geode), Messaging cluster (Discovered: Pulsar, Redpanda, RabbitMQ, NATS), CockroachDB (Discovered), qdrant (Discovered)

**Discovered grounding**: 13 Discovered repos across Data Grid (6), Messaging (5), and Database (2) domains. Space-Based (5 repos in Data Grid) and Event-Driven (universal) are the dominant styles.

**Shared dimensions**: Data distribution, replication strategies, consistency vs. availability trade-offs, partition tolerance.

**Why this cluster matters**: The CAP theorem is the defining architectural constraint. HDFS chose CP; Riak chose AP. The Discovered Data Grid cluster provides modern in-memory variants. Understanding where your system falls on the CAP spectrum is the first architectural decision.

### KataLog Internal Similarity Matrix

For the 11 KataLog challenges, the full pairwise similarity scores (0-5 scale):

|  | FF | SS | FaFa | SP | HB | WW | RW | MM | SA | CV | CI |
|--|----|----|------|----|----|----|----|----|----|----|-----|
| **Farmacy Food (FF)** | -- | 1 | 4 | 2 | 2 | 2 | 1 | 1 | 0 | 1 | 0 |
| **Sysops Squad (SS)** | 1 | -- | 2 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 1 |
| **Farmacy Family (FaFa)** | 4 | 2 | -- | 3 | 2 | 1 | 1 | 1 | 0 | 2 | 1 |
| **Spotlight Platform (SP)** | 2 | 1 | 3 | -- | 3 | 2 | 1 | 0 | 0 | 4 | 1 |
| **Hey Blue! (HB)** | 2 | 1 | 2 | 3 | -- | 1 | 2 | 1 | 0 | 2 | 0 |
| **Wildlife Watcher (WW)** | 2 | 0 | 1 | 2 | 1 | -- | 0 | 3 | 0 | 0 | 0 |
| **Road Warrior (RW)** | 1 | 1 | 1 | 1 | 2 | 0 | -- | 1 | 0 | 0 | 0 |
| **MonitorMe (MM)** | 1 | 1 | 1 | 0 | 1 | 3 | 1 | -- | 0 | 0 | 0 |
| **ShopWise AI (SA)** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | -- | 3 | 4 |
| **ClearView (CV)** | 1 | 0 | 2 | 4 | 2 | 0 | 0 | 0 | 3 | -- | 3 |
| **Certifiable Inc. (CI)** | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 4 | 3 | -- |

**Strongest KataLog pairings (score 4):**
- **Farmacy Food / Farmacy Family (4)**: Same organization, food/health domain, startup budget. Farmacy Family explicitly extends Farmacy Food. Studying both reveals how architectures evolve from greenfield to brownfield extension.
- **Spotlight Platform / ClearView (4)**: Same client (Diversity Cyber Council), non-profit budget, HR domain. ClearView adds AI centrality. Reveals how the same organization's needs evolved from traditional platform (2022) to AI-centric platform (2024).
- **ShopWise AI / Certifiable Inc. (4)**: Both AI-centric where AI is the core value proposition. Certifiable adds high-stakes accountability. Reveals how AI architecture patterns mature from low-stakes to high-stakes.

---

### How to Use the Similarity Clusters

1. **Find your closest cluster**: Identify the cluster whose shared dimensions most closely match your situation. Start with the Discovered domain distribution -- if your domain appears in the 35 Discovered domains, that cluster provides the strongest statistical evidence.
2. **Check Discovered domain coverage**: If your domain has Discovered repos, the style distribution for that domain shows what real systems actually use.
3. **Add production depth**: A problem validated in AOSA or RealWorld has architectural reasoning from the system creators -- the highest-authority evidence.
4. **Add competition reasoning**: KataLog challenges provide structured problem decomposition (cost projections, constraint documentation, judge commentary) that production systems rarely publish.
5. **Use Discovered statistics for pattern frequency**: Event-Driven in 78 of 122 repos, Modular Monolith in 29, Microservices in 45 -- these are statistically significant code-level signals.
6. **Cross-reference solution evidence**: The [Solution Space Taxonomy](solution-spaces.md) maps these problem profiles to specific architecture styles. The [Problem-Solution Matrix](problem-solution-matrix.md) provides the direct cross-reference. The [Evidence by Architecture Style](evidence/by-architecture-style.md) provides per-style evidence depth.

---

*Problem taxonomy derived from 122 real systems across 35 domains (Discovered), validated by 17 production-narrated systems (12 AOSA, 5 RealWorld), structured by 11 competition challenges with 78 team submissions (KataLog), and illustrated by 8 reference implementations (RefArch). Total catalog: 158 unique projects (225 entries including cross-source overlap). Source data: `evidence-analysis/*/docs/catalog/_index.yaml`, `docs/analysis/challenges/*.md`, `docs/analysis/cross-cutting.md`.*
