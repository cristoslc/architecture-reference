# Architecture Kata Submission Checklist

## Overview

Based on analysis of **78 teams** across **11 seasons** of the O'Reilly Architecture Katas (Fall 2020 through Winter 2025), this checklist captures the patterns that statistically predict success. The data is drawn from structured YAML metadata cataloged for each team, with placement correlations computed across first-place winners (n=11), second-place finishers (n=11), third-place finishers (n=12), and runners-up (n=44).

**The core finding**: Winning teams do not win by choosing the "right" architecture style. They win through depth of justification, disciplined decision-making, feasibility awareness, and completeness of their architecture narrative. The strongest single predictor of top-2 placement is the presence of a feasibility/cost analysis (50% of top-2 teams vs. 11% of runners-up -- a 4.5x ratio).

---

## Pre-Submission Scoring Rubric

Use this weighted checklist to score your submission before finalizing. Each item is weighted based on observed correlation between its presence and top-2 placement across the 78-team dataset.

---

### Tier 1: Must-Have (Foundation) -- 40 points

These are the baseline expectations. Submissions missing items from this tier have never won first or second place.

- [ ] **Problem analysis and requirements elicitation (10 pts)**
  - Actors/actions analysis identifying all user roles and system interactions
  - Assumptions documented where requirements are ambiguous
  - Domain questions explored and answered (not just restated)
  - _Scoring: Full marks for event storming or structured discovery method (all 3 top-placing teams in ClearView Fall 2024 used Event Storming; only 1 of 4 runners-up did). Half marks for basic requirements restatement._
  - _Exemplar: Litmus (Winter 2025) -- rigorous event storming before designing AI components; Hananoyama (Fall 2020) -- deep domain Q&A exploring how smart fridges actually differ from kiosks_

- [ ] **Architecture style selection with documented rationale (10 pts)**
  - Explicit comparison of at least 2-3 candidate styles
  - Scoring matrix or structured evaluation against quality attributes
  - Style justified by the problem context, not by industry trends
  - _Scoring: Full marks for structured comparison with rejected alternatives documented. Half marks for stating a style without comparison._
  - _Exemplar: ArchColider (Fall 2020) -- scored 4 styles against 10 quality attributes in a comparison matrix, chose Modular Monolith (contrarian, but won 1st); Katamarans (Fall 2024) -- evaluated microkernel, service-oriented, and event-driven with explicit rejection rationale_

- [ ] **At least 12 ADRs covering key decisions (10 pts)**
  - First-place teams average 15.0 ADRs (median 15); runners-up average 8.5 (median 8)
  - 73% of first-place winners have 12+ ADRs; only 27% of runners-up meet this threshold
  - Each ADR should include: context, decision, considered alternatives, consequences, and trade-offs
  - _Scoring: 10 pts for 15+ ADRs with depth; 7 pts for 10-14 with depth; 5 pts for 5-9; 2 pts for fewer than 5. Quality multiplier: reduce score by 30% if ADRs lack alternatives and consequences._
  - _Exemplar: Pragmatic (Fall 2024) -- 22 ADRs including AI-specific decisions and a dedicated AI test concept; BluzBrothers (Winter 2024) -- 20 ADRs including "negative" ADRs for what they excluded_

- [ ] **System context diagram showing actors and external systems (10 pts)**
  - Clear identification of all external actors (users, systems, third-party services)
  - System boundary explicitly drawn
  - All integration points visible
  - _Scoring: Full marks for a C1-level context diagram with all actors and external systems labeled. Half marks for an ad-hoc diagram missing actors or integrations._
  - _Exemplar: Katamarans (Fall 2024) -- C4 Context (L1) with all actors, external AI services, and HR systems; Ctrl+Alt+Elite (Fall 2024) -- C4 Context with AWS infrastructure boundary_

---

### Tier 2: Differentiators (What Winners Do) -- 35 points

These are the items that separate top-2 finishers from the middle of the pack. Each has a statistically significant correlation with high placement.

- [ ] **Feasibility/cost analysis (10 pts)** -- _strongest single predictor of placement_
  - 50% of top-2 teams include this vs. only 11% of runners-up (+39 percentage point gap, the largest in the dataset)
  - Quantitative cost projections with specific numbers (cloud service costs, LLM token costs, infrastructure estimates)
  - For non-profit/startup katas: demonstrating the architecture is financially viable for the client
  - _Scoring: 10 pts for quantitative analysis with concrete numbers and scenarios. 6 pts for qualitative feasibility discussion. 0 pts if absent._
  - _Exemplar: ArchColider (Fall 2020) -- three growth scenarios (MIN/PROJECTED/RAPID) with line-item AWS costs, 1-year TCO of $12K-$22K; ZAITects (Winter 2025) -- 5X productivity increase, 80% cost reduction with specific dollar figures; DevExperts (Fall 2024) -- AWS Calculator link with $8,448/year estimate_

- [ ] **C4 diagrams at least to Container level (5 pts)**
  - 55% of top-2 teams use C4 diagrams vs. 32% of runners-up (+23 pts gap)
  - C4 at multiple levels demonstrates ability to communicate architecture at different granularities
  - _Scoring: 5 pts for C1+C2+C3 (or deeper). 3 pts for C1+C2. 1 pt for C1 only. 0 pts for no C4._
  - _Exemplar: Pragmatic (Fall 2024) -- C1, C2, and four separate C3 component views; AchitectsEvolutionZone (Winter 2024) -- the only MonitorMe team to produce C3 component-level diagrams_

- [ ] **Event storming or structured domain analysis (5 pts)**
  - Winners disproportionately use structured discovery methods before making technology choices
  - All 3 winning teams in ClearView (Fall 2024) performed Event Storming; only 1 of 4 runners-up did
  - Bounded context identification grounds service decomposition in the domain rather than guesswork
  - _Scoring: 5 pts for event storming with documented output (event flows, bounded contexts). 3 pts for DDD analysis without event storming. 1 pt for informal domain discussion._
  - _Exemplar: Litmus (Winter 2025) -- event storming to discover domain boundaries before designing AI; Pragmatic (Fall 2024) -- combined DDD with event storming_

- [ ] **Deployment view with infrastructure details (5 pts)**
  - 82% of first-place teams include a deployment view; only 50% of runners-up do (+27 pts for top-2 vs. runners-up)
  - Specific cloud services, infrastructure topology, or on-premises hardware layout
  - Teams naming specific services (AWS, Azure, GCP) produce more actionable deployment views than "cloud (unspecified)"
  - _Scoring: 5 pts for detailed deployment with specific cloud services or infrastructure. 3 pts for basic deployment view. 0 pts if absent._
  - _Exemplar: Katamarans (Fall 2024) -- Azure deployment diagram with concrete cloud services; BluzBrothers (Winter 2024) -- Kubernetes on-premises with specific instance counts_

- [ ] **Evolutionary architecture approach (5 pts)**
  - 73% of first-place winners list 2+ architecture styles (phased or complementary) vs. 52% of runners-up
  - MVP-to-target roadmap showing how architecture evolves with the business
  - Phased migration plans for brownfield systems
  - _Scoring: 5 pts for explicit MVP-to-target roadmap with phase-specific architecture changes. 3 pts for mentioning evolution without a roadmap. 0 pts for a single big-bang target state._
  - _Exemplar: ZAITects (Winter 2025) -- MVP parallel grading, Growth AI-primary, Matured minimal human involvement; Hey Dragon (Fall 2020) -- three-stage evolution from monolith to service-based to event-driven microservices with transition criteria; Jedis (Fall 2020) -- architecture characteristics changing per business growth phase_

- [ ] **Quality attribute prioritization with trade-off analysis (5 pts)**
  - Winners choose 3-5 priority attributes and make every decision through that lens
  - The "Scalability Trap": scalability is cited by 68% of runners-up but only 55% of winners -- over-indexing on scalability at the expense of pragmatic concerns is a negative signal
  - Cost/feasibility awareness is 3.2x more common among winners (45%) than runners-up (14%)
  - _Scoring: 5 pts for 3-5 prioritized attributes with explicit trade-offs documented (including what was deprioritized). 3 pts for a prioritized list without trade-off reasoning. 1 pt for an unprioritized long list._
  - _Exemplar: Pragmatic (Fall 2024) -- Interoperability, Feasibility, Testability as top 3, with ADR-004 explicitly "downplaying" data integrity; BluzBrothers (Winter 2024) -- wrote separate ADRs for characteristics they deliberately downplayed (scalability, deployability)_

---

### Tier 3: Excellence (Standing Out) -- 25 points

These items are uncommon even among winners, but when present, they create memorable submissions that stand out to judges.

- [ ] **Fitness functions with quantitative targets (5 pts)**
  - Only ~17% of all teams mention fitness functions -- the most underutilized concept from "Fundamentals of Software Architecture"
  - Quantitative fitness functions with provable calculations are extremely rare and highly differentiated
  - _Scoring: 5 pts for quantitative fitness functions with numeric proof (timing calculations, cost thresholds, throughput validation). 3 pts for qualitative fitness functions. 0 pts if absent._
  - _Exemplar: BluzBrothers (Winter 2024) -- end-to-end timing calculation proving 693ms response (under 1-second requirement), plus alert guarantee and failover validation; Katamarans (Fall 2024) -- cost fitness function calculating $0.06 per-candidate AI processing cost, plus event health and consistency metrics_

- [ ] **Video presentation with clear narrative (5 pts)**
  - 50% of top-2 teams have videos vs. 36% of runners-up (moderate positive signal)
  - Many winners succeed without a video, but it provides an additional communication channel
  - _Scoring: 5 pts for a professional video walkthrough with clear narrative arc. 3 pts for a basic video or slide recording. 0 pts if absent._
  - _Exemplar: Litmus (Winter 2025) -- video presentation complementing written documentation; AchitectsEvolutionZone (Winter 2024) -- video with full transcript_

- [ ] **Negative ADRs documenting rejected approaches (5 pts)**
  - Top teams demonstrate architectural maturity by documenting what they chose NOT to build and why
  - Shows judges that the team evaluated alternatives rigorously rather than including everything
  - _Scoring: 5 pts for 3+ explicit rejection ADRs with detailed rationale. 3 pts for 1-2 rejection ADRs. 0 pts if all ADRs are positive decisions only._
  - _Exemplar: ZAITects (Winter 2025) -- detailed anti-pattern analysis of why Agentic AI was deliberately avoided; Litmus (Winter 2025) -- rejected AI anti-cheating agent (privacy/complexity) and LLM caching (answer variability); BluzBrothers (Winter 2024) -- ADRs for "scalability downplayed," "deployability downplayed," "patient registration out of scope," and "mobile app out of scope"_

- [ ] **Security analysis beyond basics (5 pts)**
  - 37 teams list security as a quality attribute, but fewer than 15 provide substantive security architecture
  - Threat models, encryption strategies, zero-trust approaches, data privacy compliance, or domain-specific security (HIPAA, GDPR, OWASP)
  - _Scoring: 5 pts for a dedicated security perspective with threat model or domain-specific security analysis. 3 pts for security ADRs with specific mechanisms (encryption, access control). 1 pt for listing security as a quality attribute without implementation detail._
  - _Exemplar: ArchColider (Fall 2020) -- zero trust from day one, with security tokens on internal module calls anticipating future service extraction; ZAITects (Winter 2025) -- OWASP Top 10 for LLM security; Katamarans (Fall 2024) -- two dedicated PII safety ADRs with separate secure storage_

- [ ] **Unique innovation or framework application (5 pts)**
  - A novel technique, contrarian decision, or systematic framework application that no other team in the same kata used
  - Innovation can be non-technical (Software Architecture Guild's expert compensation reform) or methodological (Mighty Orbots' wireframe-driven architecture discovery)
  - _Scoring: 5 pts for a genuinely novel contribution that judges will remember. 3 pts for applying a known framework systematically (Rozanski/Woods, Team Topologies). 0 pts for standard approaches._
  - _Exemplar: Software Architecture Guild (Winter 2025) -- microkernel architecture enabling 6 parallel AI solutions, plus expert compensation reform addressing human incentives; Usfive (Winter 2025) -- contrarian rejection of RAG with multi-agent viewpoint scoring mimicking an Architecture Review Board; Pragmatic (Fall 2024) -- deterministic matching reducing LLM calls from O(n*m) to O(n+m); It Depends (Fall 2022) -- "Straight Through Architecture" with end-to-end requirement traceability_

---

## Week-by-Week Timeline

Based on the typical 4-5 week kata timeline, here is a suggested schedule that front-loads discovery and allocates time to the differentiators that most teams skip.

### Week 1: Discovery and Problem Analysis (Days 1-7)

**Goal**: Understand the domain deeply before touching architecture.

- [ ] Read the kata requirements as a team (multiple passes)
- [ ] Identify all actors, actions, and external systems
- [ ] List assumptions and unknowns; research external systems (APIs, constraints, pricing)
- [ ] Conduct Event Storming or structured domain discovery workshop
- [ ] Identify bounded contexts and domain events
- [ ] Draft 3-5 prioritized quality attributes with explicit trade-off reasoning
- [ ] Research the problem domain's standards and protocols (HL7 for healthcare, OWASP for AI security, etc.)

**Anti-pattern to avoid**: Jumping straight to technology selection or architecture style choice.

### Week 2: Architecture Decisions (Days 8-14)

**Goal**: Select and justify your architecture approach.

- [ ] Evaluate 2-3 candidate architecture styles using a structured comparison matrix
- [ ] Document your style selection as an ADR with rejected alternatives
- [ ] Identify the key architectural decisions that need ADRs (target 15+ by submission)
- [ ] Write your first 5-8 ADRs covering: architecture style, data strategy, integration approach, deployment model, and 1-2 decisions specific to the kata domain
- [ ] Draft your C1 context diagram and begin C2 container diagrams
- [ ] Identify what you are deliberately excluding from scope (write "negative" ADRs)

**Anti-pattern to avoid**: Trying to satisfy every quality attribute equally. Choose 3-5 and own the trade-offs.

### Week 3: Architecture Depth (Days 15-21)

**Goal**: Add the differentiators that separate winners from runners-up.

- [ ] Complete C2 container diagrams; begin C3 component diagrams for key services
- [ ] Write your feasibility/cost analysis (cloud service pricing, LLM token costs, infrastructure estimates)
- [ ] Define your deployment view with specific infrastructure (cloud provider, services, topology)
- [ ] Design your evolutionary roadmap (MVP to target state with phase-specific characteristics)
- [ ] Write 5-7 more ADRs covering integration, security, and domain-specific decisions
- [ ] Draft fitness functions with quantitative targets where possible

**Anti-pattern to avoid**: Spending all time on diagrams and neglecting the written rationale. Judges read ADRs and analysis, not just pictures.

### Week 4: Polish and Completeness (Days 22-28)

**Goal**: Fill gaps, add excellence items, and ensure narrative coherence.

- [ ] Review all ADRs for completeness (alternatives, consequences, trade-offs)
- [ ] Add security analysis beyond the basics (threat model, encryption strategy, compliance)
- [ ] Write a Known Limitations section -- honesty builds credibility
- [ ] Add sequence diagrams for 2-3 key workflows (moderate value, but adds depth)
- [ ] Consider recording a video walkthrough (moderate positive signal)
- [ ] Score your submission against this rubric and address the biggest gaps

**Anti-pattern to avoid**: Adding more features instead of deepening existing decisions. Judges reward depth over breadth.

### Week 5 (if available): Final Review (Days 29-35)

**Goal**: External review and final improvements.

- [ ] Have someone outside the team review the submission for clarity
- [ ] Verify all diagrams are consistent with the written architecture
- [ ] Ensure the README provides a clear navigation path through the submission
- [ ] Run through the Scoring Rubric one final time
- [ ] Submit

---

## Common Pitfalls to Avoid

These are the most frequently observed mistakes across 78 submissions, derived from the cross-cutting analysis.

### 1. Skipping Feasibility Analysis (75.6% of all teams)
The single most common gap and the single strongest predictor of placement. Over three-quarters of teams provide no cost or feasibility analysis. Even a rough back-of-envelope cost estimate dramatically increases credibility. For budget-constrained clients (non-profits, startups), this omission is particularly damaging.

### 2. Defaulting to Microservices Without Justification
Microservices appear at nearly equal rates across all placement levels (33-55%). It is the most commonly cited style but does not predict success. The winner of Fall 2020 (ArchColider) chose a Modular Monolith. The winner of Spring 2022 (PegasuZ) also used a Modular Monolith phase. Judges reward contextual fit, not industry fashion. If you choose microservices, justify why the operational overhead is warranted for your specific problem.

### 3. Ignoring Fitness Functions (~83% of all teams)
The most underutilized concept from "Fundamentals of Software Architecture." Fitness functions provide quantitative validation that your architecture meets its stated quality attributes. BluzBrothers won Winter 2024 with end-to-end timing proof (693ms under a 1-second requirement). Most teams claim "high performance" or "high availability" without proving it.

### 4. The Scalability Trap
Scalability is cited by 68% of runners-up but only 55% of winners. Over-indexing on scalability -- at the expense of pragmatic concerns like cost, data integrity, and simplicity -- appears to be a negative signal. Judges reward teams that prioritize the right attributes for the problem context, not teams that default to scalability as a universal goal.

### 5. ADR Quantity Without Quality
Self-Driven Team (Fall 2020) had 20 ADRs and placed as a runner-up. ArchColider had 16 and won. The difference was depth: structured scoring matrices, concrete consequences, and explicit alternatives vs. ADRs that state a decision without showing the reasoning. An ADR that says "We chose X because of A, B, C; we rejected Y because of D, E; the consequences are F, G" is worth more than five ADRs that each say "We chose X."

### 6. Missing Deployment View (41% of all teams)
82% of first-place teams include a deployment view. Not having one is a significant negative signal, especially for on-premises or infrastructure-intensive challenges. Teams that name specific services (AWS EC2, Azure Functions, GCP Cloud Run) produce more actionable views than "cloud (unspecified)."

### 7. Treating Security as a Checkbox
37 teams list security as a quality attribute, but fewer than 15 provide substantive security architecture. Mentioning "security" without specific mechanisms (encryption strategies, access control models, threat models, compliance requirements) does not differentiate. Winners like ArchColider (zero trust), ZAITects (OWASP Top 10 for LLMs), and Katamarans (PII safety ADRs) go deep.

### 8. Not Documenting What You Rejected
Top teams earn differentiation through disciplined exclusion, not just inclusion. ZAITects rejected Agentic AI with a detailed anti-pattern analysis. Litmus rejected AI anti-cheating and LLM caching with full ADRs. BluzBrothers wrote ADRs for characteristics they deliberately downplayed. Documenting rejected approaches demonstrates that the team evaluated alternatives rigorously.

### 9. No Evolutionary Roadmap
For brownfield challenges (Sysops Squad, Farmacy Family), many teams design a target architecture without addressing how to get there. Only about 30% of applicable teams provide phased migration plans. Even for greenfield challenges, showing how the architecture evolves from MVP to full scale (as Jedis and Hey Dragon did) resonates with judges.

### 10. Long, Unfocused Quality Attribute Lists
Jazz Executor (Fall 2024) listed 10 quality attributes without clear prioritization. Pragmatic chose 3. When everything is a priority, nothing is. Winners select 3-5 attributes and make every subsequent decision through that lens, explicitly documenting what was deprioritized and why.

---

## Reference Exemplars

For each major checklist area, these teams provide the strongest examples to study. Repository links are available in the kata-log catalog.

### Problem Analysis and Requirements Elicitation
| Team | Season | What to Study |
|------|--------|---------------|
| Litmus | Winter 2025 | Event storming as formal discovery before AI design |
| Pragmatic | Fall 2024 | DDD + event storming combined; interview with AI expert |
| Hananoyama | Fall 2020 | Deep domain Q&A exploring physical-world constraints |
| Mighty Orbots | Winter 2024 | Wireframe-driven architecture discovery |
| Katamarans | Fall 2024 | Six Thinking Hats for requirements elicitation |

### Architecture Style Selection and ADR Quality
| Team | Season | What to Study |
|------|--------|---------------|
| ArchColider | Fall 2020 | Structured scoring matrix comparing 4 styles against 10 attributes |
| BluzBrothers | Winter 2024 | 20 ADRs including negative/exclusion ADRs; event storming |
| Pragmatic | Fall 2024 | 22 ADRs with deep AI-specific decisions |
| Software Architecture Guild | Winter 2025 | Few (6) but deeply considered, high-impact ADRs |
| Mighty Orbots | Winter 2024 | Superseded ADR showing iterative decision-making |

### Feasibility and Cost Analysis
| Team | Season | What to Study |
|------|--------|---------------|
| ArchColider | Fall 2020 | Three growth scenarios with line-item AWS costs |
| ZAITects | Winter 2025 | Business outcome projections (5X productivity, 80% cost reduction) |
| Katamarans | Fall 2024 | Cost fitness function ($0.06/candidate); AI pricing calculator |
| DevExperts | Fall 2024 | AWS Calculator with specific $8,448/year estimate |
| Pragmatic | Fall 2024 | Token estimation research for LLM cost feasibility |

### C4 and Architectural Diagrams
| Team | Season | What to Study |
|------|--------|---------------|
| Pragmatic | Fall 2024 | C1 + C2 + four separate C3 component views |
| The Archangels | Fall 2021 | Full C4 hierarchy -- the most complete diagram set in the dataset |
| AchitectsEvolutionZone | Winter 2024 | Only MonitorMe team to reach C3 component level |
| Miyagi's Little Forests | Fall 2020 | Five distinct runtime architecture views with element catalogs |
| Ctrl+Alt+Elite | Fall 2024 | C4 through component level plus AWS deployment diagram |

### Deployment Views
| Team | Season | What to Study |
|------|--------|---------------|
| Katamarans | Fall 2024 | Azure deployment with concrete cloud services |
| BluzBrothers | Winter 2024 | Kubernetes on-premises with specific instance counts |
| Ctrl+Alt+Elite | Fall 2024 | Complete AWS deployment architecture |
| LowCode | Winter 2024 | Distributed hardware with role-based failover (3-2-1 node model) |
| InfyArchs | Winter 2024 | K3s edge computing with Rancher and GitOps |

### Evolutionary Architecture and Phased Roadmaps
| Team | Season | What to Study |
|------|--------|---------------|
| ZAITects | Winter 2025 | MVP/Growth/Matured phased rollout for AI adoption |
| Hey Dragon | Fall 2020 | Three-stage evolution (monolith to service-based to event-driven) |
| Jedis | Fall 2020 | Architecture characteristics changing per business growth phase |
| ArchColider | Fall 2020 | Modular Monolith designed for future service extraction |
| Equihire Architects | Fall 2024 | Strategy Pattern as a dial between cost and accuracy |

### Fitness Functions
| Team | Season | What to Study |
|------|--------|---------------|
| BluzBrothers | Winter 2024 | Quantitative fitness functions with numeric proof (693ms end-to-end) |
| Katamarans | Fall 2024 | Four fitness functions: cost, event health, consistency, PII security |

### Security Analysis
| Team | Season | What to Study |
|------|--------|---------------|
| ArchColider | Fall 2020 | Zero trust from day one on internal module calls |
| ZAITects | Winter 2025 | OWASP Top 10 for LLM security |
| Profitero Data Alchemists | Fall 2023 | Security perspective covering 10 practice areas |
| Katamarans | Fall 2024 | Two dedicated PII safety ADRs |

### Unique Innovation
| Team | Season | What to Study |
|------|--------|---------------|
| Software Architecture Guild | Winter 2025 | Microkernel for 6 parallel AI solutions; expert compensation reform |
| Usfive | Winter 2025 | Contrarian anti-RAG with multi-agent viewpoint scoring |
| Pragmatic | Fall 2024 | Deterministic matching reducing LLM calls from O(n*m) to O(n+m) |
| It Depends | Fall 2022 | "Straight Through Architecture" with requirement traceability |
| ConnectedAI | AI Winter 2024 | Quantitative multi-model LLM evaluation with Ragas framework |
| Profitero Data Alchemists | Fall 2023 | Systematic Rozanski/Woods viewpoints and perspectives |
| LowCode | Winter 2024 | Distributed hardware with plug-and-play auto-configuration |

---

## Scoring Interpretation

Total your score across all three tiers (maximum 100 points):

| Score Range | Interpretation | Historical Correlation |
|-------------|---------------|----------------------|
| **80-100** | **Strong contender for top 3.** Your submission covers the foundation, includes the differentiators winners use, and has at least some excellence items. When the Winning Formula scorecard is applied retrospectively, all 11 first-place winners score 79-87. | Top-2 placement in ~80% of cases |
| **60-79** | **Competitive runner-up.** You have a solid foundation and some differentiators, but are missing key items (often feasibility analysis or evolutionary approach). Strong second- and third-place finishers land here. | Top-3 placement in ~60% of cases |
| **40-59** | **Solid participation.** You have the basics covered but are missing most differentiators. Typical of teams that produce a competent architecture but do not stand out. Focus on adding feasibility analysis, C4 depth, and negative ADRs. | Occasional 3rd place; usually runner-up |
| **Below 40** | **Significant gaps.** Major foundation items are missing (few ADRs, no structured rationale, no context diagram). Before adding advanced items, focus on the Tier 1 fundamentals. Retrospectively, the two lowest-scoring teams (Arch Angels at 24, Transformers at 18) were a runner-up and 3rd place respectively. | Runner-up in nearly all cases |

### Score Calibration Against Historical Winners

These scores are estimated by applying the Predictive Scorecard from the cross-cutting analysis:

| Team | Season | Placement | Estimated Score |
|------|--------|-----------|-----------------|
| The Archangels | Fall 2021 | 1st | 87 |
| Pragmatic | Fall 2024 | 1st | 86 |
| BluzBrothers | Winter 2024 | 1st | 84 |
| ZAITects | Winter 2025 | 1st | 83 |
| MonArch | Fall 2022 | 1st | 82 |
| ArchColider | Fall 2020 | 1st | 81 |
| PegasuZ | Spring 2022 | 1st | 79 |
| Los Ingenials | Fall 2022 | Runner-up | 62 |
| Arch Angels | Fall 2021 | Runner-up | 24 |
| Transformers | AI Winter 2024 | 3rd | 18 |

The scorecard correctly identifies top-2 teams in approximately 80% of cases when applied to the full 78-team dataset.

---

## Quick Reference: The Five Things Winners Do Consistently

1. **Document 15+ decisions** with well-structured ADRs that show trade-off reasoning
2. **Include feasibility analysis** demonstrating cost awareness and practical constraints
3. **Use C4 diagrams** at multiple levels to communicate architecture at different granularities
4. **Adopt event-driven patterns** as a primary or supporting architecture style (73% of winners)
5. **Propose evolutionary approaches** with phased roadmaps from MVP to target state

---

*Generated from analysis of 78 teams across 11 O'Reilly Architecture Kata seasons (Fall 2020 -- Winter 2025). Source data: `docs/analysis/cross-cutting.md` and `docs/analysis/challenges/`. Team catalogs: `docs/catalog/`.*
