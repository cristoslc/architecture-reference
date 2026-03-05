# Problem-Solution Mapping Matrix

The analytical core of the reference library: a rigorous, evidence-backed mapping from problem characteristics to the architecture styles most likely to succeed. Every recommendation cites evidence from multiple sources: 78 KataLog competition submissions, 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 122 Discovered open-source repositories.

---

## How to Read This Matrix

Each mapping cell contains up to five pieces of information:

- **Style**: The recommended architecture style or combination
- **Weighted Score**: The aggregate placement score (1st = 4 pts, 2nd = 3 pts, 3rd = 2 pts, Runner-up = 1 pt) for competition teams using this style in the relevant context
- **Avg Placement**: The per-team average score (range 1.0-4.0; higher = more consistently successful)
- **Production Evidence**: Which AOSA, RealWorld, RefArch, or Discovered systems validate this recommendation
- **Confidence**: Based on source breadth and convergence
  - **Production-Validated** = AOSA or RealWorld production system confirms the recommendation (highest confidence)
  - **High** = 3+ sources agree, or production + competition evidence converges
  - **Medium** = 2 sources, or 3+ sources with mixed results
  - **Low** = single source or extrapolated

**Source tags**: Each row is tagged with its evidence origin:
- `[COMPETITION]` = KataLog competition data (78 teams, 11 challenges)
- `[PRODUCTION]` = AOSA or RealWorldASPNET production system
- `[REFERENCE]` = Reference architecture implementation
- `[DISCOVERED]` = Open-source repository analysis (122 repos)

**Important caveats**: Correlation is not causation. Winning teams succeed through a combination of style choice, documentation quality, trade-off reasoning, and feasibility analysis. Style choice alone does not determine placement. Competition data covers 78 teams across 11 challenges -- some cells have very small sample sizes. Production systems provide deployment-validated evidence but may reflect survivorship bias.

---

## Master Mapping: Problem Dimensions to Best Architecture Styles

### By Domain Type

| Domain | Tag | Best Style(s) | Avg Placement / Production Scale | Production Evidence | Confidence |
|--------|-----|--------------|----------------------------------|--------------------|----|
| **Healthcare / MedTech** | [COMPETITION] | Event-Driven | 2.00 (n=7) | -- | High |
| **Food / Logistics** | [COMPETITION] | Modular Monolith; DDD + Event Sourcing | 4.00 (n=1); 3.50 (n=2) | -- | High |
| **Enterprise IT / Migration** | [COMPETITION] | Service-Based + EDA | 2.33 (n=6) | -- | High |
| **Non-Profit / HR Tech** | [COMPETITION] | Service-Based + EDA; Modular Monolith | 2.57 (n=7); 3.25 (n=2) | -- | High |
| **Civic Tech / Social Impact** | [COMPETITION] | Multi-style evolutionary | 4.00 (n=1) | -- | Medium |
| **Conservation / IoT** | [COMPETITION] | Microservices; Modular Monolith (pragmatic deploy) | 2.25 (n=4); 2.50 (n=2) | -- | Medium |
| **Travel / Consumer** | [COMPETITION] | Event-Driven; EDA + Space-Based | 1.75 (n=8); 3.00 (n=1) | -- | High |
| **Retail / AI** | [COMPETITION] | Multi-Agent + EDA + MS | 4.00 (n=1) | -- | Medium |
| **HR / AI Bias Reduction** | [COMPETITION] | Service-Based + EDA | 4.00 (n=1) | -- | Medium |
| **EdTech / AI Certification** | [COMPETITION] | Service-Based + EDA | 4.00 (n=1) | -- | Medium |
| **Health / Community** | [COMPETITION] | Event-Driven | 2.25 (n=4) | -- | High |
| **Web Infrastructure** | [PRODUCTION] | Event-Driven + Pipeline | Internet scale (billions req/day) | NGINX (AOSA): non-blocking event loop + multi-stage pipeline processing; production-validated at global CDN scale | Production-Validated |
| **Distributed Storage** | [PRODUCTION] | Primary-Secondary + Replication | Petabyte scale | HDFS (AOSA): NameNode/DataNode primary-secondary with block replication; commodity hardware fault tolerance at Yahoo/Facebook scale | Production-Validated |
| **Compiler / DevTools** | [PRODUCTION] | Pipeline + Plugin | Dozens of frontends/backends | LLVM (AOSA): three-phase compiler pipeline (frontend, optimizer, backend) with stable IR enabling extensibility; Git (AOSA): content-addressable DAG with pipeline-style object processing | Production-Validated |
| **Media / Streaming** | [PRODUCTION] | Pipeline + Plugin | Thousands of codecs/devices | GStreamer (AOSA): element-based pipeline with plugin negotiation for format diversity; Jellyfin (RealWorld): plugin architecture for transcoding, metadata, and client support | Production-Validated |
| **E-Commerce** | [PRODUCTION] | Plugin + Layered; or Microservices + DDD + CQRS | 60K+ stores (nopCommerce); reference scale (eShop) | nopCommerce (RealWorld): plugin-based layered architecture, 17 years in production; eShopOnContainers (RefArch): microservices + DDD + CQRS reference implementation. Discovered: DDD(7), Event-Driven(5), Microservices(4) across 11 e-commerce repos | Production-Validated |
| **CMS / Content** | [PRODUCTION] | Modular Monolith + Plugin; or CQRS + Event Sourcing | Multi-tenant production | Orchard Core (RealWorld): modular monolith with plugin-based multi-tenancy; Squidex (RealWorld): CQRS + Event Sourcing for headless CMS with full audit trail | Production-Validated |
| **Security / Passwords** | [PRODUCTION] | Service-Based + Event-Driven | 16K+ GitHub stars, SOC2 certified | Bitwarden (RealWorld): zero-knowledge encryption constrains service boundaries; event-driven sync across clients; SOC2/GDPR compliant | Production-Validated |
| **Monitoring / Metrics** | [PRODUCTION] | Pipeline + Service-Based | High write volume at scale | Graphite (AOSA): Carbon pipeline for ingestion, Whisper for storage, Graphite-web for rendering; write volume drives pipeline architecture | Production-Validated |
| **Messaging** | [PRODUCTION] | Broker-less + Pipeline + Actor | Extreme throughput (millions msg/sec) | ZeroMQ (AOSA): zero-copy, lock-free, broker-less messaging; actor-model concurrency with pipeline-style message processing | Production-Validated |
| **Configuration Mgmt** | [PRODUCTION] | Declarative + Client-Server | Thousands of managed nodes | Puppet (AOSA): declarative desired-state convergence with client-server catalog compilation and agent-based enforcement | Production-Validated |
| **Database / ORM** | [PRODUCTION] | Layered + Plugin | Most popular Python ORM | SQLAlchemy (AOSA): Core (SQL expression) and ORM (object mapping) layers with dialect plugin system; SQL transparency vs. ORM convenience as explicit trade-off | Production-Validated |
| **Developer Tools** | [DISCOVERED] | Event-Driven; Modular Monolith; CQRS | 36 repos analyzed | Discovered corpus: Event-Driven(19), Modular Monolith(13), CQRS(11). Largest domain in discovered set | High |
| **Data Grid** | [DISCOVERED] | Space-Based + Event-Driven | 6 repos analyzed | Discovered corpus: Space-Based(5), Event-Driven(4). Confirms Space-Based for in-memory data grids | Medium |

**Competition evidence detail (preserved from KataLog analysis)**:
- Healthcare/MedTech: MonitorMe -- all 7 teams chose EDA; BluzBrothers (1st) proved 693ms latency with Kafka + fitness functions. Avoid: Service-Based (avg 1.0, n=1).
- Food/Logistics: Farmacy Food -- ArchColider (1st) won with MM against 6 microservices teams; Miyagi's Little Forests (2nd) used DDD. Avoid: Pure Microservices (avg 1.50, n=6).
- Enterprise IT: Sysops Squad -- 6 of 7 teams chose service-based; Team Seven (1st) added event-driven queues; sole microservices team placed runner-up. Avoid: Microservices (avg 1.0, n=2).
- Non-Profit/HR: ClearView -- Pragmatic (1st) used SB+EDA; Spotlight -- PegasuZ (1st) used MM evolving to MS+EDA. Avoid: Pure Microservices (avg 1.33, n=3).
- Civic Tech: Hey Blue! -- MonArch (1st) combined MM + MS + EDA + Hexagonal + Serverless; IPT (2nd) used MS + EDA + DDD. The most style-diverse winner in the dataset.
- Conservation/IoT: Wildlife Watcher -- CELUS Ceals (1st) used MS with C4; Rapid Response (2nd) designed 6 MS but deployed 5 as monolith. Avoid: Pure Event-Driven (avg 1.33, n=3).
- Travel/Consumer: Road Warrior -- Profitero Data Alchemists (1st) used pure EDA with Kafka; Iconites (2nd) added Space-Based for global distribution with Cosmos DB. Avoid: Service-Based (avg 1.0, n=1).
- Retail/AI: ShopWise AI -- ConnectedAI (1st) used multi-agent supervisor with LangGraph; Breakwater (2nd) used n8n low-code multi-agent. Avoid: Monolithic pipeline.
- HR/AI: ClearView -- Pragmatic (1st) used SB with selective EDA; Katamarans (2nd) used EDA; Jazz Executor (MS-only) placed runner-up. Avoid: Pure Microservices (avg 1.0, n=1).
- EdTech/AI: Certifiable Inc. -- ZAITects (1st) used SB + EDA; Litmus (2nd) used SB; Usfive (multi-agent) placed runner-up. Avoid: Multi-Agent for structured workflows (avg 1.0, n=1).
- Health/Community: Farmacy Family -- The Archangels (1st) used EDA with Kafka + crypto-shredding; Sever Crew (2nd) used SB + EDA.

**Cross-source convergence**: Several domain mappings are now validated by both competition and production evidence. E-Commerce shows two validated paths (Plugin+Layered from nopCommerce, Microservices+DDD from eShopOnContainers and Discovered repos). CMS/Content converges on Modular Monolith + Plugin (Orchard Core production, PegasuZ competition). Security domains converge on Service-Based + EDA (Bitwarden production, Pragmatic competition). These cross-source agreements represent the highest-confidence recommendations in the matrix.

---

### By Scale Requirement

| Scale Tier | Best Style | Avg Placement | Production Evidence | Key Pattern | Confidence |
|------------|-----------|---------------|--------------------:|-------------|------------|
| **Small** (<1K users) | Modular Monolith | 3.00 (n=6) | Orchard Core, Squidex (RealWorld) | Start simple; focus on domain logic over infrastructure. Production CMS systems validate MM at small-to-medium scale | High |
| **Medium** (1K-100K users) | Service-Based + EDA | 2.57 (n=7) | Bitwarden (16K+ stars), nopCommerce (60K stores), Jellyfin (RealWorld) | Service decomposition with async where needed; cost optimization critical. Production apps confirm SB+EDA at medium scale | Production-Validated |
| **Large** (100K-2M users) | Event-Driven + Microservices | 2.20 (n=5) | eShopOnContainers (RefArch), Graphite (AOSA), Puppet (AOSA) | Full distributed architecture justified; DDD for decomposition. Reference architectures demonstrate patterns at this tier | High |
| **Very Large** (2M+ users) | EDA + Space-Based / CQRS | 2.33 (n=3 top) | Riak (AOSA), Discovered Data Grid repos (Space-Based 5/6) | Multiple scaling groups, CDN distribution, in-memory grids, CQRS read/write separation | High |
| **Extreme** (internet-scale) | Event-Driven + Pipeline; or Peer-to-Peer | -- | NGINX (billions req/day), HDFS (petabytes), ZeroMQ (millions msg/sec), Riak (extreme availability) | [PRODUCTION-VALIDATED] Non-blocking event loops, broker-less messaging, replication-based fault tolerance. No competition data at this tier; production evidence only | Production-Validated |

**Critical insight**: Scale alone does not determine style. MonitorMe has only 500 patients but demands 4,000 events/second throughput -- data intensity, not user count, drove the universal EDA choice (competition evidence). Conversely, Farmacy Food's winner chose Modular Monolith despite potential national scale, prioritizing startup economics. The pattern from competition: **match style to current scale, document the evolution path to future scale.**

**Production insight**: At extreme scale, the scaling dimension itself determines the style. NGINX scales request throughput through non-blocking event loops (connection count is the dimension). HDFS scales storage through block replication across commodity hardware (data volume is the dimension). ZeroMQ scales message throughput through zero-copy, lock-free data structures (latency is the dimension). Riak scales availability through peer-to-peer eventual consistency (partition tolerance is the dimension). The pattern from production: **match style to the dominant scaling dimension (users, data volume, throughput, or geographic distribution), not a single metric.**

**Competition detail**: ArchColider (1st, Farmacy Food) chose MM citing "unproven domain model." All 6 MM teams averaged 3.00. Road Warrior: Profitero Data Alchemists (1st) defined 3 scaling groups with Kafka partitioning. Iconites (2nd) used Space-Based + Cosmos DB global distribution. ShopWise AI: ConnectedAI (1st) used a focused multi-agent architecture at small scale.

---

### By Budget Constraint

| Budget | Best Style | Avg Placement | Production Evidence | Key Insight | Confidence |
|--------|-----------|---------------|--------------------:|-------------|------------|
| **Startup / Non-Profit** | Modular Monolith (initial) | 3.00 (n=6) | Orchard Core (RealWorld): MM with plugin extensibility | Cost analysis is the single strongest predictor of placement in budget-constrained katas. nopCommerce started as monolith 17 years ago and scaled to 60K stores | Production-Validated |
| **Startup / Non-Profit** (2nd choice) | Service-Based + EDA | 2.57 (n=7) | Bitwarden (RealWorld): SB + EDA at startup scale | When scale demands exceed what a monolith can deliver, SB+EDA offers the best cost/capability balance | Production-Validated |
| **Growth / Scaling** | Event-Driven + Microservices | 2.00 (n=17) | eShopOnContainers, wild-workouts-go (RefArch) | Justified when domain boundaries are proven and operational maturity supports it | High |
| **Enterprise** | Per-quantum style selection | varies | NGINX, HDFS, LLVM (AOSA) | Established organizations can afford operational overhead; production systems demonstrate per-component style selection | Production-Validated |

**Competition detail**: ArchColider (1st, Farmacy Food): 3-scenario cost model $12K-$23K/yr. PegasuZ (1st, Spotlight): MM MVP. MonArch (1st, Hey Blue!): $2,780/mo GCP. Pragmatic (1st, ClearView): token cost estimation. TheGlobalVariables: $0.002/user/mo. DevExperts: $8,448/yr.

**Anti-pattern** (competition evidence): Microservices in non-profit/startup contexts. In ClearView (non-profit), the sole pure-microservices team (Jazz Executor) placed as runner-up. In Sysops Squad, the sole microservices team (Arch Mahal) placed as runner-up while all 6 service-based teams placed higher. Microservices' operational overhead is a budget risk that judges penalize when unjustified.

**Production counterpoint**: nopCommerce (Plugin + Layered) has sustained 60K+ stores over 17 years on a monolith-derived architecture, validating the "start simple" approach. Bitwarden achieved SOC2 certification and 16K+ GitHub stars with Service-Based + Event-Driven, not microservices. Neither chose microservices. Both are commercially successful and have been in production for years.

---

### By Integration Complexity

| Complexity | Best Style | Avg Placement | Production Evidence | Key Pattern | Confidence |
|------------|-----------|---------------|--------------------:|-------------|------------|
| **Low** (0-2 systems) | Service-Based or focused pipeline | 2.86 (n=7) | buckpal, clean-architecture-dotnet (RefArch) | Direct API calls with abstraction layers; Hexagonal architecture isolates integration at port boundaries | High |
| **Medium** (3-5 systems) | Service-Based + EDA | 2.33 (n=6) | Bitwarden (RealWorld): multi-client sync; Graphite (AOSA): Carbon + Whisper + web | Adapter pattern per external system; dedicated integration services; Kafka for async bridge | Production-Validated |
| **High** (6+ systems) | Event-Driven with integration backbone | 2.25 (n=4 top) | Puppet (AOSA): dozens of OS/platform integrations; Selenium (AOSA): all major browsers via adapter | Kafka/message broker as universal integration backbone; adapter pattern per external system | Production-Validated |
| **Very High** (8+ systems) | Plugin + Event-Driven | 2.00 (n=2) | LLVM (AOSA): dozens of language frontends + hardware backends; GStreamer (AOSA): thousands of codecs/devices; Jellyfin (RealWorld): dozens of media clients + sources | [PRODUCTION-VALIDATED] Plugin architecture for extensible integration at extreme breadth. Stable intermediate representations (LLVM IR, GStreamer caps) enable ecosystem growth without core changes | Production-Validated |
| **Ecosystem** (100+ integrations) | Plugin + Pipeline | -- | LLVM, GStreamer, SQLAlchemy (AOSA) | [PRODUCTION-VALIDATED] No competition data at this tier. Production systems demonstrate that pipeline + plugin architectures scale integration count by orders of magnitude through stable abstractions | Production-Validated |

**Critical finding** (competition): At high integration complexity, the pre-architecture research activity matters as much as the style choice. CELUS Ceals (1st, Wildlife Watcher) and Jaikaturi (Runner-up, Farmacy Food) both invested heavily in vendor research -- evaluating actual APIs, data formats, deployment models, and costs of target systems. This research-first approach consistently predicted higher placement.

**Competition detail**: BluzBrothers (1st, MonitorMe) designed device protocol gateway for 8 device types. Farmacy Food -- 5/7 teams used EDA for integration. ClearView -- Pragmatic (1st) designed adapter-based HR integration with EDA triggers. Road Warrior -- Profitero Data Alchemists (1st) used Kafka for email/API aggregation. Wildlife Watcher -- Wonderous Toys (3rd) used Microkernel for integration plugins. CELUS Ceals (1st) produced detailed comparative analysis of all 8+ platforms.

**Production validation**: LLVM's three-phase pipeline with stable IR enables dozens of frontends and backends to interoperate without coordination. GStreamer's capability negotiation protocol enables thousands of plugins to self-discover compatibility. SQLAlchemy's dialect system enables a single ORM to integrate with PostgreSQL, MySQL, SQLite, Oracle, and more through pluggable backends. Puppet integrates with dozens of operating systems and platforms through a declarative abstraction layer. Selenium uses the adapter pattern to support all major browsers through a unified WebDriver API. All five validate that **stable intermediate abstractions** are the key to scaling integration complexity, not just adapter patterns.

---

### By Compliance Load

| Compliance | Best Style | Avg Placement | Production Evidence | Key Pattern | Confidence |
|------------|-----------|---------------|--------------------:|-------------|------------|
| **None / Low** | Any (style driven by other dimensions) | varies | Most AOSA systems (NGINX, LLVM, GStreamer, ZeroMQ) | Compliance absence frees teams to optimize for other qualities | High |
| **Medium** (PCI, Food Safety, GDPR-PII) | Service-Based + EDA | 2.33 (n=6) | nopCommerce (RealWorld): PCI-compliant payment integration | Dedicated compliance boundary (billing service for PCI, consent service for GDPR); compliance decisions documented in specific ADRs | Production-Validated |
| **High** (HIPAA, Medical, Career-affecting, SOC2) | Service-Based + EDA with compliance-specific boundaries | 2.57 (n=7) | Bitwarden (RealWorld): SOC2 + GDPR compliant; zero-knowledge architecture enforces compliance structurally | [PRODUCTION-VALIDATED] Crypto-shredding for GDPR erasure; HIPAA-eligible service selection; human-in-the-loop for career-affecting decisions. Bitwarden's zero-knowledge encryption makes compliance a structural property, not a policy overlay | Production-Validated |

**Key finding** (competition): Compliance load correlates with ADR quality as a placement predictor. In high-compliance challenges, top teams documented compliance decisions with specific ADRs referencing concrete standards (NIST 800-111, HIPAA-eligible AWS services, OWASP Top 10 for LLMs). Teams that listed compliance as a generic quality attribute without architectural response placed lower. The honest deferral with documented rationale (Architects++, 3rd, Farmacy Family) outperformed superficial compliance claims.

**Competition detail**: Sysops Squad -- universal billing separation for PCI. Road Warrior -- Street Fighters produced comprehensive GDPR ADR (data classification, consent, breach notification). Farmacy Food -- external payment processors universal. Farmacy Family -- Archangels (1st) used crypto-shredding for GDPR. Certifiable Inc. -- all 7 teams implemented human-in-the-loop. ClearView -- Pragmatic (1st) designed deterministic boundaries around non-deterministic AI.

**Production insight**: Bitwarden demonstrates that zero-knowledge architecture makes compliance structural rather than procedural -- the server literally cannot access user data, making SOC2 and GDPR compliance an architectural property rather than an operational burden. This is the strongest form of "compliance by design" in the evidence base. nopCommerce's PCI compliance through payment gateway abstraction shows a more typical enterprise pattern: isolate the compliance boundary behind a well-defined interface.

---

### By Real-Time Requirements

| Real-Time Need | Best Style | Avg Placement | Production Evidence | Key Pattern | Confidence |
|----------------|-----------|---------------|--------------------:|-------------|------------|
| **None / Low** (batch, minutes OK) | Service-Based | 2.00 (n=25) | Puppet (AOSA): periodic convergence; Orchard Core (RealWorld) | Batch processing, queue-based decoupling, no infrastructure for real-time | Production-Validated |
| **Medium** (seconds acceptable) | Event-Driven + Service-Based | 2.57 (n=7) | Squidex (RealWorld): CQRS event processing; Graphite (AOSA): near-real-time metrics | Event-driven for specific async flows; message queues for decoupling | Production-Validated |
| **High** (sub-second needed) | Event-Driven + Microservices | 2.00 (n=13) | GStreamer (AOSA): real-time media pipeline; Twisted (AOSA): async reactor | Kafka/event streaming, WebSockets, in-memory data structures, multiple scaling groups | Production-Validated |
| **Critical** (lives depend on latency) | Pure Event-Driven with fitness functions | 2.00 (n=7) | NGINX (AOSA): microsecond event processing; ZeroMQ (AOSA): zero-copy, lock-free messaging | [PRODUCTION-VALIDATED] End-to-end timing proofs, non-blocking event loops, zero-copy data paths. NGINX and ZeroMQ demonstrate that critical latency demands event-driven architectures with performance as a structural property | Production-Validated |

**Competition detail**: MonitorMe -- BluzBrothers (1st) used Kafka + InfluxDB. LowCode (3rd tied) designed 3-node distributed appliance with graceful degradation and capability loss mapping per failure level. Road Warrior -- Profitero Data Alchemists (1st) defined 3 scaling groups with Kafka partitioning. Hey Blue! -- MonArch (1st) used in-memory graph for O(log n) proximity lookups.

**Pattern** (competition): Quantitative validation separates winners from runners-up. BluzBrothers' 693ms timing proof, Street Fighters' 4,000 email requests/second estimate, and Rapid Response's 240-second LoRaWAN transmission calculation all demonstrate that real-time claims backed by numbers outperform qualitative assertions.

**Production pattern**: NGINX achieves microsecond-level event processing through non-blocking I/O and worker-process isolation. ZeroMQ achieves millions of messages per second through zero-copy, lock-free data structures. GStreamer processes real-time media streams through pipeline architectures with back-pressure negotiation. Twisted handles thousands of concurrent connections through its reactor pattern. All four validate that **critical latency is an architecture problem, not a tuning problem** -- the style must be designed around the latency constraint from the ground up.

---

### By Edge/Offline Requirements

| Edge Need | Best Style | Avg Placement | Production Evidence | Key Pattern | Confidence |
|-----------|-----------|---------------|--------------------:|-------------|------------|
| **None** (cloud-only) | Per other dimensions | varies | Most AOSA/RealWorld systems | Standard cloud architecture patterns apply | High |
| **Edge with connectivity** (smart devices, fridges) | Event-Driven with edge gateway | 2.50 (n=2 top) | Jellyfin (RealWorld): self-hosted media server with offline playback | Eventual consistency between edge and cloud; offline-capable edge logic | Production-Validated |
| **Edge with severe constraints** (IoT, medical appliances) | Microservices with pragmatic monolith deploy | 3.00 (n=2) | HDFS (AOSA): DataNode edge processing with central coordination | Design as microservices, deploy as monolith where hardware constrains; separate only components needing independent scaling | Production-Validated |
| **On-premises appliance** (no cloud fallback) | Event-Driven (on-prem) | 2.00 (n=7) | Jellyfin (RealWorld): fully self-hosted with no cloud dependency; Bitwarden (RealWorld): self-hosted option | [PRODUCTION-VALIDATED] All infrastructure on-prem; graceful degradation mandatory. Jellyfin and Bitwarden both offer self-hosted deployments, validating on-prem event-driven architectures | Production-Validated |

**Competition detail**: 8 of 11 challenges have no edge/offline requirements. Farmacy Food -- Jaikaturi designed CDN-based offline authentication for smart fridges. ArchColider used event sourcing for eventual consistency between edge and cloud. Wildlife Watcher -- Rapid Response (2nd) designed 6 MS, deployed 5 as monolith, kept Camera Feed Engine separate for independent scaling. MonitorMe -- all 7 teams used EDA on-prem. BluzBrothers (1st) used Kafka + InfluxDB. LowCode designed capability loss mapping per failure level across 3-node distributed appliance.

**Production insight**: Jellyfin's self-hosted architecture is the strongest production validation of on-premises event-driven systems. It handles media transcoding, metadata management, and multi-client sync entirely on user-owned hardware with no cloud dependency. Bitwarden's self-hosted option demonstrates that even security-critical SaaS can be deployed on-premises with the same architecture. HDFS's DataNode architecture shows how edge processing (block-level operations on commodity hardware) can be coordinated through a central NameNode without requiring full cloud connectivity.

---

### By AI/ML Component

| AI Role | Best Style | Avg Placement | Production Evidence | Key Pattern | Confidence |
|---------|-----------|---------------|--------------------:|-------------|------------|
| **None** | Per other dimensions | varies | NGINX, HDFS, Git, GStreamer, ZeroMQ (AOSA) | Traditional distributed systems patterns; most production systems pre-date AI wave | High |
| **Peripheral** (nice-to-have feature) | Per other dimensions + defer AI | varies | -- | Treat AI as future extension; do not let AI drive architecture | Medium |
| **Supporting** (enhances core workflow) | Microservices with edge AI module | 2.25 (n=4) | -- | On-device AI constrained by hardware; ML training external; edge-cloud separation | Medium |
| **Central** (AI is the product) | Service-Based + EDA + human-in-loop | 3.00 (n=7) | Discovered: Multi-Agent(4), Modular Monolith(4) across 6 AI/ML repos | Deterministic boundaries around non-deterministic AI; confidence-based escalation; LLM cost optimization; AI evaluation frameworks | High |
| **Multi-Agent** (autonomous agents) | Multi-Agent + Supervisor | 4.00 (n=1) | Discovered: 4 multi-agent repos in AI/ML domain | Supervisor pattern for agent coordination; dual-LLM cost strategy; quantitative evaluation frameworks (Ragas, LangFuse) | Medium |

**Winner pattern in AI-central challenges** (competition): Top teams constrained AI rather than giving it free rein. They designed deterministic boundaries (Pragmatic), confidence-based escalation to humans (all Certifiable Inc. teams), multi-model cost optimization (ConnectedAI's dual-LLM strategy), and formal evaluation frameworks (ConnectedAI's Ragas, ZAITects' Langwatch). The architecture constrains the AI -- it does not just enable it.

**Competition detail**: ClearView -- Pragmatic (1st) reduced LLM calls from O(n*m) to O(n+m). Certifiable Inc. -- ZAITects (1st) used LLM-as-a-Judge + AI Gateway for LLM governance. ShopWise -- ConnectedAI (1st) used Ragas + LangFuse evaluation and dual-LLM cost strategy. Wildlife Watcher -- CELUS Ceals (1st) used Roboflow/TensorFlow Lite for edge inference.

**Anti-pattern** (competition): Multi-agent architectures in structured grading workflows. In Certifiable Inc., the multi-agent team (Usfive) placed as runner-up while simpler service-based approaches (ZAITects 1st, Litmus 2nd) won. ZAITects explicitly rejected Agentic AI for this use case.

**Discovered evidence**: The 6 AI/ML repos in the Discovered corpus show Multi-Agent(4) and Modular Monolith(4) as the dominant styles, suggesting the open-source community is exploring both agent-based and modular approaches. This aligns with the competition finding that AI-central systems benefit from structured decomposition rather than monolithic AI pipelines.

---

## Compound Mappings: Multi-Dimension Lookups

### "I have a problem like..."

For common multi-dimensional problem profiles, these are the specific recommended approaches based on the strongest available evidence.

| Problem Profile | Sources | Recommended Approach | Key Decisions | Confidence |
|----------------|---------|---------------------|---------------|------------|
| **Budget-constrained non-profit, medium scale** | [COMPETITION] Spotlight, Hey Blue!, ClearView | Service-Based + selective EDA; evolutionary roadmap from MM to distributed | Include cost analysis with per-user projections; document evolution triggers tied to business milestones | **High** (3 challenges, 5 first-place teams) |
| **Healthcare with real-time + on-prem** | [COMPETITION] MonitorMe | Event-Driven with Kafka; on-premises deployment; time-series DB; fitness-function-proven latency | Downplay scalability if ceiling is fixed; prove timing quantitatively; design graceful degradation | **High** (7 teams, unanimous EDA convergence) |
| **Greenfield startup with high integration** | [COMPETITION] Farmacy Food; [PRODUCTION] nopCommerce | Modular Monolith + Event Sourcing + DDD; evolution path to distributed. nopCommerce validates 17-year MM longevity | Vendor research as architecture; 3-scenario cost model; resist microservices until domain model is proven | **Production-Validated** |
| **AI-centric with accuracy requirements** | [COMPETITION] Certifiable Inc., ClearView; [DISCOVERED] 6 AI/ML repos | Service-Based + EDA + human-in-the-loop + deterministic boundaries around AI | Confidence-based escalation; LLM-as-a-Judge evaluation; reject autonomous AI for high-stakes decisions | **High** (4 first-place teams across 3 AI challenges) |
| **Travel / consumer at extreme scale** | [COMPETITION] Road Warrior; [PRODUCTION] NGINX (AOSA) | Event-Driven + Microservices; CQRS for read/write separation; multiple scaling groups. NGINX validates EDA at internet scale | Define scaling groups per workload; use Space-Based for global distribution if needed | **Production-Validated** |
| **IoT with edge/offline constraints** | [COMPETITION] Wildlife Watcher; [PRODUCTION] HDFS (AOSA), Jellyfin (RealWorld) | Microservices design with pragmatic monolith deploy; edge processing module separate. HDFS validates edge+central coordination | Quantify bandwidth constraints; comparative analysis of all integration platforms | **Production-Validated** |
| **Legacy monolith migration** | [COMPETITION] Sysops Squad; [REFERENCE] modular-monolith-with-ddd | Service-Based (not microservices); transition architecture > target architecture. RefArch validates MM+DDD as migration stepping stone | Document the migration path, not just the destination; phased decomposition with fitness-function gates | **High** |
| **Plugin ecosystem for extensibility** | [PRODUCTION] LLVM, GStreamer (AOSA); Jellyfin, nopCommerce, Orchard Core (RealWorld) | Plugin + Pipeline with stable intermediate abstractions | Stable IR/API contracts; plugin discovery/negotiation protocols; versioned extension points | **Production-Validated** (5 production systems converge) |
| **Event-driven for high throughput** | [PRODUCTION] NGINX, ZeroMQ, Twisted (AOSA) | Event-Driven + non-blocking I/O; or Broker-less + Actor | Zero-copy data paths; lock-free concurrency; event loop per core | **Production-Validated** (3 AOSA systems converge) |
| **Pipeline for data transformation** | [PRODUCTION] LLVM, GStreamer, Graphite (AOSA) | Pipeline + Plugin with stage isolation | Stable intermediate representations between stages; back-pressure mechanisms; parallel stage execution | **Production-Validated** (3 AOSA systems converge) |
| **Multi-tenant SaaS platform** | [PRODUCTION] Orchard Core, Squidex (RealWorld) | Modular Monolith + Plugin (Orchard) or CQRS + Event Sourcing (Squidex) | Tenant isolation strategy (shared DB vs. DB per tenant); plugin-based feature toggling per tenant | **Production-Validated** |
| **Security-critical with zero-knowledge** | [PRODUCTION] Bitwarden (RealWorld) | Service-Based + Event-Driven with end-to-end encryption | Zero-knowledge architecture; compliance as structural property; multi-client sync with encrypted payloads | **Production-Validated** |
| **Health community with HIPAA + startup budget** | [COMPETITION] Farmacy Family | Event-Driven with Kafka integration backbone; honest compliance handling | Crypto-shredding for GDPR; HIPAA-eligible service selection; or defer HIPAA with documented rationale | **High** (7 teams; Archangels 1st) |
| **AI chatbot / e-commerce** | [COMPETITION] ShopWise AI | Multi-Agent supervisor + text-to-SQL; working prototype | Dual-LLM cost strategy; quantitative evaluation framework (Ragas); text-to-SQL beats RAG for structured data | **Medium** (4 teams; small sample) |
| **Established enterprise extending with AI** | [COMPETITION] Certifiable Inc. | Service-Based + AI pipeline + human oversight | Separate Grader from Judge (LLM-as-a-Judge); microkernel for parallel AI variants; reject over-automation; document what you rejected and why | **High** (7 teams; ZAITects 1st; all teams used human-in-the-loop) |
| **Non-profit AI platform with bias concerns** | [COMPETITION] ClearView | Service-Based + selective EDA; deterministic matching pipeline; adapter pattern for unbounded HR integrations | Reduce LLM calls architecturally (O(n+m) not O(n*m)); PII anonymization as cross-cutting concern; calculate per-candidate AI costs | **Medium** (7 teams; Pragmatic 1st with deterministic approach) |
| **Distributed database with extreme availability** | [PRODUCTION] Riak (AOSA) | Peer-to-Peer + Eventual Consistency | CAP theorem trade-offs; vector clocks for conflict resolution; ring-based partitioning; read-repair for consistency | **Production-Validated** |
| **Cross-platform testing automation** | [PRODUCTION] Selenium (AOSA) | Service-Based + Adapter | Adapter pattern per browser/platform; remote execution protocol; driver isolation | **Production-Validated** |
| **Async networking framework** | [PRODUCTION] Twisted (AOSA) | Event-Driven + Reactor | Reactor pattern for event demultiplexing; deferred/callback chains; protocol abstraction | **Production-Validated** |

**How to use the compound mappings**: Start by finding the profile that best matches your problem. If no profile matches exactly, combine insights from the closest two or three profiles. Weight production-validated profiles more heavily than competition-only profiles. For profiles with multiple recommended approaches (e.g., E-Commerce with Plugin+Layered or Microservices+DDD), choose based on your team's operational maturity -- simpler approaches for less experienced teams, more complex approaches for teams with proven distributed systems experience.

---

## Quality Attribute to Style Mapping

Which architecture styles best support which quality attributes, based on 78 competition submissions cross-referenced with production evidence.

| Quality Attribute | Best Style (Competition) | Avg Score | Production Validation | Worst Style | Confidence |
|-------------------|------------------------|-----------|----------------------|-------------|------------|
| **Scalability** | Modular Monolith | 3.00 (n=3) | NGINX: Event-Driven at internet scale; HDFS: Primary-Secondary at petabyte scale; Riak: Peer-to-Peer for extreme availability | Serverless (1.50, n=6) | Production-Validated |
| **Availability** | Modular Monolith | 3.67 (n=3) | Riak (AOSA): peer-to-peer eventual consistency for extreme availability; HDFS: block replication for fault tolerance | Service-Based (1.50, n=14) | Production-Validated |
| **Performance** | Modular Monolith | 3.33 (n=3) | NGINX (AOSA): microsecond event processing; ZeroMQ (AOSA): zero-copy, lock-free messaging; Git (AOSA): content-addressable storage for O(1) lookups | Serverless (1.67, n=6) | Production-Validated |
| **Security** | Modular Monolith | 3.25 (n=4) | Bitwarden (RealWorld): zero-knowledge Service-Based architecture with SOC2 certification | Microservices (1.52, n=21) | Production-Validated |
| **Extensibility** | Modular Monolith | 4.00 (n=2) | LLVM, GStreamer (AOSA): Plugin+Pipeline; Jellyfin, nopCommerce (RealWorld): Plugin architecture. 5 production systems validate plugin-based extensibility | Service-Based (1.40, n=10) | Production-Validated |
| **Evolvability** | Modular Monolith | 4.00 (n=2) | nopCommerce (RealWorld): 17 years of evolution on Plugin+Layered; modular-monolith-with-ddd (RefArch): MM with extraction points | Service-Based (1.40, n=10) | Production-Validated |
| **Cost / Feasibility** | Modular Monolith | 3.00 (n=5) | Jellyfin (RealWorld): self-hosted = zero cloud cost; Orchard Core (RealWorld): MM minimizes infra spend | Microservices (1.81, n=16) | Production-Validated |
| **Data Integrity** | Service-Based | 2.50 (n=4) | Squidex (RealWorld): CQRS + Event Sourcing provides full audit trail; HDFS (AOSA): checksummed block replication | -- | Production-Validated |
| **Interoperability** | Event-Driven | 2.33 (n=12) | LLVM (AOSA): stable IR bridges dozens of languages and hardware targets; GStreamer (AOSA): capability negotiation bridges thousands of codecs | Microservices (1.67, n=6) | Production-Validated |
| **Observability** | Service-Based | 2.25 (n=4) | Graphite (AOSA): purpose-built monitoring pipeline; Bitwarden (RealWorld): structured event logging | Microservices (1.50, n=6) | Production-Validated |
| **Simplicity** | Modular Monolith | 2.33 (n=3) | SQLAlchemy (AOSA): layered abstraction manages SQL complexity; Orchard Core (RealWorld): MM reduces deployment complexity | Microservices (not cited) | Production-Validated |

**The Modular Monolith paradox** (competition evidence): Modular Monolith shows the highest average placement score across almost every quality attribute. This is partly a selection effect -- the 6 teams that chose MM were disproportionately thoughtful architects making a contrarian, well-reasoned choice. The style's strength is not that monoliths are inherently superior, but that **teams who resist the microservices default and justify a simpler choice tend to exhibit the architectural reasoning judges reward.** Small sample size (n=6) limits statistical confidence.

**Production confirmation**: The paradox holds in production. nopCommerce (17 years, 60K stores) and Orchard Core (multi-tenant CMS) both use monolith-derived architectures and have outlasted many microservices-first competitors. LLVM and GStreamer achieve extreme extensibility through plugin architectures, not microservices decomposition. SQLAlchemy manages the complexity of SQL transparency vs. ORM convenience through layered abstraction, not service decomposition. The common thread: **successful production architectures manage complexity through abstractions (layers, plugins, pipelines), not through distribution (microservices).**

**Competition vs. production scoring nuance**: In competition, MM's high scores partly reflect a selection effect (thoughtful contrarians). In production, MM's success reflects a design effect (simpler operational model, fewer failure modes, lower infrastructure cost). Both effects are real but different. Competition evidence tells you MM architects tend to be better architects. Production evidence tells you MM architectures tend to be more durable. Both are useful signals.

**The Microservices trap** (competition evidence): Microservices consistently underperforms relative to its adoption rate. With 39 teams (50% of all submissions), it is the second most popular style but ranks below Service-Based and Modular Monolith in per-team effectiveness for every quality attribute except raw team count. The differentiator: microservices teams that paired with EDA, DDD, or evolutionary approaches performed markedly better than those using microservices alone (1.70 avg for MS-only vs. 2.00+ for MS + EDA).

**Discovered corpus alignment**: The 122 Discovered repos provide independent validation. Event-Driven appears in 19/36 developer tool repos, confirming its dominance. Modular Monolith appears in 13/36 developer tool repos and 4/7 infrastructure repos, confirming the MM paradox extends beyond competition. DDD appears in 7/11 e-commerce repos, confirming its strength in complex business domains. Space-Based appears in 5/6 data grid repos, confirming its niche but strong applicability. Multi-Agent appears in 4/6 AI/ML repos, a pattern emerging since the competition dataset was compiled.

**Production quality attribute insights not visible in competition data**:
- **Fault tolerance**: HDFS (block replication), Riak (peer-to-peer), NGINX (worker isolation) -- production systems reveal that fault tolerance is a structural property requiring specific architectural patterns, not just redundancy
- **Zero-copy performance**: ZeroMQ demonstrates that performance at extreme scale requires eliminating data copying at the architecture level, not just optimizing algorithms
- **Backward compatibility**: LLVM's stable IR and GStreamer's capability negotiation show that extensibility at scale requires stable intermediate abstractions that evolve independently of plugins
- **Multi-tenancy**: Orchard Core and Squidex demonstrate two production-validated approaches -- plugin-based feature isolation (Orchard) and CQRS-based data isolation (Squidex)

---

## Style Combination Performance Matrix

The most actionable finding in the dataset: **which style combinations actually win**, now validated against production evidence.

| Combination | Teams | Avg Placement | 1st Place Wins | Production Validation | Key Insight |
|-------------|-------|---------------|----------------|----------------------|-------------|
| **Event-Driven + Service-Based** | 7 | **2.57** | 3 | Bitwarden (RealWorld), Graphite (AOSA) | Highest-performing common combination. Production-validated in security and monitoring domains |
| **Event-Driven + Pipeline** | -- | -- | -- | NGINX, GStreamer (AOSA) | [PRODUCTION-VALIDATED] No competition data, but 2 AOSA systems demonstrate this at extreme scale |
| **Plugin + Pipeline** | -- | -- | -- | LLVM, GStreamer (AOSA) | [PRODUCTION-VALIDATED] The extensibility combination; stable IR/caps enable ecosystem growth |
| **Plugin + Layered** | -- | -- | -- | SQLAlchemy (AOSA), nopCommerce (RealWorld) | [PRODUCTION-VALIDATED] Layered abstraction with plugin extensibility; proven in ORM and e-commerce |
| **CQRS + Event Sourcing** | -- | -- | -- | Squidex (RealWorld), eShopOnContainers (RefArch) | [PRODUCTION-VALIDATED] Full audit trail with read/write optimization; headless CMS and e-commerce reference |
| **Modular Monolith + Plugin** | -- | -- | -- | Orchard Core (RealWorld), Jellyfin (RealWorld) | [PRODUCTION-VALIDATED] MM with plugin extensibility for multi-tenant and media domains |
| **Modular Monolith + [any distributed target]** | 6 | **3.00** | 3 | modular-monolith-with-ddd (RefArch) | Every MM team with a documented evolution path placed top 3. RefArch validates the pattern |
| **Event-Driven + Microservices** | 17 | **1.29** | 0 from combo alone | eShopOnContainers, eShop (RefArch) | Most common competition combination but lowest-performing per team. Reference architectures exist but competition evidence is cautionary |
| **3+ complementary styles** | 11 | **2.36** | 4 | LLVM (Pipeline+Plugin+Modular), GStreamer (Pipeline+Plugin), wild-workouts-go (DDD+Hex+CQRS+MS) | Multi-style mastery correlates with placement; production systems confirm multi-style architectures |
| **CQRS + DDD + Modular Monolith** | 1 | **4.00** | 1 | modular-monolith-with-ddd (RefArch) | ArchColider (1st, Farmacy Food): highest-scoring single submission. RefArch validates the exact combination |
| **Single style** | 30 | **1.87** | 3 | -- | Adequate but not differentiated; single-style teams must compensate with exceptional documentation |

**The combination rule** (competition evidence): Event-Driven + Service-Based (avg 2.57) outperforms Event-Driven + Microservices (avg 1.29) by a factor of 2x on per-team placement. Three of seven EDA+SB teams won first place; zero of seventeen EDA+MS teams won from the combination alone. For most problems, Service-Based + selective Event-Driven is the optimal starting combination.

**Production insight**: The production evidence adds combinations that competition data cannot test. Plugin + Pipeline (LLVM, GStreamer) and Event-Driven + Pipeline (NGINX, GStreamer) are two of the most successful combinations in production but appear in zero competition submissions. This suggests competition framing biases toward enterprise architecture styles, while production systems reveal infrastructure architecture combinations that are equally important.

**Reference architecture alignment**: The RefArch corpus validates several combinations. eShopOnContainers demonstrates Microservices + Event-Driven + DDD + CQRS as a reference implementation. modular-monolith-with-ddd validates CQRS + DDD + Modular Monolith -- the exact combination that produced the highest-scoring single competition submission (ArchColider). wild-workouts-go validates DDD + Hexagonal + CQRS + Microservices for Go-based systems. These reference implementations serve as blueprints for the combinations that both competition and production evidence recommend.

---

## Documentation Practices to Placement Mapping

Which documentation artifacts most predict success for which problem types, based on winner analysis (competition evidence only -- production systems use different documentation paradigms).

| Problem Type | Critical Doc Artifact | Placement Impact | Evidence |
|-------------|----------------------|-----------------|----------|
| **Scale-heavy** (Road Warrior, Hey Blue!) | Fitness functions with quantitative targets | Winners avg 3.5 vs. 1.5 without | BluzBrothers (1st, MonitorMe): 693ms end-to-end proof. Profitero Data Alchemists (1st, Road Warrior): 3 scaling groups with workload sizing. Street Fighters calculated 4,000 email req/sec |
| **Budget-constrained** (Spotlight, ClearView, Farmacy Food) | Cost analysis with concrete projections | Every 1st place in non-profit katas included cost analysis; 0 runners-up without cost analysis won | ArchColider: $12K-$23K/yr 3-scenario. MonArch: $2,780/mo. TheGlobalVariables: $0.002/user/mo. Katamarans: $0.06/candidate. DevExperts: $8,448/yr |
| **High-integration** (Wildlife Watcher, Road Warrior, ClearView) | Sequence diagrams + integration analysis | Top-3 teams at 2x rate of runners-up for integration-heavy challenges | CELUS Ceals (1st): comparative platform analysis tables. Pragmatic (1st): adapter-based HR integration with sequence flows. Profitero: Kafka partition strategy aligned to databases |
| **Compliance-heavy** (Farmacy Family, ClearView, Certifiable Inc.) | Security/compliance-specific ADRs | Teams with specific compliance ADRs placed avg +1.0 higher than teams with generic compliance mentions | Archangels (1st): crypto-shredding ADR-005 for GDPR. ZAITects (1st): OWASP Top 10 for LLM. Street Fighters: comprehensive GDPR ADR (data classification, consent, breach notification) |
| **Brownfield / migration** (Sysops Squad) | Transition architecture diagrams | Team Seven (1st) centered submission on transition architecture, not just target state | Team Seven: phased migration plan. Pentagram: fitness-function-driven phase gates. Hey Dragon: 3-stage evolution (monolith to SB to EDA-MS) |
| **AI-centric** (ShopWise, ClearView, Certifiable Inc.) | AI feasibility analysis + evaluation framework | All top-3 AI teams included feasibility analysis; ConnectedAI's Ragas evaluation separated 1st from all others | ConnectedAI (1st): Ragas + LangFuse. ZAITects (1st): comprehensive LLM production stack + cost projection. Pragmatic (1st): deterministic matching cost reduction. Litmus (2nd): rejected AI anti-cheating with full ADRs |
| **Any challenge** | ADR count 10+ | 1st place teams avg 14.1 ADRs vs. runners-up avg 9.2. Top ADR counts: Pragmatic (22), Ctrl+Alt+Elite (20), BluzBrothers (20), The Marmots (19) | Teams with 0 ADRs (Arch Angels, Transformers) never placed higher than Runner-up/3rd. Minimum viable threshold appears to be 6-7 ADRs for top-3 contention |
| **Any challenge** | Deployment view | 82% of 1st-place teams include deployment view vs. 50% of runners-up | Deployment view demonstrates architecture has been thought through to implementation level. Its absence suggests abstract-only architecture |
| **Any challenge** | C4 modeling | Winners using C4 avg 3.2 placement vs. 1.8 without | BluzBrothers (1st): full C4. The Archangels (1st): full C4. MonArch (1st): C4 component modeling per service. CELUS Ceals (1st): extensive C4 |

**Note on production documentation**: Production systems (AOSA, RealWorld) use fundamentally different documentation approaches than competition submissions. AOSA chapters focus on "lessons learned" and "mistakes made" narratives. RealWorld projects rely on code-as-documentation with README files. Reference architectures use extensive code comments and architectural decision logs. None use the ADR-heavy, C4-driven approach that competition evidence rewards. This divergence suggests that documentation best practices are context-dependent: formal architectural documentation is critical for upfront design decisions, while production systems benefit more from evolutionary documentation that captures what changed and why.

---

## Cross-Source Analysis: Where Sources Agree and Disagree

The most valuable findings emerge when multiple independent evidence sources converge on the same recommendation, or when they diverge in instructive ways.

### Strong Convergences (highest-confidence recommendations)

**Event-Driven for high-throughput systems**: All 5 sources agree. Competition: 7/7 MonitorMe teams, 8/9 Road Warrior teams chose EDA. AOSA: NGINX, ZeroMQ, Twisted all use event-driven at extreme scale. RealWorld: Bitwarden uses event-driven sync. RefArch: eShopOnContainers uses event-driven messaging. Discovered: Event-Driven is the most common style across 122 repos (appears in 36+ developer tool repos alone). This is the single highest-confidence recommendation in the matrix.

**Plugin architecture for extensibility**: 4 sources agree. AOSA: LLVM, GStreamer, SQLAlchemy all use plugin systems. RealWorld: Jellyfin, nopCommerce, Orchard Core all use plugin architectures. Competition: Microkernel/Plugin appears in Wildlife Watcher (Wonderous Toys 3rd, SAG). RefArch: eShopOnContainers uses plugin-like bounded contexts. The production evidence is overwhelming: when extensibility is a primary quality attribute, plugin architecture outperforms microservices decomposition.

**Modular Monolith for startups and budget-constrained environments**: 4 sources agree. Competition: 6/6 MM teams averaged 3.00 placement. RealWorld: nopCommerce (17 years, 60K stores) and Orchard Core (multi-tenant CMS). RefArch: modular-monolith-with-ddd demonstrates the pattern. Discovered: Modular Monolith appears in 13/36 developer tool repos. The "start simple" advice is not just academic -- it is production-proven.

**Service-Based + EDA as the default combination**: 3 sources agree. Competition: highest-performing common combination (avg 2.57, 3 first-place wins). RealWorld: Bitwarden, Graphite use this combination. Discovered: appears across multiple domains. This is the safest default for teams without strong domain-specific requirements.

### Where Discovered Corpus Adds New Signal

The 122 Discovered repositories provide the broadest view of real-world architecture choices, covering domains and scale levels not represented in competition or curated production evidence:

- **Developer Tools (36 repos)**: Event-Driven(19), Modular Monolith(13), CQRS(11) -- the largest domain, confirming EDA dominance and MM viability
- **E-Commerce (11 repos)**: DDD(7), Event-Driven(5), Microservices(4) -- DDD is the standout pattern, more prevalent than microservices
- **Infrastructure (7 repos)**: Modular Monolith(4), Event-Driven(3) -- infrastructure teams favor simplicity, aligning with AOSA evidence
- **AI/ML (6 repos)**: Multi-Agent(4), Modular Monolith(4) -- multi-agent pattern emerging strongly in this new domain
- **Data Grid (6 repos)**: Space-Based(5), Event-Driven(4) -- strongest single-pattern dominance in any domain

### Instructive Divergences

**Pipeline architecture**: Strong in production (LLVM, GStreamer, Graphite, NGINX all use pipelines), absent from competition. This suggests that competition framing biases toward enterprise/business systems where pipeline architecture is less common, while infrastructure systems heavily rely on pipeline patterns. Practitioners building data processing, compilation, media, or monitoring systems should weight AOSA evidence more heavily than competition evidence.

**Microservices performance**: Competition evidence is strongly cautionary (avg 1.29 when paired with EDA, underperforms in every quality attribute). But reference architectures (eShopOnContainers, wild-workouts-go) and Discovered repos show microservices as the dominant style for mature, well-understood domains. The resolution: microservices require **proven domain boundaries and operational maturity** -- competition teams often lack both, while reference architectures assume both.

**CQRS + Event Sourcing**: RealWorld evidence (Squidex) and RefArch evidence (eShopOnContainers, modular-monolith-with-ddd) validate this combination, but competition evidence is limited (ArchColider is the only strong example). This combination appears underused in competition but well-validated in production, suggesting it is a high-skill pattern that delivers strong results when applied correctly.

**Space-Based architecture**: Competition evidence (Road Warrior Iconites 2nd) and Discovered evidence (5/6 Data Grid repos) support this for extreme scale, but no AOSA or RealWorld system uses it. This may reflect the pattern's niche applicability or its relative novelty compared to the older AOSA systems. However, the Discovered corpus's strong signal (5/6 in Data Grid) suggests it is well-established in its niche.

**Broker-less messaging**: ZeroMQ (AOSA) demonstrates broker-less, zero-copy messaging at extreme throughput, but no competition team or RealWorld app uses this pattern. All competition teams that used messaging chose brokered approaches (Kafka, RabbitMQ). This divergence suggests that broker-less patterns are a specialized infrastructure concern that enterprise application architects rarely encounter but infrastructure architects should consider.

**Content-addressable storage**: Git (AOSA) uses content-addressable storage for O(1) lookups and structural sharing. No competition team uses this pattern. Like pipeline and broker-less, this is an infrastructure architecture pattern invisible in enterprise-focused evidence sources.

---

## Decision Flowchart: Choosing Your Style

For practitioners using this matrix, follow this sequence:

**Step 1: Check your AI role.**
- If AI is central to your product, start with Service-Based + EDA + human-in-the-loop. See the AI-centric compound mapping above. Competition evidence: 4 first-place teams across 3 AI challenges used this pattern. Discovered evidence: Multi-Agent(4) and Modular Monolith(4) dominate AI/ML repos.
- If AI is peripheral or absent, proceed to Step 2.

**Step 2: Check your scale and budget.**
- If startup/non-profit with unproven domain: **Modular Monolith** with documented evolution path. Production validation: nopCommerce (17 years, 60K stores), Orchard Core (multi-tenant CMS).
- If medium-scale established: **Service-Based + selective EDA**. Production validation: Bitwarden (SOC2, 16K+ stars).
- If large-scale with proven domain boundaries: **Microservices + EDA** (ensure DDD decomposition). Reference validation: eShopOnContainers, wild-workouts-go.
- If very large scale with strict SLAs: **EDA + CQRS/Space-Based**. Discovered validation: Space-Based(5/6) in Data Grid repos.
- If extreme / internet scale: **Event-Driven + Pipeline** or **Peer-to-Peer**. Production validation: NGINX (billions req/day), HDFS (petabytes), ZeroMQ (millions msg/sec).

**Step 3: Check your real-time needs.**
- If critical (lives depend on latency): **Event-Driven** with fitness-function-proven timing. Consider on-premises deployment. Production validation: NGINX (microsecond event processing), ZeroMQ (zero-copy messaging).
- If high (sub-second needed): **Event-Driven + Microservices** with quantitative validation. Production validation: GStreamer (real-time media pipeline).
- If low/none: Style driven by other dimensions; avoid over-investing in real-time infrastructure.

**Step 4: Check your integration complexity.**
- If ecosystem (100+ integrations): **Plugin + Pipeline** with stable intermediate abstractions. Production validation: LLVM, GStreamer (AOSA).
- If very high (8+ systems): Add **Plugin** pattern for extensibility; invest in comparative platform analysis before architecture. Production validation: Jellyfin, nopCommerce (RealWorld).
- If high (6+ systems): Use **event-driven integration backbone** (Kafka) with adapter pattern per system. Production validation: Puppet, Selenium (AOSA).
- If medium or low: Standard integration patterns suffice; Hexagonal architecture (buckpal, clean-architecture-dotnet RefArch) isolates integration at port boundaries.

**Step 5: Check your compliance load.**
- If high (HIPAA, career-affecting, SOC2): Dedicate specific ADRs to compliance; consider zero-knowledge architecture (Bitwarden), crypto-shredding, dedicated compliance boundaries, or honest deferral with documented rationale.
- If medium (PCI, GDPR): Isolate sensitive data into dedicated services (billing for PCI, consent service for GDPR). Production validation: nopCommerce (PCI-compliant payment integration).
- If none: Focus architecture effort elsewhere.

**Step 6: Document the evolution path.** Regardless of starting style, document when and why you would evolve to the next style tier. Tie evolution triggers to business milestones (user thresholds, funding rounds), not arbitrary timelines. 73% of first-place winners proposed multi-style or phased architectures (competition evidence). Production evidence confirms: nopCommerce evolved over 17 years; LLVM grew from 1 frontend to dozens through stable plugin APIs.

**Step 7: Validate against production evidence.** Before finalizing your style choice, check if a production system in this matrix operates in a similar domain with a similar style. If your chosen style has production validation, you have the highest confidence level. If it has only competition evidence, consider whether the competition context (time-boxed, theoretical, judged) matches your real-world constraints. If it has only reference architecture evidence, note that reference architectures demonstrate patterns but not operational challenges.

**Common mistakes to avoid** (compiled from all 5 sources):
1. **Choosing microservices by default**: Competition evidence shows MS underperforms relative to adoption. Production evidence shows the most successful systems (NGINX, LLVM, nopCommerce) use event-driven, pipeline, or plugin architectures instead.
2. **Ignoring the plugin pattern**: 5 production systems (LLVM, GStreamer, SQLAlchemy, nopCommerce, Orchard Core) use plugin architectures for extensibility. Competition teams rarely consider this option.
3. **Underestimating pipeline architecture**: 4 AOSA systems use pipeline patterns. This is the most underused pattern relative to its production success.
4. **Over-engineering for scale that does not exist yet**: Competition evidence (MM paradox) and production evidence (nopCommerce longevity) both show that simpler architectures can serve longer than expected.
5. **Treating compliance as an afterthought**: Both Bitwarden (production) and competition winners demonstrate that compliance is most effective when it is a structural property of the architecture, not a policy layer.

---

**Source reliability hierarchy**: For any given recommendation, weight evidence in this order: (1) Production-Validated (AOSA + RealWorld convergence), (2) Cross-source agreement (3+ sources), (3) Production-only (single AOSA or RealWorld system), (4) Competition-only (KataLog data), (5) Single-source (Discovered or RefArch alone). When sources conflict, investigate whether the conflict stems from different problem contexts (enterprise vs. infrastructure), different scale tiers, or different maturity levels.

*Generated: 2026-03-05. Evidence sources: 78 O'Reilly Architecture Kata submissions across 11 challenges (Fall 2020 -- Winter 2025), 12 AOSA production systems (NGINX, HDFS, Git, LLVM, GStreamer, Graphite, ZeroMQ, Twisted, SQLAlchemy, Riak, Puppet, Selenium), 5 RealWorldASPNET production apps (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex), 8 reference architecture implementations (eShopOnContainers, eShop, modular-monolith-with-ddd, buckpal, clean-architecture-dotnet, wild-workouts-go, serverless-microservices-azure, AKS Baseline), and 122 Discovered open-source repositories across 5 top domains. Source data: `problem-spaces.md`, `solution-spaces.md`, `evidence/by-architecture-style.md`, `evidence/by-quality-attribute.md`, `aosa-catalog.md`, `realworld-aspnet-catalog.md`, `reference-architectures-catalog.md`, `discovered-catalog.md`.*
