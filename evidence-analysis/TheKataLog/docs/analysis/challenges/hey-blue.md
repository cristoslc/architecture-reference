# Hey Blue! -- Comparative Analysis

**Challenge:** Hey Blue! -- Fall 2022 O'Reilly Architecture Katas
**Teams Analyzed:** 3
**Challenge Brief:** Design a platform to facilitate meaningful connections between police officers and community members, incentivized through a points-based rewards system with affiliate marketing. The platform is for a non-profit (EcoSchool) founded by retired NYPD officer and 9/11 first responder John Verdi.

---

## Challenge Overview

The Hey Blue! kata presented teams with a socially impactful but architecturally demanding problem: build a mobile-first platform where police officers opt in to be discoverable by nearby citizens, facilitate real-time "connection" moments (in-person or virtual), award points for those connections, and allow points to be redeemed at retail storefronts or donated to charities. The platform must serve a non-profit with limited budget, scale to potentially millions of users across U.S. cities, handle real-time geolocation, protect officer safety and privacy, and integrate with social media for amplification.

Key architectural tensions in the challenge:

- **Cost vs. Scale** -- A non-profit with grant funding needs enterprise-grade geolocation and real-time messaging.
- **Officer Safety vs. Discoverability** -- Officers must be findable, but their locations must be protected from misuse.
- **Real-Time vs. Simplicity** -- Connection workflows demand low-latency proximity detection, yet the system must be maintainable by a small team.
- **MVP vs. Vision** -- The 1.2 billion annual connection target implies massive scale, but the initial launch is a startup.

---

## Team Comparison Matrix

| Dimension | MonArch (1st) | IPT (2nd) | Black Cat Manifestation (3rd) |
|---|---|---|---|
| **Team Size** | 3 | 3 | 2 |
| **Architecture Style** | Microservices + Event-Driven + Hexagonal | Microservices + Event-Driven + DDD | Event-Driven (Mediator Topology) |
| **Cloud Platform** | Google Cloud (GCP) | Microsoft Azure | None specified (Elixir/Actor model) |
| **ADR Count** | 7 | 8 | 7 |
| **Modeling Approach** | C4 (Context/Container/Component) + Event Storming | Event Storming + Domain Capabilities | Architecture Characteristics Worksheet + Scenarios |
| **Cost Analysis** | Yes ($2,780/mo for 50K MAU) | Yes (qualitative feasibility) | Qualitative feasibility only |
| **GDPR/Privacy** | Not addressed | Dedicated ADR (ADR08) | Officer privacy via QR codes (ADR06) |
| **Deployment View** | Yes (GCP-specific) | Yes (Azure-specific) | No |
| **Video Presentation** | No | No | No |
| **Unique Differentiator** | In-memory graph for geolocation | Microkernel dispatcher for business integration | Elixir actor model + QR code-first design |

---

## Architecture Style Choices

### The Microservices Consensus -- and Where Teams Diverged

Two of the three placing teams chose microservices as a primary or contributing style. The third, **Black Cat Manifestation**, chose a pure event-driven architecture with mediator topology. This divergence is worth examining.

**MonArch (1st)** took the most pragmatic stance. Their README opens with a Sam Newman quote -- "Microservices are not the goal, you don't win by having microservices" -- and explicitly proposed a **modular monolith as the initial deployment** that could later be decomposed along bounded-context seams. This evolutionary approach (modular monolith to microservices) demonstrated architectural maturity: acknowledging that a non-profit startup does not need distributed systems complexity on day one. They layered hexagonal architecture (ADR02) on top, ensuring each service's internals were structured with ports and adapters for future flexibility.

**IPT (2nd)** combined microservices with strong DDD discipline, using event storming to identify four domain capabilities (Connection, Order, User, Report) that mapped cleanly to service boundaries. Their distinctive contribution was the **Microkernel/Plugin pattern for the Dispatcher service** (ADR04), recognizing that participating businesses would have wildly different integration capabilities -- from REST APIs to phone/fax orders. This was an unusually practical insight.

**Black Cat Manifestation (3rd)** chose event-driven architecture with a **mediator topology** (ADR08), explicitly trading scalability for workflow correctness. Their rationale cited safety requirements: civilians must initiate connections, officers must accept, and these steps must happen in sequence. The mediator ensures this orchestration. They drew inspiration from messaging platforms (WhatsApp, Telegram, Discord) and proposed Elixir's actor model as the implementation foundation -- a technically distinctive and well-reasoned choice for a 2-person team.

Together, the three teams illustrate a spectrum from evolutionary microservices (MonArch), to DDD-aligned microservices with plugin extensibility (IPT), to a fundamentally different event-driven paradigm (Black Cat Manifestation). Each approach was coherent with the team's size, priorities, and view of the domain's core risks.

---

## What Distinguished the Top Teams

### 1. Pragmatism Over Comprehensiveness

The most striking pattern across the placing teams is that **their documentation was focused and architecturally cohesive rather than voluminous**.

- **MonArch** produced 7 ADRs that each addressed architectural decisions directly shaping the system: hexagonal design, CQRS, in-memory graph stores, WebSocket communication. Every ADR connected to a visible component in their C4 diagrams.
- **IPT** produced 8 ADRs including the Microkernel Dispatcher (ADR04) and GDPR compliance (ADR08) -- decisions that shaped the system's character and demonstrated awareness of both technical and regulatory concerns.
- **Black Cat Manifestation** also produced 7 ADRs, each tightly scoped to a genuine trade-off: mediator vs. broker topology, QR codes vs. geolocation, electronic goods only vs. full storefront.

All three teams showed restraint, ensuring that each documented decision carried real architectural weight rather than cataloging routine technology selections.

### 2. Depth on the Hard Problem: Geolocation and Connection Workflow

The connection workflow -- officer goes available, citizen detects proximity, connection is established, points are awarded -- was the kata's central technical challenge. The top teams invested disproportionate attention here:

- **MonArch** provided the deepest technical treatment: a detailed sequence diagram for the full connection workflow, WebSocket-based real-time location streaming, and an **in-memory graph database for O(log n) proximity lookups** (ADR06). They analyzed haversine distance calculations, proposed graph data structures where nodes represent officer geolocations connected by proximity, and discussed the algorithmic tradeoffs between insert cost and lookup speed. This level of specificity was unmatched.
- **IPT** addressed proximity through their Connection Capability service with event-driven handshake orchestration, keeping the flow clean through domain-driven separation.
- **Black Cat Manifestation** took a radically different approach: **QR codes for in-person interactions that bypass geolocation entirely** (ADR06). When an officer does not want to be tracked, a civilian simply scans the officer's QR code. This was a creative solution to the officer-safety tension that no other team proposed as a first-class alternative.

Each team tackled the core problem from a different angle -- algorithmic depth, domain-driven separation, and creative reframing -- but all three demonstrated that they understood where the real architectural risk lay.

### 3. Evolutionary Architecture Thinking

The top teams demonstrated awareness that architecture must evolve:

- **MonArch** explicitly documented the modular monolith as an MVP path, with bounded contexts designed to be extractable into microservices. Their architecture quanta analysis (Figure 9) showed coupling between services, identifying that the system had a quanta of 6 -- evidence of careful coupling analysis.
- **IPT** built evolvability into their ADRs: the BFF pattern (ADR05) allows frontend-specific optimization without backend changes; the read replica pattern (ADR06) supports eventual consistency for reporting; GDPR compliance (ADR08) future-proofs for international expansion.
- **Black Cat Manifestation** designed for evolution by keeping the storefront deliberately simple (electronic goods only, per ADR01), avoiding premature complexity around inventory management and shipping.

### 4. Cost Awareness

As a non-profit project, cost sensitivity was a legitimate architectural driver:

- **MonArch** was the only team to produce **concrete cost estimates**: $2,780/month for 50,000 MAU on GCP, broken down by service (API Gateway $450, Cloud Run $1,000, Cloud SQL $1,260, Pub/Sub $70).
- **IPT** prioritized "Feasibility (cost)" as their top quality attribute and chose Azure partly for its non-profit pricing programs, though they did not provide specific numbers.
- **Black Cat Manifestation** addressed cost implicitly through simplicity: by choosing Elixir's actor model and avoiding cloud-specific infrastructure commitments, they minimized vendor lock-in and operational overhead for a small team.

---

## Common Patterns

### Event Storming as Domain Discovery

All three placing teams used event storming or event-driven scenario analysis to discover bounded contexts. MonArch and IPT applied event storming explicitly, while Black Cat Manifestation used a scenario-based approach that achieved similar results through their Architecture Characteristics Worksheet. The teams that used these techniques produced clean service boundaries -- MonArch's 5 bounded contexts and IPT's 4 domain capabilities both emerged directly from their discovery sessions.

### Points System as a Separate Bounded Context

Every team isolated the rewards/points system into its own service or context. This universal decision reflects the domain's natural seam: points accumulation, redemption, and donation have distinct invariants (balance tracking, idempotent point awards) that differ from connection management or user identity.

### API Gateway as the Entry Point

All three teams placed an API gateway between clients and backend services. MonArch (ADR04) and IPT (Azure API Management) both treated the gateway as a first-class architectural element responsible for routing, rate limiting, and authentication. Black Cat Manifestation's event-driven approach channeled client interactions through a mediator that served a similar gateway function, consolidating entry-point concerns even without a traditional API gateway product.

### Event-Driven Communication for Cross-Service Workflows

Every team recognized that connection events must propagate asynchronously to points, profile updates, analytics, and social media. The specific messaging infrastructure varied (GCP Pub/Sub, Azure Event Hub, abstract event channels), but the pattern was universal: the connection event is the domain's central event, and downstream services subscribe to it.

### Social Media Integration as an Afterthought

No team invested significant architecture in social media integration. MonArch included a Social Media API Manager component; others mentioned it in passing. This was likely a correct prioritization -- social media posting is a solved problem with well-documented APIs -- but it also reflects that teams focused on the harder problems.

---

## Unique Innovations Worth Highlighting

### MonArch: In-Memory Graph Store for Proximity (ADR06)

MonArch's proposal to use a **geolocation-clustered in-memory graph database** for officer proximity lookups was the most technically innovative decision across the placing teams. Rather than brute-force scanning a table of officer locations (O(n)), they proposed a graph where each node represents an officer's geolocation and edges connect nearby officers. Searching for the closest officer to a citizen's location becomes O(log n) by traversing the graph. They identified Redis Graph as a candidate but noted it would need benchmarking against custom implementations. This ADR showed the kind of first-principles algorithmic thinking that distinguishes strong architecture from mere box-drawing.

### IPT: Microkernel Dispatcher for Business Integration (ADR04)

IPT's recognition that participating businesses would range from large chains with REST APIs to small shops that take orders by phone or fax led them to propose a **Microkernel/Plugin architecture for the Dispatcher service**. The core system handles order lifecycle, while each business gets a custom plugin. This was the most empathetic architectural decision -- it centered the experience of small business owners who might otherwise be excluded from the platform.

### Black Cat Manifestation: QR Codes as a Privacy-First Connection Mechanism (ADR06)

By proposing QR codes as the primary mechanism for in-person interactions **without location tracking**, Black Cat Manifestation solved the officer-safety problem more cleanly than any other team. An officer who does not want to be tracked simply displays their QR code; the civilian scans it; the backend validates the interaction. No GPS, no Bluetooth, no background location services. For a 2-person team, the simplicity and elegance of this solution was remarkable.

---

## Lessons for Practitioners

### 1. Start with the Evolutionary End State, Not the Final State

MonArch's modular-monolith-first strategy is a template for greenfield projects at resource-constrained organizations. By designing bounded contexts that *could* become microservices but deploying them as a monolith initially, they avoided the operational overhead of distributed systems while preserving the option to decompose later. The key enabler was hexagonal architecture: because each module's internals were structured with ports and adapters, extraction would not require rewriting business logic.

**Takeaway:** Document the evolutionary path in your ADRs. MonArch's ADR01 and ADR02 together told a story: "Here is where we are going (microservices), here is how we structure each service (hexagonal), and here is where we start (modular monolith)."

### 2. Invest Disproportionately in the Core Domain Problem

The top teams spent the most time on the connection/proximity workflow because it was the highest-risk, highest-uncertainty part of the system. Points redemption, user registration, and reporting are well-understood patterns. Proximity detection with real-time notifications and privacy constraints is not. MonArch's sequence diagrams and graph-store ADR, IPT's domain-driven Connection Capability service, and Black Cat Manifestation's QR code alternative all demonstrate this principle.

**Takeaway:** In any architecture kata or real project, identify the one or two workflows where "if we get this wrong, nothing else matters" and dedicate your deepest analysis there.

### 3. ADR Quality Matters More Than ADR Quantity

MonArch's 7 ADRs each addressed a genuine architectural *decision* with trade-offs, consequences, and connections to the broader design. IPT's 8 ADRs included the Microkernel Dispatcher (ADR04) and GDPR compliance (ADR08) -- decisions that shaped the system's character. Black Cat Manifestation's 7 ADRs each captured a meaningful trade-off where reasonable architects might disagree.

**Takeaway:** An ADR should capture a decision where reasonable architects might disagree. "We will use GitHub for source control" is not an ADR; "We will use a mediator topology rather than a broker topology because workflow correctness outweighs scalability for this domain" is.

### 4. Address the Non-Functional Elephant: Cost

For a non-profit relying on grants, cloud costs are existential. MonArch's concrete GCP pricing breakdown ($2,780/month for 50K MAU) gave stakeholders something tangible to evaluate. IPT's emphasis on Azure non-profit pricing demonstrated cost awareness at the platform-selection level. Black Cat Manifestation's choice of Elixir and minimal cloud infrastructure kept the cost profile lean by design.

**Takeaway:** Even rough cost estimates signal architectural maturity. They force you to confront whether your beautiful microservices architecture is actually viable for a non-profit running on donations.

### 5. Privacy and Compliance Are Architectural Concerns, Not Afterthoughts

Hey Blue! involves tracking police officer locations -- a capability with serious safety and privacy implications. IPT elevated GDPR compliance to a top-level ADR (ADR08), arguing that implementing the strictest standard globally is cheaper than managing a patchwork of U.S. state regulations. Black Cat Manifestation designed QR codes as a privacy-preserving alternative to geolocation. MonArch's catalog notes the absence of GDPR discussion, which illustrates that even a winning team can have gaps -- and that privacy should always be a driving architectural characteristic when your domain involves location tracking of law enforcement.

**Takeaway:** When your domain involves location tracking of law enforcement, privacy is not a nice-to-have. It is a driving architectural characteristic that should appear in your top-3 list.

### 6. Small Teams Can Produce Outsized Results

Black Cat Manifestation placed 3rd with a team of 2. Their output was focused, opinionated, and technically creative. They cited academic research on policing, drew inspiration from real messaging platforms, and made bold simplifying decisions (electronic goods only, QR codes over geolocation). Constraint breeds creativity -- their small team forced them to prioritize ruthlessly, which resulted in a more coherent architecture than many larger teams produce.

**Takeaway:** Team size is not a predictor of architectural quality. Clarity of thought, willingness to make trade-offs explicit, and focus on the hard problems matter more than volume of documentation.
