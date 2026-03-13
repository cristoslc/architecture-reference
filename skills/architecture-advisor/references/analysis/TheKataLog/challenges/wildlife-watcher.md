# Wildlife Watcher -- Comparative Analysis

> **Challenge:** Fall 2023 | **Teams analyzed:** 3 | **Kata sponsor:** Wildlife.ai

## Challenge Overview

Wildlife.ai, a charitable trust using AI to accelerate wildlife conservation, needed an open-source wildlife camera system that triggers on animal movement, identifies species on-device using AI, and reports observations in near real-time to biologists. The challenge posed a rare combination of constraints: edge computing on ultra-low-power microcontrollers (up to 512KB Flash), unreliable connectivity (LoRaWAN, 3G, satellite), tight budgets befitting a nonprofit, open-source requirements, and integration with a constellation of third-party platforms (iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite).

This kata tested teams on their ability to balance cost-consciousness with architectural sophistication, handle the gap between edge and cloud, and design for extensibility within an open-source ecosystem.

## Team Comparison Matrix

| Dimension | Celus Ceals (1st) | Rapid Response (2nd) | Wonderous Toys (3rd) |
|---|---|---|---|
| **Architecture Style** | Microservices | Microservices (deployable as monolith) | Modular Monolith + Micro Kernel + Event-Driven |
| **Team Size** | 3 | 3 | Not specified |
| **ADR Count** | 15 | 8 | 6 |
| **Top Quality Attribute** | Availability | Availability | Feasibility / Cost-effectiveness |
| **Diagram Approach** | C4 (system context, container, individual) | Architecture overview + Deployment + Sequence (Mermaid) | Architecture style mapping + Event storming + Module use cases |
| **Connectivity Handling** | Via camera integration service with queue | Images-over-3G analysis with LoRaWAN bandwidth math | Bluetooth LE + LoRaWAN/3G/Satellite via Pub/Sub |
| **3rd-Party Integration Strategy** | Dedicated integration containers per platform with comparative tool analysis | Dedicated services (External Labeling, ML Candidates) | Micro kernel plugin architecture |
| **Feasibility Analysis** | Yes | No | Yes |
| **Video Presentation** | No | No | No |

## Architecture Style Choices

### The Microservices Approaches

Two of the three placing teams chose microservices, but with strikingly different levels of pragmatism about deployment reality.

**Celus Ceals (1st)** selected microservices through a scored evaluation in ADR-007, comparing microservices, event-driven, and modular monolith against scalability, elasticity, extendability/evolvability, and modularity/domain partitioning. Microservices scored 20 versus 15 for event-driven and 8 for modular monolith. They acknowledged the negative trade-off explicitly: "Implementation is harder because it lacks simplicity. We need to take care of network communication issues between services."

**Rapid Response (2nd)** took the most pragmatic deployment stance. While designing six well-defined microservices, their ADR on Monolith/Microservices explicitly decided to deploy five of the six as a cohesive monolith, keeping only the Camera Feed Engine separate for independent scaling. Their rationale was direct: "This decision is made based on requirements, which state hundreds of users." This monolith-first-with-extraction-path approach recognized that operational complexity of distributed systems was unjustified at the current scale.

### The Hybrid Alternative

**Wonderous Toys (3rd)** made the most architecturally distinctive choice: a hybrid of modular monolith, micro kernel, and event-driven styles. This was not ad hoc -- each style mapped to a specific concern. The modular monolith handled the core application (ADR-002, emphasizing cost-effectiveness and simplicity for a charitable trust). The micro kernel pattern (ADR-005) specifically addressed the integration module, treating each third-party integration as a plugin with a standard facade. Event-driven architecture (ADR-001) handled camera alerts via GCP Pub/Sub, addressing the unreliable connectivity constraint.

## What Distinguished the Top Teams

### 1. Depth of Third-Party Integration Analysis

The single most differentiating factor was how teams handled the constellation of external tools. The challenge required integrating with at least six categories of third-party services, and the placing teams treated this as a first-class architectural concern rather than a hand-wave.

**Celus Ceals** produced a detailed comparative analysis of all third-party tools, evaluating labelling platforms (Wildlife Insights, TrapTagger, Trapper) across deployment model, scalability, license, media handling, API availability, upload mechanisms, and data input methods. They did the same for training tools (Roboflow, Edge Impulse, TensorFlow Lite) across dataset management, labeling, training, model management, and deployment capabilities. They then documented specific integration decisions in ADR-005 (choosing Wildlife Insights first due to its SaaS nature reducing platform complexity) and ADR-006 (choosing the first model training integration). This level of due diligence showed the judges that the team understood what they were actually building against.

**Rapid Response** modeled each service's external dependencies and message contracts in their README, showing precisely which messages flowed between services and external platforms. Their ML Candidates Service ADR described a queued training pipeline where labeled observations flow into a centralized hub before being sent to external ML services.

**Wonderous Toys** addressed integration extensibility at the architectural level through their micro kernel plugin pattern (ADR-005), treating each third-party integration as a plugin behind a standard facade. This meant that the architecture itself encoded the expectation that integrations would evolve and grow over time, rather than treating each one as a point-to-point connection.

### 2. Iterative Delivery and Pragmatic Scoping

**Celus Ceals** explicitly structured their solution around iterations (ADR-002). The first iteration focused on parts "harder to change in the future (hardware)" while subsequent iterations would improve user experience. They delivered a complete first-iteration C4 model alongside a suggested second-iteration scope. This demonstrated architectural maturity -- acknowledging that the full vision cannot ship at once and identifying what must be right from the start.

**Rapid Response** showed similar pragmatism with their monolith-first deployment strategy. Rather than prescribing distributed infrastructure from day one, they designed for extraction: "If one of the services needs to scale individually, it can be easily done since its component in the monolith can be easily extracted into its own microservice." The Camera Feed Engine remained separate because its scaling factors (number of cameras, message delivery rates) were fundamentally different from the user-facing services.

**Wonderous Toys** chose a modular monolith explicitly because it was "cost-effective and will enable us to build the solution more swiftly" for a charitable trust. This showed a direct connection between understanding the organizational context (a nonprofit with limited resources) and choosing an architecture that respects those constraints from the outset.

### 3. Edge Computing and Bandwidth Realism

**Rapid Response** produced the most technically grounded analysis of connectivity constraints. Their ADR on sending pictures of captured species calculated actual transmission times: a 10-second 720p video at 2.2 MB would take 55 seconds on worst-case 3G (300 kbps), and a 31 KB compressed image on LoRaWAN at 1 kbps would take 240 seconds. This led to the decision to send image frames rather than video, with a configurable option to send text-only alerts for cameras in areas with poor connections.

**Celus Ceals** addressed this through ADR-010 (using a queue on the camera integration service container) to handle the mismatch between fast camera data ingestion and slower user selection/enrichment processing, and ADR-012 (manual processes on cameras) acknowledging that some operations would require physical proximity.

**Wonderous Toys** took a multi-protocol approach with Bluetooth LE for local connections and LoRaWAN/3G/Satellite via GCP Pub/Sub for remote communication, recognizing that different field conditions demand different connectivity strategies.

### 4. Documentation Completeness and Rigor

The three placing teams each demonstrated documentation discipline in distinct ways. Celus Ceals had 15 ADRs covering architecture, security, UI, and integration decisions, plus a RAID log for risk management. Rapid Response had clear service-by-service documentation with external dependencies and message handling contracts for all six microservices. Wonderous Toys had thorough constraints and assumptions documentation with seven numbered items, each with explicit assumptions.

The breadth and depth of documentation across these teams showed not just what decisions were made, but why they were made and what trade-offs were accepted -- giving reviewers confidence that the architecture was deliberately designed rather than accidentally arrived at.

## Common Patterns

### Mobile-First User Interface

All three placing teams converged on a mobile app as the primary user interface, recognizing that biologists and nature enthusiasts in the field need mobile access. Wonderous Toys made this an explicit ADR (ADR-004: "Ease of Use - Mobile App Only"). Rapid Response chose React Native for cross-platform development. Celus Ceals included mobile UI considerations across several of their ADRs.

### Asynchronous Messaging for Service Communication

Every placing team adopted some form of asynchronous messaging between components. Rapid Response formalized this in their Services Communication Pattern ADR, citing loose coupling, scalability, error handling with dead-letter queues, and decoupled release cycles. Celus Ceals used queues specifically at the camera integration boundary (ADR-010). Wonderous Toys chose GCP Pub/Sub for event-driven communication between camera alerts and the core system.

### Separation of Camera Feed Ingestion

All three teams recognized that the camera-facing edge of the system has fundamentally different scaling and reliability characteristics from user-facing services. Rapid Response kept the Camera Feed Engine as the only service that must remain independently deployable. Celus Ceals created a dedicated Camera Integration Service with its own queue. Wonderous Toys handled camera alerts through their event-driven layer, decoupling the unpredictable camera feed from the rest of the modular monolith.

### External ML Training

No placing team attempted to build ML training infrastructure in-house. All recognized that Roboflow, Edge Impulse, and TensorFlow Lite should be leveraged as external services, with the platform acting as an orchestrator for training data curation, submission, and model retrieval. Rapid Response's ML Candidates Service and Celus Ceals' ML Training Manager both embodied this gateway pattern.

### Camtrap DP as the Data Exchange Standard

All three teams incorporated the Camtrap DP data exchange format for publishing to GBIF, reflecting the domain's established interoperability standard. Rapid Response dedicated an ADR specifically to exporting observations into Camtrap DP format.

## Unique Innovations Worth Highlighting

### Celus Ceals: Iterative Architecture with RAID Log

The first-place team was the only one to include a RAID (Risks, Assumptions, Issues, Dependencies) log -- a project management artifact rarely seen in kata submissions but valuable for demonstrating that architectural decisions exist within a delivery context. Combined with their iterative approach (ADR-002), this showed a team thinking not just about what to build but about how to build it incrementally and manage risk along the way.

### Rapid Response: Bandwidth-Driven Design Decisions

The second-place team's transmission time calculations and resulting design decisions (images over video, configurable per-camera alert modes) represented the most rigorous treatment of the physical constraints that distinguish IoT/edge systems from typical web architectures. Their ADR included a table comparing minimum and maximum transfer rates for 3G and LoRaWAN, showing exact packet counts (125 LoRaWAN packets for a 31 KB message) and per-scenario timing.

### Wonderous Toys: Micro Kernel for Integration Extensibility

The third-place team's use of the micro kernel pattern specifically for the integration module (ADR-005) was the most architecturally elegant solution to the extensibility requirement. By treating each third-party integration as a plugin behind a standard facade, they created a pattern where new integrations (future partners, new labeling platforms) could be added without modifying the core system. This directly addressed the open-source community contribution model where external developers might contribute integration plugins.

## Lessons for Practitioners

### 1. Match Architecture Complexity to Organizational Capacity

The placing teams demonstrated that architectural ambition must be calibrated to the organization's ability to operate the system. Celus Ceals chose microservices but planned iterative delivery. Rapid Response designed microservices but deployed as a monolith. Wonderous Toys chose a modular monolith explicitly because it was "cost-effective and will enable us to build the solution more swiftly" for a charitable trust. Each team found a different point on the complexity spectrum, but all three anchored their choice in the reality of a resource-constrained nonprofit.

**Takeaway:** For resource-constrained organizations, design for the architecture you want but deploy the architecture you can afford to operate today. Build in extraction points so you can evolve when the need is proven.

### 2. Physical Constraints Demand Quantitative Analysis

This kata's edge computing requirements exposed whether teams could move beyond logical architecture into physical reality. Rapid Response's bandwidth calculations -- determining that a 31 KB image takes 240 seconds over weak LoRaWAN, or that a 2.2 MB video takes 55 seconds on worst-case 3G -- produced concrete, defensible design decisions. Celus Ceals' queue-based camera integration and manual-process ADR similarly reflected an understanding that edge devices operate under physical constraints that cannot be abstracted away.

**Takeaway:** When your architecture spans the physical-digital boundary, back your decisions with numbers. A 31 KB image taking 240 seconds over weak LoRaWAN is an architectural constraint, not an infrastructure detail.

### 3. Third-Party Integration is Architecture, Not Implementation

The challenge required integration with eight or more external platforms, each with different APIs, data formats, deployment models, and authentication mechanisms. Celus Ceals' comparative analysis tables and Wonderous Toys' micro kernel plugin pattern treated integration as a first-class architectural concern. Rapid Response's explicit message contracts and service-level dependency mapping ensured that integration points were visible in the architecture rather than hidden in implementation.

**Takeaway:** When your system's value proposition depends on third-party integrations, analyze those integrations during architecture -- not during implementation. Differences in API style, data input mechanisms, and deployment models (SaaS vs. self-hosted) affect your architecture.

### 4. ADR Discipline Matters, but Depth Beats Quantity

Celus Ceals led with 15 ADRs, Rapid Response had 8, and Wonderous Toys had 6. The placing order correlated not with ADR count alone but with the depth and actionability of each decision record. Celus Ceals' ADRs led to concrete design decisions (which labeling platform to integrate first, how to handle camera security, where to place queues). Rapid Response's ADRs drove specific deployment choices (monolith-first, images over video). Wonderous Toys' ADRs each mapped directly to an architectural style choice with clear rationale.

**Takeaway:** ADRs should drive design decisions, not just document analysis. Each ADR should change something about the architecture or explicitly decide not to change something.

### 5. Open Source Changes the Architecture Conversation

All three placing teams recognized that open-source requirements affect architecture: simpler is better for community contributions, modular designs enable plugin ecosystems, and self-hostability matters. Wonderous Toys (ADR-006 on open source) explicitly factored open-source dynamics into their decisions. Celus Ceals chose SaaS integrations to reduce self-hosting complexity. Rapid Response's monolith-first approach lowered the barrier for contributors who would need to run the system locally.

**Takeaway:** Open-source is not just a licensing decision -- it is an architectural constraint that favors simplicity, modularity, and clear extension points over sophistication and tight coupling.

### 6. Domain Understanding Separates Good From Great

The teams that went deepest into the wildlife conservation domain produced the most nuanced and defensible architectures. Celus Ceals understood that camera locations may lack power for complex authentication and that hardware decisions are harder to change than software. Rapid Response recognized that bandwidth limitations in the field fundamentally shape what data can flow through the system. Wonderous Toys grasped that a charitable trust's resource constraints are not temporary limitations but permanent architectural drivers. The kata was not just a distributed systems exercise; it was a conservation technology design problem.

**Takeaway:** Architecture without domain understanding produces generic solutions. The best architectures emerge from teams that understand not just the technical requirements but *why* those requirements exist and *who* they serve.
