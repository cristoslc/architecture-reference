# Problem-Solution Mapping Matrix

The analytical core of the reference library: evidence-backed mappings from problem characteristics to architecture styles, grounded in production-only statistical analysis of 142 entries (87 platforms, 55 applications; ratio 1.58:1) from the Discovered corpus, validated by 17 production systems (AOSA + RealWorld), and enriched with qualitative reasoning from 78 competition teams (KataLog). Total evidence base: 259 entries across 5 sources (142 production + 42 reference + 17 AOSA/RealWorld + 78 KataLog; reference implementations serve as annotation examples only per ADR-001).

---

## How to Read This Matrix

Mappings are grounded in Discovered corpus statistics (142 production entries, deep-validated via source code inspection and recomputed per SPEC-022/ADR-002 deep-analysis) as the primary evidence layer. Production systems (AOSA/RealWorld) provide depth validation. Competition evidence (KataLog) provides qualitative reasoning -- the "why" behind the statistical patterns.

**Evidence hierarchy:**

1. **Discovered statistical distributions** -- frequency counts, percentages, and co-occurrence patterns from 142 production-only entries (87 platforms, 55 applications), deep-validated via source code inspection. Reference implementations (42 entries) are excluded from frequency counts per ADR-001 (equal weighting) and serve as annotation examples only. This answers "what do real production codebases actually use?"
2. **Production-validated mappings** -- deep production evidence from AOSA and RealWorld system creators. Small sample (17 systems) but highest individual authority.
3. **Qualitative reasoning: competition evidence** -- KataLog team ADRs, judge commentary, and "show your work" artifacts from 78 submissions. Valued specifically for explaining *why* patterns work -- reasoning unavailable in code analysis.
4. **Reference architecture validation** -- RefArch implementations (42 entries) confirming recommended patterns with working code. Not counted in frequencies per ADR-001.

**Confidence levels:**
- **Production-Validated** = Discovered pattern confirmed by AOSA or RealWorld production system (highest)
- **High** = 3+ sources agree, or Discovered + production evidence converges
- **Medium** = 2 sources, or 3+ sources with mixed results
- **Low** = single source or extrapolated

> **Detection bias:** Discovered statistics are derived from deep-analysis source code inspection. Styles and QAs that leave strong code signals are more reliably detected. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this specific gap -- teams documented these invisible decisions in ADRs and presentations.
>
> **Methodology update (SPEC-022, ADR-002):** Discovered statistics are now derived from production-only entries (142 of 184 total repos), recomputed via ADR-002 deep-analysis frequency recomputation. Reference implementations (42 entries) are excluded from frequency counts per ADR-001 equal weighting and serve as annotation examples only. Old style names have been canonicalized (e.g., "Plugin/Microkernel" -> "Microkernel", "Pipe-and-Filter" -> "Pipeline"). Zero Indeterminate entries remain -- ADR-002 deep-analysis resolved all prior classification ambiguity.
>
> **Tutorial bias correction (SPEC-022):** DDD (old 8.5% -> new 2.1%), CQRS (old 7.0% -> new 0.7%), and Hexagonal (old 3.5% -> new 3.5%) were inflated in prior counts by reference/tutorial implementations now excluded. Microkernel (new 58.5%) and Layered (new 54.9%) rose dramatically as deep-analysis properly identifies plugin architectures and layered patterns in production codebases.

**Limitations:** Correlation is not causation. Style frequency does not prove effectiveness. Each repo may exhibit multiple styles; counts are not mutually exclusive. Competition data covers 78 teams across 11 challenges -- some cells have small sample sizes. Production systems may reflect survivorship bias.

**Platform vs Application dimension:** The 142 production entries split into 87 platforms and 55 applications (ratio 1.58:1). Style prevalence varies by entry type -- Microkernel is more prevalent in platforms (61%) than applications (55%), while Layered is more prevalent in applications (67%) than platforms (47%). This dimension is noted where relevant throughout the matrix.

---

## Discovered Domain-Style Matrix (PRIMARY)

Statistical mapping from 142 production-only entries across 47 unique domains. This is the primary evidence layer: "In domain X, style Y appears in N entries." The "Production Confirmed" column flags where AOSA/RealWorld systems validate the Discovered pattern. Top domains: Developer Tools (36), E-Commerce (15), Observability (11), Data Processing (11), Infrastructure (9), Data Grid (8), Messaging (6), Productivity (5), Media Automation (5), Workflow Orchestration (5).

| Domain | Entries | Top Style 1 | Top Style 2 | Top Style 3 | Production Confirmed |
|--------|---------|-------------|-------------|-------------|---------------------|
| **Developer Tools** | 36 | Microkernel (dominant) | Layered | Modular Monolith | Notable: nest (74k stars), redis (73k stars) |
| **E-Commerce** | 15 | Layered | Microkernel | Modular Monolith | nopCommerce (Plugin+Layered), eShopOnContainers (MS+DDD+CQRS). Notable: saleor (22k stars) |
| **Observability** | 11 | Microkernel | Layered | Pipeline | Graphite (Pipeline+SB). Notable: grafana (72k stars) |
| **Data Processing** | 11 | Pipeline | Microkernel | Layered | Graphite (Pipeline+SB). Notable: airflow (44k stars), localstack (64k stars) |
| **Infrastructure** | 9 | Microkernel | Layered | Pipeline | NGINX (EDA+Pipeline). Notable: traefik (62k stars) |
| **Data Grid** | 8 | Microkernel | Layered | Modular Monolith | Riak (P2P, Eventual Consistency). Notable: dragonfly (30k stars) |
| **Messaging** | 6 | Microkernel | Event-Driven | Modular Monolith | ZeroMQ (Broker-less+Pipeline+Actor) |
| *Additional 40 domains* | varies | Varies | Varies | Varies | HDFS, LLVM, GStreamer, Selenium, Puppet, SQLAlchemy, Twisted |

**Key statistical findings (142 production entries, SPEC-022/ADR-002):**

1. **Microkernel is the most prevalent style**, appearing in 83 of 142 production entries (58.5%). Deep-analysis properly identifies plugin architectures that were previously underdetected. More prevalent in platforms (53/87, 61%) than applications (30/55, 55%).
2. **Layered is the second most prevalent style** at 78 entries (54.9%), appearing across most domain clusters. More prevalent in applications (37/55, 67%) than platforms (41/87, 47%).
3. **Modular Monolith remains the third most prevalent style** at 57 entries (40.1%), stable from the prior estimate (39.9%). Notable projects include AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k), nest (74k), redis (73k).
4. **Event-Driven dropped significantly** from 28.8% to 17/142 (12.0%) after tutorial bias correction and production-only filtering. More prevalent in applications (10/55, 18%) than platforms (7/87, 8%).
5. **Domain-specific specialization is real.** Pipeline appears in 13 entries (9.2%), predominantly in Data Processing and Infrastructure. Microservices (12, 8.5%) is more prevalent in platforms (11/87, 13%) than applications (1/55, 2%).
6. **Tutorial bias correction:** DDD dropped from 8.5% to 3/142 (2.1%), CQRS from 7.0% to 1/142 (0.7%). These styles were heavily inflated by reference/tutorial implementations now excluded per ADR-001.
7. **E-Commerce is the most cross-validated domain** with evidence from 4 of 5 sources (Discovered, Production, Competition, RefArch).

---

## Production-Validated Mappings

These mappings have the highest confidence -- Discovered statistical frequency AND production validation from systems built, deployed, and operated under real-world conditions.

| Domain | Discovered Pattern | Production System | Production Style | Convergence |
|--------|-------------------|-------------------|-----------------|-------------|
| **E-Commerce** | Layered + Microkernel dominant in 15 entries | nopCommerce (RealWorld) | Plugin + Layered | Direct match -- Layered and Microkernel are top-2 styles in E-Commerce |
| **E-Commerce** | Layered + Microkernel dominant in 15 entries | eShopOnContainers (RefArch) | MS + DDD + CQRS | DDD/CQRS now rare in production (2.1%/0.7%); tutorial bias inflated prior counts |
| **CMS / Content** | Modular Monolith + Layered dominant | Orchard Core (RealWorld) | MM + Plugin | Direct match -- MM dominant in Discovered CMS repos |
| **CMS / Content** | Modular Monolith + Layered dominant | Squidex (RealWorld) | CQRS + Event Sourcing | Validates CQRS path for headless CMS (rare but validated) |
| **Infrastructure** | Microkernel + Layered + Pipeline in 9 entries | NGINX (AOSA) | Event-Driven + Pipeline | Pipeline confirmed at internet scale (billions req/day) |
| **Data Grid** | Microkernel + Layered in 8 entries | Riak (AOSA) | Peer-to-Peer + Eventual Consistency | Confirms distributed data pattern |
| **Data Processing** | Pipeline + Microkernel + Layered in 11 entries | Graphite (AOSA) | Pipeline + Service-Based | Pipeline confirmed by production pipeline |
| **Messaging** | Microkernel + Event-Driven in 6 entries | ZeroMQ (AOSA) | Broker-less + Pipeline + Actor | Event-Driven confirmed at extreme throughput |
| **Security** | (no Discovered cluster) | Bitwarden (RealWorld) | Service-Based + Event-Driven | SOC2 + GDPR; zero-knowledge encryption |
| **Media / Streaming** | (cross-domain) | GStreamer (AOSA), Jellyfin (RealWorld) | Pipeline + Plugin | Thousands of codecs/devices |
| **Compiler / DevTools** | Microkernel + Layered dominant in Developer Tools (36 entries) | LLVM (AOSA), Git (AOSA) | Pipeline + Plugin | Pipeline confirmed in production compilers/devtools |

**SPEC-022 rebalancing insight:** Microkernel now shows 83 of 142 production entries (58.5%) -- the most prevalent style -- after ADR-002 deep-analysis properly identifies plugin architectures. Notable projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). This confirms what 6 production systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, nopCommerce, Orchard Core) already demonstrated: Microkernel is the most widely-used production pattern.

Service-Based now shows 7 of 142 production entries (4.9%), down from the prior 11/163 (6.7%) estimate after production-only filtering. Notable projects: dify (131k stars), mastodon (49k), temporal (18k). Combined with 3 production systems (Selenium, Graphite, Bitwarden), this remains validated but niche.

---

## Qualitative Reasoning: Competition Evidence

KataLog competition teams (78 submissions, 11 challenges) explain *why* they chose specific styles for specific domains. This qualitative reasoning is unavailable in code analysis -- teams documented decisions in ADRs, cost projections, and presentations evaluated by expert judges.

### By Domain Type

| Domain | Competition Challenge | Winning Style | Key Reasoning | Avg Placement |
|--------|----------------------|---------------|---------------|---------------|
| **Healthcare / MedTech** | MonitorMe | Event-Driven | All 7 teams chose EDA; BluzBrothers (1st) proved 693ms latency with Kafka + fitness functions | 2.00 (n=7) |
| **Food / Logistics** | Farmacy Food | Modular Monolith; DDD + Event Sourcing | ArchColider (1st) won with MM against 6 microservices teams, citing "unproven domain model" | 4.00 (n=1); 3.50 (n=2) |
| **Enterprise IT / Migration** | Sysops Squad | Service-Based + EDA | 6 of 7 teams chose service-based; Team Seven (1st) added event-driven queues | 2.33 (n=6) |
| **Non-Profit / HR Tech** | ClearView, Spotlight | Service-Based + EDA; Modular Monolith | Pragmatic (1st) used SB+EDA; PegasuZ (1st) used MM evolving to MS+EDA | 2.57 (n=7); 3.25 (n=2) |
| **Civic Tech / Social Impact** | Hey Blue! | Multi-style evolutionary | MonArch (1st) combined MM + MS + EDA + Hexagonal + Serverless; most style-diverse winner | 4.00 (n=1) |
| **Conservation / IoT** | Wildlife Watcher | Microservices; Modular Monolith (pragmatic deploy) | CELUS Ceals (1st) used MS with C4; Rapid Response (2nd) designed 6 MS but deployed 5 as monolith | 2.25 (n=4) |
| **Travel / Consumer** | Road Warrior | Event-Driven; EDA + Space-Based | Profitero Data Alchemists (1st) used pure EDA with Kafka; Iconites (2nd) added Space-Based for global distribution | 1.75 (n=8) |
| **Retail / AI** | ShopWise AI | Multi-Agent + EDA + MS | ConnectedAI (1st) used multi-agent supervisor with LangGraph + Ragas evaluation | 4.00 (n=1) |
| **EdTech / AI** | Certifiable Inc. | Service-Based + EDA | ZAITects (1st) used SB + EDA; explicitly rejected Agentic AI for structured workflows | 4.00 (n=1) |
| **Health / Community** | Farmacy Family | Event-Driven | Archangels (1st) used EDA with Kafka + crypto-shredding for GDPR | 2.25 (n=4) |

**Anti-patterns from competition evidence:**
- Pure Microservices in budget-constrained contexts: In ClearView (non-profit), Jazz Executor (MS-only) placed as runner-up. In Sysops Squad, the sole MS team placed runner-up while all 6 SB teams placed higher.
- Multi-Agent for structured workflows: In Certifiable Inc., the multi-agent team (Usfive) placed as runner-up while simpler SB approaches won.

### By Scale (competition + Discovered convergence)

| Scale Tier | Discovered Signal | Competition Best Style | Competition Avg | Production Validation |
|------------|------------------|----------------------|-----------------|----------------------|
| **Small** (<1K users) | Modular Monolith: 57 of 142 entries (40.1%) | Modular Monolith | 3.00 (n=6) | Orchard Core, Squidex (RealWorld) |
| **Medium** (1K-100K) | Service-Based (7 entries, 4.9%) + EDA (17 entries, 12.0%) across multiple domains | Service-Based + EDA | 2.57 (n=7) | Bitwarden (16K+ stars), nopCommerce (60K stores), Jellyfin |
| **Large** (100K-2M) | Event-Driven + Microservices co-occur across entries | Event-Driven + Microservices | 2.20 (n=5) | eShopOnContainers (RefArch), Graphite, Puppet (AOSA) |
| **Very Large** (2M+) | Space-Based (1 entry, 0.7%), CQRS (1 entry, 0.7%) | EDA + Space-Based / CQRS | 2.33 (n=3) | Riak (AOSA), Discovered Data Grid repos (dragonfly 30k stars) |
| **Extreme** (internet-scale) | Event-Driven (17 entries, 12.0%), Pipeline (13 entries, 9.2%) | No competition data | -- | NGINX (billions req/day), HDFS (petabytes), ZeroMQ (millions msg/sec) |

**Critical insight (competition):** Scale alone does not determine style. MonitorMe has only 500 patients but demands 4,000 events/second. Data intensity, not user count, drove the universal EDA choice. Conversely, Farmacy Food's winner chose Modular Monolith despite potential national scale, prioritizing startup economics. **Match style to current scale, document the evolution path to future scale.**

**Production insight:** At extreme scale, the scaling dimension itself determines the style. NGINX scales request throughput through non-blocking event loops. HDFS scales storage through block replication. ZeroMQ scales message throughput through zero-copy, lock-free structures. Riak scales availability through peer-to-peer eventual consistency. **Match style to the dominant scaling dimension, not a single metric.**

### By Budget Constraint

Discovered corpus context: Modular Monolith appears in 57 of 142 production entries (40.1%), the third most prevalent style but the most common single-deployment-unit architecture. Microkernel (83, 58.5%) and Layered (78, 54.9%) are more prevalent overall but frequently co-occur with MM. This aligns with competition evidence that simpler architectures succeed in budget-constrained environments.

| Budget | Competition Best Style | Competition Avg | Production Validation |
|--------|----------------------|-----------------|----------------------|
| **Startup / Non-Profit** | Modular Monolith (initial) | 3.00 (n=6) | nopCommerce: started as monolith, scaled to 60K stores over 17 years |
| **Startup / Non-Profit** (2nd) | Service-Based + EDA | 2.57 (n=7) | Bitwarden: SB + EDA at startup scale, SOC2 certified |
| **Growth / Scaling** | Event-Driven + Microservices | 2.00 (n=17) | eShopOnContainers, wild-workouts-go (RefArch) |
| **Enterprise** | Per-quantum style selection | varies | NGINX, HDFS, LLVM (AOSA) |

**Competition detail:** ArchColider (1st, Farmacy Food): 3-scenario cost model $12K-$23K/yr. PegasuZ (1st, Spotlight): MM MVP. MonArch (1st, Hey Blue!): $2,780/mo GCP. Pragmatic (1st, ClearView): token cost estimation. Cost analysis is the single strongest predictor of placement in budget-constrained katas.

### By Integration Complexity

Discovered corpus context: Event-Driven appears in 17 of 142 production entries (12.0%), serving as the integration backbone where present. Pipeline at 13 entries (9.2%) appears predominantly in infrastructure and data processing domains with high integration needs. Microkernel (83 entries, 58.5%) provides the dominant extensibility mechanism for integration. Notable projects: dify (131k stars), langchain (128k), localstack (64k), traefik (62k), airflow (44k).

| Complexity | Competition Best Style | Competition Avg | Production Validation |
|------------|----------------------|-----------------|----------------------|
| **Low** (0-2 systems) | Service-Based or focused pipeline | 2.86 (n=7) | buckpal, clean-architecture-dotnet (RefArch) |
| **Medium** (3-5 systems) | Service-Based + EDA | 2.33 (n=6) | Bitwarden (multi-client sync), Graphite (Carbon+Whisper+web) |
| **High** (6+ systems) | Event-Driven with integration backbone | 2.25 (n=4) | Puppet (dozens of OS/platforms), Selenium (all major browsers) |
| **Very High** (8+ systems) | Microkernel + Event-Driven | 2.00 (n=2) | LLVM (dozens of frontends+backends), GStreamer (thousands of codecs) |
| **Ecosystem** (100+) | Microkernel + Pipeline | -- | LLVM, GStreamer, SQLAlchemy (AOSA) |

**Production validation:** LLVM's three-phase pipeline with stable IR enables dozens of frontends and backends to interoperate. GStreamer's capability negotiation enables thousands of plugins to self-discover compatibility. SQLAlchemy's dialect system integrates with PostgreSQL, MySQL, SQLite, Oracle through pluggable backends. All five production systems validate that **stable intermediate abstractions** are the key to scaling integration complexity.

### By Real-Time Requirements

Discovered corpus context: Event-Driven (17 entries, 12.0%) remains the primary pattern for systems with real-time components, though less prevalent than prior estimates (was 28.8%). CQRS (1 entry, 0.7%) and Space-Based (1 entry, 0.7%) are rare in production codebases -- tutorial bias correction significantly reduced their counts. Production systems (NGINX, ZeroMQ, GStreamer) remain the strongest evidence for real-time patterns.

| Real-Time Need | Competition Best Style | Competition Avg | Production Validation |
|----------------|----------------------|-----------------|----------------------|
| **None / Low** | Service-Based | 2.00 (n=25) | Puppet (periodic convergence), Orchard Core |
| **Medium** (seconds) | Event-Driven + Service-Based | 2.57 (n=7) | Squidex (CQRS event processing), Graphite (near-real-time metrics) |
| **High** (sub-second) | Event-Driven + Microservices | 2.00 (n=13) | GStreamer (real-time media pipeline), Twisted (async reactor) |
| **Critical** (lives depend) | Pure Event-Driven with fitness functions | 2.00 (n=7) | NGINX (microsecond event processing), ZeroMQ (zero-copy messaging) |

**Competition pattern:** Quantitative validation separates winners from runners-up. BluzBrothers' 693ms timing proof, Street Fighters' 4,000 email req/sec estimate, and Rapid Response's 240-second LoRaWAN calculation demonstrate that real-time claims backed by numbers outperform qualitative assertions.

**Production pattern:** NGINX, ZeroMQ, GStreamer, and Twisted all validate that **critical latency is an architecture problem, not a tuning problem** -- the style must be designed around the latency constraint from the ground up.

### By Compliance Load

| Compliance | Competition Best Style | Competition Avg | Production Validation |
|------------|----------------------|-----------------|----------------------|
| **None / Low** | Any (driven by other dimensions) | varies | Most AOSA systems (NGINX, LLVM, GStreamer, ZeroMQ) |
| **Medium** (PCI, GDPR-PII) | Service-Based + EDA | 2.33 (n=6) | nopCommerce: PCI-compliant payment integration |
| **High** (HIPAA, SOC2) | SB + EDA with compliance boundaries | 2.57 (n=7) | Bitwarden: SOC2 + GDPR; zero-knowledge architecture |

**Competition finding:** Compliance load correlates with ADR quality as a placement predictor. Top teams documented compliance with specific ADRs referencing concrete standards (NIST 800-111, HIPAA-eligible AWS services, OWASP Top 10 for LLMs). Teams listing compliance as a generic quality attribute without architectural response placed lower.

### By Edge/Offline and AI/ML Requirements

**Edge/Offline** -- Discovered context: Jellyfin (RealWorld) validates self-hosted event-driven architecture. HDFS (AOSA) validates edge+central coordination. 8 of 11 competition challenges have no edge/offline requirements.

| Edge Need | Recommendation | Production Validation |
|-----------|---------------|----------------------|
| **None** (cloud-only) | Per other dimensions | Most AOSA/RealWorld systems |
| **Edge with connectivity** | Event-Driven with edge gateway | Jellyfin (self-hosted offline playback) |
| **Severe constraints** (IoT) | MS design, pragmatic monolith deploy | HDFS (DataNode edge processing) |
| **On-premises** (no cloud) | Event-Driven (on-prem) | Jellyfin, Bitwarden (self-hosted options) |

**AI/ML** -- Discovered context: Multi-Agent appears in 1 of 142 production entries (0.7%) -- significantly lower than the prior estimate of 11/163 (6.7%) due to tutorial bias correction. Many prior Multi-Agent repos were reference/tutorial implementations now excluded per ADR-001. Notable production Multi-Agent project: AutoGPT (182k stars). Competition evidence and reference implementations (langchain, autogen, crewAI) remain the primary guidance for AI/ML architecture.

| AI Role | Discovered Signal | Competition Best Style | Competition Avg |
|---------|------------------|----------------------|-----------------|
| **None** | Per other dimensions | Per other dimensions | varies |
| **Supporting** | -- | MS with edge AI module | 2.25 (n=4) |
| **Central** (AI is the product) | Multi-Agent (1 entry, 0.7%); reference implementations provide examples | SB + EDA + human-in-loop | 3.00 (n=7) |
| **Multi-Agent** | 1 production entry; reference implementations (langchain, autogen, crewAI) as annotation examples | Multi-Agent + Supervisor | 4.00 (n=1) |

**Winner pattern (competition):** Top teams constrained AI rather than giving it free rein -- deterministic boundaries (Pragmatic), confidence-based escalation (all Certifiable Inc. teams), multi-model cost optimization (ConnectedAI's dual-LLM strategy), and formal evaluation frameworks (ConnectedAI's Ragas, ZAITects' Langwatch).

---

## Compound Problem Mappings

For common multi-dimensional problem profiles, these are the recommended approaches. Each mapping leads with Discovered corpus evidence for the relevant domain, then cites production validation and competition reasoning.

| Problem Profile | Discovered Signal | Production Validation | Competition Reasoning | Confidence |
|----------------|-------------------|----------------------|----------------------|------------|
| **Budget-constrained non-profit, medium scale** | Modular Monolith: 57 of 142 entries (40.1%); SB (7 entries, 4.9%) + EDA (17 entries, 12.0%) across multiple domains | nopCommerce (17yr MM), Bitwarden (SB+EDA) | Spotlight, Hey Blue!, ClearView: 5 first-place teams used SB+EDA or MM with evolution path | **High** |
| **Healthcare with real-time + on-prem** | Event-Driven: 17 of 142 entries (12.0%); validated for real-time patterns by production systems | NGINX (microsecond EDA), ZeroMQ (zero-copy) | MonitorMe: 7 teams, unanimous EDA convergence; BluzBrothers 693ms proof | **High** |
| **Greenfield startup with high integration** | MM (57 entries) + Microkernel (83 entries) co-occur frequently | nopCommerce validates 17-year MM longevity | Farmacy Food: ArchColider (1st) won with MM + 3-scenario cost model | **Production-Validated** |
| **AI-centric with accuracy requirements** | Multi-Agent: 1 production entry (0.7%); reference implementations as annotation examples | -- | 4 first-place teams across 3 AI challenges used SB+EDA+human-in-loop | **High** |
| **Travel / consumer at extreme scale** | Event-Driven (17 entries, 12.0%), Space-Based (1 entry, 0.7%) | NGINX validates EDA at internet scale | Road Warrior: Profitero (1st) used EDA+Kafka; Iconites (2nd) added Space-Based | **Production-Validated** |
| **IoT with edge/offline constraints** | MS (12 entries, 8.5%) + EDA (17 entries, 12.0%) across domains | HDFS (edge+central), Jellyfin (self-hosted) | Wildlife Watcher: CELUS Ceals (1st) used MS with C4 | **Production-Validated** |
| **Legacy monolith migration** | MM (57 entries, 40.1%) as dominant starting architecture | -- | Sysops Squad: SB (not MS); transition architecture > target architecture | **High** |
| **Plugin ecosystem for extensibility** | Microkernel: 83 entries (58.5%) -- n8n (177k), elasticsearch (76k), grafana (72k) | LLVM, GStreamer, SQLAlchemy, nopCommerce, Orchard Core (5 systems) | Rarely considered in competition | **Production-Validated** |
| **Event-driven for high throughput** | Event-Driven: 17 of 142 entries (12.0%) | NGINX, ZeroMQ, Twisted (3 AOSA systems) | MonitorMe, Road Warrior winners used EDA | **Production-Validated** |
| **Pipeline for data transformation** | Pipeline: 13 entries (9.2%) -- dominant in Data Processing and Infrastructure | LLVM, GStreamer, Graphite (3 AOSA systems) | Absent from competition (framing bias) | **Production-Validated** |
| **Multi-tenant SaaS** | CMS repos show MM dominant; Layered: 78 entries (54.9%) | Orchard Core (MM+Plugin), Squidex (CQRS+ES) | -- | **Production-Validated** |
| **Security-critical with zero-knowledge** | -- | Bitwarden (SB+EDA, SOC2+GDPR) | ClearView: Pragmatic (1st) designed deterministic boundaries | **Production-Validated** |
| **Distributed database with extreme availability** | Space-Based: 1 of 142 production entries (0.7%); Data Grid cluster (8 entries) | Riak (P2P + Eventual Consistency) | -- | **Production-Validated** |

---

## QA-to-Style Mappings

Quality attribute-to-style correlations grounded in Discovered detection data, validated by production evidence, and enriched with competition reasoning.

### Discovered QA Detection (142 production entries)

| Quality Attribute | Entries | % of Corpus | Detection Bias Notes |
|-------------------|---------|-------------|---------------------|
| Deployability | ~126 | ~89% | Inflated by Docker/CI signal prevalence |
| Modularity | ~48 | ~34% | |
| Scalability | ~38 | ~27% | |
| Fault Tolerance | ~21 | ~15% | |
| Observability | ~4 | ~3% | Underdetected -- hard to infer from filesystem |
| Evolvability | ~3 | ~2% | Underdetected -- hard to infer from filesystem |

### QA-to-Style Matrix (all sources)

| Quality Attribute | Discovered Correlation | Production Validation | Competition Best Style (Avg) | Competition Worst Style |
|-------------------|----------------------|----------------------|------------------------------|------------------------|
| **Scalability** | Space-Based (1 entry, 0.7% -- rare in production); Event-Driven (17 entries, 12.0%) in throughput-critical domains | NGINX (internet-scale EDA), HDFS (petabyte replication), Riak (extreme availability) | Modular Monolith (3.00, n=3) | Serverless (1.50, n=6) |
| **Availability** | Event-Driven (17 entries, 12.0%) + fault tolerance patterns across domains | Riak (P2P eventual consistency), HDFS (block replication) | Modular Monolith (3.67, n=3) | Service-Based (1.50, n=14) |
| **Performance** | Pipeline (13 entries, 9.2%) in throughput-critical domains | NGINX (microsecond events), ZeroMQ (zero-copy), Git (content-addressable O(1)) | Modular Monolith (3.33, n=3) | Serverless (1.67, n=6) |
| **Security** | Hexagonal (5 entries, 3.5%) provides port-based security isolation | Bitwarden (zero-knowledge, SOC2) | Modular Monolith (3.25, n=4) | Microservices (1.52, n=21) |
| **Extensibility** | Microkernel: 83 entries (58.5%) -- n8n (177k), elasticsearch (76k), nest (74k), grafana (72k) | LLVM, GStreamer (Plugin+Pipeline), Jellyfin, nopCommerce (Plugin) -- 5 systems | Modular Monolith (4.00, n=2) | Service-Based (1.40, n=10) |
| **Evolvability** | DDD (3 entries, 2.1%) + Hexagonal (5 entries, 3.5%) -- rare in production; tutorial bias correction reduced these significantly. Production systems and RefArch provide stronger evidence. | nopCommerce (17 years on Plugin+Layered); modular-monolith-with-ddd (RefArch) | Modular Monolith (4.00, n=2) | Service-Based (1.40, n=10) |
| **Cost / Feasibility** | MM (57 entries, 40.1%) is cheapest to operate (single deployment unit) | Jellyfin (self-hosted = zero cloud cost), Orchard Core (MM minimizes infra) | Modular Monolith (3.00, n=5) | Microservices (1.81, n=16) |
| **Data Integrity** | CQRS (1 entry, 0.7%) -- rare in production codebases; tutorial bias correction reduced this significantly. Production systems provide the primary evidence. | Squidex (CQRS+ES full audit), HDFS (checksummed replication) | Service-Based (2.50, n=4) | -- |
| **Interoperability** | Microkernel (83 entries, 58.5%) enables integration extensibility | LLVM (stable IR bridges languages/hardware), GStreamer (capability negotiation) | Event-Driven (2.33, n=12) | Microservices (1.67, n=6) |

**The Modular Monolith paradox:** MM shows the highest competition placement score across almost every QA. This is partly a selection effect -- the 6 teams that chose MM were disproportionately thoughtful architects making a contrarian, well-reasoned choice.

The Discovered corpus independently validates this: Modular Monolith appears in 57 of 142 production entries (40.1%), the third most prevalent style. Notable projects include AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k). Production evidence confirms it too: nopCommerce (17 years, 60K stores) and Orchard Core have outlasted many microservices-first competitors.

**The Microservices trap:** 39 competition teams (50% of submissions) chose MS, making it the most popular style. Yet it ranks below SB and MM in per-team effectiveness for every QA. The Discovered corpus shows MS in only 12 of 142 production entries (8.5%) -- confirming it is far less common than competition popularity suggests.

The differentiator: MS teams that paired with EDA, DDD, or evolutionary approaches performed markedly better than MS-only. MS-only averaged 1.70 points; MS+EDA averaged 2.00+.

**Production QA insights not visible in competition or Discovered data:**
- **Fault tolerance**: HDFS (block replication), Riak (peer-to-peer), NGINX (worker isolation) -- structural property, not just redundancy
- **Zero-copy performance**: ZeroMQ demonstrates performance at extreme scale requires eliminating data copying at the architecture level
- **Backward compatibility**: LLVM's stable IR and GStreamer's capability negotiation show extensibility at scale requires stable intermediate abstractions
- **Multi-tenancy**: Orchard Core (plugin-based feature isolation) and Squidex (CQRS-based data isolation) demonstrate two production-validated approaches

---

## Style Combination Performance

Which style combinations succeed, grounded in Discovered co-occurrence data and validated by production and competition evidence.

### Discovered Co-occurrence Patterns (142 production entries)

The strongest co-occurrence in the production corpus: **Microkernel + Layered appear together frequently** -- reflecting the common pattern of plugin architectures with layered internal structure. **Microkernel + Modular Monolith** is also highly prevalent, reflecting plugin-based modular designs.

Other significant co-occurrences: **Layered + Modular Monolith**, **Event-Driven + Modular Monolith**, and **Microkernel + Pipeline** round out the top pairs. The dominance of Microkernel and Layered in co-occurrence data reflects the SPEC-022 rebalancing -- deep-analysis identified these cross-cutting patterns far more frequently than prior methods.

### Combination Performance (all sources)

| Combination | Discovered Co-occurrence | Competition Teams / Avg | Production Validation |
|-------------|------------------------|------------------------|----------------------|
| **Microkernel + Layered** | Most common pair in production corpus | No competition data | nopCommerce (RealWorld), LLVM (AOSA) |
| **Microkernel + Modular Monolith** | Second most common pair | No competition data | Orchard Core, Jellyfin, n8n (177k stars), elasticsearch (76k) |
| **Layered + Modular Monolith** | Third most common pair | No competition data | nopCommerce (RealWorld) |
| **Event-Driven + Modular Monolith** | Common pair (EDA at 12.0%, MM at 40.1%) | 6 / 3.00 (3 first-place wins) | Orchard Core (RealWorld) |
| **DDD + Hexagonal** | Rare in production (DDD 2.1%, Hexagonal 3.5%); tutorial bias correction reduced counts. Reference implementations provide annotation examples. | 4 / varies | Notable RefArch: CleanArchitecture (19k), domain-driven-hexagon (14k) |
| **CQRS + DDD** | Rare in production (CQRS 0.7%, DDD 2.1%); tutorial bias correction reduced counts significantly. | ArchColider (1st): 4.00 | Notable RefArch: CleanArchitecture (19k), modular-monolith-with-ddd (13k) |
| **Event-Driven + Service-Based** | Across multiple domains | 7 / 2.57 (3 first-place wins) | Bitwarden, Graphite |
| **Event-Driven + Pipeline** | Infrastructure + Data Processing domains | No competition data | NGINX, GStreamer (AOSA) |
| **Microkernel + Pipeline** | Common in production | No competition data | LLVM, GStreamer (AOSA) |
| **Event-Driven + Microservices** | Less common than prior estimates | 17 / 1.29 (0 first-place from combo alone) | eShopOnContainers, eShop (RefArch) |
| **3+ complementary styles** | Common in larger repos | 11 / 2.36 (4 first-place wins) | LLVM, GStreamer, wild-workouts-go |

**The combination rule:** Event-Driven + Service-Based (avg 2.57) outperforms Event-Driven + Microservices (avg 1.29) by 2x on per-team placement. The Discovered corpus confirms this independently: Microkernel + Layered and Microkernel + MM are the dominant pairs. The open-source community converges on plugin architectures with layered structure and modular boundaries.

**SPEC-022 insight:** The rebalancing reveals that Microkernel and Layered co-occurrence patterns dominate production codebases -- previously invisible under prior detection methods. Notable projects exhibiting Microkernel + Layered: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k). DDD + Hexagonal and CQRS + DDD co-occurrence counts dropped significantly due to tutorial bias correction -- these combinations remain valid architectural approaches but are primarily evidenced by reference implementations (annotation examples) and competition teams, not production frequency. Competition framing bias (enterprise over infrastructure) explains why Microkernel-based pairs are absent from competition submissions.

---

## Cross-Source Analysis: Where Sources Agree and Disagree

### Strong Convergences (highest-confidence recommendations)

**Event-Driven for high-throughput systems:** All 5 sources agree. Discovered: 17 of 142 production entries (12.0%) -- lower than prior estimates due to tutorial bias correction, but production systems provide overwhelming validation. AOSA: NGINX, ZeroMQ, Twisted. RealWorld: Bitwarden. RefArch: eShopOnContainers. Competition: 7 of 7 MonitorMe teams and 8 of 9 Road Warrior teams chose EDA. This remains the single highest-confidence recommendation in the matrix -- production validation and competition consensus are stronger signals than Discovered frequency alone.

**Modular Monolith for startups and budget-constrained environments:** All 5 sources now agree. Discovered: 57 of 142 production entries (40.1%) -- the third most prevalent style and the most common single-deployment-unit architecture. Notable projects: AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k). RealWorld: nopCommerce (17 years), Orchard Core. RefArch: modular-monolith-with-ddd. Competition: all 6 MM teams averaged 3.00 placement score. The "start simple" advice is production-proven.

**Microkernel/Plugin architecture for extensibility:** Now the most prevalent style in production. Discovered: 83 of 142 entries (58.5%) after SPEC-022 deep-analysis -- n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). More prevalent in platforms (61%) than applications (55%). AOSA: LLVM, GStreamer, SQLAlchemy. RealWorld: Jellyfin, nopCommerce, Orchard Core. Competition: Wildlife Watcher (Wonderous Toys 3rd). The production evidence is overwhelming: plugin/microkernel is the most common production pattern. Deep-analysis resolved the prior detection blind spot.

### Instructive Divergences

**Pipeline architecture:** Strong in production (LLVM, GStreamer, Graphite, NGINX), 13 Discovered production entries (9.2%), but absent from competition. Competition framing biases toward enterprise systems where pipeline is less common.

**Microservices performance gap:** Competition is strongly cautionary -- MS+EDA averages only 1.29 placement points. Discovered shows MS in only 12 of 142 production entries (8.5%). More prevalent in platforms (13%) than applications (2%). Notable MS projects: supabase (98k stars), dapr (25k), microservices-demo (19k). RefArch repos (eShopOnContainers, wild-workouts-go) assume proven domain boundaries and operational maturity. Competition teams typically lack both.

**Space-Based architecture:** Discovered: 1 of 142 production entries (0.7%) -- significantly lower than the prior 5/163 (3.1%) estimate after production-only filtering. Competition: Road Warrior Iconites (2nd place). No AOSA/RealWorld system uses it. Extremely niche.

**DDD, CQRS, Hexagonal -- tutorial bias correction:** These styles dropped significantly in production frequency (DDD 2.1%, CQRS 0.7%, Hexagonal 3.5%) after excluding reference/tutorial implementations per ADR-001. They remain valid architectural approaches -- production systems (Bitwarden, Squidex, nopCommerce) and competition winners validate them -- but their prior Discovered frequencies were inflated by tutorial/reference codebases.

---

## Decision Flowchart: Choosing Your Style

**Step 1: Check your AI role.** In the Discovered corpus (142 production entries), Multi-Agent appears in 1 entry (0.7%) -- lower than prior estimates due to tutorial bias correction. Reference implementations (langchain, autogen, crewAI) serve as annotation examples. Competition evidence: 4 first-place teams across 3 AI challenges used SB+EDA+human-in-the-loop. If AI is central, start there.

**Step 2: Check your scale and budget.** Discovered evidence: Microkernel (83 entries, 58.5%) and Layered (78, 54.9%) are the most prevalent styles, reflecting cross-cutting patterns. Modular Monolith (57 entries, 40.1%) is the most common single-deployment-unit architecture. For startups: MM with documented evolution path (validated by nopCommerce, 17 years). For medium scale: SB+EDA (validated by Bitwarden). For large scale with proven boundaries: MS+EDA. For extreme scale: EDA+Pipeline (validated by NGINX, ZeroMQ).

**Step 3: Check your real-time needs.** If critical: Event-Driven with fitness-function-proven timing (NGINX validates microsecond processing). If high: EDA+MS with quantitative validation. If none: style driven by other dimensions.

**Step 4: Check your integration complexity.** If ecosystem (100+): Microkernel+Pipeline with stable intermediate abstractions (LLVM, GStreamer validate). Microkernel confirmed at 83 entries (58.5%) -- the most prevalent style. If high (6+): event-driven integration backbone with adapter pattern (Puppet, Selenium validate). If low: Hexagonal architecture (5 entries, 3.5%) isolates integration at port boundaries.

**Step 5: Check your compliance load.** If high (HIPAA, SOC2): consider zero-knowledge architecture (Bitwarden), crypto-shredding, dedicated compliance boundaries. If medium (PCI, GDPR): isolate sensitive data into dedicated services.

**Step 6: Document the evolution path.** Tie evolution triggers to business milestones, not arbitrary timelines. In the Discovered corpus, Microkernel + MM co-occurrence and Microkernel + Layered co-occurrence are the most common evolutionary configurations. 73% of first-place competition winners proposed multi-style or phased architectures. Production evidence confirms longevity: nopCommerce evolved over 17 years, and LLVM grew from 1 frontend to dozens through stable plugin APIs.

**Step 7: Validate against production evidence.** Check if a production system in this matrix operates in a similar domain with a similar style. Production-validated > cross-source agreement > competition-only > single-source.

**Common mistakes to avoid** (all 5 sources):
1. **Choosing microservices by default:** Production-only Discovered shows MS at only 8.5% (12/142 entries), while Microkernel (58.5%), Layered (54.9%), and MM (40.1%) are far more prevalent. Competition shows MS underperforms. Production shows the most successful systems use EDA, pipeline, or plugin architectures.
2. **Ignoring the plugin/microkernel pattern:** Now confirmed as the most prevalent style at 83 entries (58.5%). More prevalent in platforms (61%) than applications (55%). Plus 5 production systems. Consider microkernel when extensibility is primary.
3. **Underestimating pipeline architecture:** 13 production entries (9.2%) use pipeline patterns and 4 AOSA production systems validate them. It is the most underused pattern relative to its production success.
4. **Over-engineering for scale that does not exist yet:** Discovered MM prevalence (40.1%) and nopCommerce longevity both show simpler architectures serve longer than expected.
5. **Treating compliance as an afterthought:** Bitwarden (production) and competition winners both demonstrate compliance is most effective as a structural property.

---

## Documentation Practices to Placement Mapping

Competition evidence only -- production systems use different documentation paradigms. Preserved as qualitative reasoning for practitioners.

| Problem Type | Critical Doc Artifact | Placement Impact | Evidence |
|-------------|----------------------|-----------------|----------|
| **Scale-heavy** | Fitness functions with quantitative targets | Winners avg 3.5 vs. 1.5 without | BluzBrothers: 693ms proof. Profitero: 3 scaling groups. Street Fighters: 4,000 email req/sec |
| **Budget-constrained** | Cost analysis with concrete projections | Every 1st place in non-profit katas included cost analysis | ArchColider: $12K-$23K/yr. MonArch: $2,780/mo. TheGlobalVariables: $0.002/user/mo |
| **High-integration** | Sequence diagrams + integration analysis | Top-3 teams at 2x rate of runners-up | CELUS Ceals: comparative platform analysis. Pragmatic: adapter-based HR integration |
| **Compliance-heavy** | Security/compliance-specific ADRs | Teams with specific ADRs placed avg +1.0 higher | Archangels: crypto-shredding ADR-005. ZAITects: OWASP Top 10 for LLM |
| **Brownfield / migration** | Transition architecture diagrams | Centered on transition, not just target state | Team Seven: phased migration. Pentagram: fitness-function-driven gates |
| **AI-centric** | AI feasibility analysis + evaluation framework | All top-3 AI teams included feasibility | ConnectedAI: Ragas+LangFuse. ZAITects: LLM production stack |
| **Any challenge** | ADR count 10+ | 1st place avg 14.1 ADRs vs. runners-up avg 9.2 | Top: Pragmatic (22), Ctrl+Alt+Elite (20), BluzBrothers (20), The Marmots (19) |
| **Any challenge** | C4 modeling | Winners using C4 avg 3.2 vs. 1.8 without | BluzBrothers, Archangels, MonArch, CELUS Ceals: all 1st place with full C4 |

---

*Generated: 2026-03-09. Updated per SPEC-023 (Reference Library Rebalancing) using SPEC-022 production-only frequency rankings (ADR-002 deep-analysis). Evidence sources: 142 production-only Discovered entries (87 platforms, 55 applications) across 47 domains, 42 reference implementation annotation examples, 12 AOSA production systems (NGINX, HDFS, Git, LLVM, GStreamer, Graphite, ZeroMQ, Twisted, SQLAlchemy, Riak, Puppet, Selenium), 5 RealWorldASPNET production apps (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex), and 78 O'Reilly Architecture Kata submissions across 11 challenges (Fall 2020 -- Winter 2025). Source data: `problem-spaces.md`, `solution-spaces.md`, `evidence/by-architecture-style.md`, `evidence/by-quality-attribute.md`, `discovered-catalog.md`, `aosa-catalog.md`, `realworld-aspnet-catalog.md`, `reference-architectures-catalog.md`.*
