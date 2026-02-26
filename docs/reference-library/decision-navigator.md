# Architecture Decision Navigator

A practitioner-facing guide for navigating from problem characteristics to evidence-based architectural recommendations. Every recommendation is backed by specific team evidence from 78 O'Reilly Architecture Kata submissions across 11 challenges (Fall 2020 -- Winter 2025).

---

## How to Use This Guide

1. **Answer the 8 questions in Step 1** to classify your problem across key dimensions.
2. **Follow the matching path in Step 2** based on your answers. Each path gives you a recommended architecture approach, the evidence behind it, and specific teams to study.
3. **Validate with quality attributes in Step 3** to strengthen your approach for your specific priorities.
4. **Choose your documentation strategy in Step 4** to prioritize the artifacts that will have the highest impact for your context.
5. **Check the Quick Reference Card** at the end for a one-page summary.

This guide is designed for sequential use -- work through Steps 1 through 4 in order. The entire process should take 15-30 minutes and will give you a specific, evidence-backed starting point for your architecture.

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

Find the path that best matches your answer profile. If you match multiple paths, read all of them and synthesize -- winners in the dataset frequently combined insights from multiple problem dimensions.

---

### Path A: Budget-Constrained + Small-to-Medium Scale
**Match profile**: Q1=A, Q2=A or B

**Recommended: Modular Monolith with documented evolution path to Service-Based or Microservices**

**Evidence**: Modular Monolith has the highest average placement score (3.00) of any architecture style in the dataset. All 3 first-place Modular Monolith teams won their respective competitions. In budget-constrained contexts specifically, the "start simple, evolve deliberately" approach is undefeated.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| ArchColider | 1st | Farmacy Food | Modular monolith + event sourcing + DDD | Three-scenario cost model: $12K--$23K/year. Won against 9 teams, 6 of which chose microservices. |
| PegasuZ | 1st | Spotlight Platform | Modular monolith MVP evolving to microservices + event-driven | Asked "Why build a fortress if no one will live in it?" Defined quantum boundaries for later extraction. |
| MonArch | 1st | Hey Blue! | Modular monolith initial phase evolving to microservices | Projected $2,780/month on GCP for 50K MAU. Began modular, planned service extraction. |

**Why this works**: Judges consistently rewarded cost-realism over architectural ambition in non-profit and startup contexts. Teams that defaulted to microservices in budget-constrained settings averaged lower placement scores. The modular monolith reduces infrastructure cost, operational complexity, and time-to-market while preserving the ability to extract services later.

**Critical documentation**: Include a concrete cost analysis. In non-profit/startup challenges, every first-place winner included some form of cost analysis. Feasibility analysis is the strongest single predictor of placement: teams with it are 4.5x more likely to place in the top 2.

**Also study**: TheGlobalVariables (3rd, Spotlight) calculated $0.002/user/month with serverless microservices. Arch8s (Runner-up, Spotlight) used a hybrid modular monolith + service-based + serverless approach.

---

### Path B: Large Scale + Event-Heavy Workloads
**Match profile**: Q2=C or D, Q6=B or C

**Recommended: Event-Driven Architecture + Service-Based (NOT microservices-first)**

**Evidence**: The combination of Event-Driven + Service-Based averages 2.57 placement points per team with 3 first-place wins out of 7 teams. Event-Driven + Microservices, despite being the most common combination (17 teams), averages only 1.29 points per team. This is the single largest performance gap between any two style combinations in the dataset.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| Pragmatic | 1st | ClearView | Service-based with selective event-driven | 22 ADRs, DDD/Event Storming, AI feasibility analysis |
| ZAITects | 1st | Certifiable Inc. | Service-based with event-driven hybrid | 18 ADRs, comprehensive LLM production stack |
| Team Seven | 1st | Sysops Squad | Service-based with event-driven message queues | 12 ADRs, phased migration plan with transition architecture |
| Profitero Data Alchemists | 1st | Road Warrior | Pure event-driven | Rozanski/Woods viewpoints, 15 ADRs, chose evolvability over elasticity |

**Why this works**: Service-based architecture provides coarser-grained services that are simpler to operate than microservices, while event-driven patterns provide the asynchronous decoupling needed at scale. Microservices-only teams (no EDA) averaged just 1.70 points. EDA-only teams (no microservices) averaged 2.44. Microservices without event-driven architecture is an anti-pattern -- pure synchronous microservices create tight coupling through REST chains.

**Watch out for**: The "Scalability Trap." Scalability is cited by 68% of runners-up but only 55% of first-place winners. Do not let scalability drive your entire architecture. Address it through targeted mechanisms (scaling groups, CQRS, queue-based decoupling) rather than choosing an entire architecture style for scalability alone.

**Also study**: Iconites (2nd, Road Warrior) combined microservices + event-driven + space-based with Cosmos DB global distribution for the highest-scale challenge. BluzBrothers (1st, MonitorMe) used pure event-driven with Kafka to meet critical latency requirements.

---

### Path C: Legacy Migration (Brownfield)
**Match profile**: Q3=B

**Recommended: Service-Based Architecture with phased transition plan**

**Evidence**: In the Sysops Squad challenge (the only pure brownfield-migration kata), 6 of 7 teams chose service-based architecture. The top 3 placements (1st, 2nd, 3rd) all used service-based. In the Certifiable Inc. challenge (brownfield extension), 6 of 7 teams also chose service-based, and the 1st and 2nd place teams both used it.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| Team Seven | 1st | Sysops Squad | Service-based + event-driven message queues | Centered submission on transition architecture, not just target state. Phased migration plan. |
| ArchElekt | 2nd | Sysops Squad | Service-based | Documented migration from monolith with operational continuity |
| Sever Crew | 2nd | Farmacy Family | Service-based with event-driven Kafka integration layer | Extended an existing system with event-driven bridge |
| ZAITects | 1st | Certifiable Inc. | Service-based + event-driven | Extended existing SoftArchCert platform with AI grading capabilities |

**Why this works**: The cross-cutting analysis explicitly states: "The transition architecture matters more than the target architecture." Service-based architecture decomposes the monolith into a manageable number of coarse-grained services (typically 5-12) rather than attempting a big-bang migration to dozens of microservices. This makes incremental migration feasible.

**Critical documentation**: Include a transition architecture showing the phased migration path from current state to target state. Teams that proposed only a target-state architecture without a phased migration plan rarely placed in the top 2. 73% of first-place winners propose phased approaches.

**Anti-pattern to avoid**: Big-bang architecture without an evolution path. A perfect target architecture without a realistic path from the present is less valuable than an achievable initial architecture with a clear evolution roadmap.

**Also study**: Hey Dragon (3rd, Sysops Squad) proposed a 3-stage evolution: Monolith to Service-Based to Microservices. Global Architects (Runner-up, Sysops Squad) proposed an ML chatbot for demand reduction -- a creative non-architectural mitigation.

---

### Path D: Healthcare/Medical with Real-Time Requirements
**Match profile**: Q5=C (healthcare), Q6=C (hard real-time)

**Recommended: Event-Driven Architecture, on-premises deployment**

**Evidence**: All 7 MonitorMe teams chose event-driven architecture -- the strongest per-challenge consensus in the dataset. The winner proved quantitative compliance with latency SLAs.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| BluzBrothers | 1st | MonitorMe | Pure event-driven with Kafka | 20 ADRs, quantitative fitness functions, proved 693ms end-to-end latency against 1-second SLA. Infrastructure sizing proof for 500 patients. |
| Mighty Orbots | 2nd | MonitorMe | Microservices + event-driven | ELT pipeline prioritizing data integrity by loading raw data immediately. |
| LowCode | 3rd (tied) | MonitorMe | Distributed hardware with event-driven | 3-node role-based failover: Coordinator/Monitor/Analyzer. Mapped graceful degradation at each failure level. |

**Why this works**: Medical monitoring generates continuous high-frequency events (heart rate at 500ms, ECG at 1s, blood pressure at 1hr). Event-driven architecture is the natural fit for processing heterogeneous event streams with different cadences. On-premises deployment removes cloud latency from the critical path.

**Critical documentation**: Include quantitative fitness functions. BluzBrothers won by proving their architecture met the SLA through calculations, not claims. Also design explicit graceful degradation -- LowCode's 3-node/2-node/1-node failure state mapping was more valuable than generic "high availability" claims.

**Technology choices**: Time-series databases (InfluxDB) were the consensus for vital sign storage, achieving the highest per-team average placement score (2.67) of any database category. Apache Kafka was the dominant event broker.

**Scope decision**: BluzBrothers deliberately downplayed scalability (ADR-008) since the system had a fixed 500-patient ceiling. This mature scoping decision was noted as a strength, not a weakness.

---

### Path E: AI as the Core Product
**Match profile**: Q7=C

**Recommended: Service-Based Architecture + Human-in-the-Loop + Deterministic Boundaries**

**Evidence**: Across the three AI-centric challenges (ShopWise AI, ClearView, Certifiable Inc.), service-based architecture was the most successful foundation. In Certifiable Inc., 6 of 7 teams chose service-based; in ClearView, the winner (Pragmatic) used service-based + selective event-driven. Every team in the high-stakes Certifiable Inc. challenge implemented human-in-the-loop oversight -- no team proposed fully autonomous AI.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| ConnectedAI | 1st | ShopWise AI | Multi-agent supervisor with LangGraph | Quantitative LLM evaluation using Ragas framework (faithfulness, relevancy). Working prototype. Dual-LLM strategy (Claude for reasoning, Gemini Flash for routing). |
| Pragmatic | 1st | ClearView | Service-based + selective event-driven | Deterministic matching: extract features with LLM, then match deterministically. Reduced LLM calls from O(n*m) to O(n+m). 22 ADRs. |
| ZAITects | 1st | Certifiable Inc. | Service-based + event-driven | Separated Grader from Judge (LLM-as-a-Judge pattern). Projected 80% cost reduction. OWASP Top 10 for LLM security. Langwatch for LLM observability. |
| Litmus | 2nd | Certifiable Inc. | Service-based | Confidence-based escalation to human reviewers. |

**Why this works**: AI systems need deterministic boundaries around non-deterministic components. Service-based architecture provides clear service boundaries where AI behavior can be constrained, monitored, and overridden. The winners built architecture TO CONSTRAIN the AI, not just to enable it.

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

**Evidence**: The Wildlife Watcher and MonitorMe challenges both required edge/offline capability. The winners diverged in style (CELUS Ceals used microservices; BluzBrothers used pure event-driven), but the consistent pattern was: event-driven communication between edge and cloud, with pragmatic deployment (not microservices) at the edge.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| CELUS Ceals | 1st | Wildlife Watcher | Microservices with iterative delivery | 15 ADRs, extensive C4 modeling, thorough 3rd-party integration analysis across all 8+ platforms |
| Rapid Response | 2nd | Wildlife Watcher | Microservices with monolith-first deployment | Designed for monolith deployment at the edge. Quantified LoRaWAN constraints: 31KB image = 240 seconds. |
| BluzBrothers | 1st | MonitorMe | Pure event-driven on-premises | 20 ADRs, duplicate instances for availability, all processing on local appliance hardware |
| LowCode | 3rd (tied) | MonitorMe | Distributed hardware with role-based failover | Auto-configuration for plug-and-play appliance replacement. 3-node graceful degradation. |
| Wonderous Toys | 3rd | Wildlife Watcher | Modular monolith + microkernel | Chose modular monolith for cost-effectiveness; microkernel for integration extensibility |

**Why this works**: Edge constraints are physical, not just architectural. The bandwidth, power, and compute limitations of edge hardware demand quantitative analysis, not abstract design. Event-driven architecture handles the inherently asynchronous nature of edge-to-cloud communication (cameras upload when connectivity permits; appliances buffer when network drops).

**Critical documentation**: Quantify your physical constraints. Rapid Response's bandwidth calculation (31KB over LoRaWAN = 240 seconds) drove real design decisions that abstract analysis would have missed. LowCode's graceful degradation mapping (full function with 3 nodes, full function with 2, alerting-only with 1) addressed operational reality.

**Caution**: EDA teams in Wildlife Watcher averaged only 1.3 placement score -- the lowest for any challenge. This suggests event-driven may be over-applied in IoT/edge contexts where simpler patterns suffice. Let your physical constraints, not architectural fashion, drive the decision.

---

### Path G: High Integration Complexity + Enterprise Budget
**Match profile**: Q4=C, Q1=B or C

**Recommended: Per-quantum style selection with adapter/connector patterns**

**Evidence**: When integration complexity is the dominant concern, the most successful teams selected architecture styles at the bounded-context (quantum) level rather than imposing a single system-wide style.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| PegasuZ | 1st | Spotlight Platform | Identified architectural quanta, selected styles per quantum | Modular monolith for core, event-driven for notifications, serverless for analytics |
| Pragmatic | 1st | ClearView | Adapter-based HR integration with event-driven triggers | Named interoperability as top quality attribute. Designed adapter per HR system type. |
| CELUS Ceals | 1st | Wildlife Watcher | Comparative analysis of all 8+ external platforms | Evaluated labeling platforms across deployment model, API availability, upload mechanisms |
| Wonderous Toys | 3rd | Wildlife Watcher | Microkernel/plugin for integration extensibility | Plugin architecture so new integrations can be added without core changes |

**Why this works**: High integration complexity means different external systems have different communication patterns, data formats, authentication mechanisms, and reliability characteristics. A single system-wide style cannot optimize for all of them. Per-quantum style selection matches the architecture to the integration requirements of each bounded context.

**Critical documentation**: Produce a comparative analysis of all external systems you must integrate with. CELUS Ceals' platform-by-platform evaluation (API availability, deployment model, upload mechanism) was cited as a key differentiator. Also document vendor research as an architectural activity -- Jaikaturi (2nd, Farmacy Food) discovered ChefTec integration costs ranged from $500 to $5,000+ only by contacting the vendor directly.

**Pattern by integration tier**:
- **Medium (3-5 systems)**: Adapter pattern, dedicated integration services, webhook-based communication
- **High (6+ systems)**: Event-driven integration backbone (Kafka appeared in 5/7 Farmacy Family submissions), dedicated modules per external system
- **Very High (8+ systems)**: Microkernel/plugin architecture for extensibility, comparative platform analysis as a pre-architecture activity

---

### Path H: Non-Profit Platform with Civic/Social Mission
**Match profile**: Q1=A (non-profit specifically), Q2=B, Q3=A

**Recommended: Modular Monolith MVP with evolutionary roadmap OR Service-Based + Selective Event-Driven**

**Evidence**: Five kata challenges served non-profit organizations (Spotlight, Hey Blue!, Wildlife Watcher, ClearView, and the original Farmacy challenges for a startup). In every non-profit challenge, cost analysis separated winners from runners-up. The pattern that won most consistently: start with the simplest viable architecture, document the evolution path.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| PegasuZ | 1st | Spotlight Platform | Modular monolith MVP | "Why build a fortress if no one will live in it?" |
| MonArch | 1st | Hey Blue! | Modular monolith initial phase | $2,780/month GCP breakdown for 50K MAU |
| Pragmatic | 1st | ClearView | Service-based + selective event-driven | Token cost estimation with AI expert interview |
| CELUS Ceals | 1st | Wildlife Watcher | Microservices (justified by integration complexity) | Integration analysis was the differentiator, not the style choice |

**Why this works**: Non-profit budgets cannot absorb infrastructure over-engineering. Judges in these contexts rewarded cost-realism above architectural sophistication. The per-user cost numbers (TheGlobalVariables' $0.002/user/month, Katamarans' $0.06/candidate, MonArch's $2,780/month) made architectures credible to non-profit stakeholders.

**Critical documentation**: A concrete cost analysis is mandatory for non-profit contexts. Also consider partnership-over-build: Architects++ (3rd, Farmacy Family) chose Facebook Groups, Eventbrite, and WordPress over custom development, reducing the custom code surface area.

---

### Path I: Extreme Availability Requirements (99.99%+)
**Match profile**: Q2=D, specific high-availability SLA

**Recommended: Event-Driven + Microservices with multi-region deployment**

**Evidence**: The Road Warrior challenge demanded 99.99% availability (max 5 minutes unplanned downtime/month) for 15M users. 8 of 9 teams chose event-driven architecture.

| Team | Placement | Challenge | Approach | Key Detail |
|------|-----------|-----------|----------|------------|
| Profitero Data Alchemists | 1st | Road Warrior | Pure event-driven with Rozanski/Woods viewpoints | 15 ADRs, chose evolvability over elasticity, security perspective covering 10 practice areas |
| Iconites | 2nd | Road Warrior | Microservices + event-driven + space-based | Cosmos DB global distribution, tiered business model, $496.95/month initial infrastructure |
| The Mad Katas | 3rd | Road Warrior | Zero trust with performance-aware authentication | Balanced security against performance; GDPR compliance |

**Why this works**: 99.99% availability requires fault isolation (event-driven decoupling), independent scaling (microservices or service-based), and geographic distribution. Event-driven architecture ensures that component failures do not cascade through synchronous call chains.

**Caution about space-based**: Space-based architecture appeared only in Road Warrior (Iconites, 2nd place), which was the only challenge with extreme scale and availability requirements. It is appropriate only when you genuinely need in-memory data grids and partitioned caching at massive scale.

**Quantitative validation**: Street Fighters (Runner-up) performed quantitative load analysis estimating 25 requests/second for general traffic and 1,000 reservation updates/second at peak. This kind of volumetric analysis separates credible availability claims from aspirational ones.

---

### Path J: Compliance-Heavy with Health/Financial Data
**Match profile**: Q5=C

**Recommended: Architecture style driven by other factors, with compliance addressed through specific ADRs and structural separation**

**Evidence**: In the cross-cutting analysis, compliance load correlates with ADR quality importance, not with architecture style choice. In high-compliance challenges, top teams documented compliance decisions with specific ADRs rather than letting compliance drive the entire architecture style.

| Team | Placement | Challenge | Compliance Approach | Key Detail |
|------|-----------|-----------|---------------------|------------|
| The Archangels | 1st | Farmacy Family | Crypto-shredding for GDPR (ADR-005) | Full C4 hierarchy, RAID log, the "gold standard" submission |
| ArchColider | 1st | Farmacy Food | Zero trust from day one (ADR-006) | PCI-DSS addressed through payment processor delegation (Stripe) |
| Pragmatic | 1st | ClearView | PII as cross-cutting concern | Architecture constrains AI to prevent bias, not just process PII |
| ZAITects | 1st | Certifiable Inc. | OWASP Top 10 for LLM security analysis | Certification integrity through confidence-based human escalation |
| Wildlife Watchers | Runner-up | Wildlife Watcher | Internal CA with Mutual TLS for camera auth | Geoprivacy for endangered species locations |

**Why this works**: Compliance is a constraint on the architecture, not a driver of style selection. The Archangels (1st) used event-driven; ArchColider (1st) used modular monolith; Pragmatic (1st) used service-based. All addressed compliance through ADRs and structural patterns layered on top of their primary style.

**Critical documentation**: Specific ADRs addressing concrete security and compliance decisions. Reference specific standards (NIST 800-111, HIPAA-eligible AWS services, OWASP Top 10). Teams that mentioned compliance as a quality attribute without specific architectural responses consistently placed lower.

**Anti-pattern**: Listing "security" as a quality attribute without backing it with concrete decisions. Security appeared in 37 of 78 submissions but predicted placement only when backed by specific ADRs.

---

## Step 3: Validate with Quality Attributes

After choosing your architecture path, identify your top 3 quality attributes and use this table to strengthen your approach. The "Predictive Power" column indicates how strongly prioritizing this attribute correlates with high placement.

| If your top priority is... | Avg Placement Score | Predictive Power | Strengthen with... | Watch out for... | Study this team |
|---------------------------|--------------------|--------------------|-------------------|-----------------|-----------------|
| **Cost/Feasibility** | 2.00 | Very Strong (3.2x winner ratio) | Modular monolith (avg 3.0 for cost-focused teams), concrete cost projections, partnership-over-build | Hidden cloud costs; LLM API cost runaway in AI systems | ArchColider ($12K-$23K/yr scenarios), TheGlobalVariables ($0.002/user/mo) |
| **Data Integrity** | 2.20 | Strong (60% top-3 rate) | Service-based (avg 2.5 for integrity-focused teams), explicit consistency trade-off documentation | Claiming strong consistency in distributed systems without addressing the implications | Pragmatic (ADR-004: deliberately downplayed integrity with documented rationale) |
| **Interoperability** | 2.07 | Strong (60% top-3 rate) | Event-driven (avg 2.33 for interop-focused teams), adapter-based integration, comparative platform analysis | Underestimating integration effort for diverse external APIs | CELUS Ceals (platform-by-platform comparative analysis), Pragmatic (adapter-based HR integration) |
| **Performance** | 1.93 | Moderate (49% top-3 rate) | Event-driven (avg 2.0), time-series databases for high-frequency data, quantitative fitness functions | Assuming instead of measuring; listing performance without calculations | BluzBrothers (693ms proof), Street Fighters (25 req/s + 1,000 updates/s analysis) |
| **Evolvability** | 1.89 | Moderate (43% top-3 rate) | Modular monolith (avg 4.0), hexagonal ports, plugin architectures, explicit extraction points | Premature abstraction; building for evolution you never execute | Software Architecture Guild (microkernel for 6 parallel AI variants), Wonderous Toys (microkernel for integration plugins) |
| **Security** | 1.82 | Moderate (38% top-3 rate) | Modular monolith (avg 3.25 for security-focused teams), zero-trust, separate security groups, specific ADRs | Listing security generically without concrete decisions | ArchColider (ADR-006: zero trust), The Archangels (crypto-shredding, ADR-005) |
| **Availability** | 1.79 | Moderate (40% top-3 rate) | Modular monolith (avg 3.67), event-driven (avg 1.86), explicit graceful degradation design | Binary availability claims without degradation mapping | LowCode (3-node/2-node/1-node graceful degradation), BluzBrothers (ADR-018/020: duplicate instances) |
| **Scalability** | 1.75 | Weak (33% top-3 rate) | Targeted mechanisms (scaling groups, CQRS, queue decoupling) rather than whole-system style | The "Scalability Trap" -- 68% of runners-up cite it vs. 55% of winners | BluzBrothers (ADR-008: deliberately scoped to 500-patient ceiling) |
| **Simplicity** | 1.83 | Moderate (50% top-3 rate) | Modular monolith (avg 2.33), service-based, buy-over-build decisions | False economy of "simple" microservices; simplicity does not mean under-engineering | Wonderous Toys (modular monolith + microkernel), Architects++ (Facebook Groups + Eventbrite over custom build) |
| **Observability** | 2.00 | Moderate (46% top-3 rate) | Service-based (avg 2.25), LLM-specific observability (LangFuse, Langwatch) in AI systems | Treating observability as an afterthought; addressed by <20% of teams | ConnectedAI (LangFuse for LLM tracing), ZAITects (Langwatch for LLM observability) |

### The Quality Attribute Decision: What Winners Do Differently

The strongest quality-attribute signal in the dataset: **cost/feasibility awareness**. 45% of first-place winners explicitly prioritize cost or feasibility, compared to only 14% of runners-up. This 3.2x ratio is the strongest quality-attribute predictor of placement.

Other winner-distinctive attributes:
- **Data Integrity**: 27% of winners vs. 14% of runners-up (1.9x)
- **Fault Tolerance**: 27% of winners vs. 18% of runners-up (1.5x)
- **Accuracy**: Emerges as distinctive in AI-era katas (3 of 4 most recent winners prioritize it)

The weakest signal: **Scalability**. It is the most commonly cited attribute overall but is less common among winners than among runners-up. Over-indexing on scalability at the expense of pragmatic concerns may actually be a negative signal.

---

## Step 4: Choose Your Documentation Strategy

Based on the cross-cutting analysis, documentation completeness strongly predicts placement. Here is what to prioritize based on your context.

### Universal Must-Haves (all contexts)

These artifacts are correlated with winning regardless of problem type:

| Artifact | Top-2 Rate | Runner-up Rate | Impact | Threshold |
|----------|-----------|---------------|--------|-----------|
| **ADRs (12+)** | 73% of winners have 12+ | 27% of runners-up meet this | Very Strong | Target 15 ADRs. Mean for 1st-place: 15.0; mean for runners-up: 8.5 |
| **Feasibility/Cost Analysis** | 50% of top-2 | 11% of runners-up | Very Strong (4.5x) | Include quantitative numbers, not just qualitative assessment |
| **Deployment View** | 82% of 1st place, 77% of top-2 | 50% of runners-up | Strong | Table stakes for winning. Missing = significant negative signal |
| **C4 Diagrams** | 55% of top-2 | 32% of runners-up | Strong | At least C1 (Context) + C2 (Container). C3 (Component) for core domains |
| **Evolutionary/Phased Approach** | 73% of 1st place | 52% of runners-up | Strong | MVP-to-target roadmap with clear phase boundaries |

### Context-Specific Differentiators

| Your Context | Must-Have Artifacts | Differentiating Artifacts | Evidence Team |
|-------------|--------------------|--------------------------|--------------|
| **Budget-constrained** | Cost analysis with dollar amounts, ADRs | Multi-scenario cost models (MIN/PROJECTED/RAPID), vendor research with actual calls to vendors | ArchColider (3-scenario cost model), Jaikaturi (ChefTec vendor research: $500--$5K) |
| **Scale-heavy** | Fitness functions, volumetric analysis | Quantitative load testing proof, infrastructure sizing calculations | BluzBrothers (693ms fitness function), It Depends (140 TPS, 2800 notifications/s), Street Fighters (4,000 email requests/s) |
| **Compliance-heavy** | Security ADRs referencing specific standards, data flow diagrams | Crypto-shredding or similar privacy-by-design patterns, threat modeling | The Archangels (crypto-shredding, RAID log), Street Fighters (comprehensive GDPR ADR) |
| **AI-centric** | LLM evaluation framework, cost projections for API usage, human-in-the-loop design | Model comparison benchmarks, working prototype, AI-specific observability | ConnectedAI (Ragas evaluation, working prototype), ZAITects (OWASP Top 10 for LLM, 80% cost reduction projection) |
| **Legacy migration** | Transition architecture (current to target), phased migration plan | Before/after comparison, sequence diagrams for migration steps, risk assessment | Team Seven (transition architecture centered), Hey Dragon (3-stage: Monolith to Service-Based to Microservices) |
| **IoT/Edge** | Physical constraint quantification, edge deployment architecture | Bandwidth calculations, graceful degradation mapping, device protocol analysis | Rapid Response (31KB image = 240s on LoRaWAN), LowCode (3-node graceful degradation) |
| **High integration** | Comparative analysis of external platforms, adapter/connector architecture | Vendor research, API capability assessment, data format mapping | CELUS Ceals (8+ platform comparative analysis), IPT (Microkernel Dispatcher for varied integration capabilities) |

### Documentation Anti-Patterns

| Anti-Pattern | Evidence | Impact |
|-------------|----------|--------|
| Zero ADRs | 2 teams with zero ADRs: neither placed higher than runner-up/3rd | Very Strong negative |
| 0-1 documentation artifacts total | All 12 teams with 0-1 artifacts were runners-up or 3rd | Very Strong negative |
| Technology-first documentation (listing services without reasoning) | Los Ingenials (21 ADRs, runner-up) flagged as "possibly over-engineered" | Moderate negative |
| Generic quality attribute claims without backing decisions | 37 teams list "security" but <15 provide substantive security architecture | Moderate negative |
| Target architecture only (no migration/evolution path) | "Big-bang" approaches without phased migration consistently placed lower | Strong negative |

---

## Quick Reference Card

One-page summary of the most common paths with recommendation and top team to study.

### Architecture Selection by Problem Profile

| Your Situation | Recommended Approach | Avg Score | Top Team to Study | Key Artifact to Include |
|---------------|---------------------|-----------|-------------------|------------------------|
| Startup/nonprofit, small-medium scale | Modular Monolith with evolution path | 3.00 | ArchColider (1st, Farmacy Food) | Cost analysis with dollar amounts |
| Large scale, event-heavy | Event-Driven + Service-Based | 2.57 | Pragmatic (1st, ClearView) | Volumetric analysis with load calculations |
| Legacy migration | Service-Based + phased transition | 2.00 | Team Seven (1st, Sysops Squad) | Transition architecture diagram |
| Healthcare/medical, real-time | Event-Driven, on-premises | 2.00 | BluzBrothers (1st, MonitorMe) | Fitness functions with latency proof |
| AI is the core product | Service-Based + human-in-the-loop | -- | ZAITects (1st, Certifiable Inc.) | LLM evaluation framework + cost projection |
| IoT/Edge with offline | Event-Driven core, pragmatic edge deployment | -- | CELUS Ceals (1st, Wildlife Watcher) | Physical constraint quantification |
| High integration complexity | Per-quantum style selection | -- | CELUS Ceals (1st, Wildlife Watcher) | Comparative external platform analysis |
| Non-profit platform | Modular Monolith MVP or Service-Based | 3.00 | PegasuZ (1st, Spotlight) | Per-user cost calculation |
| 99.99%+ availability | Event-Driven + Microservices | 2.00 | Profitero Data Alchemists (1st, Road Warrior) | Rozanski/Woods multi-viewpoint framework |
| Compliance-heavy (HIPAA, GDPR) | Style per other factors + compliance ADRs | -- | The Archangels (1st, Farmacy Family) | Compliance-specific ADRs citing standards |

### The Five Things Winners Always Do

Based on the statistically derived "Winning Formula" (80% retrospective accuracy):

1. **Document 15+ decisions** with well-structured ADRs showing trade-off reasoning
2. **Include feasibility analysis** demonstrating cost awareness and practical constraints (4.5x placement impact)
3. **Use C4 diagrams** at multiple levels to communicate architecture at different granularities
4. **Adopt event-driven patterns** as a primary or supporting style (73% of winners, 50% of runners-up)
5. **Propose evolutionary approaches** with phased roadmaps from MVP to target state (73% of winners)

### Style Combinations Cheat Sheet

| Combination | Avg Score | Verdict |
|-------------|-----------|---------|
| Event-Driven + Service-Based | 2.57 | Best-performing common combination |
| Modular Monolith + any distributed target | 3.00+ | Undefeated when evolution path is documented |
| 3+ complementary styles | 2.36--2.67 | Outperforms single-style and two-style approaches |
| Event-Driven + Microservices | 1.29 | Most common but worst-performing combo per team |
| Microservices alone (no EDA) | 1.70 | Anti-pattern: microservices without async decoupling |

---

*Generated: 2026-02-26 from structured YAML metadata of 78 O'Reilly Architecture Kata submissions (Fall 2020 -- Winter 2025). Source data: `docs/reference-library/problem-spaces.md`, `docs/reference-library/solution-spaces.md`, `docs/reference-library/evidence/by-quality-attribute.md`, `docs/analysis/cross-cutting.md`.*
