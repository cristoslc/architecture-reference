# Problem-Solution Mapping Matrix

The analytical core of the reference library: a rigorous, evidence-backed mapping from problem characteristics to the architecture styles most likely to succeed. Every recommendation cites specific teams, challenges, placement scores, and sample sizes.

---

## How to Read This Matrix

Each mapping cell contains up to four pieces of information:

- **Style**: The recommended architecture style or combination
- **Weighted Score**: The aggregate placement score (1st = 4 pts, 2nd = 3 pts, 3rd = 2 pts, Runner-up = 1 pt) for teams using this style in the relevant context
- **Avg Placement**: The per-team average score (range 1.0-4.0; higher = more consistently successful)
- **Confidence**: Based on sample size
  - **High** = 3+ teams used this combination and evidence is consistent
  - **Medium** = 2 teams, or 3+ teams with mixed results
  - **Low** = 1 team, or extrapolated from adjacent evidence

**Important caveats**: Correlation is not causation. Winning teams succeed through a combination of style choice, documentation quality, trade-off reasoning, and feasibility analysis. Style choice alone does not determine placement. The dataset is 78 teams across 11 challenges -- some cells have very small sample sizes.

---

## Master Mapping: Problem Dimensions to Best Architecture Styles

### By Domain Type

| Domain | Best Style (1st) | Avg Placement | Best Style (2nd) | Avg Placement | Avoid | Evidence |
|--------|-----------------|---------------|-----------------|---------------|-------|----------|
| **Healthcare / MedTech** | Event-Driven | 2.00 (n=7) | -- | -- | Service-Based (avg 1.0, n=1) | MonitorMe: all 7 teams chose EDA; BluzBrothers (1st) proved 693ms latency with Kafka + fitness functions |
| **Food / Logistics** | Modular Monolith | 4.00 (n=1) | DDD + Event Sourcing | 3.50 (n=2) | Pure Microservices (avg 1.50, n=6) | Farmacy Food: ArchColider (1st) won with MM against 6 microservices teams; Miyagi's Little Forests (2nd) used DDD |
| **Enterprise IT / Migration** | Service-Based + EDA | 2.33 (n=6) | -- | -- | Microservices (avg 1.0, n=2) | Sysops Squad: 6 of 7 teams chose service-based; Team Seven (1st) added event-driven queues; sole microservices team placed runner-up |
| **Non-Profit / HR Tech** | Service-Based + EDA | 2.57 (n=7) | Modular Monolith | 3.25 (n=2) | Pure Microservices (avg 1.33, n=3) | ClearView: Pragmatic (1st) used SB+EDA; Spotlight: PegasuZ (1st) used MM evolving to MS+EDA |
| **Civic Tech / Social Impact** | Multi-style evolutionary | 4.00 (n=1) | Event-Driven + Microservices | 2.20 (n=5) | -- | Hey Blue!: MonArch (1st) combined MM + MS + EDA + Hexagonal + Serverless; IPT (2nd) used MS + EDA + DDD |
| **Conservation / IoT** | Microservices | 2.25 (n=4) | Modular Monolith (pragmatic deploy) | 2.50 (n=2) | Pure Event-Driven (avg 1.33, n=3) | Wildlife Watcher: CELUS Ceals (1st) used MS with C4; Rapid Response (2nd) designed 6 MS but deployed 5 as monolith |
| **Travel / Consumer** | Event-Driven | 1.75 (n=8) | EDA + Space-Based | 3.00 (n=1) | Service-Based (avg 1.0, n=1) | Road Warrior: Profitero Data Alchemists (1st) used pure EDA with Kafka; Iconites (2nd) added Space-Based for global distribution |
| **Retail / AI** | Multi-Agent + EDA + MS | 4.00 (n=1) | Multi-Agent (low-code) | 3.00 (n=1) | Monolithic pipeline | ShopWise AI: ConnectedAI (1st) used multi-agent supervisor with LangGraph; Breakwater (2nd) used n8n low-code multi-agent |
| **HR / AI Bias Reduction** | Service-Based + EDA | 4.00 (n=1) | Event-Driven | 3.00 (n=1) | Pure Microservices (avg 1.0, n=1) | ClearView: Pragmatic (1st) used SB with selective EDA; Katamarans (2nd) used EDA; Jazz Executor (MS-only) placed runner-up |
| **EdTech / AI Certification** | Service-Based + EDA | 4.00 (n=1) | Service-Based | 2.50 (n=2) | Multi-Agent (avg 1.0, n=1) | Certifiable Inc.: ZAITects (1st) used SB + EDA; Litmus (2nd) used SB; Usfive (multi-agent) placed runner-up |
| **Health / Community** | Event-Driven | 2.25 (n=4) | Service-Based | 2.00 (n=3) | -- | Farmacy Family: The Archangels (1st) used EDA with Kafka + crypto-shredding; Sever Crew (2nd) used SB + EDA |

---

### By Scale Requirement

| Scale Tier | Best Style | Avg Placement | Key Pattern | Evidence |
|------------|-----------|---------------|-------------|----------|
| **Small** (<1K users) | Modular Monolith | 3.00 (n=6 across dataset) | Start simple; focus on domain logic over infrastructure | ShopWise AI: ConnectedAI (1st) used a focused multi-agent architecture. Farmacy Food: ArchColider (1st) chose MM citing "unproven domain model." All 6 MM teams averaged 3.00 |
| **Medium** (1K-100K users) | Service-Based + EDA | 2.57 (n=7) | Service decomposition with async where needed; cost optimization critical | Sysops Squad: Team Seven (1st). Spotlight: PegasuZ (1st, MM evolving to SB). ClearView: Pragmatic (1st). Certifiable Inc.: ZAITects (1st) |
| **Large** (100K-2M users) | Event-Driven + Microservices | 2.20 (n=5) | Full distributed architecture justified; DDD for decomposition | Hey Blue!: MonArch (1st) used MS + EDA + Hexagonal. Farmacy Family: The Archangels (1st) used EDA with Kafka |
| **Very Large** (2M+ users) | EDA + Space-Based / CQRS | 2.33 (n=3 top) | Multiple scaling groups, CDN distribution, in-memory grids, CQRS read/write separation | Road Warrior: Profitero Data Alchemists (1st) defined 3 scaling groups with Kafka partitioning. Iconites (2nd) used Space-Based + Cosmos DB global distribution |

**Critical insight**: Scale alone does not determine style. MonitorMe has only 500 patients but demands 4,000 events/second throughput -- data intensity, not user count, drove the universal EDA choice. Conversely, Farmacy Food winner chose Modular Monolith despite potential national scale, prioritizing startup economics. The pattern: **match style to current scale, document the evolution path to future scale.**

---

### By Budget Constraint

| Budget | Best Style | Avg Placement | Key Insight | Evidence |
|--------|-----------|---------------|-------------|----------|
| **Startup / Non-Profit** | Modular Monolith (initial) | 3.00 (n=6) | Cost analysis is the single strongest predictor of placement in budget-constrained katas. Every 1st-place team in non-profit/startup challenges included concrete cost projections | ArchColider (1st, Farmacy Food): 3-scenario cost model $12K-$23K/yr. PegasuZ (1st, Spotlight): MM MVP. MonArch (1st, Hey Blue!): $2,780/mo GCP. Pragmatic (1st, ClearView): token cost estimation |
| **Startup / Non-Profit** (2nd choice) | Service-Based + EDA | 2.57 (n=7) | When scale demands exceed what a monolith can deliver, SB+EDA offers the best cost/capability balance | Team Seven (1st, Sysops Squad), ZAITects (1st, Certifiable Inc.), Pragmatic (1st, ClearView) |
| **Growth / Scaling** | Event-Driven + Microservices | 2.00 (n=17) | Justified when domain boundaries are proven and operational maturity supports it | MonArch (1st, Hey Blue!) evolved from MM to MS. CELUS Ceals (1st, Wildlife Watcher) justified MS against 4 criteria |
| **Enterprise** | Per-quantum style selection | varies | Established organizations can afford the operational overhead of microservices and can select styles per architectural quantum | Road Warrior teams, MonitorMe: BluzBrothers (1st) optimized infrastructure sizing. ArchZ (Runner-up, ClearView) attempted per-quanta selection but lacked feasibility analysis |

**Anti-pattern**: Microservices in non-profit/startup contexts. In ClearView (non-profit), the sole pure-microservices team (Jazz Executor) placed as runner-up. In Sysops Squad, the sole microservices team (Arch Mahal) placed as runner-up while all 6 service-based teams placed higher. Microservices' operational overhead is a budget risk that judges penalize when unjustified.

---

### By Integration Complexity

| Complexity | Best Style | Avg Placement | Key Pattern | Evidence |
|------------|-----------|---------------|-------------|----------|
| **Low** (0-2 systems) | Service-Based or focused pipeline | 2.86 (top-3 avg, n=7) | Direct API calls with abstraction layers; focus architecture effort on core domain, not integration plumbing | ShopWise AI: ConnectedAI (1st) focused on multi-agent quality. Certifiable Inc.: ZAITects (1st) used AI Gateway pattern for LLM governance |
| **Medium** (3-5 systems) | Service-Based + EDA | 2.33 (n=6) | Adapter pattern per external system; dedicated integration services; Kafka for async bridge | Sysops Squad: Team Seven (1st) used message queues for cross-domain communication. MonitorMe: BluzBrothers (1st) designed device protocol gateway for 8 device types |
| **High** (6+ systems) | Event-Driven with integration backbone | 2.25 (n=4 top) | Kafka/message broker as universal integration backbone; vendor research as a pre-architecture activity; adapter pattern per external system | Farmacy Food: 5/7 teams used EDA for integration. ClearView: Pragmatic (1st) designed adapter-based HR integration with EDA triggers. Road Warrior: Profitero Data Alchemists (1st) used Kafka for email/API aggregation |
| **Very High** (8+ systems) | Microkernel / Plugin + Event-Driven | 2.00 (n=2) | Plugin architecture for extensible integration; comparative analysis of all integration targets as pre-architecture activity | Wildlife Watcher: Wonderous Toys (3rd) used Microkernel for integration plugins. CELUS Ceals (1st) produced detailed comparative analysis of all 8+ platforms |

**Critical finding**: At high integration complexity, the pre-architecture research activity matters as much as the style choice. CELUS Ceals (1st, Wildlife Watcher) and Jaikaturi (Runner-up, Farmacy Food) both invested heavily in vendor research -- evaluating actual APIs, data formats, deployment models, and costs of target systems. This research-first approach consistently predicted higher placement.

---

### By Compliance Load

| Compliance | Best Style | Avg Placement | Key Pattern | Evidence |
|------------|-----------|---------------|-------------|----------|
| **None / Low** | Any (style driven by other dimensions) | varies | Compliance absence frees teams to optimize for other qualities; AI accuracy and prototyping dominate | ShopWise AI: no compliance constraints; ConnectedAI (1st) focused entirely on AI quality. MonitorMe: HIPAA explicitly excluded; teams focused on performance |
| **Medium** (PCI, Food Safety, GDPR-PII) | Service-Based + EDA | 2.33 (n=6) | Dedicated compliance boundary (billing service for PCI, consent service for GDPR); compliance decisions documented in specific ADRs | Sysops Squad: universal billing separation for PCI. Road Warrior: Street Fighters produced comprehensive GDPR ADR. Farmacy Food: external payment processors universal |
| **High** (HIPAA, Medical, Career-affecting) | Service-Based + EDA with compliance-specific ADRs | 2.57 (top SB+EDA in compliance contexts) | Crypto-shredding for GDPR erasure; HIPAA-eligible service selection; human-in-the-loop for career-affecting decisions; compliance honesty (deferring with documented rationale) | Farmacy Family: Archangels (1st) used crypto-shredding for GDPR. Certifiable Inc.: all 7 teams implemented human-in-the-loop. ClearView: Pragmatic (1st) designed deterministic boundaries around non-deterministic AI |

**Key finding**: Compliance load correlates with ADR quality as a placement predictor. In high-compliance challenges, top teams documented compliance decisions with specific ADRs referencing concrete standards (NIST 800-111, HIPAA-eligible AWS services, OWASP Top 10 for LLMs). Teams that listed compliance as a generic quality attribute without architectural response placed lower. The honest deferral with documented rationale (Architects++, 3rd, Farmacy Family) outperformed superficial compliance claims.

---

### By Real-Time Requirements

| Real-Time Need | Best Style | Avg Placement | Key Pattern | Evidence |
|----------------|-----------|---------------|-------------|----------|
| **None / Low** (batch, minutes OK) | Service-Based | 2.00 (n=25) | Batch processing, queue-based decoupling, no infrastructure for real-time | Spotlight Platform, ClearView, Certifiable Inc.: all winners used SB or MM, no real-time infrastructure |
| **Medium** (seconds acceptable) | Event-Driven + Service-Based | 2.57 (n=7) | Event-driven for specific async flows; message queues for decoupling | Sysops Squad: Team Seven (1st). Farmacy Food: ArchColider (1st) used event sourcing for inventory sync |
| **High** (sub-second needed) | Event-Driven + Microservices | 2.00 (n=13) | Kafka/event streaming, WebSockets, in-memory data structures, multiple scaling groups | Road Warrior: Profitero Data Alchemists (1st). Hey Blue!: MonArch (1st) used in-memory graph for O(log n) proximity lookups |
| **Critical** (lives depend on latency) | Pure Event-Driven with fitness functions | 2.00 (n=7) | End-to-end timing proofs, time-series databases, on-premises deployment, graceful degradation models | MonitorMe: BluzBrothers (1st) proved 693ms end-to-end with fitness functions. LowCode (3rd tied) designed 3-node graceful degradation. All 7 teams used EDA |

**Pattern**: Quantitative validation separates winners from runners-up in real-time contexts. BluzBrothers' 693ms timing proof, Street Fighters' 4,000 email requests/second estimate, and Rapid Response's 240-second LoRaWAN transmission calculation all demonstrate that real-time claims backed by numbers outperform qualitative assertions.

---

### By Edge/Offline Requirements

| Edge Need | Best Style | Avg Placement | Key Pattern | Evidence |
|-----------|-----------|---------------|-------------|----------|
| **None** (cloud-only) | Per other dimensions | varies | Standard cloud architecture patterns apply | 8 of 11 challenges have no edge/offline requirements |
| **Edge with connectivity** (smart devices, fridges) | Event-Driven with edge gateway | 2.50 (n=2 top) | Eventual consistency between edge and cloud; offline-capable edge logic; CDN-based auth | Farmacy Food: Jaikaturi designed CDN-based offline authentication for smart fridges. ArchColider used event sourcing for eventual consistency |
| **Edge with severe constraints** (IoT, medical appliances) | Microservices with pragmatic monolith deploy | 3.00 (n=2) | Design as microservices, deploy as monolith where hardware constrains; separate only components needing independent scaling | Wildlife Watcher: Rapid Response (2nd) designed 6 MS, deployed 5 as monolith, kept Camera Feed Engine separate. MonitorMe: LowCode (3rd tied) designed 3-node distributed appliance with graceful degradation |
| **On-premises appliance** (no cloud fallback) | Event-Driven (on-prem) | 2.00 (n=7) | All infrastructure on-prem; graceful degradation mandatory; time-series DB for high-throughput writes | MonitorMe: all 7 teams used EDA on-prem. BluzBrothers (1st) used Kafka + InfluxDB. LowCode designed capability loss mapping per failure level |

---

### By AI/ML Component

| AI Role | Best Style | Avg Placement | Key Pattern | Evidence |
|---------|-----------|---------------|-------------|----------|
| **None** | Per other dimensions | varies | Traditional distributed systems patterns | Farmacy Food, Sysops Squad, Hey Blue!, Road Warrior, MonitorMe: AI absent from requirements |
| **Peripheral** (nice-to-have feature) | Per other dimensions + defer AI | varies | Treat AI as future extension; do not let AI drive architecture | Farmacy Family: Sever Crew proposed AWS Forecast but it was not a placement factor. Spotlight: The Marmots planned data-first approach (collect before building ML) |
| **Supporting** (enhances core workflow) | Microservices with edge AI module | 2.25 (n=4) | On-device AI constrained by hardware; ML training external; edge-cloud separation | Wildlife Watcher: CELUS Ceals (1st) used Roboflow/TensorFlow Lite for edge inference. AnimAI designed service-based with AI pipeline |
| **Central** (AI is the product) | Service-Based + EDA + human-in-loop | 3.00 (top-3 avg, n=7) | Deterministic boundaries around non-deterministic AI; confidence-based escalation; LLM cost optimization; AI evaluation frameworks | ClearView: Pragmatic (1st) reduced LLM calls from O(n*m) to O(n+m). Certifiable Inc.: ZAITects (1st) used LLM-as-a-Judge + AI Gateway. ShopWise: ConnectedAI (1st) used Ragas + LangFuse evaluation |

**Winner pattern in AI-central challenges**: Top teams constrained AI rather than giving it free rein. They designed deterministic boundaries (Pragmatic), confidence-based escalation to humans (all Certifiable Inc. teams), multi-model cost optimization (ConnectedAI's dual-LLM strategy), and formal evaluation frameworks (ConnectedAI's Ragas, ZAITects' Langwatch). The architecture constrains the AI -- it does not just enable it.

**Anti-pattern**: Multi-agent architectures in structured grading workflows. In Certifiable Inc., the multi-agent team (Usfive) placed as runner-up while simpler service-based approaches (ZAITects 1st, Litmus 2nd) won. ZAITects explicitly rejected Agentic AI for this use case.

---

## Compound Mappings: Multi-Dimension Lookups

### "I have a problem like..."

For common multi-dimensional problem profiles, these are the specific recommended approaches based on the strongest available evidence.

| Problem Profile | Example Challenges | Recommended Approach | Key Decisions | Confidence |
|----------------|-------------------|---------------------|---------------|------------|
| **Budget-constrained non-profit, medium scale** | Spotlight Platform, Hey Blue!, ClearView | Service-Based + selective EDA; evolutionary roadmap from MM to distributed | Include cost analysis with per-user projections; document evolution triggers tied to business milestones | **High** (3 challenges, 5 first-place teams used this pattern) |
| **Healthcare with real-time + on-prem** | MonitorMe | Event-Driven with Kafka; on-premises deployment; time-series DB; fitness-function-proven latency | Downplay scalability if ceiling is fixed (BluzBrothers ADR-008); prove timing quantitatively; design graceful degradation | **High** (7 teams, unanimous EDA convergence) |
| **Greenfield startup with high integration** | Farmacy Food | Modular Monolith + Event Sourcing + DDD; evolution path to distributed | Vendor research as architecture; 3-scenario cost model; resist microservices until domain model is proven | **High** (ArchColider 1st with MM vs. 6 MS teams that placed lower) |
| **AI-centric with accuracy requirements** | Certifiable Inc., ClearView | Service-Based + EDA + human-in-the-loop + deterministic boundaries around AI | Confidence-based escalation; LLM-as-a-Judge evaluation; reject autonomous AI for high-stakes decisions; include cost/feasibility analysis | **High** (4 first-place teams across 3 AI challenges used this pattern) |
| **Travel / consumer at extreme scale** | Road Warrior | Event-Driven + Microservices; CQRS for read/write separation; multiple scaling groups | Define scaling groups per workload; use Space-Based for global distribution if needed; email integration is the hardest sub-problem | **High** (9 teams; EDA universal at 8/9; Profitero 1st with pure EDA + 3 scaling groups) |
| **IoT with edge/offline constraints** | Wildlife Watcher | Microservices design with pragmatic monolith deploy; edge AI module separate | Quantify bandwidth constraints; comparative analysis of all integration platforms; separate camera feed processing for independent scaling | **Medium** (6 teams; CELUS Ceals 1st with MS; Rapid Response 2nd with MM deploy) |
| **Legacy monolith migration** | Sysops Squad | Service-Based (not microservices); transition architecture > target architecture | Document the migration path, not just the destination; phased decomposition with fitness-function gates; isolate billing/PCI into own domain immediately | **High** (6/7 teams chose SB; sole MS team placed runner-up) |
| **Non-profit AI platform with bias concerns** | ClearView | Service-Based + selective EDA; deterministic matching pipeline; adapter pattern for unbounded HR integrations | Reduce LLM calls architecturally (O(n+m) not O(n*m)); PII anonymization as cross-cutting concern; calculate per-candidate AI costs | **Medium** (7 teams; Pragmatic 1st with deterministic approach) |
| **Health community with HIPAA + startup budget** | Farmacy Family | Event-Driven with Kafka integration backbone; honest compliance handling | Crypto-shredding for GDPR; HIPAA-eligible service selection; or defer HIPAA with documented rationale (Architects++); build-vs-buy for community features | **High** (7 teams; Archangels 1st with EDA + crypto-shredding) |
| **AI chatbot / e-commerce** | ShopWise AI | Multi-Agent supervisor + text-to-SQL; working prototype | Dual-LLM cost strategy; quantitative evaluation framework (Ragas); text-to-SQL beats RAG for structured data | **Medium** (4 teams; ConnectedAI 1st; small sample) |
| **Established enterprise extending with AI** | Certifiable Inc. | Service-Based + AI pipeline + human oversight | Separate Grader from Judge (LLM-as-a-Judge); microkernel for parallel AI variants; reject over-automation; document what you rejected and why | **High** (7 teams; ZAITects 1st; all teams used human-in-the-loop) |

---

## Quality Attribute to Style Mapping

Which architecture styles best support which quality attributes, based on actual scored evidence from 78 team submissions.

| Quality Attribute | Best Style | Avg Score | Top-3 Rate | Worst Style | Worst Avg | Evidence |
|-------------------|-----------|-----------|-----------|-------------|-----------|----------|
| **Scalability** | Modular Monolith | 3.00 (n=3) | 66.7% | Serverless | 1.50 (n=6) | MM teams addressed scalability through evolution paths, not upfront infrastructure. EDA (1.97, n=36) is the volume leader. Microservices (1.69, n=32) underperforms despite being the "scalable" choice |
| **Availability** | Modular Monolith | 3.67 (n=3) | 100% | Service-Based | 1.50 (n=14) | MM teams delivered availability through simplicity (fewer failure modes). EDA (1.86, n=29) is the volume leader. Graceful degradation models (LowCode) outperformed binary availability claims |
| **Performance** | Modular Monolith | 3.33 (n=3) | 100% | Serverless | 1.67 (n=6) | MM avoids network latency between services. EDA (2.0, n=30) performs well at scale. Quantitative validation (BluzBrothers' 693ms) separates winners from runners-up |
| **Security** | Modular Monolith | 3.25 (n=4) | 100% | Microservices | 1.52 (n=21) | MM reduces attack surface. Service-Based (1.90, n=10) supports security through bounded service perimeters. Specific security ADRs (crypto-shredding, zero trust) predict placement |
| **Evolvability** | Modular Monolith | 4.00 (n=2) | 100% | Service-Based | 1.40 (n=10) | MM with hexagonal internals and documented extraction points is the gold standard. Microservices (1.90, n=20) supports evolvability once domain is proven. Microkernel (Wonderous Toys, SAG) enables plugin-based extension |
| **Cost / Feasibility** | Modular Monolith | 3.00 (n=5) | 80% | Microservices | 1.81 (n=16) | MM minimizes infrastructure spend. ArchColider's 3-scenario model ($12K-$23K/yr), TheGlobalVariables' $0.002/user/mo, MonArch's $2,780/mo GCP. Serverless (2.33, n=3) is strong for intermittent workloads |
| **Data Integrity** | Service-Based | 2.50 (n=4) | 75% | -- | -- | SB keeps shared DB longer, simplifying consistency. EDA (2.12, n=16) supports integrity through event sourcing and audit trails. Mighty Orbots' ELT pipeline prioritized raw data loading |
| **Interoperability** | Event-Driven | 2.33 (n=12) | 75% | Microservices | 1.67 (n=6) | EDA's async messaging naturally bridges heterogeneous systems. Pragmatic (1st, ClearView) designed adapter-based HR integration with EDA triggers. Kafka as universal integration backbone in high-integration challenges |
| **Observability** | Service-Based | 2.25 (n=4) | 50% | Microservices | 1.50 (n=6) | SB's bounded service count makes observability tractable. In AI katas, LLM-specific observability (LangFuse, Langwatch) was a differentiator. ConnectedAI and ZAITects both included AI observability |
| **Simplicity** | Modular Monolith | 2.33 (n=3) | 66.7% | Microservices | not cited | MM and buy-over-build decisions (Architects++ chose Facebook Groups, Eventbrite, WordPress). Simplicity almost never co-occurs with microservices as a stated priority |

**The Modular Monolith paradox**: Modular Monolith shows the highest average placement score across almost every quality attribute. This is partly a selection effect -- the 6 teams that chose MM were disproportionately thoughtful architects making a contrarian, well-reasoned choice. The style's strength is not that monoliths are inherently superior, but that **teams who resist the microservices default and justify a simpler choice tend to exhibit the architectural reasoning judges reward.** Small sample size (n=6) limits statistical confidence.

**The Microservices trap**: Microservices consistently underperforms relative to its adoption rate. With 39 teams (50% of all submissions), it is the second most popular style but ranks below Service-Based and Modular Monolith in per-team effectiveness for every quality attribute except raw team count. The cross-cutting analysis calls this "popular but not predictive." The differentiator: microservices teams that paired with EDA, DDD, or evolutionary approaches performed markedly better than those using microservices alone (1.70 avg for MS-only vs. 2.00+ for MS + EDA).

---

## Style Combination Performance Matrix

The most actionable finding in the dataset: **which style combinations actually win.**

| Combination | Teams | Avg Placement | 1st Place Wins | Key Insight |
|-------------|-------|---------------|----------------|-------------|
| **Event-Driven + Service-Based** | 7 | **2.57** | 3 | Highest-performing common combination. Pragmatic (1st), ZAITects (1st), Team Seven (1st) |
| **Modular Monolith + [any distributed target]** | 6 | **3.00** | 3 | Every MM team with a documented evolution path placed top 3. "Start simple, evolve deliberately" is the strongest single signal |
| **Event-Driven + Microservices** | 17 | **1.29** | 0 from the combo alone | Most common combination but lowest-performing per team. Popularity dilutes signal; many teams default to this without differentiating |
| **3+ complementary styles** | 11 | **2.36** | 4 | Winners combine styles thoughtfully. PegasuZ (MM + MS + EDA), MonArch (MM + MS + EDA + Hex + Serverless) |
| **5 styles** | 3 | **2.67** | 1 | Small sample but directionally strong: multi-style mastery correlates with placement |
| **Single style** | 30 | **1.87** | 3 | Adequate but not differentiated; single-style teams must compensate with exceptional documentation |
| **CQRS + DDD + Modular Monolith** | 1 | **4.00** | 1 | ArchColider (1st, Farmacy Food): the dataset's highest-scoring single submission by combination sophistication |

**The combination rule**: Event-Driven + Service-Based (avg 2.57) outperforms Event-Driven + Microservices (avg 1.29) by a factor of 2x on per-team placement. Three of seven EDA+SB teams won first place; zero of seventeen EDA+MS teams won from the combination alone (first-place MS winners all added additional styles). For most problems, Service-Based + selective Event-Driven is the optimal starting combination.

---

## Documentation Practices to Placement Mapping

Which documentation artifacts most predict success for which problem types, based on winner analysis.

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

---

## Decision Flowchart: Choosing Your Style

For practitioners using this matrix, follow this sequence:

**Step 1: Check your AI role.**
- If AI is central to your product, start with Service-Based + EDA + human-in-the-loop. See the AI-centric compound mapping above.
- If AI is peripheral or absent, proceed to Step 2.

**Step 2: Check your scale and budget.**
- If startup/non-profit with unproven domain: **Modular Monolith** with documented evolution path.
- If medium-scale established: **Service-Based + selective EDA**.
- If large-scale with proven domain boundaries: **Microservices + EDA** (ensure DDD decomposition).
- If very large scale with strict SLAs: **EDA + CQRS/Space-Based**.

**Step 3: Check your real-time needs.**
- If critical (lives depend on latency): **Event-Driven** with fitness-function-proven timing. Consider on-premises deployment.
- If high (sub-second needed): **Event-Driven + Microservices** with quantitative validation.
- If low/none: Style driven by other dimensions; avoid over-investing in real-time infrastructure.

**Step 4: Check your integration complexity.**
- If very high (8+ systems): Add **Microkernel/Plugin** pattern for extensibility; invest in comparative platform analysis before architecture.
- If high (6+ systems): Use **event-driven integration backbone** (Kafka) with adapter pattern per system.
- If medium or low: Standard integration patterns suffice; do not let integration drive primary style choice.

**Step 5: Check your compliance load.**
- If high (HIPAA, career-affecting): Dedicate specific ADRs to compliance; consider crypto-shredding, dedicated compliance boundaries, or honest deferral with documented rationale.
- If medium (PCI, GDPR): Isolate sensitive data into dedicated services (billing for PCI, consent service for GDPR).
- If none: Focus architecture effort elsewhere.

**Step 6: Document the evolution path.** Regardless of starting style, document when and why you would evolve to the next style tier. Tie evolution triggers to business milestones (user thresholds, funding rounds), not arbitrary timelines. 73% of first-place winners proposed multi-style or phased architectures.

---

*Generated: 2026-02-26 from structured evidence in 78 O'Reilly Architecture Kata submissions across 11 challenges (Fall 2020 -- Winter 2025). Source data: `problem-spaces.md`, `solution-spaces.md`, `evidence/by-architecture-style.md`, `evidence/by-quality-attribute.md`.*
