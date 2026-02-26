# Road Warrior -- Comparative Analysis

**Challenge**: Fall 2023 External Season | 9 Teams | O'Reilly Architecture Katas

## Challenge Overview

Road Warrior is a next-generation online trip management dashboard for a travel startup targeting 15 million users (2 million active weekly). The system must consolidate traveler reservations from email, travel agency APIs (SABRE, APOLLO), and manual entry into a unified dashboard accessible via web and mobile. Key constraints include 99.99% availability (max 5 minutes unplanned downtime per month), sub-800ms web response times, sub-1.4s mobile first contentful paint, travel updates reflected within 5 minutes, social media sharing, end-of-year reporting, and analytical data collection for monetization. The startup context adds implicit cost sensitivity, evolvability pressure, and time-to-market urgency.

---

## Team Comparison Matrix

| Dimension | Profitero Data Alchemists (1st) | Iconites (2nd) | Flexibility Fertilisers (3rd) | ArchEnemies | Byte Me | Cloudeneers | Magenta Force | Street Fighters | Worried Warriors |
|---|---|---|---|---|---|---|---|---|---|
| **Architecture Style** | Event-Driven | Microservices + Event-Driven + Space-Based | Microservices + Event-Driven | Microservices + Event-Driven | Microservices + Event-Driven | Microservices + Event-Driven | Microservices + Event-Driven | Microservices + Event-Driven (Hybrid) | Service-Based |
| **ADR Count** | 15 | 15 | 9 | 8 | 7 | 10 | 5 | 16 | 4 |
| **Team Size** | 5 | 5 | Not specified | 5 | 5 | 5 | 5 | 5 | 3 |
| **Documentation Framework** | Rozanski/Woods Viewpoints | Custom (Event Storming + Boundary Analysis) | Custom (Workflow-driven) | Actor/Action + C4 | arc42 + SAD methodology | arc42-inspired | arc42 | Quantum analysis | TOGAF-aligned + ISO 25010 |
| **C4 Diagrams** | Yes (L1-L3) | No | No | Yes (L1-L3, 6 components) | No | No | Yes (L1-L3, interactive HTML) | No | No |
| **Deployment View** | Yes | Yes | No | Yes | Yes | No | Yes | Yes | No |
| **Video Presentation** | Yes | Yes | Yes | Yes | Yes | Yes | No | No | No |
| **Feasibility/Cost Analysis** | No | Yes (per-MVP costing) | No | No | No | No | No | No | No |
| **UI Mockups** | No | Yes (Figma + hand-drawn) | No | No | No | No | No | No | No |
| **Business Model** | No | Yes (Freemium/Silver/Gold tiers) | No | No | No | No | No | No | No |

---

## Architecture Style Choices

### The Universal Convergence on Event-Driven + Microservices

Eight of nine teams converged on some form of event-driven architecture combined with microservices. This near-unanimity reflects the challenge's inherent demands: asynchronous email polling, real-time travel update propagation, notification broadcasting, and analytics event capture all naturally map to event-driven patterns. The only dissenter was **Worried Warriors**, who chose a **service-based architecture** -- a deliberate trade-off for startup pragmatism.

### Notable Variations Within the Consensus

**Profitero Data Alchemists (1st)** chose a pure event-driven architecture rather than a microservices + event-driven hybrid. Their ADR-1 documents a deliberate team discussion where they chose Evolvability over Elasticity as their third top characteristic, reasoning that "as a startup, the ability to adapt to user feedback and market dynamics is paramount." This led them toward event-driven over microservices, valuing the looser coupling and broadcast communication patterns that events enable. They reinforced this with ADR-9 (topics and compacted topics for messaging) and ADR-10 (same partitioning key for topics and tables), showing deep attention to the mechanics of event flow.

**Iconites (2nd)** was the most architecturally ambitious, combining three styles: microservices, event-driven, and space-based architecture. Their ADR-14 justified space-based architecture for "handling data intensive events" with in-memory data grids providing low-latency access and fault tolerance. This triple-style approach addressed scalability (microservices), real-time reactivity (event-driven), and high-performance caching (space-based) simultaneously. They further layered CQRS (ADR-15) on top, separating read and write paths for independent scaling.

**Worried Warriors** stands apart by choosing service-based architecture (ADR-0001). Their reasoning was explicit: "this architecture style is coarse-grained and based on this is more simple and lower costs, but allows to be flexible to further split the services." As the smallest team (3 members), they pragmatically acknowledged that microservices would be "very cost intensive" and "not simple to build, operate, and maintain" for a startup. They positioned service-based as a stepping stone that "can be developed into microservice architectures independently per domain."

**ArchEnemies** uniquely documented a *rejected* architecture in ADR-0001: they evaluated space-based architecture and explicitly rejected it, reasoning that "our system warrants fault tolerance over elasticity" and that space-based does not align with the event-based nature of the system. This negative ADR demonstrates mature architectural reasoning.

---

## What Separated Winners from Runners-Up

### 1. Comprehensiveness and Structural Rigor of Documentation

The top three teams all demonstrated end-to-end coverage of the architecture from multiple angles, while runners-up often excelled in one dimension but left gaps.

**Profitero Data Alchemists (1st)** used the Rozanski/Woods Viewpoints and Perspectives framework systematically, producing seven distinct viewpoints (Functional, Context, Operational, Informational, Concurrency, Development, Deployment) plus a Security Perspective. No other team achieved this breadth. Their concurrency viewpoint, with its three scaling groups (API, Data Readers/Updaters, Messaging) documented in ADR-8, directly addressed how the system would handle 2 million active users. Their development viewpoint covered CI/CD, monorepo strategy (ADR-11), and merge strategy (ADR-12 for GitLab Flow) -- operational concerns most teams ignored entirely.

**Iconites (2nd)** compensated for lacking formal C4 diagrams with exceptional depth in domain discovery (event storming), UI/UX (Figma mockups), and business viability (tiered subscription model with per-MVP cost analysis). They were the only team to produce a concrete cost estimate: their MVP-1 infrastructure would cost $496.95/month on Azure, scaling through four MVP phases. This directly addressed the startup context that other teams treated abstractly.

**Flexibility Fertilisers (3rd)** distinguished themselves through pragmatic scoping. Their ADR-009 on critical infrastructure explicitly identified which system components *deserved* extra investment in availability and elasticity (booking and alerting) versus which did not (analytics, social media). This triage approach demonstrated mature engineering judgment about where to spend limited startup resources.

### 2. Depth of ADR Reasoning

Top teams used ADRs not just to record choices but to document trade-off reasoning and alternatives considered.

**Profitero Data Alchemists** produced 15 ADRs that form a coherent narrative: ADR-1 (architecture style) flows into ADR-3/4 (sync readers vs async updaters), which connects to ADR-8 (scaling groups), ADR-9 (topics), and ADR-10 (partitioning keys). Each ADR includes positive consequences, negative consequences, and risks -- a consistent structure that enables future architects to understand not just *what* was decided but *why* and *what could go wrong*.

**Street Fighters** had the most ADRs (16) of any team, covering concerns others missed entirely: GDPR compliance, monitoring/observability, server-sent events for real-time push, and mail polling mechanics. Their GDPR ADR is notably comprehensive, addressing data classification, consent management, encryption, data portability, retention policies, breach notification, privacy by design, and DPO designation. However, despite this ADR depth, they placed as a runner-up -- suggesting that breadth of ADR coverage alone is insufficient without equally strong system-level coherence.

**Worried Warriors** had only 4 ADRs but made each one count. Their architecture pattern ADR evaluated three concrete options (modular monolith, microservices, service-based) with explicit pros and cons for each, making the trade-off transparent. Quality over quantity.

### 3. Addressing the Startup Context

The challenge explicitly stated Road Warrior is a startup. Teams that treated this as a real constraint -- not just a backdrop -- tended to place higher.

**Iconites** addressed startup economics most directly with their tiered business plan (Freemium/Silver/Gold), 4-phase MVP rollout with cost projections, and explicit acknowledgment that "if the application is not performing well the owners will take a fail-fast approach." They treated feasibility/cost as an implicit architectural characteristic.

**Profitero Data Alchemists** addressed startup concerns through their implementation milestones, from project initiation through MVP, beta testing, feedback integration, API expansion, second mobile platform, and Version 2.0. This practical roadmap showed how their architecture would be *built incrementally* rather than delivered all at once.

**Flexibility Fertilisers** recommended running "a series of prototypes or perhaps a public alpha version that will help with getting real world feedback" before full commitment, explicitly acknowledging the risk of over-engineering before market validation.

---

## Common Patterns

### 1. Email Integration Strategy

Every team grappled with how to integrate email-based reservation discovery. Two primary approaches emerged:

- **Polling/scraping**: Most teams defaulted to periodic polling of user email accounts via IMAP or provider APIs. Profitero Data Alchemists integrated with the top three email providers (Gmail, Outlook, iCloud). Street Fighters dedicated ADR-16 to mail polling mechanics.
- **Forwarding + webhooks**: Flexibility Fertilisers (ADR-004) and Iconites (ADR-08) both supported email forwarding as an alternative, where users set up rules to forward booking emails to a Road Warrior-owned mailbox. Iconites went further with RPA (Power Automate) for a "when email received" trigger. Flexibility Fertilisers offered both approaches: users can either grant email access for automatic scanning or set up forwarding rules.

### 2. Separation of Read and Write Paths

Multiple teams independently arrived at read/write separation:

- **Profitero Data Alchemists**: Explicit Data Readers (synchronous, ADR-3) and Data Updaters (asynchronous, ADR-4) as separate service categories.
- **Iconites**: DDD with CQRS (ADR-15) for separating command and query responsibilities.
- **Street Fighters**: CQRS with an in-memory database layer to "hide eventual consistency" and a dedicated Reservation Collector for reads versus Reservation Manager for writes.
- **Iconites**: Segregation of Core Services and Reader APIs (ADR-11) with Reader APIs deployed closer to users geographically.

### 3. Analytics as a Separate Concern

All teams treated analytics and reporting as architecturally distinct from the core trip management flow:

- **ArchEnemies**: Dedicated analytics storage (ADR-0003), separate Analytics Generator and Analytics Exporter components (ADR-0005, ADR-0006).
- **Flexibility Fertilisers**: Analytics as part of the data analytics system with async communication for archiving (ADR-003).
- **Street Fighters**: OLAP database for analytics (ADR-11), separate from operational data stores.
- **Iconites**: Azure Synapse as a dedicated data warehouse for reporting.

### 4. API Gateway as Entry Point

Seven of nine teams employed an API Gateway pattern as the single entry point for client requests, handling authentication, rate limiting, and request routing. Profitero Data Alchemists documented this in ADR-2, ArchEnemies used it with CDN caching, and Byte Me dedicated ADR-002 to the decision.

### 5. Kubernetes as the Deployment Platform

Kubernetes appeared in the technology stacks of at least six teams (Profitero Data Alchemists, Iconites, Byte Me, Cloudeneers, Magenta Force, Street Fighters). It was valued for auto-scaling, service discovery, and container orchestration -- directly supporting the elasticity and availability requirements.

---

## Unique Innovations Worth Highlighting

### Profitero Data Alchemists: Partitioning Key Alignment (ADR-10)

A distinctive low-level architectural decision: aligning the partitioning key between Kafka topics and MongoDB tables. This ensures that all updates for the same record land in the same partition, preventing write collisions and enabling the Data Updater microservice to process changes sequentially without cross-partition coordination. This level of detail -- connecting messaging infrastructure to database schema design -- is rare in architecture katas and demonstrates production-level thinking.

### Profitero Data Alchemists: Three Scaling Groups (ADR-8)

Rather than treating the entire system as one scaling unit, the team defined three independent scaling groups: API (user-triggered), Data Readers/Updaters (internally triggered), and Messaging (queue-based, independent processing). Each group can scale based on its own workload characteristics. This granularity allows cost-effective resource allocation -- the messaging group can scale independently during batch processing windows without affecting the API group's latency.

### Iconites: Figma UI Mockups and Business Model

Iconites was the only team to produce actual UI prototypes, progressing from hand-drawn wireframes to Figma interactive designs. They also produced the only business model plan with subscription tiers (Freemium/Silver/Gold) and per-MVP cost estimates with specific Azure pricing. This demonstrated a holistic view of architecture that extends beyond technical diagrams to encompass user experience and financial viability.

### Iconites: Event Storming for Domain Discovery

Iconites used event storming as a formal domain discovery technique, progressing from domain events to commands to bounded contexts. This methodical approach -- documented with virtual whiteboard artifacts showing orange sticky notes for events, blue for commands, and yellow for actors -- produced clearer service boundaries than teams that jumped directly to component identification.

### ArchEnemies: Dual-Speed Booking Tracker (ADR-0007)

ArchEnemies designed an efficiency-oriented booking tracking algorithm with two modes: "Near Real-Time Update" for bookings with imminent expiration dates, and "Batch Update" for periodic full refreshes of all events. This directly addresses the cost challenge of polling travel APIs for 15 million users' active reservations -- you cannot poll everything every 5 minutes economically, so you prioritize based on temporal proximity to travel dates.

### ArchEnemies: Architectural Fitness Functions

ArchEnemies was the only team to explicitly define architectural fitness functions -- automated tests that verify the system continues to meet its architecture characteristics over time. They specified concrete fitness functions for responsiveness (measuring 800ms/1.4s thresholds), fault tolerance (5-minute monthly downtime limit), and performance (5-minute update propagation). They recommended embedding these into the DevOps pipeline as executable tests.

### Street Fighters: Quantitative Load Analysis

Street Fighters performed the most rigorous load calculations of any team. They estimated: 25 user requests/second during peak hours, approximately 1,000 reservation update events/second, and approximately 4,000 email filtering requests/second (assuming 30% user opt-in for mailbox scanning with 100 emails/day per user). These concrete numbers informed their quantum-level architecture decisions and justified their CQRS and specialized database choices.

### Street Fighters: 5 Architectural Quanta with Per-Quantum Characteristics

Street Fighters identified five distinct quanta (User Agent, Reservations Orchestrator, Travel Updates Receiver, Email Receiver, Analytics Capture), each with independently identified top characteristics. For example, the Email Receiver quantum prioritized Performance and Scalability (due to the volume of emails to filter), while the Reservations Orchestrator prioritized Data Consistency and Availability. This quantum-level characteristic analysis enables targeted architectural decisions per subsystem.

### Magenta Force: Interactive C4 HTML Diagrams

Magenta Force produced interactive C4 diagrams viewable as HTML pages, allowing readers to zoom into architecture layers dynamically. They also mapped use cases to domains in a traceability matrix and applied strategic domain design principles (Core/Generic/Supportive domain classification), and implemented a Zero Trust security concept.

### Worried Warriors: Explicit Trade-Off Documentation

Worried Warriors produced the most transparent trade-off analysis: simplicity vs. elasticity, time-to-market vs. global reach, and startup experience constraints vs. architecture ambition. They also applied ISO 25010 quality requirements and TOGAF-aligned architecture principles, demonstrating that formal frameworks can be applied even with a 3-person team tackling a startup scenario.

---

## Lessons for Practitioners

### 1. Framework Adoption Correlates with Placement

The winning team used Rozanski/Woods Viewpoints and Perspectives; the runners-up Magenta Force and Byte Me used arc42; Worried Warriors used TOGAF/ISO 25010. Teams that adopted a recognized documentation framework produced more complete and coherent architecture descriptions than those using ad-hoc structures. The framework provides a checklist of viewpoints that prevents blind spots -- Profitero Data Alchemists' concurrency and development viewpoints, for example, addressed dimensions that most teams overlooked entirely.

### 2. ADR Quality Matters More Than ADR Quantity

Street Fighters had the most ADRs (16) but placed as a runner-up. Profitero Data Alchemists and Iconites each had 15 and placed 1st and 2nd. Worried Warriors had only 4 but produced sharply reasoned trade-off analysis. The differentiator is not count but coherence: do the ADRs tell a connected story? Do they document alternatives considered, not just the choice made? Profitero Data Alchemists' ADRs chain logically from architecture style through scaling groups to partitioning strategy. Street Fighters' ADRs, while individually strong, lack this narrative thread.

### 3. Address the Business Context, Not Just the Technical Problem

Iconites' Figma mockups, tiered business model, and per-MVP cost analysis directly addressed the startup context. Flexibility Fertilisers' recommendation for prototyping before full commitment showed startup awareness. Teams that treated the challenge as a pure technical exercise -- designing a complete microservices architecture without addressing how a startup would fund, build, and iterate on it -- missed a key dimension that judges clearly valued.

### 4. Critical Infrastructure Identification Is an Underrated Skill

Flexibility Fertilisers' ADR-009 on critical infrastructure and ArchEnemies' dual-speed booking tracker both demonstrate a crucial skill: identifying which parts of the system *actually need* high availability, elasticity, and performance -- and which do not. In a startup with limited resources, not everything can be gold-plated. The ability to triage and prioritize infrastructure investment is arguably more valuable than designing a uniformly sophisticated architecture.

### 5. Concurrency and Scaling Deserve Their Own Viewpoint

Profitero Data Alchemists' dedicated Concurrency Viewpoint, with its three scaling groups and detailed data flow diagrams, was unique among all submissions. Street Fighters' quantitative load analysis served a similar purpose. The challenge's scale requirements (15M users, 2M active weekly, 5-minute update SLA) demand explicit attention to how the system handles concurrent load, yet most teams addressed this only implicitly through their choice of microservices and Kubernetes. Making concurrency explicit -- with scaling groups, load calculations, and partitioning strategies -- is what separates architecture from hand-waving.

### 6. Event-Driven Architecture Is the Natural Fit for Trip Management

The near-universal convergence on event-driven patterns validates its suitability for systems with asynchronous external integrations (email polling, agency API updates), real-time notification requirements, analytics event capture, and loosely coupled service boundaries. The one team that chose differently (Worried Warriors with service-based) did so deliberately as a startup trade-off, with an explicit path toward event-driven patterns as the system matures.

### 7. Negative ADRs Are Valuable

ArchEnemies' rejection of space-based architecture (ADR-0001) provides as much architectural insight as their positive decisions. Documenting *why* an approach was rejected -- in this case, prioritizing fault tolerance over elasticity and noting misalignment with event-driven patterns -- prevents future team members from re-litigating settled decisions and captures institutional reasoning that would otherwise be lost.
