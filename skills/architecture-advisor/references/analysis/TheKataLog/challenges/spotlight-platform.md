# Spotlight Platform -- Comparative Analysis

O'Reilly Architecture Katas, Spring 2022 Season | 3 Teams

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

---

## Architecture Style Choices

### The Spectrum: Pragmatic Phasing vs. Cloud-Native Commitment

The three placing teams each took a distinctly different approach to architectural style, yet all shared a common thread: they **justified their choices in terms of the non-profit's constraints** rather than defaulting to the most technically sophisticated option.

PegasuZ (1st) deliberately started with a **modular monolith for MVP** and planned a migration to microservices + event-driven only after product-market fit (ADR 007). The Marmots (2nd) adopted microservices from day one, backed by the most thorough style evaluation worksheet of any team. TheGlobalVariables (3rd) committed fully to AWS serverless, arguing that the operational savings justified the vendor lock-in for a resource-constrained non-profit.

### Microservices: Two Approaches to Adoption

Both The Marmots and TheGlobalVariables chose microservices as their primary architectural style, while PegasuZ planned microservices as their eventual target state. The key differentiator was *when* to adopt microservices. PegasuZ's phased approach -- start monolithic, decompose when scale demands it -- demonstrated a mature understanding that architectural decisions should be tied to organizational readiness, not technical aspiration. The Marmots justified their immediate microservices adoption through a detailed architecture styles worksheet and market sizing analysis that projected sufficient scale to warrant distributed services.

### Event-Driven as a Common Companion

Both PegasuZ and TheGlobalVariables explicitly incorporated event-driven architecture. PegasuZ's ADR 010 on message queues vs. event streams is noteworthy -- they chose event streams over message queues specifically because Spotlight's use cases required multi-consumer delivery (e.g., a `candidate_assignment_updated` event consumed by both the candidate service and the analytics pipeline). TheGlobalVariables achieved event-driven communication through AWS-native services like SNS, SQS, and EventBridge, tightly integrated with their serverless compute layer.

### Serverless: Bold Bet by TheGlobalVariables

TheGlobalVariables (3rd) made the most decisive infrastructure commitment, going all-in on AWS serverless (Lambda, DynamoDB, Amplify, AppSync, Cognito, SageMaker). Their ADR 0001 contains a sophisticated analysis of vendor lock-in, framing it as `(Cost of Change) x (Likelihood of Change)` and arguing that the operational savings of serverless outweigh the theoretical portability of containerized open-source alternatives. This was persuasive to judges because it was **directly aligned with the non-profit's cost constraints**.

PegasuZ took a more balanced approach in ADR 006, proposing containers for high-availability services and serverless for less-critical ones, acknowledging different deployment strategies per architectural quantum.

---

## What Distinguished the Top Teams

### 1. Feasibility Thinking and Non-Profit Empathy

The single clearest trait shared by all three placing teams was **explicit engagement with the non-profit's constraints**. PegasuZ, The Marmots, and TheGlobalVariables all demonstrated that they understood they were designing for an organization with limited funding, volunteer staff, and non-technical end users.

- **PegasuZ** (1st) conducted a feasibility analysis examining funding viability, market adoption, and the risks of green-field development. Their requirement analysis document traced every business requirement to specific NFRs with rationale. They explicitly asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" This led directly to their modular monolith MVP decision.
- **The Marmots** (2nd) grounded their microservices architecture in a detailed market sizing analysis, demonstrating that they understood scale was not an abstract goal but something that needed to be projected from realistic adoption numbers.
- **TheGlobalVariables** (3rd) produced the most granular cost analysis, calculating per-user costs as low as $0.002/month and the architectural minimum footprint at under $100/month. They also analyzed operational costs, noting that serverless eliminates the burden of OS/server maintenance while acknowledging the higher cost of rare incident response for specialized skills.

### 2. Evolutionary Roadmaps

All three placing teams presented clear thinking about **how the platform would evolve over time**, rather than proposing a single target-state architecture:

- **PegasuZ** (1st) defined an explicit MVP scope (modular monolith with core NP-Candidate quantum, BFF, documents, chat, notifications, meetings, basic reports and recommendations) and a long-term vision (microservices migration, advanced analytics with model training, NPO integrations). This demonstrated architectural maturity -- the understanding that architecture is a journey, not a destination.
- **The Marmots** (2nd) documented a future roadmap including AI-enhanced matching, group sharing, and trials/samples from non-profits, showing foresight about how the platform's capabilities would grow alongside its user base.
- **TheGlobalVariables** (3rd) designed their serverless architecture to scale organically with usage -- a form of implicit evolutionary design where costs and capacity grow proportionally to demand without requiring architectural restructuring.

### 3. User Experience and Design Thinking

Each placing team invested in understanding and designing for end users, though through different techniques:

- **PegasuZ** (1st) conducted a full **design thinking exercise** with candidate and non-profit personas, producing golden paths for both user types with accompanying video walkthroughs. This was a direct response to the "ease of use" hard requirement and demonstrated that architecture starts with understanding users, not choosing patterns.
- **TheGlobalVariables** (3rd) included **UI wireframes** for six key screens and **value stream mappings** for candidate registration, non-profit registration, and user data purging -- grounding abstract architecture in concrete user interactions.
- **The Marmots** (2nd) designed user-facing features like forums, notifications, and search with explicit attention to the candidate experience, ensuring the architecture served usability goals rather than just technical ones.

### 4. Depth and Quality of ADRs

ADR count alone did not predict placement -- what mattered was **ADR quality and completeness**:

- **PegasuZ** (1st, 12 ADRs) used a consistent PrOACT decision framework across ADRs, with clear alternatives, trade-off tables, and mitigation strategies. Every ADR was complete with status, context, decision, and consequences.
- **The Marmots** (2nd, 19 ADRs) had the highest ADR count of any team and covered granular decisions (DB read replication, analytics queue, forum storage, notification persistence) with a consistent positive/negative/risk structure.
- **TheGlobalVariables** (3rd, 6 ADRs) had the fewest ADRs but made each one count. Their vendor lock-in ADR (0001) alone contained more strategic depth than many teams' entire ADR sets.

### 5. Quantified Architectural Characteristics

All three placing teams quantified their quality attributes rather than leaving them as vague aspirations:

- **PegasuZ** (1st) defined specific availability targets: 3 nines for non-critical quanta (reporting/analytics) and 4 nines for critical quanta (notifications), with explicit justification for why 5 nines was unreasonable for a non-profit platform.
- **TheGlobalVariables** (3rd) tied responsiveness to the **Doherty Threshold** (400ms), providing a concrete, research-backed target for user experience.
- **The Marmots** (2nd) backed their scalability claims with market sizing data, translating abstract growth projections into concrete capacity requirements for their microservices.

---

## Common Patterns

### Patterns Shared Across the Placing Teams

1. **Backend for Frontend (BFF)**: All three placing teams adopted the BFF pattern. PegasuZ's BFF ADR (ADR 004) was the most detailed, choosing GraphQL for the BFF layer to solve over-fetching/under-fetching while keeping REST for external integrations. The Marmots implemented BFF as part of their layered capability decomposition, and TheGlobalVariables used AWS AppSync (a managed GraphQL service) as their BFF equivalent.

2. **Notification and Messaging**: All three teams included a notification subsystem. Approaches varied from dedicated notification queues (The Marmots, ADR: NotifyQueues) to event streams (PegasuZ, ADR 010) to AWS-managed messaging services (TheGlobalVariables).

3. **Analytics and Reporting**: All three teams addressed the operational and analytical reporting requirement. TheGlobalVariables proposed AWS SageMaker for ML-based predictions. PegasuZ planned for a separate Reports quantum with a roadmap from basic reporting (MVP) to advanced predictive analytics (long-term). The Marmots designed a dedicated analytics pipeline with queuing to decouple report generation from transactional workloads.

4. **Identity and Authentication**: Each team addressed authentication differently. TheGlobalVariables used AWS Cognito. PegasuZ documented a general IdP decision (ADR 009) with a buy-over-build rationale. The Marmots designed a dedicated auth DB with RBAC (ADR: RBACinAUTH).

5. **Architecture Styles Worksheet**: Both The Marmots and TheGlobalVariables used Mark Richards' Architecture Styles Worksheet to justify their style choice, reflecting the strong influence of the *Fundamentals of Software Architecture* textbook on kata participants. PegasuZ went beyond the worksheet to perform quantum-level analysis.

### Problem Decomposition Approaches

Each placing team used a different decomposition strategy, reflecting their architectural philosophy:
- **Architectural quanta** (PegasuZ): 8 quanta identified through event storming + actor-action analysis, each with independently tunable architectural characteristics
- **Layered capability decomposition** (The Marmots): Frontend, infrastructure abstraction, route handlers, backend microservices -- a pragmatic layering that mapped cleanly to team responsibilities
- **AWS service mapping** (TheGlobalVariables): Decomposition driven by AWS service boundaries, with each platform capability mapped to a specific managed service or Lambda function group

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

### The Marmots (2nd): Assignment Strategy with ML Roadmap

The Marmots' ADR on assignment strategy (AssignStrategy) was notable for its pragmatic two-phase approach: start with deterministic matching based on the highest match percentage, while passively collecting assignment data that could train ML models in the long term. This "build the data pipeline before you need the ML" approach demonstrated practical thinking about the maturity of the platform.

---

## Lessons for Practitioners

### 1. Start with the Organization, Not the Technology

The winning team (PegasuZ) spent significant effort on **requirement analysis**, tracing every business requirement to specific non-functional requirements before selecting any architecture style. Their feasibility analysis considered funding challenges, market viability, and the risks inherent in green-field development.

**Takeaway**: For any kata or real-world engagement, document *why* each architectural decision serves the organization's specific constraints before documenting *what* the architecture is.

### 2. Evolutionary Architecture Beats Big-Bang Design

PegasuZ's phased approach -- modular monolith for MVP, microservices for scale -- directly addressed the reality that a non-profit cannot afford to build a distributed system before validating product-market fit. TheGlobalVariables' serverless approach achieved similar pragmatism through infrastructure: serverless costs scale to near-zero at low usage. The Marmots' roadmap for AI-enhanced matching showed that even a microservices-from-day-one approach can be evolutionary in its feature delivery.

**Takeaway**: Present a roadmap with clear phase gates tied to business milestones (user count thresholds, funding rounds, market validation) rather than a single target-state architecture.

### 3. ADR Quality Matters More Than Quantity

The Marmots (19 ADRs, 2nd place) and PegasuZ (12 ADRs, 1st place) demonstrate that volume alone does not determine placement. PegasuZ's 12 ADRs were consistently structured with the PrOACT framework, alternatives analysis, and mitigation strategies. TheGlobalVariables proved that even 6 ADRs can be sufficient when each one is strategically significant and thoroughly reasoned.

**Takeaway**: Every ADR should be complete. A smaller set of well-reasoned ADRs with clear trade-off analysis is more valuable than a long list of half-finished ones.

### 4. Cost Analysis Is Architecture

All three placing teams produced cost analyses, and this was no coincidence. For a non-profit kata, cost was not an afterthought -- it was a primary architectural driver. TheGlobalVariables' per-user cost calculation ($0.002/month) gave judges confidence that the proposed architecture was actually buildable. PegasuZ's feasibility analysis framed cost as an existential question for the organization. The Marmots' market sizing translated growth projections into infrastructure planning.

**Takeaway**: Include a cost model, even a rough one. It demonstrates that the architecture exists in reality, not just on a whiteboard.

### 5. Design for Your Users, Not Your Peers

PegasuZ's design thinking exercise and TheGlobalVariables' UI wireframes both demonstrated **empathy for end users**. The kata's hard requirement for "end-user ease of use" demanded more than a checkbox -- it demanded evidence that teams understood *who* those users were. The Marmots' attention to user-facing features like forums and search showed that user experience informed their service decomposition.

**Takeaway**: Include personas, golden paths, wireframes, or value stream maps. They bridge the gap between abstract architecture and the humans who will use the system.

### 6. Completeness Enables Confidence

All three placing teams delivered submissions that were thorough and internally consistent. PegasuZ's measured approach -- fewer patterns, fully documented -- won first place. The Marmots' 19 complete ADRs demonstrated exhaustive coverage. TheGlobalVariables' focused-but-deep treatment of serverless trade-offs showed that a concise submission can be just as compelling when every section is substantive.

**Takeaway**: A complete, well-justified submission with a simpler architecture will outperform a sophisticated but incomplete one. Deliver on your promises before adding complexity.

### 7. The Architecture Styles Worksheet Is a Starting Point, Not an Ending

Both The Marmots and TheGlobalVariables used Mark Richards' Architecture Styles Worksheet. This tool is valuable for initial comparison, but the placing teams went beyond it. PegasuZ used quantum-level analysis to make different style choices per component. TheGlobalVariables layered on concrete AWS service selections with trade-off analysis. The Marmots combined the worksheet with market sizing to validate their scalability assumptions.

**Takeaway**: Use evaluation frameworks to frame the decision, then provide context-specific reasoning that goes beyond the generic comparison.

---

*Analysis based on submissions from the O'Reilly Architecture Katas Spring 2022 season. All team repositories are publicly available. ADR numbers and content referenced directly from each team's submission.*
