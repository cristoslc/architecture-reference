# Solution Space Taxonomy

A normalized, evidence-based catalog of architectural approaches used across 78 O'Reilly Architecture Kata submissions (Fall 2020 through Winter 2025), weighted by placement scores.

> **Multi-source evidence available.** This document covers TheKataLog competition data only. For the **production-weighted combined scoreboard** incorporating 12 AOSA production systems (6 pts each) and 8 reference implementations (1-2 pts each), see [Cross-Source Evidence Reference](evidence/cross-source-reference.md). Key finding: **Pipeline** (entirely from production evidence) and **Plugin/Microkernel** (82% production evidence) are significantly under-represented in competition data alone.

---

## How to Use This Document

This document maps the **solution space** of architecture kata competitions: which architectural styles, technology choices, communication patterns, and deployment strategies teams actually used, and how those choices correlated with competitive placement.

**Reading the evidence:**
- **Weighted Score** aggregates placement quality across all teams using a style. Higher = more evidence of successful use.
- **Average Placement Score** indicates quality-per-team. A style with fewer teams but higher average may be more reliably effective than a popular style with a diluted average.
- **1st Place Uses** counts how many winning teams adopted the style. This is the strongest signal.
- **Top Challenge Fit** identifies the specific problem contexts where a style performed best.

**Limitations:**
- Correlation is not causation. Winning teams may succeed for many reasons beyond their style choice.
- Each team may list multiple styles; counts are not mutually exclusive.
- The dataset is 78 teams across 11 challenges. Some styles have very small sample sizes (n < 5).
- Judges, challenge contexts, and evaluation criteria vary across seasons.
- **Competition bias**: These are design proposals, not running systems. Teams optimize for judges, not production. See the [Cross-Source Reference](evidence/cross-source-reference.md) for production-weighted scoring that corrects for this bias.

---

## Scoring Methodology (KataLog Only)

This section scores competition entries only (1-4 pts per team). For the **production-weighted methodology** where AOSA production systems receive 6 pts each, see [Cross-Source Evidence Reference](evidence/cross-source-reference.md#evidence-weighting-methodology).

Each team receives a placement score based on their competitive result:

| Placement | Points | Rationale |
|-----------|--------|-----------|
| 1st Place | 4 | Clear winner, validated by expert judges |
| 2nd Place | 3 | Strong runner-up, close to winning |
| 3rd Place | 2 | Recognized quality, notable strengths |
| Runner-up | 1 | Participated but did not place in top 3 |

**Weighted Score** = sum of all placement points for teams using that style. This rewards both breadth (many teams) and depth (high placements).

**Average Placement Score** = Weighted Score / Number of Teams. This normalizes for popularity, showing per-team effectiveness. Theoretical range: 1.0 (all runners-up) to 4.0 (all 1st-place winners).

**Placement distribution** across the 78 teams: 11 first-place, 11 second-place, 12 third-place, 44 runners-up.

---

## Architecture Style Scoreboard

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
| **Hybrid/Evolutionary** | 1 | 1 | 1.00 | 0 | Farmacy Food (1.0) |

**Key insight**: Modular Monolith has the highest average placement score (3.00) of any style despite low adoption. All three first-place Modular Monolith teams won their respective competitions. Event-Driven Architecture dominates in absolute terms (9 first-place wins) but its popularity dilutes its average.

---

## Detailed Style Profiles

### Event-Driven Architecture

**Usage**: 47 of 78 teams (60.3%)
**Weighted score**: 94
**Placement distribution**: 9 first / 6 second / 8 third / 24 runner-up
**Most successful in**: ShopWise AI Assistant (avg 4.0), Sysops Squad (avg 2.5), Certifiable Inc. (avg 2.5), Hey Blue! (avg 2.2), ClearView (avg 2.2), Farmacy Family (avg 2.2)
**Commonly paired with**: Microservices (29 teams), Service-Based Architecture (10), Serverless (5), Hexagonal/Clean (3), Modular Monolith (3)
**Key technologies observed**: Apache Kafka (most common), RabbitMQ, AWS SNS/SQS, Azure Event Hub, GCP Pub/Sub, message brokers (generic)
**Quality attributes it supports**: Scalability, Fault Tolerance, Availability, Evolvability, Performance, Responsiveness
**Quality attributes it trades off**: Simplicity, Cognitive Simplicity, Consistency (eventual consistency trade-off)
**Best example teams**:
- **BluzBrothers** (1st, MonitorMe): Pure event-driven with Kafka, 20 ADRs, quantitative fitness functions, infrastructure sizing proof
- **The Archangels** (1st, Farmacy Family): Event-driven with Kafka, 18 ADRs, crypto-shredding, full C4 modeling -- the "gold standard" submission
- **Profitero Data Alchemists** (1st, Road Warrior): Event-driven with Rozanski/Woods viewpoints, 15 ADRs, comprehensive multi-viewpoint framework
**When NOT to use**: Event-driven appeared at high rates across all placements (50% of runners-up also use it). It is necessary but not sufficient. Teams that adopted EDA without complementary patterns (event storming, proper ADR documentation, feasibility analysis) did not consistently place well. In the Wildlife Watcher challenge, EDA teams averaged only 1.3 -- the lowest for any challenge -- suggesting it may be over-applied in IoT/edge contexts where simpler patterns suffice.

---

### Microservices

**Usage**: 39 of 78 teams (50.0%)
**Weighted score**: 67
**Placement distribution**: 4 first / 6 second / 4 third / 25 runner-up
**Most successful in**: ShopWise AI (avg 4.0), Hey Blue! (avg 2.2), Wildlife Watcher (avg 2.2), Spotlight (avg 2.0)
**Commonly paired with**: Event-Driven Architecture (29 teams), Hexagonal/Clean (3), Modular Monolith (3), Service-Based (3), Serverless (3)
**Key technologies observed**: Kubernetes, Docker, AWS EKS/ECS, API Gateway, REST APIs, GraphQL
**Quality attributes it supports**: Scalability, Elasticity, Deployability, Evolvability, Fault Isolation
**Quality attributes it trades off**: Simplicity, Cost, Cognitive Load, Data Consistency, Operational Complexity
**Best example teams**:
- **CELUS Ceals** (1st, Wildlife Watcher): Microservices with iterative delivery, 15 ADRs, extensive C4 modeling, thorough 3rd-party integration analysis
- **MonArch** (1st, Hey Blue!): Microservices with hexagonal architecture per service, modular monolith initial phase, C4 modeling, event storming
- **The Marmots** (2nd, Spotlight): Pure microservices with 19 ADRs, layered separation, market sizing analysis
**When NOT to use**: Microservices alone (without EDA pairing) produces an average placement score of only 1.70 across 10 teams, with just 1 first-place win. Runners-up cite microservices at 55% -- the same rate as second-place teams. The cross-cutting analysis explicitly identifies microservices as "popular but not predictive." Teams that defaulted to microservices without addressing the complexity cost (operational overhead, distributed data management, inter-service communication) consistently underperformed.

**Critical finding**: Microservices-only teams (no EDA) averaged 1.70 points. EDA-only teams (no Microservices) averaged 2.44 points. The combination (EDA + Microservices) captures the broadest team count but does not outperform EDA alone on a per-team basis.

---

### Service-Based Architecture

**Usage**: 25 of 78 teams (32.1%)
**Weighted score**: 43
**Placement distribution**: 3 first / 3 second / 3 third / 16 runner-up
**Most successful in**: Certifiable Inc. (avg 2.0), ClearView (avg 2.0), Sysops Squad (avg 2.0), Farmacy Family (avg 2.0)
**Commonly paired with**: Event-Driven Architecture (10 teams), Microservices (3), Hybrid/Evolutionary (1), Serverless (1)
**Key technologies observed**: AWS services, message queues, API Gateway, REST APIs
**Quality attributes it supports**: Maintainability, Reliability, Availability, Testability, Cost Efficiency
**Quality attributes it trades off**: Scalability (bounded), Elasticity (less granular), Independent Deployability (limited)
**Best example teams**:
- **Pragmatic** (1st, ClearView): Service-based with selective event-driven, 22 ADRs, AI feasibility analysis, DDD/Event Storming
- **ZAITects** (1st, Certifiable Inc.): Service-based with event-driven hybrid, 18 ADRs, comprehensive LLM production stack, cost/efficiency analysis
- **Team Seven** (1st, Sysops Squad): Service-based with event-driven message queues, 12 ADRs, phased migration plan with transition architecture
**When NOT to use**: Service-Based had weak showings in the Road Warrior challenge (avg 1.0, only 1 team) and Wildlife Watcher (avg 1.0, only 1 team), which both required high scalability and real-time processing that push beyond service-based architecture's sweet spot.

---

### Modular Monolith

**Usage**: 6 of 78 teams (7.7%)
**Weighted score**: 18
**Placement distribution**: 3 first / 1 second / 1 third / 1 runner-up
**Most successful in**: Farmacy Food (avg 4.0), Hey Blue! (avg 4.0), Spotlight (avg 2.5), Wildlife Watcher (avg 2.5)
**Commonly paired with**: Microservices (3 teams -- as evolution target), Event-Driven Architecture (3), Serverless (2), Hexagonal/Clean (1)
**Key technologies observed**: AWS, DynamoDB, RabbitMQ, event sourcing, DDD strategic design
**Quality attributes it supports**: Cognitive Simplicity, Cost Efficiency, Deployability, Testability, Modifiability
**Quality attributes it trades off**: Scalability (initially), Elasticity (initially), Independent Deployability
**Best example teams**:
- **ArchColider** (1st, Farmacy Food): Modular monolith + event sourcing + DDD, pioneering cost analysis with 3 growth scenarios
- **MonArch** (1st, Hey Blue!): Modular monolith as initial phase evolving to microservices, C4 modeling, event storming
- **PegasuZ** (1st, Spotlight): Modular monolith MVP with microservices + event-driven long-term target, evolutionary architecture roadmap
**When NOT to use**: Very small sample size (n=6), but notably absent from Road Warrior (real-time travel, 2M active weekly users) and MonitorMe (medical device monitoring) -- challenges with strict latency and throughput requirements that may exceed a monolith's initial capacity.

**Critical finding**: Modular Monolith has the highest average placement score (3.00) of any style. Every team that used it as an explicit initial phase with a documented evolution path to distributed styles placed in the top 3. This "start simple, evolve deliberately" approach is the strongest single architectural signal in the dataset.

---

### Serverless

**Usage**: 8 of 78 teams (10.3%)
**Weighted score**: 12
**Placement distribution**: 1 first / 0 second / 1 third / 6 runner-up
**Most successful in**: Hey Blue! (avg 2.0), Spotlight (avg 1.5)
**Commonly paired with**: Event-Driven Architecture (5), Microservices (3), Modular Monolith (2)
**Key technologies observed**: AWS Lambda, AWS Step Functions, Google Cloud Functions, Firebase
**Quality attributes it supports**: Elasticity, Cost Efficiency (pay-per-use), Deployability, Scalability (automatic)
**Quality attributes it trades off**: Performance (cold starts), Control, Vendor Lock-in, Debugging Complexity
**Best example teams**:
- **MonArch** (1st, Hey Blue!): Serverless as one component of a broader multi-style architecture
- **TheGlobalVariables** (3rd, Spotlight): Serverless microservices on AWS Amplify with detailed cost-of-ownership analysis ($0.002/user/month)
**When NOT to use**: Serverless as the primary/sole style (Berlin Bears, Team Pacman) consistently produced runner-up results. Both teams lacked the architectural depth seen in winners. The style performs better as a supporting pattern within a broader architecture than as the primary structural approach.

---

### Domain-Driven Design

**Usage**: 4 of 78 teams (5.1%) as explicit architectural approach
**Weighted score**: 11
**Placement distribution**: 1 first / 2 second / 0 third / 1 runner-up
**Most successful in**: Farmacy Food (avg 3.5), Hey Blue! (avg 3.0)
**Commonly paired with**: Microservices (3), CQRS/Event Sourcing (2), Event-Driven Architecture (2), Hexagonal/Clean (1)
**Key technologies observed**: Event Storming (process), bounded contexts, context maps, strategic domain design
**Quality attributes it supports**: Extensibility, Modifiability, Domain Alignment, Cognitive Clarity
**Quality attributes it trades off**: Time-to-market (upfront analysis cost), Simplicity (for simple domains)
**Best example teams**:
- **ArchColider** (1st, Farmacy Food): DDD strategic design with core/supportive/generic domain classification, event sourcing
- **Miyagi's Little Forests** (2nd, Farmacy Food): DDD context map to microservices mapping, hexagonal reference architecture
- **IPT** (2nd, Hey Blue!): DDD with event storming, domain capability diagrams, GDPR compliance
**When NOT to use**: DDD is under-reported in the YAML data (many teams use DDD concepts like event storming without listing DDD as a style). It appeared most valuable in greenfield contexts with complex business logic. No DDD team placed poorly.

**Note**: While only 4 teams explicitly list DDD as an architecture style, many more use DDD tactical patterns (event storming, bounded contexts, domain decomposition). The cross-cutting analysis identifies event storming as a common practice among winners.

---

### Hexagonal/Clean Architecture

**Usage**: 4 of 78 teams (5.1%)
**Weighted score**: 10
**Placement distribution**: 1 first / 1 second / 1 third / 1 runner-up
**Most successful in**: Hey Blue! (avg 4.0), Farmacy Food (avg 3.0)
**Commonly paired with**: Microservices (3), Event-Driven Architecture (3), CQRS/Event Sourcing (2), Space-Based (1)
**Key technologies observed**: Port/adapter patterns, dependency inversion, domain isolation
**Quality attributes it supports**: Testability, Maintainability, Domain Isolation, Replaceability
**Quality attributes it trades off**: Simplicity (additional layers), Initial Development Speed
**Best example teams**:
- **MonArch** (1st, Hey Blue!): Hexagonal architecture applied at each microservice level with C4 component modeling
- **Miyagi's Little Forests** (2nd, Farmacy Food): Hexagonal reference architecture for internal bounded context structure
- **Architects++** (3rd, Farmacy Family): Hexagonal architecture with partnership-over-build approach and HIPAA compliance
**When NOT to use**: Small sample (n=4), all teams placed competitively. No clear negative signal exists for this pattern. It functions as a within-service structural pattern rather than a system-level architecture.

---

### CQRS/Event Sourcing

**Usage**: 3 of 78 teams (3.8%)
**Weighted score**: 8
**Placement distribution**: 1 first / 1 second / 0 third / 1 runner-up
**Most successful in**: Farmacy Food (avg 3.5)
**Commonly paired with**: Microservices (2), Event-Driven Architecture (2), Hexagonal/Clean (2), Domain-Driven Design (2)
**Key technologies observed**: Event stores, read/write model separation, projection-based queries
**Quality attributes it supports**: Auditability, Scalability (read/write independent scaling), Event Replay, Data Integrity
**Quality attributes it trades off**: Complexity, Eventual Consistency, Learning Curve
**Best example teams**:
- **ArchColider** (1st, Farmacy Food): Event sourcing as core storage pattern combined with modular monolith and DDD
- **Miyagi's Little Forests** (2nd, Farmacy Food): CQRS with hexagonal architecture and DDD context mapping
**When NOT to use**: CQRS/Event Sourcing was only used in the Farmacy Food and Spotlight challenges. Teams in later seasons (2023-2025) did not adopt it, suggesting it may be perceived as adding complexity without sufficient payoff for most kata challenge contexts.

---

### Multi-Agent

**Usage**: 3 of 78 teams (3.8%)
**Weighted score**: 8
**Placement distribution**: 1 first / 1 second / 0 third / 1 runner-up
**Most successful in**: ShopWise AI Assistant (avg 3.5), Certifiable Inc. (avg 1.0)
**Commonly paired with**: Service-Based Architecture (1), Microservices (1), Event-Driven Architecture (1)
**Key technologies observed**: LangGraph, LangChain, n8n workflows, supervisor-agent hierarchy, role-based AI personas
**Quality attributes it supports**: Accuracy (specialized agents), Extensibility (add new agents), Responsible AI
**Quality attributes it trades off**: Complexity, Latency (multi-hop), Cost (multiple LLM calls), Debugging Difficulty
**Best example teams**:
- **ConnectedAI** (1st, ShopWise AI): Multi-agent supervisor architecture with LangGraph, quantitative LLM evaluation using Ragas, full working prototype
- **Breakwater** (2nd, ShopWise AI): Low-code multi-agent workflow on n8n with three-agent topology
- **Usfive** (Runner-up, Certifiable Inc.): Multi-agent viewpoint scoring mimicking an Architecture Review Board with distinct professional personas
**When NOT to use**: This is an AI-era-specific pattern (first appeared Fall 2024). It requires an AI-focused challenge context. In the Certifiable Inc. challenge, where the problem was more structured (certification grading), a multi-agent approach placed as runner-up while simpler service-based approaches (ZAITects, Litmus) won 1st and 2nd.

---

### Space-Based Architecture

**Usage**: 2 of 78 teams (2.6%)
**Weighted score**: 4
**Placement distribution**: 0 first / 1 second / 0 third / 1 runner-up
**Most successful in**: Road Warrior (avg 3.0)
**Commonly paired with**: Microservices (2), Event-Driven Architecture (2), Hexagonal/Clean (1), CQRS/Event Sourcing (1)
**Key technologies observed**: In-memory data grids, partitioned caching, Redis, CosmosDB (distributed)
**Quality attributes it supports**: Extreme Scalability, Low Latency, High Throughput, Elasticity
**Quality attributes it trades off**: Complexity, Cost, Data Consistency (eventual)
**Best example teams**:
- **Iconites** (2nd, Road Warrior): Space-based combined with microservices and event-driven, with Cosmos DB global distribution
**When NOT to use**: Extremely rare (n=2). Only appeared in challenges demanding extreme scalability (Road Warrior with 2M active users). Not appropriate for most challenge contexts. The only team to place well (Iconites, 2nd) combined it with multiple other patterns.

---

### Microkernel/Plugin

**Usage**: 2 of 78 teams (2.6%)
**Weighted score**: 4
**Placement distribution**: 0 first / 0 second / 2 third / 0 runner-up
**Most successful in**: Certifiable Inc. (2.0), Wildlife Watcher (2.0)
**Commonly paired with**: Event-Driven Architecture (1), Modular Monolith (1), Service-Based (1)
**Key technologies observed**: Plugin registries, parallel solution variants, independent module replacement
**Quality attributes it supports**: Extensibility, Independent Evolution, Experimentation (A/B testing of plugins)
**Quality attributes it trades off**: Plugin Interface Stability, Integration Testing Complexity
**Best example teams**:
- **Software Architecture Guild** (3rd, Certifiable Inc.): Microkernel for AI assistants enabling 6 parallel AI solution variants -- the most innovative application of this pattern
- **Wonderous Toys** (3rd, Wildlife Watcher): Microkernel for integration extensibility combined with modular monolith
**When NOT to use**: Both teams placed 3rd but not higher. The pattern may lack the structural completeness judges expect at the system level. It works best as a component-level pattern within a broader architecture rather than as the primary system-level style.

---

### Hybrid/Evolutionary

**Usage**: 1 of 78 teams (1.3%) explicitly naming this style
**Weighted score**: 1
**Placement distribution**: 0 first / 0 second / 0 third / 1 runner-up
**Note**: While only 1 team explicitly names "Evolutionary Architecture" as a style, the evolutionary approach is far more prevalent than this count suggests. At least 8 of 11 first-place winners (73%) propose multi-style or phased architectures. Teams like PegasuZ (Modular Monolith to Microservices), MonArch (Modular Monolith initial to Microservices), ArchColider (Modular Monolith with evolution path), and Hey Dragon (3-stage Monolith to Service-Based to Microservices) all demonstrate evolutionary thinking without using this specific label.

**The real pattern**: Evolutionary architecture is not a style -- it is a meta-pattern that pervades winning submissions. The cross-cutting analysis confirms that "winners disproportionately combine styles or propose phased evolution."

---

## Communication Patterns

Communication pattern choices, derived from architecture styles and technology selections:

| Pattern | Teams Using | Weighted Score | Avg Score | 1st Place | Notable Signal |
|---------|-------------|----------------|-----------|-----------|----------------|
| **Asynchronous Messaging** (event-driven, message queues) | 47 | 94 | 2.00 | 9 | Strongest winner signal |
| **Synchronous REST/API** (microservices, service-based) | ~55 | ~100 | ~1.82 | 10 | Universal baseline; not differentiating |
| **Hybrid Sync+Async** (explicit combination) | ~30 | ~60 | ~2.00 | 7 | Winners rarely use pure sync or pure async alone |
| **GraphQL** | 5 | 9 | 1.80 | 1 | Niche; used in BFF patterns |
| **MQTT/IoT Protocols** | 3 | 5 | 1.67 | 0 | Specialized for IoT challenges (MonitorMe, Wildlife Watcher) |
| **WebSockets/SSE** (real-time push) | 4 | 8 | 2.00 | 1 | Used for real-time dashboards and chat |

**Key finding**: Synchronous REST is near-universal (virtually all teams use it at some level). The differentiating factor is whether teams also incorporate asynchronous messaging. Winners explicitly designed for async communication at 73% rates (vs. ~50% for runners-up).

---

## Data Strategy Patterns

| Strategy | Teams Using | Weighted Score | Avg Score | Top Exemplar |
|----------|-------------|----------------|-----------|--------------|
| **Relational (PostgreSQL/MySQL/RDS)** | ~18 | 30 | 1.67 | Team Seven (1st), Pragmatic (1st) |
| **NoSQL (DynamoDB/MongoDB/CosmosDB)** | ~17 | 35 | 2.06 | ArchColider (1st), ConnectedAI (1st) |
| **Time-Series (InfluxDB)** | 3 | 8 | 2.67 | BluzBrothers (1st) |
| **Graph Database (Neo4j/Neptune)** | 4 | 6 | 1.50 | The Archangels (1st) |
| **Event Sourcing** | 3 | 8 | 2.67 | ArchColider (1st) |
| **CQRS (read/write separation)** | 4 | 7 | 1.75 | Miyagi's Little Forests (2nd) |
| **Vector DB/RAG** | ~8 | 21 | 2.63 | ZAITects (1st) |
| **Data Lake/Warehouse** | 4 | 5 | 1.25 | Pentagram 2021 (Runner-up) |

**Key finding**: NoSQL databases (particularly DynamoDB and MongoDB) have a higher average placement score (2.06) than relational databases (1.67). Time-series databases (InfluxDB) achieved the highest per-team average (2.67) but are domain-specific to monitoring challenges. Vector databases/RAG emerged in the AI era (2024-2025) with strong placement performance (avg 2.63).

---

## Deployment Patterns

| Pattern | Teams | Weighted Score | Avg Score | 1st Place Uses |
|---------|-------|----------------|-----------|----------------|
| **Cloud-Native** (AWS/Azure/GCP specified) | 46 | 76 | 1.65 | 5 |
| **Cloud-Agnostic/Unspecified** | 30 | 65 | 2.17 | 6 |
| **On-Premises** | 2 | 4 | 2.00 | 0 |

**Cloud provider breakdown** (among teams specifying a provider):

| Provider | Teams Mentioning | Weighted Score | 1st Place |
|----------|-----------------|----------------|-----------|
| **AWS** | 40+ | 130 | 7 |
| **Azure** | 8 | 22 | 0 |
| **GCP** | 6 | 18 | 3 |

**Key finding**: Cloud-agnostic teams (those not specifying a particular provider or remaining technology-neutral) actually score higher on average (2.17) than cloud-native teams (1.65). This suggests judges may reward architectural thinking over vendor-specific implementation details. However, when teams do specify a cloud provider, AWS is dominant (40+ teams) and GCP users have a notably high first-place rate (3 of 6 teams).

---

## Technology Stack Patterns

Top technologies by weighted placement score:

| Technology Category | Teams | Weighted Score | 1st Place Uses | Top Team |
|--------------------|-------|----------------|----------------|----------|
| **LLM/AI Services** | 28 | 61 | 7 | ConnectedAI, Pragmatic, ZAITects |
| **RAG/Vector Search** | 14 | 37 | 5 | ZAITects, ConnectedAI |
| **Apache Kafka** | 15 | 35 | 4 | BluzBrothers, The Archangels, Profitero Data Alchemists |
| **NoSQL Databases** | 17 | 35 | 4 | ArchColider, ConnectedAI |
| **PostgreSQL/RDS** | 18 | 30 | 1 | Team Seven |
| **Kubernetes** | 19 | 29 | 2 | CELUS Ceals, MonArch |
| **Docker/Containers** | 9 | 19 | 1 | ConnectedAI |
| **GraphQL** | 5 | 9 | 1 | PegasuZ |
| **RabbitMQ** | 4 | 8 | 1 | ArchColider |

**AI-era technology emergence** (2024-2025 seasons):
- LangChain/LangGraph appears in 5 teams, all in AI-focused katas
- RAG (Retrieval Augmented Generation) is the dominant AI integration pattern (14 teams, 5 first-place uses)
- "LLM-as-a-Judge" pattern emerged in Winter 2025 (ZAITects)
- Working prototypes became a competitive differentiator (ConnectedAI, Transformers both submitted functional code)

---

## Style Combination Patterns

Teams frequently combine multiple architecture styles. The data reveals which combinations produce the best results.

### Top Style Combinations by Weighted Score

| Combination | Teams | Weighted Score | Avg Score | Notable Results |
|-------------|-------|----------------|-----------|-----------------|
| **Event-Driven + Microservices** | 17 | 22 | 1.29 | Most common combo, but low avg score |
| **Event-Driven + Service-Based** | 7 | 18 | 2.57 | 3 first-place teams (Pragmatic, ZAITects, Team Seven) |
| **Event-Driven + Microservices + Modular Monolith** | 1 | 4 | 4.00 | PegasuZ (1st) |
| **Event-Driven + Microservices + Multi-Agent** | 1 | 4 | 4.00 | ConnectedAI (1st) |
| **Event-Driven + Hexagonal + Microservices + Modular Monolith + Serverless** | 1 | 4 | 4.00 | MonArch (1st) |
| **CQRS/Event Sourcing + DDD + Modular Monolith** | 1 | 4 | 4.00 | ArchColider (1st) |
| **Microservices + Modular Monolith** | 1 | 3 | 3.00 | Rapid Response (2nd) |
| **CQRS + DDD + Event-Driven + Hexagonal + Microservices** | 1 | 3 | 3.00 | Miyagi's Little Forests (2nd) |
| **DDD + Event-Driven + Microservices** | 1 | 3 | 3.00 | IPT (2nd) |
| **Event-Driven + Microservices + Space-Based** | 1 | 3 | 3.00 | Iconites (2nd) |

### Number of Styles vs. Placement

| Style Count | Teams | Weighted Score | Avg Score |
|-------------|-------|----------------|-----------|
| 0 canonical styles | 2 | 3 | 1.50 |
| 1 style | 30 | 56 | 1.87 |
| 2 styles | 31 | 51 | 1.65 |
| 3 styles | 11 | 26 | 2.36 |
| 5 styles | 3 | 8 | 2.67 |

**Key findings**:
1. **Event-Driven + Service-Based** (avg 2.57) dramatically outperforms **Event-Driven + Microservices** (avg 1.29) as a combination. Three of its seven teams won first place.
2. **Three or more complementary styles** (avg 2.36-2.67) outperform single-style or two-style approaches on average. Winners tend to combine styles thoughtfully.
3. The most common combination (Event-Driven + Microservices, 17 teams) is also the lowest-performing combo per team (avg 1.29). Its popularity dilutes its effectiveness signal -- many teams default to this combination without differentiating through additional patterns.
4. Every first-place winner with Modular Monolith combined it with at least one other style as an evolution target. The "Modular Monolith + [distributed target]" pattern is undefeated.

---

## Anti-Patterns: What Doesn't Work

Based on evidence of consistently poor placement, these patterns and approaches represent anti-patterns in the kata competition context.

### 1. Microservices Without Event-Driven Architecture
**Evidence**: 10 teams used Microservices without EDA. Average placement score: 1.70 (vs. 2.00 for EDA teams overall). Only 1 first-place win (CELUS Ceals, which compensated with strong C4 modeling, 15 ADRs, and iterative delivery).
**Why it fails**: Pure synchronous microservices create tight coupling through REST chains. Judges recognize that asynchronous decoupling is essential for the quality attributes (scalability, fault tolerance, availability) that microservices are supposed to deliver.

### 2. Over-Reliance on Scalability as Primary Quality Attribute
**Evidence**: Scalability is cited by 68% of runners-up but only 55% of first-place winners. The cross-cutting analysis calls this "The Scalability Trap."
**Why it fails**: Defaulting to scalability signals a lack of contextual analysis. Winners prioritize attributes specific to their challenge: cost/feasibility (45% of winners vs. 14% of runners-up), data integrity (27% vs. 14%), and fault tolerance (27% vs. 18%).

### 3. Zero ADRs or Minimal Decision Documentation
**Evidence**: Two teams have zero ADRs (Arch Angels, Transformers). Neither placed higher than Runner-up/3rd. Teams averaging fewer than 5 ADRs rarely place in the top 2.
**Why it fails**: ADRs demonstrate architectural reasoning. Without them, judges cannot evaluate trade-off thinking, which is the core competency being assessed.

### 4. Technology-First Architecture (Specifying Every Service Without Reasoning)
**Evidence**: Teams like Los Ingenials (21 ADRs, runner-up) and Data Arch Evangelists (9 ADRs, runner-up) specified extensive technology stacks but placed as runners-up. Los Ingenials was explicitly flagged as "possibly over-engineered."
**Why it fails**: Listing AWS services or naming every framework does not demonstrate architectural judgment. Winners focus on the "why" (quality attribute trade-offs, business constraints) rather than the "what" (specific products).

### 5. Big-Bang Architecture Without Evolution Path
**Evidence**: Teams that proposed only a target-state architecture without phased migration or MVP planning rarely placed in top 2. The cross-cutting analysis notes: "Of the 11 winners, 8 (73%) list two or more architecture styles, compared to 52% of runners-up," and winners disproportionately propose phased approaches.
**Why it fails**: Judges value pragmatism. A perfect target architecture without a realistic path from the present is less valuable than an achievable initial architecture with a clear evolution roadmap.

### 6. Monolithic Architecture as Final State
**Evidence**: Transformers (3rd, ShopWise AI) used a monolithic Flask app; no other team proposing a monolith as a final-state architecture placed higher than runner-up.
**Why it fails**: In a competition evaluating architectural thinking, a monolith suggests insufficient decomposition analysis. The exception: Modular Monolith as an intentional initial phase with documented evolution works very well (avg 3.00).

### 7. Missing Deployment View
**Evidence**: 82% of first-place teams include a deployment view vs. 50% of runners-up. Teams without a deployment view are significantly less likely to win.
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

*Generated: 2026-02-26 from structured YAML metadata of 78 O'Reilly Architecture Kata submissions (Fall 2020 -- Winter 2025).*
