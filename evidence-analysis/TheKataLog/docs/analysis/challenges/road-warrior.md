# Road Warrior -- Comparative Analysis

**Challenge**: Fall 2023 External Season | 3 Teams | O'Reilly Architecture Katas

## Challenge Overview

Road Warrior is a next-generation online trip management dashboard for a travel startup targeting 15 million users (2 million active weekly). The system must consolidate traveler reservations from email, travel agency APIs (SABRE, APOLLO), and manual entry into a unified dashboard accessible via web and mobile. Key constraints include 99.99% availability (max 5 minutes unplanned downtime per month), sub-800ms web response times, sub-1.4s mobile first contentful paint, travel updates reflected within 5 minutes, social media sharing, end-of-year reporting, and analytical data collection for monetization. The startup context adds implicit cost sensitivity, evolvability pressure, and time-to-market urgency.

---

## Team Comparison Matrix

| Dimension | Profitero Data Alchemists (1st) | Iconites (2nd) | Flexibility Fertilisers (3rd) |
|---|---|---|---|
| **Architecture Style** | Event-Driven | Microservices + Event-Driven + Space-Based | Microservices + Event-Driven |
| **ADR Count** | 15 | 15 | 9 |
| **Team Size** | 5 | 5 | Not specified |
| **Documentation Framework** | Rozanski/Woods Viewpoints | Custom (Event Storming + Boundary Analysis) | Custom (Workflow-driven) |
| **C4 Diagrams** | Yes (L1-L3) | No | No |
| **Deployment View** | Yes | Yes | No |
| **Video Presentation** | Yes | Yes | Yes |
| **Feasibility/Cost Analysis** | No | Yes (per-MVP costing) | No |
| **UI Mockups** | No | Yes (Figma + hand-drawn) | No |
| **Business Model** | No | Yes (Freemium/Silver/Gold tiers) | No |

---

## Architecture Style Choices

### The Universal Convergence on Event-Driven + Microservices

All three teams converged on event-driven architecture as a central pattern, reflecting the challenge's inherent demands: asynchronous email polling, real-time travel update propagation, notification broadcasting, and analytics event capture all naturally map to event-driven patterns. While they agreed on the general direction, each team carved out a distinct approach within this consensus.

### Notable Variations Within the Consensus

**Profitero Data Alchemists (1st)** chose a pure event-driven architecture rather than a microservices + event-driven hybrid. Their ADR-1 documents a deliberate team discussion where they chose Evolvability over Elasticity as their third top characteristic, reasoning that "as a startup, the ability to adapt to user feedback and market dynamics is paramount." This led them toward event-driven over microservices, valuing the looser coupling and broadcast communication patterns that events enable. They reinforced this with ADR-9 (topics and compacted topics for messaging) and ADR-10 (same partitioning key for topics and tables), showing deep attention to the mechanics of event flow.

**Iconites (2nd)** was the most architecturally ambitious, combining three styles: microservices, event-driven, and space-based architecture. Their ADR-14 justified space-based architecture for "handling data intensive events" with in-memory data grids providing low-latency access and fault tolerance. This triple-style approach addressed scalability (microservices), real-time reactivity (event-driven), and high-performance caching (space-based) simultaneously. They further layered CQRS (ADR-15) on top, separating read and write paths for independent scaling.

**Flexibility Fertilisers (3rd)** took a pragmatic middle path, combining microservices with event-driven patterns without the additional complexity of space-based architecture. Their approach demonstrated that a well-scoped hybrid architecture can be effective when paired with strong judgment about where to invest engineering effort.

---

## What Distinguished the Top Teams

### 1. Comprehensiveness and Structural Rigor of Documentation

Each of the three placing teams demonstrated end-to-end architecture coverage, but from distinctly different angles -- together illustrating that there is no single "right" documentation strategy, only the need for thoroughness.

**Profitero Data Alchemists (1st)** used the Rozanski/Woods Viewpoints and Perspectives framework systematically, producing seven distinct viewpoints (Functional, Context, Operational, Informational, Concurrency, Development, Deployment) plus a Security Perspective. Their concurrency viewpoint, with its three scaling groups (API, Data Readers/Updaters, Messaging) documented in ADR-8, directly addressed how the system would handle 2 million active users. Their development viewpoint covered CI/CD, monorepo strategy (ADR-11), and merge strategy (ADR-12 for GitLab Flow) -- operational concerns that are easy to overlook in a kata setting but critical for real-world delivery.

**Iconites (2nd)** compensated for lacking formal C4 diagrams with exceptional depth in domain discovery (event storming), UI/UX (Figma mockups), and business viability (tiered subscription model with per-MVP cost analysis). They were the only team to produce a concrete cost estimate: their MVP-1 infrastructure would cost $496.95/month on Azure, scaling through four MVP phases. This directly addressed the startup context that could easily be treated as an abstraction.

**Flexibility Fertilisers (3rd)** distinguished themselves through pragmatic scoping. Their ADR-009 on critical infrastructure explicitly identified which system components *deserved* extra investment in availability and elasticity (booking and alerting) versus which did not (analytics, social media). This triage approach demonstrated mature engineering judgment about where to spend limited startup resources.

### 2. Depth of ADR Reasoning

The placing teams used ADRs not just to record choices but to document trade-off reasoning and alternatives considered.

**Profitero Data Alchemists** produced 15 ADRs that form a coherent narrative: ADR-1 (architecture style) flows into ADR-3/4 (sync readers vs async updaters), which connects to ADR-8 (scaling groups), ADR-9 (topics), and ADR-10 (partitioning keys). Each ADR includes positive consequences, negative consequences, and risks -- a consistent structure that enables future architects to understand not just *what* was decided but *why* and *what could go wrong*.

**Iconites** matched with 15 ADRs of their own, covering decisions from CQRS (ADR-15) to email integration strategy (ADR-08) to Reader API separation (ADR-11). Their ADRs connected domain discovery outcomes to concrete architectural decisions, creating a traceable path from business events to service boundaries.

**Flexibility Fertilisers** had 9 ADRs that prioritized clarity and pragmatism. Their critical infrastructure ADR (ADR-009) and email integration ADR (ADR-004) both demonstrated the ability to make sharp trade-off decisions within a startup's resource constraints.

### 3. Addressing the Startup Context

The challenge explicitly stated Road Warrior is a startup. All three placing teams treated this as a real constraint rather than a backdrop, which proved to be a distinguishing factor.

**Iconites** addressed startup economics most directly with their tiered business plan (Freemium/Silver/Gold), 4-phase MVP rollout with cost projections, and explicit acknowledgment that "if the application is not performing well the owners will take a fail-fast approach." They treated feasibility/cost as an implicit architectural characteristic.

**Profitero Data Alchemists** addressed startup concerns through their implementation milestones, from project initiation through MVP, beta testing, feedback integration, API expansion, second mobile platform, and Version 2.0. This practical roadmap showed how their architecture would be *built incrementally* rather than delivered all at once.

**Flexibility Fertilisers** recommended running "a series of prototypes or perhaps a public alpha version that will help with getting real world feedback" before full commitment, explicitly acknowledging the risk of over-engineering before market validation.

---

## Common Patterns

### 1. Email Integration Strategy

All three teams grappled with how to integrate email-based reservation discovery. Two primary approaches emerged:

- **Polling/scraping**: Profitero Data Alchemists integrated with the top three email providers (Gmail, Outlook, iCloud) using periodic polling via IMAP or provider APIs.
- **Forwarding + webhooks**: Flexibility Fertilisers (ADR-004) and Iconites (ADR-08) both supported email forwarding as an alternative, where users set up rules to forward booking emails to a Road Warrior-owned mailbox. Iconites went further with RPA (Power Automate) for a "when email received" trigger. Flexibility Fertilisers offered both approaches: users can either grant email access for automatic scanning or set up forwarding rules.

### 2. Separation of Read and Write Paths

All three teams independently arrived at read/write separation, reflecting the challenge's natural asymmetry between frequent read access (travelers checking dashboards) and less frequent but complex write operations (reservation updates from multiple sources):

- **Profitero Data Alchemists**: Explicit Data Readers (synchronous, ADR-3) and Data Updaters (asynchronous, ADR-4) as separate service categories.
- **Iconites**: DDD with CQRS (ADR-15) for separating command and query responsibilities.
- **Iconites**: Segregation of Core Services and Reader APIs (ADR-11) with Reader APIs deployed closer to users geographically.

### 3. Analytics as a Separate Concern

All three teams treated analytics and reporting as architecturally distinct from the core trip management flow:

- **Flexibility Fertilisers**: Analytics as part of the data analytics system with async communication for archiving (ADR-003).
- **Iconites**: Azure Synapse as a dedicated data warehouse for reporting.
- **Profitero Data Alchemists**: Analytics data captured through event streams, leveraging their event-driven architecture to naturally funnel data into analytical pipelines without impacting core trip management performance.

### 4. API Gateway as Entry Point

All three teams employed an API Gateway pattern as the single entry point for client requests, handling authentication, rate limiting, and request routing. Profitero Data Alchemists documented this in ADR-2, providing a clean separation between client-facing concerns and internal service communication.

---

## Unique Innovations Worth Highlighting

### Profitero Data Alchemists: Partitioning Key Alignment (ADR-10)

A distinctive low-level architectural decision: aligning the partitioning key between Kafka topics and MongoDB tables. This ensures that all updates for the same record land in the same partition, preventing write collisions and enabling the Data Updater microservice to process changes sequentially without cross-partition coordination. This level of detail -- connecting messaging infrastructure to database schema design -- is rare in architecture katas and demonstrates production-level thinking.

### Profitero Data Alchemists: Three Scaling Groups (ADR-8)

Rather than treating the entire system as one scaling unit, the team defined three independent scaling groups: API (user-triggered), Data Readers/Updaters (internally triggered), and Messaging (queue-based, independent processing). Each group can scale based on its own workload characteristics. This granularity allows cost-effective resource allocation -- the messaging group can scale independently during batch processing windows without affecting the API group's latency.

### Iconites: Figma UI Mockups and Business Model

Iconites was the only team to produce actual UI prototypes, progressing from hand-drawn wireframes to Figma interactive designs. They also produced the only business model plan with subscription tiers (Freemium/Silver/Gold) and per-MVP cost estimates with specific Azure pricing. This demonstrated a holistic view of architecture that extends beyond technical diagrams to encompass user experience and financial viability.

### Iconites: Event Storming for Domain Discovery

Iconites used event storming as a formal domain discovery technique, progressing from domain events to commands to bounded contexts. This methodical approach -- documented with virtual whiteboard artifacts showing orange sticky notes for events, blue for commands, and yellow for actors -- produced clearer service boundaries than jumping directly to component identification would have.

---

## Lessons for Practitioners

### 1. Framework Adoption Correlates with Placement

The winning team used Rozanski/Woods Viewpoints and Perspectives, providing systematic coverage of seven distinct architectural viewpoints. Adopting a recognized documentation framework produces more complete and coherent architecture descriptions than ad-hoc structures. The framework provides a checklist of viewpoints that prevents blind spots -- Profitero Data Alchemists' concurrency and development viewpoints, for example, addressed dimensions that are easy to overlook entirely.

### 2. ADR Quality Matters More Than ADR Quantity

Profitero Data Alchemists and Iconites each had 15 ADRs and placed 1st and 2nd. Flexibility Fertilisers had 9 and placed 3rd. The differentiator is not count but coherence: do the ADRs tell a connected story? Do they document alternatives considered, not just the choice made? Profitero Data Alchemists' ADRs chain logically from architecture style through scaling groups to partitioning strategy, forming a narrative that builds cumulatively rather than listing disconnected decisions.

### 3. Address the Business Context, Not Just the Technical Problem

Iconites' Figma mockups, tiered business model, and per-MVP cost analysis directly addressed the startup context. Flexibility Fertilisers' recommendation for prototyping before full commitment showed startup awareness. Treating an architecture challenge as a pure technical exercise -- designing a complete system without addressing how a startup would fund, build, and iterate on it -- misses a key dimension.

### 4. Critical Infrastructure Identification Is an Underrated Skill

Flexibility Fertilisers' ADR-009 on critical infrastructure demonstrates a crucial skill: identifying which parts of the system *actually need* high availability, elasticity, and performance -- and which do not. In a startup with limited resources, not everything can be gold-plated. The ability to triage and prioritize infrastructure investment is arguably more valuable than designing a uniformly sophisticated architecture.

### 5. Concurrency and Scaling Deserve Their Own Viewpoint

Profitero Data Alchemists' dedicated Concurrency Viewpoint, with its three scaling groups and detailed data flow diagrams, was unique among all submissions. The challenge's scale requirements (15M users, 2M active weekly, 5-minute update SLA) demand explicit attention to how the system handles concurrent load, yet it is tempting to address this only implicitly through choices like microservices and Kubernetes. Making concurrency explicit -- with scaling groups, load calculations, and partitioning strategies -- is what separates architecture from hand-waving.

### 6. Event-Driven Architecture Is the Natural Fit for Trip Management

The convergence of all three placing teams on event-driven patterns validates its suitability for systems with asynchronous external integrations (email polling, agency API updates), real-time notification requirements, analytics event capture, and loosely coupled service boundaries. The challenge's requirements -- particularly the 5-minute update SLA and multi-source data aggregation -- naturally lend themselves to event-driven communication, making this a strong default for similar travel and aggregation domains.
