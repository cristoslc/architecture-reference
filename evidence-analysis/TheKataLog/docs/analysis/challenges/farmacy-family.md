# Farmacy Family -- Comparative Analysis

**Challenge:** O'Reilly Architecture Kata, Fall 2021
**Teams:** 3
**Problem:** Extend the existing Farmacy Foods system (designed by ArchColider in a prior kata) with community engagement, customer profiling, medical data sharing, dietician interactions, and analytics -- converting transactional customers into engaged customers.

---

## Challenge Overview

The Farmacy Family kata asked teams to design a system that sits alongside (and integrates with) an existing food-delivery platform, Farmacy Foods, originally designed by team ArchColider. The core challenge was multi-dimensional:

1. **Community engagement** -- forums, classes, events, and social features to build neighborhoods of engaged customers around healthy eating.
2. **Medical data integration** -- customers share health profiles with dieticians and clinics, introducing HIPAA compliance concerns.
3. **Analytics and personalization** -- geographical trend analysis, dietary recommendations, customer segmentation, and food-waste optimization.
4. **Customer conversion funnel** -- onboarding transactional customers (those who simply buy meals) into engaged customers with ongoing relationships.
5. **Integration with a brownfield system** -- the existing Farmacy Foods reactive monolith must be extended, not replaced.

The problem was deliberately rich in tensions: a startup budget versus enterprise-grade compliance needs; social-media-scale community features versus medical-grade data security; rapid time-to-market versus long-term evolvability.

---

## Team Comparison Matrix

| Team | Placement | Architecture Style | ADR Count | Team Size | Key Differentiator |
|------|-----------|-------------------|-----------|-----------|-------------------|
| **The Archangels** | 1st | Event-Driven | 18 | 4 | Deepest domain decomposition; event storming; crypto-shredding; graph DB for analytics; Skyflow secure vault |
| **Sever Crew** | 2nd | Service-Based + Event-Driven (Kafka) | 11 | 5 | Baseline-to-target architecture evolution; 12 stakeholders; UI prototypes; data volume estimation; AWS Forecast ML |
| **Architects++** | 3rd | Hexagonal + Service-Based (DDD) | 15 | 3 | Partnership-over-build philosophy; Facebook Groups + Eventbrite + WordPress; HIPAA isolation analysis; FOSS CRM |

---

## Architecture Style Choices

The three placing teams chose three distinct architectural approaches, revealing how the same problem statement can yield fundamentally different design philosophies.

### Event-Driven (Archangels, 1st place)

The Archangels conducted a systematic comparison of microservices versus event-driven architecture against their seven prioritized quality attributes. They found that event-driven scored highly on four of seven characteristics (elasticity, scalability, fault tolerance, workflow) while microservices had more severe trade-offs around configurability and workflow. The winning insight was that workflow -- critical for the customer onboarding funnel -- is a natural strength of event-driven architecture. They reinforced this with the inbox-outbox pattern (ADR-004) to address the dual-write problem inherent in event-based systems.

### Service-Based with Event Integration (Sever Crew, 2nd place)

Sever Crew chose service-based architecture as a pragmatic middle ground between monolith and microservices. Their ADR-2 explicitly frames this as a "good compromise" -- macro-services resolve orchestration and transactional issues while avoiding the operational complexity of microservices. They added Kafka as an event integration layer between services, creating a hybrid that gets some event-driven benefits without the full commitment.

### Hexagonal with DDD Services (Architects++, 3rd place)

Architects++ took the most unconventional approach: hexagonal architecture with DDD-defined services, backed by AWS Batch for internal domain processing. Their backend components reference architecture uses hexagonal ports-and-adapters to isolate domain logic from infrastructure, with all services following the same pattern. This was driven by their principle of using a "single uniform technology" (ADR-13) appropriate for a startup that may only have one developer maintaining the system.

---

## What Distinguished the Top Teams

### 1. Depth and Rigor of Decision Records

The single most predictive factor for placement was ADR count and quality. The three placing teams had 18, 11, and 15 ADRs respectively -- all in double digits. This is not merely a documentation exercise -- ADRs reflect the depth of thinking about trade-offs. The Archangels' 18 ADRs covered everything from high-level architecture style (ADR-002) through domain granularity decisions (ADRs 011-017) down to specific integration patterns (ADRs 018-019). Each domain got its own split decision with explicit rationale. Sever Crew's 11 ADRs captured critical decisions around Kafka integration, HIPAA compliance, and UI integration strategy. Architects++ used their 15 ADRs to document bold choices like HIPAA deferral and partnership-over-build, providing explicit rationale and consequences for each.

### 2. Systematic Architecture Analysis Process

All three teams followed a recognizable process: identify quality attributes, map them to architecture styles, evaluate trade-offs with explicit matrices, then decide. The Archangels' architecture patterns analysis compared microservices and event-driven side by side, with pros, cons, and mitigations for each. Sever Crew used a quality attributes overlay diagram to map concerns to specific containers. Architects++ mapped their five prioritized quality attributes (Security/HIPAA, Availability, Performance, Data Resilience, Usability) to specific ADR decisions.

### 3. Security and Compliance Depth

HIPAA compliance was a differentiating challenge in this kata. Each of the three placing teams addressed it distinctly and substantively:

- **Archangels** proposed crypto-shredding (ADR-005) for GDPR-style data deletion and Skyflow as a secure data vault (ADR-010), demonstrating awareness of specialized compliance tooling.
- **Sever Crew** (ADR-6) went deep on the legal specifics -- citing NIST 800-111 for data at rest, NIST 800-52/800-77/FIPS140-2 for data in motion, and referencing specific AWS HIPAA-eligible services. They also addressed the legal complexity of customer authorization forms.
- **Architects++** (ADR-1, their HIPAA ADR) made the provocative but well-reasoned decision that Farmacy Family should NOT isolate HIPAA functionality into separate components for the initial rollout, arguing that the operational burden of maintaining HIPAA compliance as a small startup is the real challenge, not the technical architecture. This demonstrated the kind of business-aware thinking that judges reward.

### 4. Complete Documentation Artifacts

All three teams produced multiple complementary diagram types: C4 models (Archangels at full depth from context through component; Sever Crew with baseline and target), scenario flows, deployment diagrams, and data models. The Archangels added event storming, communication views, and fitness functions. Sever Crew added UI prototypes for desktop and mobile. The completeness of the view portfolio matters for demonstrating that the architecture has been considered from multiple angles.

### 5. Realistic Startup Context Awareness

All three teams explicitly grappled with the startup context. The Archangels' buy-vs-build ADR (006) established a principle of evaluating COTS before building. Sever Crew estimated data volumes and planned infrastructure sizing. Architects++ went furthest with their "partnership over rolling our own" principle, choosing Facebook Groups for community, Eventbrite for events, WordPress for CMS, and Human API for health data integration -- reducing the custom build surface dramatically.

---

## Common Patterns

Despite different architecture styles, several patterns appeared across the three placing teams:

### AWS as the Deployment Platform

All three teams chose AWS, which was driven by the constraint that Farmacy Foods was already deployed there. The shared platform choice led to convergent technology selections: Cognito for identity, S3 for storage, and Kafka (MSK) for event streaming.

### Kafka as the Integration Backbone

All three placing teams included Apache Kafka (or AWS MSK) as a core integration layer. Even teams that did not choose event-driven as their primary style (like Sever Crew's service-based approach) used Kafka for inter-service communication and analytics data pipelines. Kafka became the consensus answer for bridging the Farmacy Foods and Farmacy Family systems.

### Customer Segmentation as a Batch Process

All three teams recognized that customer segmentation -- grouping users by geography, dietary needs, income level, and behavior -- should be a batch process rather than a real-time computation. Architects++ used AWS Batch; Sever Crew used AWS Glue + Athena. This shared insight reflected a realistic assessment of the data volumes (hundreds of customers) and update frequency needed.

### Separation of Medical Data Concerns

Each team recognized that medical data required special treatment, though they differed in approach: a specialized secure vault (Archangels with Skyflow), HIPAA-eligible AWS services with encryption (Sever Crew), or explicitly deferring full HIPAA compliance while acknowledging the risk (Architects++). The diversity of approaches underscored that HIPAA compliance admits no single canonical solution -- context, team size, and risk tolerance all shape the response.

### Integration with the Existing Reactive Monolith

All teams had to address the constraint of adding Farmacy Family UI to the existing Farmacy Foods interface. Sever Crew (ADR-5) proposed incorporating new functionality into the existing web and mobile apps rather than creating separate applications, prioritizing a unified user experience. The Archangels approached integration through event-driven communication between the old and new systems. Architects++ relied on third-party platforms for community features, sidestepping the tightest integration challenges.

---

## Unique Innovations Worth Highlighting

### Crypto-Shredding for Data Privacy (Archangels, ADR-005)

The Archangels proposed maintaining a separate crypto key store with a per-user encryption key. To delete all of a user's data across a distributed system, you simply delete their key, making all their encrypted data unrecoverable -- even in backups. This is an elegant solution to the GDPR right-to-erasure problem in event-driven architectures where data may be replicated across multiple stores and event logs. The trade-off (needing a short-lived cache of unencrypted data for querying) was explicitly acknowledged.

### Graph Database for Analytics (Archangels, ADR-008)

Rather than defaulting to a relational or document store, the Archangels chose a graph database for analytics data, reasoning that community relationships, dietary patterns, and geographic connections are naturally graph-shaped. The bonus insight -- "can model the database exactly how things are in the real world, with no joins" -- reflects deep thinking about the problem domain rather than defaulting to familiar technology.

### Baseline-to-Target Architecture Evolution (Sever Crew)

Sever Crew produced both baseline and target C4 diagrams at context and container levels, making the evolution path from the existing Farmacy Foods system immediately clear to reviewers. This approach -- showing the current state and the desired future state side by side -- is a powerful communication tool in brownfield architecture. Combined with their 12-stakeholder analysis and data volume estimation, it demonstrated an enterprise-grade approach to what was ostensibly a startup problem.

### Partnership-Over-Build with Specific Platforms (Architects++)

Architects++ made the boldest buy-vs-build choices: Facebook Groups for community (reasoning that their low-income, elderly, and first-responder users would prefer familiarity over custom software), Eventbrite for events, WordPress for CMS, and Human API for health data integration. Their decision to forego a mobile app entirely in favor of mobile web -- arguing that their customer base would not benefit from app-store complexity -- showed user-empathy-driven architecture.

---

## Lessons for Practitioners

### 1. ADRs Are Not Optional

The correlation between ADR discipline and placement is striking. All three placing teams documented 10+ ADRs, with the 1st-place Archangels producing 18. The practice forces explicit trade-off analysis, creates institutional memory, and demonstrates to reviewers (and stakeholders in real projects) that decisions were deliberate rather than accidental. The Archangels' approach of dedicating an ADR to each domain split (ADRs 011-017) is a pattern worth adopting -- it prevents "accidental monolith" by making each boundary an explicit decision.

### 2. Start with Quality Attributes, Not Technology

All three teams started by identifying and prioritizing quality attributes before selecting technologies. The Archangels identified seven quality attributes, ranked the top three (interoperability, configurability, authorization), and used these to evaluate architecture styles with a comparison matrix. This prevented the common anti-pattern of choosing microservices or serverless "because it is modern" and instead drove architecture from actual system requirements.

### 3. Address Compliance Head-On, Even if the Answer is "Not Yet"

Architects++ earned third place partly by making the honest, well-reasoned decision that full HIPAA isolation was not appropriate for the initial rollout of a small startup. This is more valuable than a superficial claim of compliance. Their rationale -- that the operational burden of maintaining compliance is the real challenge for small teams, and that duplicating functionality across HIPAA-governed and non-governed components introduces its own risks -- is applicable to many real-world projects. The key was that they analyzed the problem thoroughly and stated consequences clearly, rather than ignoring it.

### 4. Brownfield Thinking Requires Showing the Delta

Sever Crew's baseline-vs-target diagrams explicitly showed how their new system related to the existing one. In brownfield architecture, the integration story is often more important than the greenfield design. Producing both baseline and target C4 diagrams at context and container levels made the evolution path immediately clear to reviewers. This is a practice worth emulating in any brownfield engagement.

### 5. Multiple Perspectives Catch What Single Views Miss

The Archangels produced the richest set of views: C4 models, event storming, scenario flows, functional views, communication views, and deployment diagrams. Each view catches different classes of problems. Event storming reveals domain events and boundaries that static diagrams miss. Scenario flows validate that the architecture actually supports specific user journeys. Communication views expose coupling and integration patterns. Teams that relied on a single diagram type inevitably left gaps in their analysis.

### 6. Feasibility Matters for Startup Contexts

The kata description emphasized that Farmacy Foods is a startup. All three placing teams acknowledged budget constraints, team-size limitations, and time-to-market pressure in their architecture decisions: Architects++ chose FOSS and third-party platforms to minimize custom build; Sever Crew chose service-based over microservices for lower operational complexity; the Archangels established a buy-vs-build evaluation principle (ADR-006). Contextual awareness of business constraints is as important as pure technical excellence.

### 7. Diverse Team Sizes Can Succeed with Focus

The placing teams ranged from 3 members (Architects++, including a product manager) to 5 members (Sever Crew), with the 1st-place Archangels fielding 4 (including a member with prior kata experience). Team size did not determine quality -- focus and prioritization did. However, the Archangels' 4-person team produced the most comprehensive submission, suggesting that a focused team of 4 may be the sweet spot for this type of exercise.
