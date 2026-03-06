# Architecture Decision Navigator

A practitioner-facing guide for navigating from problem characteristics to evidence-based architectural recommendations. Every recommendation is grounded in deep-validated statistical analysis of 163 open-source repositories (Discovered, SPEC-019 source-code-inspected), validated by 17 production systems (AOSA + RealWorld), and enriched with qualitative reasoning from 78 competition teams (KataLog). Total evidence base: 266 entries across 5 sources.

> **Methodology update (SPEC-019):** Discovered statistics are now derived from deep-validated source code inspection (163 repos), not automated filesystem analysis alone. This resolved several prior detection blind spots -- notably Plugin/Microkernel (0 -> 33 repos, 20.2%) and Service-Based (4 -> 11 repos, 6.7%). Styles and QAs that are architectural decisions invisible in directory structure may still be underdetected.
>
> KataLog competition evidence fills this gap -- teams documented these invisible decisions in ADRs and presentations.

---

## How to Use This Guide

1. **Answer the 8 questions in Step 1** to classify your problem across key dimensions.
2. **Follow the matching path in Step 2** based on your answers. Each path opens with statistical evidence from 163 deep-validated codebases, then production validation, then team reasoning explaining why the pattern works.
3. **Validate with quality attributes in Step 3** to strengthen your approach using Discovered detection data and team insights.
4. **Check the Quick Reference Card** at the end for a one-page summary ranked by Discovered frequency.

This guide is designed for sequential use -- work through Steps 1 through 3 in order. The entire process should take 15-30 minutes and will give you a specific, evidence-backed starting point for your architecture.

---

## Step 1: Classify Your Problem

Answer these questions about YOUR system. Circle or check the answer that best fits.

### Q1: What is your budget context?
- [ ] **A)** Startup/nonprofit -- cost is a top-3 priority
- [ ] **B)** Growth-stage -- some budget flexibility
- [ ] **C)** Enterprise -- budget is not the primary constraint

### Q2: What is your scale requirement?
- [ ] **A)** Small: <10K users, single-store, or fixed ceiling
- [ ] **B)** Medium: 10K--1M users or thousands of transactions/week
- [ ] **C)** Large: 1M--15M users or nationwide operations
- [ ] **D)** Very Large: 15M+ users or 99.99% availability SLA

### Q3: Is this greenfield or brownfield?
- [ ] **A)** Greenfield -- building from scratch
- [ ] **B)** Brownfield -- extending, migrating, or replacing an existing system

### Q4: What is your integration complexity?
- [ ] **A)** Low: 0--2 external systems
- [ ] **B)** Medium: 3--5 external systems
- [ ] **C)** High: 6+ external systems, unbounded integrations, or hardware integration

### Q5: Do you have compliance/regulatory requirements?
- [ ] **A)** None or minimal
- [ ] **B)** Moderate (PCI-DSS, food safety, GDPR with standard PII, geoprivacy)
- [ ] **C)** Heavy (HIPAA, medical device, high-stakes certification, anti-bias requirements with legal exposure)

### Q6: Do you have real-time requirements?
- [ ] **A)** No -- batch processing or eventual consistency is fine
- [ ] **B)** Near-real-time -- seconds to low minutes matter (proximity alerts, live dashboards, 5-minute update SLAs)
- [ ] **C)** Hard real-time -- sub-second response is required (vital sign monitoring, life-critical alerting)

### Q7: Does your system include AI/ML?
- [ ] **A)** No AI component
- [ ] **B)** AI as a feature within a larger system (recommendations, matching, peripheral analytics)
- [ ] **C)** AI is the core product (chatbot, AI grading, AI anonymization, AI pipeline)

### Q8: Do you have edge/offline requirements?
- [ ] **A)** No -- cloud-only is fine
- [ ] **B)** Yes -- some components must work offline, on-premises, or on constrained edge hardware

---

## Step 2: Follow Your Path

Find the path that best matches your answer profile. If you match multiple paths, read all of them and synthesize -- successful architects frequently combine insights from multiple problem dimensions.

---

### Path A: Budget-Constrained + Small-to-Medium Scale
**Match profile**: Q1=A, Q2=A or B

**Recommended: Modular Monolith with documented evolution path to Service-Based or Microservices**

**Statistical basis:** Modular Monolith appears in 65 of 163 deep-validated Discovered repos (39.9%) -- the most frequently observed architecture style. Notable projects: AutoGPT (182k stars), n8n (177k), langchain (128k), elasticsearch (76k), nest (74k), redis (73k). It co-occurs with Event-Driven in 25 repos (the top co-occurring pair) and with Plugin/Microkernel in 19 repos (the second most common pair). This suggests modular boundaries with event-driven communication and plugin extensibility are the most common architectural configurations in production codebases.

**Production validation:** Orchard Core (RealWorld) is a production CMS built as a Modular Monolith with a Plugin system, demonstrating successful module isolation and extensibility without the operational overhead of distributed services. The modular-monolith-with-ddd reference implementation (RefArch) provides a canonical example of Modular Monolith with DDD boundaries, confirming that this pattern translates from design to production with well-defined bounded contexts.

**Why this works -- team reasoning:** In KataLog competition, Modular Monolith has the highest average placement score (3.00) of any architecture style. All 3 first-place Modular Monolith teams won their respective competitions. Judges consistently rewarded cost-realism over architectural ambition in non-profit and startup contexts.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| ArchColider | 1st | Farmacy Food | Modular monolith + event sourcing + DDD | Three-scenario cost model: $12K--$23K/year. Won against 9 teams, 6 of which chose microservices. |
| PegasuZ | 1st | Spotlight Platform | Modular monolith MVP evolving to microservices + event-driven | Asked "Why build a fortress if no one will live in it?" Defined quantum boundaries for later extraction. |
| MonArch | 1st | Hey Blue! | Modular monolith initial phase evolving to microservices | Projected $2,780/month on GCP for 50K MAU. Began modular, planned service extraction. |

**Critical documentation**: Include a concrete cost analysis. In non-profit/startup challenges, every first-place winner included some form of cost analysis. Feasibility analysis is the strongest single predictor of placement. Teams with it are 4.5x more likely to place in the top 2.

**Also study**: TheGlobalVariables (3rd, Spotlight) calculated $0.002/user/month with serverless microservices. Arch8s (Runner-up, Spotlight) used a hybrid modular monolith + service-based + serverless approach.

---

### Path B: Large Scale + Event-Heavy Workloads
**Match profile**: Q2=C or D, Q6=B or C

**Recommended: Event-Driven Architecture + Service-Based (NOT microservices-first)**

**Statistical basis:** Event-Driven appears in 47 of 163 deep-validated Discovered repos (28.8%) -- the second most prevalent style. Notable projects: AutoGPT (182k stars), n8n (177k), dify (131k), elasticsearch (76k), appwrite (55k). It co-occurs with Service-Based patterns across multiple domains. Five production systems validate this combination: NGINX, Twisted, ZeroMQ, Squidex, and Bitwarden.

Service-Based now shows 11 Discovered repos (6.7%) after deep validation -- up from 4 repos under automated detection. Notable projects: dify (131k stars), mastodon (49k), temporal (18k), linkerd2 (11k). Three production systems (Selenium, Graphite, Bitwarden) provide additional validation.

**Production validation:** NGINX (AOSA) uses Event-Driven architecture to handle the C10K problem and beyond, serving over 30% of internet traffic using an asynchronous, non-blocking event loop. Bitwarden (RealWorld) combines Service-Based + Event-Driven patterns for a security-critical password management platform. Graphite (AOSA) uses Pipeline + Service-Based architecture for high-volume metrics ingestion, processing millions of metrics per minute.

**Why this works -- team reasoning:** In KataLog competition, Event-Driven + Service-Based averages 2.57 placement points per team with 3 first-place wins out of 7 teams. Event-Driven + Microservices, despite being the most common combination (17 teams), averages only 1.29 points per team. This is the single largest performance gap between any two style combinations in the dataset.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| Pragmatic | 1st | ClearView | Service-based with selective event-driven | 22 ADRs, DDD/Event Storming, AI feasibility analysis |
| ZAITects | 1st | Certifiable Inc. | Service-based with event-driven hybrid | 18 ADRs, comprehensive LLM production stack |
| Team Seven | 1st | Sysops Squad | Service-based with event-driven message queues | 12 ADRs, phased migration plan with transition architecture |
| Profitero Data Alchemists | 1st | Road Warrior | Pure event-driven | Rozanski/Woods viewpoints, 15 ADRs, chose evolvability over elasticity |

**Watch out for**: The "Scalability Trap." Scalability is cited by 68% of runners-up but only 55% of first-place winners. Do not let scalability drive your entire architecture. Address it through targeted mechanisms (scaling groups, CQRS, queue-based decoupling) rather than choosing an entire architecture style for scalability alone.

Microservices without event-driven architecture is an anti-pattern -- pure synchronous microservices create tight coupling through REST chains. Deep-validated Discovered shows only 16 repos (9.8%) use Microservices -- far fewer than prior automated detection suggested. Notable MS projects: supabase (98k stars), dapr (25k), microservices-demo (19k). Zero have production-system validation. EDA-only teams averaged 2.44 points; microservices-only teams (no EDA) averaged 1.70.

**Also study**: Iconites (2nd, Road Warrior) combined microservices + event-driven + space-based with Cosmos DB global distribution. BluzBrothers (1st, MonitorMe) used pure event-driven with Kafka to meet critical latency requirements.

---

### Path C: Legacy Migration (Brownfield)
**Match profile**: Q3=B

**Recommended: Service-Based Architecture with phased transition plan**

**Statistical basis:** Service-Based now appears in 11 of 163 deep-validated Discovered repos (6.7%) -- up from 4 repos under automated detection. Notable projects: dify (131k stars), mastodon (49k), temporal (18k), linkerd2 (11k). Three production systems (Selenium, Graphite, Bitwarden) provide additional validation.

Brownfield migration evidence is inherently thin in open-source catalogs -- most repositories represent a single architectural snapshot rather than a migration journey.

**Production validation:** nopCommerce (RealWorld) demonstrates successful brownfield evolution over a 17-year lifespan, migrating from original ASP.NET to modern .NET while maintaining backward compatibility and a large plugin ecosystem. Selenium (AOSA) evolved from its monolithic RC (Remote Control) architecture to the distributed WebDriver architecture -- a production-scale brownfield migration that replaced the core execution model while preserving the public API contract.

**Why this works -- team reasoning:** In the Sysops Squad challenge (the only pure brownfield-migration kata), 6 of 7 KataLog teams chose service-based architecture. The top 3 placements all used service-based. In Certifiable Inc. (brownfield extension), 6 of 7 teams also chose service-based. The cross-cutting analysis states: "The transition architecture matters more than the target architecture."

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| Team Seven | 1st | Sysops Squad | Service-based + event-driven message queues | Centered submission on transition architecture, not just target state. Phased migration plan. |
| ArchElekt | 2nd | Sysops Squad | Service-based | Documented migration from monolith with operational continuity |
| Sever Crew | 2nd | Farmacy Family | Service-based with event-driven Kafka integration layer | Extended an existing system with event-driven bridge |
| ZAITects | 1st | Certifiable Inc. | Service-based + event-driven | Extended existing SoftArchCert platform with AI grading capabilities |

**Critical documentation**: Include a transition architecture showing the phased migration path from current state to target state. Teams that proposed only a target-state architecture without a phased migration plan rarely placed in the top 2. 73% of first-place winners propose phased approaches.

**Anti-pattern to avoid**: Big-bang architecture without an evolution path. A perfect target architecture without a realistic path from the present is less valuable than an achievable initial architecture with a clear evolution roadmap.

**Also study**: Hey Dragon (3rd, Sysops Squad) proposed a 3-stage evolution: Monolith to Service-Based to Microservices. Global Architects (Runner-up, Sysops Squad) proposed an ML chatbot for demand reduction -- a creative non-architectural mitigation.

---

### Path D: Healthcare/Medical with Real-Time Requirements
**Match profile**: Q5=C (healthcare), Q6=C (hard real-time)

**Recommended: Event-Driven Architecture, on-premises deployment**

**Statistical basis:** Event-Driven appears in 47 of 163 deep-validated Discovered repos (28.8%). Notable projects: AutoGPT (182k stars), n8n (177k), dify (131k), elasticsearch (76k). Among Observability-focused and Data Processing repos, telemetry pipeline patterns analogous to medical monitoring -- continuous high-frequency data ingestion with event-driven processing -- are common.

No direct healthcare repos appear in the Discovered corpus. The statistical basis here is EDA's general prevalence and its dominance in streaming/pipeline workloads.

**Production validation:** Graphite (AOSA) is a production monitoring pipeline handling high-frequency metrics at scale, architecturally analogous to medical monitoring systems. Its Carbon daemon ingests continuous time-series data streams, Whisper provides fixed-size time-series storage, and the pipeline processes heterogeneous metric streams with different collection intervals -- the same fundamental pattern as vital sign monitoring with varied cadences (heart rate at 500ms, ECG at 1s, blood pressure at 1hr).

**Why this works -- team reasoning:** All 7 MonitorMe KataLog teams chose event-driven architecture -- the strongest per-challenge consensus in the dataset. The winner proved quantitative compliance with latency SLAs.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| BluzBrothers | 1st | MonitorMe | Pure event-driven with Kafka | 20 ADRs, quantitative fitness functions, proved 693ms end-to-end latency against 1-second SLA. Infrastructure sizing proof for 500 patients. |
| Mighty Orbots | 2nd | MonitorMe | Microservices + event-driven | ELT pipeline prioritizing data integrity by loading raw data immediately. |
| LowCode | 3rd (tied) | MonitorMe | Distributed hardware with event-driven | 3-node role-based failover: Coordinator/Monitor/Analyzer. Mapped graceful degradation at each failure level. |

**Note on evidence coverage**: No direct healthcare production systems appear in the AOSA or RealWorld sources. Competition evidence from MonitorMe (7 teams, unanimous EDA choice) provides the most domain-specific guidance. Graphite validates the underlying architectural pattern (continuous event ingestion at scale) without the healthcare-specific compliance context.

**Critical documentation**: Include quantitative fitness functions. BluzBrothers won by proving their architecture met the SLA through calculations, not claims. Also design explicit graceful degradation -- LowCode's 3-node/2-node/1-node failure state mapping was more valuable than generic "high availability" claims.

**Technology choices**: Time-series databases (InfluxDB) were the consensus for vital sign storage, achieving the highest per-team average placement score (2.67) of any database category. Apache Kafka was the dominant event broker.

**Scope decision**: BluzBrothers deliberately downplayed scalability (ADR-008) since the system had a fixed 500-patient ceiling. This mature scoping decision was noted as a strength, not a weakness.

---

### Path E: AI as the Core Product
**Match profile**: Q7=C

**Recommended: Service-Based Architecture + Human-in-the-Loop + Deterministic Boundaries**

**Statistical basis:** 16 AI/ML repositories appear in the deep-validated Discovered corpus -- the second-largest domain cluster. Multi-Agent appears in 11 repos (6.7% of corpus). Notable Multi-Agent projects: AutoGPT (182k stars), langchain (128k), autogen (55k), crewAI (45k). The expanded AI/ML cluster now provides meaningful statistical basis.

AI-as-core-product is the newest architectural pattern with growing but still evolving evidence. Competition evidence provides the most current guidance, as the AOSA corpus (2011-2012 vintage) predates modern AI systems entirely.

**Production validation:** No production AI systems appear in the AOSA or RealWorld catalogs. This is the weakest production evidence of any path. The 16 Discovered AI/ML repos confirm multi-agent as an emerging pattern with significant open-source momentum.

**Why this works -- team reasoning:** Across three AI-centric KataLog challenges (ShopWise AI, ClearView, Certifiable Inc.), service-based architecture was the most successful foundation. Every team in the high-stakes Certifiable Inc. challenge implemented human-in-the-loop oversight -- no team proposed fully autonomous AI. AI systems need deterministic boundaries around non-deterministic components. The winners built architecture TO CONSTRAIN the AI, not just to enable it.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| ConnectedAI | 1st | ShopWise AI | Multi-agent supervisor with LangGraph | Quantitative LLM evaluation using Ragas framework (faithfulness, relevancy). Working prototype. Dual-LLM strategy (Claude for reasoning, Gemini Flash for routing). |
| Pragmatic | 1st | ClearView | Service-based + selective event-driven | Deterministic matching: extract features with LLM, then match deterministically. Reduced LLM calls from O(n*m) to O(n+m). 22 ADRs. |
| ZAITects | 1st | Certifiable Inc. | Service-based + event-driven | Separated Grader from Judge (LLM-as-a-Judge pattern). Projected 80% cost reduction. OWASP Top 10 for LLM security. Langwatch for LLM observability. |
| Litmus | 2nd | Certifiable Inc. | Service-based | Confidence-based escalation to human reviewers. |

**Critical documentation for AI systems**:
- LLM evaluation framework with quantitative metrics (ConnectedAI used Ragas; ZAITects used Langwatch)
- Cost projections for LLM API usage (Katamarans calculated $0.06/candidate; ZAITects projected $190K vs. $940K manual costs)
- Model comparison benchmarks (ConnectedAI compared Claude, Gemini, GPT-4o-mini)
- AI-specific security analysis (ZAITects did OWASP Top 10 for LLM)
- Human-in-the-loop escalation design with confidence thresholds

**Key insight**: In the Certifiable Inc. challenge, a multi-agent approach (Usfive) placed as runner-up while simpler service-based approaches won 1st and 2nd. Multi-agent is not always better -- simpler architectures with clear boundaries outperformed complex agent topologies in structured problem domains.

**Contrarian wisdom**: Usfive deliberately rejected RAG and vector databases, arguing they homogenize acceptable answers. Software Architecture Guild used microkernel to run 6 parallel AI solution variants. Both offer valid alternative perspectives worth studying even though neither placed at the top.

**Also study**: Breakwater (2nd, ShopWise AI) used low-code multi-agent on n8n, validating that SQL outperformed RAG for structured data retrieval.

---

### Path F: IoT/Edge with Offline Requirements
**Match profile**: Q8=B

**Recommended: Event-Driven core with pragmatic monolith deployment at the edge**

**Statistical basis:** Event-Driven appears in 47 of 163 deep-validated Discovered repos (28.8%). Among Developer Tools (53 repos) and Infrastructure (7 repos) categories, offline operation and eventual synchronization are common requirements.

Edge/offline patterns -- store-and-forward, converge-on-connect, local-first operation -- appear across these categories. This confirms event-driven communication as the standard approach for intermittently connected systems.

**Production validation:** Git (AOSA) is a fully offline-capable distributed system, proving offline-first architecture at massive scale. Every Git clone is a complete repository that operates without any network connectivity, synchronizing changes only when connectivity is available -- the canonical "store-and-forward" pattern. Bitwarden (RealWorld) supports offline vault access. Puppet (AOSA) implements a converge-on-connect pattern where nodes operate independently with their last-known configuration and reconcile state when they reconnect -- directly analogous to IoT edge nodes that must function during connectivity gaps.

**Why this works -- team reasoning:** The Wildlife Watcher and MonitorMe KataLog challenges both required edge/offline capability. The winners diverged in style (CELUS Ceals used microservices; BluzBrothers used pure event-driven), but the consistent pattern was: event-driven communication between edge and cloud, with pragmatic deployment (not microservices) at the edge. Edge constraints are physical, not just architectural -- bandwidth, power, and compute limitations demand quantitative analysis.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| CELUS Ceals | 1st | Wildlife Watcher | Microservices with iterative delivery | 15 ADRs, extensive C4 modeling, thorough 3rd-party integration analysis across all 8+ platforms |
| Rapid Response | 2nd | Wildlife Watcher | Microservices with monolith-first deployment | Designed for monolith deployment at the edge. Quantified LoRaWAN constraints: 31KB image = 240 seconds. |
| BluzBrothers | 1st | MonitorMe | Pure event-driven on-premises | 20 ADRs, duplicate instances for availability, all processing on local appliance hardware |
| LowCode | 3rd (tied) | MonitorMe | Distributed hardware with role-based failover | Auto-configuration for plug-and-play appliance replacement. 3-node graceful degradation. |
| Wonderous Toys | 3rd | Wildlife Watcher | Modular monolith + microkernel | Chose modular monolith for cost-effectiveness; microkernel for integration extensibility |

**Critical documentation**: Quantify your physical constraints. Rapid Response's bandwidth calculation (31KB over LoRaWAN = 240 seconds) drove real design decisions that abstract analysis would have missed. LowCode's graceful degradation mapping (full function with 3 nodes, full function with 2, alerting-only with 1) addressed operational reality.

**Caution**: EDA teams in Wildlife Watcher averaged only 1.3 placement score -- the lowest for any challenge. This suggests event-driven may be over-applied in IoT/edge contexts where simpler patterns suffice. Let your physical constraints, not architectural fashion, drive the decision.

---

### Path G: High Integration Complexity + Enterprise Budget
**Match profile**: Q4=C, Q1=B or C

**Recommended: Per-quantum style selection with adapter/connector patterns**

**Statistical basis:** 53 Developer Tools repositories in the deep-validated Discovered corpus consistently surface extensibility as a key architectural tension. Plugin/Microkernel appears in 33 repos (20.2%) -- the 4th most common style overall. Notable Plugin projects: n8n (177k stars), elasticsearch (76k), nest (74k), redis (73k), grafana (72k). Plugin and Adapter patterns appear frequently as the solution for unbounded integration requirements.

Pipe-and-Filter appears in 26 repos (16.0%) and co-occurs with Event-Driven. Notable projects: dify (131k), langchain (128k), localstack (64k), traefik (62k), airflow (44k). This confirms pipeline-based processing as a common integration backbone in production codebases.

**Production validation:** LLVM (AOSA) uses Pipeline + Plugin architecture to handle dozens of language frontends and hardware backends through a stable Intermediate Representation (IR). GStreamer (AOSA) uses a Plugin architecture to handle thousands of codecs, devices, and protocols. Selenium (AOSA) uses an Adapter pattern per browser unified behind a single WebDriver API. Jellyfin (RealWorld) uses a Plugin system for metadata providers, subtitle sources, and client applications.

**Why this works -- team reasoning:** When integration complexity is the dominant concern, the most successful KataLog teams selected architecture styles at the bounded-context (quantum) level rather than imposing a single system-wide style. High integration complexity means different external systems have different communication patterns, data formats, authentication mechanisms, and reliability characteristics. A single system-wide style cannot optimize for all of them.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| PegasuZ | 1st | Spotlight Platform | Identified architectural quanta, selected styles per quantum | Modular monolith for core, event-driven for notifications, serverless for analytics |
| Pragmatic | 1st | ClearView | Adapter-based HR integration with event-driven triggers | Named interoperability as top quality attribute. Designed adapter per HR system type. |
| CELUS Ceals | 1st | Wildlife Watcher | Comparative analysis of all 8+ external platforms | Evaluated labeling platforms across deployment model, API availability, upload mechanisms |
| Wonderous Toys | 3rd | Wildlife Watcher | Microkernel/plugin for integration extensibility | Plugin architecture so new integrations can be added without core changes |

**Critical documentation**: Produce a comparative analysis of all external systems you must integrate with. CELUS Ceals' platform-by-platform evaluation (API availability, deployment model, upload mechanism) was cited as a key differentiator. Also document vendor research as an architectural activity -- Jaikaturi (2nd, Farmacy Food) discovered ChefTec integration costs ranged from $500 to $5,000+ only by contacting the vendor directly.

**Pattern by integration tier**:
- **Medium (3-5 systems)**: Adapter pattern, dedicated integration services, webhook-based communication
- **High (6+ systems)**: Event-driven integration backbone (Kafka appeared in 5/7 Farmacy Family submissions), dedicated modules per external system
- **Very High (8+ systems)**: Microkernel/plugin architecture for extensibility, comparative platform analysis as a pre-architecture activity

---

### Path H: Non-Profit Platform with Civic/Social Mission
**Match profile**: Q1=A (non-profit specifically), Q2=B, Q3=A

**Recommended: Modular Monolith MVP with evolutionary roadmap OR Service-Based + Selective Event-Driven**

**Statistical basis:** Modular Monolith appears in 65 of 163 deep-validated Discovered repos (39.9%). It co-occurs with Event-Driven in 25 repos (the top co-occurring pair), making the "start modular, add event-driven communication" evolution path the most common configuration in real codebases.

Non-profit-specific repos are not separately tagged in Discovered, but the general pattern -- modular boundaries with low operational overhead -- aligns with the cost constraints of civic platforms.

**Production validation:** Production evidence for non-profit platforms is limited across all 5 sources. Orchard Core (RealWorld) as a modular monolith CMS demonstrates the pattern at production scale, though not in a non-profit context specifically.

**Why this works -- team reasoning:** Five KataLog challenges served non-profit organizations (Spotlight, Hey Blue!, Wildlife Watcher, ClearView, and the original Farmacy challenges). In every non-profit challenge, cost analysis separated winners from runners-up. Non-profit budgets cannot absorb infrastructure over-engineering. Judges rewarded cost-realism above architectural sophistication.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| PegasuZ | 1st | Spotlight Platform | Modular monolith MVP | "Why build a fortress if no one will live in it?" |
| MonArch | 1st | Hey Blue! | Modular monolith initial phase | $2,780/month GCP breakdown for 50K MAU |
| Pragmatic | 1st | ClearView | Service-based + selective event-driven | Token cost estimation with AI expert interview |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices (justified by integration complexity) | Integration analysis was the differentiator, not the style choice |

**Critical documentation**: A concrete cost analysis is mandatory for non-profit contexts. The per-user cost numbers (TheGlobalVariables' $0.002/user/month, Katamarans' $0.06/candidate, MonArch's $2,780/month) made architectures credible to non-profit stakeholders. Also consider partnership-over-build: Architects++ (3rd, Farmacy Family) chose Facebook Groups, Eventbrite, and WordPress over custom development, reducing the custom code surface area.

---

### Path I: Extreme Availability Requirements (99.99%+)
**Match profile**: Q2=D, specific high-availability SLA

**Recommended: Event-Driven + Microservices with multi-region deployment**

**Statistical basis:** Event-Driven appears in 47 of 163 deep-validated Discovered repos (28.8%) and co-occurs with Microservices in repos targeting high-scale domains. Among Infrastructure repos (7), high-availability patterns -- replication, partitioning, circuit breakers, bulkheads -- appear as standard production practices.

Space-Based appears in 5 repos (3.1%) -- dragonfly (30k stars), hazelcast (6k), ignite (5k). It is a niche pattern reserved for extreme scale requirements.

**Production validation:** NGINX (AOSA) serves over 30% of internet traffic through its event-driven, non-blocking architecture. Its master/worker process model allows zero-downtime configuration reloads and binary upgrades. Riak (AOSA) uses a masterless design that eliminates single points of failure, with tunable consistency that allows operators to trade consistency for availability per request. HDFS (AOSA) uses triple replication across racks, tolerating any two simultaneous failures while maintaining data availability.

**Why this works -- team reasoning:** The Road Warrior KataLog challenge demanded 99.99% availability for 15M users. 8 of 9 teams chose event-driven architecture. 99.99% availability requires fault isolation (event-driven decoupling), independent scaling (microservices or service-based), and geographic distribution. Event-driven architecture ensures that component failures do not cascade through synchronous call chains.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| Profitero Data Alchemists | 1st | Road Warrior | Pure event-driven with Rozanski/Woods viewpoints | 15 ADRs, chose evolvability over elasticity, security perspective covering 10 practice areas |
| Iconites | 2nd | Road Warrior | Microservices + event-driven + space-based | Cosmos DB global distribution, tiered business model, $496.95/month initial infrastructure |
| The Mad Katas | 3rd | Road Warrior | Zero trust with performance-aware authentication | Balanced security against performance; GDPR compliance |

**Caution about space-based**: Space-based architecture appeared only in Road Warrior (Iconites, 2nd place), which was the only challenge with extreme scale and availability requirements. It is appropriate only when you genuinely need in-memory data grids and partitioned caching at massive scale.

**Quantitative validation**: Street Fighters (Runner-up) performed quantitative load analysis estimating 25 requests/second for general traffic and 1,000 reservation updates/second at peak. This kind of volumetric analysis separates credible availability claims from aspirational ones.

---

### Path J: Compliance-Heavy with Health/Financial Data
**Match profile**: Q5=C

**Recommended: Architecture style driven by other factors, with compliance addressed through specific ADRs and structural separation**

**Statistical basis:** Banking/Finance repositories in the deep-validated Discovered corpus consistently prioritize Modularity alongside Deployability. DDD (29 repos, 17.8%) and Hexagonal (20 repos, 12.3%) provide compliance-friendly bounded contexts. Compliance-heavy domains favor clear module boundaries for audit scope isolation over any particular architecture style choice.

Compliance is a constraint on the architecture, not a driver of style selection.

**Production validation:** Bitwarden (RealWorld) maintains SOC 2 Type II, GDPR, CCPA, and HIPAA compliance in production on a Service-Based + Event-Driven architecture, demonstrating that compliance is achievable as a layered concern. Puppet (AOSA) implements compliance-as-code through idempotent configuration management with full auditability -- every configuration change is versioned, logged, and reproducible.

**Why this works -- team reasoning:** In KataLog competition, compliance load correlates with ADR quality importance, not architecture style choice. The Archangels (1st) used event-driven; ArchColider (1st) used modular monolith; Pragmatic (1st) used service-based. All addressed compliance through ADRs and structural patterns layered on top of their primary style. Teams that mentioned compliance as a quality attribute without specific architectural responses consistently placed lower.

| Team | Placement | Challenge | Compliance Approach | Key Detail |
|------|-----------|-----------|---------------------|------------|
| The Archangels | 1st | Farmacy Family | Crypto-shredding for GDPR (ADR-005) | Full C4 hierarchy, RAID log, the "gold standard" submission |
| ArchColider | 1st | Farmacy Food | Zero trust from day one (ADR-006) | PCI-DSS addressed through payment processor delegation (Stripe) |
| Pragmatic | 1st | ClearView | PII as cross-cutting concern | Architecture constrains AI to prevent bias, not just process PII |
| ZAITects | 1st | Certifiable Inc. | OWASP Top 10 for LLM security analysis | Certification integrity through confidence-based human escalation |
| Wildlife Watchers | Runner-up | Wildlife Watcher | Internal CA with Mutual TLS for camera auth | Geoprivacy for endangered species locations |

**Critical documentation**: Specific ADRs addressing concrete security and compliance decisions. Reference specific standards (NIST 800-111, HIPAA-eligible AWS services, OWASP Top 10). Teams that mentioned compliance as a quality attribute without backing it with concrete decisions consistently placed lower.

**Anti-pattern**: Listing "security" as a quality attribute without backing it with concrete decisions. Security appeared in 37 of 78 submissions but predicted placement only when backed by specific ADRs.

---

## Step 3: Validate with Quality Attributes

After choosing your architecture path, identify your top 3 quality attributes and use this table to strengthen your approach. The "Discovered Detection" column shows how frequently this QA appears in the 163-repo deep-validated corpus. The "Production Examples" column shows which AOSA/RealWorld systems validate the recommended approach.

> **Detection bias note:** Discovered QA detection relies on filesystem signals. Deployability (89%) is inflated by Docker/CI prevalence. Performance, Testability, and Interoperability are underdetected -- the absence of Discovered signal does not mean the QA is unimportant. KataLog competition evidence fills this gap by documenting QA priorities that are invisible in code.

| If your top priority is... | Discovered Detection | Predictive Power (KataLog) | Strengthen with... | Production Examples | Watch out for... | Study this team |
|---------------------------|---------------------|---------------------------|-------------------|---------------------|-----------------|-----------------|
| **Cost/Feasibility** | Not directly detectable | Very Strong (3.2x winner ratio) | Modular monolith (avg 3.0 for cost-focused teams), concrete cost projections, partnership-over-build | Orchard Core (RealWorld): modular monolith in production; 65 Discovered MM repos (39.9%) | Hidden cloud costs; LLM API cost runaway in AI systems | ArchColider ($12K-$23K/yr scenarios), TheGlobalVariables ($0.002/user/mo) |
| **Deployability** | 108 repos (89%) | -- | Docker/CI pipelines (standard practice in 89% of repos); container orchestration | NGINX (AOSA): zero-downtime reloads; Bitwarden (RealWorld): containerized deployment | Over-investing in deployment automation for simple systems | All paths -- deployability is table stakes |
| **Modularity** | 41 repos (34%) | -- | Clear module boundaries, DDD bounded contexts | Orchard Core (RealWorld): plugin-based modularity; 65 Discovered MM repos + 33 Plugin repos with modularity signals | Module boundaries without enforcement; boundary erosion over time | PegasuZ (quantum-level architecture), ArchColider (DDD boundaries) |
| **Data Integrity** | Not directly detectable | Strong (60% top-3 rate) | Service-based (avg 2.5 for integrity-focused teams), explicit consistency trade-off documentation | Riak (AOSA): tunable consistency per request; HDFS (AOSA): triple replication | Claiming strong consistency in distributed systems without addressing the implications | Pragmatic (ADR-004: deliberately downplayed integrity with documented rationale) |
| **Scalability** | 33 repos (27%) | Weak (33% top-3 rate) | Targeted mechanisms (scaling groups, CQRS, queue decoupling) rather than whole-system style | NGINX (AOSA): event-driven scaling; Graphite (AOSA): pipeline scaling | The "Scalability Trap" -- 68% of runners-up cite it vs. 55% of winners | BluzBrothers (ADR-008: deliberately scoped to 500-patient ceiling) |
| **Interoperability** | Plugin/Microkernel: 33 repos (20.2%) | Strong (60% top-3 rate) | Event-driven (avg 2.33 for interop-focused teams), adapter-based integration, comparative platform analysis | LLVM (AOSA): plugin-based multi-frontend; Selenium (AOSA): adapter-per-browser; Jellyfin (RealWorld): plugin extensibility; n8n (177k), elasticsearch (76k) | Underestimating integration effort for diverse external APIs | CELUS Ceals (platform-by-platform analysis), Pragmatic (adapter-based HR integration) |
| **Fault Tolerance** | 18 repos (15%) | Moderate (1.5x winner ratio) | Event-driven decoupling, circuit breakers, graceful degradation mapping | NGINX (AOSA): master/worker fault isolation; Riak (AOSA): masterless design | Binary availability claims without degradation mapping | LowCode (3-node/2-node/1-node graceful degradation) |
| **Performance** | Not directly detectable | Moderate (49% top-3 rate) | Event-driven (avg 2.0), time-series databases for high-frequency data, quantitative fitness functions | NGINX (AOSA): event-driven C10K+; Graphite (AOSA): high-frequency metrics pipeline | Assuming instead of measuring; listing performance without calculations | BluzBrothers (693ms proof), Street Fighters (25 req/s + 1,000 updates/s analysis) |
| **Evolvability** | DDD: 29 repos (17.8%); Hexagonal: 20 repos (12.3%) | Moderate (43% top-3 rate) | Modular monolith (avg 4.0), hexagonal ports, plugin architectures, explicit extraction points | nopCommerce (RealWorld): 17-year evolution; GStreamer (AOSA): plugin-based extensibility; 33 Discovered Plugin repos | Premature abstraction; building for evolution you never execute | Software Architecture Guild (microkernel for 6 AI variants), Wonderous Toys (microkernel for plugins) |
| **Security** | Not directly detectable | Moderate (38% top-3 rate) | Modular monolith (avg 3.25 for security-focused teams), zero-trust, specific ADRs | Bitwarden (RealWorld): SOC 2/GDPR/HIPAA compliant; Puppet (AOSA): compliance-as-code | Listing security generically without concrete decisions | ArchColider (ADR-006: zero trust), The Archangels (crypto-shredding, ADR-005) |
| **Simplicity** | Not directly detectable | Moderate (50% top-3 rate) | Modular monolith (avg 2.33), service-based, buy-over-build decisions | Orchard Core (RealWorld): modular monolith simplicity; Git (AOSA): simple object model | False economy of "simple" microservices; simplicity does not mean under-engineering | Wonderous Toys (modular monolith + microkernel), Architects++ (Facebook Groups + Eventbrite over custom build) |
| **Observability** | 4 repos (3%) -- underdetected | Moderate (46% top-3 rate) | Service-based (avg 2.25), LLM-specific observability (LangFuse, Langwatch) in AI systems | Graphite (AOSA): production observability pipeline; 3 Observability Discovered repos | Treating observability as an afterthought; addressed by <20% of teams | ConnectedAI (LangFuse for LLM tracing), ZAITects (Langwatch for LLM observability) |

### The Quality Attribute Decision: What Winners Do Differently

The strongest quality-attribute signal in the dataset: **cost/feasibility awareness**. 45% of first-place winners explicitly prioritize cost or feasibility, compared to only 14% of runners-up. This 3.2x ratio is the strongest quality-attribute predictor of placement.

Other winner-distinctive attributes:
- **Data Integrity**: 27% of winners vs. 14% of runners-up (1.9x)
- **Fault Tolerance**: 27% of winners vs. 18% of runners-up (1.5x)
- **Accuracy**: Emerges as distinctive in AI-era katas (3 of 4 most recent winners prioritize it)

The weakest signal: **Scalability**. It is the most commonly cited attribute overall but is less common among winners than among runners-up. Over-indexing on scalability at the expense of pragmatic concerns may actually be a negative signal.

---

## Quick Reference Card

One-page summary ranked by Discovered frequency -- how architects actually build software in the 163-repo deep-validated corpus.

### Architecture Selection by Problem Profile

| Your Situation | Recommended Approach | Discovered Frequency | Top Team to Study | Production Validation | Key Artifact to Include |
|---------------|---------------------|---------------------|-------------------|----------------------|------------------------|
| Startup/nonprofit, small-medium scale | Modular Monolith with evolution path | 65 repos (39.9%) | ArchColider (1st, Farmacy Food) | Orchard Core (RealWorld). Notable: AutoGPT (182k), n8n (177k) | Cost analysis with dollar amounts |
| Large scale, event-heavy | Event-Driven + Service-Based | 47 EDA repos (28.8%), 11 SB repos (6.7%) | Pragmatic (1st, ClearView) | NGINX (AOSA), Bitwarden (RealWorld), Graphite (AOSA) | Volumetric analysis with load calculations |
| Legacy migration | Service-Based + phased transition | 11 repos (6.7%) | Team Seven (1st, Sysops Squad) | nopCommerce (RealWorld), Selenium (AOSA) | Transition architecture diagram |
| Healthcare/medical, real-time | Event-Driven, on-premises | 47 EDA repos (28.8%) | BluzBrothers (1st, MonitorMe) | Graphite (AOSA) -- analogous pipeline pattern | Fitness functions with latency proof |
| AI is the core product | Service-Based + human-in-the-loop | 16 AI/ML repos (9.8%), 11 Multi-Agent repos (6.7%) | ZAITects (1st, Certifiable Inc.) | Notable: AutoGPT (182k), langchain (128k), autogen (55k) | LLM evaluation framework + cost projection |
| IoT/Edge with offline | Event-Driven core, pragmatic edge deployment | 47 EDA repos (28.8%) | CELUS Ceals (1st, Wildlife Watcher) | Git (AOSA), Puppet (AOSA), Bitwarden (RealWorld) | Physical constraint quantification |
| High integration complexity | Per-quantum style selection, Plugin/Microkernel | 53 DevTools repos (32.5%), 33 Plugin repos (20.2%) | CELUS Ceals (1st, Wildlife Watcher) | LLVM (AOSA), GStreamer (AOSA), Selenium (AOSA), Jellyfin (RealWorld) | Comparative external platform analysis |
| Non-profit platform | Modular Monolith MVP or Service-Based | 65 MM repos (39.9%) | PegasuZ (1st, Spotlight) | Limited -- competition evidence is primary | Per-user cost calculation |
| 99.99%+ availability | Event-Driven + Microservices | 47 EDA + 16 MS repos | Profitero Data Alchemists (1st, Road Warrior) | NGINX (AOSA), Riak (AOSA), HDFS (AOSA) | Rozanski/Woods multi-viewpoint framework |
| Compliance-heavy (HIPAA, GDPR) | Style per other factors + compliance ADRs | DDD: 29 repos (17.8%), Hexagonal: 20 repos (12.3%) | The Archangels (1st, Farmacy Family) | Bitwarden (RealWorld), Puppet (AOSA) | Compliance-specific ADRs citing standards |

### The Five Things Winners Always Do

Based on the statistically derived "Winning Formula" (80% retrospective accuracy):

1. **Document 15+ decisions** with well-structured ADRs showing trade-off reasoning
2. **Include feasibility analysis** demonstrating cost awareness and practical constraints (4.5x placement impact)
3. **Use C4 diagrams** at multiple levels to communicate architecture at different granularities
4. **Adopt event-driven patterns** as a primary or supporting style -- 47 of 163 Discovered repos (28.8%) use EDA, and 73% of KataLog winners do the same
5. **Propose evolutionary approaches** with phased roadmaps from MVP to target state (73% of winners)

### Style Combinations Cheat Sheet

| Combination | Discovered Co-occurrence | Production Examples | Verdict |
|-------------|------------------------|---------------------|---------|
| Event-Driven + Modular Monolith | 25 repos (top co-occurring pair) | Orchard Core (RealWorld) | Most common configuration in real codebases |
| Modular Monolith + Plugin/Microkernel | 19 repos (2nd most common pair) | Orchard Core, Jellyfin, n8n (177k), elasticsearch (76k) | Deep-validated; invisible under prior automated detection |
| Layered + Modular Monolith | 16 repos | nopCommerce (RealWorld) | Layered internal structure within modular boundaries |
| DDD + Hexagonal | 15 repos | CleanArchitecture (19k), domain-driven-hexagon (14k) | Clean boundaries for complex domains |
| CQRS + DDD | 15 repos | CleanArchitecture (19k), modular-monolith-with-ddd (13k) | Production-validated for content management |
| Event-Driven + Service-Based | Across domains | Bitwarden (RealWorld), Graphite (AOSA) | Best-performing KataLog combination (2.57 avg) |
| Event-Driven + Pipeline | Across domains | NGINX (AOSA), GStreamer (AOSA) | Production-validated at extreme scale |
| Plugin + Pipeline | Now detectable via deep validation | LLVM (AOSA), GStreamer (AOSA) | Production-validated for extensible processing |
| 3+ complementary styles | Common in Discovered | LLVM (AOSA): Pipeline + Plugin + Layered | Outperforms single-style and two-style approaches in KataLog (2.36-2.67 avg) |
| Event-Driven + Microservices | Less common than prior estimates | -- | Most common KataLog combo but worst-performing (1.29 avg); 0 production systems |
| Microservices alone (no EDA) | 16 MS repos (9.8%), 0 production systems | -- | Anti-pattern: microservices without async decoupling (1.70 avg) |

---

*Generated: 2026-03-06 from structured metadata of 266 entries across 5 sources: 78 KataLog competition submissions (Fall 2020 -- Winter 2025), 12 AOSA production systems, 5 RealWorldASPNET production apps, 8 reference implementations, and 163 Discovered open-source repositories (deep-validated via source code inspection per SPEC-019). Source data: `docs/reference-library/problem-spaces.md`, `docs/reference-library/solution-spaces.md`, `docs/reference-library/evidence/by-quality-attribute.md`, `docs/analysis/cross-cutting.md`.*
