# Spotlight Platform -- Comparative Analysis

O'Reilly Architecture Katas, Spring 2022 Season | 8 Teams

---

## Challenge Overview

The Spotlight Platform kata asked teams to design a centralized platform for the **Diversity Cyber Council**, a 501(c)(3) non-profit serving underrepresented demographics in the tech industry. The platform needed to connect candidates with non-profit organizations offering training, mentoring, and career services to build a diverse talent pipeline.

The core problem statements were twofold:

1. **Decentralization gap**: Non-profits operate in isolation, creating gaps in service and overall impact.
2. **Visibility barrier**: The lack of a centralized directory prevents underrepresented candidates from discovering available support services.

Hard requirements included end-user ease of use, candidate progress tracking, and engagement tracking. The platform needed to support rich content (text, links, PDFs), automatic matching of candidates to non-profit offerings, and both operational and analytical reporting.

This challenge was distinctive because it asked teams to design for a non-profit context, where cost sensitivity, feasibility, and the technical literacy of end users were first-order architectural concerns rather than afterthoughts.

---

## Team Comparison Matrix

| Team | Placement | Architecture Style | ADR Count | Team Size | Key Differentiator |
|------|-----------|-------------------|-----------|-----------|-------------------|
| **PegasuZ** | 1st | Modular Monolith (MVP) evolving to Microservices + Event-Driven | 12 | 5 | Evolutionary architecture with phased roadmap; architectural quantum decomposition; design thinking with golden paths; feasibility analysis |
| **The Marmots** | 2nd | Microservices | 19 | 4 | Highest ADR count across all teams; methodical worksheet-based architecture selection; detailed scalability analysis with market sizing |
| **TheGlobalVariables** | 3rd | Serverless Microservices + Event-Driven (AWS) | 6 | N/A | Deep AWS serverless commitment; per-user cost analysis ($0.002/user/month); C4 diagrams; value stream mappings; UI wireframes |
| **Arch8s** | Runner-up | Hybrid: Modular Monolith + Service-Based + Serverless | 17 | 3 | Full C4 hierarchy via Structurizr DSL; zero-trust security; event storming; RAID log; 12-factor principles |
| **Goal Diggers** | Runner-up | Cell-Based + Microservices + Event-Driven + Hexagonal + CQRS + Space-Based | 14 | 3 | Most advanced pattern vocabulary; cell-based architecture; DDD with 8+ subdomains; Scale Cube deployment model |
| **Kamikaze Slayers** | Runner-up | Microservices + Event-Driven | 8 | 3 | Detailed per-subsystem cost breakdown ($1,813/month); quantified NFRs (100K RPM, 99.9% availability); gamification features; CDC pattern |
| **Shokunin** | Runner-up | Microservices + DDD | 6 | N/A | Strongest DDD purist approach; ubiquitous language; rich personas; federated GraphQL; anti-corruption layer patterns (explicitly incomplete) |
| **WrightStuffNJ** | Runner-up | Service-Based + Event-Driven + Workflow-Driven | 11 | N/A | IVR system for phoneless candidates; Neo4j graph database; workflow engine; WCAG 2.1 accessibility; marketing automation; test plan |

---

## Architecture Style Choices

### The Spectrum: Pragmatic Phasing vs. Pattern Maximalism

The eight teams spanned a wide spectrum of architectural ambition. At one end, PegasuZ (1st) deliberately started with a **modular monolith for MVP** and planned a migration to microservices + event-driven only after product-market fit (ADR 007). At the other end, Goal Diggers (Runner-up) layered six named patterns -- cell-based, microservices, event-driven, hexagonal, CQRS, and space-based -- into a single proposal.

The top three finishers shared a critical trait: they **justified their architectural style in terms of the non-profit's constraints** rather than defaulting to the most technically sophisticated option.

### Microservices as Baseline

Six of eight teams chose microservices as their primary or eventual architectural style. The exceptions were PegasuZ (modular monolith for MVP) and Arch8s (hybrid approach). This consensus reflects the kata's emphasis on scalability, extensibility, and independent deployability, but the winning teams differentiated themselves by explaining *when* to adopt microservices rather than assuming them from day one.

### Event-Driven as a Common Companion

Five teams explicitly incorporated event-driven architecture: PegasuZ (long-term), TheGlobalVariables, Goal Diggers, Kamikaze Slayers, and WrightStuffNJ. PegasuZ's ADR 010 on message queues vs. event streams is noteworthy -- they chose event streams over message queues specifically because Spotlight's use cases required multi-consumer delivery (e.g., a `candidate_assignment_updated` event consumed by both the candidate service and the analytics pipeline).

### Serverless: Bold Bet by TheGlobalVariables

TheGlobalVariables (3rd) made the most decisive infrastructure commitment, going all-in on AWS serverless (Lambda, DynamoDB, Amplify, AppSync, Cognito, SageMaker). Their ADR 0001 contains a sophisticated analysis of vendor lock-in, framing it as `(Cost of Change) x (Likelihood of Change)` and arguing that the operational savings of serverless outweigh the theoretical portability of containerized open-source alternatives. This was persuasive to judges because it was **directly aligned with the non-profit's cost constraints**.

PegasuZ took a more balanced approach in ADR 006, proposing containers for high-availability services and serverless for less-critical ones, acknowledging different deployment strategies per architectural quantum.

### Unique Pattern Choices

- **Cell-Based Architecture** (Goal Diggers, ADR 001): The only team to use this pattern, mapping cells to DDD bounded contexts. While theoretically strong, several of their ADRs (Blobstore, OAuth, BFF, CQRS, MicroFrontend) remained marked as "TO DO," suggesting the breadth of patterns outpaced their ability to deliver depth.
- **Graph Database** (Wright-Stuff ADR 0005, Goal Diggers ADR 007): Two teams selected graph databases. Wright-Stuff's choice of Neo4j was particularly well-reasoned -- they argued that the relationship-first nature of graph databases was a natural fit for mapping candidates to offerings, providers to services, and generating analytical reports from interconnected data.
- **Workflow Engine** (Wright-Stuff): The only team to include AWS Step Functions and Simple Workflow Service for managing candidate onboarding, making workflow a first-class architectural concern.
- **Federated GraphQL** (Shokunin): The only team to propose federated GraphQL as the integration backbone, enabling each domain to expose a subgraph while presenting a unified API to the frontend.

---

## What Separated Winners from Runners-Up

### 1. Feasibility Thinking and Non-Profit Empathy

The single clearest differentiator between the top three and the runners-up was **explicit engagement with the non-profit's constraints**. PegasuZ, The Marmots, and TheGlobalVariables all demonstrated that they understood they were designing for an organization with limited funding, volunteer staff, and non-technical end users.

- **PegasuZ** (1st) conducted a feasibility analysis examining funding viability, market adoption, and the risks of green-field development. Their requirement analysis document traced every business requirement to specific NFRs with rationale. They explicitly asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" This led directly to their modular monolith MVP decision.
- **TheGlobalVariables** (3rd) produced the most granular cost analysis, calculating per-user costs as low as $0.002/month and the architectural minimum footprint at under $100/month. They also analyzed operational costs, noting that serverless eliminates the burden of OS/server maintenance while acknowledging the higher cost of rare incident response for specialized skills.
- **Kamikaze Slayers** (Runner-up) also produced a cost analysis ($1,813/month with reserved instances), but it was more of a traditional infrastructure costing exercise rather than a strategic argument for why the architecture suited a non-profit.

### 2. Evolutionary Roadmaps

Top teams presented clear **phased roadmaps** rather than a single target-state architecture:

- **PegasuZ** (1st) defined an explicit MVP scope (modular monolith with core NP-Candidate quantum, BFF, documents, chat, notifications, meetings, basic reports and recommendations) and a long-term vision (microservices migration, advanced analytics with model training, NPO integrations). This demonstrated architectural maturity -- the understanding that architecture is a journey, not a destination.
- **The Marmots** (2nd) documented a future roadmap including AI-enhanced matching, group sharing, and trials/samples from non-profits, but their architecture was already microservices from day one without a phased migration path.

Runners-up like Goal Diggers and Arch8s had roadmap sections, but they were less developed. Goal Diggers noted a backlog including bot integration, but key ADRs remained unwritten.

### 3. User Experience and Design Thinking

- **PegasuZ** (1st) conducted a full **design thinking exercise** with candidate and non-profit personas, producing golden paths for both user types with accompanying video walkthroughs. This was a direct response to the "ease of use" hard requirement and demonstrated that architecture starts with understanding users, not choosing patterns.
- **Shokunin** (Runner-up) created the richest **personas** (Kobe the facilitator, Janine the lifelong-learner) with compelling backstories that humanized the problem. Their user stories were explicitly tied to domain capabilities (engagement, discovery, matching, growth, reward). However, their submission was incomplete due to personal circumstances.
- **TheGlobalVariables** (3rd) included **UI wireframes** for six key screens and **value stream mappings** for candidate registration, non-profit registration, and user data purging -- grounding abstract architecture in concrete user interactions.

### 4. Depth vs. Breadth of ADRs

ADR count alone did not predict placement. The Marmots had 19 ADRs (most of any team) and placed 2nd. Arch8s had 17 ADRs and was a runner-up. What mattered was **ADR quality and completeness**:

- **PegasuZ** (1st, 12 ADRs) used a consistent PrOACT decision framework across ADRs, with clear alternatives, trade-off tables, and mitigation strategies. Every ADR was complete with status, context, decision, and consequences.
- **The Marmots** (2nd, 19 ADRs) covered granular decisions (DB read replication, analytics queue, forum storage, notification persistence) with a consistent positive/negative/risk structure.
- **Goal Diggers** (Runner-up, 14 ADRs) had 5 of 14 ADRs marked as "TO DO," undermining the completeness of their submission despite the ambitious pattern vocabulary.

### 5. Quantified Architectural Characteristics

Teams that quantified their quality attributes stood out:

- **PegasuZ** (1st) defined specific availability targets: 3 nines for non-critical quanta (reporting/analytics) and 4 nines for critical quanta (notifications), with explicit justification for why 5 nines was unreasonable for a non-profit platform.
- **Kamikaze Slayers** (Runner-up) specified 100K RPM, 99.9% availability, 2-second search response, and 5-second page load targets.
- **TheGlobalVariables** (3rd) tied responsiveness to the **Doherty Threshold** (400ms), providing a concrete, research-backed target for user experience.

---

## Common Patterns

### Patterns Shared Across Most or All Teams

1. **Backend for Frontend (BFF)**: PegasuZ (ADR 004), The Marmots, Goal Diggers (ADR 012, TODO), Shokunin, and Wright-Stuff all adopted BFF. PegasuZ's BFF ADR was the most detailed, choosing GraphQL for the BFF layer to solve over-fetching/under-fetching while keeping REST for external integrations.

2. **Notification and Messaging**: Every team included a notification subsystem. Approaches varied from AWS SNS (Wright-Stuff) to dedicated notification queues (Marmots, ADR: NotifyQueues) to event streams (PegasuZ, ADR 010).

3. **Analytics and Reporting**: All teams addressed the operational and analytical reporting requirement. TheGlobalVariables proposed AWS SageMaker for ML-based predictions. Kamikaze Slayers designed a dedicated analytics subsystem with AWS Redshift. PegasuZ planned for a separate Reports quantum with a roadmap from basic reporting (MVP) to advanced predictive analytics (long-term).

4. **Identity and Authentication**: AWS Cognito appeared in four teams (TheGlobalVariables, Arch8s, Wright-Stuff, Kamikaze Slayers). PegasuZ documented a general IdP decision (ADR 009). The Marmots designed a dedicated auth DB with RBAC (ADR: RBACinAUTH).

5. **Architecture Styles Worksheet**: At least four teams (The Marmots, TheGlobalVariables, Arch8s, Wright-Stuff) used Mark Richards' Architecture Styles Worksheet to justify their style choice, reflecting the strong influence of the *Fundamentals of Software Architecture* textbook on kata participants.

6. **Search Capability**: Multiple teams invested in search. Kamikaze Slayers and Shokunin both chose ElasticSearch. The Marmots designed a search query service with caching. Shokunin proposed federated GraphQL as a search/discovery mechanism.

### Problem Decomposition Approaches

Teams used different decomposition strategies:
- **Architectural quanta** (PegasuZ): 8 quanta identified through event storming + actor-action analysis
- **DDD bounded contexts** (Shokunin, Goal Diggers, Arch8s): Domain-driven decomposition into Non-profits, Candidates, Matching, Insights, Activities
- **Subsystem views** (Kamikaze Slayers): 7 subsystems with dedicated architectural views per component
- **Layered capability decomposition** (The Marmots): Frontend, infrastructure abstraction, route handlers, backend microservices

---

## Unique Innovations Worth Highlighting

### PegasuZ (1st): Architectural Quantum Identification

PegasuZ's most distinctive contribution was their systematic identification of **architectural quanta** -- independently deployable units with high functional cohesion. Using a combination of event storming and actor-action analysis, they identified 8 quanta (NP-Candidate, Reports, Notification, Recommendations, Chat, Meetings, Document, NPO Integrations) and 3 shared services (Infrastructure, Support, BFF). Each quantum was documented with its own architectural characteristics, allowing different availability targets and deployment strategies per quantum. This approach, drawn from Neal Ford, Mark Richards, and Pramod Sadalage's work, was applied more rigorously here than by any other team.

### PegasuZ (1st): Build vs. Buy Decision Framework

ADR 003 articulated a clear decision framework for green-field projects: evaluate each capability against six factors (proximity to core value proposition, competitive advantage, simplicity, time-to-market, team competency, cost). The decision to buy auth, document storage, chat, and notifications while building core matching and workflow capabilities was pragmatic and well-reasoned for a non-profit context.

### TheGlobalVariables (3rd): Lock-In Cost Formula

Their ADR 0001 introduced the formula `(Cost of Change) x (Likelihood of Change)` as a framework for evaluating vendor lock-in. Rather than treating lock-in as a binary risk, they quantified it as a probability-weighted cost -- and argued that for a non-profit with limited resources, the opportunity cost of building for portability exceeded the expected cost of a future migration.

### TheGlobalVariables (3rd): Value Stream Mapping

TheGlobalVariables was the only team to use **value stream mappings** (VSMs) for key processes (candidate registration, non-profit registration, user data purging). This lean-inspired technique grounded their architecture in concrete operational flows rather than abstract component diagrams.

### Wright-Stuff: IVR System for Accessibility

Wright-Stuff's most innovative decision was including an **Interactive Voice Response (IVR) system** (ADR 0001) to serve candidates who lack access to a smartphone or computer. Citing Pew Research data on the digital divide, they designed a phone-based interface using AWS Connect that could deliver provider lists, schedules, and contact information. They also specified **WCAG 2.1** compliance for web interfaces. No other team addressed accessibility with this depth, and the IVR system directly addressed the underrepresented demographics that the platform aimed to serve.

### Wright-Stuff: Graph Database Data Model

Wright-Stuff's selection of **Neo4j** as the persistent data store (ADR 0005) was uniquely well-motivated. They included a visual graph data model diagram showing nodes (candidates, NPOs, offerings, services) and their relationships, arguing that graph databases excel at the relationship-heavy queries central to the Spotlight platform (matching candidates to offerings, discovering paths through services, generating analytical reports on interconnected entities).

### Goal Diggers: Scale Cube Deployment

Goal Diggers was the only team to apply the **Scale Cube model** (from *The Art of Scalability*), using Y-axis decomposition for domain separation and Z-axis for sharding. Their multi-cluster deployment approach with "no single point of failure" and fabric causal clusters showed sophisticated thinking about operational resilience, even if some supporting ADRs remained incomplete.

### Shokunin: Ubiquitous Language and Anti-Corruption Layers

Despite being incomplete, Shokunin's submission contained the purest application of **DDD principles**. They documented a ubiquitous language section to align all stakeholders on terminology, and their DDD context map explicitly modeled relationships between contexts: a *partnership* between matching and NP/candidate contexts, an *anti-corruption layer* in the activity context for translating cross-domain concepts, and a *conformist* relationship between the insight and activity contexts. This level of DDD rigor was unique among all submissions.

### Kamikaze Slayers: Change Data Capture

Kamikaze Slayers was the only team to explicitly design a **Change Data Capture (CDC)** pattern (ADR 04) for cross-service data synchronization. This addressed a practical challenge in microservices architectures: keeping search indexes, analytics stores, and operational databases consistent without tight coupling between services.

### The Marmots: Assignment Strategy with ML Roadmap

The Marmots' ADR on assignment strategy (AssignStrategy) was notable for its pragmatic two-phase approach: start with deterministic matching based on the highest match percentage, while passively collecting assignment data that could train ML models in the long term. This "build the data pipeline before you need the ML" approach demonstrated practical thinking about the maturity of the platform.

---

## Lessons for Practitioners

### 1. Start with the Organization, Not the Technology

The winning team (PegasuZ) spent significant effort on **requirement analysis**, tracing every business requirement to specific non-functional requirements before selecting any architecture style. Their feasibility analysis considered funding challenges, market viability, and the risks inherent in green-field development. Teams that jumped directly to architectural patterns (like Goal Diggers' six-pattern stack) produced technically impressive but less contextually grounded submissions.

**Takeaway**: For any kata or real-world engagement, document *why* each architectural decision serves the organization's specific constraints before documenting *what* the architecture is.

### 2. Evolutionary Architecture Beats Big-Bang Design

PegasuZ's phased approach -- modular monolith for MVP, microservices for scale -- directly addressed the reality that a non-profit cannot afford to build a distributed system before validating product-market fit. TheGlobalVariables' serverless approach achieved similar pragmatism through infrastructure: serverless costs scale to near-zero at low usage.

**Takeaway**: Present a roadmap with clear phase gates tied to business milestones (user count thresholds, funding rounds, market validation) rather than a single target-state architecture.

### 3. ADR Quality Matters More Than Quantity

The Marmots (19 ADRs, 2nd place) and Arch8s (17 ADRs, Runner-up) demonstrate that volume alone does not win. PegasuZ's 12 ADRs were consistently structured with the PrOACT framework, alternatives analysis, and mitigation strategies. Goal Diggers' 14 ADRs with 5 marked "TO DO" actually hurt their submission by highlighting incompleteness.

**Takeaway**: Every ADR should be complete. A smaller set of well-reasoned ADRs with clear trade-off analysis is more valuable than a long list of half-finished ones.

### 4. Cost Analysis Is Architecture

Three teams produced cost analyses (PegasuZ, TheGlobalVariables, Kamikaze Slayers), and all three were among the strongest submissions. For a non-profit kata, cost was not an afterthought -- it was a primary architectural driver. TheGlobalVariables' per-user cost calculation and Kamikaze Slayers' per-subsystem breakdown both gave judges confidence that the proposed architectures were actually buildable.

**Takeaway**: Include a cost model, even a rough one. It demonstrates that the architecture exists in reality, not just on a whiteboard.

### 5. Design for Your Users, Not Your Peers

Wright-Stuff's IVR system and PegasuZ's design thinking exercise both demonstrated **empathy for end users**. The kata's hard requirement for "end-user ease of use" demanded more than a checkbox -- it demanded evidence that teams understood *who* those users were. Shokunin's personas (though incomplete) humanized the problem in a way that made their architectural decisions feel motivated.

**Takeaway**: Include personas, golden paths, wireframes, or value stream maps. They bridge the gap between abstract architecture and the humans who will use the system.

### 6. Completeness Trumps Sophistication

Goal Diggers had arguably the most technically ambitious submission (cell-based architecture, hexagonal, CQRS, space-based, Scale Cube), but their incomplete ADRs and lack of feasibility analysis placed them as a runner-up. Shokunin's elegant DDD approach was explicitly flagged as incomplete due to personal circumstances. Meanwhile, PegasuZ's more measured approach -- fewer patterns, fully documented -- won first place.

**Takeaway**: A complete, well-justified submission with a simpler architecture will outperform a sophisticated but incomplete one. Deliver on your promises before adding complexity.

### 7. The Architecture Styles Worksheet Is a Starting Point, Not an Ending

At least four teams used Mark Richards' Architecture Styles Worksheet. This tool is valuable for initial comparison, but the winners went beyond it. PegasuZ used the worksheet as input to quantum-level decisions (different styles per quantum). TheGlobalVariables used it to justify serverless but then layered on concrete AWS service selections with trade-off analysis.

**Takeaway**: Use evaluation frameworks to frame the decision, then provide context-specific reasoning that goes beyond the generic comparison.

---

*Analysis based on submissions from the O'Reilly Architecture Katas Spring 2022 season. All team repositories are publicly available. ADR numbers and content referenced directly from each team's submission.*
