# Solution Space Taxonomy

A cross-source, evidence-based catalog of architectural approaches ranked by frequency in 122 production codebases (Discovered), validated by 17 production systems (AOSA + RealWorld), and enriched with qualitative reasoning from 78 competition teams (KataLog). Total evidence base: 225 entries across 5 sources.

> **Cross-references.** For the raw evidence tables and weighting methodology, see [Cross-Source Evidence Reference](evidence/cross-source-reference.md). For the analytical framework, gap analysis, and lifecycle-stage mapping, see [Cross-Source Analysis](evidence/cross-source-analysis.md). For per-style KataLog breakdowns, see [Evidence by Architecture Style](evidence/by-architecture-style.md). For the problem-domain perspective (which challenges favor which styles), see [Problem Spaces](problem-spaces.md).

---

## How to Use This Document

This document maps the **solution space** of software architecture: which architectural styles appear in real codebases, production systems, competition designs, and reference implementations.

**Evidence hierarchy (Discovered-first):**

1. **Discovered Frequency Scoreboard** (PRIMARY). Statistical ranking by frequency in 122 open-source repositories classified through automated signal detection with multi-turn LLM validation. This answers "what do real codebases actually use?" and is the primary ranking because it represents the largest, most diverse evidence sample.

2. **Production Evidence Highlights**. Deep narratives from 12 AOSA production systems and 5 RealWorldASPNET applications. Small sample (17 systems) but highest individual authority -- these are systems built, deployed, and operated under real-world conditions by their creators.

3. **Qualitative Evidence: Competition Insights** (KataLog). Valued specifically for judge commentary, team ADR reasoning, and "show your work" artifacts from 78 O'Reilly Architecture Kata submissions. Competition teams explain *why* patterns work -- reasoning that is unavailable in code analysis. Subject to competition bias: teams optimize for judges, not production.

4. **Alternative Ranking: Production-Weighted Score**. The Combined Weighted Scoreboard (production systems at 20 pts each) is preserved as an alternative weighting methodology for readers who want to weight curated production evidence most heavily.

**Reading each style profile:**
- **Statistical basis** opens every profile: "In 122 codebases, [Style] appears in N% of repos, co-occurring with [X] in M repos."
- **Production evidence** (AOSA + RealWorld) provides depth validation from systems with published architectural reasoning.
- **Why this works** presents KataLog team reasoning, judge feedback, and ADR excerpts that explain the qualitative reasoning behind statistical patterns.
- **Reference implementations** (RefArch) confirm recommended patterns with working code.
- **Quality attributes** are drawn from all sources, with Discovered detection data and production-observed attributes taking precedence.

> **Detection bias:** Discovered statistics are derived from automated filesystem analysis. Styles and QAs that leave strong filesystem signals (Docker -> Deployability, module boundaries -> Modularity) are overrepresented. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this gap -- teams documented these invisible decisions in ADRs and presentations.

**Limitations:**
- Discovered classification is automated; quality varies (production systems mixed with tutorials and samples). Pruning removed 51 unclassifiable entries (libraries, frameworks, SDKs) from the original 173.
- Correlation is not causation. Style frequency does not prove effectiveness.
- Each repo and KataLog team may exhibit multiple styles; counts are not mutually exclusive.
- The KataLog dataset is 78 teams across 11 challenges. Some styles have very small sample sizes (n < 5).
- AOSA projects date from 2011-2012; technology specifics may be dated even though architectural patterns remain valid.
- RealWorldASPNET is .NET-only (5 entries). Discovered repos span 9+ languages.
- Production evidence covers 17 systems. Absence from production sources does not prove a style is unsuitable for production -- it means the evidence base hasn't captured it yet.

---

## Discovered Frequency Scoreboard (PRIMARY RANKING)

Styles ranked by frequency in 122 real codebases. This is the primary ranking because it represents the largest, most structurally diverse evidence sample -- how architects actually build software in practice.

| Rank | Style | Discovered Repos | % of Corpus | Top Co-occurring Style | Production Systems |
|------|-------|-----------------|-------------|----------------------|-------------------|
| 1 | **Modular Monolith** | 64 | 52% | Event-Driven (38 repos) | Orchard Core |
| 2 | **Event-Driven** | 63 | 52% | Modular Monolith (38 repos) | NGINX, Twisted, ZeroMQ, Squidex, Bitwarden |
| 3 | **Layered** | 29 | 24% | Modular Monolith (18 repos) | nopCommerce |
| 4 | **Domain-Driven Design** | 27 | 22% | Event-Driven | (none in evidence base) |
| 5 | **Microservices** | 26 | 21% | Event-Driven | (none in evidence base) |
| 6 | **Pipe-and-Filter** | 19 | 16% | Event-Driven | NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin |
| 7 | **CQRS/Event Sourcing** | 18 | 15% | Event-Driven | Squidex |
| 8 | **Hexagonal/Clean** | 16 | 13% | Event-Driven | (none in evidence base) |
| 9 | **Serverless** | 6 | 5% | Event-Driven | (none in evidence base) |
| 10 | **Multi-Agent** | 5 | 4% | Event-Driven | (none in evidence base) |
| 11 | **Space-Based** | 5 | 4% | Event-Driven | Riak |
| 12 | **Service-Based** | 4 | 3% | Event-Driven | Selenium, Graphite, Bitwarden |
| — | **Plugin/Microkernel** | 0 | 0% | — | LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce |

**Key statistical findings:**

1. **Modular Monolith and Event-Driven are equally prevalent (52% each) and co-occur in 38 repos.** These are the dominant patterns in real codebases. Their co-occurrence (31% of the entire corpus) suggests they are complementary rather than competing -- Event-Driven communication within a Modular Monolith host is the single most common architectural configuration.

2. **Layered, DDD, and Microservices form a second tier (21-24%).** These appear in roughly one-fifth to one-quarter of repos. Layered + Modular Monolith co-occur in 18 repos, suggesting layered internal structure within modular boundaries.

3. **Plugin/Microkernel has zero Discovered entries despite being production-dominant.** Plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container orchestration. This is a known blind spot in signal-based detection. The 6 production systems (LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce) confirm the pattern is heavily used but structurally undetectable.

4. **Service-Based has thin code presence (4 repos, 3%).** Service-based architecture is harder to detect from structural signals than microservices (fewer Docker Compose services) or event-driven (no message broker config). Yet it has 3 production systems (Selenium, Graphite, Bitwarden), confirming it is under-detected, not under-used.

5. **Microservices shows moderate code presence but zero production evidence.** 26 Discovered repos (21%) vs. 0 production systems. Pruning removed many microservices tutorials and sample apps from the original 54, but the design-production gap remains stark.

---

## Production Evidence Highlights

These production systems confirm the patterns seen at scale in the Discovered corpus. Each system below has been built, deployed, and operated under real-world conditions, with architectural reasoning published by the system's creators.

### AOSA Production Systems (12 projects, 2011-2012)

| System | Primary Styles | Scale | Key Architectural Insight |
|--------|---------------|-------|--------------------------|
| **NGINX** | Event-Driven, Pipeline | 30% of internet traffic | Event-driven reactor with non-blocking I/O; HTTP request processing as a pipeline of filter modules |
| **LLVM** | Pipeline, Plugin | Hundreds of language frontends | Compilation as multi-stage pipeline; every optimization is a plugin/pass |
| **Twisted** | Event-Driven | Python networking framework | Reactor pattern for event-driven networking |
| **ZeroMQ** | Event-Driven, Pipeline | Financial trading (microsecond latency) | Broker-less messaging with actor model; push/pull pipeline topology |
| **Graphite** | Pipeline, Service-Based | Metrics at scale | Three independent pipeline stages (Carbon, Whisper, web) as separate services |
| **GStreamer** | Pipeline, Plugin | Multimedia framework | 250+ plugins for codecs/filters/demuxers; media processing as directed graph pipeline |
| **SQLAlchemy** | Plugin | Python ORM standard | Dialect plugins for database backends; layered plugin architecture |
| **Riak** | Space-Based | Distributed key-value store | Consistent hashing (Dynamo model), masterless cluster, tunable consistency |
| **Selenium** | Service-Based | Browser automation standard | Per-browser driver services coordinated by WebDriver protocol |

*(Plus 3 additional AOSA systems: HDFS, Erlang, Berkeley DB -- providing infrastructure/storage evidence)*

### RealWorldASPNET Production Systems (5 projects)

| System | Primary Styles | GitHub Stars | Key Architectural Insight |
|--------|---------------|-------------|--------------------------|
| **Squidex** | Event-Driven, CQRS/ES | ~2,300 | Every content change as an immutable event; MongoDB event store with projected read models |
| **Bitwarden** | Service-Based, Event-Driven | ~16,000 | 9 services with shared database; explicitly chose service-based over microservices to avoid operational overhead |
| **Jellyfin** | Pipeline, Plugin | ~38,000 | Media transcoding pipeline + plugin system for metadata, auth, notifications |
| **Orchard Core** | Modular Monolith, Plugin | ~7,500 | CMS/application framework where modules (blog, commerce, forms) are independently toggleable plugins |
| **nopCommerce** | Layered, Plugin | ~9,500 | Four-layer e-commerce with 17-year track record; plugin system for payments, shipping, taxes |

### Production Style Combinations

These combinations are validated at production scale:

| Combination | Systems | Why It Works |
|-------------|---------|-------------|
| **Pipeline + Plugin** | LLVM, GStreamer, Jellyfin | Pipeline provides processing flow; plugins provide independently replaceable stages |
| **Plugin + Layered** | nopCommerce | Layered internal structure with plugin extensibility for third-party integrations |
| **Plugin + Modular Monolith** | Orchard Core | Monolith host with module/plugin architecture for feature composition |
| **Event-Driven + Service-Based** | Bitwarden | AMQP events for cross-service coordination within service-based decomposition |
| **Pipeline + Service-Based** | Graphite | Three independent pipeline stages deployable as separate services |
| **Event-Driven + Pipeline** | NGINX | Event loop dispatches requests into the filter pipeline |

### Production Evidence Share

Percentage of each style's production-weighted combined score from production sources (AOSA + RealWorldASPNET):

| Style | Production % | Production Sources |
|-------|-------------|-------------------|
| Pipeline | **100%** | NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin |
| Layered | **100%** | nopCommerce |
| Plugin/Microkernel | **97%** | LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce |
| Space-Based | **83%** | Riak |
| CQRS/Event Sourcing | **61%** | Squidex |
| Service-Based | **57%** | Selenium, Graphite, Bitwarden |
| Modular Monolith | **50%** | Orchard Core |
| Event-Driven | **49%** | NGINX, Twisted, ZeroMQ, Squidex, Bitwarden |
| Microservices | 0% | (no production evidence) |
| DDD | 0% | (no production evidence) |
| Hexagonal/Clean | 0% | (no production evidence) |
| Serverless | 0% | (no production evidence) |
| Multi-Agent | 0% | (no production evidence) |

**Remaining gaps:** Five styles have zero production evidence: Microservices, DDD, Hexagonal/Clean, Serverless, and Multi-Agent. Discovered evidence shows all five have active open-source implementations (26, 27, 16, 6, and 5 repos respectively), confirming they are widely *built* but not yet *validated at production scale* within this evidence base.

---

## Qualitative Evidence: Competition Insights

KataLog competition data is valued for a specific purpose: teams explain *why* they chose patterns. This qualitative reasoning -- judge commentary, ADR excerpts, cost projections, trade-off documentation -- is unavailable in code-level analysis. Competition teams optimize for judges and sometimes for trends, so placement data is secondary to the reasoning artifacts they produce.

### KataLog Competition Scoreboard

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

**Key qualitative insight**: Modular Monolith has the highest average placement score (3.00) of any style despite low adoption (6 teams). Every winning team that used it proposed it as an intentional initial phase with a documented evolution path. Event-Driven dominates in absolute terms (9 first-place wins) but its popularity dilutes its average. Pipeline and Layered have zero KataLog representation -- they are invisible to competition data entirely, yet both rank in the top 6 of the Discovered frequency scoreboard.

### Why Competition Evidence Matters (Despite Lower Ranking)

Competition teams provide three types of insight unavailable in code analysis:

1. **Explicit reasoning via ADRs.** Winners average 15+ ADRs documenting architectural decisions, trade-offs, and alternatives considered. Only ~5 of 122 Discovered repos have ADR directories.
2. **Cost and feasibility analysis.** Teams like ArchColider (1st, Farmacy Food) documented 3 growth scenarios with cost projections. TheGlobalVariables (3rd, Spotlight) calculated $0.002/user/month for serverless. This reasoning is invisible in codebases.
3. **Judge feedback on trade-offs.** Expert judges evaluated trade-off thinking, not just pattern selection. Their commentary reveals *why* certain combinations succeed and others fail.

### Competition Style Combination Performance

| Combination | Teams | Weighted Score | Avg Score | Notable Results |
|-------------|-------|----------------|-----------|-----------------|
| **Event-Driven + Service-Based** | 7 | 18 | 2.57 | 3 first-place teams (Pragmatic, ZAITects, Team Seven) |
| **Event-Driven + Microservices** | 17 | 22 | 1.29 | Most common combo, but lowest avg score |
| **CQRS/ES + DDD + Modular Monolith** | 1 | 4 | 4.00 | ArchColider (1st) |
| **Event-Driven + Microservices + Multi-Agent** | 1 | 4 | 4.00 | ConnectedAI (1st) |
| **Event-Driven + Modular Monolith (evolving)** | 1 | 4 | 4.00 | PegasuZ (1st) |

**Key finding**: Event-Driven + Service-Based (avg 2.57) dramatically outperforms Event-Driven + Microservices (avg 1.29). Bitwarden's production architecture confirms this: service-based + events beats microservices + events. Teams explain that service-based avoids the operational overhead of fully independent data stores while retaining independent deployability.

---

## Alternative Ranking: Production-Weighted Score

The Combined Weighted Scoreboard uses a production-weighted methodology where a single production system (20 pts) outweighs an entire Kata competition season (~13 pts). This is an alternative ranking that weights curated production evidence most heavily. See the full methodology in [cross-source-reference.md](evidence/cross-source-reference.md#evidence-weighting-methodology).

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

### Scoring Methodology

Each entry receives points based on evidence quality:

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

**What the production weighting reveals:**

1. **Plugin/Microkernel surges to #2 (was #11 in KataLog-only).** Six production systems across compilers, ORMs, multimedia, media servers, CMS, and e-commerce. 97% production evidence. Only 2 Kata teams ever used this pattern.
2. **Pipeline rises to #3 (invisible in KataLog).** Five AOSA projects plus Jellyfin. 100% production evidence. Zero Kata teams proposed pipeline as a primary style.
3. **Microservices drops to #5 (was #2).** Zero production evidence across all sources. Every point from competition designs and reference templates.
4. **Serverless drops to #12 (was #5).** Zero production evidence. The gap between competition popularity and production adoption is second only to Microservices.
5. **Layered enters at #9 (invisible in KataLog).** nopCommerce's four-layer architecture plus 29 Discovered repos. 100% production evidence in the curated score.

**How this ranking compares to Discovered frequency:** Event-Driven ranks #1 in both systems. The biggest divergence is Plugin/Microkernel (#2 production-weighted, undetectable in Discovered) and Modular Monolith (#1 Discovered, #6 production-weighted). Together, the two rankings provide complementary views: Discovered shows what architects actually build; production-weighted scoring shows what has survived the deepest scrutiny.

---

## Detailed Style Profiles

Each profile opens with its statistical basis from the Discovered corpus, then production evidence, then qualitative reasoning from competition teams.

---

### #1 (Discovered) / #6 (Production-Weighted) -- Modular Monolith

**In 122 codebases, Modular Monolith appears in 64 repos (52%) -- the most commonly adopted architecture style in practice.** It co-occurs with Event-Driven in 38 repos (31% of the entire corpus) and with Layered in 18 repos. This is the default architecture of competently-built software.

**Evidence tier**: T4 (KataLog, RealWorld, RefArch, Discovered) | **Production-weighted score**: 40 pts (50% production)

**Production evidence:**
- **Orchard Core** (RealWorld): CMS/application framework built as a modular monolith with a plugin (module) architecture. Modules provide features (blog, commerce, forms) that can be enabled/disabled at runtime. Demonstrates that modular monolith and plugin architecture are complementary -- the monolith provides the host, modules provide the plugins. ~7,500 GitHub stars.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 6 of 78 teams (7.7%) -- low adoption but highest average placement score (3.00)
- **Placement distribution**: 3 first / 1 second / 1 third / 1 runner-up
- **ArchColider** (1st, Farmacy Food): Modular monolith + event sourcing + DDD, pioneering cost analysis with 3 growth scenarios. The team documented *why* a monolith-first approach reduced initial operational cost while preserving the ability to extract services later.
- **MonArch** (1st, Hey Blue!): Modular monolith as initial phase evolving to microservices, C4 modeling, event storming. Judges rewarded the explicit evolution path.
- **PegasuZ** (1st, Spotlight): Modular monolith MVP with microservices + event-driven long-term target. The evolutionary roadmap -- not just the target architecture -- distinguished this submission.
- **Commonly paired with**: Microservices (3 teams -- as evolution target), Event-Driven (3), Serverless (2), Hexagonal/Clean (1)

**Reference implementations:**
- Modular Monolith with DDD (C#, 1 repository)

**Quality attributes supported**: Cognitive Simplicity, Cost Efficiency, Deployability, Testability, Modifiability
**Quality attributes traded off**: Scalability (initially), Elasticity (initially), Independent Deployability

**Cross-source insight**: Modular Monolith dominates the Discovered corpus (64 repos, 52%) yet ranks only #6 in production-weighted scoring (40 pts). This reveals that well-structured open-source applications overwhelmingly exhibit modular monolith patterns. The KataLog win rate (83.3%, highest of any style) validates its effectiveness. The "start simple, evolve deliberately" approach is the strongest single architectural signal in the competition dataset.

**When to use**: Nearly all greenfield projects should start as a modular monolith. In 122 codebases, it is the most common pattern. Every winning KataLog team that used it proposed it as an intentional initial phase with a documented evolution path. Especially effective when combined with DDD (ArchColider) or plugin architecture (Orchard Core).

**When NOT to use**: Very small KataLog sample (n=6). Notably absent from Road Warrior (2M active users) and MonitorMe (medical device monitoring) -- challenges with strict latency and throughput requirements that may exceed a monolith's initial capacity.

---

### #2 (Discovered) / #1 (Production-Weighted) -- Event-Driven Architecture

**In 122 codebases, Event-Driven appears in 63 repos (52%) -- tied with Modular Monolith as the most prevalent style.** It co-occurs with Modular Monolith in 38 repos. Kafka-based stream processing, RabbitMQ message buses, event sourcing frameworks, and reactive systems dominate the Discovered sample.

**Evidence tier**: T5 (all 5 sources) | **Production-weighted score**: 203 pts (49% production)

**Production evidence:**
- **NGINX** (AOSA Vol. 2): Event-driven reactor pattern with non-blocking I/O. Serves ~30% of internet traffic. The event loop processes thousands of connections per worker process without threading.
- **Twisted** (AOSA Vol. 2): Python event-driven networking framework using the reactor pattern. Underlies numerous Python network applications.
- **ZeroMQ** (AOSA Vol. 2): Broker-less messaging library with actor model (socket-as-actor). Used in financial trading systems with microsecond-level latency requirements.
- **Squidex** (RealWorld): Headless CMS using event sourcing -- every content change stored as an immutable event with MongoDB as event store. ~2,300 GitHub stars.
- **Bitwarden** (RealWorld): Password management server using AMQP for cross-service event coordination alongside service-based decomposition. ~16,000 GitHub stars.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 47 of 78 teams (60.3%) -- the most popular competition style
- **Placement distribution**: 9 first / 6 second / 8 third / 24 runner-up
- **Average placement score**: 2.00
- **BluzBrothers** (1st, MonitorMe): Pure event-driven with Kafka, 20 ADRs, quantitative fitness functions, infrastructure sizing proof. Judges highlighted the fitness function approach as distinguishing this submission.
- **The Archangels** (1st, Farmacy Family): Event-driven with Kafka, 18 ADRs, crypto-shredding, full C4 modeling. The team explained *why* event-driven was critical for HIPAA audit trails.
- **Profitero Data Alchemists** (1st, Road Warrior): Event-driven with Rozanski/Woods viewpoints, 15 ADRs, three scaling groups. Cost analysis showed event-driven reduced infrastructure spend vs. synchronous alternatives.
- **Most successful in**: ShopWise AI Assistant (avg 4.0), Sysops Squad (avg 2.5), Certifiable Inc. (avg 2.5), Hey Blue! (avg 2.2), ClearView (avg 2.2)
- **Commonly paired with**: Microservices (29 teams), Service-Based (10), Serverless (5), Hexagonal/Clean (3), Modular Monolith (3)
- **Key technologies**: Apache Kafka, RabbitMQ, AWS SNS/SQS, Azure Event Hub, GCP Pub/Sub

**Reference implementations:**
- 5 repositories spanning C#, Java, and Go (eShopOnContainers, eShop, Modular Monolith w/DDD, Serverless Microservices, Wild Workouts)

**Quality attributes supported**: Scalability, Fault Tolerance, Availability, Evolvability, Performance, Responsiveness
**Quality attributes traded off**: Simplicity, Cognitive Simplicity, Consistency (eventual consistency trade-off)

**Cross-source insight**: Event-Driven is universally adopted across every evidence tier. In 122 codebases, it appears in 52% of repos. In competition, 60% of teams use it. In production, 5 of 17 systems rely on it. But its *role* shifts across the lifecycle. In competition designs, it is the primary organizing principle. In production (NGINX, Twisted), it solves specific technical problems -- non-blocking I/O, event-loop concurrency, immutable audit trails. Teams proposing "Event-Driven Architecture" should specify which aspect they mean: event-based communication, event sourcing as data model, event-loop concurrency, or integration pattern.

**When to use**: Systems requiring asynchronous decoupling, high throughput, fault tolerance, or temporal decoupling between producers and consumers. Appears in 52% of real codebases -- the most adopted architectural pattern alongside Modular Monolith.

**When NOT to use**: Event-driven appeared at high rates across all KataLog placements (50% of runners-up also use it). It is necessary but not sufficient. Teams that adopted EDA without complementary patterns (event storming, proper ADR documentation, feasibility analysis) did not consistently place well. In the Wildlife Watcher challenge, EDA teams averaged only 1.3 -- suggesting it may be over-applied in IoT/edge contexts where simpler patterns suffice.

---

### #3 (Discovered) / #9 (Production-Weighted) -- Layered Architecture

**In 122 codebases, Layered appears in 29 repos (24%).** It co-occurs with Modular Monolith in 18 repos, suggesting layered internal structure within modular boundaries. Django applications, Spring Boot services, Rails applications, and traditional n-tier codebases dominate this segment.

**Evidence tier**: T2 (RealWorld, Discovered) | **Production-weighted score**: 20 pts (100% production)

**Production evidence:**
- **nopCommerce** (RealWorld): E-commerce platform with a classic four-layer architecture: Presentation (web UI/API) -> Services (business logic) -> Data (persistence) -> Core (domain entities/interfaces). Layers enforce dependency direction -- upper layers depend on lower layers, never the reverse. 17-year production track record, ~9,500 GitHub stars. Also classified as Plugin (plugin system for extensions operates within the layered structure).

**Why this works -- team reasoning (KataLog):**
- **Usage**: 0 of 78 teams. Layered architecture was not proposed as a primary style by any competition team. This likely reflects the perception that layered architecture is "too simple" for a competition context where judges reward architectural sophistication, even though layered architecture demonstrably works in long-lived production systems and appears in 24% of real codebases.

**Reference implementations:** None.

**Quality attributes supported**: Simplicity, Separation of Concerns, Testability (per-layer), Maintainability, Onboarding Speed
**Quality attributes traded off**: Performance (cross-layer overhead), Scalability (monolithic deployment), Flexibility (rigid layer boundaries)

**Cross-source insight**: Layered architecture appears in 24% of Discovered repos and has 100% production evidence share (nopCommerce alone), yet it is invisible in competition data and reference implementations. Combined with Plugin architecture (as in nopCommerce), layered systems can achieve extensibility while maintaining structural clarity. The competition blind spot is significant: a pattern used by nearly a quarter of real codebases receives zero competition attention.

**When to use**: Business applications where separation of concerns, team onboarding speed, and maintainability are primary concerns. Effective as the internal structure within each module of a modular monolith. nopCommerce demonstrates that layered + plugin is a viable long-term production combination.

**When NOT to use**: Systems requiring independent deployment of components, elastic scaling of individual layers, or cross-cutting functionality that does not fit cleanly into a single layer. Not appropriate as the sole architecture for systems with extreme scalability or real-time requirements.

---

### #4 (Discovered) / #10 (Production-Weighted) -- Domain-Driven Design

**In 122 codebases, DDD appears in 27 repos (22%).** This represents the widest gap between code presence and production adoption of any style -- 27 Discovered repos but zero production systems in the evidence base. DDD patterns are widely implemented in open source but unvalidated at production scale within this evidence base.

**Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production-weighted score**: 16 pts (0% production)

**Production evidence:**
None. DDD has zero production evidence across both production sources. However, the 27 Discovered repos confirm widespread code-level adoption.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 4 of 78 teams (5.1%) as explicit architectural approach
- **Placement distribution**: 1 first / 2 second / 0 third / 1 runner-up
- **Average placement score**: 2.75
- **ArchColider** (1st, Farmacy Food): DDD strategic design with core/supportive/generic domain classification, event sourcing. The team's ADRs documented *why* domain modeling investment paid off in reduced coupling between modules.
- **Miyagi's Little Forests** (2nd, Farmacy Food): DDD context map to microservices mapping, hexagonal reference architecture. The context map served as the primary decomposition tool.
- **IPT** (2nd, Hey Blue!): DDD with event storming, domain capability diagrams, GDPR compliance. Event storming revealed privacy boundaries invisible in technical decomposition.
- **Commonly paired with**: Microservices (3), CQRS/Event Sourcing (2), Event-Driven (2), Hexagonal/Clean (1)
- **Key technologies**: Event Storming (process), bounded contexts, context maps, strategic domain design

**Note**: While only 4 teams explicitly list DDD as an architecture style, many more use DDD tactical patterns (event storming, bounded contexts, domain decomposition). Event storming is a common practice among KataLog winners.

**Reference implementations:**
- 3 repositories (eShopOnContainers, Modular Monolith w/DDD, Wild Workouts -- C#, Java, Go)

**Quality attributes supported**: Extensibility, Modifiability, Domain Alignment, Cognitive Clarity
**Quality attributes traded off**: Time-to-market (upfront analysis cost), Simplicity (for simple domains)

**When to use**: Complex business domains with rich domain logic, especially greenfield projects. Appears in 22% of real codebases. KataLog teams that used DDD placed competitively (avg 2.75). No DDD team placed poorly.

**When NOT to use**: DDD is under-reported in both Discovered (automated detection struggles with strategic design patterns) and KataLog (many teams use DDD concepts without listing it). The upfront analysis cost is significant. Avoid for simple CRUD domains or systems where the primary complexity is technical rather than domain-based.

---

### #5 (Discovered) / #5 (Production-Weighted) -- Microservices

**In 122 codebases, Microservices appears in 26 repos (21%).** Down from 54 before pruning tutorials and sample apps, confirming that much of the "microservices" presence in open source is educational rather than production-grade. Zero production evidence across all 17 production systems in the evidence base.

**Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production-weighted score**: 76 pts (0% production)

**Production evidence:**
None. Microservices has zero production evidence across both production sources. This is the sharpest signal that competition popularity does not equal production adoption. Systems that could use microservices (Bitwarden with 9 services) explicitly choose simpler decomposition (Service-Based) because the operational overhead of full microservice independence is not justified.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 39 of 78 teams (50.0%) -- the second-most popular competition style
- **Placement distribution**: 4 first / 6 second / 4 third / 25 runner-up
- **Average placement score**: 1.72
- **CELUS Ceals** (1st, Wildlife Watcher): Microservices with iterative delivery, 15 ADRs, extensive C4 modeling, thorough 3rd-party integration analysis. The team explained *why* independent deployability was critical for wildlife monitoring stations with varying connectivity.
- **MonArch** (1st, Hey Blue!): Microservices with hexagonal architecture per service, modular monolith initial phase, C4 modeling, event storming. The modular-monolith-first strategy distinguished this from other microservices submissions.
- **The Marmots** (2nd, Spotlight): Pure microservices with 19 ADRs, layered separation, market sizing analysis.
- **Most successful in**: ShopWise AI (avg 4.0), Hey Blue! (avg 2.2), Wildlife Watcher (avg 2.2), Spotlight (avg 2.0)
- **Commonly paired with**: Event-Driven (29 teams), Hexagonal/Clean (3), Modular Monolith (3), Service-Based (3), Serverless (3)
- **Key technologies**: Kubernetes, Docker, AWS EKS/ECS, API Gateway, REST APIs, GraphQL

**Critical finding from competition teams**: Microservices-only teams (no EDA) averaged 1.70 KataLog points. EDA-only teams (no Microservices) averaged 2.44 points. Runners-up cite microservices at 55% -- the same rate as second-place teams. Competition analysis identifies microservices as "popular but not predictive."

**Reference implementations:**
- 5 repositories (eShopOnContainers, eShop, Wild Workouts, Serverless Microservices, AKS Baseline). Highest count of any style in RefArch -- Microservices dominates teaching materials.

**Quality attributes supported**: Scalability, Elasticity, Deployability, Evolvability, Fault Isolation
**Quality attributes traded off**: Simplicity, Cost, Cognitive Load, Data Consistency, Operational Complexity

**Cross-source insight**: Microservices has the largest design-production gap in the evidence base. In 122 codebases, 21% exhibit microservices patterns -- but many are educational. In competition, 50% of teams use it. In production, zero of 17 systems rely on it. The gap exists because: (1) AOSA projects predate the microservices naming convention; (2) production teams that could adopt microservices choose simpler decomposition (Bitwarden: Service-Based); (3) the operational overhead filter removes microservices where the benefit of independent deployability does not justify the cost.

**When to use**: Systems where independent team deployability is a genuine organizational requirement (Conway's Law alignment), where individual services need independent scaling, and where the organization has platform engineering capacity for the operational overhead.

**When NOT to use**: Pure synchronous microservices (without EDA) create tight coupling through REST chains. KataLog evidence shows Microservices without EDA averages 1.70 pts. Avoid defaulting to microservices for "scalability" -- production systems achieve scalability through specific mechanisms (NGINX event loops, Riak consistent hashing) rather than through architecture style selection.

---

### #6 (Discovered) / #3 (Production-Weighted) -- Pipeline / Pipe-and-Filter

**In 122 codebases, Pipe-and-Filter appears in 19 repos (16%).** Data processing pipelines, ETL systems, and stream processors. Code-level and production-level evidence converge for this style -- 6 production systems confirm the Discovered pattern.

**Evidence tier**: T3 (AOSA, RealWorld, Discovered) | **Production-weighted score**: 120 pts (100% production)

**Production evidence:**
- **NGINX** (AOSA Vol. 2): HTTP request processing as a pipeline of filter modules (gzip, SSL, rewrite, proxy pass). Each module processes the request/response and passes it to the next stage. The pipeline architecture enables NGINX's extraordinary throughput.
- **LLVM** (AOSA Vol. 1): Compilation as a multi-stage pipeline: frontend (parsing) -> IR generation -> optimization passes -> backend (code generation). Each stage transforms the representation, and passes can be composed, reordered, or omitted.
- **ZeroMQ** (AOSA Vol. 2): Message processing pipelines with push/pull socket patterns for fan-out/fan-in workload distribution.
- **Graphite** (AOSA Vol. 1): Metrics pipeline: Carbon (ingestion) -> Whisper (storage) -> Graphite-web (rendering). Three independent components connected by well-defined data contracts.
- **GStreamer** (AOSA Vol. 2): Media processing pipeline where elements (sources, filters, sinks) are connected into directed graphs. 250+ plugins in the base distribution.
- **Jellyfin** (RealWorld): Media transcoding pipeline for real-time video/audio conversion. Decode -> filter -> encode stages. ~38,000 GitHub stars.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 0 of 78 teams. Pipeline was not proposed as a primary style by any competition team across 11 challenges and 9 seasons. This is the sharpest design-production gap in the dataset -- the #3 production-weighted style and #6 Discovered style is completely absent from design exercises. Competition prompts describe user-facing business systems where Microservices and Event-Driven map intuitively, while pipeline architecture solves infrastructure problems (request processing, compilation, media transcoding, metrics ingestion) that competition prompts rarely address.

**Reference implementations:** None.

**Quality attributes supported**: Throughput, Composability, Independent Stage Evolution, Testability (per-stage), Reusability of stages
**Quality attributes traded off**: Latency (multi-stage overhead for single items), Complexity (error handling across stages), Interactivity (pipeline assumes unidirectional flow)

**When to use**: Systems where data flows through ordered transformation stages: compilers, media processing, HTTP request handling, ETL/data ingestion, metrics pipelines, CI/CD systems. Appears in 16% of real codebases. Especially powerful when combined with Plugin architecture (LLVM, GStreamer) so that pipeline stages are independently replaceable.

**When NOT to use**: Interactive or request-response systems where bidirectional communication is primary. Pipeline assumes unidirectional data flow; forcing interactive patterns into a pipeline creates unnecessary complexity.

---

### #7 (Discovered) / #7 (Production-Weighted) -- CQRS/Event Sourcing

**In 122 codebases, CQRS/Event Sourcing appears in 18 repos (15%).** AxonFramework, EventStoreDB integrations, Marten-based systems, and other event sourcing frameworks.

**Evidence tier**: T4 (KataLog, RealWorld, RefArch, Discovered) | **Production-weighted score**: 33 pts (61% production)

**Production evidence:**
- **Squidex** (RealWorld): Headless CMS where every content change is stored as an immutable event. MongoDB serves as the event store; read models are projected from events. The first production CQRS/Event Sourcing evidence in the library, providing 61% of the style's combined score. ~2,300 GitHub stars.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 3 of 78 teams (3.8%)
- **Placement distribution**: 1 first / 1 second / 0 third / 1 runner-up
- **Average placement score**: 2.67
- **ArchColider** (1st, Farmacy Food): Event sourcing as core storage pattern combined with modular monolith and DDD. The team's ADRs explained that immutable events provided the audit trail required by food safety regulations -- a domain-specific justification invisible in code.
- **Miyagi's Little Forests** (2nd, Farmacy Food): CQRS with hexagonal architecture and DDD context mapping.
- **Commonly paired with**: Microservices (2), Event-Driven (2), Hexagonal/Clean (2), DDD (2)

**Reference implementations:**
- 4 repositories (eShopOnContainers, Modular Monolith w/DDD, Clean Architecture Template, Wild Workouts -- C#, Java, Go). Highest RefArch representation relative to KataLog usage.

**Quality attributes supported**: Auditability, Scalability (independent read/write scaling), Event Replay, Data Integrity, Temporal Query
**Quality attributes traded off**: Complexity, Eventual Consistency, Learning Curve

**When to use**: Systems requiring full audit trails, temporal queries, or independent read/write scaling. Appears in 15% of real codebases. Squidex demonstrates that CQRS/ES is viable for content management where every change must be tracked and replayed. Strongest when paired with DDD and Event-Driven.

**When NOT to use**: KataLog evidence shows CQRS/ES only appeared in Farmacy Food and Spotlight challenges. Teams in 2023-2025 seasons did not adopt it, suggesting perceived complexity without sufficient payoff for most challenge contexts. Avoid unless the domain genuinely requires immutable event histories or independent read/write models.

---

### #8 (Discovered) / #11 (Production-Weighted) -- Hexagonal/Clean Architecture

**In 122 codebases, Hexagonal/Clean appears in 16 repos (13%).** Clean Architecture templates, hexagonal examples across Java, C#, Go, and TypeScript.

**Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production-weighted score**: 16 pts (0% production)

**Production evidence:**
None. Hexagonal/Clean has zero production evidence. However, 16 Discovered repos and strong RefArch presence (3 repos, highest point contribution of any style from RefArch alone) suggest it is widely taught and implemented as a within-service structural pattern.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 4 of 78 teams (5.1%)
- **Placement distribution**: 1 first / 1 second / 1 third / 1 runner-up
- **Average placement score**: 2.50
- **MonArch** (1st, Hey Blue!): Hexagonal architecture applied at each microservice level with C4 component modeling. The team explained that hexagonal boundaries per service enabled independent testing and replacement of adapters without touching domain logic.
- **Miyagi's Little Forests** (2nd, Farmacy Food): Hexagonal reference architecture for internal bounded context structure.
- **Architects++** (3rd, Farmacy Family): Hexagonal architecture with partnership-over-build approach, HIPAA compliance.
- **Most successful in**: Hey Blue! (avg 4.0), Farmacy Food (avg 3.0)
- **Commonly paired with**: Microservices (3), Event-Driven (3), CQRS/Event Sourcing (2), Space-Based (1)
- **Key technologies**: Port/adapter patterns, dependency inversion, domain isolation

**Reference implementations:**
- 3 repositories (Clean Architecture Solution Template, BuckPal, Wild Workouts -- C#, Java, Go). Highest per-style RefArch representation.

**Quality attributes supported**: Testability, Maintainability, Domain Isolation, Replaceability
**Quality attributes traded off**: Simplicity (additional layers), Initial Development Speed

**When to use**: As a within-service structural pattern for domain isolation and testability. Appears in 13% of real codebases. Functions best inside a broader system-level architecture (MonArch applied hexagonal within each microservice). All 4 KataLog teams placed competitively.

**When NOT to use**: Small KataLog sample (n=4), all teams placed competitively -- no clear negative signal. The pattern adds structural overhead that may not be justified for simple CRUD services or short-lived systems.

---

### #9 (Discovered) / #12 (Production-Weighted) -- Serverless

**In 122 codebases, Serverless appears in 6 repos (5%).** Mostly AWS SAM/CDK deployments. Below the n>=10 target for robust classification.

**Evidence tier**: T4 (KataLog, RefArch, Discovered; no AOSA/RealWorld) | **Production-weighted score**: 14 pts (0% production)

**Production evidence:**
None. Serverless has zero production evidence across both production sources. No AOSA or RealWorldASPNET project uses serverless as a primary style.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 8 of 78 teams (10.3%)
- **Placement distribution**: 1 first / 0 second / 1 third / 6 runner-up
- **Average placement score**: 1.50
- **MonArch** (1st, Hey Blue!): Serverless as one component of a broader multi-style architecture. The team used serverless for event-triggered background processing, not as the primary style.
- **TheGlobalVariables** (3rd, Spotlight): Serverless microservices on AWS Amplify with detailed cost-of-ownership analysis ($0.002/user/month). This is the most thorough cost analysis in the KataLog dataset -- teams explain *why* serverless cost models are attractive for variable-load workloads.
- **Most successful in**: Hey Blue! (avg 2.0), Spotlight (avg 1.5)
- **Commonly paired with**: Event-Driven (5), Microservices (3), Modular Monolith (2)
- **Key technologies**: AWS Lambda, AWS Step Functions, Google Cloud Functions, Firebase

**Reference implementations:**
- 1 repository (Serverless Microservices Reference Architecture, C#)

**Quality attributes supported**: Elasticity, Cost Efficiency (pay-per-use), Deployability, Automatic Scalability
**Quality attributes traded off**: Performance (cold starts), Control, Vendor Lock-in, Debugging Complexity

**When to use**: As a supporting pattern within a broader architecture, especially for event-triggered background processing, scheduled tasks, or lightweight APIs. Appears in 5% of real codebases. Cost-effective for variable-load workloads.

**When NOT to use**: Serverless as the primary/sole style (Berlin Bears, Team Pacman) consistently produced runner-up KataLog results. The gap between competition popularity (8 teams) and production adoption (0%) mirrors the Microservices gap. The style performs better as a supporting pattern than as the primary structural approach.

---

### #10 (Discovered) / #13 (Production-Weighted) -- Multi-Agent

**In 122 codebases, Multi-Agent appears in 5 repos (4%).** AutoGPT, CrewAI, LangGraph-based systems, CAMEL, smolagents. Below the n>=10 target for robust classification. The first code-level validation of this emerging pattern.

**Evidence tier**: T2 (KataLog, Discovered) | **Production-weighted score**: 8 pts (0% production)

**Production evidence:**
None. Multi-Agent is the newest style in the taxonomy (first appeared Fall 2024) and has no production evidence across any source.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 3 of 78 teams (3.8%)
- **Placement distribution**: 1 first / 1 second / 0 third / 1 runner-up
- **Average placement score**: 2.67
- **ConnectedAI** (1st, ShopWise AI): Multi-agent supervisor architecture with LangGraph, quantitative LLM evaluation using Ragas, full working prototype. The team explained *why* specialized agents outperformed a single-model approach: each agent could be independently evaluated and improved.
- **Breakwater** (2nd, ShopWise AI): Low-code multi-agent workflow on n8n with three-agent topology. The team documented cost implications of multi-hop LLM calls.
- **Most successful in**: ShopWise AI Assistant (avg 3.5), Certifiable Inc. (avg 1.0)
- **Commonly paired with**: Service-Based (1), Microservices (1), Event-Driven (1)
- **Key technologies**: LangGraph, LangChain, n8n workflows, supervisor-agent hierarchy, role-based AI personas

**Reference implementations:** None.

**Quality attributes supported**: Accuracy (specialized agents), Extensibility (add new agents), Responsible AI (separation of concerns per agent)
**Quality attributes traded off**: Complexity, Latency (multi-hop), Cost (multiple LLM calls), Debugging Difficulty

**When to use**: AI-focused systems where different reasoning capabilities (retrieval, analysis, planning, execution) benefit from specialized agents. Appears in 4% of real codebases. Requires an AI-centric problem context.

**When NOT to use**: This is an AI-era-specific pattern (first appeared Fall 2024). In the Certifiable Inc. challenge, where the problem was more structured (certification grading), a multi-agent approach placed as runner-up while simpler service-based approaches won 1st and 2nd.

---

### #11 (Discovered) / #8 (Production-Weighted) -- Space-Based Architecture

**In 122 codebases, Space-Based appears in 5 repos (4%).** Hazelcast integrations, Orleans-based systems, actor frameworks, distributed caches.

**Evidence tier**: T3 (KataLog, AOSA, Discovered) | **Production-weighted score**: 24 pts (83% production)

**Production evidence:**
- **Riak** (AOSA Vol. 1): Distributed key-value store using consistent hashing (Dynamo model) with in-memory data partitioning across a peer-to-peer cluster. No master node -- all nodes are equal. Eventual consistency with tunable read/write quorums. The canonical production example of space-based/tuple-space-inspired architecture.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 2 of 78 teams (2.6%)
- **Placement distribution**: 0 first / 1 second / 0 third / 1 runner-up
- **Average placement score**: 2.00
- **Iconites** (2nd, Road Warrior): Space-based combined with microservices and event-driven, Cosmos DB global distribution. The team explained *why* in-memory data partitioning was necessary for 2M active users with sub-second response requirements.
- **Most successful in**: Road Warrior (avg 3.0)
- **Commonly paired with**: Microservices (2), Event-Driven (2), Hexagonal/Clean (1), CQRS (1)
- **Key technologies**: In-memory data grids, partitioned caching, Redis, CosmosDB (distributed)

**Reference implementations:** None.

**Quality attributes supported**: Extreme Scalability, Low Latency, High Throughput, Elasticity
**Quality attributes traded off**: Complexity, Cost, Data Consistency (eventual)

**When to use**: Systems demanding extreme scalability, near-zero latency, and elastic capacity. Appears in 4% of real codebases. Riak demonstrates the pattern at database infrastructure level. Only appropriate when traffic patterns require in-memory data partitioning across distributed nodes.

**When NOT to use**: Extremely rare in practice (5 Discovered repos, 2 KataLog teams, 1 AOSA system). The complexity and cost overhead are unjustified for most application architectures.

---

### #12 (Discovered) / #4 (Production-Weighted) -- Service-Based Architecture

**In 122 codebases, Service-Based appears in only 4 repos (3%).** Service-based architecture is harder to detect from structural signals than microservices (fewer Docker Compose services) or event-driven (no message broker config). Its thin Discovered presence is a detection artifact, not a reflection of actual adoption -- 3 production systems confirm the pattern is under-detected.

**Evidence tier**: T5 (all 5 sources) | **Production-weighted score**: 105 pts (57% production)

**Production evidence:**
- **Selenium WebDriver** (AOSA Vol. 1): Service-based with adapter pattern. Per-browser drivers (ChromeDriver, GeckoDriver) are independent services coordinated by the WebDriver protocol. Each service is coarser-grained than a microservice but independently deployable.
- **Graphite** (AOSA Vol. 1): Three independent services (Carbon, Whisper, Graphite-web) connected by well-defined data contracts. Services can be replaced independently -- Carbon can be swapped for StatsD without changing Whisper or the web frontend.
- **Bitwarden** (RealWorld): Password management platform with 9 services that share a single database. Explicitly chose service-based over microservices to avoid operational overhead of fully independent data stores. ~16,000 GitHub stars.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 25 of 78 teams (32.1%) -- the third-most popular competition style
- **Placement distribution**: 3 first / 3 second / 3 third / 16 runner-up
- **Average placement score**: 1.72
- **Pragmatic** (1st, ClearView): Service-based with selective event-driven, 22 ADRs, AI feasibility analysis, DDD/Event Storming. The team documented *why* service-based decomposition with selective event-driven communication avoided the operational overhead of full microservices while preserving independent deployability.
- **ZAITects** (1st, Certifiable Inc.): Service-based with event-driven hybrid, 18 ADRs, comprehensive LLM production stack. The team explained that coarser-grained services reduced inter-service communication latency for LLM orchestration.
- **Team Seven** (1st, Sysops Squad): Service-based with event-driven message queues, 12 ADRs, phased migration plan.
- **Most successful in**: Certifiable Inc. (avg 2.0), ClearView (avg 2.0), Sysops Squad (avg 2.0), Farmacy Family (avg 2.0)
- **Commonly paired with**: Event-Driven (10 teams), Microservices (3), Hybrid/Evolutionary (1), Serverless (1)
- **Key technologies**: AWS services, message queues, API Gateway, REST APIs

**Reference implementations:**
- 1 repository (AKS Baseline Cluster -- infrastructure-focused)

**Quality attributes supported**: Maintainability, Reliability, Availability, Testability, Cost Efficiency
**Quality attributes traded off**: Scalability (bounded), Elasticity (less granular), Independent Deployability (limited vs. microservices)

**Cross-source insight**: Service-Based is one of only two styles (with Event-Driven) that has evidence across all five source types. Its thin Discovered presence (4 repos, 3%) contrasts sharply with its strong production validation (3 systems, 57% production evidence). Bitwarden's explicit choice of service-based over microservices -- citing operational overhead -- validates the KataLog finding that Event-Driven + Service-Based (avg 2.57) outperforms Event-Driven + Microservices (avg 1.29). Production evidence confirms that coarser-grained service decomposition with a shared database is a deliberate, pragmatic choice, not a compromise.

**When to use**: Business applications needing independent deployability without the operational overhead of full microservices. Particularly effective when services share a database (Bitwarden pattern) and teams lack the platform engineering capacity for service mesh, distributed tracing, and per-service CI/CD.

**When NOT to use**: Service-Based had weak KataLog showings in Road Warrior (avg 1.0) and Wildlife Watcher (avg 1.0), challenges requiring high scalability and real-time processing that push beyond service-based architecture's sweet spot.

---

### Not Discovered / #2 (Production-Weighted) -- Plugin/Microkernel

**In 122 codebases, Plugin/Microkernel appears in 0 repos (0%).** Plugin architectures are defined by runtime extension points and host-plugin contracts, not by directory structure or container orchestration. This is a known blind spot in automated structural detection -- the #2 production-weighted style is structurally undetectable. Despite zero Discovered presence, 6 production systems across compilers, ORMs, multimedia, media servers, CMS, and e-commerce validate this as one of the most production-proven patterns.

**Evidence tier**: T3 (KataLog, AOSA, RealWorld) | **Production-weighted score**: 124 pts (97% production)

**Production evidence:**
- **LLVM** (AOSA Vol. 1): Compiler infrastructure with a plugin/pass architecture. Each optimization and transformation is a plugin that slots into the compilation pipeline. Used by Apple (Clang/Swift), Rust, and hundreds of language frontends.
- **SQLAlchemy** (AOSA Vol. 2): Python ORM with a layered plugin architecture. Dialect plugins support multiple database backends (PostgreSQL, MySQL, SQLite, Oracle). Extensions for caching, versioning, and migration.
- **GStreamer** (AOSA Vol. 2): Multimedia framework where every codec, filter, demuxer, and output device is a plugin. Over 250 plugins in the base distribution. Core provides the host framework; all media processing is plugin-supplied.
- **Jellyfin** (RealWorld): Media server with a plugin system for metadata providers, authentication schemes, notification services, and media encoders. ~38,000 GitHub stars. .NET production evidence for plugin architecture.
- **Orchard Core** (RealWorld): CMS/application framework built as a modular monolith with a plugin (module) architecture. Modules provide features that can be enabled/disabled at runtime. ~7,500 GitHub stars.
- **nopCommerce** (RealWorld): E-commerce platform with a 17-year track record. Plugin system for payment gateways, shipping providers, tax calculators, and widgets. ~9,500 GitHub stars.

**Why this works -- team reasoning (KataLog):**
- **Usage**: 2 of 78 teams (2.6%)
- **Placement distribution**: 0 first / 0 second / 2 third / 0 runner-up
- **Average placement score**: 2.00
- **Software Architecture Guild** (3rd, Certifiable Inc.): Microkernel for AI assistants enabling 6 parallel AI solution variants. The team explained that plugin architecture allowed different AI models to be swapped without changing the host application.
- **Wonderous Toys** (3rd, Wildlife Watcher): Microkernel for integration extensibility combined with modular monolith.
- **Commonly paired with**: Event-Driven (1), Modular Monolith (1), Service-Based (1)

**Reference implementations:** None.

**Quality attributes supported**: Extensibility, Independent Evolution, Experimentation (A/B testing of plugins), Vendor Neutrality, Long-Term Adaptability
**Quality attributes traded off**: Plugin Interface Stability, Integration Testing Complexity, Plugin Isolation

**Cross-source insight**: Plugin/Microkernel is the largest rank correction in the dataset (+9 positions from KataLog-only to production-weighted). It is the most production-validated style relative to its design-phase awareness. Six production systems demonstrate that plugin architecture is how long-lived systems achieve extensibility. Yet competition teams almost never propose it, and automated code discovery cannot detect it. This is the strongest example of a detection bias blind spot: a pattern that is invisible to both automated analysis and competition culture, yet proven at massive scale.

**When to use**: Systems requiring third-party extensibility, independent feature evolution, or the ability to accommodate uses the creators never imagined. Especially strong for platforms (LLVM, GStreamer, Orchard Core) and products with ecosystem strategies (nopCommerce payment gateways, Jellyfin metadata providers).

**When NOT to use**: Systems without clear extension points or where all functionality is first-party. Plugin architecture adds interface design overhead that is wasted if no third-party or independent-team extension is planned.

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

## Cloud Provider Pattern Mapping

Maps cloud provider design pattern documentation to the library's architecture styles.

### Event-Driven Architecture

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Event-Driven Architecture | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-decomposing-monoliths/event-driven.html) |
| AWS | Saga Pattern (choreography) | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/saga.html) |
| Azure | Event-Driven Architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/event-driven) |
| Azure | Competing Consumers | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/competing-consumers) |
| Azure | Publisher-Subscriber | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/publisher-subscriber) |
| GCP | Event-Driven Architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/event-driven) |

### Microservices

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Decompose by business capability | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/decomposition.html) |
| AWS | API Gateway pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/api-gateway.html) |
| Azure | Microservices architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) |
| Azure | Sidecar pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/sidecar) |
| Azure | Ambassador pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/ambassador) |
| GCP | Microservices architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/microservices-architecture-introduction) |

### Service-Based Architecture

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | Web-Queue-Worker | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/web-queue-worker) |
| Azure | N-tier architecture | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/n-tier) |
| AWS | Strangler Fig pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/strangler-fig.html) |

### CQRS/Event Sourcing

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | CQRS pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) |
| Azure | Event Sourcing pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) |
| Azure | Materialized View pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/materialized-view) |
| AWS | CQRS pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/cqrs.html) |

### Serverless

| Provider | Pattern | Reference |
|----------|---------|-----------|
| AWS | Serverless architecture patterns | [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-architecture.html) |
| Azure | Serverless architecture style | [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/serverless) |
| GCP | Serverless architecture | [Google Cloud Architecture Center](https://cloud.google.com/architecture/serverless-overview) |

### Resilience / Cross-Cutting (Applies to Multiple Styles)

| Provider | Pattern | Reference |
|----------|---------|-----------|
| Azure | Circuit Breaker | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker) |
| Azure | Retry pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry) |
| Azure | Bulkhead pattern | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead) |
| AWS | Throttling pattern | [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/throttling.html) |
| All | Health Endpoint Monitoring | [Cloud Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) |

---

## Anti-Patterns: What Doesn't Work

Based on evidence from all five sources, these patterns consistently correlate with poor outcomes.

### 1. Microservices Without Event-Driven Architecture
**Statistical basis**: In 122 codebases, Microservices appears in 26 repos but co-occurs with Event-Driven in the majority. Teams that separate these patterns struggle.
**KataLog evidence**: 10 teams used Microservices without EDA. Average placement score: 1.70 (vs. 2.00 for EDA teams overall). Only 1 first-place win.
**Production evidence**: Systems that could adopt microservices (Bitwarden with 9 services) choose service-based with event-driven instead. Zero production systems in the evidence base use microservices as a primary style.
**Why it fails**: Pure synchronous microservices create tight coupling through REST chains. Production systems demonstrate that asynchronous decoupling is essential for the quality attributes microservices are supposed to deliver.

### 2. Over-Reliance on Scalability as Primary Quality Attribute
**Statistical basis**: In 122 codebases, Deployability (89%) vastly exceeds Scalability (27%) in detection frequency, suggesting most real systems prioritize deployment over scaling.
**KataLog evidence**: Scalability is cited by 68% of runners-up but only 55% of first-place winners. The "Scalability Trap."
**Production evidence**: AOSA and RealWorldASPNET systems achieve scalability through *specific mechanisms* (HDFS block replication, Riak consistent hashing, NGINX event loops, nopCommerce caching layers) rather than through architecture style selection.
**Why it fails**: Choosing Microservices "for scalability" is the design equivalent of choosing Kubernetes "for reliability" -- the abstraction level is wrong.

### 3. Zero ADRs or Minimal Decision Documentation
**Statistical basis**: Only ~5 of 122 Discovered repos have ADR directories. 1 of 8 Reference Architectures includes ADRs. The practice most correlated with competition success has minimal representation in real codebases.
**KataLog evidence**: Teams with zero ADRs never placed higher than Runner-up/3rd. Teams averaging fewer than 5 ADRs rarely place in top 2.
**Why it fails**: ADRs demonstrate architectural reasoning. Without them, judges cannot evaluate trade-off thinking. The gap between competition best practice and real-codebase practice is stark.

### 4. Technology-First Architecture
**KataLog evidence**: Teams like Los Ingenials (21 ADRs, runner-up) specified extensive technology stacks but placed as runners-up. Flagged as "possibly over-engineered."
**Production evidence**: Production systems use pragmatic technology choices aligned to their domain. Bitwarden uses a shared SQL database despite having 9 services. Graphite uses three simple components. Technology selection follows architecture, not the reverse.
**Why it fails**: Listing AWS services or naming every framework does not demonstrate architectural judgment. Winners focus on the "why" (quality attribute trade-offs) rather than the "what" (specific products).

### 5. Big-Bang Architecture Without Evolution Path
**Statistical basis**: In 122 codebases, Modular Monolith (52%) vastly exceeds Microservices (21%), suggesting most real systems start with simpler architectures -- evolution is the norm.
**KataLog evidence**: 73% of winners list two or more architecture styles and propose phased approaches. Teams proposing only a target-state architecture rarely placed in top 2.
**Production evidence**: Production systems evolved organically. LLVM's pass/plugin architecture enables incremental addition of language frontends and optimization passes. Orchard Core's module system allows features to be added without modifying the host.
**Why it fails**: Judges value pragmatism. A perfect target without a realistic path from the present is less valuable than an achievable initial architecture with a clear evolution roadmap.

### 6. Ignoring Production-Proven Patterns
**Statistical basis**: Pipeline appears in 16% of Discovered repos and ranks #3 production-weighted. Plugin is undetectable in code but has 6 production systems. Both are invisible in competition.
**Cross-source evidence**: Teams defaulting to Microservices + Event-Driven without considering Pipeline (for data flow problems) or Plugin (for extensibility problems) miss patterns validated at massive scale.
**Why it fails**: Competition discourse creates a recency bias toward named patterns (Microservices, Serverless). The most battle-tested patterns (Pipeline in NGINX/LLVM/GStreamer, Plugin in LLVM/SQLAlchemy/Jellyfin) predate modern architecture naming conventions but solve real problems more effectively.

### 7. Missing Deployment View
**KataLog evidence**: 82% of first-place teams include a deployment view vs. 50% of runners-up.
**Production evidence**: Every AOSA and RealWorld system has a concrete deployment model. In 122 Discovered repos, Deployability signals (Docker, CI) appear in 89% -- the most detected quality attribute.
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
