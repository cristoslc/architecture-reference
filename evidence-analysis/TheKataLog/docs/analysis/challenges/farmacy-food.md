# Farmacy Food -- Comparative Analysis

> **Challenge:** O'Reilly Architecture Kata, Fall 2020 Season
> **Teams analyzed:** 10 (3 placed, 7 runners-up)
> **Scope:** Design an ordering system for a ghost kitchen startup that distributes healthy meals via smart fridges and kiosks, supporting inventory tracking, customer engagement, and scalable growth.

---

## Challenge Overview

Farmacy Food is a real startup based in Detroit that produces healthy, nutritionally dense meals and distributes them through a network of smart fridges (Byte Technology) and kiosk points of sale (Toast POS) in sub-let spaces within other businesses. The architecture kata asked teams to design a system that could:

- **Integrate with third-party hardware:** Smart fridges with RFID-based inventory tracking and cloud management APIs, plus Toast POS kiosk systems.
- **Track inventory end-to-end:** From kitchen production (managed by ChefTec) through distribution to multiple points of sale, including expiry management.
- **Support customer engagement:** Feedback, surveys, coupons, promotional pricing, and eventually personalized dietary recommendations.
- **Scale geographically:** Start in Detroit, expand city-wide, then nationally -- from hundreds to thousands of customers.
- **Accommodate future ambitions:** Subscription meal plans, health expert platforms, multi-vendor marketplaces, and integration with health data (raising HIPAA concerns).

Key constraints included an existing technology stack (ChefTec for kitchen inventory, Toast for POS, QuickBooks for accounting), a startup budget, and a small development team. The challenge was rich in domain complexity -- bridging physical food logistics with digital customer experiences -- and offered teams latitude to define scope, assumptions, and architectural vision.

---

## Team Comparison Matrix

| Team | Placement | Architecture Style(s) | ADR Count | Cloud Platform | Key Differentiator |
|------|-----------|----------------------|-----------|----------------|-------------------|
| ArchColider | 1st | Modular Monolith + Event Sourcing + DDD | 16 | AWS (specific services) | Cost analysis across 3 growth scenarios; zero trust from day one |
| Miyagi's Little Forests | 2nd | Microservices + EDA + Hexagonal + DDD + CQRS | 6 | AWS (EKS/Kubernetes) | Rigorous architecture view template with element catalogs; DDD context map to microservices mapping |
| Jedis | 3rd | Microservices + Event-Driven | 10 | Cloud (unspecified) | 3-phase business growth strategy with per-phase architecture characteristics; 12 capability descriptions |
| DaVinci | Runner-up | Event-Driven Microservices | 9 | AWS (EKS/Kubernetes) | Benefit dependency network linking business goals to architecture; C4 diagrams |
| Hananoyama | Runner-up | Service-Based | 5 | Not specified | Deep actors/actions analysis; thorough domain questions with reasoned answers |
| Hey Dragon | Runner-up | Evolutionary (Monolith -> Service-Based -> Microservices) | 9 | Not specified | 3-stage evolutionary architecture with stage-specific ADRs |
| Jaikaturi | Runner-up | Serverless + Event-Driven | 9 | GCP (Firebase, Cloud Functions) | Real ChefTec vendor phone call; CDN-based offline smart fridge strategy |
| Self-Driven Team | Runner-up | Microservices | 20 | Cloud (unspecified) | 20 ADRs (highest count); 7 detailed personas; ML recommendation engine; PII anonymization |
| Super Kings | Runner-up | Microservices + SOA | 3 | Cloud (unspecified) | HIPAA-compliant health service with encryption; adapter pattern for external integrations |
| Team Pacman | Runner-up | Serverless | 5 | Cloud (unspecified) | 9 sequence diagrams (most extensive); step-by-step architecture progression; per-component characteristics mapping |

---

## Architecture Style Choices

### The Spectrum of Approaches

The ten teams spanned nearly the full spectrum of architecture styles described in *Fundamentals of Software Architecture*, revealing how the same problem statement can reasonably lead to very different structural decisions.

**Microservices-first (5 teams):** Miyagi's Forests, Jedis, DaVinci, Self-Driven Team, and Super Kings all chose microservices as their primary style. The rationale was consistent -- independent deployability, scalability per service, and alignment with cloud-native deployment. Miyagi's Forests provided the most rigorous justification in ADR 001, explicitly rejecting serverless (mixed runtime burden), phased approaches (unnecessary for greenfield), and service-based architecture (less suited to containerization), while acknowledging the tradeoffs of operational complexity.

**Modular Monolith (1 team):** ArchColider (1st place) made the contrarian choice of a modular monolith, arguing in ADR 002 that the startup context -- small team, unproven domain model, need for cognitive simplicity -- did not justify the infrastructure overhead of microservices. They scored four architecture styles against ten quality attributes using a structured comparison matrix, concluding that microservices "require a lot of attention to infrastructure, separation of responsibility, preferably a stable and known domain model." Their bet was that well-designed module facades would preserve the option to extract services later without paying the distributed systems tax upfront.

**Evolutionary Architecture (1 team):** Hey Dragon proposed a distinctive three-stage evolution: layered monolith (Stage 1, optimizing for time to market), service-based architecture (Stage 2, enabling independent deployment), and event-driven microservices (Stage 3, supporting full scalability). Each stage had its own set of ADRs and architecture diagrams. This was the most explicit treatment of architecture as a journey rather than a destination.

**Serverless (2 teams):** Jaikaturi (GCP/Firebase) and Team Pacman both chose serverless, though from very different angles. Jaikaturi framed the decision in ADR 3 as a startup viability concern: "Building virtual machines and self-hosting means that the developers will have to spend time maintaining and operating machines. That cost is significant and will slow down development time." Team Pacman provided a direct comparison ADR rejecting monolithic in favor of serverless for scalability and operational simplicity.

**Service-Based (1 team):** Hananoyama chose a service-based architecture, reasoning from a minimal set of components derived from careful actors/actions analysis rather than from a technology-first perspective.

### Patterns That Emerge

1. **DDD was a common analytical tool regardless of architecture style.** ArchColider, Miyagi's Forests, Jedis, and Self-Driven Team all used domain-driven design for decomposition, even when they disagreed on runtime architecture.

2. **Event-driven architecture appeared as a secondary style in nearly every submission.** Even teams that chose microservices or modular monolith recognized the need for asynchronous communication -- for inventory updates, notifications, and analytics pipelines. Kafka was the most frequently cited technology for this purpose.

3. **No team chose a pure monolith.** Even ArchColider's modular monolith was designed with explicit module boundaries and inter-module communication patterns that anticipated future extraction. The kata's emphasis on scalability and growth made pure monolith untenable.

4. **Cloud provider specificity correlated with depth.** Teams that named specific services (ArchColider with AWS, Miyagi's Forests with AWS EKS, Jaikaturi with GCP/Firebase) tended to produce more actionable deployment views than teams that said "cloud (unspecified)."

---

## What Separated Winners from Runners-Up

The gap between the top 3 and the runners-up was not about choosing the "right" architecture style -- the winner chose a modular monolith while most runners-up chose microservices. The differentiators were depth, rigor, and holistic thinking.

### 1. Treating Architecture as a Business Decision, Not Just a Technical One

**ArchColider (1st)** produced a detailed cost analysis with three growth scenarios (MIN: 500 requests/day, PROJECTED: 1,000 requests/day, RAPID: 10,000 requests/day), calculating line-item costs for every AWS service down to data transfer rates. Their 1-year TCO ranged from $12,248 to $22,481. No other team produced anything comparable. For a startup kata, demonstrating that you understand the financial implications of your architecture decisions is exactly what judges are looking for.

**Jedis (3rd)** connected architecture to business through a phased growth strategy where architecture characteristics explicitly changed per business stage -- from fault tolerance and elasticity in the short term, to workflow support and evolvability in the mid term, to performance and cost optimization in the long term. They also envisioned the platform evolving from a smart fridge network into a "healthy eating community," showing business imagination beyond the immediate requirements.

### 2. ADR Quality Over Quantity

Self-Driven Team had the most ADRs (20), yet placed as a runner-up. ArchColider had 16 and won. The difference was in the depth and specificity of individual ADRs. ArchColider's ADR 002 (System Approach) included a structured scoring matrix comparing four architecture styles against ten quality attributes. Their ADR 007 (Event Sourcing) compared snapshot-based approaches against event sourcing with concrete rationale about complaint resolution and data migration during active development. Their ADR 006 (Zero Trust) anticipated the modular monolith's future extraction to services by requiring security tokens on internal module calls from day one.

By contrast, several runner-up ADRs were structurally sound but lacked the depth of considered alternatives or concrete consequences.

### 3. Multiple Architectural Views and Perspectives

**Miyagi's Forests (2nd)** excelled here with five distinct runtime architecture views (User Account Management, Catalog, Order, Customer at Pick-up, Replenisher), each following a formal architecture view template with element catalogs, behavior descriptions, and quality attribute discussions. They also produced a DDD context map, a context-map-to-microservices mapping, a hexagonal reference architecture for internal bounded context structure, and a detailed AWS deployment view with EKS multi-AZ configuration. This systematic use of viewpoints demonstrated architectural rigor that most runner-up teams did not match.

**ArchColider** provided comparable breadth: strategic domain design, conceptual models, component composition, information models, concurrency views, deployment views, infrastructure/networking diagrams, user scenarios, a security view, and the cost analysis.

### 4. Addressing the Hard Problem of External Integration

The kata's integration requirements (Byte Technology smart fridges, Toast POS, ChefTec kitchen management) were a differentiator. Teams that engaged deeply with these constraints scored higher.

**Jaikaturi** (runner-up but notably innovative) actually phoned ChefTec's consultancy line to understand integration feasibility. They learned that a standard integration would cost around $500 and that custom integrations could exceed $5,000 and take 60+ days. This kind of real-world research demonstrated practical architectural thinking.

**ArchColider** addressed the smart fridge data staleness problem in ADR 012, acknowledging that fridge inventory data would always be slightly stale and designing the system to handle eventual consistency rather than pretending real-time accuracy was achievable.

**Hananoyama** (runner-up) provided the deepest exploration of how smart fridges and kiosks actually differ in practice -- detailing RFID-based transactions at fridges versus staff-mediated transactions at kiosks -- and reasoning through the implications for inventory tracking and pricing.

### 5. Security as a First-Class Concern

ArchColider's zero trust ADR (ADR 006) and Self-Driven Team's PII anonymization ADR (ADR 008) and HIPAA considerations stood out. Most other teams mentioned security as a quality attribute but did not produce specific ADRs addressing how security would be implemented. Super Kings addressed HIPAA compliance for the health service with encryption and audit logging but had fewer ADRs overall.

---

## Common Patterns

Despite different architecture styles, several patterns emerged across most or all teams:

### 1. Separation of Customer-Facing and Operational Concerns
Every team separated the customer experience (ordering, browsing, feedback) from operational systems (kitchen management, inventory, distribution). This is a natural domain boundary that all teams independently identified.

### 2. Event-Based Inventory Propagation
Whether using Kafka, RabbitMQ, Cloud Pub/Sub, or generic message queues, all teams recognized that inventory updates between smart fridges, kitchens, and the central system should be asynchronous. The real-time nature of physical inventory (meals removed from fridges, meals produced in kitchens) does not map well to synchronous request-response patterns.

### 3. External Payment Delegation
No team attempted to build payment processing in-house. All teams that addressed payments (ArchColider ADR 009, Miyagi's Forests ADR 002, Jaikaturi ADR 4) chose to delegate to external providers (Stripe was the most common choice), citing PCI compliance burden and security risk as reasons.

### 4. Notification as a Separate Subsystem
Teams consistently identified notification (SMS, email, push) as a cross-cutting concern deserving its own service or module. Jedis went furthest, splitting notification into a Notification Scheduler (for timing) and a Notification Sender (for multi-channel dispatch), documented in separate ADRs.

### 5. Actors/Actions as a Starting Point
Multiple teams (Hananoyama, Self-Driven Team ADR 001, implicitly others) used actor/action analysis as their primary method for identifying system components and boundaries. This is consistent with the approach taught in the O'Reilly architecture fundamentals course.

### 6. Recognition of the ChefTec Integration Challenge
Most teams acknowledged that ChefTec was a black box with unclear API availability. Teams ranged from treating it as an external system with a clean adapter interface (Super Kings, ArchColider) to actually researching its integration capabilities (Jaikaturi).

---

## Unique Innovations Worth Highlighting

### ArchColider: Event Sourcing for Order Audit Trail (ADR 007)
While event sourcing is a well-known pattern, ArchColider's rationale was specific and compelling: in a food delivery business that depends on reputation, the ability to reconstruct exactly how an order progressed through states is essential for resolving customer complaints. They also noted that event sourcing would support data model migrations during the active development phase -- a practical concern for a startup whose domain model is still evolving.

### Miyagi's Forests: Hexagonal Architecture as Microservice Internal Reference (Architecture View)
Rather than just prescribing microservices, Miyagi's Forests defined how each bounded context should be internally structured using hexagonal (ports and adapters) architecture. This bridged the gap between high-level microservice decomposition and code-level design, giving developers a clear blueprint for implementation.

### Jedis: Architecture Characteristics Per Growth Phase (Strategy Document)
Jedis explicitly defined how architecture characteristics should shift as the business grows: short-term priorities are fault tolerance, elasticity, and cost; mid-term priorities add workflow support, evolvability, and plugins (microkernel for notifications); long-term priorities center on scalability, performance, and cost at scale. They even recommended different architecture style preferences per phase -- microservices for short term, event-driven with microkernel for mid term, event-driven for long term.

### Jaikaturi: CDN-Based Offline Smart Fridge Access (ADR 8)
Jaikaturi designed a decentralized offline strategy where daily order files are distributed to smart fridges via Google CDN. The files contain hashed subsets of credit card digits (not full numbers) so that fridges can authenticate customers and release meals even without internet connectivity. They designed the hashing scheme so that brute-force attacks would map to many possible cards, making the cost of breaking the scheme exceed the cost of the meal. This was the most creative approach to the fridge availability problem across all teams.

### Jaikaturi: Actual Vendor Research (ChefTec Phone Call)
Jaikaturi called ChefTec's consultancy line, confirmed integration was feasible, obtained approximate costs ($500 for standard, $5,000+ for custom), and learned about timelines (60+ days for custom). This level of real-world validation was unique among all teams and demonstrated that architecture is not just about diagrams.

### Self-Driven Team: ML Recommendation Engine Design (ADR 010, ADR 020)
Self-Driven Team designed a recommendation engine with three components: an ML model trainer (batch system), an inference service (real-time), and a manual recommendation merger (allowing nutritionists to override or supplement ML recommendations). ADR 020 chose a hybrid approach combining automated ML with expert manual input. This was the most detailed treatment of the personalization requirement.

### Self-Driven Team: Seven Detailed Personas
Rather than generic user categories, Self-Driven Team created named personas (Alice the Chef, Barbara the Kiosk Worker, Claire the Analyst, Edward the Delivery Driver, Jennifer the Subscriber, Mark the Nutritionist, Scott the Occasional Customer) with detailed stories, goals, and system interactions. This user-centered approach grounded their technical decisions in concrete usage patterns.

### Hey Dragon: Explicit Evolutionary Architecture (All Stages Diagram)
Hey Dragon was the only team to make architecture evolution their central thesis. Their all-stages overview diagram shows the literal progression from monolith to service-based to event-driven microservices, with clear criteria for when to trigger each transition. This is valuable as a reference for practitioners who need to present architecture roadmaps to non-technical stakeholders.

### DaVinci: Benefit Dependency Network
DaVinci created a benefit dependency network that traced from business goals through benefits to enabling features and architecture decisions. This technique, borrowed from business analysis, provided clear traceability from "why are we building this" to "what architecture decisions support it."

### Hananoyama: Deep Domain Question Exploration
Hananoyama's README contained an extensive Q&A section exploring questions like: How does a kiosk differ from a smart fridge? How is inventory tracked differently at each? Can dynamic pricing be displayed at a fridge? Their conclusion -- that tiered pricing can only apply to subscriptions or app-based ordering, not at physical points of sale -- showed the kind of domain reasoning that architects must do but rarely document.

### Team Pacman: Per-Component Architecture Characteristics Table
Team Pacman mapped specific quality attributes to individual components (e.g., Inventory needs scalability, performance, availability, and reliability; Expiry Tracker needs only performance). This granular mapping is more useful than system-wide quality attribute statements because it drives specific implementation and deployment decisions per component.

---

## Lessons for Practitioners

### 1. The "Right" Architecture Style is Context-Dependent
The winning team chose a modular monolith. The second-place team chose microservices. The third-place team also chose microservices but with a different emphasis. Multiple runners-up chose serverless, service-based, or evolutionary approaches. What mattered was not the style itself but the quality of the justification and how well it fit the stated constraints (startup team, limited budget, need for speed).

**Takeaway:** In architecture katas and in real projects, the decision rationale matters more than the decision itself. ArchColider's structured comparison matrix (ADR 002) demonstrating why modular monolith beat microservices for *their specific context* was more persuasive than teams that chose microservices as a default.

### 2. ADRs Are a Competitive Advantage When They Show Depth
Quantity alone does not win. Self-Driven Team had 20 ADRs and placed as a runner-up. ArchColider had 16 and won. The winning ADRs showed: considered alternatives with explicit tradeoff analysis, specific consequences (not just "we need to do X"), and connections to business drivers. The best ADRs (like ArchColider's ADR 002 or Miyagi's Forests' ADR 001) explicitly listed rejected alternatives with reasons.

**Takeaway:** An ADR that says "We chose X because of A, B, C. We rejected Y because of D, E. The consequences are F, G, and we accept risk H" is worth more than five ADRs that each say "We chose X."

### 3. Cost and Feasibility Analysis Separates Senior from Junior Thinking
Only ArchColider and Jaikaturi produced feasibility or cost analysis. In a kata about a startup, this is particularly relevant -- a beautiful microservices architecture that costs $100K/year to run is not appropriate for a company selling $12 meals from smart fridges. ArchColider's three-scenario cost model showed that even the rapid growth scenario stayed under $23K/year, demonstrating that their architecture was viable for the business.

**Takeaway:** If the problem domain involves a startup or cost-sensitive organization, include at least a rough cost model. It demonstrates business acumen, not just technical skill.

### 4. Multiple Viewpoints Reveal More Than a Single System Diagram
Teams with multiple architecture views (ArchColider with 10+ diagram types, Miyagi's Forests with 5 runtime views plus context map plus deployment view) could reason about the system from different angles. Teams with a single architecture diagram (some runners-up) had to pack too much information into one view, losing clarity.

**Takeaway:** Use at least: (a) a context diagram showing external systems, (b) a component/service diagram showing internal structure, (c) a deployment view showing infrastructure, and (d) sequence or activity diagrams showing key workflows. Each view answers different stakeholder questions.

### 5. Engaging with External Systems Shows Real-World Readiness
The kata specified integration with Byte Technology (smart fridges), Toast (POS), ChefTec (kitchen management), and QuickBooks (accounting). Teams that researched these systems' actual APIs and constraints produced more credible architectures. Jaikaturi's phone call to ChefTec, Hananoyama's detailed analysis of fridge vs. kiosk differences, and ArchColider's stale data ADR all showed engagement with the messiness of real integration.

**Takeaway:** In any architecture exercise, investigate the actual APIs, data formats, and limitations of the systems you need to integrate with. Assumptions about integration being "straightforward" are a common source of project failure.

### 6. Business Growth Strategy Grounds Architecture in Reality
Jedis and Hey Dragon both proposed phased approaches tied to business growth. Jaikaturi defined six milestones from marketing analytics to multi-location scaling. These approaches acknowledge that architecture is not a one-time decision but an evolving response to business needs.

**Takeaway:** Show how your architecture supports not just current requirements but a plausible growth path. Define what changes at each stage and what architectural characteristics become more or less important.

### 7. Domain Understanding Beats Technology Sophistication
Hananoyama placed as a runner-up despite having no deployment views, no specific technology choices, and minimal infrastructure documentation. What they did have was an extraordinarily thorough analysis of the problem domain -- actors, actions, component responsibilities, and nuanced questions about how the physical world (fridges, kiosks, kitchens) actually works. This deep domain understanding is the foundation that all good architectures are built on.

**Takeaway:** Start with the domain, not the technology. Understand actors, actions, and business rules before drawing component diagrams. Technology choices should follow from requirements analysis, not precede it.
