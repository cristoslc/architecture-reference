# MonitorMe -- Comparative Analysis

**Challenge:** O'Reilly Architecture Katas, Winter 2024 Season
**Teams Analyzed:** 7
**Domain:** On-premises medical patient monitoring for StayHealthy, Inc.

---

## Challenge Overview

StayHealthy, Inc., an established medical software company with two existing cloud-based SaaS products (MonitorThem for analytics and MyMedicalData for patient records), required an architecture for **MonitorMe** -- an on-premises medical patient monitoring system deployed to individual hospital locations. The system must:

- Ingest vital sign data from **8 device types** (heart rate at 500ms, ECG at 1s, blood pressure at 1hr, etc.)
- Display consolidated patient data on **nurse station screens** with sub-1-second average response time
- Support **up to 500 patients** per installation across up to 25 nurse stations (20 patients each)
- **Analyze vital signs** for anomalies with context-aware thresholds (awake vs. asleep)
- **Alert medical professionals** via both nurse station screens and a mobile app
- Store 24 hours of vital sign history with filtering capabilities
- Enable **snapshot uploads** to MyMedicalData via secure HTTP API
- Remain operational when **individual devices or software components fail**
- Operate entirely **on-premises** with proprietary StayHealthy hardware

The challenge combines real-time streaming, fault tolerance, data integrity, and healthcare domain constraints -- making architecture style selection and deployment strategy central concerns.

---

## Team Comparison Matrix

| Dimension | BluzBrothers (1st) | Mighty Orbots (2nd) | Architects Evolution Zone (3rd tied) | LowCode (3rd tied) | InfyArchs (Runner-up) | Safezone Cartons (Runner-up) | Systems Savants (Runner-up) |
|---|---|---|---|---|---|---|---|
| **Architecture Style** | Event-driven | Microservices + Event-driven hybrid | Event-driven | Event-driven + Distributed system | Microservices + Event-driven | Event-driven + Service-based | Microservices + Event-driven |
| **Team Size** | 4 | Not specified | 5 | 5 | 4 | 3 | 4 |
| **ADR Count** | 20 | 5 | 12 | 3 | 12 | 12 | 11 |
| **Top Quality Attributes** | Performance, Fault tolerance, Availability | Availability, Data integrity, Data consistency | Responsiveness, Fault tolerance, Performance | Concurrency, Availability, Data integrity | Fault tolerance, Availability, Data integrity | Availability, Performance, Agility | Interoperability, Real-time performance, High availability |
| **Event Broker** | Apache Kafka (ADR-015) | Implicit (event-driven for rule processing) | RabbitMQ (ADR-007) | Internal event bus | Kafka/Redpanda (ADR) | Telegraf pipeline | HiveMQ MQTT broker |
| **Database Strategy** | Time-series (InfluxDB) | Time-series + relational (rules/alerts) | NoSQL + in-memory cache | Embedded per-appliance | InfluxDB + PostgreSQL | InfluxDB | PostgreSQL |
| **Deployment** | Kubernetes on-premises | Not specified | On-premise server cluster | Distributed 3-node appliances | K3s on edge devices | Edge gateways + central hub | AWS Outposts (hybrid) |
| **C4 Diagrams** | C1, C2 | None | C1, C2, C3 | C1, C2 (per role) | C1, C2 (per system) | C1, C2 (per subsystem) | C1, C2 (simplified + expanded) |
| **Sequence Diagrams** | 4 use cases | 1 (transformation) | Multiple (alerting, CMS, storage) | 3 (Mermaid-embedded) | None | 1 (device to patient) | None |
| **UI Wireframes** | None | 7 screens | Desktop, mobile, CMS mockups | Deferred | None | None | Dashboard + mobile mockups |
| **Fitness Functions** | 3 (sizing, alerts, failover) | None | None | None | None | None | None |
| **Capacity Planning** | Full throughput calculations | None | None | None | None | Data amount calculations | Capacity planning data |
| **Video Presentation** | External link only | External link only | Yes (with transcript) | Yes (YouTube) | None | Yes (with transcript) | Yes (YouTube) |

---

## Architecture Style Choices

### Universal Agreement: Event-Driven at the Core

All seven teams converged on **event-driven architecture** as a foundational element. The MonitorMe problem domain -- continuous streams of vital sign data from multiple devices, real-time display requirements, and anomaly-triggered alerting -- is a textbook fit for event-driven patterns. Where teams diverged was in what they combined with event-driven and how they structured it.

### Pure Event-Driven (BluzBrothers, AchitectsEvolutionZone)

**BluzBrothers** (1st place) committed to a pure event-driven style, justified through their ADR-012 which scored event-driven at 14 stars against their selection criteria of elasticity, evolvability, and performance. They chose **Apache Kafka** as their broker (ADR-015), citing low latency, high scalability, and durability. Their top-3 characteristics -- Evolvability, Performance, and Elasticity (ADR-011) -- are a notable departure from most teams, deliberately *downplaying* scalability (ADR-008) and deployability (ADR-009) since the system has a fixed 500-patient ceiling. This was a mature scoping decision.

**AchitectsEvolutionZone** (3rd) also chose pure event-driven (ADR-012) but distinguished themselves with **RabbitMQ** as their message broker (ADR-007) and a dedicated **Device Gateway** component. Their emphasis on the physical communication layer -- with separate ADRs for wired communication to CMS (ADR-001), wired gateway-to-server communication (ADR-003), and WLAN paths (ADR-004, ADR-005) -- showed deeper engagement with the on-premises hardware realities.

### Microservices + Event-Driven Hybrid (Mighty Orbots, InfyArchs, Systems Savants)

Three teams combined microservices with event-driven patterns, each for different reasons:

**Mighty Orbots** (2nd) arrived at their hybrid through **usage-pattern analysis**. Their wireframe-driven discovery process revealed that fault tolerance for individual sensors naturally mapped to microservices (each sensor's status must not affect others), while the rule processing pipeline demanded event-driven flow. Their architecture has a clearer logical separation: microservices for data acquisition and administration, event-driven for the analysis-to-alert pipeline.

**InfyArchs** decomposed the system into **5 distinct software systems** (Vitals Monitoring, Metrics Capturing, Hospital, Administration, Alerting), each with its own architecture. This is the most granular decomposition of any team, treating each subsystem as a semi-independent product. They specified concrete technology choices at the component level: Go/Rust for data workers, React for UI, Node.js for APIs.

**Systems Savants** paired microservices with event-driven on **AWS Outposts**, creating a hybrid cloud approach for on-premises deployment. Their **MQTT protocol selection** (ADR-009) for IoT device communication is particularly relevant -- MQTT is purpose-built for constrained IoT devices and low-bandwidth scenarios, a choice none of the other teams made explicitly.

### Event-Driven + Distributed Hardware (LowCode)

**LowCode** (3rd) took the most distinctive approach by treating the **hardware architecture as a first-class design concern**. Their solution requires a minimum of 3 identical appliances with role-based behavior (Coordinator, Monitor, Analyzer) and automatic failover. When degraded to 2 nodes, the system continues fully; at 1 node, it drops the nurse station display but maintains analysis and alerting. This graceful degradation model (ADR-0001) is the most explicitly designed failover strategy of any team.

### Event-Driven + Service-Based (Safezone Cartons)

**Safezone Cartons** combined event-driven with **service-based architecture** and introduced an **edge gateway pattern** where processing happens at the nurse station level. This brings computation closest to the data source, ensuring the fastest possible local response while asynchronously synchronizing with a central hub. Their use of **Telegraf** (a plugin-driven server agent for collecting and reporting metrics) as the data processing layer is a pragmatic choice from the operations/monitoring world applied to healthcare.

---

## What Separated Winners from Runners-Up

### 1. Rigor of Decision Documentation

The single most visible differentiator is ADR depth and discipline:

- **BluzBrothers (1st): 20 ADRs** -- They documented not just what they decided, but what they *excluded*. ADRs for "scalability downplayed" (ADR-008), "deployability downplayed" (ADR-009), "patient registration out of scope" (ADR-005), and "mobile app out of scope" (ADR-013) demonstrate a team that understood that good architecture is as much about what you leave out as what you include. Their ADR-010 ("availability not used for architecture style selection") is especially notable -- they recognized availability as crucial but argued it should be addressed at the deployment level rather than influencing the software architecture style.
- **Mighty Orbots (2nd): 5 ADRs** -- Fewer in number but including a **superseded ADR** (data administration as input only, later replaced with input-and-output). This showed iterative thinking and willingness to evolve decisions visibly.
- **LowCode (3rd): 3 ADRs** -- The fewest ADRs of any placed team, but their distributed systems ADR (0001) is among the most impactful single decisions in the entire competition.

### 2. Quantitative Validation

**BluzBrothers** was the only team to provide **fitness functions** with concrete numeric proof that their architecture could meet requirements. Their infrastructure sizing calculation showed:

- Average throughput: 2,100 requests/second (4,000 peak) at ~4 MB/s
- Database write time (InfluxDB benchmark): 16ms for 4,000 events/s
- Kafka publish time: 4ms for 4MB/s
- LAN transfer: 32ms for 4MB
- **Total end-to-end: 693ms** (under the 1-second requirement)

This step-by-step breakdown -- from sensor to Kafka to database to nurse station -- is the kind of back-of-envelope calculation that separates architectural proposals from architectural *proof*. **Safezone Cartons** and **Systems Savants** also provided data calculations, but without the end-to-end timing validation.

### 3. Discovery Process and Requirements Decomposition

**Mighty Orbots** demonstrated the power of **UI-driven architecture discovery**. Their process of designing 7 wireframe screens before making architecture decisions led to surprising insights:

- The monitoring screen needed to be read-only, leading to a split between monitoring and admin screens
- The need for notification history led to a separate alerts database
- Patient-bed-hub relationships drove the decision toward a central database
- The patient history use case revealed bidirectional data flow, causing them to revise their data administration component (superseded ADR)

**BluzBrothers** used **Event Storming** to identify domain events and components before selecting their architecture style. This workshop-driven approach ensured their component boundaries aligned with actual domain flows.

### 4. Deployment Realism

The top teams addressed the on-premises constraint thoughtfully:

- **BluzBrothers**: Kubernetes with automated instance duplication (ADR-018, ADR-020), with specific instance counts for services
- **LowCode**: Custom distributed appliance design with auto-discovery and plug-and-play replacement
- **AchitectsEvolutionZone**: On-premise server cluster (ADR-011) with detailed infrastructure layout covering wired and wireless paths

Runner-up teams either over-engineered (Systems Savants proposing **AWS Outposts** introduces vendor lock-in and cost complexity for a hospital deployment) or under-specified deployment (Mighty Orbots had no deployment view at all).

---

## Common Patterns

### 1. Time-Series Database for Vital Signs

Five of seven teams selected or recommended a **time-series database** for storing vital sign readings. BluzBrothers, InfyArchs, and Safezone Cartons explicitly chose **InfluxDB**. Mighty Orbots selected a generic time-series database with detailed schema design. The rationale is consistent: high-throughput writes, native temporal querying, automatic data retention policies, and aggregation support align with the 24-hour rolling window requirement.

**AchitectsEvolutionZone** opted for **NoSQL** more broadly, and **Systems Savants** chose **PostgreSQL** -- the most relational choice, justified through their data integrity requirements.

### 2. Separation of Sensor Ingestion from Analysis

Every team separated the data ingestion pathway from the analysis/alerting pathway. The common insight: nothing should impede sensors from writing data. Analysis is a downstream consumer. This pattern manifests as:

- **BluzBrothers**: Vital Sign Recorder (writes) vs. Vital Sign Analyzer (reads + processes)
- **Mighty Orbots**: Ingestion pool (ELT writes) vs. Rule Alert Processor (analysis)
- **LowCode**: Monitor role (display) vs. Analyzer role (threshold detection)
- **Safezone Cartons**: Edge gateway (local processing) vs. Central hub (aggregated analysis)

### 3. Event-Driven for the Alert Pipeline

All teams implemented the anomaly-detection-to-alert flow as an event-driven pipeline. The pattern is: sensor data arrives as events, rule processors subscribe to relevant events, matched rules produce alert events, and notification services consume alert events to push to screens and mobile devices.

### 4. Nurse Station as a Distinct Architectural Boundary

Teams consistently treated the nurse station as a key architectural boundary. **BluzBrothers** (ADR-014) and **Mighty Orbots** explicitly separated the nurse station's monitoring concern from the admin/configuration concern. **Safezone Cartons** pushed computation to the nurse station level with edge gateways. **LowCode** treated the nurse station's display as the most expendable function during degraded operation -- the last thing sacrificed when nodes fail.

### 5. Security Deferred (Mostly)

Security was consistently acknowledged but deferred. **BluzBrothers** listed authentication/authorization as a postponed decision. **Mighty Orbots** noted it as a future iteration concern. **LowCode** addressed it most directly with wired connections, on-site storage, and encrypted databases. **Systems Savants** went furthest with a dedicated ADR for layered security (ADR-006). The common reasoning: the system is on-premises, behind hospital infrastructure, and the kata explicitly stated HIPAA compliance was not required.

---

## Unique Innovations Worth Highlighting

### BluzBrothers: Fitness Functions as Architectural Proof (1st Place)

The standout contribution from the winning team is their **three fitness functions** that move beyond theoretical architecture into testable assertions:

1. **Infrastructure Validation**: End-to-end timing calculation proving sub-1-second display (693ms)
2. **Alert Guarantee**: Verification that alert delivery remains reliable through redundant pathways
3. **Failover Validation**: Confirmation that single-device failure does not cascade

This approach transforms an architecture kata submission into something closer to an engineering specification. Combined with their **20 ADRs** and **Event Storming** artifacts, BluzBrothers demonstrated that *discipline of documentation* is itself an architectural quality.

### Mighty Orbots: Wireframe-Driven Architecture Discovery (2nd Place)

Mighty Orbots' method of using **UI wireframes to drive architectural decisions** is a repeatable technique for any team. Their four user personas (Nancy the Nurse, David the Doctor, Alice the Admin, Sarah the SysAdmin) grounded every design decision in real usage. Key discoveries that emerged from wireframes:

- The monitoring screen should be **read-only** -- leading to a clean separation of display and administration
- **Notification history** as a requirement led to a separate alerts database
- The **bed-hub-patient** relationship model emerged from the device management screen
- **Rules as a data structure** became the conceptual core, leading to the rule alert processor

Their **ELT pipeline decision** (ADR: sensor data is ELT) is also distinctive: by loading raw data immediately and transforming later, they prioritized data integrity and consistency over processing efficiency.

### Mighty Orbots: Rule Processing Engine

The three-trigger-type rule system (state triggers, threshold triggers, change triggers) is the most detailed analysis engine proposed by any team. Each trigger type has configurable latency, escalation timing, and resolution actions. This level of specificity in alert rule design shows thinking beyond architecture into product design.

### AchitectsEvolutionZone: HL7 Healthcare Protocol Adoption (3rd Place)

**HL7 (Health Level Seven)** is the established standard for healthcare data interoperability. AchitectsEvolutionZone was the only team to reference a real healthcare communication standard (ADR-002). While the kata specified proprietary StayHealthy devices, adopting HL7 at the Device Gateway level demonstrates forward-thinking about interoperability: if StayHealthy ever opens their platform to third-party devices, the HL7 foundation makes this trivial. This is a domain-aware decision that reflects healthcare industry knowledge.

### AchitectsEvolutionZone: Full C4 to Component Level

They were the only team to produce **C3 component-level diagrams**, showing internal component interactions within containers. While C1 and C2 were common, drilling to C3 provided visibility into how services within a container communicate -- valuable for the implementation team.

### LowCode: Hardware-First Distributed Architecture (3rd Place)

LowCode's **3-node identical appliance model** with role-based behavior is the most innovative hardware architecture proposal. The graceful degradation model is operationally elegant:

| Active Nodes | Available Roles | Nurse Station | Alerting |
|---|---|---|---|
| 3 | Coordinator + Monitor + 2x Analyzer | Full function | Full function |
| 2 | Coordinator + Monitor + Analyzer | Full function | Full function |
| 1 | Analyzer only | **Down** | Full function |

The **auto-configuration sequence** for plug-and-play appliance replacement (detailed in their Mermaid sequence diagram) means a hospital technician can swap a failed node without software expertise. This is the most operationally practical design for a healthcare environment.

### InfyArchs: IoT Edge Computing with K3s

InfyArchs' choice of **K3s** (lightweight Kubernetes) for edge device orchestration, managed centrally via **Rancher** with **GitOps** deployment, represents the most modern DevOps-oriented approach. Their decomposition into 5 independent software systems, each with its own container and deployment views, makes the solution modular at the system level rather than just the service level.

### Safezone Cartons: Edge Gateway with Data Calculations

Safezone Cartons' **edge gateway architecture** processes data at the nurse station before sending it to the central hub asynchronously. Their detailed **data amount calculations** (showing ~1.09 GB per day per fully-occupied nurse station across all 8 vital sign types) provided concrete evidence for their storage and bandwidth decisions. Their **QR code device registry flow** for patient-device association via mobile app is a practical workflow innovation.

### Systems Savants: MQTT for IoT Communication

Systems Savants was the only team to select **MQTT** (ADR-009) as the device communication protocol. MQTT's publish-subscribe model, small packet overhead, and built-in quality-of-service levels make it the standard IoT protocol -- a technically sound choice for connecting medical monitoring devices. Their use of **HiveMQ** as the MQTT broker adds enterprise-grade clustering and monitoring.

### Systems Savants: Team Topologies Thinking

Along with BluzBrothers (who included a Team Topologies section), Systems Savants considered organizational design alongside technical design. BluzBrothers explicitly documented team structure aligned to their architecture, following Conway's Law principles. This is a dimension most kata teams overlook entirely.

---

## Lessons for Practitioners

### 1. Document What You Exclude, Not Just What You Include

BluzBrothers' approach of writing ADRs for characteristics they *downplayed* (scalability, deployability) and features they declared *out of scope* (patient registration, mobile app, sensor hardware) is a practice worth adopting universally. These "negative space" decisions are where scope creep lives. Making them explicit forces the team to articulate *why* something is not a priority -- and gives stakeholders a clear record to revisit when priorities change.

### 2. Let UI Wireframes Drive Architecture Discovery

Mighty Orbots demonstrated that designing screens before components reveals architectural truths that abstract analysis misses. The read-only monitoring screen, the need for notification history, and the bidirectional data administration pattern all emerged from thinking about how nurses and doctors actually use the system. For any system with human operators, this approach can surface requirements that pure domain modeling overlooks.

### 3. Prove Your Architecture with Numbers

Only one of seven teams (BluzBrothers) provided end-to-end timing calculations. In a domain where sub-1-second response time is a stated requirement and "human lives are at stake," this gap is concerning. Fitness functions and back-of-envelope throughput calculations are lightweight activities that dramatically increase architectural credibility. Safezone Cartons and Systems Savants provided partial calculations -- but the winning team was the only one to close the loop from sensor to screen.

### 4. On-Premises Demands Explicit Deployment Architecture

The on-premises constraint was a differentiator. Teams that addressed it concretely (BluzBrothers with Kubernetes, LowCode with distributed appliances, AchitectsEvolutionZone with infrastructure layouts) placed higher than those who either ignored it (Mighty Orbots had no deployment view) or over-relied on cloud abstractions (Systems Savants' AWS Outposts introduces dependencies unusual for a hospital installation). For on-premises systems, the deployment architecture *is* the architecture.

### 5. Healthcare Domain Knowledge Creates Differentiation

AchitectsEvolutionZone's adoption of **HL7** and Systems Savants' selection of **MQTT** for IoT communication show that domain-specific protocol knowledge matters. These are not just technically sound choices -- they signal to stakeholders that the team understands the ecosystem their software inhabits. For any kata challenge, investing time to research the target domain's established standards and protocols pays dividends.

### 6. Event-Driven Is Not a Complete Answer

While all seven teams correctly identified event-driven architecture as essential, the top teams recognized it as necessary but not sufficient. The winning teams all layered additional concerns on top: hardware failover (LowCode), data pipeline strategy (Mighty Orbots' ELT), caching for alert performance (AchitectsEvolutionZone, BluzBrothers), and deployment orchestration (BluzBrothers, InfyArchs). Architecture style selection is the beginning of the design process, not the end.

### 7. Graceful Degradation Trumps Binary Availability

LowCode's 3-2-1 node degradation model is the clearest example, but BluzBrothers (ADR-018, ADR-020 on duplicate instances) and Mighty Orbots (independent sensor processing) also designed for partial failure. In a medical monitoring system, the question is not "is the system up?" but "which capabilities remain available?" Designing for graceful degradation -- explicitly mapping what works at each failure level -- is more valuable than claiming "high availability" without specifics.

### 8. Iteration and Supersession Show Mature Thinking

Mighty Orbots' **superseded ADR** (data administration as input-only, later revised to input-and-output) is worth calling out. Showing that you changed your mind, and documenting *why*, demonstrates a healthy design process. It builds confidence that the final architecture has been stress-tested against alternatives. Teams should preserve superseded decisions rather than hiding them.

---

*Analysis based on submissions to the O'Reilly Architecture Katas, Winter 2024 season. Team repositories and catalog entries sourced from the kata-log reference collection.*
