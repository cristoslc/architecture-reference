# Sysops Squad -- Comparative Analysis

**Challenge:** O'Reilly Architecture Kata, Spring 2021 Season
**Teams Analyzed:** 3
**Source Repositories:** Team-7, ArchElekt, Mad-Katas

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

---

## Architecture Style Choices

### The Dominant Choice: Service-Based Architecture

All three placing teams selected service-based architecture as their primary style. This unanimous convergence reflects a mature understanding of the problem space. The reasoning was remarkably consistent:

- **Team Seven (ADR-1):** Identified four distinct domain areas (customer-facing, operational, billing, administration), each with different architectural characteristics. Service-based architecture provides fault-tolerance, scalability, and agility without the cost overhead of microservices, and serves as a natural evolutionary starting point toward microservices if needed later.

- **ArchElekt:** Explicitly chose simplicity and pragmatism as design principles. Their trade-off analysis acknowledged that while the monolithic database remains a single point of contention, service-based architecture provides a good balance between benefits and complexity.

- **The Mad Katas:** Performed a formal architecture capabilities comparison matrix across microservices, service-based, and event-driven styles. They concluded that service-based trade-offs (lower elasticity and workflow scores) could be mitigated through containerization, graph databases, orchestrator services, and queues -- making it the most favorable choice.

The convergence on service-based architecture across all three teams underscores an important practical lesson: for monolith migrations of this scale, service-based architecture strikes the right balance between decomposition benefits and operational complexity. Each team independently recognized that microservices would introduce unnecessary overhead for the problem at hand.

### Event-Driven Augmentation

**Team Seven** layered event-driven patterns on top of their service-based foundation. Their ADR-2 made a particularly compelling case: the ticket workflow between domains is inherently message-oriented rather than request-response, as illustrated by their BPMN diagram. They specified guaranteed-delivery point-to-point queues rather than topic-based pub/sub, a precise technical distinction that demonstrated depth of understanding. Both ArchElekt and The Mad Katas also incorporated asynchronous messaging for ticket processing, though Team Seven's treatment was the most architecturally explicit.

---

## What Distinguished the Top Teams

### 1. Transition Architecture and Migration Rigor

The single clearest differentiator among the placing teams was the depth and realism of their migration strategy.

**Team Seven (1st)** provided a complete transition architecture -- not just a target state, but an intermediate architecture that could be deployed first. This transition architecture retained a monolithic database to reduce initial effort while still delivering the critical availability and scalability improvements through asynchronous messaging. Crucially, they included a **risk analysis** of the transition state itself: identifying that the monolithic database could become a performance bottleneck, the single API gateway could be a single point of failure, and security risks from shared data access. This level of intellectual honesty about intermediate states is rare and was the defining characteristic of the winning submission.

**ArchElekt** took a pragmatic, problem-first approach to migration, mapping each identified problem directly to the architectural change that would solve it. While less elaborate than Team Seven's phased transition, this approach ensured that every step of the migration delivered measurable business value.

**The Mad Katas** provided the most comprehensive target-state documentation, with detailed C4 diagrams at all three levels and scenario flows that traced ticket processing through the new architecture. Their migration thinking was embedded in the sheer breadth of their ADR coverage, which addressed not only backend services but also frontend decomposition, database technology selection, and security posture.

### 2. Decision Documentation Depth

All three teams produced 12 or more ADRs, and the quality and specificity of these records was a strong predictor of placement:

- **Team Seven's** 12 ADRs form a coherent narrative, with later ADRs building on earlier ones (ADR-4 referencing ADR-1, ADR-5 referencing ADR-4). Each ADR includes explicit consequences and trade-offs acknowledged.

- **The Mad Katas** produced the most ADRs (17), and uniquely included **negative decisions** -- ADRs documenting what they decided *not* to do (ADR-12: "We will not separate reporting," ADR-14: "We will not separate System Data," ADR-16: "We will not separate Contract Management"). This practice of recording rejected alternatives is a hallmark of mature architecture documentation.

- **ArchElekt's** 12 ADRs spanned both technical decisions (segregating ticket creation, separating payment database) and business process improvements (expert self-managed skills, active ticket acceptance/rejection). This breadth of scope demonstrated that the team understood architecture as encompassing both system design and business workflow.

### 3. Process View Coverage

**Team Seven** provided 8 sequence diagrams covering the complete ticket lifecycle from customer registration through survey submission, including monthly billing. Each diagram was annotated with architectural rationale -- for example, noting that ticket status is saved to the customer database *before* sending notifications, so the customer always sees current status upon receiving a notification.

**ArchElekt** did not include sequence diagrams but compensated with detailed C4 component diagrams for each major container and a ticket workflow diagram with explicit lifecycle states.

**The Mad Katas** included scenario flow diagrams at the C4 level, providing multi-level views of the same workflows.

### 4. Stakeholder and Quality Attribute Analysis

Each of the three teams demonstrated a disciplined approach to connecting business requirements to architectural decisions:

- **Team Seven** mapped specific stakeholders to architecture characteristics (e.g., SH-2 Customer maps to availability, performance, scalability, robustness) and then traced those characteristics to use cases (e.g., QA-1 Scalability maps to UC-3 Ticket Workflow).

- **ArchElekt** traced identified problems directly to architectural decisions, creating a clear audit trail from "wrong expert shows up" to "ADR-001: Allow experts to maintain their own skills."

- **The Mad Katas** performed a formal architecture capabilities comparison matrix, systematically evaluating how each candidate style scored against the identified quality attributes before making their selection.

---

## Common Patterns

Despite working independently, the three placing teams converged on several architectural decisions:

### 1. Ticket Creation Isolation

Every team recognized that ticket creation needed to be isolated from the rest of the system to prevent availability issues. The specifics varied -- some used persistent queues (ArchElekt ADR-003, Team Seven ADR-2), others used separate services -- but the core insight was universal: the act of accepting a customer's ticket must never fail, even if downstream processing is delayed.

### 2. Billing/Payment Separation

All three teams separated billing or payment into its own domain with dedicated data storage. The security rationale (PCI compliance, credit card data isolation) was cited consistently. Team Seven (ADR-4) provided the most detailed treatment, explaining exactly which data crosses the boundary (only last 4 digits of credit card number) and how billing data reaches the reporting domain (ETL or replication).

### 3. Reporting Database Separation

Every team moved reporting and analytics off the main operational database. The recognition that report generation queries were likely contributing to the system freezing was shared across all submissions.

### 4. Notification as a Separate Service

All teams externalized notification (SMS/email) into a dedicated service or integration. This was recognized as a natural boundary -- notification is a cross-cutting concern that should not be embedded in domain services.

### 5. Asynchronous Communication for Ticket Workflow

Every team introduced message queues or event-driven communication for the ticket processing pipeline. The synchronous request-response model of the monolith was universally identified as a root cause of the cascading failures.

---

## Unique Innovations Worth Highlighting

### Graph Database for Expert-Ticket Matching (The Mad Katas, ADR-005)

The Mad Katas proposed using Neo4j as the primary datastore -- the most unconventional technology choice among the placing teams. Their datastore analysis document systematically evaluated relational, document, and graph databases against 14 functional and 6 non-functional requirements. Graph databases uniquely met all requirements, particularly for the expert-ticket matching problem where multi-criteria relationship traversal (skills, location, availability) is the core operation. The team acknowledged the training risk but argued that modeling data as it exists in the real world (nodes and relationships rather than tables and joins) would reduce long-term complexity. This was a bold, well-reasoned decision.

### Micro Frontend Architecture (The Mad Katas, ADR-003)

The Mad Katas were the only team to address the frontend architecture explicitly. Their ADR for micro frontends, using the Backends-for-Frontends (BFF) pattern, recognized that breaking up the backend without breaking up the frontend would leave a monolithic UI as a deployment bottleneck. This is a frequently overlooked concern in migration projects and shows awareness of the full system boundary.

### Zero Trust Security Model (The Mad Katas, ADR-011)

The Mad Katas proposed zero trust architecture -- assuming the system has been breached and authenticating every internal request -- a security posture that no other placing team considered. They addressed the performance trade-off by proposing that services begin processing requests immediately while authentication confirmation is in flight, only sending the response after authentication completes. This is a sophisticated pattern that balances security with latency.

### Expert-Managed Skills (ArchElekt, ADR-001)

ArchElekt identified that a root cause of wrong-expert assignment was that *managers* maintained expert skill profiles rather than the experts themselves. Their ADR-001 moved skill maintenance to experts, a simple business process change that addresses a core problem without any technology change at all. This insight -- that some architectural problems have process solutions -- was characteristic of ArchElekt's pragmatic approach.

### Phased Transition with Risk Analysis (Team Seven)

Team Seven's transition architecture was itself an innovation. Rather than presenting only the target state, they designed an intermediate architecture that could be deployed to production, complete with its own risk analysis identifying single points of failure and security gaps. This practice of treating the migration path as a series of production-grade architectures -- each with its own trade-offs documented -- set the standard for migration rigor.

---

## Lessons for Practitioners

### 1. Start with Service-Based, Not Microservices

The unanimous choice of service-based architecture across all three placing teams reinforces a practical lesson: for monolith migrations, service-based architecture is usually the right first step. It provides most of the benefits of decomposition (independent deployment, fault isolation, team autonomy) without the operational complexity overhead of microservices (per-service databases, distributed transactions, service mesh). Multiple teams explicitly noted that service-based architecture is an evolutionary stepping stone toward microservices *if and when* the data supports it.

### 2. Document What You Decided NOT to Do

The Mad Katas' practice of recording negative decisions (ADRs 012, 014, 016) is an underappreciated best practice. Knowing that the team *considered* separating reporting but decided against it (and later superseded that decision) provides valuable context that positive-only ADRs miss. It prevents future architects from revisiting already-rejected options without understanding the original reasoning.

### 3. The Transition Architecture Matters More Than the Target

Team Seven's winning approach centered not on a more innovative target architecture, but on a more honest and detailed *path to get there*. Their transition architecture acknowledged that the target state requires significant database splitting effort, so they defined an intermediate state that solves the critical problems (availability, ticket loss) while deferring the expensive work (database decomposition). The risk analysis of the transition state itself -- identifying its own single points of failure and security gaps -- demonstrated that the team understood migration as a series of production states, not a single leap.

### 4. Connect Every Decision to a Problem

ArchElekt's problem-first approach -- identifying five specific problems in the current system and then tracing each architectural decision back to which problem it solves -- is a model of clear thinking. Architecture that cannot be traced to a business problem is speculative. The second-place team won their position not through innovation but through disciplined problem-solution mapping.

### 5. Address the Full Stack

The Mad Katas stood out by addressing both frontend (micro frontends) and security (zero trust) in addition to backend decomposition. Most architectural designs focus exclusively on service decomposition and data architecture. Real migration projects must address the UI layer, security posture, observability, and deployment infrastructure -- gaps in any of these can undermine the backend architecture.

### 6. Process Changes Can Be Architecture Decisions

ArchElekt proposed business process changes alongside technical changes: moving skill maintenance to experts (ADR-001) and requiring experts to actively accept or reject tickets (ADR-005). These process changes address root causes more directly than technical changes alone. The lesson is that an architect's scope should include the business workflow, not just the system diagram.

### 7. Data Architecture Deserves Dedicated Analysis

The Mad Katas' comprehensive datastore analysis -- evaluating three database paradigms against 20 requirements -- produced the most unconventional and potentially high-value decision of any team (graph database). Teams that treat data architecture as an afterthought (using whatever database the monolith already had) miss an opportunity to fundamentally improve the expert-matching and knowledge-base-search capabilities that are core to the business problem.

---

*Analysis based on submissions to the O'Reilly Architecture Kata, Spring 2021 season. All team repositories are publicly available on GitHub.*
