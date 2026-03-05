# Problem Space Taxonomy

A reference classification of problem profiles spanning all 5 evidence sources in the architecture reference library (225 catalog entries across KataLog, AOSA, RealWorldASPNET, ReferenceArchitectures, and Discovered). Use this document to find the problem profile that most closely resembles your own, then study the corresponding solution patterns in the [Solution Space Taxonomy](solution-spaces.md) and [Problem-Solution Matrix](problem-solution-matrix.md).

---

## How to Use This Document

1. **Identify your problem dimensions.** Read the Dimension Definitions below and determine where your problem falls on each axis (domain type, scale, budget context, compliance burden, integration complexity, real-time needs, edge/offline requirements, AI/ML component, greenfield vs. brownfield).

2. **Scan the Classification Matrix.** Find the row(s) that most closely match your problem across multiple dimensions. The "Source" column tells you what kind of evidence backs each profile: competition design (KataLog), production narrative (AOSA), production application (RealWorld), reference implementation (RefArch), or code-level discovery (Discovered). The "Key Tension" column captures the central architectural dilemma -- if your key tension matches, the solutions from that profile are likely relevant.

3. **Read the Detailed Problem Profile.** Each major profile has a detailed write-up with evidence-backed classifications. Production-validated profiles (AOSA, RealWorld) are marked with a production badge. Use these to confirm relevance before diving into solution evidence.

4. **Use the Problem Similarity Clusters.** The similarity analysis groups profiles by shared problem dimensions across all 5 sources. If your problem matches one profile strongly, the cluster members provide additional solution evidence from different evidence types.

5. **Explore the Dimension Deep Dives.** The deep-dive sections group profiles by each dimension and extract the architectural patterns that emerge at each tier, drawing on competition, production, reference, and discovered evidence.

6. **Cross-reference other library docs.** The [Evidence by Architecture Style](evidence/by-architecture-style.md) and [Evidence by Quality Attribute](evidence/by-quality-attribute.md) documents provide complementary views. The [Cross-Source Analysis](evidence/cross-source-analysis.md) shows where evidence sources agree or disagree.

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

### KataLog Problem Profiles (11 profiles, 78 team submissions)

Evidence type: **competition design** -- teams designed architectures under time constraints for fictional scenarios. Strongest evidence for trade-off reasoning and decision-making under pressure.

| Problem Profile | Source | Domain Type | Scale | Budget Context | Compliance | Integration | Real-time | Edge/Offline | AI/ML | Greenfield | Key Tension |
|-----------------|--------|-------------|-------|----------------|------------|-------------|-----------|-------------|-------|------------|-------------|
| Farmacy Food | KataLog | Food / Logistics | Small-Large | Startup | Food Safety, PCI | High | Medium | Yes (smart fridges) | None | Greenfield | Scale cheaply now vs. architect for national growth |
| Sysops Squad | KataLog | Enterprise IT / Field Service | Large | Enterprise | PCI | Medium | Medium | No | None | Brownfield (migration) | Migrate a failing monolith without losing the business |
| Farmacy Family | KataLog | Health / Community | Small-Medium | Startup | HIPAA, GDPR | High | Low | No | Peripheral | Brownfield (extension) | Startup budget vs. enterprise-grade health compliance |
| Spotlight Platform | KataLog | Non-Profit / HR Tech | Medium | Non-Profit | GDPR | Medium | Low | No | Peripheral | Greenfield | Non-profit budget vs. platform ambition |
| Hey Blue! | KataLog | Civic Tech / Social Impact | Large-Very Large | Non-Profit | GDPR, Officer Safety | Medium | High | No | None | Greenfield | Real-time officer safety vs. community engagement at scale |
| Wildlife Watcher | KataLog | Conservation / IoT | Small-Medium | Non-Profit | Geoprivacy | Very High | Medium | Yes (edge cameras) | Supporting | Greenfield | Ultra-constrained edge hardware vs. cloud AI sophistication |
| Road Warrior | KataLog | Travel / Consumer | Very Large | Startup | GDPR, PCI | High | High | No | None | Greenfield | 99.99% availability at startup cost |
| MonitorMe | KataLog | Healthcare / MedTech | Medium | Enterprise | None explicit | Medium | Critical | Yes (on-prem appliance) | None | Greenfield | Life-critical latency on constrained on-premises hardware |
| ShopWise AI | KataLog | Retail / E-Commerce | Small | Not specified | None | Low | Low | No | Central | Greenfield | AI accuracy and cost vs. rapid prototyping |
| ClearView | KataLog | HR / AI Bias Reduction | Medium | Non-Profit | PII, Anti-bias | High | Low | No | Central | Greenfield | LLM cost/non-determinism vs. bias-free hiring at non-profit budget |
| Certifiable Inc. | KataLog | EdTech / Certification | Medium-Large | Enterprise (thin margins) | Certification integrity | Low | Low | No | Central | Brownfield (extension) | AI autonomy vs. career-affecting accuracy in high-stakes grading |

### AOSA Problem Profiles (12 projects, production-validated)

Evidence type: **production narrative** -- architectural descriptions written by system creators. These systems have been built, deployed, and operated at scale. Source: AOSA Volumes 1-2 (2011-2012).

| Problem Profile | Source | Domain Type | Scale | Budget Context | Compliance | Integration | Real-time | Edge/Offline | AI/ML | Greenfield | Key Tension |
|-----------------|--------|-------------|-------|----------------|------------|-------------|-----------|-------------|-------|------------|-------------|
| LLVM | AOSA | Compiler Infrastructure | Very Large | Open-Source | None | Medium (frontends, backends, tools) | None (batch compilation) | No | None | Greenfield | Extensibility of IR vs. compilation performance across dozens of targets |
| HDFS | AOSA | Distributed Storage / Big Data | Very Large | Open-Source / Enterprise | None explicit | Medium (Hadoop ecosystem) | Low (batch-oriented) | No | None | Greenfield | Fault tolerance at commodity hardware scale vs. write throughput |
| Riak | AOSA | Distributed Database / KV Store | Large | Open-Source / Enterprise | None explicit | Low (KV API) | Medium (low-latency reads) | No | None | Greenfield | Availability vs. consistency in partitioned networks (CAP) |
| Selenium WebDriver | AOSA | Testing / Browser Automation | Very Large | Open-Source | None | Very High (per-browser drivers) | Medium (test execution) | No | None | Brownfield (extension) | Unified API vs. browser-specific behavior divergence |
| Graphite | AOSA | Monitoring / Metrics | Large | Open-Source | None | High (any metric source) | Medium (near-real-time dashboards) | No | None | Greenfield | Storage efficiency vs. query flexibility for time-series data |
| NGINX | AOSA | Web Infrastructure | Very Large | Open-Source / Enterprise | None explicit | High (upstream servers, modules) | High (request serving) | No | None | Greenfield | C10K concurrency vs. memory efficiency on single machines |
| Git | AOSA | Version Control / Developer Tools | Very Large | Open-Source | None | Low (content-addressable) | None (local operations) | Yes (fully offline) | None | Greenfield | Distributed workflow integrity vs. repository scale and merge complexity |
| ZeroMQ | AOSA | Messaging / Distributed Systems | Large | Open-Source | None | High (any transport) | High (low-latency messaging) | No | None | Greenfield | Zero-copy performance vs. multi-pattern messaging flexibility |
| Twisted | AOSA | Networking Framework | Large | Open-Source | None | High (multi-protocol) | High (async I/O) | No | None | Greenfield | Async programming complexity vs. protocol diversity support |
| SQLAlchemy | AOSA | Database / ORM | Large | Open-Source | None | High (multi-database) | None (query generation) | No | None | Greenfield | ORM convenience vs. SQL expressiveness and database portability |
| Puppet | AOSA | Infrastructure / Config Management | Large | Open-Source / Enterprise | Compliance as a feature | High (managed infrastructure) | Low (convergence intervals) | No | None | Greenfield | Declarative simplicity vs. imperative escape hatches for complex orchestration |
| GStreamer | AOSA | Multimedia / Streaming | Large | Open-Source | None | Very High (codecs, devices, protocols) | High (real-time media) | No | None | Greenfield | Pipeline flexibility vs. real-time media performance guarantees |

### RealWorldASPNET Problem Profiles (5 projects, production-validated)

Evidence type: **production application** -- actively maintained, production-grade applications with real users. Highest evidence weight (20 pts per project). Source: real-world-aspnetcore curation.

| Problem Profile | Source | Domain Type | Scale | Budget Context | Compliance | Integration | Real-time | Edge/Offline | AI/ML | Greenfield | Key Tension |
|-----------------|--------|-------------|-------|----------------|------------|-------------|-----------|-------------|-------|------------|-------------|
| Squidex | RealWorld | Headless CMS / Content Management | Medium-Large | Open-Source (~2,300 stars) | Multi-tenant data isolation | Medium (APIs, webhooks, scripting) | Medium (content delivery) | No | None | Greenfield | Event sourcing complexity vs. content management flexibility with CQRS |
| Bitwarden Server | RealWorld | Security / Password Management | Very Large | Open-Source / Commercial (~16,000 stars) | SOC 2, security audits | Medium (browser extensions, clients) | Medium (vault sync) | Yes (offline vault access) | None | Greenfield | Zero-knowledge encryption vs. usable cross-device sync at scale |
| Jellyfin | RealWorld | Media Server / Streaming | Large | Open-Source Community (~38,000 stars) | None explicit | High (media formats, clients, metadata providers) | High (real-time transcoding) | Yes (local media server) | None | Greenfield | Plugin extensibility vs. real-time transcoding performance |
| Orchard Core | RealWorld | CMS / Application Framework | Medium-Large | Open-Source (~7,500 stars) | None explicit | Medium (modules, themes) | Low | No | None | Greenfield | Module isolation vs. shared-state performance in a modular monolith |
| nopCommerce | RealWorld | E-Commerce | Large | Open-Source / Commercial (~9,500 stars) | PCI (payment processing) | High (payment gateways, shipping, tax, plugins) | Low | No | None | Brownfield (17-year evolution) | Plugin ecosystem stability vs. framework evolution over 17 years |

### ReferenceArchitectures Problem Profiles (8 projects, reference implementations)

Evidence type: **reference implementation** -- curated repositories serving as canonical pattern examples with working, deployable code. Source: selected for pattern coverage aligned with 12 canonical architecture styles.

| Problem Profile | Source | Domain Type | Scale | Budget Context | Compliance | Integration | Real-time | Edge/Offline | AI/ML | Greenfield | Key Tension |
|-----------------|--------|-------------|-------|----------------|------------|-------------|-----------|-------------|-------|------------|-------------|
| eShopOnContainers | RefArch | E-Commerce | Medium-Large | Microsoft Reference | None explicit | High (microservices, event bus) | Medium (ordering) | No | None | Greenfield | Microservices coordination complexity vs. domain isolation |
| eShop | RefArch | E-Commerce | Medium-Large | Microsoft Reference | None explicit | Medium (simplified from eShopOnContainers) | Medium (ordering) | No | None | Greenfield | Modern .NET simplification vs. distributed systems patterns |
| Modular Monolith with DDD | RefArch | Conference Management | Medium | Reference | None explicit | Low (internal modules) | Low | No | None | Greenfield | Module boundary enforcement vs. cross-cutting concern sharing |
| Clean Architecture Template | RefArch | Task Management | Small-Medium | Reference | None explicit | Low (template) | Low | No | None | Greenfield | Clean Architecture purity vs. pragmatic shortcuts |
| BuckPal | RefArch | Banking / Money Transfer | Small | Reference | Financial regulations | Low (hexagonal ports) | Low | No | None | Greenfield | Hexagonal port abstraction overhead vs. domain model purity |
| Wild Workouts | RefArch | Fitness / Workout Scheduling | Small-Medium | Reference | None explicit | Medium (microservices) | Low | No | None | Greenfield | DDD tactical patterns overhead vs. Go idioms |
| Serverless Microservices | RefArch | Ride-Sharing | Medium-Large | Microsoft Reference | None explicit | High (serverless functions, event grid) | High (ride matching) | No | None | Greenfield | Serverless cold-start latency vs. event-driven scalability |
| AKS Baseline Cluster | RefArch | Container Platform / Infrastructure | Large | Microsoft Reference | Enterprise compliance | High (Azure services, networking) | Medium | No | None | Greenfield | Kubernetes operational complexity vs. workload isolation and scaling |

### Discovered Domain Cluster Profiles (122 projects, code-level evidence)

Evidence type: **automated discovery** -- architecture signals extracted from public GitHub repositories via the dataset scaling pipeline. These represent code-level evidence of architecture patterns in real codebases. The top domain clusters are summarized below as aggregate profiles.

| Problem Profile | Source | Domain Type | Scale | Budget Context | Compliance | Integration | Real-time | Edge/Offline | AI/ML | Greenfield | Key Tension |
|-----------------|--------|-------------|-------|----------------|------------|-------------|-----------|-------------|-------|------------|-------------|
| Developer Tools Cluster (36 repos) | Discovered | Developer Tools / Frameworks | Varies | Open-Source | None typical | Medium-High (multi-platform) | Low-Medium | No | None-Peripheral | Mostly Greenfield | Framework extensibility vs. opinionated conventions |
| E-Commerce Cluster (11 repos) | Discovered | E-Commerce | Medium-Large | Open-Source / Commercial | PCI | High (payments, shipping) | Medium | No | None | Mixed | Monolith-to-microservices migration path vs. operational complexity |
| Infrastructure Cluster (7 repos) | Discovered | Service Mesh / Proxy / Discovery | Large-Very Large | Open-Source / Enterprise | Enterprise compliance | Very High (all services) | High (proxy latency) | No | None | Greenfield | Proxy overhead vs. observability and traffic control |
| AI/ML Cluster (6 repos) | Discovered | AI/ML Agents and Pipelines | Varies | Open-Source | None explicit | Medium (LLM APIs) | Low-Medium | No | Central | Greenfield | Multi-agent coordination vs. single-agent simplicity |
| Data Grid Cluster (6 repos) | Discovered | In-Memory Data / Caching | Very Large | Open-Source / Enterprise | None explicit | High (client libraries) | Critical (sub-ms latency) | No | None | Greenfield | Memory efficiency vs. data distribution and consistency |
| Workflow Orchestration Cluster (5 repos) | Discovered | Workflow / Job Scheduling | Large | Open-Source | Audit trails | High (task executors, plugins) | Medium (job scheduling) | No | None | Greenfield | Workflow definition flexibility vs. execution reliability |
| Data Processing Cluster (5 repos) | Discovered | Stream / Batch Processing | Very Large | Open-Source / Enterprise | Data governance | Very High (connectors) | High (stream latency) | No | None | Greenfield | Exactly-once processing guarantees vs. throughput |
| Messaging Cluster (5 repos) | Discovered | Message Broker / Event Bus | Very Large | Open-Source / Enterprise | None explicit | High (producers, consumers) | High (delivery latency) | No | None | Greenfield | Delivery guarantees vs. throughput and latency |

---

## Detailed Problem Profiles

### KataLog Profiles

#### Farmacy Food (Fall 2020)

**Domain**: Food tech / Ghost kitchen logistics
**Scale trajectory**: Single city (Detroit) to national expansion -- hundreds to thousands of customers
**Budget context**: Startup with limited funding and small development team. ArchColider's cost model projected $12K-$23K/year infrastructure costs across three growth scenarios.
**Compliance needs**: Food safety (expiry management, allergen tracking), PCI-DSS (payment processing). Future HIPAA concerns if health data integration proceeds.
**Integration complexity**: HIGH -- Byte Technology smart fridges (RFID, cloud API), Toast POS kiosks, ChefTec kitchen management (unclear API, $500-$5000+ integration cost per Jaikaturi's vendor research), QuickBooks accounting.
**Real-time needs**: Medium -- inventory sync between fridges and central system must handle eventual consistency; order processing; push notifications.
**Edge/offline needs**: Yes -- smart fridges must authenticate customers and release meals even without internet connectivity. Jaikaturi designed a CDN-based offline authentication using hashed credit card subsets.
**AI/ML component**: None in core requirements. Self-Driven Team proposed an ML recommendation engine as an extension.
**Greenfield/brownfield**: Greenfield -- new system, though integrating with existing third-party platforms.
**Key architectural tension**: How to build a system cheaply enough for a startup but with enough structural integrity to scale nationally. The winner (ArchColider) chose a modular monolith specifically to avoid premature distributed systems complexity.
**Number of external systems**: 4+ (Byte Technology, Toast, ChefTec, QuickBooks, payment processor)
**Data sensitivity**: Medium -- payment data (PCI), dietary preferences, future health data

---

#### Sysops Squad (Spring 2021)

**Domain**: Enterprise IT / Field service management
**Scale trajectory**: Existing nationwide operation -- large-scale consumer electronics retailer across the United States with established customer base.
**Budget context**: Established enterprise (Penultimate Electronics). Cost is a concern but not existential -- the business line will be shut down entirely if the architecture is not fixed.
**Compliance needs**: PCI-DSS (credit card data for service plan billing). Teams universally separated billing into its own domain with dedicated storage.
**Integration complexity**: Medium -- payment processing system, notification (SMS/email), existing monolithic database. The integration challenge is primarily internal (decomposing the monolith) rather than external.
**Real-time needs**: Medium -- ticket routing and assignment should be responsive; expert availability tracking needs near-real-time updates; reporting can be batch.
**Edge/offline needs**: No -- web portals, mobile apps, and call-center interfaces all assume connectivity.
**AI/ML component**: None in core requirements. Global Architects proposed an ML chatbot for demand reduction.
**Greenfield/brownfield**: Brownfield (migration) -- the entire challenge is about decomposing a failing monolith into a target architecture while maintaining operations. Team Seven's winning approach centered on the transition architecture, not just the target state.
**Key architectural tension**: How to migrate from a monolith to a decomposed architecture without disrupting an active nationwide business. The transition path matters more than the destination.
**Number of external systems**: 2-3 (payment processor, notification services, existing monolithic database)
**Data sensitivity**: Medium-high -- customer PII, credit card data, service history, expert location data

---

#### Farmacy Family (Fall 2021)

**Domain**: Health / Community engagement platform
**Scale trajectory**: Small to medium -- extending an existing startup's customer base from transactional to engaged. Hundreds to low thousands of users.
**Budget context**: Startup. The existing Farmacy Foods system constrains the budget. Architects++ explicitly chose Facebook Groups, Eventbrite, and WordPress to minimize custom build surface.
**Compliance needs**: HIPAA (medical data sharing between customers, dieticians, and clinics), GDPR (data privacy, right to erasure). The Archangels addressed GDPR via crypto-shredding. Architects++ made the deliberate decision NOT to isolate HIPAA functionality initially, arguing the operational burden outweighed the technical architecture concern.
**Integration complexity**: HIGH -- must integrate with the existing Farmacy Foods reactive monolith, plus health data APIs (Human API, Epic EHR/EMR per Pentagram 2021), community platforms, and analytics pipelines. Kafka appeared in 5 of 7 submissions as the integration backbone.
**Real-time needs**: Low -- community engagement, forums, classes, and analytics are not latency-sensitive. Customer segmentation is explicitly a batch process.
**Edge/offline needs**: No.
**AI/ML component**: Peripheral -- dietary recommendations and customer segmentation. Sever Crew proposed AWS Forecast ML. Not a core requirement.
**Greenfield/brownfield**: Brownfield (extension) -- the system sits alongside and integrates with an existing platform (ArchColider's Farmacy Foods design from Fall 2020).
**Key architectural tension**: Startup budget vs. enterprise-grade health compliance. Teams had to balance rapid time-to-market for community features against the legal and technical weight of HIPAA compliance.
**Number of external systems**: 4+ (Farmacy Foods, health APIs, community platforms, analytics)
**Data sensitivity**: High -- medical data (HIPAA), dietary preferences, customer behavioral data

---

#### Spotlight Platform (Spring 2022)

**Domain**: Non-profit / HR tech / Diversity & inclusion
**Scale trajectory**: Medium -- connecting underrepresented candidates with non-profit training organizations. PegasuZ defined availability targets of 3-4 nines, implying thousands of concurrent users at maturity.
**Budget context**: Non-profit (Diversity Cyber Council, 501(c)(3)). Severely cost-constrained. PegasuZ asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" TheGlobalVariables calculated per-user costs as low as $0.002/month.
**Compliance needs**: GDPR (candidate PII). Multiple teams addressed data purging and consent management.
**Integration complexity**: Medium -- non-profit organizations' systems, content management, notification systems. The challenge emphasized rich content (text, links, PDFs) and automatic matching rather than complex external integrations.
**Real-time needs**: Low -- candidate-to-offering matching and reporting are not latency-sensitive. Notifications need reasonable timeliness but not sub-second delivery.
**Edge/offline needs**: No. Wright-Stuff proposed an IVR system for phoneless candidates, but this is connectivity-constrained rather than offline.
**AI/ML component**: Peripheral -- candidate matching and recommendation. The Marmots planned a data-first approach (collect assignment data before building ML models). TheGlobalVariables proposed AWS SageMaker for predictions.
**Greenfield/brownfield**: Greenfield -- entirely new platform.
**Key architectural tension**: Non-profit budget vs. platform ambition. The kata required enterprise-grade features (matching, analytics, content management, reporting) at non-profit funding levels. The winner (PegasuZ) resolved this by starting with a modular monolith MVP.
**Number of external systems**: 2-3 (non-profit systems, content platforms, notification)
**Data sensitivity**: Medium -- candidate PII, demographic data, progress tracking

---

#### Hey Blue! (Fall 2022)

**Domain**: Civic tech / Social impact / Community-police relations
**Scale trajectory**: Large to Very Large -- the stated target was 1.2 billion annual connections across U.S. cities, implying millions of users. Initial launch is startup-scale.
**Budget context**: Non-profit (EcoSchool). Grant-funded. MonArch projected $2,780/month for 50K MAU on GCP.
**Compliance needs**: GDPR (international expansion potential per IPT), officer safety/privacy (location tracking of law enforcement creates serious safety risks). It Depends deliberately deviated from requirements to protect officer locations.
**Integration complexity**: Medium -- social media APIs, retail storefront systems for points redemption, charity/donation platforms. IPT's Microkernel Dispatcher for business integration recognized that participating businesses range from REST-capable chains to phone/fax-only shops.
**Real-time needs**: High -- officer proximity detection, real-time connection workflows, WebSocket-based location streaming, push notifications. MonArch designed an in-memory graph database for O(log n) proximity lookups.
**Edge/offline needs**: No, though Black Cat Manifestation's QR code approach bypassed geolocation entirely for in-person interactions.
**AI/ML component**: None.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: Real-time officer safety vs. community engagement at scale. The system must make officers discoverable while protecting their locations from misuse, and must handle enterprise-grade geolocation on a non-profit budget.
**Number of external systems**: 3-5 (social media, retail partners, charity platforms, payment processing)
**Data sensitivity**: High -- officer location data (safety-critical), user PII, transaction data

---

#### Wildlife Watcher (Fall 2023)

**Domain**: Conservation technology / IoT / Edge computing
**Scale trajectory**: Small to medium -- hundreds of cameras and users initially, with open-source community growth potential. Not a mass-consumer application.
**Budget context**: Non-profit (Wildlife.ai charitable trust). Cost-consciousness drove architecture decisions across all teams. Wonderous Toys chose modular monolith explicitly for cost-effectiveness.
**Compliance needs**: Geoprivacy for endangered species (AnimAI's ADR-003 recognized that camera location data could be exploited by poachers). Wildlife Watchers implemented user vetting before granting data access.
**Integration complexity**: VERY HIGH -- the challenge required integration with 8+ external platforms: iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite. Each has different APIs, deployment models (SaaS vs. self-hosted), data formats, and authentication mechanisms. Celus Ceals produced comparative analysis tables for all platforms.
**Real-time needs**: Medium -- camera alerts should propagate in near-real-time, but conservation observation workflows tolerate minutes of delay. Rapid Response calculated actual transmission times (31KB image over LoRaWAN = 240 seconds).
**Edge/offline needs**: Yes -- this is the defining constraint. Wildlife cameras operate on ultra-low-power microcontrollers (up to 512KB Flash) with unreliable connectivity (LoRaWAN at 1kbps, 3G, satellite). AI species identification must run on-device. Cameras may be physically inaccessible.
**AI/ML component**: Supporting -- on-device AI for species identification is a core requirement, but the system's primary value is the observation platform, not the AI itself. ML training is explicitly external (Roboflow, Edge Impulse, TensorFlow Lite).
**Greenfield/brownfield**: Greenfield -- open-source project.
**Key architectural tension**: Ultra-constrained edge hardware vs. cloud AI sophistication. Teams had to design for 512KB microcontrollers that run AI inference while connected via LoRaWAN at 1kbps, yet integrate with cloud-based labeling and training platforms.
**Number of external systems**: 8+ (iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite)
**Data sensitivity**: Medium -- geoprivacy for endangered species, open data risks

---

#### Road Warrior (Fall 2023 External)

**Domain**: Travel / Consumer technology
**Scale trajectory**: Very Large -- 15 million total users, 2 million active weekly. The largest user base of any kata challenge.
**Budget context**: Startup with time-to-market urgency. Iconites proposed a tiered business model (Freemium/Silver/Gold) and phased MVP with cost projections ($496.95/month initial infrastructure).
**Compliance needs**: GDPR (international travelers), PCI-DSS (payment processing for premium tiers). Street Fighters produced a comprehensive GDPR ADR covering data classification, consent management, encryption, breach notification, and DPO designation.
**Integration complexity**: HIGH -- SABRE and APOLLO travel agency APIs, email providers (Gmail, Outlook, iCloud via IMAP/webhooks), social media APIs, analytics platforms. Email integration was the hardest technical challenge -- Street Fighters estimated 4,000 email filtering requests/second.
**Real-time needs**: High -- travel updates must be reflected within 5 minutes (hard requirement), web response times under 800ms, mobile first contentful paint under 1.4s. 99.99% availability requirement (max 5 minutes unplanned downtime per month).
**Edge/offline needs**: No.
**AI/ML component**: None in core requirements. Analytics data collection for future monetization.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: 99.99% availability for millions of users at startup cost. The system demands enterprise-grade reliability and performance (the strictest SLAs of any kata) while being built by a startup without established infrastructure.
**Number of external systems**: 5+ (SABRE, APOLLO, email providers, social media, payment)
**Data sensitivity**: High -- travel itineraries, email access, payment data, location data

---

#### MonitorMe (Winter 2024)

**Domain**: Healthcare / Medical device monitoring
**Scale trajectory**: Medium -- up to 500 patients per installation, up to 25 nurse stations. Fixed ceiling, not open-ended growth. BluzBrothers explicitly downplayed scalability (ADR-008) since the 500-patient ceiling was hard.
**Budget context**: Established enterprise (StayHealthy, Inc. already has two cloud-based SaaS products). Budget supports proprietary hardware development.
**Compliance needs**: The kata explicitly stated HIPAA compliance was not required. The system operates on-premises with proprietary hardware, behind hospital infrastructure. Security was consistently acknowledged but deferred by most teams.
**Integration complexity**: Medium -- must integrate with StayHealthy's existing cloud products (MyMedicalData via secure HTTP API, MonitorThem for analytics). 8 device types with different sampling rates (heart rate at 500ms, ECG at 1s, blood pressure at 1hr, etc.).
**Real-time needs**: CRITICAL -- sub-1-second average response time for nurse station displays. Vital sign anomaly alerting is life-critical. BluzBrothers proved 693ms end-to-end latency through fitness function calculations. This is the highest real-time requirement of any kata.
**Edge/offline needs**: Yes -- the entire system is an on-premises hospital appliance. It must operate independently of cloud connectivity. LowCode designed a distributed 3-node appliance with graceful degradation (3 nodes = full function, 2 nodes = full function, 1 node = alerting only).
**AI/ML component**: None -- anomaly detection uses configurable threshold rules, not ML.
**Greenfield/brownfield**: Greenfield -- new product, though it integrates with existing StayHealthy cloud products.
**Key architectural tension**: Life-critical latency on constrained on-premises hardware. The system must guarantee sub-second vital sign display and reliable alerting while running entirely on proprietary hardware in a hospital, with no cloud fallback.
**Number of external systems**: 2 (MyMedicalData, MonitorThem) plus 8 medical device types
**Data sensitivity**: Very High -- vital signs, patient health data (even though HIPAA was explicitly excluded)

---

#### ShopWise AI Assistant (AI Winter 2024)

**Domain**: Retail / E-commerce / AI chatbot
**Scale trajectory**: Small -- single e-commerce store with product catalog and order database. No explicit user count requirements.
**Budget context**: Not specified. Implicit cost consciousness around LLM API costs. ConnectedAI used a dual-LLM strategy (Claude for reasoning, Gemini Flash for routing) to manage costs.
**Compliance needs**: None explicit. IntelliMutual acknowledged their database was in a public subnet as a security concern. SQL injection via LLM-generated queries is an implicit risk.
**Integration complexity**: Low -- product/order database is the primary integration. No external third-party systems beyond LLM API providers.
**Real-time needs**: Low -- chatbot response times should be conversational (seconds), but there are no hard latency SLAs.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- the AI chatbot IS the product. This was the first AI-focused kata. All four teams converged on text-to-SQL as the core pattern. ConnectedAI implemented a multi-agent supervisor hierarchy with four specialist agents. Breakwater validated that SQL outperformed RAG for structured data retrieval.
**Greenfield/brownfield**: Greenfield -- new system with a provided database.
**Key architectural tension**: AI accuracy and cost vs. rapid prototyping. Teams had to balance sophisticated multi-agent architectures (ConnectedAI) against practical working prototypes (Breakwater's n8n low-code approach). The kata uniquely required working software, not just diagrams.
**Number of external systems**: 1 (LLM API provider -- though multiple models were used)
**Data sensitivity**: Low -- product catalog and order data. No health or financial data.

---

#### ClearView (Fall 2024)

**Domain**: HR / AI for bias reduction in recruitment
**Scale trajectory**: Medium -- Pragmatic and Katamarans designed for initial deployment with a manageable candidate pool. Equihire Architects explicitly scoped to 5,000 candidates.
**Budget context**: Non-profit (Diversity Cyber Council). LLM costs are a primary architectural concern. Katamarans calculated $0.06 per candidate for a full hiring flow. DevExperts estimated $8,448/year total infrastructure.
**Compliance needs**: PII protection (resume data, demographic information), anti-bias requirements (the system must eliminate bias while relying on LLMs that carry biases). Katamarans dedicated two ADRs to PII safety.
**Integration complexity**: HIGH -- the platform must integrate with an unbounded number of third-party HR systems (ATS, HRIS), each with different APIs, data formats, and authentication mechanisms. Every team identified HR integration as a first-class architectural concern, using adapter/connector patterns.
**Real-time needs**: Low -- resume anonymization and matching are batch or near-batch processes. No sub-second requirements.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- AI performs resume anonymization, candidate story construction, and job matching. This is the core value proposition. Pragmatic's deterministic matching approach (extract features with LLM, then match deterministically) reduced LLM calls from O(n*m) to O(n+m).
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: LLM cost and non-determinism vs. bias-free hiring at non-profit budget. Teams must build an AI-centric platform that eliminates bias (the whole point) while controlling costs and maintaining transparency/explainability.
**Number of external systems**: Unbounded (HR systems) + LLM providers
**Data sensitivity**: High -- resumes, demographic data, employment history, PII requiring anonymization

---

#### Certifiable Inc. (Winter 2025)

**Domain**: EdTech / AI-assisted certification grading
**Scale trajectory**: Medium to Large -- 200 candidates/week currently, with projected 5-10X surge to 1,000-2,000/week from international expansion.
**Budget context**: Established organization with thin margins. The $800 exam fee and $550 grading cost (11 expert-hours at $50/hr) leave slim profitability. AI must reduce costs, not add them. ZAITects projected 80% cost reduction ($940K to $190K grading costs/week).
**Compliance needs**: Certification integrity -- errors can derail careers. This is not regulatory compliance but an ethical/reputational constraint that is arguably more demanding than formal regulation. Every team implemented human-in-the-loop; no team proposed fully autonomous AI grading.
**Integration complexity**: Low -- the AI system integrates with the existing SoftArchCert platform. No complex external system integrations.
**Real-time needs**: Low -- grading is a batch process. Candidates wait days for results.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- AI grading is the entire value proposition. This is the highest-stakes AI challenge in the kata series (career-affecting outcomes). ZAITects separated the Grader from the Judge (LLM-as-a-Judge pattern). Software Architecture Guild ran six parallel AI solution variants via microkernel architecture. Usfive deliberately rejected RAG to avoid homogenizing acceptable answers.
**Greenfield/brownfield**: Brownfield (extension) -- adding AI capabilities to an existing certification platform.
**Key architectural tension**: AI autonomy vs. career-affecting accuracy. How much grading autonomy should the AI have when errors can derail someone's professional career? Every team used confidence-based escalation to human reviewers.
**Number of external systems**: 1 (existing SoftArchCert platform) + LLM providers
**Data sensitivity**: High -- candidate exam responses, personal career data, certification outcomes

---

### AOSA Production Profiles

#### LLVM -- Compiler Infrastructure [PRODUCTION-VALIDATED]

**Domain**: Compiler infrastructure serving dozens of language frontends and hardware targets.
**Architecture styles**: Pipeline, Modular Architecture, Plugin Architecture.
**Scale**: One of the most widely deployed compiler infrastructures in the world (Clang, Rust, Swift all use LLVM as a backend).
**Key architectural insight**: The three-phase design (frontend -> optimizer -> backend) with a language-agnostic Intermediate Representation (IR) is the canonical example of Pipeline architecture. The IR acts as the decoupling layer that enables N frontends to target M backends through a single optimization pipeline, avoiding the N*M problem.
**Cross-source parallel**: The Pipeline pattern appears in AOSA (LLVM, Graphite, GStreamer), RealWorld (Jellyfin transcoding), and Discovered (Pipe-and-Filter in 32 of 122 repos). LLVM provides the most rigorous production evidence for why Pipeline succeeds at scale.

---

#### HDFS -- Distributed Storage [PRODUCTION-VALIDATED]

**Domain**: Distributed file system for Big Data workloads, core component of the Hadoop ecosystem.
**Architecture styles**: Primary-Secondary (Master-Slave), Data Replication.
**Scale**: Deployed at petabyte scale across thousands of commodity machines at Yahoo!, Facebook, and others.
**Key architectural insight**: The NameNode (single master) design traded availability for simplicity -- a pragmatic choice that worked for batch workloads but became the system's primary limitation as the ecosystem matured. Teams facing similar trade-offs should study how HDFS evolved (NameNode HA, federation) to address the single-point-of-failure.
**Cross-source parallel**: Contrasts with Riak's masterless approach (also AOSA). Compare with the Data Grid cluster in Discovered (Redis, Dragonfly, Hazelcast) which demonstrates the alternative: masterless replication for availability.

---

#### Riak -- Distributed Database [PRODUCTION-VALIDATED]

**Domain**: Distributed key-value store designed for high availability.
**Architecture styles**: Peer-to-Peer (Masterless), Eventual Consistency.
**Scale**: Deployed at enterprise scale for applications requiring always-available writes.
**Key architectural insight**: Riak chose the opposite side of the CAP trade-off from HDFS -- favoring availability and partition tolerance over strong consistency. The ring-based consistent hashing, vector clocks for conflict detection, and read-repair demonstrate how to build systems that tolerate network partitions gracefully.
**Cross-source parallel**: The availability-vs-consistency tension appears in KataLog (Farmacy Food's eventual consistency for fridge inventory) and Discovered (CockroachDB chose strong consistency; Redis chose availability).

---

#### Selenium WebDriver -- Testing Infrastructure [PRODUCTION-VALIDATED]

**Domain**: Browser automation framework serving the global QA/testing ecosystem.
**Architecture styles**: Service-Based, Adapter Pattern (per-browser drivers).
**Scale**: The dominant browser automation framework, with millions of daily test executions worldwide.
**Key architectural insight**: The Adapter Pattern (one driver per browser) is a textbook solution for heterogeneous integration. The WebDriver wire protocol acts as the unified API that abstracts browser-specific behavior, identical in principle to ClearView's adapter pattern for HR systems (KataLog) and Wildlife Watcher's integration plugin pattern.
**Cross-source parallel**: Adapter/connector patterns appear across all 5 sources: KataLog (ClearView HR adapters, Wildlife Watcher platform plugins), AOSA (Selenium, SQLAlchemy multi-database), RealWorld (nopCommerce payment gateways), RefArch (eShopOnContainers event bus), Discovered (debezium connectors, nifi processors).

---

#### Graphite -- Monitoring Infrastructure [PRODUCTION-VALIDATED]

**Domain**: Time-series metrics collection, storage, and visualization.
**Architecture styles**: Pipeline, Service-Based.
**Scale**: Deployed at scale for infrastructure monitoring across thousands of servers.
**Key architectural insight**: Graphite's three-component pipeline (Carbon collector -> Whisper storage -> Graphite-web rendering) demonstrates how Pipeline architecture naturally emerges for monitoring domains. The time-series storage trade-off (resolution vs. retention) is a domain-specific constraint that shaped the architecture.
**Cross-source parallel**: The monitoring/observability domain appears in Discovered (Grafana, Elasticsearch, self-hosted Sentry). Grafana in particular evolved from a Graphite dashboard tool to a full observability platform, demonstrating how Pipeline architectures grow. MonitorMe (KataLog) faces a similar pipeline problem for vital signs.

---

#### NGINX -- Web Infrastructure [PRODUCTION-VALIDATED]

**Domain**: High-performance HTTP server, reverse proxy, and load balancer.
**Architecture styles**: Event-Driven, Pipeline.
**Scale**: Serves a substantial fraction of global web traffic. The C10K problem solution.
**Key architectural insight**: NGINX's event-driven, non-blocking architecture with worker processes is the production proof that Event-Driven architecture solves the concurrent connection problem. The master-worker process model provides fault isolation without the overhead of thread-per-connection.
**Cross-source parallel**: Event-Driven is the most prevalent style across all sources: AOSA (NGINX, Twisted, ZeroMQ), RealWorld (Squidex, Bitwarden), KataLog (MonitorMe, Road Warrior), Discovered (78 of 122 repos use Event-Driven). NGINX and Twisted (AOSA) provide the foundational production evidence.

---

#### Git -- Version Control [PRODUCTION-VALIDATED]

**Domain**: Distributed version control system.
**Architecture styles**: Content-Addressable Storage, Directed Acyclic Graph (DAG).
**Scale**: The dominant version control system globally, managing repositories from single-developer projects to the Linux kernel.
**Key architectural insight**: Git's content-addressable storage (every object identified by its SHA-1 hash) and DAG-based history model enable fully offline operation with efficient distributed sync. This is the strongest production evidence for offline-first architecture.
**Edge/offline relevance**: Git is the only AOSA project that operates fully offline by design. This makes it directly relevant to KataLog profiles with edge/offline requirements (Wildlife Watcher, MonitorMe, Farmacy Food smart fridges) and RealWorld profiles (Bitwarden offline vault, Jellyfin local media server).

---

#### ZeroMQ -- Messaging Infrastructure [PRODUCTION-VALIDATED]

**Domain**: High-performance asynchronous messaging library.
**Architecture styles**: Broker-less Messaging, Pipeline, Actor Model (socket-as-actor).
**Scale**: Deployed in latency-sensitive trading systems, scientific computing, and distributed applications.
**Key architectural insight**: ZeroMQ's broker-less design eliminates the message broker as a single point of failure and latency bottleneck. The socket-as-actor model provides a clean programming abstraction for concurrent messaging.
**Cross-source parallel**: Contrasts with broker-based messaging in Discovered (RabbitMQ, Pulsar, NATS, Redpanda). The broker vs. broker-less trade-off is a fundamental messaging architecture decision. KataLog profiles that require high-throughput messaging (Road Warrior, Hey Blue!) would benefit from studying both approaches.

---

#### Twisted -- Networking Framework [PRODUCTION-VALIDATED]

**Domain**: Event-driven networking engine for Python.
**Architecture styles**: Event-Driven, Reactor Pattern.
**Scale**: Production framework for multi-protocol network servers.
**Key architectural insight**: Twisted's Reactor Pattern (event loop + protocol handlers) is the Python implementation of the same architecture that makes NGINX performant. The Deferred callback chain was an early solution to the async programming problem that modern async/await syntax replaced.
**Cross-source parallel**: The Reactor/Event-Loop pattern is foundational to NGINX (AOSA), Node.js applications (Discovered), and any Event-Driven system in the catalog. The 78 Event-Driven repos in Discovered all trace their architectural lineage to patterns proven by Twisted and NGINX.

---

#### SQLAlchemy -- Database/ORM [PRODUCTION-VALIDATED]

**Domain**: SQL toolkit and Object-Relational Mapper for Python.
**Architecture styles**: Layered Architecture, Plugin Architecture.
**Scale**: The dominant Python ORM, used in production across thousands of applications.
**Key architectural insight**: SQLAlchemy's dual-layer design (Core SQL expression layer + ORM layer on top) allows developers to choose their abstraction level. This is a Layered Architecture where each layer is independently useful, not just a dependency of the layer above.
**Cross-source parallel**: Layered Architecture is the second most common style in Discovered (30 of 122 repos). SQLAlchemy's approach -- layers that can be used independently -- is the production-validated version of what many Discovered repos implement (ABP, ASP.NET Boilerplate, eShopOnWeb). RefArch's Clean Architecture Template also uses explicit layers.

---

#### Puppet -- Configuration Management [PRODUCTION-VALIDATED]

**Domain**: Infrastructure automation and configuration management.
**Architecture styles**: Declarative Configuration, Client-Server.
**Scale**: Deployed to manage tens of thousands of servers at enterprise scale.
**Key architectural insight**: Puppet's declarative model (describe desired state, not steps) is an architecture pattern in itself. The agent-server architecture with a catalog compilation step demonstrates how to separate policy (what should be) from mechanism (how to get there).
**Cross-source parallel**: The declarative-vs-imperative tension appears in Discovered's Workflow Orchestration cluster (Airflow, Argo Workflows, Temporal, Prefect, Conductor) where workflow definitions face the same trade-off. Kubernetes (AKS Baseline in RefArch) uses the same declarative model.

---

#### GStreamer -- Multimedia Framework [PRODUCTION-VALIDATED]

**Domain**: Multimedia processing framework for audio and video.
**Architecture styles**: Pipeline, Plugin Architecture.
**Scale**: The standard multimedia framework for Linux desktop and embedded systems.
**Key architectural insight**: GStreamer's pipeline-of-plugins architecture handles heterogeneous media processing (decode, transform, encode, output) by composing independently developed plugins. The pipeline graph is dynamically constructed, allowing runtime reconfiguration.
**Cross-source parallel**: The Pipeline + Plugin combination appears in RealWorld (Jellyfin media transcoding) and Discovered (Data Processing cluster: Beam, Flink, Dagster). GStreamer is the production proof that Plugin Architecture + Pipeline handles multimedia complexity. Jellyfin's plugin architecture for media codecs directly parallels GStreamer's approach.

---

### RealWorld Production Profiles

#### Squidex -- Headless CMS [PRODUCTION-VALIDATED]

**Domain**: Headless CMS with API-first content management.
**Architecture styles**: CQRS, Event Sourcing, Event-Driven (per RealWorldASPNET catalog).
**Scale**: ~2,300 GitHub stars, multi-tenant SaaS deployment.
**Key architectural insight**: Squidex is the first production CQRS/Event Sourcing evidence in the catalog (previously 0% production). The event-sourced content model enables full audit trails and temporal queries ("what did this content look like last Tuesday?") that traditional CMS architectures cannot provide.
**Evidence gap filled**: CQRS/Event Sourcing went from 0% to 61% production evidence with Squidex's inclusion.
**Cross-source parallel**: CQRS appears in RefArch (eShopOnContainers, Modular Monolith with DDD, Clean Architecture Template, Wild Workouts) and Discovered (23 repos including AxonFramework, EventStore, CQRSlite). Squidex validates that CQRS/Event Sourcing works in production CMS contexts, not just reference implementations.

---

#### Bitwarden Server -- Password Management [PRODUCTION-VALIDATED]

**Domain**: Zero-knowledge password management with cross-device sync.
**Architecture styles**: Service-Based, Event-Driven (per RealWorldASPNET catalog).
**Scale**: ~16,000 GitHub stars, millions of users across browser extensions, desktop apps, and mobile clients.
**Key architectural insight**: Bitwarden is the only security-domain production architecture in the entire catalog. Zero-knowledge encryption (server never sees plaintext) shapes every architectural decision -- from API design to sync protocols to key derivation.
**Evidence gap filled**: Security domain had zero entries in any evidence source before Bitwarden's inclusion.
**Edge/offline relevance**: Bitwarden's offline vault access demonstrates how to architect for offline-first in a security-sensitive context. Relevant to KataLog profiles with edge/offline needs (Wildlife Watcher, MonitorMe).

---

#### Jellyfin -- Media Server [PRODUCTION-VALIDATED]

**Domain**: Self-hosted media server with real-time transcoding and multi-client support.
**Architecture styles**: Plugin Architecture, Pipeline, Client-Server (per RealWorldASPNET catalog).
**Scale**: ~38,000 GitHub stars, the largest project in the RealWorld source by community size.
**Key architectural insight**: Jellyfin provides .NET Plugin Architecture production evidence that was previously C/C++ only (from AOSA's GStreamer). The real-time transcoding pipeline must adapt to client capabilities (different codecs, resolutions, bandwidth) at serving time, not build time.
**Evidence gap filled**: Plugin Architecture in .NET production added alongside C/C++ AOSA entries, bringing Plugin Architecture to 97% production evidence coverage.
**Cross-source parallel**: The Pipeline + Plugin combination matches GStreamer (AOSA). The media streaming domain also appears in KataLog (MonitorMe's real-time data pipeline) and Discovered (Jellyfin appears in both RealWorld and Discovered catalogs, providing cross-validated evidence).

---

#### Orchard Core -- CMS/Application Framework [PRODUCTION-VALIDATED]

**Domain**: Modular CMS and application framework built on ASP.NET Core.
**Architecture styles**: Modular Monolith, Plugin Architecture (per RealWorldASPNET catalog).
**Scale**: ~7,500 GitHub stars, used as a foundation for custom CMS deployments.
**Key architectural insight**: Orchard Core provides the first Modular Monolith production evidence (previously 0% production). Module isolation within a single deployment unit is achieved through feature flags, dependency injection scoping, and convention-based module discovery.
**Evidence gap filled**: Modular Monolith went from 0% to 50% production evidence with Orchard Core's inclusion.
**Cross-source parallel**: Modular Monolith appears in RefArch (Modular Monolith with DDD) and Discovered (29 repos including ABP, EventStore, Mattermost, Discourse). The KataLog winner for Farmacy Food (ArchColider) and Spotlight Platform (PegasuZ) both chose Modular Monolith -- Orchard Core validates that choice in production.

---

#### nopCommerce -- E-Commerce Platform [PRODUCTION-VALIDATED]

**Domain**: Full-featured e-commerce platform with a 17-year production track record.
**Architecture styles**: Plugin Architecture, Layered Architecture (per RealWorldASPNET catalog).
**Scale**: ~9,500 GitHub stars, powering thousands of live storefronts.
**Key architectural insight**: nopCommerce's 17-year evolution demonstrates how Plugin Architecture sustains long-lived e-commerce platforms. The plugin ecosystem (payment gateways, shipping providers, tax calculators) decouples the platform from vendor-specific integrations -- the same pattern that KataLog teams proposed for ClearView (HR system adapters) and Wildlife Watcher (scientific platform plugins).
**Evidence gap filled**: Plugin Architecture in e-commerce domain with the longest production track record in the catalog.
**Cross-source parallel**: E-Commerce is the most cross-validated domain in the catalog -- KataLog (ShopWise AI), AOSA (none), RealWorld (nopCommerce), RefArch (eShopOnContainers, eShop, eShopOnWeb), Discovered (11 repos including Medusa, Saleor, Shopware, Spree). See the [Cross-Source Analysis](evidence/cross-source-analysis.md) for the full e-commerce comparison.

---

### Discovered Domain Cluster Profiles

#### Developer Tools Cluster (36 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: ABP, Backstage, Dapr, GitLab, Supabase, Appwrite, NocoDB, Gitpod, LocalStack, serverless frameworks, clean architecture templates (11 repos across C#, Go, Java, TypeScript).
**Dominant architecture styles**: Event-Driven (prevalent), Domain-Driven Design, CQRS, Hexagonal Architecture, Modular Monolith, Layered.
**Problem profile**: Developer tools and frameworks face a unique problem: they must be extensible enough for diverse use cases while maintaining opinionated enough defaults to be useful out of the box. The 36 repos split into two sub-clusters:
- **Framework/platform tools** (ABP, Backstage, Dapr, Supabase, Appwrite): Microservices or Service-Based with Event-Driven integration. These are tools developers deploy as infrastructure.
- **Clean architecture templates** (11+ repos): Hexagonal Architecture, DDD, CQRS. These are educational/starter implementations that demonstrate patterns.

**Key tension**: Framework extensibility vs. opinionated conventions. The most successful tools (Backstage at confidence 1.0, Dapr at 1.0) achieve both through plugin/extension models.
**Cross-source parallel**: AOSA provides the production foundation -- Git (developer tool), SQLAlchemy (developer framework), GStreamer (plugin-based framework) all demonstrate how successful developer tools balance extensibility with coherence. RefArch's Clean Architecture Template serves the same audience as the Discovered template repos.

---

#### E-Commerce Cluster (11 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: eShop, eShopOnContainers, eShopOnWeb, go-ecommerce-microservices, Medusa, NorthwindTraders, nopCommerce, Saleor, Shopware, Spree, microservices-demo.
**Dominant architecture styles**: Microservices (6 repos), Event-Driven (7 repos), CQRS (4 repos), Modular Monolith (4 repos), Domain-Driven Design (3 repos).
**Problem profile**: E-commerce is the most cross-validated domain in the entire catalog, with evidence from 4 of 5 sources. The Discovered cluster reveals a clear architectural spectrum: simple layered monoliths (eShopOnWeb) -> modular monoliths (Medusa, Saleor, Shopware, Spree) -> microservices (eShop, go-ecommerce-microservices, microservices-demo). This spectrum matches the KataLog finding that scale drives architecture style selection.
**Key tension**: The monolith-to-microservices migration path. The cluster contains examples at every point on the spectrum, making it the best domain for studying evolutionary architecture. nopCommerce (also in RealWorld) demonstrates 17 years of evolution within the Plugin + Layered approach, while eShopOnContainers -> eShop shows Microsoft's own migration from complex microservices to simplified microservices.
**Cross-source parallel**: KataLog (ShopWise AI), RealWorld (nopCommerce), RefArch (eShopOnContainers, eShop), Discovered (11 repos). The only missing source is AOSA.

---

#### Infrastructure Cluster (7 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: Consul, Envoy, Istio, Linkerd2, Traefik, Zuul, Eureka.
**Dominant architecture styles**: Microservices (5 repos), Event-Driven (4 repos), Pipe-and-Filter (4 repos).
**Problem profile**: Service mesh, API gateway, and service discovery tools that sit in the critical path of every request in a microservices deployment. These systems must add observability, traffic control, and security without introducing unacceptable latency overhead. All operate at Very Large scale and require High real-time performance.
**Key tension**: Proxy overhead vs. observability and traffic control. Every millisecond of proxy latency is multiplied by every request in the system. Envoy and Istio (both at confidence 1.0) demonstrate the sidecar proxy pattern; Traefik demonstrates the edge proxy pattern; Consul and Eureka demonstrate service discovery without proxy overhead.
**Cross-source parallel**: AOSA's NGINX is the foundational production evidence for high-performance request processing. RefArch's AKS Baseline Cluster demonstrates Kubernetes-native infrastructure. Puppet (AOSA) demonstrates the declarative infrastructure management pattern these tools build upon.

---

#### AI/ML Cluster (6 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: AutoGPT, autogen, camel, crewAI, dify, letta.
**Dominant architecture styles**: Multi-Agent (4 repos), Event-Driven (5 repos), Pipe-and-Filter (1 repo), Layered (2 repos).
**Problem profile**: AI agent frameworks and platforms that orchestrate LLM-powered agents for complex tasks. This is the newest domain in the catalog, with all repos emerging post-2023. The Multi-Agent style (4 of 6 repos) is unique to this cluster -- it does not appear in any other source.
**Key tension**: Multi-agent coordination vs. single-agent simplicity. AutoGPT and crewAI represent the multi-agent extreme; dify represents the pipeline/workflow approach to AI orchestration. The KataLog AI katas (ShopWise AI, ClearView, Certifiable Inc.) explored this same tension through competition designs.
**Cross-source parallel**: KataLog provides the strongest trade-off analysis for AI architectures (ShopWise AI's multi-agent vs. pipeline comparison, ClearView's deterministic boundaries around non-deterministic AI, Certifiable Inc.'s LLM-as-a-Judge pattern). The Discovered cluster provides code-level evidence that Multi-Agent is the emerging dominant pattern for AI orchestration.

---

#### Data Grid Cluster (6 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: Redis, Dragonfly, Hazelcast, Apache Ignite, Infinispan, Apache Geode.
**Dominant architecture styles**: Space-Based (5 repos), Event-Driven (4 repos), Modular Monolith (2 repos).
**Problem profile**: In-memory data grids and caching systems that provide sub-millisecond data access at extreme scale. Space-Based architecture (5 of 6 repos) is nearly exclusive to this cluster -- it appears in only 7 total Discovered repos, and 5 are data grids. These systems prioritize memory efficiency and data distribution over persistence durability.
**Key tension**: Memory efficiency vs. data distribution and consistency. Redis and Dragonfly use single-threaded event loops (like NGINX) for simplicity; Hazelcast and Geode use partitioned data distribution for scale. The consistency models range from strong (Ignite) to eventual (Redis).
**Cross-source parallel**: AOSA's Riak demonstrates the same availability-vs-consistency trade-off at the database level. AOSA's NGINX demonstrates the same event-driven single-thread model that Redis uses. The KataLog profiles that require real-time data (Hey Blue!'s proximity lookup, MonitorMe's vital signs) would benefit from Space-Based patterns proven in this cluster.

---

#### Workflow Orchestration Cluster (5 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: Airflow, Argo Workflows, Conductor, Prefect, Temporal.
**Dominant architecture styles**: Microservices (4 repos), Event-Driven (5 repos), Domain-Driven Design (4 repos).
**Problem profile**: Systems that define, schedule, and execute complex multi-step workflows. The cluster splits between DAG-based orchestrators (Airflow, Argo, Prefect) and event-driven workflow engines (Temporal, Conductor). All face the fundamental challenge of making workflows reliable when individual steps can fail, retry, or timeout.
**Key tension**: Workflow definition flexibility vs. execution reliability. Airflow's Python-based DAG definitions maximize flexibility but can create untestable workflows. Temporal's deterministic replay model maximizes reliability but constrains workflow definition patterns.
**Cross-source parallel**: Puppet (AOSA) demonstrates the declarative-vs-imperative trade-off in infrastructure workflows. RefArch's Serverless Microservices reference uses event-driven orchestration for ride-sharing. The KataLog profiles with complex workflows (Sysops Squad ticket routing, Certifiable Inc. grading pipeline) face similar orchestration decisions.

---

#### Data Processing Cluster (5 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: Apache Beam, Apache Flink, Dagster, Mage AI, Pachyderm.
**Dominant architecture styles**: Microservices (4 repos), Event-Driven (4 repos), Pipe-and-Filter (4 repos), Domain-Driven Design (2 repos).
**Problem profile**: Stream and batch data processing frameworks that handle high-throughput data transformation. Pipe-and-Filter is the defining pattern (4 of 5 repos), reflecting the domain's inherent nature: data flows through a series of transformation stages. These systems must balance processing guarantees (exactly-once, at-least-once) against throughput requirements.
**Key tension**: Exactly-once processing guarantees vs. throughput. Beam and Flink provide exactly-once semantics at the cost of complexity; simpler systems like Mage AI trade guarantees for developer experience.
**Cross-source parallel**: AOSA's LLVM demonstrates Pipeline at compilation scale. AOSA's Graphite demonstrates Pipeline for metrics ingestion. GStreamer (AOSA) demonstrates Pipeline for media processing. The Pipe-and-Filter pattern is proven across all these domains -- the Data Processing cluster provides the distributed, cloud-scale implementation evidence.

---

#### Messaging Cluster (5 repos) [CODE-LEVEL EVIDENCE]

**Representative projects**: NATS, Apache Pulsar, RabbitMQ, Redpanda, Mattermost.
**Dominant architecture styles**: Event-Driven (5 repos), Microservices (2 repos), Modular Monolith (2 repos).
**Problem profile**: Message brokers and event buses that provide reliable asynchronous communication between distributed components. The cluster splits between high-throughput log-based brokers (Pulsar, Redpanda) and traditional message brokers (RabbitMQ, NATS). Mattermost represents application-level messaging (team chat) built on similar infrastructure patterns.
**Key tension**: Delivery guarantees vs. throughput and latency. Pulsar and Redpanda provide durable, ordered message delivery at the cost of latency; NATS provides ultra-low-latency at-most-once delivery for use cases where message loss is acceptable.
**Cross-source parallel**: AOSA's ZeroMQ provides the foundational production evidence for broker-less messaging -- a third approach beyond the broker-based patterns in this cluster. KataLog teams extensively used messaging infrastructure: Kafka appeared in 5 of 7 Farmacy Family submissions; Road Warrior required event-driven update propagation; MonitorMe required real-time vital sign streaming.

---

## Problem Dimension Deep Dives

### By Domain Type

**Food / Logistics** (KataLog: Farmacy Food)
Domain-specific constraints: physical-digital bridge (RFID, smart fridges, POS), food safety regulations (expiry management, allergen tracking), cold chain logistics. Teams that engaged with the physical reality of fridges and kiosks produced more nuanced architectures. The key insight: event-driven inventory propagation is universal when physical goods are involved, because physical state changes are inherently asynchronous.

**Enterprise IT / Field Service** (KataLog: Sysops Squad)
Domain-specific constraints: existing monolith with active users, nationwide operations that cannot tolerate downtime, expert workforce management. The monolith migration constraint drove near-unanimous convergence on service-based architecture (6 of 7 teams). Production parallel: Puppet (AOSA) demonstrates a mature client-server architecture for managing distributed infrastructure operations.

**Health / Community** (KataLog: Farmacy Family)
Domain-specific constraints: HIPAA compliance for medical data sharing, integration with an existing system, community engagement features alongside medical-grade data security. The compliance tension (startup budget vs. HIPAA) was the primary architectural driver. Production parallel: Bitwarden (RealWorld) demonstrates how to architect for security-sensitive data with zero-knowledge encryption.

**Non-Profit / HR Tech** (KataLog: Spotlight Platform, ClearView)
Domain-specific constraints: severe budget limitations, non-technical end users, need for accessibility. Both challenges were for the Diversity Cyber Council. Cost analysis separated winners from runners-up in both cases. The key insight: for non-profits, the architecture must justify its own cost of operation -- $0.002/user/month (TheGlobalVariables) and $0.06/candidate (Katamarans) are the kinds of numbers that make architectures credible.

**Civic Tech / Social Impact** (KataLog: Hey Blue!)
Domain-specific constraints: real-time geolocation with safety implications, points-based incentive system, retail integration for redemption. Officer safety was the domain-specific constraint that no generic architecture pattern addresses. Production parallel: the Data Grid cluster (Discovered) provides the in-memory data structure patterns needed for O(log n) proximity lookups at scale.

**Conservation / IoT** (KataLog: Wildlife Watcher)
Domain-specific constraints: ultra-low-power edge hardware (512KB Flash), unreliable connectivity (LoRaWAN, 3G, satellite), open-source requirements. Production parallel: Git (AOSA) is the strongest evidence for offline-first architecture; Bitwarden (RealWorld) demonstrates offline vault access in a security context.

**Travel / Consumer** (KataLog: Road Warrior)
Domain-specific constraints: massive user scale (15M), stringent availability SLAs (99.99%), multi-source data aggregation. Production parallel: NGINX (AOSA) demonstrates how to handle C10K+ concurrent connections. The Infrastructure cluster (Discovered: Envoy, Istio, Traefik) provides the modern service mesh and API gateway patterns needed at this scale.

**Healthcare / MedTech** (KataLog: MonitorMe)
Domain-specific constraints: life-critical latency, on-premises deployment, 8 device types at different sampling rates, graceful degradation. Production parallel: GStreamer (AOSA) demonstrates real-time pipeline processing for heterogeneous data sources. Graphite (AOSA) demonstrates time-series storage patterns applicable to vital sign data.

**Retail / AI** (KataLog: ShopWise AI; Discovered: 11 e-commerce repos; RealWorld: nopCommerce; RefArch: eShop*)
The most cross-validated domain. KataLog tested AI engineering (text-to-SQL, multi-agent); Discovered shows the full monolith-to-microservices spectrum; RealWorld proves plugin-based e-commerce at 17-year production scale; RefArch provides deployable reference implementations.

**HR / AI for Bias Reduction** (KataLog: ClearView)
Domain-specific constraints: non-deterministic AI must produce bias-free outcomes, unbounded HR system integrations, PII protection, explainability requirements. Production parallel: Selenium (AOSA) demonstrates the adapter pattern for heterogeneous integration that ClearView teams adopted for HR system connectivity.

**EdTech / AI Certification** (KataLog: Certifiable Inc.)
Domain-specific constraints: high-stakes grading where errors affect careers, thin margins, differentiated treatment of objective vs. subjective assessments. Production parallel: the Workflow Orchestration cluster (Discovered: Temporal, Conductor) provides workflow reliability patterns applicable to the grading pipeline.

**Compiler Infrastructure** (AOSA: LLVM)
Domain-specific constraints: N frontends * M backends must share a single optimization pipeline, compilation performance, IR stability across releases. The Pipeline + Plugin pattern proven here is the archetype for all data transformation domains.

**Distributed Storage** (AOSA: HDFS, Riak; Discovered: Data Grid cluster)
Domain-specific constraints: fault tolerance on commodity hardware, consistency vs. availability trade-off, data replication strategies. HDFS (master-based) and Riak (masterless) represent the two fundamental approaches; the Data Grid cluster provides modern in-memory variants.

**Web Infrastructure** (AOSA: NGINX; Discovered: Infrastructure cluster)
Domain-specific constraints: C10K+ concurrency, zero-downtime deployments, request routing and load balancing. NGINX proved the event-driven model; Envoy, Istio, and Traefik extend it with service mesh capabilities.

**Messaging / Distributed Systems** (AOSA: ZeroMQ; Discovered: Messaging cluster)
Domain-specific constraints: delivery guarantees, ordering, latency, throughput, back-pressure. The broker vs. broker-less decision (ZeroMQ vs. RabbitMQ/Pulsar) is the foundational architecture choice.

**CMS / Content Management** (RealWorld: Squidex, Orchard Core; Discovered: Directus, Strapi)
Domain-specific constraints: content modeling flexibility, multi-tenancy, plugin/theme ecosystems. Squidex proves CQRS/Event Sourcing for CMS; Orchard Core proves Modular Monolith.

**Security / Password Management** (RealWorld: Bitwarden)
Domain-specific constraints: zero-knowledge encryption, cross-device sync, offline access, security audit compliance. Unique in the catalog -- no other source covers the security domain.

**Media Server / Streaming** (RealWorld: Jellyfin; AOSA: GStreamer)
Domain-specific constraints: real-time transcoding, codec diversity, client capability negotiation, plugin-based media processing. Cross-validated between AOSA (C/C++) and RealWorld (.NET).

---

### By Scale Requirements

Profiles ordered from smallest to largest expected scale, incorporating all 5 sources:

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

**Architectural transitions by scale tier (production-validated):**
- **Small**: Single-process or monolithic architectures are not only acceptable but preferred. AI quality and domain logic dominate. Production evidence: BuckPal (RefArch), clean architecture templates (Discovered).
- **Medium**: Service-based or modular monolith is the sweet spot. Event-driven for specific async concerns. Cost efficiency matters. Production evidence: Squidex (RealWorld), Orchard Core (RealWorld), Modular Monolith with DDD (RefArch).
- **Large**: Microservices become justified. Event-driven becomes pervasive. CQRS and read/write separation emerge. Production evidence: nopCommerce (RealWorld), Jellyfin (RealWorld), Graphite (AOSA), Riak (AOSA).
- **Very Large**: Space-based patterns, in-memory data grids, event-driven pipelines, and aggressive caching become necessary. Production evidence: NGINX (AOSA), HDFS (AOSA), Git (AOSA), Bitwarden (RealWorld), Redis/Dragonfly (Discovered).

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

**Patterns by integration tier (with production evidence):**
- **Low**: Direct API calls with abstraction layers. Production: Git's protocol-based integration (AOSA).
- **Medium**: Adapter pattern, dedicated integration services. Production: Puppet's agent-catalog model (AOSA), Squidex's webhook-based events (RealWorld).
- **High**: Event-driven integration backbone, dedicated modules per system. Production: NGINX's module system (AOSA), nopCommerce's plugin ecosystem (RealWorld), SQLAlchemy's dialect system (AOSA).
- **Very High**: Microkernel/plugin architecture for extensibility; protocol-based abstraction. Production: Selenium's wire protocol (AOSA), GStreamer's pipeline-of-plugins (AOSA), Data Processing connectors (Discovered).

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

**Key finding**: Compliance load correlates with the importance of architectural decision documentation. In high-compliance contexts (Farmacy Family, ClearView, Certifiable Inc. from KataLog; Bitwarden from RealWorld; Puppet from AOSA), the most successful architectures documented compliance decisions with specific ADRs and referenced specific standards. Production systems (Bitwarden, Puppet) demonstrate that compliance constraints become permanent architectural forces -- Bitwarden's zero-knowledge model and Puppet's declarative compliance are not features that can be bolted on later.

---

### By AI/ML Component

The evolution of AI across all sources traces a clear arc:

**Phase 1: No AI (traditional systems)**
- KataLog 2020-2022: Farmacy Food, Sysops Squad, Farmacy Family, Spotlight Platform, Hey Blue!
- All AOSA projects (2011-2012 era, pre-modern-AI)
- Most RealWorld projects: nopCommerce, Orchard Core, Squidex, Jellyfin
- All RefArch projects (pre-AI reference implementations)
- Architecture dominated by traditional distributed systems concerns: decomposition, integration, scaling, migration

**Phase 2: IoT/Edge AI (2023)**
- KataLog: Wildlife Watcher (on-device species identification)
- AI constrained by hardware (512KB Flash) and connectivity (LoRaWAN)
- The architectural challenge was deploying AI to the edge, not building AI systems

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

Rather than an N*N matrix across all 36+ profiles, similarity is organized into clusters of profiles that share 3+ problem dimensions. Each cluster groups profiles from multiple sources that face similar architectural challenges.

### Cluster 1: Edge/IoT/Constrained Hardware

**Members**: Wildlife Watcher (KataLog), MonitorMe (KataLog), Git (AOSA), Bitwarden (RealWorld), Jellyfin (RealWorld), GStreamer (AOSA)

**Shared dimensions**: Edge/offline operation, device/hardware constraints, real-time data processing from constrained environments.

**Why this cluster matters**: These profiles all face the fundamental tension of operating sophisticated software on limited hardware or in disconnected environments. Git proves that fully offline distributed systems work at global scale. Bitwarden proves offline-first works in security-sensitive contexts. MonitorMe and GStreamer prove real-time processing from heterogeneous devices. Wildlife Watcher represents the extreme case (512KB Flash, LoRaWAN).

**Strongest internal pairings**:
- Wildlife Watcher / MonitorMe (score 3): Both involve hardware/device integration, edge computing, event-driven architectures, and real-time data from constrained devices.
- GStreamer / Jellyfin (score 4): Both process heterogeneous media through plugin-based pipelines with real-time constraints.
- Git / Bitwarden (score 3): Both architect for fully offline operation with eventual sync.

### Cluster 2: AI-Centric Systems

**Members**: ShopWise AI (KataLog), ClearView (KataLog), Certifiable Inc. (KataLog), AutoGPT (Discovered), crewAI (Discovered), autogen (Discovered), dify (Discovered), letta (Discovered), camel (Discovered)

**Shared dimensions**: Central AI/ML component, LLM integration, non-deterministic output management, cost optimization.

**Why this cluster matters**: This is the fastest-growing cluster and the one with the least production evidence. KataLog provides the strongest trade-off reasoning (competition designs with documented decisions). Discovered provides code-level evidence of emerging patterns (Multi-Agent dominance). No AOSA or RealWorld entries exist yet -- this represents the evidence frontier.

**Strongest internal pairings**:
- ShopWise AI / Certifiable Inc. (score 4): Both AI-centric with text understanding. Certifiable adds high-stakes accountability.
- ClearView / Certifiable Inc. (score 3): Both require AI to make consequential decisions about people's lives/careers.
- ShopWise AI / ClearView (score 3): Both LLM-integrated, both face cost optimization challenges.
- Discovered AI repos form a tight sub-cluster: 4 of 6 use Multi-Agent architecture, all use Event-Driven.

### Cluster 3: E-Commerce / Transactional Systems

**Members**: Farmacy Food (KataLog), ShopWise AI (KataLog), nopCommerce (RealWorld), eShopOnContainers (RefArch), eShop (RefArch), eShopOnWeb (Discovered), go-ecommerce-microservices (Discovered), Medusa (Discovered), Saleor (Discovered), Shopware (Discovered), Spree (Discovered), microservices-demo (Discovered), NorthwindTraders (Discovered), BuckPal (RefArch)

**Shared dimensions**: Transactional integrity, payment processing (PCI), catalog/inventory management, plugin-based extensibility for vendors.

**Why this cluster matters**: The most cross-validated domain in the catalog (4 of 5 sources). The cluster contains examples at every point on the monolith-to-microservices spectrum, making it the best domain for studying evolutionary architecture. nopCommerce's 17-year track record is the strongest long-term evolution evidence.

**Architectural spectrum within cluster**:
1. Layered monolith: eShopOnWeb, nopCommerce
2. Modular Monolith: Medusa, Saleor, Shopware, Spree
3. Hexagonal: BuckPal, NorthwindTraders
4. Microservices: eShop, eShopOnContainers, go-ecommerce-microservices, microservices-demo

### Cluster 4: Non-Profit / Cost-Constrained Platforms

**Members**: Spotlight Platform (KataLog), Hey Blue! (KataLog), ClearView (KataLog), Wildlife Watcher (KataLog), Farmacy Food (KataLog), Farmacy Family (KataLog)

**Shared dimensions**: Severe budget constraints, non-profit or startup context, cost-per-user as a primary architectural driver.

**Why this cluster matters**: Six of 11 KataLog challenges operate under tight budget constraints. The winning pattern across all of them is evolutionary architecture: start with the simplest viable architecture (modular monolith or service-based) and plan for growth rather than building for scale on day one. Production evidence supports this -- Orchard Core (RealWorld) demonstrates Modular Monolith at scale.

**Key cost benchmarks from evidence**:
- $0.002/user/month (Spotlight Platform, TheGlobalVariables)
- $0.06/candidate (ClearView, Katamarans)
- $2,780/month for 50K MAU (Hey Blue!, MonArch)
- $12K-23K/year infrastructure (Farmacy Food, ArchColider)
- $8,448/year total infrastructure (ClearView, DevExperts)

### Cluster 5: High-Performance / Real-Time Systems

**Members**: MonitorMe (KataLog), Road Warrior (KataLog), Hey Blue! (KataLog), NGINX (AOSA), ZeroMQ (AOSA), GStreamer (AOSA), Twisted (AOSA), Jellyfin (RealWorld), Data Grid cluster (Discovered), Messaging cluster (Discovered), Infrastructure cluster (Discovered)

**Shared dimensions**: Sub-second latency requirements, high concurrency, event-driven architecture as the dominant pattern.

**Why this cluster matters**: Event-Driven is the most prevalent architecture style across all sources (78 of 122 Discovered repos, all AOSA real-time systems, nearly universal in KataLog). This cluster provides the deepest evidence base for understanding when and how event-driven patterns succeed. The AOSA entries (NGINX, ZeroMQ, Twisted) provide foundational theory; the Discovered entries provide modern implementations; KataLog provides trade-off reasoning.

### Cluster 6: Developer Platforms / Extensible Frameworks

**Members**: Developer Tools cluster (36 Discovered repos), Selenium (AOSA), SQLAlchemy (AOSA), GStreamer (AOSA), LLVM (AOSA), Puppet (AOSA), nopCommerce (RealWorld), Orchard Core (RealWorld), Jellyfin (RealWorld), Clean Architecture Template (RefArch)

**Shared dimensions**: Plugin/extension architecture, framework extensibility, multi-platform support, developer experience as a quality attribute.

**Why this cluster matters**: Plugin Architecture is one of the most cross-validated patterns in the catalog. AOSA provides the deepest production narratives (GStreamer, LLVM, SQLAlchemy). RealWorld proves it in .NET contexts (Jellyfin, nopCommerce, Orchard Core). Discovered shows it at scale across 36 developer tool repos. The pattern succeeds when the system must support use cases the original architects cannot predict.

### Cluster 7: Distributed Data / Storage Systems

**Members**: HDFS (AOSA), Riak (AOSA), Data Grid cluster (Discovered: Redis, Dragonfly, Hazelcast, Ignite, Infinispan, Geode), Messaging cluster (Discovered: Pulsar, Redpanda, RabbitMQ, NATS), CockroachDB (Discovered), qdrant (Discovered)

**Shared dimensions**: Data distribution, replication strategies, consistency vs. availability trade-offs, partition tolerance.

**Why this cluster matters**: The CAP theorem is the defining architectural constraint for this cluster. HDFS chose consistency + partition tolerance (CP); Riak chose availability + partition tolerance (AP). The Discovered Data Grid cluster provides modern in-memory variants. Understanding where your system falls on the CAP spectrum is the first architectural decision.

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

1. **Find your closest cluster**: Identify the cluster whose shared dimensions most closely match your situation.
2. **Check profiles from multiple sources**: A problem validated in KataLog (trade-off reasoning), AOSA (production narrative), RealWorld (production application), and Discovered (code-level evidence) has the strongest combined evidence.
3. **Prioritize production-validated profiles**: AOSA and RealWorld profiles have been built and operated -- their architectural constraints are real, not hypothetical.
4. **Use Discovered clusters for pattern frequency**: If 78 of 122 discovered repos use Event-Driven architecture, that is statistically significant code-level evidence.
5. **Cross-reference solution evidence**: The [Solution Space Taxonomy](solution-spaces.md) maps these problem profiles to specific architecture styles. The [Problem-Solution Matrix](problem-solution-matrix.md) provides the direct cross-reference. The [Evidence by Architecture Style](evidence/by-architecture-style.md) provides per-style evidence depth.

---

*Generated from evidence across 5 sources: 11 KataLog challenges (78 team submissions, Fall 2020--Winter 2025), 12 AOSA production systems (Volumes 1-2, 2011-2012), 5 RealWorldASPNET production applications, 8 ReferenceArchitecture implementations, and 122 Discovered repositories. Total catalog: 158 unique projects (225 entries including cross-source overlap). Source data: `evidence-analysis/*/docs/catalog/_index.yaml`, `docs/analysis/challenges/*.md`, `docs/analysis/cross-cutting.md`.*
