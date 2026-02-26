# Sysops Squad -- Comparative Analysis

**Challenge:** O'Reilly Architecture Kata, Spring 2021 Season
**Teams Analyzed:** 7
**Source Repositories:** Team-7, ArchElekt, Mad-Katas, Arch-Mahal, Global-Architects, Pentagram, Renaissance

---

## Challenge Overview

The Sysops Squad kata asked teams to redesign the trouble ticket system for Penultimate Electronics, a large consumer electronics retailer operating across the United States. The existing system was a monolithic application suffering from four critical failures:

1. **Lost tickets** -- customer problem tickets disappeared, meaning no expert ever showed up.
2. **Wrong expert assignment** -- the matching algorithm sent consultants who lacked the skills to fix the problem.
3. **Poor availability** -- the system frequently froze or crashed during usage spikes, preventing customers and call-center staff from entering tickets.
4. **Difficult maintainability** -- every code change took too long and introduced regressions elsewhere in the monolith.

The stakes were existential: Penultimate Electronics would be forced to shut down the support plan business line entirely and fire all field experts if the architecture was not fixed. Teams had to produce a target architecture, migration strategy, and supporting decision records within a compressed kata timeline.

The system serves four primary actor groups (customers, field experts, administrators, and managers) across web portals, mobile apps, and call-center interfaces, with integrations to payment processing and notification (SMS/email) systems.

---

## Team Comparison Matrix

| Team | Placement | Architecture Style | ADR Count | Diagram Types | Key Differentiator |
|------|-----------|-------------------|-----------|---------------|-------------------|
| Team Seven | 1st | Service-Based + Event-Driven (message queues) | 12 | C4 (Context, Container), Sequence, Deployment, BPMN, Use Case, Transition | Phased transition architecture with explicit risk analysis |
| ArchElekt | 2nd | Service-Based | 12 | C4 (Context, Container, Component), Ticket workflow | Pragmatic problem-first design with ticket lifecycle component |
| The Mad Katas | 3rd | Service-Based + Micro Frontend | 17 | C4 (all three levels), Scenario flows, Graph DB design, Deployment | Graph database (Neo4j) and zero trust security |
| Arch Mahal | Runner-up | Microservices | 6 | As-Is/To-Be, Service interaction, DR deployment, Scenario | Uber-model for expert self-assignment |
| Global Architects | Runner-up | Service-Based | 3 | System, Data flow, Context, AWS infrastructure | Self-healing architecture with discrepancy/healing services |
| Pentagram | Runner-up | Service-Based (Phase 1) evolving to hybrid Microservices (Phase 3+) | 8 | C4 (L1, L2), Sequence, Data models, Migration phases | Fitness-function-driven evolutionary migration |
| Renaissance | Runner-up | Service-Based | 6 | Actor actions, Use case, Component, Sequence (PlantUML), Deployment (AWS EKS) | Pragmatic 3rd-party tool adoption (BI, Knowledge Base) |

---

## Architecture Style Choices

### The Dominant Choice: Service-Based Architecture

Six of seven teams selected service-based architecture as their primary style. This near-unanimous convergence is notable and reflects a mature understanding of the problem space. The reasoning was remarkably consistent across teams:

- **Team Seven (ADR-1):** Identified four distinct domain areas (customer-facing, operational, billing, administration), each with different architectural characteristics. Service-based architecture provides fault-tolerance, scalability, and agility without the cost overhead of microservices, and serves as a natural evolutionary starting point toward microservices if needed later.

- **ArchElekt:** Explicitly chose simplicity and pragmatism as design principles. Their trade-off analysis acknowledged that while the monolithic database remains a single point of contention, service-based architecture provides a good balance between benefits and complexity.

- **The Mad Katas:** Performed a formal architecture capabilities comparison matrix across microservices, service-based, and event-driven styles. They concluded that service-based trade-offs (lower elasticity and workflow scores) could be mitigated through containerization, graph databases, orchestrator services, and queues -- making it the most favorable choice.

- **Renaissance:** Provided explicit reasoning for choosing service-based over microservices, emphasizing that the additional complexity of microservices was not justified for the problem scale.

- **Global Architects:** Selected service-based for its balance of maintainability and evolvability without over-engineering.

### The Outlier: Microservices

**Arch Mahal** was the sole team to select a full microservices architecture. Their rationale centered on maximizing independent deployability and scalability. However, this choice was noted as potentially over-ambitious for a migration from a monolith -- the leap from monolith to microservices is substantially larger than to service-based, and the team's 6 ADRs did not fully address the data decomposition challenges that microservices demand.

### The Evolutionary Approach

**Pentagram** took the most sophisticated stance by proposing a phased evolution: starting with service-based (Phase 1), creating bounded contexts with per-service databases (Phase 2), converting the ticketing service to a microservice on the cloud (Phase 3), and data-driven conversion of remaining services (Phase 4). Each phase transition was governed by fitness function measurements rather than arbitrary timelines -- a distinctive approach that none of the other teams adopted.

### Event-Driven Augmentation

**Team Seven** and **Pentagram** both layered event-driven patterns on top of their service-based foundation. Team Seven's ADR-2 made a particularly compelling case: the ticket workflow between domains is inherently message-oriented rather than request-response, as illustrated by their BPMN diagram. They specified guaranteed-delivery point-to-point queues rather than topic-based pub/sub, a precise technical distinction that demonstrated depth of understanding.

---

## What Separated Winners from Runners-Up

### 1. Transition Architecture and Migration Rigor

The single clearest differentiator between top-placing and runner-up teams was the depth and realism of their migration strategy.

**Team Seven (1st)** provided a complete transition architecture -- not just a target state, but an intermediate architecture that could be deployed first. This transition architecture retained a monolithic database to reduce initial effort while still delivering the critical availability and scalability improvements through asynchronous messaging. Crucially, they included a **risk analysis** of the transition state itself: identifying that the monolithic database could become a performance bottleneck, the single API gateway could be a single point of failure, and security risks from shared data access. This level of intellectual honesty about intermediate states is rare.

**Renaissance** provided the most detailed step-by-step migration among the runner-up teams, with four steps that each included motivation, expected results, and how-to instructions. Their approach of starting with analytics (suspected cause of load issues) and knowledge base (most decoupled) showed practical migration thinking. However, it lacked the risk analysis that Team Seven provided.

**Pentagram** had the most theoretically rigorous approach with fitness-function-driven phase gates, but the fitness functions themselves were not specified in concrete terms -- the *what* to measure and *what thresholds* to use were left as future work.

**Arch Mahal** and **Global Architects** described migration phases at a high level but without the operational detail of the top teams.

### 2. Decision Documentation Depth

The top three teams all produced 12+ ADRs. The quality and specificity of these ADRs was a strong predictor of placement:

- **Team Seven's** 12 ADRs form a coherent narrative, with later ADRs building on earlier ones (ADR-4 referencing ADR-1, ADR-5 referencing ADR-4). Each ADR includes explicit consequences and trade-offs acknowledged.

- **The Mad Katas** produced the most ADRs of any team (17), and uniquely included **negative decisions** -- ADRs documenting what they decided *not* to do (ADR-12: "We will not separate reporting," ADR-14: "We will not separate System Data," ADR-16: "We will not separate Contract Management"). This practice of recording rejected alternatives is a hallmark of mature architecture documentation.

- **ArchElekt's** 12 ADRs spanned both technical decisions (segregating ticket creation, separating payment database) and business process improvements (expert self-managed skills, active ticket acceptance/rejection). This breadth of scope demonstrated that the team understood architecture as encompassing both system design and business workflow.

Runner-up teams had significantly fewer ADRs: Arch Mahal (6), Renaissance (6), Global Architects (3), Pentagram (8). While count alone is not definitive, the correlation between ADR volume and placement is striking.

### 3. Process View Coverage

**Team Seven** provided 8 sequence diagrams covering the complete ticket lifecycle from customer registration through survey submission, including monthly billing. Each diagram was annotated with architectural rationale -- for example, noting that ticket status is saved to the customer database *before* sending notifications, so the customer always sees current status upon receiving a notification.

**ArchElekt** did not include sequence diagrams but compensated with detailed C4 component diagrams for each major container and a ticket workflow diagram with explicit lifecycle states.

**The Mad Katas** included scenario flow diagrams at the C4 level, providing multi-level views of the same workflows.

Most runner-up teams lacked this process-level detail entirely.

### 4. Stakeholder and Quality Attribute Analysis

The top three teams each demonstrated a disciplined approach to connecting business requirements to architectural decisions:

- **Team Seven** mapped specific stakeholders to architecture characteristics (e.g., SH-2 Customer maps to availability, performance, scalability, robustness) and then traced those characteristics to use cases (e.g., QA-1 Scalability maps to UC-3 Ticket Workflow).

- **Pentagram** produced quality attribute scenarios with formal importance/difficulty rankings, the most structured approach among all seven teams.

- **ArchElekt** traced identified problems directly to architectural decisions, creating a clear audit trail from "wrong expert shows up" to "ADR-001: Allow experts to maintain their own skills."

---

## Common Patterns

Despite working independently, the seven teams converged on several architectural decisions:

### 1. Ticket Creation Isolation

Every team recognized that ticket creation needed to be isolated from the rest of the system to prevent availability issues. The specifics varied -- some used persistent queues (ArchElekt ADR-003, Team Seven ADR-2), others used separate services -- but the core insight was universal: the act of accepting a customer's ticket must never fail, even if downstream processing is delayed.

### 2. Billing/Payment Separation

All seven teams separated billing or payment into its own domain with dedicated data storage. The security rationale (PCI compliance, credit card data isolation) was cited consistently. Team Seven (ADR-4) provided the most detailed treatment, explaining exactly which data crosses the boundary (only last 4 digits of credit card number) and how billing data reaches the reporting domain (ETL or replication).

### 3. Reporting Database Separation

Every team moved reporting and analytics off the main operational database. The recognition that report generation queries were likely contributing to the system freezing was shared across all submissions. Renaissance's migration plan started with this step specifically because they suspected analytics queries were the primary cause of production load.

### 4. Notification as a Separate Service

All teams externalized notification (SMS/email) into a dedicated service or integration. This was recognized as a natural boundary -- notification is a cross-cutting concern that should not be embedded in domain services.

### 5. Asynchronous Communication for Ticket Workflow

Every team introduced message queues or event-driven communication for the ticket processing pipeline. The synchronous request-response model of the monolith was universally identified as a root cause of the cascading failures.

---

## Unique Innovations Worth Highlighting

### Graph Database for Expert-Ticket Matching (The Mad Katas, ADR-005)

The Mad Katas proposed using Neo4j as the primary datastore -- the most unconventional technology choice across all seven teams. Their datastore analysis document systematically evaluated relational, document, and graph databases against 14 functional and 6 non-functional requirements. Graph databases uniquely met all requirements, particularly for the expert-ticket matching problem where multi-criteria relationship traversal (skills, location, availability) is the core operation. The team acknowledged the training risk but argued that modeling data as it exists in the real world (nodes and relationships rather than tables and joins) would reduce long-term complexity. This was a bold, well-reasoned decision that no other team considered.

### Uber Model for Expert Self-Assignment (Arch Mahal, ADR-003)

Arch Mahal reimagined the expert assignment problem entirely. Rather than the system assigning tickets to experts (which all other teams preserved), they proposed that experts self-select tickets based on their own assessment of skills, location, and availability -- modeled after ride-sharing platforms. This eliminated the wrong-expert problem by definition: if an expert picks a ticket, they are asserting they can handle it. The manager role was redesigned to handle only corner cases where no expert self-assigns. While this introduces the risk of unpopular tickets going unclaimed, it is a genuinely creative reframing of the core business problem.

### Self-Healing Architecture (Global Architects, ADR-0003)

Global Architects introduced a discrepancy service that continuously monitors for differences between created, assigned, and resolved tickets, paired with a healing service that applies automated rules to fix broken ticket states. If automated correction fails, the healing service escalates to a Customer Success Manager (a new role they proposed). This proactive approach to data consistency was unique -- all other teams relied on the ticket workflow itself to prevent inconsistencies, rather than building a separate system to detect and repair them after the fact.

### Micro Frontend Architecture (The Mad Katas, ADR-003)

The Mad Katas were the only team to address the frontend architecture explicitly. Their ADR for micro frontends, using the Backends-for-Frontends (BFF) pattern, recognized that breaking up the backend without breaking up the frontend would leave a monolithic UI as a deployment bottleneck. This is a frequently overlooked concern in migration projects and shows awareness of the full system boundary.

### Zero Trust Security Model (The Mad Katas, ADR-011)

The Mad Katas proposed zero trust architecture -- assuming the system has been breached and authenticating every internal request -- a security posture that no other team considered. They addressed the performance trade-off by proposing that services begin processing requests immediately while authentication confirmation is in flight, only sending the response after authentication completes. This is a sophisticated pattern that balances security with latency.

### Fitness-Function-Driven Migration (Pentagram, ADR-003)

Pentagram's Phase 0 -- introducing fitness functions into the existing monolith before making any architectural changes -- was a uniquely disciplined approach. By establishing baseline measurements for every quality attribute before migration begins, the team created an objective framework for evaluating whether each phase actually delivered improvement. No other team proposed measuring the before state with such rigor.

### Chatbot for Customer Self-Service (Global Architects)

Global Architects proposed a chatbot service using ML algorithms to resolve simple customer problems without creating a ticket at all. This was the only team to address demand reduction as an architectural strategy -- fewer tickets means less load on the system, regardless of how well the system is architected.

### Expert-Managed Skills (ArchElekt, ADR-001)

ArchElekt identified that a root cause of wrong-expert assignment was that *managers* maintained expert skill profiles rather than the experts themselves. Their ADR-001 moved skill maintenance to experts, a simple business process change that addresses a core problem without any technology change at all. This insight -- that some architectural problems have process solutions -- was characteristic of ArchElekt's pragmatic approach.

---

## Lessons for Practitioners

### 1. Start with Service-Based, Not Microservices

The near-unanimous choice of service-based architecture, with the sole microservices team (Arch Mahal) placing as a runner-up, reinforces a practical lesson: for monolith migrations, service-based architecture is usually the right first step. It provides most of the benefits of decomposition (independent deployment, fault isolation, team autonomy) without the operational complexity overhead of microservices (per-service databases, distributed transactions, service mesh). Multiple teams explicitly noted that service-based architecture is an evolutionary stepping stone toward microservices *if and when* the data supports it.

### 2. Document What You Decided NOT to Do

The Mad Katas' practice of recording negative decisions (ADRs 012, 014, 016) is an underappreciated best practice. Knowing that the team *considered* separating reporting but decided against it (and later superseded that decision) provides valuable context that positive-only ADRs miss. It prevents future architects from revisiting already-rejected options without understanding the original reasoning.

### 3. The Transition Architecture Matters More Than the Target

Team Seven's winning approach centered not on a more innovative target architecture, but on a more honest and detailed *path to get there*. Their transition architecture acknowledged that the target state requires significant database splitting effort, so they defined an intermediate state that solves the critical problems (availability, ticket loss) while deferring the expensive work (database decomposition). The risk analysis of the transition state itself -- identifying its own single points of failure and security gaps -- demonstrated that the team understood migration as a series of production states, not a single leap.

### 4. Connect Every Decision to a Problem

ArchElekt's problem-first approach -- identifying five specific problems in the current system and then tracing each architectural decision back to which problem it solves -- is a model of clear thinking. Architecture that cannot be traced to a business problem is speculative. The second-place team won their position not through innovation but through disciplined problem-solution mapping.

### 5. Address the Full Stack

The Mad Katas stood out by addressing both frontend (micro frontends) and security (zero trust) in addition to backend decomposition. Most teams focused exclusively on service decomposition and data architecture. Real migration projects must address the UI layer, security posture, observability, and deployment infrastructure -- gaps in any of these can undermine the backend architecture.

### 6. Process Changes Can Be Architecture Decisions

Several teams proposed business process changes alongside technical changes: ArchElekt moved skill maintenance to experts, Arch Mahal introduced expert self-assignment, Global Architects added a Customer Success Manager role, and ArchElekt required experts to actively accept or reject tickets (ADR-005). These process changes often address root causes more directly than technical changes alone. The lesson is that an architect's scope should include the business workflow, not just the system diagram.

### 7. Measure Before You Migrate

Pentagram's Phase 0 (baseline fitness functions before any changes) is a practice that should be standard but rarely is. Without baseline measurements, teams cannot objectively demonstrate that their new architecture actually improved the quality attributes they claim to optimize. This is especially important when justifying the cost and risk of a major migration to business stakeholders.

### 8. Data Architecture Deserves Dedicated Analysis

The Mad Katas' comprehensive datastore analysis -- evaluating three database paradigms against 20 requirements -- produced the most unconventional and potentially high-value decision of any team (graph database). Teams that treated data architecture as an afterthought (using whatever database the monolith already had) missed an opportunity to fundamentally improve the expert-matching and knowledge-base-search capabilities that were core to the business problem.

---

*Analysis based on submissions to the O'Reilly Architecture Kata, Spring 2021 season. All team repositories are publicly available on GitHub.*
