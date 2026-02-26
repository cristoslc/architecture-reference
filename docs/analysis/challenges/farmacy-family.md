# Farmacy Family -- Comparative Analysis

**Challenge:** O'Reilly Architecture Kata, Fall 2021
**Teams:** 7
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
| **Arch Angels** | Runner-up | Hybrid (Monolith + Event-Driven + Microservices) | 0 | 4 | Generalized catalog/fulfillment pattern; extends ArchColider component model; sequence diagrams for key flows |
| **Berlin Bears** | Runner-up | Serverless + Modular | 3 | 2 | Lean Canvas and Business Model Canvas; market sizing (TAM/SAM/SOM); persona-driven; AWS Step Functions for segmentation |
| **Elephant on a Cycle** | Runner-up | Microservices + Cloud-Native | 6 | 4 | Customer journey maps for 5 user types; comprehensive fitness functions; Zero Trust Architecture; micro-frontends; Nuna medical platform |
| **Pentagram 2021** | Runner-up | Service-Based + Event-Driven (hybrid) | 5 | 5 | Complete C4 hierarchy via Structurizr; data lake with ML pipeline; Epic EHR/EMR integration; deployment diagram |

---

## Architecture Style Choices

The seven teams chose five distinct architectural approaches, revealing how the same problem statement can yield fundamentally different design philosophies.

### Event-Driven (Archangels, 1st place)

The Archangels conducted a systematic comparison of microservices versus event-driven architecture against their seven prioritized quality attributes. They found that event-driven scored highly on four of seven characteristics (elasticity, scalability, fault tolerance, workflow) while microservices had more severe trade-offs around configurability and workflow. The winning insight was that workflow -- critical for the customer onboarding funnel -- is a natural strength of event-driven architecture. They reinforced this with the inbox-outbox pattern (ADR-004) to address the dual-write problem inherent in event-based systems.

### Service-Based with Event Integration (Sever Crew, 2nd; Pentagram 2021, runner-up)

Both Sever Crew and Pentagram 2021 chose service-based architecture as a pragmatic middle ground between monolith and microservices. Sever Crew's ADR-2 explicitly frames this as a "good compromise" -- macro-services resolve orchestration and transactional issues while avoiding the operational complexity of microservices. They added Kafka as an event integration layer between services, creating a hybrid that gets some event-driven benefits without the full commitment. Pentagram 2021 arrived at the same conclusion independently (ADR-003), also using Kafka as the event bus connecting their service-based components to a data lake.

### Hexagonal with DDD Services (Architects++, 3rd)

Architects++ took the most unconventional approach: hexagonal architecture with DDD-defined services, backed by AWS Batch for internal domain processing. Their backend components reference architecture uses hexagonal ports-and-adapters to isolate domain logic from infrastructure, with all services following the same pattern. This was driven by their principle of using a "single uniform technology" (ADR-13) appropriate for a startup that may only have one developer maintaining the system.

### Microservices and Cloud-Native (Elephant on a Cycle, runner-up)

Elephant on a Cycle chose full microservices with Kubernetes orchestration, citing scalability and domain partitioning as top priorities. They paired this with micro-frontends (ADR-3) for UI modularity. This was the most ambitious architectural choice among the teams and arguably the most complex for a startup context.

### Serverless (Berlin Bears, runner-up)

Berlin Bears went serverless-first, using AWS Lambda, API Gateway, DynamoDB, and Step Functions. Their ADR for new custom-build components explicitly chose serverless over a modularized monolith because requirements for customer profiles and segmentation were expected to change rapidly. The pay-per-request pricing model aligned well with startup cost constraints.

### Hybrid (Arch Angels, runner-up)

Arch Angels proposed a hybrid approach combining the existing monolith with event-driven and microservices patterns. Their architecture characteristics analysis evaluated cost, adaptability, agility, and feasibility, leading them to avoid any single pure style.

---

## What Separated Winners from Runners-Up

### 1. Depth and Rigor of Decision Records

The single most predictive factor for placement was ADR count and quality. The top three teams had 18, 11, and 15 ADRs respectively, while the runners-up had 0, 3, 5, and 6. This is not merely a documentation exercise -- ADRs reflect the depth of thinking about trade-offs. The Archangels' 18 ADRs covered everything from high-level architecture style (ADR-002) through domain granularity decisions (ADRs 011-017) down to specific integration patterns (ADRs 018-019). Each domain got its own split decision with explicit rationale.

The Arch Angels team (runner-up) had zero formal ADRs, which meant that while their solution had interesting ideas (the generalized catalog/fulfillment pattern), the reasoning behind decisions was not captured in a reviewable, traceable form.

### 2. Systematic Architecture Analysis Process

The top teams all followed a recognizable process: identify quality attributes, map them to architecture styles, evaluate trade-offs with explicit matrices, then decide. The Archangels' architecture patterns analysis compared microservices and event-driven side by side, with pros, cons, and mitigations for each. Sever Crew used a quality attributes overlay diagram to map concerns to specific containers. Architects++ mapped their five prioritized quality attributes (Security/HIPAA, Availability, Performance, Data Resilience, Usability) to specific ADR decisions.

Runners-up tended to state their architecture choice without showing the same level of comparative analysis. Elephant on a Cycle had strong fitness functions but did not document the architecture style selection process as thoroughly.

### 3. Security and Compliance Depth

HIPAA compliance was a differentiating challenge in this kata. The three medalists each addressed it distinctly and substantively:

- **Archangels** proposed crypto-shredding (ADR-005) for GDPR-style data deletion and Skyflow as a secure data vault (ADR-010), demonstrating awareness of specialized compliance tooling.
- **Sever Crew** (ADR-6) went deep on the legal specifics -- citing NIST 800-111 for data at rest, NIST 800-52/800-77/FIPS140-2 for data in motion, and referencing specific AWS HIPAA-eligible services. They also addressed the legal complexity of customer authorization forms.
- **Architects++** (ADR-1, their HIPAA ADR) made the provocative but well-reasoned decision that Farmacy Family should NOT isolate HIPAA functionality into separate components for the initial rollout, arguing that the operational burden of maintaining HIPAA compliance as a small startup is the real challenge, not the technical architecture. This demonstrated the kind of business-aware thinking that judges reward.

Among runners-up, Elephant on a Cycle proposed Zero Trust Architecture (ADR-5) and certified third-party platforms for medical data (ADR-4), but their healthcare compliance document was acknowledged as empty. Berlin Bears listed security as a quality attribute but did not address HIPAA specifically.

### 4. Complete Documentation Artifacts

The medalists all produced multiple complementary diagram types: C4 models (Archangels at full depth from context through component; Sever Crew with baseline and target), scenario flows, deployment diagrams, and data models. The Archangels added event storming, communication views, and fitness functions. Sever Crew added UI prototypes for desktop and mobile.

Several runner-up teams produced good diagrams but missed key perspectives. Arch Angels had sequence diagrams but no deployment view. Berlin Bears had sequence diagrams and a data model but no C4 diagrams. The completeness of the view portfolio matters for demonstrating that the architecture has been considered from multiple angles.

### 5. Realistic Startup Context Awareness

All three medalists explicitly grappled with the startup context. The Archangels' buy-vs-build ADR (006) established a principle of evaluating COTS before building. Sever Crew estimated data volumes and planned infrastructure sizing. Architects++ went furthest with their "partnership over rolling our own" principle, choosing Facebook Groups for community, Eventbrite for events, WordPress for CMS, Serendipity (FOSS) for CRM, and Human API for health data integration -- reducing the custom build surface dramatically.

---

## Common Patterns

Despite different architecture styles, several patterns appeared across multiple teams:

### AWS as the Deployment Platform

All seven teams chose AWS, which was driven by the constraint that Farmacy Foods was already deployed there. The shared platform choice led to convergent technology selections: Cognito for identity, S3 for storage, Lambda for serverless compute, and Kafka (MSK) for event streaming.

### Kafka as the Integration Backbone

Five of seven teams included Apache Kafka (or AWS MSK) as a core integration layer. Even teams that did not choose event-driven as their primary style (like Sever Crew's service-based approach) used Kafka for inter-service communication and analytics data pipelines. Kafka became the consensus answer for bridging the Farmacy Foods and Farmacy Family systems.

### Customer Segmentation as a Batch Process

Multiple teams (Berlin Bears, Sever Crew, Architects++) recognized that customer segmentation -- grouping users by geography, dietary needs, income level, and behavior -- should be a batch process rather than a real-time computation. Berlin Bears used AWS Step Functions; Architects++ used AWS Batch; Sever Crew used AWS Glue + Athena. This shared insight reflected a realistic assessment of the data volumes (hundreds of customers) and update frequency needed.

### Separation of Medical Data Concerns

Every team recognized that medical data required special treatment, though they differed in approach: third-party certified platforms (Elephant on a Cycle with Nuna, Archangels with Skyflow), HIPAA-eligible AWS services with encryption (Sever Crew), or explicitly deferring full HIPAA compliance while acknowledging the risk (Architects++).

### Integration with the Existing Reactive Monolith

All teams had to address the constraint of adding Farmacy Family UI to the existing Farmacy Foods interface. Sever Crew (ADR-5) and Arch Angels both proposed incorporating new functionality into the existing web and mobile apps rather than creating separate applications, prioritizing a unified user experience. Elephant on a Cycle took the opposite approach with micro-frontends (ADR-3), allowing independent deployment of UI components.

---

## Unique Innovations Worth Highlighting

### Crypto-Shredding for Data Privacy (Archangels, ADR-005)

The Archangels proposed maintaining a separate crypto key store with a per-user encryption key. To delete all of a user's data across a distributed system, you simply delete their key, making all their encrypted data unrecoverable -- even in backups. This is an elegant solution to the GDPR right-to-erasure problem in event-driven architectures where data may be replicated across multiple stores and event logs. The trade-off (needing a short-lived cache of unencrypted data for querying) was explicitly acknowledged.

### Graph Database for Analytics (Archangels, ADR-008)

Rather than defaulting to a relational or document store, the Archangels chose a graph database for analytics data, reasoning that community relationships, dietary patterns, and geographic connections are naturally graph-shaped. The bonus insight -- "can model the database exactly how things are in the real world, with no joins" -- reflects deep thinking about the problem domain rather than defaulting to familiar technology.

### Generalized Catalog/Fulfillment Pattern (Arch Angels)

The Arch Angels recognized that purchasing a meal, enrolling in an education course, and joining a community are architecturally identical catalog-and-fulfillment operations. They proposed a generalized Catalog interface extended by Meal Catalog, Education Catalog, and Community Catalog, with corresponding Fulfillment implementations. This is a powerful abstraction that demonstrates pattern recognition across domains and would significantly reduce code duplication in a real implementation.

### Epic EHR/EMR Integration (Pentagram 2021, ADR-002)

Pentagram 2021 was the only team to identify a specific real-world medical data integration: the Epic EHR/EMR API. Their ADR detailed exactly what data was available on Epic's free tier (vitals, lab results, diagnostic reports, medication requests, allergies, immunizations) and explicitly noted the limitation that it was read-only -- dieticians could not order tests through this channel. This level of specificity about third-party integration capabilities was unique.

### Structurizr for Diagram-as-Code (Pentagram 2021)

Pentagram 2021 used Structurizr to generate their C4 diagrams from code, producing the most complete C4 hierarchy of any team (system landscape, system context, container, component, and deployment levels). This approach ensures diagrams stay in sync with the architecture model and represents a mature practice for architecture governance.

### Business Model Canvas and Market Sizing (Berlin Bears)

Despite having only 2 active team members out of 5, Berlin Bears was the only team to produce a Lean Canvas, Business Model Canvas, and TAM/SAM/SOM market analysis. This business-architecture alignment is often missing from purely technical kata submissions and demonstrated an understanding that architecture decisions must serve business viability.

### Partnership-Over-Build with Specific Platforms (Architects++)

Architects++ made the boldest buy-vs-build choices: Facebook Groups for community (reasoning that their low-income, elderly, and first-responder users would prefer familiarity over custom software), Eventbrite for events, WordPress for CMS, and Human API for health data integration. Their decision to forego a mobile app entirely in favor of mobile web -- arguing that their customer base would not benefit from app-store complexity -- showed user-empathy-driven architecture.

### Comprehensive Fitness Functions (Elephant on a Cycle)

Elephant on a Cycle produced the most detailed fitness function specifications of any team. For each of their four architecture characteristics (scalability, security, domain partitioning, elasticity), they defined measurable criteria with specific thresholds (e.g., "latency does not exceed 20% from normal in 95th percentile in 5-minute intervals"), measurement methods for both test and production environments, and failure detection criteria. This is textbook architectural governance.

---

## Lessons for Practitioners

### 1. ADRs Are Not Optional

The correlation between ADR discipline and placement is striking. Teams that documented 10+ ADRs consistently placed higher than teams with fewer or no ADRs. The practice forces explicit trade-off analysis, creates institutional memory, and demonstrates to reviewers (and stakeholders in real projects) that decisions were deliberate rather than accidental. The Archangels' approach of dedicating an ADR to each domain split (ADRs 011-017) is a pattern worth adopting -- it prevents "accidental monolith" by making each boundary an explicit decision.

### 2. Start with Quality Attributes, Not Technology

The top teams all started by identifying and prioritizing quality attributes before selecting technologies. The Archangels identified seven quality attributes, ranked the top three (interoperability, configurability, authorization), and used these to evaluate architecture styles with a comparison matrix. This prevented the common anti-pattern of choosing microservices or serverless "because it is modern" and instead drove architecture from actual system requirements.

### 3. Address Compliance Head-On, Even if the Answer is "Not Yet"

Architects++ earned third place partly by making the honest, well-reasoned decision that full HIPAA isolation was not appropriate for the initial rollout of a small startup. This is more valuable than a superficial claim of compliance. Their rationale -- that the operational burden of maintaining compliance is the real challenge for small teams, and that duplicating functionality across HIPAA-governed and non-governed components introduces its own risks -- is applicable to many real-world projects. The key was that they analyzed the problem thoroughly and stated consequences clearly, rather than ignoring it.

### 4. Brownfield Thinking Requires Showing the Delta

The most effective teams (Sever Crew with baseline-vs-target diagrams, Arch Angels with their ArchColider component extension) explicitly showed how their new system related to the existing one. In brownfield architecture, the integration story is often more important than the greenfield design. Sever Crew's approach of producing both baseline and target C4 diagrams at context and container levels made the evolution path immediately clear to reviewers.

### 5. Multiple Perspectives Catch What Single Views Miss

The Archangels produced the richest set of views: C4 models, event storming, scenario flows, functional views, communication views, and deployment diagrams. Each view catches different classes of problems. Event storming reveals domain events and boundaries that static diagrams miss. Scenario flows validate that the architecture actually supports specific user journeys. Communication views expose coupling and integration patterns. Teams that relied on a single diagram type inevitably left gaps in their analysis.

### 6. Feasibility Matters for Startup Contexts

The kata description emphasized that Farmacy Foods is a startup. Teams that acknowledged budget constraints, team-size limitations, and time-to-market pressure in their architecture decisions (Architects++ choosing FOSS and third-party platforms; Berlin Bears choosing serverless for pay-per-request economics; Sever Crew choosing service-based over microservices for lower operational complexity) demonstrated contextual awareness that pure technical excellence alone does not provide.

### 7. Small Teams Can Compete on Depth

Berlin Bears fielded only 2 active members (out of 5 assigned) and still produced a runner-up entry with business analysis, sequence diagrams, and inline ADRs. Architects++ had 3 members including a product manager. Team size did not determine quality -- focus and prioritization did. However, the 1st-place Archangels' 4-person team (including a member with prior kata experience) produced the most comprehensive submission, suggesting that a focused team of 4 may be the sweet spot for this type of exercise.
