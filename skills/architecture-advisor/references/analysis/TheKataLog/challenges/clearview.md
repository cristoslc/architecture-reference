# ClearView -- Comparative Analysis

> **Challenge:** Fall 2024 O'Reilly Architecture Kata
> **Domain:** AI-powered HR platform for reducing bias in recruitment
> **Client:** Diversity Cyber Council (501c3 Non-Profit)
> **Teams analyzed:** 3

---

## Challenge Overview

ClearView is a supplemental HR platform for the Diversity Cyber Council, a non-profit organization serving under-represented demographics in the tech industry. The system must anonymize candidate resumes using AI, construct bias-free "stories" from them, match candidates to open roles using LLMs, integrate with employers' existing HR systems, and aggregate data to reveal hiring disparities. Key tensions in the problem: the client is a non-profit with limited budget, yet the solution demands expensive AI/LLM capabilities; the system must eliminate bias while relying on LLMs that are themselves known to carry biases; and the platform must integrate with an unbounded number of third-party HR systems.

This analysis examines the three placing teams and how their architectural decisions led to their success.

---

## Team Comparison Matrix

| Dimension | **Pragmatic** (1st) | **Katamarans** (2nd) | **Ctrl+Alt+Elite** (3rd) |
|---|---|---|---|
| **Team size** | 3 | 3 | 3 |
| **Architecture style** | Service-Based + Event-Driven (selective) | Event-Driven | Event-Driven + Microservices (supporting) |
| **Top 3 quality attributes** | Interoperability, Feasibility, Testability | Cost, Abstraction, Integration | Scalability, Performance, Interoperability |
| **ADR count** | 22 | 14 | 20 |
| **C4 depth** | C1, C2, C3 (4 views) | C1, C2 | C1, C2, C3 (4 views) |
| **Event Storming** | Yes | Yes | Yes |
| **Deployment diagram** | No | Yes (Azure) | Yes (AWS) |
| **Feasibility/cost analysis** | Yes (token estimation, AI expert interview) | Yes (cost fitness function, AI pricing calculator) | No |
| **Fitness functions** | No | Yes (4 functions) | No |
| **UX prototypes** | No | No | Yes (Figma, 3 roles) |
| **Video presentation** | No | Yes | No |
| **Matching approach** | Deterministic: human-readable features extracted by LLM, then static comparison | Weighted token comparison with fine-tunable weights | Vector DB + Knowledge Graph + LLM re-ranking pipeline |

---

## Architecture Style Choices

### Service-Based with Selective Event-Driven (Pragmatic)

Pragmatic (ADR-002) selected service-based architecture as its primary style for its balance of feasibility and testability, adding event-driven capabilities only where interoperability demanded it -- for example, publishing matches as events (ADR-016) and asynchronous communication with external systems (ADR-005). This hybrid approach was explicitly motivated by the non-profit budget constraint, choosing pragmatic cost-consciousness over architectural ambition. The service-based style gave Pragmatic independently deployable services without the operational overhead of full microservices or the complexity of event-driven choreography -- a middle ground that proved to be a winning formula.

### Event-Driven Architecture (Katamarans)

Katamarans (ADR-008) chose pure event-driven architecture after evaluating microkernel (rejected for scalability) and service-oriented (rejected for high delivery costs). Their rationale emphasized loose coupling, cost efficiency through idle-until-triggered components, and evolvability in a rapidly changing AI landscape. This style aligned directly with their identification of cost as the primary driver (ADR-002), ensuring that every component could scale down to zero when not in use -- an important consideration for a non-profit with unpredictable traffic.

### Event-Driven + Microservices Hybrid (Ctrl+Alt+Elite)

Ctrl+Alt+Elite (ADR-01) adopted event-driven architecture as the primary style with microservices as supporting components. This was the most technology-rich submission, specifying Kafka as the event broker, Golang as the programming language, PostgreSQL for transactional data, Redshift for analytics, and a full AWS deployment topology. The specificity cut both ways: it demonstrated implementation readiness but lacked the cost analysis to justify the stack for a non-profit client.

### Style Comparison

The three teams represent a spectrum from conservative to ambitious. Pragmatic anchored on service-based architecture and added event-driven patterns surgically; Katamarans committed fully to event-driven architecture; Ctrl+Alt+Elite layered microservices on top of an event-driven core. All three teams were small (3 members each), and notably, the most constrained architectural choice -- Pragmatic's service-based approach -- won first place. This suggests that for budget-constrained clients, restraint in architectural complexity is rewarded when paired with deep domain analysis.

---

## What Distinguished the Top Teams

### 1. Depth of AI/LLM Risk Analysis

The clearest differentiator among the three placing teams was how seriously each engaged with the risks and costs of LLM integration -- the novel architectural challenge of this kata.

**Pragmatic** (1st) conducted an actual interview with an AI expert, performed token estimation research calculating costs per prompt ($0.001-$0.025 depending on model), and used those findings to drive multiple ADRs. Their ADR-011 (Deterministic Matching) is the standout decision: rather than letting the LLM perform matching directly (which would be expensive and non-deterministic), they designed a pipeline where the LLM extracts human-readable features, and matching is then performed deterministically. This reduced complexity from O(n*m) to O(n+m) in terms of LLM prompts. Their ADR-025 (AI Test Concept) then outlined a comprehensive testing strategy for the non-deterministic LLM components.

**Katamarans** (2nd) complemented this with a cost fitness function that calculated the per-candidate processing cost ($0.06 for a full hiring flow), enabling ongoing cost governance. Their ADR-005 (Changing AI Solution Landscape) and ADR-006 (Picking 3rd Party AI Services) demonstrated awareness that the AI market is volatile and designed abstraction layers accordingly.

**Ctrl+Alt+Elite** (3rd) designed the most technically sophisticated AI pipeline (Vector DB + Knowledge Graph + LLM re-ranking), but did not include a cost or feasibility analysis -- a significant omission given the non-profit context. This gap between the first two teams and the third illustrates that technical sophistication alone is insufficient; understanding the economic constraints of the AI components matters equally.

### 2. Explicit Prioritization and Trade-off Documentation

Each placing team made hard choices and documented their reasoning, but the sharpness of those choices correlated with placement. Pragmatic explicitly "downplayed" data integrity (ADR-004) to keep the architecture simpler, acknowledging the trade-off rather than trying to satisfy every quality attribute. Katamarans identified cost as their primary driver (ADR-002) and made every subsequent decision through that lens. Ctrl+Alt+Elite prioritized scalability and performance, leading to a more complex stack that was harder to justify for a non-profit's initial deployment.

The pattern is clear: the teams that chose fewer, sharper priorities and traced every downstream decision back to those priorities produced the most coherent architectures.

### 3. Process Rigor and Requirements Elicitation

All three placing teams performed Event Storming to discover bounded contexts and event flows. Pragmatic combined it with DDD; Katamarans used the "Six Thinking Hats" technique for requirements distillation; Ctrl+Alt+Elite used it to identify microservice boundaries. This shared commitment to domain-first design, before making technology choices, led to better-grounded service decomposition and more natural bounded contexts across all three submissions.

### 4. Completeness of the Architecture Narrative

The placing teams told complete stories from requirements through architecture decisions to known limitations. Pragmatic's Known Limitations section was particularly effective -- it acknowledged that their matching algorithm has limitations, that matching is delayed (not real-time), and that external AI rate limiting is an unsolved problem. This transparency likely built credibility with judges. Katamarans' fitness functions served a similar purpose, acknowledging that operational health must be measured and governed. Ctrl+Alt+Elite's Figma prototypes grounded the architecture in a tangible user experience, demonstrating that the technical design served real user workflows.

---

## Common Patterns

### External LLMs over Self-Hosted Models

All three teams chose to use external, third-party LLM services rather than self-hosted models. The reasoning was remarkably consistent: the non-profit context demands low upfront cost, LLM technology evolves too rapidly to commit to a specific model, and pay-as-you-go pricing is more predictable than infrastructure costs. Pragmatic (ADR-007) gave the most thorough analysis, comparing external APIs, cloud-hosted open-source models, and on-premise options before selecting external APIs for their cost and time-to-market advantages.

### Adapter/Connector Pattern for HR Integration

All three teams identified HR system integration as a first-class architectural concern. The solutions converged on similar patterns: a dedicated integration service with per-HR-system adapters or connectors. Pragmatic (ADR-023) designed an adapter-based HR Integration Service with event-driven triggers. Ctrl+Alt+Elite (ADR-12) built a custom orchestration engine with connector libraries. Katamarans designed an HR integration orchestrator. The pattern was consistent because the problem demanded it: an unbounded number of HR systems, each with potentially different APIs, data formats, and authentication mechanisms.

### Event-Driven Communication for AI Workloads

Even Pragmatic, which did not choose event-driven architecture as its primary style, used asynchronous, event-driven patterns for AI-related workloads. Their ADR-005 explicitly decided to "use event-driven architecture where needed" for external system communication. Katamarans and Ctrl+Alt+Elite, both event-driven at their core, naturally applied this pattern throughout. This reflects a practical understanding that LLM calls are inherently slow, rate-limited, and failure-prone -- all characteristics that benefit from asynchronous processing.

### Analytics as a Separate Concern

All three teams separated analytics and reporting from the transactional core. Solutions ranged from batch processing (Pragmatic ADR-003) to dedicated analytics engines (Ctrl+Alt+Elite with Redshift + QuickSight) to event-sourced analytics (Katamarans). The consistency reflects the kata's explicit requirement to "aggregate data to reveal disparities."

### Security and PII as Cross-Cutting Concerns

All three teams treated PII protection as critical, though their approaches varied. Katamarans dedicated two ADRs to PII safety (ADR-009, ADR-014) with separate secure storage. Pragmatic addressed it through their service boundaries and data isolation. Ctrl+Alt+Elite incorporated it into their microservice design. The universal recognition of PII sensitivity reflects the domain's ethical requirements.

---

## Unique Innovations Worth Highlighting

### Pragmatic: Deterministic Matching with Human-Readable Features (ADR-011)

The most architecturally significant innovation across all submissions. Rather than using LLMs for direct resume-to-job matching (which would be expensive, non-deterministic, and potentially biased), Pragmatic designed a two-phase approach: (1) use LLMs to extract a fixed set of human-readable features from both stories and job descriptions, then (2) perform matching using deterministic comparison of those features. This reduces the number of LLM calls from O(n*m) to O(n+m), makes matching transparent and testable, and creates a "spyder" visualization that hiring managers can interpret. This decision demonstrates deep understanding of both AI limitations and architectural cost optimization.

### Pragmatic: AI Test Concept (ADR-025)

A dedicated ADR for testing non-deterministic AI components. The concept involves creating large test sets with expected outputs (Resume to Story, Resume to Features, Story to Features, expected matches) and defining test scopes for each AI-mediated transformation. The ADR honestly acknowledges that "anonymization can only be verified by humans or by leveraging other LLMs (which adds complexity)."

### Katamarans: Fitness Functions for Operational Governance

Katamarans was the only top-placing team to define explicit fitness functions: Cost (per-candidate AI processing cost), Event Health Formula (percentage of failed events), Eventual Consistency (cross-component consistency metrics), and Sensitive Data Security (PII access control validation). The Cost fitness function is particularly noteworthy: it calculates that processing one candidate through the full hiring flow costs $0.06 in AI service fees, enabling the business to set minimum resume unlock prices that ensure profitability.

### Katamarans: Six Thinking Hats for Requirements Elicitation

A structured requirements elicitation technique where each "hat" (representing job candidate, DEI consultant, employer, solution owner, architect, HR manager) brought a different perspective. This approach surfaced requirements that pure technical analysis might miss, such as the candidate's need for transparency in how their data is used.

### Ctrl+Alt+Elite: Vector DB + Knowledge Graph + LLM Re-Ranking Pipeline

The most technically advanced AI architecture. Resumes and job postings are parsed into sections, stored as vector embeddings in a Vector Database (ADR-03) and as entities/relationships in a Knowledge Graph (ADR-04). Similarity metrics (Euclidean Distance, Cosine Similarity, Jaccard Similarity, SimRank) retrieve initial matches, a threshold/top-N filter removes low-relevance results, and an LLM re-ranks the remaining candidates (ADR-05). The Knowledge Graph integration is particularly innovative -- it captures relationships between skills, roles, and experience that pure vector similarity might miss, and helps mitigate LLM hallucinations.

### Ctrl+Alt+Elite: Full UX Prototypes

The only placing team to include Figma prototypes for all three user roles (Candidate, Employer, Admin), providing a tangible demonstration of the user experience that the architecture is designed to support.

---

## Lessons for Practitioners

### 1. For AI-heavy systems, architecture must constrain the AI, not just enable it

The most successful teams (Pragmatic, Katamarans) designed their architectures to limit and control LLM usage rather than giving the AI free rein. Pragmatic's deterministic matching approach (ADR-011) is the exemplar: by extracting human-readable features first and matching deterministically, they made the system testable, explainable, and cost-efficient. The lesson is that when integrating non-deterministic, expensive AI components, the architecture should create deterministic boundaries around them.

### 2. Cost analysis is not optional for non-profit clients

Teams that performed explicit cost analysis (Pragmatic's token estimation, Katamarans' cost fitness function) demonstrated that they understood the client's context. Ctrl+Alt+Elite proposed an AWS-heavy architecture without a cost analysis, leaving a credibility gap that likely contributed to their third-place finish. For any budget-constrained client, the architecture must justify its own cost of operation.

### 3. Fewer, sharper quality attribute priorities beat a long list

Pragmatic chose 3 attributes (Interoperability, Feasibility, Testability). Katamarans chose 3 (Cost, Abstraction, Integration). Ctrl+Alt+Elite chose 3 (Scalability, Performance, Interoperability). All three teams kept their priorities focused, which produced coherent architectures where every decision could be evaluated against a small set of criteria. When everything is a priority, nothing is.

### 4. Event Storming is a differentiator in kata competitions

All three placing teams performed Event Storming. This technique forces teams to engage with the domain before making technology choices, leading to better-grounded service decomposition and more natural bounded contexts. For architecture katas specifically, it provides visible evidence of a rigorous design process.

### 5. Known limitations build credibility

Pragmatic's explicit Known Limitations section -- acknowledging delayed matching, rate limiting challenges, and user administration gaps -- was a distinguishing feature. In architecture katas (and real projects), admitting what the architecture cannot do demonstrates maturity and builds trust. Judges and stakeholders respond better to honest trade-offs than to implied perfection.

### 6. Service-based architecture deserves more respect

In a landscape where microservices and event-driven architectures receive the most attention, Pragmatic's service-based entry won first place. Service-based architecture offers a pragmatic middle ground: independently deployable services without the operational overhead of full microservices or the complexity of event-driven choreography. For startups, non-profits, and organizations with limited DevOps maturity, it is often the right choice.

### 7. The matching algorithm is the architectural fulcrum of AI hiring platforms

All three teams had to solve the matching problem, and their approaches were the most varied and architecturally significant decisions in each submission. The spectrum ranged from Katamarans' weighted token comparison, through Pragmatic's deterministic feature matching, to Ctrl+Alt+Elite's Vector DB + Knowledge Graph + LLM re-ranking. The "right" approach depends on scale, budget, and accuracy requirements -- but the architectural decision must be made explicitly and early, as it cascades into cost, performance, testability, and explainability.

### 8. Abstraction layers around AI services are essential for longevity

Multiple teams (Katamarans ADR-005, ADR-006; Pragmatic ADR-007) designed abstraction layers between their architecture and external AI services. Given that LLM providers, pricing, and capabilities change rapidly, this is not optional -- it is a survival requirement. Any team building on LLMs today should assume they will need to swap providers within 18 months.
