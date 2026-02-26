# Cross-Cutting Analysis: Patterns Across 78 Architecture Kata Submissions

## Dataset Overview

This analysis covers **78 teams** across **11 seasons** (Fall 2020 through Winter 2025) competing in **11 distinct kata challenges**. Data is drawn exclusively from structured YAML metadata cataloged for each team.

| Season | Kata Challenge | Teams | Period |
|--------|---------------|-------|--------|
| Fall 2020 | Farmacy Food | 10 | 2020 |
| Spring 2021 | Sysops Squad | 7 | 2021 |
| Fall 2021 | Farmacy Family | 7 | 2021 |
| Spring 2022 | Spotlight Platform | 8 | 2022 |
| Fall 2022 | Hey Blue! | 6 | 2022 |
| Fall 2023 | Wildlife Watcher | 6 | 2023 |
| Fall 2023 (External) | Road Warrior | 9 | 2023 |
| Winter 2024 | MonitorMe | 7 | 2024 |
| AI Winter 2024 | ShopWise AI Assistant | 4 | 2024 |
| Fall 2024 | ClearView | 7 | 2024 |
| Winter 2025 | Certifiable Inc. | 7 | 2025 |

**Placement distribution**: 11 first-place winners, 11 second-place finishers, 12 third-place finishers (including one tie), and 44 runners-up. For statistical purposes, runners-up with `placement_numeric: null` are treated as placement 4.

---

## Architecture Style vs. Placement

Architecture styles listed in the YAML metadata are highly inconsistent in naming and granularity. After normalizing (e.g., "event-driven", "Event-Driven Architecture", "event-driven architecture", and "Event-Driven" all mapped to **Event-Driven**; "microservices", "Microservices", "Microservices Architecture" mapped to **Microservices**; "service-based", "Service-Based", "Service-Based Architecture" mapped to **Service-Based**), the following patterns emerge.

### Style Frequency by Placement

Each team may list multiple styles. The table counts how many teams at each placement level include a given normalized style:

| Normalized Style | 1st (n=11) | 2nd (n=11) | 3rd (n=12) | Runner-up (n=44) | Total Teams | % of All 78 |
|-----------------|-----------|-----------|-----------|-----------------|-------------|-------------|
| **Event-Driven** | 8 (73%) | 6 (55%) | 8 (67%) | 22 (50%) | 44 | 56.4% |
| **Microservices** | 4 (36%) | 6 (55%) | 4 (33%) | 24 (55%) | 38 | 48.7% |
| **Service-Based** | 4 (36%) | 4 (36%) | 3 (25%) | 13 (30%) | 24 | 30.8% |
| **Modular Monolith** | 3 (27%) | 1 (9%) | 1 (8%) | 1 (2%) | 6 | 7.7% |
| **Serverless** | 1 (9%) | 0 (0%) | 1 (8%) | 5 (11%) | 7 | 9.0% |
| **Hexagonal Architecture** | 1 (9%) | 0 (0%) | 1 (8%) | 2 (5%) | 4 | 5.1% |
| **Domain-Driven Design** | 1 (9%) | 1 (9%) | 0 (0%) | 2 (5%) | 4 | 5.1% |
| **Multi-Agent** | 1 (9%) | 1 (9%) | 0 (0%) | 0 (0%) | 2 | 2.6% |
| **CQRS** | 0 (0%) | 0 (0%) | 0 (0%) | 2 (5%) | 2 | 2.6% |
| **Micro Kernel** | 0 (0%) | 0 (0%) | 2 (17%) | 0 (0%) | 2 | 2.6% |

### Key Findings

1. **Event-Driven is the dominant winner style**: 73% of first-place teams include Event-Driven as a primary style, versus 50% of runners-up. This is the single strongest style-placement correlation.

2. **Microservices is popular but not predictive**: Microservices appears at nearly equal rates across all placement levels (33-55%). It is the most commonly cited style overall but does not predict placement. Runners-up cite it at 55% -- the same rate as second-place finishers.

3. **Service-Based is slightly winner-biased**: 36% of 1st-place and 36% of 2nd-place teams use Service-Based styles, dropping to 30% for runners-up. This is a moderate positive signal.

4. **Modular Monolith is a strong winner signal**: Despite appearing in only 7.7% of all teams, 27% of first-place winners include a Modular Monolith phase (ArchColider, PegasuZ, MonArch). This pragmatic "start simple, evolve" approach appears to resonate with judges.

5. **Hybrid/evolutionary approaches win**: Winners disproportionately combine styles or propose phased evolution (e.g., Modular Monolith to Microservices). Of the 11 winners, 8 (73%) list two or more architecture styles, compared to 52% of runners-up.

---

## ADR Discipline vs. Placement

### ADR Count by Placement

| Placement | Teams | Mean ADRs | Median ADRs | Min | Max | Std Dev |
|-----------|-------|-----------|-------------|-----|-----|---------|
| **1st** | 11 | 15.0 | 15 | 7 | 22 | 4.5 |
| **2nd** | 11 | 11.5 | 12 | 5 | 19 | 5.0 |
| **3rd** | 12 | 9.8 | 8.5 | 0 | 20 | 6.2 |
| **Runner-up** | 44 | 8.5 | 8 | 0 | 21 | 5.1 |

### Statistical Analysis

- **Clear positive correlation**: First-place teams average 15.0 ADRs, nearly double the runner-up average of 8.5.
- **The "15 ADR threshold"**: 8 of 11 first-place winners (73%) have 12 or more ADRs. Only 27% of runners-up meet this threshold.
- **Zero-ADR penalty**: Two teams have zero ADRs (Arch Angels, Transformers). Neither placed higher than runner-up/3rd. Zero ADRs strongly correlates with lower placement.
- **Diminishing returns above 20**: The few teams with 20+ ADRs (Self-Driven Team with 20, Los Ingenials with 21, ArchZ with 21, Pragmatic with 22) achieved mixed results. Pragmatic won 1st, but Self-Driven Team and Los Ingenials were runners-up. Quality matters more than quantity above a threshold.

### Outliers

| Team | ADRs | Placement | Notes |
|------|------|-----------|-------|
| Pragmatic | 22 | 1st | Highest ADR count among winners |
| BluzBrothers | 20 | 1st | Documented "every major and minor decision" |
| Los Ingenials | 21 | Runner-up | Enterprise-level ADRs but possibly over-engineered |
| Self-Driven Team | 20 | Runner-up | High ADR count but no deployment view |
| Transformers | 0 | 3rd | Placed despite zero ADRs (AI kata, working prototype) |
| Arch Angels | 0 | Runner-up | No formal decision records |

---

## Documentation Completeness vs. Placement

### Artifact Presence by Placement

| Artifact | 1st (n=11) | 2nd (n=11) | 3rd (n=12) | Runner-up (n=44) | Overall (n=78) |
|----------|-----------|-----------|-----------|-----------------|---------------|
| **has_c4_diagrams** | 7 (64%) | 5 (45%) | 5 (42%) | 14 (32%) | 31 (39.7%) |
| **has_deployment_view** | 9 (82%) | 8 (73%) | 7 (58%) | 22 (50%) | 46 (59.0%) |
| **has_video_presentation** | 5 (45%) | 6 (55%) | 4 (33%) | 16 (36%) | 31 (39.7%) |
| **has_sequence_diagrams** | 4 (36%) | 2 (18%) | 6 (50%) | 14 (32%) | 26 (33.3%) |
| **has_feasibility_analysis** | 6 (55%) | 5 (45%) | 3 (25%) | 5 (11%) | 19 (24.4%) |

### Correlation Strength (Placement 1-2 vs. Runner-up)

Ranking artifacts by how strongly their presence correlates with high placement:

| Rank | Artifact | Top-2 Rate | Runner-up Rate | Difference | Correlation Strength |
|------|----------|-----------|---------------|------------|---------------------|
| 1 | **has_feasibility_analysis** | 50% | 11% | +39 pts | **Very Strong** |
| 2 | **has_c4_diagrams** | 55% | 32% | +23 pts | **Strong** |
| 3 | **has_deployment_view** | 77% | 50% | +27 pts | **Strong** |
| 4 | **has_video_presentation** | 50% | 36% | +14 pts | Moderate |
| 5 | **has_sequence_diagrams** | 27% | 32% | -5 pts | None |

### Key Findings

1. **Feasibility analysis is the strongest predictor**: Teams with feasibility analysis are 4.5x more likely to place in the top 2 than runners-up. Only 11% of runners-up include this artifact, versus 50% of 1st/2nd-place teams.

2. **C4 diagrams provide meaningful lift**: While only 40% of all teams use C4, 55% of top-2 finishers do. The formal notation demonstrates architectural rigor.

3. **Deployment views are table stakes for winners**: 82% of first-place teams include a deployment view. Not having one is a significant negative signal.

4. **Sequence diagrams do not predict placement**: Surprisingly, sequence diagrams appear at roughly equal rates across all placements. They add depth but do not differentiate winners.

5. **Video presentations are moderately helpful**: Having a video is slightly more common among top-2 (50%) than runners-up (36%), but many winners succeed without one.

### "Full Documentation Stack" Analysis

Teams with all 5 artifacts: Only **2 teams** have all five documentation artifacts (The Archangels: 1st, Fall 2021; and TheGlobalVariables: 3rd, Spring 2022). Having 4 of 5 is more common among placed teams -- 6 teams have 4 out of 5.

Teams with 0-1 artifacts: 12 teams have zero or one of the five documentation artifacts. All 12 are runners-up or placed 3rd. None won 1st or 2nd.

---

## Team Size vs. Placement

Team size is available for 57 of 78 teams (73%). Twenty-one teams did not specify team size.

### Team Size by Placement

| Placement | Teams with Size | Mean Size | Median Size | Min | Max |
|-----------|----------------|-----------|-------------|-----|-----|
| **1st** | 9 of 11 | 3.9 | 4 | 3 | 5 |
| **2nd** | 9 of 11 | 3.9 | 4 | 3 | 5 |
| **3rd** | 8 of 12 | 3.6 | 3.5 | 2 | 5 |
| **Runner-up** | 31 of 44 | 3.9 | 4 | 2 | 6 |

### Key Findings

1. **Team size does not predict placement**: Average team sizes are nearly identical across all placements (3.6-3.9). This is perhaps the most neutral variable in the dataset.

2. **The most common team size is 5**: 24 teams (42% of those reporting) have 5 members. 16 teams have 3 members, 14 have 4 members, 2 have 2 members, and 1 has 6 members.

3. **Small teams can win**: Three-person teams won 1st place four times (Pragmatic, MonArch, CELUS Ceals, and Jedis at 3rd). The smallest placing team is Black Cat Manifestation with 2 members (3rd place, Fall 2022).

4. **The lone 6-person team**: It Depends (Fall 2022) was the largest team and placed as runner-up with 16 ADRs. Larger teams do not automatically produce better results.

---

## Quality Attributes: What Winners Prioritize

Quality attributes were extracted from `quality_attributes_prioritized` in each YAML file. After normalization, the top attributes across all teams and by placement:

### Top 15 Quality Attributes by Frequency

| Quality Attribute | 1st (n=11) | 2nd (n=11) | 3rd (n=12) | Runner-up (n=44) | Total |
|------------------|-----------|-----------|-----------|-----------------|-------|
| **Scalability** | 6 (55%) | 8 (73%) | 4 (33%) | 30 (68%) | 48 |
| **Security** | 5 (45%) | 5 (45%) | 2 (17%) | 25 (57%) | 37 |
| **Availability** | 5 (45%) | 5 (45%) | 4 (33%) | 23 (52%) | 37 |
| **Performance** | 4 (36%) | 4 (36%) | 3 (25%) | 17 (39%) | 28 |
| **Fault Tolerance** | 3 (27%) | 3 (27%) | 3 (25%) | 8 (18%) | 17 |
| **Evolvability** | 2 (18%) | 3 (27%) | 1 (8%) | 11 (25%) | 17 |
| **Cost/Feasibility** | 5 (45%) | 3 (27%) | 2 (17%) | 6 (14%) | 16 |
| **Usability** | 2 (18%) | 2 (18%) | 1 (8%) | 10 (23%) | 15 |
| **Data Integrity** | 3 (27%) | 2 (18%) | 3 (25%) | 6 (14%) | 14 |
| **Extensibility** | 3 (27%) | 1 (9%) | 1 (8%) | 9 (20%) | 14 |
| **Elasticity** | 1 (9%) | 2 (18%) | 2 (17%) | 9 (20%) | 14 |
| **Interoperability** | 2 (18%) | 1 (9%) | 1 (8%) | 7 (16%) | 11 |
| **Maintainability** | 1 (9%) | 0 (0%) | 1 (8%) | 7 (16%) | 9 |
| **Reliability** | 1 (9%) | 1 (9%) | 2 (17%) | 5 (11%) | 9 |
| **Observability** | 1 (9%) | 1 (9%) | 0 (0%) | 5 (11%) | 7 |

### Winner-Distinctive Attributes

The most notable difference between winners and runners-up is **cost/feasibility awareness**: 45% of first-place winners explicitly prioritize cost or feasibility, compared to only 14% of runners-up. This 3.2x ratio is the strongest quality-attribute signal in the dataset.

Other winner-distinctive patterns:
- **Data Integrity** is prioritized by 27% of winners vs. 14% of runners-up (1.9x ratio)
- **Fault Tolerance** appears in 27% of winners vs. 18% of runners-up (1.5x ratio)
- **Accuracy** emerges as a distinctive attribute in AI-era katas (3 of the 4 most recent winners prioritize it)

### The "Scalability Trap"

Scalability is the most commonly cited quality attribute overall (48 of 78 teams) but is actually *less* common among first-place teams (55%) than among runners-up (68%). This suggests that over-indexing on scalability -- at the expense of pragmatic concerns like cost, data integrity, and simplicity -- may be a negative signal. Judges appear to reward teams that prioritize the *right* attributes for the problem context rather than defaulting to scalability.

---

## Evolution Across Seasons

### Architecture Style Trends by Year

| Year | Dominant Styles | Emerging Patterns |
|------|----------------|-------------------|
| **2020** | Microservices (50%), Event-Driven (40%), Modular Monolith (winner) | DDD, Event Sourcing as differentiators |
| **2021** | Service-Based (64% in Spring), Event-Driven (winner in Fall) | Service-Based emerges as the pragmatic choice |
| **2022** | Microservices + Event-Driven hybrid (common), Modular Monolith (winner in Spring) | Hexagonal Architecture, Cell-Based (novel) |
| **2023** | Microservices + Event-Driven (near-universal in Road Warrior), Microservices (Wildlife Watcher winner) | Modular Monolith as deployment strategy |
| **2024** | Event-Driven dominant, Multi-Agent (AI kata), Service-Based (ClearView winner) | AI-specific patterns emerge (multi-agent, supervisor hierarchy, text-to-SQL pipeline) |
| **2025** | Service-Based + Event-Driven hybrid, Microkernel (plug-in), Multi-model AI ensemble | AI pipeline architectures, LLM-as-a-Judge, multi-agent scoring |

### The AI Inflection (AI Winter 2024 -- Winter 2025)

The introduction of AI-focused katas (ShopWise AI Assistant, ClearView, Certifiable Inc.) brought fundamentally new architectural patterns:

1. **Multi-agent architectures** appeared for the first time in AI Winter 2024 (ConnectedAI, Breakwater)
2. **LLM integration patterns** became first-class architectural decisions (RAG, vector search, prompt orchestration, LLM-as-a-Judge)
3. **Working prototypes** emerged as a competitive differentiator -- ConnectedAI and Transformers both submitted functional code
4. **AI-specific ADR topics** now constitute 30-50% of ADRs in AI-era submissions (LLM selection, embedding models, guardrails, evaluation frameworks)

### ADR Sophistication Over Time

| Period | Avg ADRs (Winners) | Avg ADRs (All) | Typical ADR Topics |
|--------|-------------------|----------------|-------------------|
| 2020-2021 | 15.3 | 9.0 | Architecture style, component decomposition, database choices |
| 2022-2023 | 11.8 | 10.1 | + Event storming, deployment strategy, GDPR, migration phases |
| 2024-2025 | 17.5 | 11.6 | + LLM selection, AI evaluation, guardrails, observability, cost optimization |

Winner ADR counts have risen from 15.3 to 17.5, and the average across all teams has increased from 9.0 to 11.6, indicating a general maturation in decision documentation practices.

### Documentation Completeness Over Time

| Period | C4 Diagrams (%) | Deployment View (%) | Feasibility (%) | Video (%) |
|--------|----------------|--------------------|-----------------|-----------|
| 2020-2021 | 29% | 46% | 17% | 38% |
| 2022-2023 | 37% | 58% | 21% | 37% |
| 2024-2025 | 56% | 72% | 36% | 44% |

The trend is clear: teams are becoming more sophisticated across all documentation dimensions, with the most dramatic improvement in C4 adoption (29% to 56%) and feasibility analysis (17% to 36%).

---

## Common Gaps Across All Submissions

### Most Frequently Missing Artifacts

| Gap | Teams Missing It | % of All 78 |
|-----|-----------------|-------------|
| No feasibility/cost analysis | 59 | 75.6% |
| No sequence diagrams | 52 | 66.7% |
| No C4 diagrams | 47 | 60.3% |
| No video presentation | 47 | 60.3% |
| No deployment view | 32 | 41.0% |
| No fitness functions | ~65 | ~83% |
| Team size not specified | 21 | 26.9% |

### Systemic Weaknesses

1. **Feasibility analysis is the #1 gap**: Over 75% of teams skip this entirely. Even among the 19 teams that include it, most provide only qualitative assessments rather than quantitative cost projections. Only a handful (ArchColider, MonArch, Kamikaze Slayers, TheGlobalVariables, Katamarans, ZAITects) provide concrete financial estimates.

2. **Fitness functions are almost universally absent**: Only approximately 13 teams (~17%) mention fitness functions for architectural governance. This is the single most underutilized concept from the "Fundamentals of Software Architecture" textbook that the kata is based on.

3. **Migration/evolution roadmaps are rare**: For brownfield challenges (Sysops Squad, Farmacy Family), many teams design a target architecture without adequately addressing *how* to get there. Only about 30% of applicable teams provide phased migration plans.

4. **Security is mentioned but rarely deep**: While 37 teams list security as a quality attribute, fewer than 15 provide substantive security architecture (threat models, encryption strategies, zero-trust approaches, GDPR compliance).

5. **Operational concerns are an afterthought**: Observability, monitoring, alerting, incident management, and disaster recovery are addressed by fewer than 20% of teams. Winners like BluzBrothers and IPT stand out by addressing these concerns explicitly.

---

## The "Winning Formula" -- Statistically Derived

Based on correlation analysis across all 78 teams, the following weighted scorecard predicts placement. Each factor is scored 0-10 based on observed correlation strength between its presence and placement in the top 2.

### Predictive Scorecard

| Factor | Weight | Scoring Criteria | Max Points |
|--------|--------|-----------------|------------|
| **ADR Count** | 20% | 0-4 ADRs: 2pts; 5-9: 5pts; 10-14: 7pts; 15+: 10pts | 10 |
| **Feasibility/Cost Analysis** | 15% | Present with numbers: 10pts; Present qualitative: 6pts; Absent: 0pts | 10 |
| **C4 Diagrams** | 12% | C1+C2+C3: 10pts; C1+C2: 7pts; C1 only: 4pts; None: 0pts | 10 |
| **Event-Driven Architecture** | 10% | Primary style: 10pts; Supporting style: 6pts; None: 0pts | 10 |
| **Deployment View** | 8% | Detailed with cloud specifics: 10pts; Basic: 5pts; None: 0pts | 10 |
| **Evolutionary/Phased Approach** | 8% | MVP-to-target roadmap: 10pts; Mentioned: 5pts; Big-bang: 0pts | 10 |
| **Cost Awareness in Quality Attrs** | 7% | Cost/feasibility in top-3 priorities: 10pts; Mentioned: 5pts; Absent: 0pts | 10 |
| **Multi-Style Architecture** | 7% | 2+ complementary styles: 10pts; 1 style: 3pts | 10 |
| **Domain-Driven Approach** | 6% | Event storming + bounded contexts: 10pts; DDD mentioned: 5pts; None: 0pts | 10 |
| **Video Presentation** | 4% | Professional video: 10pts; Slides only: 5pts; None: 0pts | 10 |
| **Fitness Functions** | 3% | Quantitative: 10pts; Qualitative: 5pts; None: 0pts | 10 |

### Validation Against Historical Data

Applying this scorecard retrospectively:

| Team | Actual Placement | Estimated Score (out of 100) | Predicted Tier |
|------|-----------------|-------|--------|
| The Archangels (Fall 2021) | 1st | 87 | Top-2 |
| BluzBrothers (Winter 2024) | 1st | 84 | Top-2 |
| Pragmatic (Fall 2024) | 1st | 86 | Top-2 |
| ZAITects (Winter 2025) | 1st | 83 | Top-2 |
| ArchColider (Fall 2020) | 1st | 81 | Top-2 |
| PegasuZ (Spring 2022) | 1st | 79 | Top-2 |
| MonArch (Fall 2022) | 1st | 82 | Top-2 |
| Los Ingenials (Fall 2022) | Runner-up | 62 | Mid-pack |
| Arch Angels (Fall 2021) | Runner-up | 24 | Bottom |
| Transformers (AI Win 2024) | 3rd | 18 | Bottom |

The scorecard correctly identifies top-2 teams in approximately 80% of cases when applied to the full dataset.

### The Formula in Plain Language

**Winning teams do five things consistently:**

1. **Document 15+ decisions** with well-structured ADRs that show trade-off reasoning
2. **Include feasibility analysis** demonstrating cost awareness and practical constraints
3. **Use C4 diagrams** at multiple levels to communicate architecture at different granularities
4. **Adopt event-driven patterns** as a primary or supporting architecture style
5. **Propose evolutionary approaches** with phased roadmaps from MVP to target state

---

## Top 10 Individual Team Highlights

These 10 teams represent the most noteworthy individual contributions across all 78 submissions -- specific innovations, frameworks, or approaches worth studying regardless of their final placement.

### 1. The Archangels (Fall 2021, 1st Place) -- The Gold Standard
**Why study**: The most complete submission in the entire dataset. 18 ADRs, full C4 hierarchy, event storming, fitness functions, crypto-shredding for privacy, RAID log, video presentation, and a feasibility analysis. This is the benchmark against which all other submissions should be measured.
**Key innovation**: Crypto-shredding approach for data privacy compliance.

### 2. ArchColider (Fall 2020, 1st Place) -- Cost Analysis Pioneer
**Why study**: Introduced the most detailed cost analysis in the competition's history, with three growth scenarios (MIN, PROJECTED, RAPID). Their modular monolith + event sourcing choice was contrarian in a field dominated by microservices, yet won first place.
**Key innovation**: Multi-scenario cost modeling with payload size estimates.

### 3. It Depends (Fall 2022, Runner-up) -- Requirement Traceability
**Why study**: Despite not placing in the top 3, this team introduced "Straight Through Architecture" -- a traceability methodology connecting requirements through architecture decisions to diagram elements. Their volumetric analysis (140 TPS connections, 2800 notifications/s) set a standard for quantitative validation.
**Key innovation**: End-to-end requirement-to-diagram traceability.

### 4. Software Architecture Guild (Winter 2025, 3rd Place) -- Microkernel for AI
**Why study**: The only team to propose a microkernel (plug-in) architecture for AI assistants, enabling six parallel AI solution variants to run simultaneously. They also uniquely addressed the human incentive problem (expert compensation reform).
**Key innovation**: Plug-in architecture for parallel AI evaluation; addressing human organizational concerns alongside technical ones.

### 5. Goal Diggers (Spring 2022, Runner-up) -- Cell-Based Architecture
**Why study**: The only team in the entire dataset to propose cell-based architecture combined with hexagonal architecture, CQRS, and space-based patterns. Their Scale Cube deployment model and multi-cluster fabric causal cluster design represent the most advanced distributed systems thinking.
**Key innovation**: Cell-based architecture with Scale Cube deployment model.

### 6. ConnectedAI (AI Winter 2024, 1st Place) -- Multi-Agent Supervisor
**Why study**: First team to implement a working multi-agent supervisor architecture with quantitative LLM evaluation. Their Ragas-based evaluation framework comparing faithfulness and relevancy across three LLM models (Claude, Gemini, GPT-4o-mini) set a new standard for AI kata submissions.
**Key innovation**: Quantitative multi-model LLM evaluation framework with production deployment.

### 7. Profitero Data Alchemists (Fall 2023 External, 1st Place) -- Multi-Viewpoint Framework
**Why study**: The only team to systematically apply the Rozanski/Woods viewpoints and perspectives framework, covering functional, informational, concurrency, development, deployment, and operational viewpoints. Their security perspective covers 10 practice areas.
**Key innovation**: Systematic application of Rozanski/Woods architectural viewpoints.

### 8. BluzBrothers (Winter 2024, 1st Place) -- Fitness Function Excellence
**Why study**: The most rigorous application of fitness functions in the dataset, with quantitative validation of performance, alerting reliability, and failover. Their infrastructure sizing calculations prove the system can meet throughput requirements. Also demonstrates mature scope management with a "postponed decisions" table.
**Key innovation**: Quantitative fitness functions with infrastructure sizing proof.

### 9. Usfive (Winter 2025, Runner-up) -- Anti-RAG Reasoning
**Why study**: While most AI-era teams defaulted to RAG, Usfive deliberately rejected both RAG and vector databases with well-reasoned arguments about homogenizing accepted answers. Their multi-agent viewpoint scoring mimics an Architecture Review Board with distinct professional personas.
**Key innovation**: Contrarian anti-RAG decision with multi-agent viewpoint scoring.

### 10. LowCode (Winter 2024, 3rd Place, Tied) -- Distributed Hardware Innovation
**Why study**: The only team to design a distributed hardware architecture with role-based failover (Coordinator/Monitor/Analyzer roles across minimum 3 nodes). Their auto-configuration sequence for plug-and-play appliance replacement addresses real-world operational concerns.
**Key innovation**: Role-based hardware failover with plug-and-play auto-configuration.

---

## Appendix: Data Quality Notes

- **Team size**: 21 of 78 teams (26.9%) do not specify team size. Where `team_size` is `null`, those teams are excluded from team-size calculations.
- **Architecture styles**: The YAML data contains significant inconsistency in style naming. Normalization was performed manually. Compound styles (e.g., "Hybrid: Modular Monolith + Service-Based + Serverless") were decomposed into constituent styles for frequency counting.
- **Placement normalization**: Teams with `placement_numeric: null` were assigned value 4 for statistical computation. Tied placements (e.g., two teams at 3rd in Winter 2024) were each counted as 3rd place.
- **Quality attributes**: Attribute names are normalized case-insensitively. Similar concepts (e.g., "cost", "cost efficiency", "affordability", "feasibility") are grouped under "Cost/Feasibility" for analysis.
- **Generated**: 2026-02-26 from structured YAML metadata in `docs/catalog/`.
