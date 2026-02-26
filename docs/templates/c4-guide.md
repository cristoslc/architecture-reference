# C4 Diagramming Guide: Patterns from Architecture Kata Winners

This guide extracts C4 diagramming best practices from eight exemplary O'Reilly Architecture Kata submissions. Each team studied placed 1st, 2nd, or runner-up, and their use of C4 diagrams is a significant contributing factor to that success.

**Teams studied:**

| Team | Placement | Season | Kata Problem |
|------|-----------|--------|--------------|
| Archangels | 1st | Fall 2021 | Farmacy Family |
| Sever-Crew | 2nd | Fall 2021 | Farmacy Family |
| Pentagram2021 | Runner-up | Fall 2021 | Farmacy Family |
| Global-Variables | 3rd | Spring 2022 | Spotlight (Diversity Cyber Council) |
| Arch8s | Runner-up | Spring 2022 | Spotlight (Diversity Cyber Council) |
| Celus-Ceals | 1st | Fall 2023 | Wildlife Watcher |
| ZAITects | 1st | Winter 2025 | Certifiable, Inc. |
| Pragmatic | 1st | Fall 2024 | ClearView |

---

## Why C4 Diagrams Correlate with Winning

Across the eight teams examined, every single one used C4 as their primary architectural visualization approach. This is not coincidence. C4 diagrams provide three things judges consistently reward:

1. **Progressive disclosure** -- Judges can quickly orient themselves at Level 1 (Context), then drill into areas of interest at Level 2 (Container) and Level 3 (Component). This respects the judges' limited review time.

2. **Vocabulary precision** -- C4 provides exact terminology (Person, Software System, Container, Component) that eliminates ambiguity. When Archangels references a "Container," judges know it means a separately deployable unit, not a Docker container.

3. **Completeness signal** -- A team that produces C1 through C3 diagrams demonstrates they have thought through the architecture at multiple abstraction levels, from stakeholder concerns down to module internals. This signals depth of analysis.

**Key finding:** All eight top-placing teams produced at least C1 (System Context) and C2 (Container) diagrams. Teams that additionally produced targeted C3 (Component) diagrams for their most complex subsystems -- rather than blanket C3 coverage -- placed highest.

---

## C4 Levels Observed Across Submissions

| Team | C1 Context | C2 Container | C3 Component | C4 Code | Deployment | System Landscape |
|------|:----------:|:------------:|:------------:|:-------:|:----------:|:----------------:|
| Archangels | Yes | Yes | Yes (3 domains) | No | Yes (separate) | No |
| Sever-Crew | Yes (baseline + target) | Yes (baseline + target) | No | No | Yes | No |
| Pentagram2021 | Yes | Yes (2 views) | Yes | No | Yes | Yes |
| Global-Variables | Yes | Yes | No | No | Yes (CI/CD) | No |
| Arch8s | Yes | Yes | Yes (2 views) | Skipped explicitly | Yes | No |
| Celus-Ceals | Yes | Yes | Yes (11 per-container) | No (TODO noted) | No | No |
| ZAITects | No explicit C1 | Yes (C2 per use case) | Yes (1 preliminary) | No | No | No |
| Pragmatic | Yes | Yes | Yes (4 containers) | No | No | No |

**Observations:**

- **C1 + C2 is the baseline.** Every winning team produces at least these two levels. If you produce nothing else, produce these.
- **C3 is selective, not exhaustive.** The best teams (Archangels, Celus-Ceals, Pragmatic) produce C3 diagrams only for containers that are architecturally significant -- those with complex internal structure, critical integration points, or novel patterns.
- **C4 (Code) is universally skipped.** Arch8s explicitly noted "Level 4. Code (skipped)" in their documentation. At the kata level, code diagrams add no value and consume time.
- **Deployment diagrams appear separately.** Teams like Pentagram2021 and Sever-Crew treat deployment as a distinct view rather than a C4 level, which is consistent with Simon Brown's C4 model documentation.
- **System Landscape is rare but powerful.** Only Pentagram2021 included a System Landscape diagram (showing all software systems in the enterprise context). This was effective for the Farmacy problem where multiple pre-existing systems needed to be shown.

---

## Tooling Comparison

| Tool | Teams Using It | Strengths | Weaknesses |
|------|---------------|-----------|------------|
| **Structurizr DSL** | Pentagram2021, Arch8s | Model-as-code; generates all C4 levels from a single source; views, styles, and deployment are all co-located; supports animation sequences | Learning curve; requires tooling setup; rendered output can look generic |
| **PlantUML (C4-PlantUML)** | Arch8s | Text-based; version-control friendly; uses the C4-PlantUML stdlib for correct notation; good for CI rendering | Verbose syntax; layout control is limited; diagrams can become cluttered |
| **Draw.io** | Pragmatic, Archangels (Excalidraw) | Visual WYSIWYG editing; easy for non-technical stakeholders to read; precise layout control; `.drawio` files are XML and version-controllable | Manual effort to maintain consistency across diagrams; no model validation; easy to deviate from C4 notation |
| **Image-only (PNG/JPG)** | Sever-Crew, Global-Variables, Celus-Ceals, ZAITects | No tooling required; any drawing tool works | Not editable from repo; no model-as-code benefits; inconsistent notation possible |

**Recommendation:** For a kata submission, use whatever tool you can move fastest with. Structurizr DSL provides the highest fidelity to the C4 model and produces the most consistent output, but a hand-drawn Draw.io diagram that communicates clearly beats a half-finished Structurizr model every time.

### Structurizr DSL: Pattern from Pentagram2021

Pentagram2021 authored a complete Structurizr DSL workspace that generated all their diagrams from a single source file. This is the gold standard for C4 tooling:

Source: `/Pentagram2021/models/c4/c4model.txt`

Key structural patterns in their DSL:
- Persons defined with role descriptions and visual tags (`"Customer"`, `"Transactional Customer"`)
- Software systems grouped inside an `enterprise` block
- Containers and components nested within their parent software system
- Relationships defined between all elements with protocol annotations (`"JSON/HTTPS"`, `"JDBC"`)
- Deployment environment with specific infrastructure nodes (`"Ubuntu 16.04 LTS"`, `"AWS RDS - Postgres 12.8"`)
- Styles section with distinct colors for internal vs. existing/external systems
- Database elements styled with `shape Cylinder`, mobile with `shape MobileDeviceLandscape`

### PlantUML C4: Pattern from Arch8s

Arch8s used the `C4-PlantUML` stdlib, which enforces correct C4 notation through macros:

Source: `/Arch8s/assets/plantuml/context.puml`

```plantuml
@startuml Spotlight context diagram
!includeurl https://raw.githubusercontent.com/RicardoNiepel/C4-PlantUML/release/1-0/C4_Context.puml

title Context diagram for Spotlight platform
LAYOUT_WITH_LEGEND()

Person(community_leader, "Community Leader", "A platform administrator for DCC Spotlight")
Person(candidate, "Candidate", "a person with certain need")
Person_Ext(visitor, "Visitor", "a person with interest")

System_Boundary(diversity_cyber_council, "Diversity Cyber Council") {
    System(spotlight, "Spotlight", "Drives the business logic and enforces constraints")
}

System_Ext(ses, "Notification service", "Handles push notifications and transactional emails")
System_Ext(rds, "Database", "Handles data persistance")

Rel(community_leader, spotlight, "Supports and Reviews NPOs")
Rel(candidate, spotlight, "Applies for and consumes services")
Rel(spotlight, ses, "(Optionally) sends notifications via ")

@enduml
```

Key patterns:
- `Person` vs. `Person_Ext` distinguishes internal from external actors
- `System_Boundary` groups the system under design
- `System_Ext` marks external dependencies
- `LAYOUT_WITH_LEGEND()` auto-generates a C4 key
- Relationship labels describe the *purpose* of communication, not just "calls"

---

## Best Practices from Top Teams

### System Context (C1) Patterns

The System Context diagram answers: "What is the system, who uses it, and what does it depend on?"

**What the best C1 diagrams include:**

1. **All actor types, clearly distinguished.** Archangels and Sever-Crew both identify distinct persona categories (e.g., "Transactional Customer" vs. "Engaged Customer," "Medical Provider" vs. "Dietician"). Pragmatic derives actors directly from Event Storming outputs.

2. **The system boundary.** The system under design is shown as a single box. Pentagram2021 uses `System_Boundary`, Arch8s uses the same PlantUML construct. Every team draws a clear line between "what we are building" and "what already exists."

3. **External systems with purpose labels.** Sever-Crew labels external systems like "Farmacy Food System" with descriptions of their role. Pragmatic identifies "HR System," "AI System," "Billing System," "Mail Server," and "Survey System" as distinct external entities.

4. **Baseline vs. Target architecture.** Sever-Crew (2nd place, Fall 2021) produced both a baseline and a target C1 diagram. This is a powerful technique: showing what exists today vs. what the proposed solution looks like. It immediately communicates the scope of change.

**What to avoid at C1:**
- Do not show internal containers or components at this level
- Do not show technology choices (no "Spring Boot" or "React" labels)
- Do not show databases as separate systems unless they are truly external (e.g., a third-party analytics platform)

**Template -- Minimum C1 elements:**

| Element | Example from Pragmatic |
|---------|----------------------|
| Primary actors | Job Candidate, Hiring Manager, Employer, Administrator |
| The system | ClearView |
| External systems | HR System, AI System, Billing System, Mail Server, Survey System |
| Relationship labels | "uploads resumes," "verifies credentials," "sends notifications" |

### Container (C2) Patterns

The Container diagram answers: "What are the major technical building blocks and how do they communicate?"

**What the best C2 diagrams include:**

1. **Clear container types.** Pragmatic separates containers by domain responsibility: Story Container, Matching Container, HR Integration, Analytics. Sever-Crew identifies: Social Network Module, Customer Profile Module, Webinars Module, eDietician Module, plus reused Farmacy Foods containers.

2. **Technology annotations on containers.** Arch8s labels containers with technology: `Container(spa_app, "Single Page Application", "Javascript, ReactJS", "Provides WEB interface")`. Pentagram2021's Structurizr model includes `"Spring Boot MVC"` and `"JavaScript and React"`.

3. **Communication protocols on relationships.** The Pentagram2021 model annotates relationships with protocols: `"JSON/HTTPS"`, `"JDBC"`, `"XML/HTTPS"`. This level of specificity is what judges look for at C2.

4. **Message buses and event topics.** Pragmatic shows a Matches topic connecting containers asynchronously. Sever-Crew shows AWS Kafka as an event streaming integration layer. This pattern is critical for event-driven architectures.

5. **Shared vs. dedicated databases.** Pragmatic explicitly notes that multiple services share a database (per ADR-014), while Sever-Crew assigns specific AWS data services (RDS, DynamoDB, S3) to different modules. Both approaches are valid when documented via ADR.

6. **Cross-references to ADRs.** Every top team links C2 elements to their Architecture Decision Records. Pragmatic references ADR-002 (architecture style), ADR-014 (shared database), and ADR-016 (event topics) directly in the C2 documentation.

**What to avoid at C2:**
- Do not show component-level detail (individual classes, modules, or services within a container)
- Do not omit the actors -- carry them down from C1 so the diagram stands alone
- Do not show only the "happy path" -- include error-handling infrastructure (dead-letter queues, retry mechanisms) if they are architecturally significant

**Common C2 container patterns observed:**

| Pattern | Teams Using It |
|---------|---------------|
| API Gateway fronting backend services | Sever-Crew, Pentagram2021, Arch8s |
| SPA + Mobile App as separate client containers | Arch8s, Pentagram2021, Sever-Crew |
| Event bus / message broker as integration container | Sever-Crew (Kafka), Pragmatic (Match Topic), Pentagram2021 (Event Bus) |
| Separate containers per bounded context / domain | Archangels, Celus-Ceals, Pragmatic |
| Shared database between related services | Pragmatic (explicit ADR), Arch8s |
| Dedicated data stores per service | Sever-Crew, Celus-Ceals |

### Component (C3) Patterns

The Component diagram answers: "What are the internal modules of a specific container and how do they collaborate?"

**Selective C3 is better than exhaustive C3.** The winning teams only produce C3 diagrams for containers where the internal decomposition is architecturally interesting.

**Which containers get C3 diagrams:**

| Team | C3 Diagrams Produced | Rationale |
|------|---------------------|-----------|
| Archangels | Medical Management, User Management, Analytics Management | Each domain has distinct security and data access patterns |
| Arch8s | Backend API (full), Notifications (focused) | Shows how 20+ modules organize within a monolithic API |
| Celus-Ceals | 11 individual container diagrams (one per service) | Microservices architecture -- each service is small enough for a single C3 |
| Pragmatic | Job Candidate, Story, Matching, HR Integration | Each addresses a distinct architectural challenge (AI integration, event-driven matching, multi-system HR adapters) |
| ZAITects | ASAS Grader (preliminary) | AI processing pipeline with novel grader/judge separation |

**What the best C3 diagrams include:**

1. **Data flow narratives.** Pragmatic accompanies every C3 diagram with a numbered data flow description:
   > 1. The Job candidate requests resume tips through the Job candidate API.
   > 2. The Job candidate API forwards the request to the Resume Service.
   > 3. The Resume Service interacts asynchronously with the AI Resume Tips Adapter...

   This transforms the diagram from a static picture into a walkthrough that judges can follow.

2. **Adapter patterns for external integrations.** Pragmatic's HR Integration C3 shows dedicated adapters per HR system (SAP SuccessFactors, Workday), with a dead-letter queue retry mechanism. This demonstrates interoperability thinking.

3. **Explicit async boundaries.** When a component communicates asynchronously (via queue or event), the best teams mark this clearly. Pragmatic labels async interactions and references ADR-005 (async with external systems).

4. **ADR cross-references at the component level.** Archangels links specific components to ADRs (e.g., "005 use-crypto-shredding" for the Medical domain, "004 use-inbox-outbox-pattern" for inter-component communication).

**Celus-Ceals' per-container C3 pattern:**

Celus-Ceals (1st, Fall 2023) took a distinctive approach: they created a separate markdown page for every container, each with its own C3 diagram image. Example containers documented:
- Auth Service
- Camera Manager
- Camera Integration Service
- Dataset Manager
- ML Training Manager
- Notification Service
- iNaturalist Integration
- GBIF Integration
- Labelling Platform Integration
- User Preferences
- Camera Metadata Manager

This works well for microservices architectures where each container is relatively small. For monolithic or service-based architectures, the Archangels/Pragmatic approach of grouping by domain is more effective.

**What to avoid at C3:**
- Do not produce C3 diagrams for every container -- focus on the architecturally significant ones
- Do not show implementation details (class names, method signatures) -- that belongs at C4/Code level
- Do not lose the external context -- show which actors or other containers interact with the components

### Deployment (C4/Infrastructure) Patterns

Deployment diagrams show how containers map to infrastructure. Not all teams produce these, but those that do gain a significant advantage in demonstrating feasibility.

**Pentagram2021's Structurizr deployment (gold standard):**

From their DSL model, they define a complete `deploymentEnvironment "Production"` block:
- Customer's mobile device (iOS/Android) hosting the Mobile App container instance
- Customer's computer with Web Browser hosting the SPA container instance
- Server infrastructure with specific OS versions (`"Ubuntu 16.04 LTS"`) and middleware (`"Apache Tomcat 8.x"`)
- Database primary/secondary replication: `primaryDatabaseServer -> secondaryDatabaseServer "Replicates data to"`
- Instance counts specified: `"" 4` for web servers, `"" 8` for API servers
- Failover nodes styled with `opacity 25` for visual distinction

**Sever-Crew's AWS deployment pattern:**

Sever-Crew maps each C2 container to specific AWS services:
- Social Network Module -> EC2 + RDS
- AI Modules (eDietician, Inventory) -> Lambda + Forecast + RDS + DynamoDB
- Analytics -> Glue (ETL) + Athena
- Profile Module -> Lambda + RDS
- Clinics Gateway -> Lambda + DynamoDB + API Gateway + Transit Gateway (VPN)
- Central storage -> S3
- Integration layer -> Managed Kafka (MSK)

**Arch8s' cloud infrastructure checklist:**

Arch8s provides a comprehensive list of AWS services organized by function:
- Identity: IAM, Cognito
- Compute: ECS (Docker), Lambda
- Storage: S3, ECR
- Database: Aurora PostgreSQL
- Networking: API Gateway, ELB, Route53, VPC
- Monitoring: CloudWatch, CloudTrail
- Security: Systems Manager (vault)

**What to show in deployment diagrams:**
- Network boundaries (VPC, subnets, security groups)
- Redundancy and failover (multi-AZ, primary/secondary databases)
- Auto-scaling groups or serverless scaling characteristics
- CDN and API Gateway layers
- Data replication flows

---

## Common C4 Mistakes

Based on patterns observed across all submissions (not limited to winners):

1. **Skipping C1 entirely.** ZAITects jumped directly to C2 per use case. While their content was excellent, the lack of a single system-level context view makes it harder for judges to get oriented. Always start with C1.

2. **Technology on C1 diagrams.** The System Context diagram should be technology-agnostic. Labels like "React SPA" or "PostgreSQL" do not belong at this level -- save them for C2.

3. **Inconsistent notation.** Teams that use PNG images from different tools (some from Draw.io, some from Miro, some screenshots) produce visually inconsistent diagrams. Pick one tool and use it for all C4 diagrams.

4. **Missing legends.** Arch8s includes `LAYOUT_WITH_LEGEND()` in every PlantUML diagram. Archangels provides a dedicated C4 Model Key image. Celus-Ceals has a separate Legend page. Diagrams without legends force judges to guess what colors and shapes mean.

5. **Labeling relationships with "calls" or "uses."** The best teams label relationships with the *purpose* of the interaction: "Sends notifications via," "Stores user profiles," "Publishes match events to." Generic labels like "uses" or "calls" waste diagram space.

6. **Exhaustive C3 coverage.** Producing a C3 diagram for every container dilutes the signal. Focus C3 effort on the containers that embody your most important architectural decisions.

7. **Orphaned diagrams.** Diagrams that are not referenced from the README or linked to ADRs lose their context. Every C4 diagram should be embedded in a narrative that explains what it shows and why the design decisions were made.

8. **No data flow description.** A diagram alone is insufficient. Pragmatic's practice of numbering each data flow step as a textual walkthrough alongside the diagram is a pattern worth copying.

---

## Template: Minimum Viable C4 for a Kata Submission

To be competitive, produce at minimum the following:

### 1. System Context Diagram (C1) -- Required

**Must include:**
- All human actors who interact with the system, with role descriptions
- The system under design as a single labeled box
- All external systems the solution depends on or integrates with
- Labeled relationships describing the purpose of each interaction
- A legend explaining notation (colors, shapes, line styles)

**Format:** One diagram. Embed it in your main README or a dedicated architecture page. Accompany it with a table listing each actor and external system with a one-line description.

**Time budget:** 1-2 hours

### 2. Container Diagram (C2) -- Required

**Must include:**
- All major containers (web app, mobile app, API services, databases, message brokers, external service adapters)
- Technology labels on each container (language, framework, database engine)
- Communication protocols on relationships (HTTPS, gRPC, AMQP, JDBC)
- Actors carried down from C1
- External systems carried down from C1

**Format:** One primary diagram. If the system has distinct subsystems (e.g., a separate analytics platform), produce a focused C2 for each subsystem as Pentagram2021 did with their Data Lake container view.

**Time budget:** 2-3 hours

### 3. Component Diagrams (C3) -- Selective, Highly Recommended

**Produce C3 for containers that:**
- Have complex internal structure (more than 3-4 internal modules)
- Embody your most important architectural decisions
- Handle critical quality attributes (security, fault tolerance, scalability)
- Integrate with multiple external systems

**Must include:**
- Internal components with responsibility descriptions
- Data flow narrative (numbered steps)
- Cross-references to relevant ADRs
- External actors and systems that interact with the components

**Format:** One page per C3 diagram. Include both the diagram and the data flow walkthrough.

**Time budget:** 1-2 hours per diagram; produce 2-4 diagrams total

### 4. Deployment View -- Recommended

**Include if:**
- Your architecture has non-trivial infrastructure requirements
- You are using cloud-native services that judges may not be familiar with
- Redundancy, scaling, or security boundaries are key to your design

**Must include:**
- Mapping of containers to infrastructure nodes
- Network boundaries (VPC, subnets)
- Scaling characteristics (auto-scaling groups, serverless)
- Data replication topology

**Time budget:** 1-2 hours

### Total Minimum Time Investment: 5-9 hours

This is substantial but proportional to the return. Teams that invest in C4 diagrams consistently outperform teams that rely on ad-hoc box-and-line diagrams.

---

### Quick Reference: C4 Notation Checklist

Use this checklist before submitting:

- [ ] C1 Context diagram present and embedded in documentation
- [ ] C1 shows all actors with role descriptions
- [ ] C1 shows all external system dependencies
- [ ] C1 has no technology labels (those belong at C2)
- [ ] C2 Container diagram present
- [ ] C2 includes technology labels on every container
- [ ] C2 includes protocol labels on relationships
- [ ] C2 carries actors and external systems down from C1
- [ ] C3 Component diagrams present for 2-4 key containers
- [ ] C3 diagrams include data flow narratives
- [ ] C3 diagrams cross-reference ADRs
- [ ] All diagrams have legends
- [ ] All diagrams are embedded in markdown with explanatory text
- [ ] Consistent tool and notation used across all diagrams
- [ ] Deployment view present (if applicable)

---

### Source File Locations

For reference, the actual C4 artifacts from each team can be found at:

| Team | C4 Documentation | Diagram Source Files |
|------|-----------------|---------------------|
| Archangels | `Archangels/3.ViewsAndPerspectives/C4Models/README.md` | `Archangels/assets/diagrams/` (PNG, Excalidraw) |
| Sever-Crew | `Sever-Crew/README.md` (inline) | `Sever-Crew/images/` (JPG, PNG) |
| Pentagram2021 | `Pentagram2021/solution/solutionOverview.md` | `Pentagram2021/models/c4/c4model.txt` (Structurizr DSL), `Pentagram2021/images/structurizr-*.png` |
| Global-Variables | `Global-Variables/README.md` (Section 6.iii) | `Global-Variables/docs/system-context.jpg`, `Global-Variables/docs/container-diagram.jpg` |
| Arch8s | `Arch8s/4.Views/4.4.C4Models/README.md` | `Arch8s/assets/plantuml/*.puml`, `Arch8s/assets/spotlight-c4.dsl` (Structurizr DSL) |
| Celus-Ceals | `Celus-Ceals/4.Solution/1.FirstIteration/C4Models/README.md` | `Celus-Ceals/4.Solution/1.FirstIteration/C4Models/` (per-container markdown + PNG) |
| ZAITects | `ZAITects/README.md` (inline C2/C3) | `ZAITects/assets/test1c2.png`, `ZAITects/assets/test2c2.png`, `ZAITects/assets/test1-grader-c3.jpg` |
| Pragmatic | `Pragmatic/C4/` (dedicated directory) | `Pragmatic/C4/images/C4.drawio` (Draw.io source), `Pragmatic/C4/images/*.svg` |
