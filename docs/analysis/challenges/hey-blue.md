# Hey Blue! -- Comparative Analysis

**Challenge:** Hey Blue! -- Fall 2022 O'Reilly Architecture Katas
**Teams Analyzed:** 6
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

| Dimension | MonArch (1st) | IPT (2nd) | Black Cat Manifestation (3rd) | Achievers (Runner-up) | It Depends (Runner-up) | Los Ingenials (Runner-up) |
|---|---|---|---|---|---|---|
| **Team Size** | 3 | 3 | 2 | Unknown | 6 | 5 |
| **Architecture Style** | Microservices + Event-Driven + Hexagonal | Microservices + Event-Driven + DDD | Event-Driven (Mediator Topology) | Microservices | Event-Driven Serverless (Hybrid) | Microservices + Event-Driven + Serverless |
| **Cloud Platform** | Google Cloud (GCP) | Microsoft Azure | None specified (Elixir/Actor model) | AWS (implied) | None specified (Serverless functions) | AWS |
| **ADR Count** | 7 | 8 | 7 | 9 | 16 | 21 |
| **Modeling Approach** | C4 (Context/Container/Component) + Event Storming | Event Storming + Domain Capabilities | Architecture Characteristics Worksheet + Scenarios | Use Cases + Service Decomposition | C4 + Domain Analysis Map + User Story Map | Archimate (Business/Application/Technology) |
| **Cost Analysis** | Yes ($2,780/mo for 50K MAU) | Yes (qualitative feasibility) | Qualitative feasibility only | No | Volumetric analysis (no pricing) | No |
| **GDPR/Privacy** | Not addressed | Dedicated ADR (ADR08) | Officer privacy via QR codes (ADR06) | Not addressed | ADR on minimal PII + officer location protection | GDPR mentioned as constraint |
| **Deployment View** | Yes (GCP-specific) | Yes (Azure-specific) | No | Yes | No | Yes (AWS-specific) |
| **Video Presentation** | No | No | No | No | Yes | No |
| **Unique Differentiator** | In-memory graph for geolocation | Microkernel dispatcher for business integration | Elixir actor model + QR code-first design | Dual API gateway + emergency notification roadmap | Volumetric analysis + "Straight Through Architecture" traceability | W3C social network reference architecture + Team Topologies |

---

## Architecture Style Choices

### The Microservices Consensus -- and Where Teams Diverged

Five of six teams chose microservices as a primary or contributing style. The lone outlier, **Black Cat Manifestation**, chose a pure event-driven architecture with mediator topology. This divergence is worth examining.

**MonArch (1st)** took the most pragmatic stance. Their README opens with a Sam Newman quote -- "Microservices are not the goal, you don't win by having microservices" -- and explicitly proposed a **modular monolith as the initial deployment** that could later be decomposed along bounded-context seams. This evolutionary approach (modular monolith to microservices) demonstrated architectural maturity: acknowledging that a non-profit startup does not need distributed systems complexity on day one. They layered hexagonal architecture (ADR02) on top, ensuring each service's internals were structured with ports and adapters for future flexibility.

**IPT (2nd)** combined microservices with strong DDD discipline, using event storming to identify four domain capabilities (Connection, Order, User, Report) that mapped cleanly to service boundaries. Their distinctive contribution was the **Microkernel/Plugin pattern for the Dispatcher service** (ADR04), recognizing that participating businesses would have wildly different integration capabilities -- from REST APIs to phone/fax orders. This was an unusually practical insight.

**Black Cat Manifestation (3rd)** chose event-driven architecture with a **mediator topology** (ADR08), explicitly trading scalability for workflow correctness. Their rationale cited safety requirements: civilians must initiate connections, officers must accept, and these steps must happen in sequence. The mediator ensures this orchestration. They drew inspiration from messaging platforms (WhatsApp, Telegram, Discord) and proposed Elixir's actor model as the implementation foundation -- a technically distinctive and well-reasoned choice for a 2-person team.

**It Depends** invented a hybrid they called **"Event-Driven Serverless"** (ADR-010), arguing that Hey Blue!'s interaction pattern (occasional bursts during daytime, near-zero overnight) maps perfectly to serverless's scale-to-zero economics. Their analysis was the most methodical: they built a custom comparison matrix scoring 9 architectural styles across their core characteristics, and the hybrid edged out pure serverless and pure event-driven options.

**Los Ingenials** took the most enterprise-oriented approach, combining microservices, event-driven, serverless, and containers on AWS (EKS + Lambda). Their 21 ADRs covered not just technical architecture but also HR tooling, finance/treasury systems, document management, and mailing -- treating Hey Blue! as a full enterprise rather than a startup platform.

---

## What Separated Winners from Runners-Up

### 1. Pragmatism Over Comprehensiveness

The most striking pattern is that **the top 3 teams produced less documentation than some runner-up teams, but it was more focused and architecturally cohesive**.

- **MonArch** (7 ADRs) beat **Los Ingenials** (21 ADRs) and **It Depends** (16 ADRs). MonArch's ADRs addressed architectural decisions that directly shaped the system: hexagonal design, CQRS, in-memory graph stores, WebSocket communication. Every ADR connected to a visible component in their C4 diagrams.
- **Los Ingenials** produced the most voluminous output with full Archimate modeling across business, application, and technology layers, Team Topologies, and ADRs for HR and finance tools. The judges may have viewed this as over-engineering for a non-profit startup -- their own YAML catalog notes "Architecture may be over-engineered for a non-profit startup."
- **It Depends** had the strongest analytical rigor (volumetric analysis, "Straight Through Architecture" traceability), but their own retrospective acknowledged that some documentation appeared rushed.

### 2. Depth on the Hard Problem: Geolocation and Connection Workflow

The connection workflow -- officer goes available, citizen detects proximity, connection is established, points are awarded -- was the kata's central technical challenge. The top teams invested disproportionate attention here:

- **MonArch** provided the deepest technical treatment: a detailed sequence diagram for the full connection workflow, WebSocket-based real-time location streaming, and an **in-memory graph database for O(log n) proximity lookups** (ADR06). They analyzed haversine distance calculations, proposed graph data structures where nodes represent officer geolocations connected by proximity, and discussed the algorithmic tradeoffs between insert cost and lookup speed. This level of specificity was unmatched.
- **IPT** addressed proximity through their Connection Capability service with event-driven handshake orchestration, keeping the flow clean through domain-driven separation.
- **Black Cat Manifestation** took a radically different approach: **QR codes for in-person interactions that bypass geolocation entirely** (ADR06). When an officer does not want to be tracked, a civilian simply scans the officer's QR code. This was a creative solution to the officer-safety tension that no other team proposed as a first-class alternative.

Runner-up teams handled the connection workflow at a higher level of abstraction, often deferring to "proximity detection" without specifying the mechanism.

### 3. Evolutionary Architecture Thinking

The top teams demonstrated awareness that architecture must evolve:

- **MonArch** explicitly documented the modular monolith as an MVP path, with bounded contexts designed to be extractable into microservices. Their architecture quanta analysis (Figure 9) showed coupling between services, identifying that the system had a quanta of 6 -- evidence of careful coupling analysis.
- **IPT** built evolvability into their ADRs: the BFF pattern (ADR05) allows frontend-specific optimization without backend changes; the read replica pattern (ADR06) supports eventual consistency for reporting; GDPR compliance (ADR08) future-proofs for international expansion.
- **Black Cat Manifestation** designed for evolution by keeping the storefront deliberately simple (electronic goods only, per ADR01), avoiding premature complexity around inventory management and shipping.

### 4. Cost Awareness

As a non-profit project, cost sensitivity was a legitimate architectural driver:

- **MonArch** was the only team to produce **concrete cost estimates**: $2,780/month for 50,000 MAU on GCP, broken down by service (API Gateway $450, Cloud Run $1,000, Cloud SQL $1,260, Pub/Sub $70).
- **IPT** prioritized "Feasibility (cost)" as their top quality attribute and chose Azure partly for its non-profit pricing programs, though they did not provide specific numbers.
- **It Depends** produced volumetric analysis (140 TPS connections, 2,800 notifications/second) that would inform capacity planning but did not translate this into dollar estimates.

---

## Common Patterns

### Event Storming as Domain Discovery

Three of six teams (MonArch, IPT, and implicitly Black Cat Manifestation through their scenario analysis) used event storming to discover bounded contexts. This reflects the methodology's dominance as a pre-architecture technique for DDD-aligned systems. The teams that used event storming produced cleaner service boundaries -- MonArch's 5 bounded contexts and IPT's 4 domain capabilities both emerged directly from their storming sessions.

### Points System as a Separate Bounded Context

Every team isolated the rewards/points system into its own service or context. This universal decision reflects the domain's natural seam: points accumulation, redemption, and donation have distinct invariants (balance tracking, idempotent point awards) that differ from connection management or user identity.

### API Gateway as the Entry Point

All six teams placed an API gateway between clients and backend services. MonArch (ADR04), IPT (Azure API Management), Achievers (dual API gateways), and Los Ingenials (AWS API Gateway) all treated the gateway as a first-class architectural element. Achievers uniquely proposed **dual API gateways** -- one for public mobile clients and a separate one for administrative users -- which, while adding operational complexity, demonstrated security-minded thinking about attack surface separation.

### Event-Driven Communication for Cross-Service Workflows

Every team recognized that connection events must propagate asynchronously to points, profile updates, analytics, and social media. The specific messaging infrastructure varied (GCP Pub/Sub, Azure Event Hub, AWS SNS/SQS, abstract event channels), but the pattern was universal: the connection event is the domain's central event, and downstream services subscribe to it.

### Social Media Integration as an Afterthought

No team invested significant architecture in social media integration. MonArch included a Social Media API Manager component; others mentioned it in passing. This was likely a correct prioritization -- social media posting is a solved problem with well-documented APIs -- but it also reflects that teams focused on the harder problems.

---

## Unique Innovations Worth Highlighting

### MonArch: In-Memory Graph Store for Proximity (ADR06)

MonArch's proposal to use a **geolocation-clustered in-memory graph database** for officer proximity lookups was the most technically innovative decision across all six teams. Rather than brute-force scanning a table of officer locations (O(n)), they proposed a graph where each node represents an officer's geolocation and edges connect nearby officers. Searching for the closest officer to a citizen's location becomes O(log n) by traversing the graph. They identified Redis Graph as a candidate but noted it would need benchmarking against custom implementations. This ADR showed the kind of first-principles algorithmic thinking that distinguishes strong architecture from mere box-drawing.

### IPT: Microkernel Dispatcher for Business Integration (ADR04)

IPT's recognition that participating businesses would range from large chains with REST APIs to small shops that take orders by phone or fax led them to propose a **Microkernel/Plugin architecture for the Dispatcher service**. The core system handles order lifecycle, while each business gets a custom plugin. This was the most empathetic architectural decision -- it centered the experience of small business owners who might otherwise be excluded from the platform.

### Black Cat Manifestation: QR Codes as a Privacy-First Connection Mechanism (ADR06)

By proposing QR codes as the primary mechanism for in-person interactions **without location tracking**, Black Cat Manifestation solved the officer-safety problem more cleanly than any other team. An officer who does not want to be tracked simply displays their QR code; the civilian scans it; the backend validates the interaction. No GPS, no Bluetooth, no background location services. For a 2-person team, the simplicity and elegance of this solution was remarkable.

### It Depends: Volumetric Analysis and "Straight Through Architecture"

It Depends was the only team to perform **napkin-math volumetric analysis**, calculating that the system would need to handle 140 connections per second at peak, generate 2,800 notifications per second, and process 60 geolocation refreshes per second. They also introduced "Straight Through Architecture" -- a traceability technique linking requirements through domain analysis to architectural decisions to diagrams. While not a novel concept, their disciplined application of it was rare among kata submissions.

### It Depends: Deliberate Deviation from Requirements for Officer Safety (ADR-013, ADR-014)

It Depends explicitly chose to **deviate from the stated requirements** to protect officer locations. Their ADR-013 ("Provide map design to protect officer location") and ADR-014 ("Provide control functionality to protect officer location") represent a security-first mindset that prioritizes user safety over literal requirement compliance -- a mature architectural judgment.

### Los Ingenials: W3C Social Network Reference Architecture

Los Ingenials grounded their design in the **W3C consortium's social network reference architecture**, adapting it with extensions for commerce and enterprise concerns. This was the only team to cite a formal reference architecture standard. They also applied **Team Topologies** to plan how the development organization would evolve alongside the platform -- starting with a single stream-aligned team and growing to multiple teams with a platform team as complexity increased.

---

## Lessons for Practitioners

### 1. Start with the Evolutionary End State, Not the Final State

MonArch's modular-monolith-first strategy is a template for greenfield projects at resource-constrained organizations. By designing bounded contexts that *could* become microservices but deploying them as a monolith initially, they avoided the operational overhead of distributed systems while preserving the option to decompose later. The key enabler was hexagonal architecture: because each module's internals were structured with ports and adapters, extraction would not require rewriting business logic.

**Takeaway:** Document the evolutionary path in your ADRs. MonArch's ADR01 and ADR02 together told a story: "Here is where we are going (microservices), here is how we structure each service (hexagonal), and here is where we start (modular monolith)."

### 2. Invest Disproportionately in the Core Domain Problem

The top teams spent the most time on the connection/proximity workflow because it was the highest-risk, highest-uncertainty part of the system. Points redemption, user registration, and reporting are well-understood patterns. Proximity detection with real-time notifications and privacy constraints is not. MonArch's sequence diagrams and graph-store ADR, Black Cat Manifestation's QR code alternative, and It Depends' volumetric analysis all demonstrate this principle.

**Takeaway:** In any architecture kata or real project, identify the one or two workflows where "if we get this wrong, nothing else matters" and dedicate your deepest analysis there.

### 3. ADR Quality Matters More Than ADR Quantity

Los Ingenials' 21 ADRs covered everything from cloud provider to HR tooling, but many were straightforward technology selections (GitHub for code, Amazon SES for mailing). MonArch's 7 ADRs each addressed a genuine architectural *decision* with trade-offs, consequences, and connections to the broader design. IPT's 8 ADRs included the Microkernel Dispatcher (ADR04) and GDPR compliance (ADR08) -- decisions that shaped the system's character.

**Takeaway:** An ADR should capture a decision where reasonable architects might disagree. "We will use GitHub for source control" is not an ADR; "We will use a mediator topology rather than a broker topology because workflow correctness outweighs scalability for this domain" is.

### 4. Address the Non-Functional Elephant: Cost

For a non-profit relying on grants, cloud costs are existential. MonArch's concrete GCP pricing breakdown ($2,780/month for 50K MAU) gave stakeholders something tangible to evaluate. It Depends' volumetric analysis provided the throughput basis for capacity planning, even without dollar figures. Teams that ignored cost analysis entirely missed a critical constraint of the problem domain.

**Takeaway:** Even rough cost estimates signal architectural maturity. They force you to confront whether your beautiful microservices architecture is actually viable for a non-profit running on donations.

### 5. Privacy and Compliance Are Architectural Concerns, Not Afterthoughts

Hey Blue! involves tracking police officer locations -- a capability with serious safety and privacy implications. IPT elevated GDPR compliance to a top-level ADR (ADR08), arguing that implementing the strictest standard globally is cheaper than managing a patchwork of U.S. state regulations. Black Cat Manifestation designed QR codes as a privacy-preserving alternative to geolocation. It Depends deliberately deviated from requirements to protect officer locations.

Teams that did not address privacy (MonArch's catalog notes "No GDPR or data privacy compliance discussion"; Achievers similarly) left a gap that judges likely noticed.

**Takeaway:** When your domain involves location tracking of law enforcement, privacy is not a nice-to-have. It is a driving architectural characteristic that should appear in your top-3 list.

### 6. Small Teams Can Produce Outsized Results

Black Cat Manifestation placed 3rd with a team of 2. Their output was focused, opinionated, and technically creative. They cited academic research on policing, drew inspiration from real messaging platforms, and made bold simplifying decisions (electronic goods only, QR codes over geolocation). Constraint breeds creativity -- their small team forced them to prioritize ruthlessly, which resulted in a more coherent architecture than some larger teams produced.

**Takeaway:** Team size is not a predictor of architectural quality. Clarity of thought, willingness to make trade-offs explicit, and focus on the hard problems matter more than volume of documentation.
