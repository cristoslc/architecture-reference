# ClearView -- Comparative Analysis

> **Challenge:** Fall 2024 O'Reilly Architecture Kata
> **Domain:** AI-powered HR platform for reducing bias in recruitment
> **Client:** Diversity Cyber Council (501c3 Non-Profit)
> **Teams analyzed:** 7

---

## Challenge Overview

ClearView is a supplemental HR platform for the Diversity Cyber Council, a non-profit organization serving under-represented demographics in the tech industry. The system must anonymize candidate resumes using AI, construct bias-free "stories" from them, match candidates to open roles using LLMs, integrate with employers' existing HR systems, and aggregate data to reveal hiring disparities. Key tensions in the problem: the client is a non-profit with limited budget, yet the solution demands expensive AI/LLM capabilities; the system must eliminate bias while relying on LLMs that are themselves known to carry biases; and the platform must integrate with an unbounded number of third-party HR systems.

Seven teams tackled this challenge. Three placed (1st through 3rd), and four were recognized as runners-up.

---

## Team Comparison Matrix

| Dimension | **Pragmatic** (1st) | **Katamarans** (2nd) | **Ctrl+Alt+Elite** (3rd) | **ArchZ** (Runner-up) | **DevExperts** (Runner-up) | **Equihire Architects** (Runner-up) | **Jazz Executor** (Runner-up) |
|---|---|---|---|---|---|---|---|
| **Team size** | 3 | 3 | 3 | 5 | 5 | 4 | 4 |
| **Architecture style** | Service-Based + Event-Driven (selective) | Event-Driven | Event-Driven + Microservices (supporting) | Mixed per-quanta (Event-Driven, Microservices, Service-Based) | Event-Driven | Service-Based | Microservices |
| **Top 3 quality attributes** | Interoperability, Feasibility, Testability | Cost, Abstraction, Integration | Scalability, Performance, Interoperability | Security, Availability, Scalability | Scalability, Data Integrity, Extensibility | Cost, Interoperability, Simplicity | Scalability, Availability, Consistency |
| **ADR count** | 22 | 14 | 20 | 21 | 10 | 9 | 11 |
| **C4 depth** | C1, C2, C3 (4 views) | C1, C2 | C1, C2, C3 (4 views) | C1, C2 (per quanta) | C1, C2, C3 (4 views) | None (ad-hoc component diagrams) | C1, C2, C3 |
| **Event Storming** | Yes | Yes | Yes | Yes (actor-action) | No | No | No |
| **Deployment diagram** | No | Yes (Azure) | Yes (AWS) | Yes (AWS/K8s) | Yes (AWS) | No | Yes |
| **Feasibility/cost analysis** | Yes (token estimation, AI expert interview) | Yes (cost fitness function, AI pricing calculator) | No | No | Yes ($8,448/year with AWS Calculator) | Yes (scoped to 5,000 candidates) | No |
| **Fitness functions** | No | Yes (4 functions) | No | No | No | No | Yes |
| **UX prototypes** | No | No | Yes (Figma, 3 roles) | Yes (Figma, 4 roles) | No | No | Yes (video walkthroughs) |
| **Video presentation** | No | Yes | No | Yes (Loom) | No | No | Yes |
| **Matching approach** | Deterministic: human-readable features extracted by LLM, then static comparison | Weighted token comparison with fine-tunable weights | Vector DB + Knowledge Graph + LLM re-ranking pipeline | RAG with vector search | LLM-based (Step Functions workflow) | Cosine Similarity with Strategy Pattern (LLM alternative) | AI/ML service (not deeply specified) |

---

## Architecture Style Choices

### Service-Based Architecture (Pragmatic, Equihire Architects)

Two teams chose service-based architecture as their primary style, both explicitly motivated by the non-profit budget constraint. Pragmatic (ADR-002) selected service-based architecture for its balance of feasibility and testability, adding event-driven capabilities only where interoperability demanded it -- for example, publishing matches as events (ADR-016) and asynchronous communication with external systems (ADR-005). Equihire Architects (ADR-02) made a nearly identical choice, explicitly noting that microservices and event-driven architectures were considered but rejected because "cost and simplicity were the main characteristics which made the difference."

The service-based style proved to be a winning approach: both teams that chose it placed well (1st and runner-up), suggesting that judges valued pragmatic cost-consciousness over architectural ambition.

### Event-Driven Architecture (Katamarans, DevExperts)

Katamarans (ADR-008) chose pure event-driven architecture after evaluating microkernel (rejected for scalability) and service-oriented (rejected for high delivery costs). Their rationale emphasized loose coupling, cost efficiency through idle-until-triggered components, and evolvability in a rapidly changing AI landscape. DevExperts also selected event-driven architecture but layered it on a fully serverless AWS stack (Lambda, SQS, Step Functions), achieving the lowest estimated infrastructure cost of all teams at $8,448/year.

### Event-Driven + Microservices Hybrid (Ctrl+Alt+Elite)

Ctrl+Alt+Elite (ADR-01) adopted event-driven architecture as the primary style with microservices as supporting components. This was the most technology-rich submission, specifying Kafka as the event broker, Golang as the programming language, PostgreSQL for transactional data, Redshift for analytics, and a full AWS deployment topology. The specificity cut both ways: it demonstrated implementation readiness but lacked the cost analysis to justify the stack for a non-profit client.

### Per-Quanta Style Selection (ArchZ)

ArchZ took the most theoretically sophisticated approach, treating the platform as a collection of architectural quanta, each with its own style. Their AI and Matching quanta used event-driven architecture; User Profile and Integrations used microservices; and Invoice, Notification, and Survey used service-based architecture. While intellectually rigorous, this approach introduced significant operational complexity that was not offset by a feasibility analysis.

### Full Microservices (Jazz Executor)

Jazz Executor was the only team to select a pure microservices architecture. With 10 quality attributes listed (the most of any team) and no clear top-3 prioritization, the submission lacked the focus that characterised the winning entries. The microservices choice was the most expensive and operationally complex option, and the absence of a cost analysis was a notable gap for a non-profit client.

---

## What Separated Winners from Runners-Up

### 1. Depth of AI/LLM Risk Analysis

The clearest differentiator was how seriously teams engaged with the risks and costs of LLM integration -- the novel architectural challenge of this kata.

**Pragmatic** (1st) conducted an actual interview with an AI expert, performed token estimation research calculating costs per prompt ($0.001-$0.025 depending on model), and used those findings to drive multiple ADRs. Their ADR-011 (Deterministic Matching) is the standout decision: rather than letting the LLM perform matching directly (which would be expensive and non-deterministic), they designed a pipeline where the LLM extracts human-readable features, and matching is then performed deterministically. This reduced complexity from O(n*m) to O(n+m) in terms of LLM prompts. Their ADR-025 (AI Test Concept) then outlined a comprehensive testing strategy for the non-deterministic LLM components.

**Katamarans** (2nd) complemented this with a cost fitness function that calculated the per-candidate processing cost ($0.06 for a full hiring flow), enabling ongoing cost governance. Their ADR-005 (Changing AI Solution Landscape) and ADR-006 (Picking 3rd Party AI Services) demonstrated awareness that the AI market is volatile and designed abstraction layers accordingly.

**Ctrl+Alt+Elite** (3rd) designed the most technically sophisticated AI pipeline (Vector DB + Knowledge Graph + LLM re-ranking), but did not include a cost or feasibility analysis -- a significant omission given the non-profit context.

By contrast, runners-up either treated AI as a black box (Jazz Executor), deferred AI decisions without sufficient architectural guardrails (DevExperts), or took a simpler but under-specified approach (ArchZ relied on RAG with vector search but did not quantify costs).

### 2. Explicit Prioritization and Trade-off Documentation

Winning teams made hard choices and documented their reasoning. Pragmatic explicitly "downplayed" data integrity (ADR-004) to keep the architecture simpler, acknowledging the trade-off rather than trying to satisfy every quality attribute. Katamarans identified cost as their primary driver (ADR-002) and made every subsequent decision through that lens. Equihire Architects scoped their system to 5,000 candidates and intentionally deprioritized scalability -- a brave decision that kept their architecture honest.

Runner-up teams tended toward broader, less differentiated lists. Jazz Executor listed 10 quality attributes without clear prioritization. ArchZ listed 7 attributes and applied them per-quanta, which was thorough but diffused the architectural narrative.

### 3. Process Rigor and Requirements Elicitation

All three winning teams performed Event Storming to discover bounded contexts and event flows. Pragmatic combined it with DDD; Katamarans used the "Six Thinking Hats" technique for requirements distillation; Ctrl+Alt+Elite used it to identify microservice boundaries. Among runners-up, only ArchZ performed Event Storming (using an actor-action variant). DevExperts, Equihire Architects, and Jazz Executor skipped this step, which may have led to less grounded service decomposition.

### 4. Completeness of the Architecture Narrative

Winning teams told a complete story from requirements through architecture decisions to known limitations. Pragmatic's Known Limitations section was particularly effective -- it acknowledged that their matching algorithm has limitations, that matching is delayed (not real-time), and that external AI rate limiting is an unsolved problem. This transparency likely built credibility with judges.

---

## Common Patterns

### External LLMs over Self-Hosted Models

All seven teams chose to use external, third-party LLM services rather than self-hosted models. The reasoning was remarkably consistent: the non-profit context demands low upfront cost, LLM technology evolves too rapidly to commit to a specific model, and pay-as-you-go pricing is more predictable than infrastructure costs. Pragmatic (ADR-007) gave the most thorough analysis, comparing external APIs, cloud-hosted open-source models, and on-premise options before selecting external APIs for their cost and time-to-market advantages.

### Adapter/Connector Pattern for HR Integration

Every team identified HR system integration as a first-class architectural concern. The solutions converged on similar patterns: a dedicated integration service with per-HR-system adapters or connectors. Pragmatic (ADR-023) designed an adapter-based HR Integration Service with event-driven triggers. Ctrl+Alt+Elite (ADR-12) built a custom orchestration engine with connector libraries. Katamarans designed an HR integration orchestrator. The pattern was consistent because the problem demanded it: an unbounded number of HR systems, each with potentially different APIs, data formats, and authentication mechanisms.

### Event-Driven Communication for AI Workloads

Even teams that did not choose event-driven architecture as their primary style used asynchronous, event-driven patterns for AI-related workloads. Pragmatic (ADR-005) explicitly decided to "use event-driven architecture where needed" for external system communication. This reflects a practical understanding that LLM calls are inherently slow, rate-limited, and failure-prone -- all characteristics that benefit from asynchronous processing.

### Analytics as a Separate Concern

Every team separated analytics and reporting from the transactional core. Solutions ranged from batch processing (Pragmatic ADR-003), to dedicated analytics engines (Ctrl+Alt+Elite with Redshift + QuickSight), to event-sourced analytics (DevExperts with Athena + QuickSight). The consistency reflects the kata's explicit requirement to "aggregate data to reveal disparities."

### Security and PII as Cross-Cutting Concerns

All teams treated PII protection as critical, though their approaches varied. Katamarans dedicated two ADRs to PII safety (ADR-009, ADR-014) with separate secure storage. Equihire Architects used schema-per-domain database design for security isolation. DevExperts chose Cognito for authentication. The universal recognition of PII sensitivity reflects the domain's ethical requirements.

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

The only top-3 team to include Figma prototypes for all three user roles (Candidate, Employer, Admin), providing a tangible demonstration of the user experience that the architecture is designed to support.

### ArchZ: Architectural Quanta with Per-Component Style Selection

ArchZ applied the concept of architectural quanta (from "Fundamentals of Software Architecture" by Richards and Ford) more thoroughly than any other team. Each quantum -- AI, User Profile, Matching, Invoice, Notification, Integrations, Survey, Analytics -- received its own architecture characteristics worksheet and style selection. This approach is theoretically sound and ensures that each component gets the architectural treatment it deserves, though it increases operational complexity.

### DevExperts: Concrete Cost Estimation with AWS Calculator

DevExperts provided the most specific infrastructure cost estimate: $8,448/year with a link to the actual AWS Calculator breakdown. For a non-profit client, this level of concreteness is extremely valuable for budgeting and decision-making. They also included a "Postponed Decisions" table with clear justifications for what was deferred and why.

### Equihire Architects: Strategy Pattern for Matching

Equihire Architects designed a Strategy Pattern for their matching scoring logic, allowing the system to switch between Cosine Similarity (cheaper, deterministic) and LLM-based scoring (more accurate, more expensive) at runtime. This "dial" between cost and accuracy is a pragmatic approach for a non-profit that might start with the cheaper option and upgrade later.

### DevExperts: Backend-for-Frontend (BFF) Pattern

DevExperts clearly articulated a BFF pattern where each user role (Candidate, Employer, Admin) gets a dedicated backend service tailored to its frontend needs. This is a well-established pattern but was not commonly seen across submissions.

---

## Lessons for Practitioners

### 1. For AI-heavy systems, architecture must constrain the AI, not just enable it

The most successful teams (Pragmatic, Katamarans) designed their architectures to limit and control LLM usage rather than giving the AI free rein. Pragmatic's deterministic matching approach (ADR-011) is the exemplar: by extracting human-readable features first and matching deterministically, they made the system testable, explainable, and cost-efficient. The lesson is that when integrating non-deterministic, expensive AI components, the architecture should create deterministic boundaries around them.

### 2. Cost analysis is not optional for non-profit clients

Teams that performed explicit cost analysis (Pragmatic's token estimation, Katamarans' cost fitness function, DevExperts' AWS Calculator estimate) demonstrated that they understood the client's context. Teams that proposed AWS-heavy architectures without cost analysis (Ctrl+Alt+Elite, ArchZ) left a credibility gap. For any budget-constrained client, the architecture must justify its own cost of operation.

### 3. Fewer, sharper quality attribute priorities beat a long list

Pragmatic chose 3 (Interoperability, Feasibility, Testability). Equihire Architects chose 3 (Cost, Interoperability, Simplicity). Jazz Executor listed 10. The teams with fewer, more focused priorities produced more coherent architectures because every decision could be evaluated against a small set of criteria. When everything is a priority, nothing is.

### 4. Event Storming is a differentiator in kata competitions

All three winning teams performed Event Storming. Only one of four runners-up did. Event Storming forces teams to engage with the domain before making technology choices, leading to better-grounded service decomposition and more natural bounded contexts. For architecture katas specifically, it provides visible evidence of a rigorous design process.

### 5. Known limitations build credibility

Pragmatic's explicit Known Limitations section -- acknowledging delayed matching, rate limiting challenges, and user administration gaps -- was a distinguishing feature. In architecture katas (and real projects), admitting what the architecture cannot do demonstrates maturity and builds trust. Judges and stakeholders respond better to honest trade-offs than to implied perfection.

### 6. Service-based architecture deserves more respect

In a landscape where microservices and event-driven architectures receive the most attention, the two service-based entries (Pragmatic at 1st, Equihire Architects at runner-up) performed well. Service-based architecture offers a pragmatic middle ground: independently deployable services without the operational overhead of full microservices or the complexity of event-driven choreography. For startups, non-profits, and organizations with limited DevOps maturity, it is often the right choice.

### 7. The matching algorithm is the architectural fulcrum of AI hiring platforms

Every team had to solve the matching problem, and their approaches were the most varied and architecturally significant decisions in each submission. The spectrum ranged from simple (Equihire Architects' Cosine Similarity), through intermediate (Katamarans' weighted token comparison, Pragmatic's deterministic feature matching), to complex (Ctrl+Alt+Elite's Vector DB + Knowledge Graph + LLM re-ranking). The "right" approach depends on scale, budget, and accuracy requirements -- but the architectural decision must be made explicitly and early, as it cascades into cost, performance, testability, and explainability.

### 8. Abstraction layers around AI services are essential for longevity

Multiple teams (Katamarans ADR-005, ADR-006; Pragmatic ADR-007; Equihire Architects' Strategy Pattern) designed abstraction layers between their architecture and external AI services. Given that LLM providers, pricing, and capabilities change rapidly, this is not optional -- it is a survival requirement. Any team building on LLMs today should assume they will need to swap providers within 18 months.
