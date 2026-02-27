# Farmacy Food -- Comparative Analysis

> **Challenge:** O'Reilly Architecture Kata, Fall 2020 Season
> **Teams analyzed:** 3
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

---

## Architecture Style Choices

### The Spectrum of Approaches

Despite being only three teams, the placing entries spanned a remarkable range of architecture styles, demonstrating that the same problem statement can reasonably lead to very different structural decisions depending on which constraints a team prioritizes.

**Modular Monolith (ArchColider, 1st place):** ArchColider made the contrarian choice of a modular monolith, arguing in ADR 002 that the startup context -- small team, unproven domain model, need for cognitive simplicity -- did not justify the infrastructure overhead of microservices. They scored four architecture styles against ten quality attributes using a structured comparison matrix, concluding that microservices "require a lot of attention to infrastructure, separation of responsibility, preferably a stable and known domain model." Their bet was that well-designed module facades would preserve the option to extract services later without paying the distributed systems tax upfront.

**Microservices with Hexagonal Internals (Miyagi's Little Forests, 2nd place):** Miyagi's Forests chose microservices as their primary style and provided the most rigorous justification in ADR 001, explicitly rejecting serverless (mixed runtime burden), phased approaches (unnecessary for greenfield), and service-based architecture (less suited to containerization), while acknowledging the tradeoffs of operational complexity. Critically, they also defined how each bounded context should be internally structured using hexagonal (ports and adapters) architecture, bridging the gap between high-level decomposition and code-level design.

**Microservices with Phased Evolution (Jedis, 3rd place):** Jedis also chose microservices but distinguished their approach through a business-growth-driven lens, defining how architecture characteristics should shift across three growth phases. Rather than presenting a static target architecture, they recommended different architecture style emphases per phase -- microservices for short term, event-driven with microkernel for mid term, event-driven for long term -- acknowledging that the right architecture evolves with the business.

### Patterns That Emerge

1. **DDD was a shared analytical foundation.** All three placing teams used domain-driven design for decomposition, even when they disagreed on runtime architecture. This suggests DDD is a reliable starting methodology regardless of the target architecture style.

2. **Event-driven architecture appeared as a secondary style in every submission.** Even ArchColider's modular monolith incorporated event sourcing, recognizing the need for asynchronous communication for inventory updates, notifications, and analytics pipelines. Kafka was the most frequently cited technology for this purpose.

3. **No team chose a pure monolith.** Even ArchColider's modular monolith was designed with explicit module boundaries and inter-module communication patterns that anticipated future extraction. The kata's emphasis on scalability and growth made a pure monolith untenable.

4. **Cloud provider specificity correlated with depth.** ArchColider named specific AWS services and calculated line-item costs. Miyagi's Forests detailed an AWS EKS multi-AZ deployment configuration. Both produced more actionable deployment views than a generic "cloud" designation would allow.

---

## What Distinguished the Top Teams

The placing teams each brought distinct strengths, but they shared several qualities that elevated their submissions above the field. Notably, the winning team chose a modular monolith while 2nd and 3rd place chose microservices -- demonstrating that the "right" style mattered far less than the rigor behind the choice.

### 1. Treating Architecture as a Business Decision, Not Just a Technical One

**ArchColider (1st)** produced a detailed cost analysis with three growth scenarios (MIN: 500 requests/day, PROJECTED: 1,000 requests/day, RAPID: 10,000 requests/day), calculating line-item costs for every AWS service down to data transfer rates. Their 1-year TCO ranged from $12,248 to $22,481. For a startup kata, demonstrating that you understand the financial implications of your architecture decisions is exactly what judges look for.

**Jedis (3rd)** connected architecture to business through a phased growth strategy where architecture characteristics explicitly changed per business stage -- from fault tolerance and elasticity in the short term, to workflow support and evolvability in the mid term, to performance and cost optimization in the long term. They also envisioned the platform evolving from a smart fridge network into a "healthy eating community," showing business imagination beyond the immediate requirements.

### 2. ADR Quality Over Quantity

ArchColider had 16 ADRs and won. The strength lay in the depth and specificity of individual ADRs. ArchColider's ADR 002 (System Approach) included a structured scoring matrix comparing four architecture styles against ten quality attributes. Their ADR 007 (Event Sourcing) compared snapshot-based approaches against event sourcing with concrete rationale about complaint resolution and data migration during active development. Their ADR 006 (Zero Trust) anticipated the modular monolith's future extraction to services by requiring security tokens on internal module calls from day one.

Miyagi's Forests had only 6 ADRs but each was substantive. ADR 001 explicitly listed rejected alternatives (serverless, phased, service-based) with detailed reasons for each rejection. Jedis' 10 ADRs included separate, focused decisions for notification scheduling versus notification sending -- demonstrating the kind of granular thinking that makes ADRs actionable rather than ceremonial.

**The lesson:** ADRs that show considered alternatives with explicit tradeoff analysis, specific consequences, and connections to business drivers are far more valuable than a higher count of shallow decisions.

### 3. Multiple Architectural Views and Perspectives

**Miyagi's Forests (2nd)** excelled here with five distinct runtime architecture views (User Account Management, Catalog, Order, Customer at Pick-up, Replenisher), each following a formal architecture view template with element catalogs, behavior descriptions, and quality attribute discussions. They also produced a DDD context map, a context-map-to-microservices mapping, a hexagonal reference architecture for internal bounded context structure, and a detailed AWS deployment view with EKS multi-AZ configuration. This systematic use of viewpoints demonstrated architectural rigor that is rare in kata submissions.

**ArchColider** provided comparable breadth: strategic domain design, conceptual models, component composition, information models, concurrency views, deployment views, infrastructure/networking diagrams, user scenarios, a security view, and the cost analysis.

**Jedis** complemented their architecture diagrams with 12 detailed capability descriptions, providing a different kind of view -- one that mapped business capabilities to technical components and clarified what each part of the system was responsible for.

### 4. Addressing the Hard Problem of External Integration

The kata's integration requirements (Byte Technology smart fridges, Toast POS, ChefTec kitchen management) were a key differentiator. Teams that engaged deeply with these constraints produced more credible architectures.

**ArchColider** addressed the smart fridge data staleness problem in ADR 012, acknowledging that fridge inventory data would always be slightly stale and designing the system to handle eventual consistency rather than pretending real-time accuracy was achievable. This kind of honest constraint analysis is a hallmark of mature architectural thinking.

**Jedis** identified integration points as explicit architectural components with defined responsibilities, ensuring that third-party dependencies were isolated behind clear interfaces rather than leaking into core domain logic.

**Miyagi's Forests** addressed external integration through their hexagonal architecture approach, where ports and adapters provided a natural boundary between the domain and external systems, making it straightforward to swap or evolve integrations without affecting core business logic.

### 5. Security as a First-Class Concern

ArchColider's zero trust ADR (ADR 006) stood out as a particularly forward-thinking decision. By requiring security tokens on internal module calls from day one -- even within a modular monolith where such calls are in-process -- they ensured that a future migration to distributed services would not require retrofitting authentication. Most teams mentioned security as a quality attribute but did not produce specific ADRs addressing how security would be architecturally enforced.

---

## Common Patterns

Despite choosing different architecture styles, several patterns emerged across all three placing teams:

### 1. Separation of Customer-Facing and Operational Concerns
Every team separated the customer experience (ordering, browsing, feedback) from operational systems (kitchen management, inventory, distribution). This is a natural domain boundary that all teams independently identified, suggesting it is a fundamental structural insight for food-logistics systems.

### 2. Event-Based Inventory Propagation
Whether using Kafka or generic message queues, all three teams recognized that inventory updates between smart fridges, kitchens, and the central system should be asynchronous. The real-time nature of physical inventory (meals removed from fridges, meals produced in kitchens) does not map well to synchronous request-response patterns.

### 3. External Payment Delegation
No team attempted to build payment processing in-house. Both ArchColider (ADR 009) and Miyagi's Forests (ADR 002) chose to delegate to external providers (Stripe was the most common choice), citing PCI compliance burden and security risk as reasons. This reflects a mature understanding of where build-versus-buy decisions should fall.

### 4. Notification as a Separate Subsystem
All three teams identified notification (SMS, email, push) as a cross-cutting concern deserving its own service or module. Jedis went furthest, splitting notification into a Notification Scheduler (for timing) and a Notification Sender (for multi-channel dispatch), documented in separate ADRs. This separation of scheduling from delivery is a pattern worth adopting in practice.

### 5. DDD-Driven Decomposition
All three placing teams used domain-driven design as their primary method for identifying system boundaries. ArchColider used strategic domain design to define module boundaries within the monolith. Miyagi's Forests produced a formal DDD context map that directly mapped to microservice boundaries. Jedis used domain capabilities as the organizing principle for their service decomposition. The consistency of this approach across all three winners reinforces DDD as the dominant decomposition methodology in modern architecture practice.

---

## Unique Innovations Worth Highlighting

### ArchColider: Event Sourcing for Order Audit Trail (ADR 007)
While event sourcing is a well-known pattern, ArchColider's rationale was specific and compelling: in a food delivery business that depends on reputation, the ability to reconstruct exactly how an order progressed through states is essential for resolving customer complaints. They also noted that event sourcing would support data model migrations during the active development phase -- a practical concern for a startup whose domain model is still evolving.

### ArchColider: Three-Scenario Cost Model (Cost Analysis)
ArchColider's line-item cost analysis across three growth scenarios (MIN, PROJECTED, RAPID) was unique among all submissions. By calculating specific AWS service costs down to data transfer rates, they demonstrated that their modular monolith architecture was financially viable for a startup -- with a 1-year TCO ranging from $12,248 to $22,481. This grounded their architecture in business reality rather than technical idealism.

### ArchColider: Zero Trust in a Modular Monolith (ADR 006)
Requiring security tokens on internal module calls within a monolith is an unusual decision, but ArchColider justified it as future-proofing: when modules are eventually extracted to separate services, authentication is already in place. This demonstrates the kind of long-horizon thinking that separates strategic architecture from tactical code organization.

### Miyagi's Forests: Hexagonal Architecture as Microservice Internal Reference (Architecture View)
Rather than just prescribing microservices, Miyagi's Forests defined how each bounded context should be internally structured using hexagonal (ports and adapters) architecture. This bridged the gap between high-level microservice decomposition and code-level design, giving developers a clear blueprint for implementation. It is one of the clearest examples in any kata submission of providing guidance at multiple levels of abstraction.

### Miyagi's Forests: Formal Architecture View Templates with Element Catalogs
Each of Miyagi's Forests' five runtime views followed a consistent template that included an element catalog (naming every component in the view with its responsibility), behavior descriptions, and quality attribute discussions. This level of formalism made their views self-documenting and reviewable -- a practice that translates directly to professional architecture documentation.

### Jedis: Architecture Characteristics Per Growth Phase (Strategy Document)
Jedis explicitly defined how architecture characteristics should shift as the business grows: short-term priorities are fault tolerance, elasticity, and cost; mid-term priorities add workflow support, evolvability, and plugins (microkernel for notifications); long-term priorities center on scalability, performance, and cost at scale. This phase-aware approach to architecture characteristics is a valuable framework for any team that needs to present an architecture roadmap tied to business milestones.

### Jedis: Twelve Capability Descriptions
Jedis documented 12 distinct business capabilities, each with a clear description of what it does, why it exists, and which services support it. This capability-mapping approach provided traceability from business needs to technical components, ensuring that every service had a clear business justification and that no capabilities were left unaddressed.

---

## Lessons for Practitioners

### 1. The "Right" Architecture Style is Context-Dependent
The winning team chose a modular monolith. The second- and third-place teams chose microservices. What mattered was not the style itself but the quality of the justification and how well it fit the stated constraints (startup team, limited budget, need for speed).

**Takeaway:** In architecture katas and in real projects, the decision rationale matters more than the decision itself. ArchColider's structured comparison matrix (ADR 002) demonstrating why modular monolith beat microservices for *their specific context* was more persuasive than a default choice of microservices would have been.

### 2. ADRs Are a Competitive Advantage When They Show Depth
The winning ADRs showed: considered alternatives with explicit tradeoff analysis, specific consequences (not just "we need to do X"), and connections to business drivers. The best ADRs (like ArchColider's ADR 002 or Miyagi's Forests' ADR 001) explicitly listed rejected alternatives with reasons. Jedis' granular ADRs for notification scheduling versus sending showed how fine-grained decisions benefit from formal documentation.

**Takeaway:** An ADR that says "We chose X because of A, B, C. We rejected Y because of D, E. The consequences are F, G, and we accept risk H" is worth more than five ADRs that each say "We chose X."

### 3. Cost and Feasibility Analysis Separates Senior from Junior Thinking
ArchColider's three-scenario cost model showed that even the rapid growth scenario stayed under $23K/year, demonstrating that their architecture was viable for the business. In a kata about a startup, this is particularly relevant -- a beautiful microservices architecture that costs $100K/year to run is not appropriate for a company selling $12 meals from smart fridges.

**Takeaway:** If the problem domain involves a startup or cost-sensitive organization, include at least a rough cost model. It demonstrates business acumen, not just technical skill.

### 4. Multiple Viewpoints Reveal More Than a Single System Diagram
ArchColider produced 10+ diagram types. Miyagi's Forests created 5 runtime views plus a context map plus a deployment view. Jedis provided 12 capability descriptions alongside architecture diagrams. Each view answers different stakeholder questions and reveals different aspects of the system.

**Takeaway:** Use at least: (a) a context diagram showing external systems, (b) a component/service diagram showing internal structure, (c) a deployment view showing infrastructure, and (d) sequence or activity diagrams showing key workflows. Each view answers different stakeholder questions.

### 5. Engaging with External Systems Shows Real-World Readiness
The kata specified integration with Byte Technology (smart fridges), Toast (POS), ChefTec (kitchen management), and QuickBooks (accounting). ArchColider's stale data ADR for smart fridge inventory, Miyagi's Forests' hexagonal port-and-adapter approach for integration isolation, and Jedis' explicit integration components all showed genuine engagement with the messiness of real-world system boundaries.

**Takeaway:** In any architecture exercise, investigate the actual APIs, data formats, and limitations of the systems you need to integrate with. Assumptions about integration being "straightforward" are a common source of project failure.

### 6. Business Growth Strategy Grounds Architecture in Reality
Jedis proposed a phased approach tied to business growth, defining what changes at each stage and what architectural characteristics become more or less important. ArchColider's cost scenarios implicitly addressed growth by modeling MIN, PROJECTED, and RAPID load. Miyagi's Forests' deployment view with multi-AZ Kubernetes addressed operational growth.

**Takeaway:** Show how your architecture supports not just current requirements but a plausible growth path. Define what changes at each stage and what architectural characteristics become more or less important.

### 7. Domain Understanding is the Foundation
All three placing teams demonstrated deep engagement with the problem domain before making technology choices. ArchColider's event sourcing decision grew from understanding how food delivery complaints need resolution. Miyagi's Forests' DDD context map emerged from careful bounded context analysis. Jedis' capability descriptions showed thorough understanding of what the business actually needed. Deep domain understanding is the foundation that all good architectures are built on.

**Takeaway:** Start with the domain, not the technology. Understand actors, actions, and business rules before drawing component diagrams. Technology choices should follow from requirements analysis, not precede it.
