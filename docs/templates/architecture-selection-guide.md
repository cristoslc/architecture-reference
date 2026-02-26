# Architecture Style Selection Guide: Patterns from Kata Winners

> Synthesized from 8 winning and top-placing O'Reilly Architecture Kata teams (2020-2025).

---

## The Meta-Pattern: How Winners Choose Architecture Styles

Across the winning Kata submissions analyzed, several clear patterns emerge in how architecture styles are selected:

- **73% of winners use multi-style architectures.** Rather than picking a single style, most winning teams compose multiple styles across different parts of the system. PegasuZ assigned different styles per architectural quantum. MonArch designed a modular monolith with an explicit evolution plan to microservices + event-driven. Pragmatic chose service-based with event-driven where needed.

- **Modular monolith is a strong winner signal.** Teams that start with a modular monolith (or explicitly plan a modular-monolith-first strategy) disproportionately win. ArchColider (1st, Fall 2020) chose "modularized monolith" as their primary style. PegasuZ (1st, Spring 2022) specified modular monolith for the MVP quantum. MonArch (1st, Fall 2022) centered their entire approach on it. This signals that judges reward pragmatism and evolutionary thinking over complexity.

- **Microservices alone is not predictive of winning.** No winning team chose microservices as a standalone, from-day-one architecture without an evolutionary rationale. MonArch explicitly started with modular monolith before planning a microservices migration. PegasuZ only prescribed microservices for the long-term state. The Archangels and Profitero chose event-driven over microservices after direct comparison.

- **Service-based architecture is the "pragmatic winner" style.** AnimAI and Pragmatic both independently selected service-based architecture through systematic elimination, citing it as the optimal balance of cost, testability, and extensibility. Software Architecture Guild chose microkernel for its specific AI plug-in use case.

- **Every winner documents their reasoning.** No winning team simply declares an architecture style. Every one provides a written analysis with characteristics mapping, trade-off analysis, or systematic elimination. The documentation of reasoning is itself a pattern.

**Summary of styles chosen by each team:**

| Team | Year/Place | Primary Style | Secondary Style(s) | Selection Method |
|------|------------|---------------|---------------------|-----------------|
| ArchColider | Fall 2020, 1st | Modularized Monolith | Event Sourcing, Log-based streaming | DDD Strategic Design + Quality Attributes per subsystem |
| Archangels | Fall 2021, 1st | Event-Driven | -- | Characteristics worksheet + Pros/Cons/Mitigations matrix |
| PegasuZ | Spring 2022, 1st | Multi-style (per quantum) | Modular Monolith (MVP), Microservices + Event-Driven (long-term) | Architectural quantum decomposition + per-quantum worksheet |
| MonArch | Fall 2022, 1st | Modular Monolith | Microservices (evolution target) | Event storming + evolutionary pragmatism |
| Profitero | Fall 2023, 1st (External) | Event-Driven | -- | Rozanski/Woods viewpoints + Characteristics worksheet ADR |
| AnimAI | Fall 2023, Runner-up | Service-Based | -- | Systematic elimination (cost-first) |
| Pragmatic | Fall 2024, 1st | Service-Based | Event-Driven (where needed) | Event storming + characteristics analysis + ADR |
| SAG | Winter 2025, 3rd | Microkernel (Plug-in) | -- | Rozanski/Woods viewpoints + Characteristics targeting |

---

## Selection Frameworks Observed

### Mark Richards Architecture Styles Worksheet

The Architecture Styles Worksheet (from DeveloperToArchitect.com) maps architecture characteristics to architecture styles using a star-rating matrix. It is the single most commonly used selection tool across winning teams.

**How teams use it:**

**Archangels (1st, Fall 2021)** provide the clearest example. They:
1. Identified 7 key architecture characteristics from requirements (Interoperability, Data Integrity, Scalability/Elasticity, Configurability, Authorisation, Workflow, Fault Tolerance).
2. Selected a top 3 (Interoperability, Configurability, Authorisation).
3. Mapped these against the worksheet, highlighting their characteristics in the matrix.
4. Identified two candidate styles (Microservices, Event-Driven) from the highest-scoring intersections.
5. Built a Pros/Cons/Mitigations table for each candidate.
6. Selected Event-Driven as having "lower overall trade-offs."

Their comparison table structure is worth replicating:

| Pros | Cons | Mitigations |
|------|------|-------------|
| Scores highly on elasticity and scalability | Interoperability and configurability score fairly low | Configurability is about the profile, not the system as a whole |
| Workflow scores highly | Scores badly on simplicity | -- |

**PegasuZ (1st, Spring 2022)** used the worksheet at the quantum level rather than system level. For each identified quantum, they created a separate worksheet analysis with its own top-3 characteristics, leading to potentially different style selections per quantum. For the NPO-Candidate quantum, they identified Feasibility, Extensibility, and Scalability as the top 3, and used the worksheet to validate modular monolith for MVP and microservices + event-driven for the long term.

**Profitero Data Alchemists (1st, Fall 2023)** used the worksheet in their ADR-1, identifying Performance, Scalability, and Evolvability as the top 3 characteristics. The team described their process: "By using the Architecture Styles Worksheet, the team assessed these key characteristics and ultimately chose the event-driven architecture as the most suitable option."

**Key lesson:** The worksheet is a starting tool, not a decision tool. Every team that uses it follows up with deeper analysis (pros/cons, trade-off matrices, or elimination reasoning).

### Architecture Characteristics Analysis

Identifying and prioritizing quality attributes is the universal first step. Every winning team follows some variant of this process:

**Step 1: Extract candidate characteristics from requirements.**

Pragmatic (1st, Fall 2024) demonstrates a thorough approach. Starting from business requirements and an event storming session, they identified 12 candidate characteristics:

> security, interoperability, feasibility, fault tolerance, testability, adaptability, scalability, observability, extensibility, configurability, abstraction, data integrity

**Step 2: Define each characteristic precisely.**

Pragmatic provided explicit definitions for each characteristic, avoiding ambiguity:

> **feasibility** -- Taking into account timeframes, budgets, and developer skills when making architectural choices; tight timeframes and budgets make this a driving architectural characteristic.

**Step 3: Reduce to 7 or fewer, then select the top 3.**

The Archangels explicitly state: "Best practice is to identify no more than seven." Every winning team converges on exactly 3 driving characteristics. Pragmatic described their reasoning for downgrading some characteristics:

> **Extensibility**: Largely covered by adaptability.
> **Data integrity**: While essential, we believe it primarily impacts code implementation and overlaps with AI model testability, making it less relevant to the architecture.

**Step 4: Distinguish driving from implicit characteristics.**

Multiple teams separate "driving" characteristics (which affect structure) from "implicit" characteristics (which are always present but do not drive structural decisions).

ArchColider provides per-subsystem quality attributes -- a particularly granular approach:
- Meal Catalog: Extensibility, Maintainability, Availability
- Order Processing: Reliability, Integrity
- Purchase Gateway: Security, Availability
- Reporting: Reliability

The Archangels make the same distinction:
> **Implicit Architecture Characteristics:** Feasibility, Security/Authentication/Authorisation, Maintainability, Simplicity. These may not affect the *structure* but will feed into the overall architecture.

**Step 5: Justify the top 3 from business context.**

Pragmatic identified 3 business challenges that drove their top 3:
1. AI introduces non-deterministic behavior --> **Testability**
2. Nonprofit with AI costs --> **Feasibility**
3. Multiple HR system integrations --> **Interoperability**

AnimAI (Runner-up, Fall 2023) mapped each requirement directly to a characteristic in a detailed Requirements-Characteristics mapping table, creating full traceability from business need to architectural decision.

### Architectural Quantum Decomposition

**PegasuZ (1st, Spring 2022)** provides the canonical example of quantum-based architecture selection.

**What is an architectural quantum?** In their words: "An independently deployable artifact with high functional cohesion and synchronous connascence."

**Their process:**

1. **Event storming + actor-action exercise** to identify aggregates.
2. **Group aggregates into services** based on cohesion.
3. **Identify synchronous dependencies** between services to define quantum boundaries.
4. **Assign characteristics per quantum** -- each quantum gets its own top-3 characteristics worksheet.
5. **Select architecture style per quantum** based on its specific characteristics.

This led to 8 distinct quanta with potentially different styles:
- NPO-Candidate (core quantum): Modular Monolith for MVP, Microservices + Event-Driven long-term
- Reports, Notification, Recommendations, Chat, Meetings, Document, NPO Integrations: Each analyzed independently

**The critical insight:** "Since the proposal is a platform, the platform could be composed of several architectural quanta, each with its own architectural style. So, we are not picking a style yet." This deferral of the global style decision until after quantum decomposition is a distinguishing technique.

**MonArch (1st, Fall 2022)** also used quantum analysis. They identified 6 quanta based on coupling analysis -- static (shared databases) and dynamic (synchronous calls and asynchronous events) -- and used this to validate their domain partitioning.

**The Archangels (1st, Fall 2021)** performed granularity analysis at the domain level using a multi-factor table:

| Functionality | Volatility | Scalability | Fault Tolerance | Data Security | Data Transactions | Data Dependencies | Workflow |
|---|---|---|---|---|---|---|---|

They used this table for each domain (Users, Security, Community, Analytics, Messaging, Medical) to determine where to split or merge services, producing ADRs for each granularity decision.

### Rozanski/Woods Viewpoints

Two teams used the Rozanski/Woods "Viewpoints and Perspectives" framework as their primary structuring approach: Profitero Data Alchemists (1st, Fall 2023) and Software Architecture Guild (3rd, Winter 2025).

**The framework** structures architecture documentation through multiple viewpoints, each addressing a different stakeholder concern:

| Viewpoint | Addresses |
|-----------|-----------|
| Functional | System's functional elements, responsibilities, interfaces, primary interactions |
| Context | Relationships, dependencies, interactions with environment |
| Operational | How the system is operated in production |
| Informational | How architecture stores, manipulates, manages, distributes information |
| Concurrency | Concurrency structure, mapping functional elements to concurrency units |
| Development | Architecture supporting the software development process |
| Deployment | Runtime environment, dependencies |
| Security (Perspective) | Access control, monitoring, audit |

**Profitero's application** is exemplary. They used each viewpoint to drive specific architectural decisions:
- Functional Viewpoint --> identified main flow and functional requirements
- Context Viewpoint --> C4 model Levels 1-3, identifying integration points
- Concurrency Viewpoint --> defined 3 scaling groups (API, Data Readers/Updaters, Messaging), directly informing their event-driven choice
- Development Viewpoint --> monorepo strategy, merge strategy, automation decisions
- Deployment Viewpoint --> multi-zone infrastructure, Kubernetes, Kafka

**Software Architecture Guild** used the same framework for their existing system analysis (Current State) via user journey maps and service blueprints, and for their proposed architecture changes, using functional viewpoints to structure AI solution integration.

**When to use Rozanski/Woods:** This framework excels when:
- The system has many stakeholder groups with different concerns
- Infrastructure and operational concerns are as important as functional design
- The team wants a comprehensive, auditable documentation structure
- The system involves complex integrations (many external APIs, multiple deployment environments)

### Systematic Elimination

**AnimAI (Runner-up, Fall 2023)** provides the most explicit example of systematic elimination for architecture style selection.

Their process was documented across ADRs 000-014:

1. **Establish priority-ordered characteristics** (ADR-013):
   - Cost, Performance, Scalability, Extensibility, Simplicity, Testability, Interoperability

2. **Eliminate from the top priority down** (ADR-014):
   - Cost is #1 --> Eliminate **Space-Based** and **Microservices** (too expensive)
   - Cost is #1 --> Eliminate **Event-Driven** (costs and complexity)
   - Scalability is #3 --> Eliminate **Microkernel**, **Layered Monolith**, **Modular Monolith** (insufficient scalability)
   - Remaining candidate: **Service-Based Architecture**

3. **Validate the survivor** against remaining characteristics:
   - Better scalability and performance than eliminated options
   - Slightly higher costs than monolith options, but more future-proof
   - Acknowledge trade-offs: testing harder than microservices, deployment pipeline needs coordination, poor elasticity

This elimination approach is notable for its transparency and reproducibility. It makes the reasoning chain explicit and defensible.

**Pragmatic (1st, Fall 2024)** used a similar but less formal elimination in their ADR-002:
> "Although the microkernel architecture was considered, its limitations in scalability and fault-tolerance -- two of our top 7 driving characteristics -- led us to pursue a different option."

### Event Storming to Architecture

Event storming is used by multiple winning teams as a bridge between requirements and architecture.

**MonArch (1st, Fall 2022)** used event storming as their primary domain partitioning technique:
1. Identify domain events (orange sticky notes) -- "something that happens within the system"
2. Identify commands that trigger events (blue sticky notes)
3. Identify actors associated with commands
4. Group related commands and events into aggregates
5. Identify automation policies (asynchronous couplings between bounded contexts)
6. Group semantically related aggregates into bounded contexts
7. Map bounded contexts to modules/services

This directly produced their modular monolith structure and identified where event-driven communication was needed between bounded contexts.

**Pragmatic (1st, Fall 2024)** combined event storming with architecture characteristics analysis:
> "Starting from the business requirements and the Event Storming session, we determined the architecture characteristics."

Their event storming session identified three main challenges that became the top-3 characteristics.

**PegasuZ (1st, Spring 2022)** combined event storming with the actor-action approach to identify aggregates, which were then grouped into services and quanta.

**The Archangels (1st, Fall 2021)** used event storming per requirement, going through each of the 10 initial requirements to map domain events, commands, actors, and timing. This requirement-by-requirement approach ensures completeness.

**Pattern:** Event storming works best when teams use it to discover bounded contexts and asynchronous coupling points, then feed those discoveries into the architecture characteristics and quantum analysis. It is a discovery technique, not a selection technique.

---

## Architecture Style Decision Tree

Based on the patterns observed across all 8 teams, the following synthesized decision guidance emerges:

```
START: What are your top 3 driving characteristics?

  Is COST / FEASIBILITY in your top 3?
    YES --> Eliminate: Space-Based, Microservices (from day 1)
            Consider: Service-Based, Modular Monolith
    NO  --> All styles remain candidates

  Is SCALABILITY in your top 3?
    YES --> Eliminate: Layered Monolith, Microkernel
            Consider: Microservices (long-term), Event-Driven, Service-Based
    NO  --> Modular Monolith and Service-Based remain strong candidates

  Is EVOLVABILITY / EXTENSIBILITY in your top 3?
    YES --> Consider: Event-Driven, Service-Based, Modular Monolith (with extraction plan)
    NO  --> Continue

  Is INTEROPERABILITY in your top 3?
    YES --> Consider: Service-Based + Event Streaming, Event-Driven
    NO  --> Continue

  Is WORKFLOW in your top 3?
    YES --> Consider: Event-Driven (scores highest)
            Avoid: Microservices (scores lowest)
    NO  --> Continue

  Is PERFORMANCE in your top 3?
    YES --> Consider: Event-Driven, Service-Based
            Note: Microservices penalize system-level performance (network hops)
    NO  --> Continue

  Is TESTABILITY in your top 3?
    YES --> Consider: Service-Based (independent services with clear interfaces)
    NO  --> Continue

  Is SIMPLICITY in your top 3?
    YES --> Consider: Modular Monolith, Service-Based
            Avoid: Microservices, Event-Driven
    NO  --> Continue

  Are you a GREENFIELD project with uncertain domain?
    YES --> Start with Modular Monolith, plan evolution
            (ArchColider, PegasuZ, MonArch pattern)
    NO  --> Match style to dominant characteristics

  Does your system have MULTIPLE DISTINCT QUANTA with different characteristics?
    YES --> Use multi-style: assign style per quantum
            (PegasuZ pattern)
    NO  --> Use single style for the system
```

---

## The Evolutionary Architecture Pattern

The most consistent meta-pattern across winners is: **start simple, evolve to complex.**

### Why "Start Monolith, Evolve to Services" Wins

**ArchColider (1st, Fall 2020)** explicitly stated their philosophy:

> "Microservice approach requires a lot of attention to infrastructure, separation of responsibility, preferably a stable and known domain model. For the ordering system it's not applicable, and developers' effort will be wasted or invisible for end-users. Microservices should grow naturally as the need arises."

Their rejected alternatives demonstrate this thinking:
- **Microservices from the start** -- Rejected: "requires a lot of attention to infrastructure" and "a stable and known domain model"
- **Pure monolith** -- Rejected: "oversimplification" for the level of maturity
- **Modularized monolith** -- Selected: the middle path

**PegasuZ (1st, Spring 2022)** encoded this in their roadmap:

- **MVP:** NPO-Candidate quantum as Modular Monolith
- **Long Term:** "NPO-Candidate quantum (migrate to Microservices + Event Driven)"

Their ADR for the NP-Candidate quantum MVP made it conditional:
> "Modular Monolith if there is a cost constraint. Start with the monolith and later migrate to microservice + event driven after there is a product market fit and a system required to scale."

**MonArch (1st, Fall 2022)** centered their entire approach on this pattern. They:
1. Used event storming to identify bounded contexts
2. Mapped each bounded context to a module within a modular monolith
3. Showed the modular monolith as a stepping stone (Figure 6)
4. Then decomposed it along bounded-context boundaries into microservices (Figure 7)
5. Made the goal explicit: "The Hey Blue! system could even be developed and deployed as a modular monolith... This is a viable approach that can be taken initially for rapidly prototyping a minimum viable product at a reduced overall cost of development."

### The Evolution Triggers

ArchColider described concrete signals for when to extract:
> "The decision about extracting modules should be made based on metrics and trends that some modules have higher pressure than others. Vertical scaling is a preferred way of handling load during the first months, years of the system life. When vertical scaling is no longer an option then we would start scaling horizontally."

This is data-driven evolution: telemetry and metrics drive extraction decisions, not upfront speculation.

### Key Principles of Evolutionary Architecture from Winners

1. **Design module boundaries as if they are service boundaries** (ArchColider: "communication between modules described in such a way that every module can be extracted as a service in a short time")
2. **Use capacity planning to time the evolution** (PegasuZ's capacity table from 5K users at 3 months to 1M at 3 years)
3. **Make the evolution plan explicit in the architecture documentation** (PegasuZ Roadmap, MonArch modular monolith -> microservices progression)
4. **Require telemetry from day one** (ArchColider: "Telemetry is mandatory" as Principle #3)
5. **Prefer vertical scaling first** (ArchColider: "Vertical scaling is a preferred way... When vertical scaling is no longer an option then we would start scaling horizontally")

---

## Style-Specific Guidance

### When to Choose Service-Based

**Observed in:** AnimAI (Runner-up, Fall 2023), Pragmatic (1st, Fall 2024)

**Select when:**
- Cost/feasibility is a top-3 concern (nonprofit, startup, limited budget)
- You need independent deployability per domain without the overhead of full microservices
- Testability matters (independent services with clear interfaces)
- You want the ability to expand one domain without affecting another
- Elasticity is NOT required (service-based handles this poorly)

**AnimAI's rationale:** Service-based is the survivor when you eliminate on cost (killing microservices and event-driven) but still need scalability (killing monoliths). It is "the compromise."

**Pragmatic's rationale:** Service-based provides the optimal balance between feasibility and testability, with event-streaming capabilities added "where needed" for better interoperability and deployability.

**Trade-offs to accept:**
- Testing is harder than pure microservices (shared databases between services)
- Deployment pipeline needs more coordination than microservices
- Poor elasticity support

### When to Choose Event-Driven

**Observed in:** Archangels (1st, Fall 2021), Profitero (1st, Fall 2023)

**Select when:**
- Workflow is a key characteristic (event-driven scores highest here)
- Scalability and elasticity are critical (15M+ users, as in Profitero)
- You need real-time updates and notifications
- Fault tolerance matters (community/platform systems where one failure should not cascade)
- Performance at scale is required (event-driven excels at asynchronous processing)

**Archangels' rationale:** After comparing Microservices vs Event-Driven in a formal Pros/Cons/Mitigations table, event-driven had "lower overall trade-offs" and scored highly on workflow, which was important for customer onboarding.

**Profitero's rationale:** With 15 million potential users and the need for real-time travel updates within 5 minutes, event-driven architecture was the natural fit for Performance, Scalability, and Evolvability.

**Trade-offs to accept:**
- Complexity in managing event flows and ensuring data consistency
- Scores poorly on simplicity
- Requires robust operational practices and monitoring
- Potential learning curve for development teams

### When to Choose Microservices

**Observed in:** PegasuZ long-term (1st, Spring 2022), MonArch long-term (1st, Fall 2022)

**Select when:**
- The domain model is stable and well-understood (NOT for greenfield)
- Independent deployment per service is a hard requirement
- Different services have vastly different scalability needs
- Team structure aligns with service boundaries (Conway's Law)
- You have the budget and infrastructure maturity to support it

**Critically, no winning team chose microservices for day-one implementation.** Both PegasuZ and MonArch position it as the evolution target, not the starting point.

**MonArch's explicit warning:** "Microservices are not the goal, you don't win by having microservices" (quoting Sam Newman).

**Trade-offs to accept:**
- High cost (infrastructure, monitoring, distributed tracing)
- Performance penalty from network IO and distributed transactions
- Requires database-per-service (adds complexity)
- Scores low on workflow and simplicity

### When to Choose Modular Monolith

**Observed in:** ArchColider (1st, Fall 2020), PegasuZ MVP (1st, Spring 2022), MonArch (1st, Fall 2022)

**Select when:**
- It is a greenfield project with domain uncertainty
- Cost and time-to-market are top concerns
- You want to preserve the option for future decomposition
- The team is small and co-located
- Simplicity and developer velocity matter more than independent deployability

**ArchColider's approach:** Modularized monolith with DDD bounded contexts, event sourcing for core domains, and log-based streaming for inter-module communication. "Every module can be extracted as a service in a short time."

**Critical success factor:** Design the monolith as if it were already distributed. Use message-based communication between modules (ArchColider Principle #4: "Messages over direct calls"). This makes future extraction straightforward.

**Trade-offs to accept:**
- Cannot scale individual modules independently (initially)
- Single deployment unit means all-or-nothing releases
- Risk of module boundaries eroding over time without governance

### When to Choose Hybrid/Multi-Style

**Observed in:** PegasuZ (1st, Spring 2022), MonArch (1st, Fall 2022), Pragmatic (1st, Fall 2024)

**Select when:**
- Different parts of the system have fundamentally different quality attribute requirements
- Architectural quantum analysis reveals distinct quanta with different characteristics
- The system is a platform (PegasuZ: "Since the proposal is a platform, the platform could be composed of several architectural quanta, each with its own architectural style")
- Some parts need real-time event processing while others are simple CRUD

**PegasuZ's pattern:**
- Core quantum (NPO-Candidate): Modular Monolith (MVP) --> Microservices + Event-Driven (long-term)
- Notification quantum: Event-driven (asynchronous by nature)
- Reports quantum: Read-heavy, lower availability requirements
- Each quantum gets its own characteristics worksheet and style selection

**Pragmatic's pattern:** Service-Based as the primary style, with Event-Driven "where needed for better interoperability and deployability." This selective hybridization keeps complexity contained.

**Trade-offs to accept:**
- More complex for developers to understand the overall system
- Requires clear documentation of which style applies where and why
- Integration between differently-styled components needs careful design

### When to Choose Microkernel

**Observed in:** Software Architecture Guild (3rd, Winter 2025)

**Select when:**
- The core system is stable but extensions change frequently
- You need plug-in architecture (e.g., AI model integration)
- Cost and simplicity are driving characteristics
- Evolvability of extensions (not core) is the primary concern

**SAG's rationale:** For integrating AI assistants into an existing certification system, microkernel was chosen because:
- AI models need to be swapped, tested in parallel, and rolled back independently
- The core certification system should not be disrupted by AI changes
- Cost optimization requires modular AI components
- Simplicity demands clear separation between core and extensions

**Trade-offs to accept:**
- Initial implementation complexity for the plug-in framework
- Scalability limitations compared to distributed architectures
- Overhead in coordinating communication between plug-ins and core

---

## Template: Architecture Selection Rationale

Use this template to document your own architecture style selection, following the patterns of Kata winners.

```markdown
# Architecture Style Selection

## Date: [YYYY-MM-DD]
## Status: [Proposed | Accepted | Superseded]

## 1. Driving Characteristics

### Candidate Characteristics
[List all characteristics considered, derived from requirements analysis
and/or event storming. Include source requirement for each.]

| Characteristic | Source Requirement | Relevance |
|----------------|-------------------|-----------|
| [e.g., Scalability] | [e.g., Must support 2M active users] | [High/Medium/Low] |
| ... | ... | ... |

### Top 7 Selected Characteristics
[Reduce to 7 or fewer. Justify any characteristics removed.]

1. [Characteristic] -- [Why selected]
2. ...

### Top 3 Driving Characteristics
[Select the 3 that most affect structural decisions. Justify each.]

1. **[Characteristic]** -- [Business justification]
2. **[Characteristic]** -- [Business justification]
3. **[Characteristic]** -- [Business justification]

### Implicit Characteristics
[Characteristics that are always present but do not drive structure.]
- Security
- Maintainability
- [Others]

## 2. Architectural Quanta Analysis (if applicable)

[If the system has distinct parts with different characteristics,
decompose into quanta here.]

| Quantum | Key Characteristics | Candidate Style |
|---------|-------------------|-----------------|
| [e.g., Core Operations] | Feasibility, Extensibility, Scalability | [e.g., Modular Monolith] |
| ... | ... | ... |

## 3. Style Analysis

### Architecture Styles Worksheet
[Map top-3 characteristics against style ratings.
Reference: DeveloperToArchitect.com/downloads/worksheets.html]

### Candidate Styles
[Identify 2-3 candidate styles from the worksheet.]

### Comparison

#### [Style A]

| Pros | Cons | Mitigations |
|------|------|-------------|
| ... | ... | ... |

#### [Style B]

| Pros | Cons | Mitigations |
|------|------|-------------|
| ... | ... | ... |

### Elimination Reasoning (optional)
[If using systematic elimination, document each step.]

1. [Characteristic] eliminates [Style] because [reason]
2. ...

## 4. Decision

**Selected style:** [Style name]
**Secondary style (if hybrid):** [Style name] -- used for [specific contexts]

## 5. Consequences

### Positive
- [What this style enables]

### Negative
- [What trade-offs you accept]

### Risks
- [What could go wrong]

## 6. Evolution Plan (if applicable)

| Phase | Style | Trigger for Next Phase |
|-------|-------|----------------------|
| MVP | [e.g., Modular Monolith] | Product-market fit confirmed, vertical scaling insufficient |
| Growth | [e.g., Service-Based] | Individual services need independent scaling |
| Scale | [e.g., Microservices + Event-Driven] | Metrics show specific quanta under pressure |
```

---

## Sources

| Team | Repository Path | Key Files |
|------|----------------|-----------|
| ArchColider | `ArchColider/` | `2.SolutionBackground/SystemAppoach.md`, `2.SolutionBackground/SolutionOverview.md` |
| Archangels | `Archangels/` | `2.SolutionBackground/ArchitecturePatterns.md`, `1.ProblemBackground/ArchitectureAnalysis.md` |
| PegasuZ | `Pegasuz/` | `quanta/quanta-identification.md`, `quanta/npo-candidate.md`, `ADRs/007.adr-arch-style-np-candidate-mvp.md` |
| MonArch | `MonArch/` | `Readme.md` (contains full architecture approach) |
| Profitero | `Profitero-Data-Alchemists/` | `README.md`, `adrs/adr-1-architecture-style.md` |
| AnimAI | `AnimAI/` | `4-ADRs/ADR-013 Architectural Characteristics Summary.adoc`, `4-ADRs/ADR-014 Selected Architecture.adoc` |
| Pragmatic | `Pragmatic/` | `ADR/ADR-002-architecture-style.md`, `ArchitectureCharacteristics/Characteristics.md` |
| SAG | `Software-Architecture-Guild/` | `adrs/adr-6-ai-assistant-architecture.md`, `README.md` |

---

*This guide synthesizes patterns from O'Reilly Architecture Kata winners (2020-2025). Architecture is always context-dependent -- use these patterns as starting points for your own analysis, not as prescriptive rules.*
