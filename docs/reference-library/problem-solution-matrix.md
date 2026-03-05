# Problem-Solution Mapping Matrix

The analytical core of the reference library: evidence-backed mappings from problem characteristics to architecture styles, grounded in statistical analysis of 122 open-source repositories (Discovered), validated by 17 production systems (AOSA + RealWorld), and enriched with qualitative reasoning from 78 competition teams (KataLog). Total evidence base: 225 entries across 5 sources.

---

## How to Read This Matrix

Mappings are grounded in Discovered corpus statistics (122 repos) as the primary evidence layer. Production systems (AOSA/RealWorld) provide depth validation. Competition evidence (KataLog) provides qualitative reasoning -- the "why" behind the statistical patterns.

**Evidence hierarchy:**

1. **Discovered statistical distributions** -- frequency counts, percentages, and co-occurrence patterns from 122 classified open-source repositories. This answers "what do real codebases actually use?"
2. **Production-validated mappings** -- deep production evidence from AOSA and RealWorld system creators. Small sample (17 systems) but highest individual authority.
3. **Qualitative reasoning: competition evidence** -- KataLog team ADRs, judge commentary, and "show your work" artifacts from 78 submissions. Valued specifically for explaining *why* patterns work -- reasoning unavailable in code analysis.
4. **Reference architecture validation** -- RefArch implementations confirming recommended patterns with working code.

**Confidence levels:**
- **Production-Validated** = Discovered pattern confirmed by AOSA or RealWorld production system (highest)
- **High** = 3+ sources agree, or Discovered + production evidence converges
- **Medium** = 2 sources, or 3+ sources with mixed results
- **Low** = single source or extrapolated

> **Detection bias:** Discovered statistics are derived from automated filesystem analysis. Styles and QAs that leave strong filesystem signals (Docker -> Deployability, module boundaries -> Modularity) are overrepresented. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected.
>
> KataLog competition evidence fills this gap -- teams documented these invisible decisions in ADRs and presentations.

**Limitations:** Correlation is not causation. Style frequency does not prove effectiveness. Each repo may exhibit multiple styles; counts are not mutually exclusive. Competition data covers 78 teams across 11 challenges -- some cells have small sample sizes. Production systems may reflect survivorship bias.

---

## Discovered Domain-Style Matrix (PRIMARY)

Statistical mapping from 122 classified repositories across 35 domains. This is the primary evidence layer: "In domain X, style Y appears in N repos." The "Production Confirmed" column flags where AOSA/RealWorld systems validate the Discovered pattern.

| Domain | Repos | Top Style 1 | Top Style 2 | Top Style 3 | Production Confirmed |
|--------|-------|-------------|-------------|-------------|---------------------|
| **Developer Tools** | 36 | Event-Driven (21, 58%) | DDD (13, 36%) | CQRS (11, 31%) | -- |
| **E-Commerce** | 11 | Event-Driven (6, 55%) | CQRS (4, 36%) | Microservices (4, 36%) | nopCommerce (Plugin+Layered), eShopOnContainers (MS+DDD+CQRS) |
| **Infrastructure** | 7 | Microservices (4, 57%) | Event-Driven (4, 57%) | Pipe-and-Filter (4, 57%) | NGINX (EDA+Pipeline) |
| **AI/ML** | 6 | Event-Driven (5, 83%) | Multi-Agent (4, 67%) | Layered (3, 50%) | -- |
| **Data Grid** | 6 | Space-Based (5, 83%) | Event-Driven (4, 67%) | Modular Monolith (2, 33%) | Riak (P2P, Eventual Consistency) |
| **Workflow Orchestration** | 5 | Event-Driven (5, 100%) | Microservices (4, 80%) | DDD (4, 80%) | -- |
| **Data Processing** | 5 | Microservices (5, 100%) | Event-Driven (5, 100%) | Pipe-and-Filter (4, 80%) | Graphite (Pipeline+SB) |
| **Messaging** | 5 | Event-Driven (4, 80%) | Modular Monolith (2, 40%) | Microservices (2, 40%) | ZeroMQ (Broker-less+Pipeline+Actor) |
| **CMS** | 4 | Modular Monolith (3, 75%) | Layered (2, 50%) | Event-Driven (2, 50%) | Orchard Core (MM+Plugin), Squidex (CQRS+ES) |
| **Social Media** | 4 | Event-Driven (4, 100%) | Layered (3, 75%) | Modular Monolith (2, 50%) | -- |
| **Observability** | 3 | Microservices (2, 67%) | Event-Driven (2, 67%) | Pipe-and-Filter (2, 67%) | Graphite (Pipeline+SB) |
| *25 more domains* | 30 | Varies | Varies | Varies | HDFS, LLVM, GStreamer, Selenium, Puppet, SQLAlchemy, Twisted |

**Key statistical findings:**

1. **Event-Driven is the most cross-domain style**, appearing in the top styles for 9 of the 10 largest domain clusters. It appears in 63 of 122 repos overall (52%).
2. **Developer Tools dominates at 30% of the corpus** (36 of 122 repos), suggesting architecture frameworks and templates are the most common open-source contribution pattern. Within this domain, Event-Driven leads (21 repos), followed by DDD (13) and CQRS (11).
3. **Domain-specific specialization is real.** Space-Based appears in 5 of 6 Data Grid repos (83%) but only 4% of the corpus overall. Multi-Agent appears in 4 of 6 AI/ML repos (67%) but 4% overall. The matrix captures these niche-but-strong signals.
4. **E-Commerce is the most cross-validated domain** with evidence from 4 of 5 sources (Discovered, Production, Competition, RefArch).

---

## Production-Validated Mappings

These mappings have the highest confidence -- Discovered statistical frequency AND production validation from systems built, deployed, and operated under real-world conditions.

| Domain | Discovered Pattern | Production System | Production Style | Convergence |
|--------|-------------------|-------------------|-----------------|-------------|
| **E-Commerce** | DDD(3/11), Event-Driven(6/11), Microservices(4/11) | nopCommerce (RealWorld) | Plugin + Layered | Alternate path validated; 17 years, 60K+ stores |
| **E-Commerce** | DDD(3/11), Event-Driven(6/11), Microservices(4/11) | eShopOnContainers (RefArch) | MS + DDD + CQRS | Aligns with Discovered DDD and MS frequency |
| **CMS / Content** | Modular Monolith(3/4), Layered(2/4) | Orchard Core (RealWorld) | MM + Plugin | Direct match -- MM dominant in Discovered CMS repos |
| **CMS / Content** | Modular Monolith(3/4), Event-Driven(2/4) | Squidex (RealWorld) | CQRS + Event Sourcing | Validates CQRS path for headless CMS |
| **Infrastructure** | Event-Driven(4/7), Pipe-and-Filter(4/7) | NGINX (AOSA) | Event-Driven + Pipeline | Direct match at internet scale (billions req/day) |
| **Data Grid** | Space-Based(5/6), Event-Driven(4/6) | Riak (AOSA) | Peer-to-Peer + Eventual Consistency | Confirms distributed data pattern |
| **Data Processing** | Event-Driven(5/5), Pipe-and-Filter(4/5) | Graphite (AOSA) | Pipeline + Service-Based | Pipe-and-Filter confirmed by production pipeline |
| **Messaging** | Event-Driven(4/5) | ZeroMQ (AOSA) | Broker-less + Pipeline + Actor | Event-Driven confirmed at extreme throughput |
| **Security** | (no Discovered cluster) | Bitwarden (RealWorld) | Service-Based + Event-Driven | SOC2 + GDPR; zero-knowledge encryption |
| **Media / Streaming** | (cross-domain) | GStreamer (AOSA), Jellyfin (RealWorld) | Pipeline + Plugin | Thousands of codecs/devices |
| **Compiler / DevTools** | Event-Driven(21/36), DDD(13/36) | LLVM (AOSA), Git (AOSA) | Pipeline + Plugin | Pipeline underdetected in Discovered (detection bias) |

**Notable gap:** Plugin/Microkernel has zero Discovered entries despite 6 production systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, nopCommerce, Orchard Core). Plugin architectures are defined by runtime extension points, not directory structure -- a known detection blind spot.

Service-Based has only 4 Discovered repos (3%) but 3 production systems (Selenium, Graphite, Bitwarden). This confirms under-detection, not under-use.

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
| **Small** (<1K users) | Modular Monolith: 64 repos (52% of corpus) | Modular Monolith | 3.00 (n=6) | Orchard Core, Squidex (RealWorld) |
| **Medium** (1K-100K) | Service-Based + EDA across multiple domains | Service-Based + EDA | 2.57 (n=7) | Bitwarden (16K+ stars), nopCommerce (60K stores), Jellyfin |
| **Large** (100K-2M) | Event-Driven + Microservices co-occur in 17 repos | Event-Driven + Microservices | 2.20 (n=5) | eShopOnContainers (RefArch), Graphite, Puppet (AOSA) |
| **Very Large** (2M+) | Space-Based(5/6 Data Grid), CQRS(18 repos) | EDA + Space-Based / CQRS | 2.33 (n=3) | Riak (AOSA), Discovered Data Grid repos |
| **Extreme** (internet-scale) | Event-Driven(63 repos), Pipe-and-Filter(19 repos) | No competition data | -- | NGINX (billions req/day), HDFS (petabytes), ZeroMQ (millions msg/sec) |

**Critical insight (competition):** Scale alone does not determine style. MonitorMe has only 500 patients but demands 4,000 events/second. Data intensity, not user count, drove the universal EDA choice. Conversely, Farmacy Food's winner chose Modular Monolith despite potential national scale, prioritizing startup economics. **Match style to current scale, document the evolution path to future scale.**

**Production insight:** At extreme scale, the scaling dimension itself determines the style. NGINX scales request throughput through non-blocking event loops. HDFS scales storage through block replication. ZeroMQ scales message throughput through zero-copy, lock-free structures. Riak scales availability through peer-to-peer eventual consistency. **Match style to the dominant scaling dimension, not a single metric.**

### By Budget Constraint

Discovered corpus context: Modular Monolith appears in 52% of repos, the most prevalent style. This aligns with competition evidence that simpler architectures succeed in budget-constrained environments.

| Budget | Competition Best Style | Competition Avg | Production Validation |
|--------|----------------------|-----------------|----------------------|
| **Startup / Non-Profit** | Modular Monolith (initial) | 3.00 (n=6) | nopCommerce: started as monolith, scaled to 60K stores over 17 years |
| **Startup / Non-Profit** (2nd) | Service-Based + EDA | 2.57 (n=7) | Bitwarden: SB + EDA at startup scale, SOC2 certified |
| **Growth / Scaling** | Event-Driven + Microservices | 2.00 (n=17) | eShopOnContainers, wild-workouts-go (RefArch) |
| **Enterprise** | Per-quantum style selection | varies | NGINX, HDFS, LLVM (AOSA) |

**Competition detail:** ArchColider (1st, Farmacy Food): 3-scenario cost model $12K-$23K/yr. PegasuZ (1st, Spotlight): MM MVP. MonArch (1st, Hey Blue!): $2,780/mo GCP. Pragmatic (1st, ClearView): token cost estimation. Cost analysis is the single strongest predictor of placement in budget-constrained katas.

### By Integration Complexity

Discovered corpus context: Event-Driven appears in 52% of all repos, often serving as the integration backbone. Pipe-and-Filter (16%) appears predominantly in infrastructure and data processing domains with high integration needs.

| Complexity | Competition Best Style | Competition Avg | Production Validation |
|------------|----------------------|-----------------|----------------------|
| **Low** (0-2 systems) | Service-Based or focused pipeline | 2.86 (n=7) | buckpal, clean-architecture-dotnet (RefArch) |
| **Medium** (3-5 systems) | Service-Based + EDA | 2.33 (n=6) | Bitwarden (multi-client sync), Graphite (Carbon+Whisper+web) |
| **High** (6+ systems) | Event-Driven with integration backbone | 2.25 (n=4) | Puppet (dozens of OS/platforms), Selenium (all major browsers) |
| **Very High** (8+ systems) | Plugin + Event-Driven | 2.00 (n=2) | LLVM (dozens of frontends+backends), GStreamer (thousands of codecs) |
| **Ecosystem** (100+) | Plugin + Pipeline | -- | LLVM, GStreamer, SQLAlchemy (AOSA) |

**Production validation:** LLVM's three-phase pipeline with stable IR enables dozens of frontends and backends to interoperate. GStreamer's capability negotiation enables thousands of plugins to self-discover compatibility. SQLAlchemy's dialect system integrates with PostgreSQL, MySQL, SQLite, Oracle through pluggable backends. All five production systems validate that **stable intermediate abstractions** are the key to scaling integration complexity.

### By Real-Time Requirements

Discovered corpus context: Event-Driven (52% of repos) is the dominant pattern for systems with any real-time component. CQRS (15%) and Space-Based (4%) appear in repos requiring read/write separation or in-memory processing.

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

**AI/ML** -- Discovered context: In 6 AI/ML repos, Multi-Agent(4) and Modular Monolith(4) are the dominant styles, suggesting the open-source community explores both agent-based and modular approaches.

| AI Role | Discovered Signal | Competition Best Style | Competition Avg |
|---------|------------------|----------------------|-----------------|
| **None** | Per other dimensions | Per other dimensions | varies |
| **Supporting** | -- | MS with edge AI module | 2.25 (n=4) |
| **Central** (AI is the product) | Multi-Agent(4/6), MM(4/6) in AI/ML repos | SB + EDA + human-in-loop | 3.00 (n=7) |
| **Multi-Agent** | 4 multi-agent repos in AI/ML domain | Multi-Agent + Supervisor | 4.00 (n=1) |

**Winner pattern (competition):** Top teams constrained AI rather than giving it free rein -- deterministic boundaries (Pragmatic), confidence-based escalation (all Certifiable Inc. teams), multi-model cost optimization (ConnectedAI's dual-LLM strategy), and formal evaluation frameworks (ConnectedAI's Ragas, ZAITects' Langwatch).

---

## Compound Problem Mappings

For common multi-dimensional problem profiles, these are the recommended approaches. Each mapping leads with Discovered corpus evidence for the relevant domain, then cites production validation and competition reasoning.

| Problem Profile | Discovered Signal | Production Validation | Competition Reasoning | Confidence |
|----------------|-------------------|----------------------|----------------------|------------|
| **Budget-constrained non-profit, medium scale** | Modular Monolith: 52% of corpus; SB+EDA across multiple domains | nopCommerce (17yr MM), Bitwarden (SB+EDA) | Spotlight, Hey Blue!, ClearView: 5 first-place teams used SB+EDA or MM with evolution path | **High** |
| **Healthcare with real-time + on-prem** | Event-Driven: 52% of corpus; dominant for real-time patterns | NGINX (microsecond EDA), ZeroMQ (zero-copy) | MonitorMe: 7 teams, unanimous EDA convergence; BluzBrothers 693ms proof | **High** |
| **Greenfield startup with high integration** | MM(52%) + Event-Driven(52%) co-occur in 38 repos | nopCommerce validates 17-year MM longevity | Farmacy Food: ArchColider (1st) won with MM + 3-scenario cost model | **Production-Validated** |
| **AI-centric with accuracy requirements** | Multi-Agent(4/6), MM(4/6) in AI/ML repos | -- | 4 first-place teams across 3 AI challenges used SB+EDA+human-in-loop | **High** |
| **Travel / consumer at extreme scale** | Event-Driven(63 repos), Space-Based(5/6 Data Grid) | NGINX validates EDA at internet scale | Road Warrior: Profitero (1st) used EDA+Kafka; Iconites (2nd) added Space-Based | **Production-Validated** |
| **IoT with edge/offline constraints** | MS(26 repos) + EDA(63 repos) co-occurrence | HDFS (edge+central), Jellyfin (self-hosted) | Wildlife Watcher: CELUS Ceals (1st) used MS with C4 | **Production-Validated** |
| **Legacy monolith migration** | MM(64 repos) as dominant starting architecture | -- | Sysops Squad: SB (not MS); transition architecture > target architecture | **High** |
| **Plugin ecosystem for extensibility** | Plugin: 0 Discovered (detection blind spot) | LLVM, GStreamer, SQLAlchemy, nopCommerce, Orchard Core (5 systems) | Rarely considered in competition | **Production-Validated** |
| **Event-driven for high throughput** | Event-Driven: 63 repos (52% of corpus) | NGINX, ZeroMQ, Twisted (3 AOSA systems) | MonitorMe, Road Warrior winners used EDA | **Production-Validated** |
| **Pipeline for data transformation** | Pipe-and-Filter: 19 repos (16%); dominant in Data Processing and Infrastructure | LLVM, GStreamer, Graphite (3 AOSA systems) | Absent from competition (framing bias) | **Production-Validated** |
| **Multi-tenant SaaS** | CMS repos: MM(3/4), Layered(2/4) | Orchard Core (MM+Plugin), Squidex (CQRS+ES) | -- | **Production-Validated** |
| **Security-critical with zero-knowledge** | -- | Bitwarden (SB+EDA, SOC2+GDPR) | ClearView: Pragmatic (1st) designed deterministic boundaries | **Production-Validated** |
| **Distributed database with extreme availability** | Space-Based: 5/6 Data Grid repos | Riak (P2P + Eventual Consistency) | -- | **Production-Validated** |

---

## QA-to-Style Mappings

Quality attribute-to-style correlations grounded in Discovered detection data, validated by production evidence, and enriched with competition reasoning.

### Discovered QA Detection (122 repos)

| Quality Attribute | Repos | % of Corpus | Detection Bias Notes |
|-------------------|-------|-------------|---------------------|
| Deployability | 108 | 89% | Inflated by Docker/CI signal prevalence |
| Modularity | 41 | 34% | |
| Scalability | 33 | 27% | |
| Fault Tolerance | 18 | 15% | |
| Observability | 4 | 3% | Underdetected -- hard to infer from filesystem |
| Evolvability | 2 | 2% | Underdetected -- hard to infer from filesystem |

### QA-to-Style Matrix (all sources)

| Quality Attribute | Discovered Correlation | Production Validation | Competition Best Style (Avg) | Competition Worst Style |
|-------------------|----------------------|----------------------|------------------------------|------------------------|
| **Scalability** | Deployability(89%) signals scalability infrastructure; Space-Based(5/6) in Data Grid | NGINX (internet-scale EDA), HDFS (petabyte replication), Riak (extreme availability) | Modular Monolith (3.00, n=3) | Serverless (1.50, n=6) |
| **Availability** | Fault Tolerance detected in 18 repos (15%) | Riak (P2P eventual consistency), HDFS (block replication) | Modular Monolith (3.67, n=3) | Service-Based (1.50, n=14) |
| **Performance** | Pipe-and-Filter(19 repos) in throughput-critical domains | NGINX (microsecond events), ZeroMQ (zero-copy), Git (content-addressable O(1)) | Modular Monolith (3.33, n=3) | Serverless (1.67, n=6) |
| **Security** | (underdetected in Discovered) | Bitwarden (zero-knowledge, SOC2) | Modular Monolith (3.25, n=4) | Microservices (1.52, n=21) |
| **Extensibility** | (plugin patterns underdetected) | LLVM, GStreamer (Plugin+Pipeline), Jellyfin, nopCommerce (Plugin) -- 5 systems | Modular Monolith (4.00, n=2) | Service-Based (1.40, n=10) |
| **Evolvability** | Detected in only 2 repos (2%) | nopCommerce (17 years on Plugin+Layered); modular-monolith-with-ddd (RefArch) | Modular Monolith (4.00, n=2) | Service-Based (1.40, n=10) |
| **Cost / Feasibility** | MM(52%) is cheapest to operate (single deployment unit) | Jellyfin (self-hosted = zero cloud cost), Orchard Core (MM minimizes infra) | Modular Monolith (3.00, n=5) | Microservices (1.81, n=16) |
| **Data Integrity** | CQRS(15%) provides audit trail patterns | Squidex (CQRS+ES full audit), HDFS (checksummed replication) | Service-Based (2.50, n=4) | -- |
| **Interoperability** | (underdetected in Discovered) | LLVM (stable IR bridges languages/hardware), GStreamer (capability negotiation) | Event-Driven (2.33, n=12) | Microservices (1.67, n=6) |

**The Modular Monolith paradox:** MM shows the highest competition placement score across almost every QA. This is partly a selection effect -- the 6 teams that chose MM were disproportionately thoughtful architects making a contrarian, well-reasoned choice.

The Discovered corpus independently validates this: Modular Monolith appears in 52% of all repos, the most prevalent style alongside Event-Driven. Production evidence confirms it too: nopCommerce (17 years, 60K stores) and Orchard Core have outlasted many microservices-first competitors.

**The Microservices trap:** 39 competition teams (50% of submissions) chose MS, making it the most popular style. Yet it ranks below SB and MM in per-team effectiveness for every QA. The Discovered corpus shows MS in 21% of repos -- common but not dominant.

The differentiator: MS teams that paired with EDA, DDD, or evolutionary approaches performed markedly better than MS-only. MS-only averaged 1.70 points; MS+EDA averaged 2.00+.

**Production QA insights not visible in competition or Discovered data:**
- **Fault tolerance**: HDFS (block replication), Riak (peer-to-peer), NGINX (worker isolation) -- structural property, not just redundancy
- **Zero-copy performance**: ZeroMQ demonstrates performance at extreme scale requires eliminating data copying at the architecture level
- **Backward compatibility**: LLVM's stable IR and GStreamer's capability negotiation show extensibility at scale requires stable intermediate abstractions
- **Multi-tenancy**: Orchard Core (plugin-based feature isolation) and Squidex (CQRS-based data isolation) demonstrate two production-validated approaches

---

## Style Combination Performance

Which style combinations succeed, grounded in Discovered co-occurrence data and validated by production and competition evidence.

### Discovered Co-occurrence Patterns (122 repos)

The strongest co-occurrence in the corpus: **Modular Monolith + Event-Driven appear together in 38 repos** (31% of the entire corpus). This suggests these are complementary rather than competing styles. Event-Driven communication within a Modular Monolith host is the single most common architectural configuration.

Other significant co-occurrences: Layered + Modular Monolith (18 repos), Event-Driven + DDD (cross-domain), Event-Driven + CQRS (15 repos in Developer Tools and E-Commerce).

### Combination Performance (all sources)

| Combination | Discovered Co-occurrence | Competition Teams / Avg | Production Validation |
|-------------|------------------------|------------------------|----------------------|
| **Modular Monolith + Event-Driven** | 38 repos (31% of corpus) | 6 / 3.00 (3 first-place wins) | Orchard Core (RealWorld) |
| **Event-Driven + Service-Based** | Across multiple domains | 7 / 2.57 (3 first-place wins) | Bitwarden, Graphite |
| **Event-Driven + Pipeline** | Infrastructure + Data Processing domains | No competition data | NGINX, GStreamer (AOSA) |
| **Plugin + Pipeline** | (underdetected -- 0 Discovered) | No competition data | LLVM, GStreamer (AOSA) |
| **Plugin + Layered** | (underdetected -- 0 Discovered) | No competition data | SQLAlchemy, nopCommerce |
| **CQRS + Event Sourcing** | E-Commerce + Developer Tools domains | ArchColider (1st): 4.00 | Squidex, eShopOnContainers |
| **Modular Monolith + Plugin** | (underdetected -- 0 Discovered) | No competition data | Orchard Core, Jellyfin |
| **Event-Driven + Microservices** | 17 repos across domains | 17 / 1.29 (0 first-place from combo alone) | eShopOnContainers, eShop (RefArch) |
| **3+ complementary styles** | Common in larger repos | 11 / 2.36 (4 first-place wins) | LLVM, GStreamer, wild-workouts-go |

**The combination rule:** Event-Driven + Service-Based (avg 2.57) outperforms Event-Driven + Microservices (avg 1.29) by 2x on per-team placement. The Discovered corpus confirms this independently: MM+EDA co-occurrence (38 repos) is far more common than MS+EDA co-occurrence. The open-source community converges on simpler host architectures with event-driven communication.

**Production insight:** Plugin + Pipeline (LLVM, GStreamer) and Event-Driven + Pipeline (NGINX, GStreamer) are among the most successful production combinations. Neither appears in competition submissions, and both are underdetected in Discovered repos. This reflects two biases: competition framing bias (enterprise over infrastructure) and detection bias (plugin/pipeline patterns are structurally subtle).

---

## Cross-Source Analysis: Where Sources Agree and Disagree

### Strong Convergences (highest-confidence recommendations)

**Event-Driven for high-throughput systems:** All 5 sources agree. Discovered: 63 of 122 repos (52%). AOSA: NGINX, ZeroMQ, Twisted. RealWorld: Bitwarden. RefArch: eShopOnContainers. Competition: 7 of 7 MonitorMe teams and 8 of 9 Road Warrior teams chose EDA. This is the single highest-confidence recommendation in the matrix.

**Modular Monolith for startups and budget-constrained environments:** 4 sources agree. Discovered: 64 of 122 repos (52%). RealWorld: nopCommerce (17 years), Orchard Core. RefArch: modular-monolith-with-ddd. Competition: all 6 MM teams averaged 3.00 placement score. The "start simple" advice is production-proven.

**Plugin architecture for extensibility:** 4 sources agree. AOSA: LLVM, GStreamer, SQLAlchemy. RealWorld: Jellyfin, nopCommerce, Orchard Core. Competition: Wildlife Watcher (Wonderous Toys 3rd). RefArch: eShopOnContainers. The production evidence is overwhelming: when extensibility is primary, plugin outperforms microservices decomposition.

Detection note: zero Discovered repos detect plugin architecture due to a known blind spot -- plugin patterns are defined by runtime extension points, not directory structure.

### Instructive Divergences

**Pipeline architecture:** Strong in production (LLVM, GStreamer, Graphite, NGINX), 19 Discovered repos (16% -- mostly Infrastructure and Data Processing), but absent from competition. Competition framing biases toward enterprise systems where pipeline is less common.

**Microservices performance gap:** Competition is strongly cautionary -- MS+EDA averages only 1.29 placement points. Discovered shows MS in 26 repos (21%), common but not dominant. RefArch repos (eShopOnContainers, wild-workouts-go) assume proven domain boundaries and operational maturity. Competition teams typically lack both.

**Space-Based architecture:** Discovered: 5 of 6 Data Grid repos (83%). Competition: Road Warrior Iconites (2nd place). No AOSA/RealWorld system uses it. Niche but strongly validated where applicable.

---

## Decision Flowchart: Choosing Your Style

**Step 1: Check your AI role.** In the Discovered corpus, AI/ML repos show Multi-Agent (4 of 6) and Modular Monolith (4 of 6). Competition evidence: 4 first-place teams across 3 AI challenges used SB+EDA+human-in-the-loop. If AI is central, start there.

**Step 2: Check your scale and budget.** Discovered evidence: Modular Monolith(52%) and Event-Driven(52%) are the dominant patterns. For startups: MM with documented evolution path (validated by nopCommerce, 17 years). For medium scale: SB+EDA (validated by Bitwarden). For large scale with proven boundaries: MS+EDA. For extreme scale: EDA+Pipeline (validated by NGINX, ZeroMQ).

**Step 3: Check your real-time needs.** If critical: Event-Driven with fitness-function-proven timing (NGINX validates microsecond processing). If high: EDA+MS with quantitative validation. If none: style driven by other dimensions.

**Step 4: Check your integration complexity.** If ecosystem (100+): Plugin+Pipeline with stable intermediate abstractions (LLVM, GStreamer validate). If high (6+): event-driven integration backbone with adapter pattern (Puppet, Selenium validate). If low: Hexagonal architecture isolates integration at port boundaries.

**Step 5: Check your compliance load.** If high (HIPAA, SOC2): consider zero-knowledge architecture (Bitwarden), crypto-shredding, dedicated compliance boundaries. If medium (PCI, GDPR): isolate sensitive data into dedicated services.

**Step 6: Document the evolution path.** Tie evolution triggers to business milestones, not arbitrary timelines. In the Discovered corpus, MM+EDA co-occurrence (38 repos) suggests this is the most common evolutionary configuration. 73% of first-place competition winners proposed multi-style or phased architectures. Production evidence confirms longevity: nopCommerce evolved over 17 years, and LLVM grew from 1 frontend to dozens through stable plugin APIs.

**Step 7: Validate against production evidence.** Check if a production system in this matrix operates in a similar domain with a similar style. Production-validated > cross-source agreement > competition-only > single-source.

**Common mistakes to avoid** (all 5 sources):
1. **Choosing microservices by default:** Discovered shows MM(52%) and EDA(52%) are more prevalent. Competition shows MS underperforms. Production shows the most successful systems use EDA, pipeline, or plugin architectures.
2. **Ignoring the plugin pattern:** 5 production systems use plugin architectures, but 0 Discovered repos detect them (blind spot). Consider plugin when extensibility is primary.
3. **Underestimating pipeline architecture:** 19 Discovered repos (16%) use pipeline patterns, and 4 AOSA production systems validate them. It is the most underused pattern relative to its production success.
4. **Over-engineering for scale that does not exist yet:** Discovered MM prevalence (52%) and nopCommerce longevity both show simpler architectures serve longer than expected.
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

*Generated: 2026-03-05. Evidence sources: 122 Discovered open-source repositories across 35 domains (primary evidence layer), 12 AOSA production systems (NGINX, HDFS, Git, LLVM, GStreamer, Graphite, ZeroMQ, Twisted, SQLAlchemy, Riak, Puppet, Selenium), 5 RealWorldASPNET production apps (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex), 8 reference architecture implementations, and 78 O'Reilly Architecture Kata submissions across 11 challenges (Fall 2020 -- Winter 2025). Source data: `problem-spaces.md`, `solution-spaces.md`, `evidence/by-architecture-style.md`, `evidence/by-quality-attribute.md`, `discovered-catalog.md`, `aosa-catalog.md`, `realworld-aspnet-catalog.md`, `reference-architectures-catalog.md`.*
