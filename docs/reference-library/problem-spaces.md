# Problem Space Taxonomy

A reference classification of 11 O'Reilly Architecture Kata challenges across multiple dimensions, built from evidence in 78 team submissions. Use this document to find the past challenges that most closely resemble your own problem, then study the corresponding solution patterns.

---

## How to Use This Document

1. **Identify your problem dimensions.** Read the Dimension Definitions below and determine where your problem falls on each axis (domain type, scale, budget context, compliance burden, integration complexity, real-time needs, edge/offline requirements, AI/ML component, greenfield vs. brownfield).

2. **Scan the Classification Matrix.** Find the row(s) that most closely match your problem across multiple dimensions. The "Key Tension" column captures the central architectural dilemma each challenge posed -- if your key tension matches, the solutions from that challenge are likely relevant.

3. **Read the Detailed Problem Profile.** Each challenge has a detailed profile with evidence-backed classifications. Use this to confirm relevance before diving into team submissions.

4. **Use the Problem Similarity Matrix.** The 11x11 similarity matrix at the end of this document quantifies which challenges are most like each other. If your problem matches one challenge strongly, the similar challenges provide additional solution evidence.

5. **Explore the Dimension Deep Dives.** The deep-dive sections group challenges by each dimension and extract the architectural patterns that emerge at each tier.

---

## Dimension Definitions

| Dimension | Definition | Scale | Examples |
|-----------|-----------|-------|----------|
| **Domain Type** | The primary industry or functional domain of the challenge | Categorical | Food/Logistics, Enterprise IT, Healthcare, Travel, Civic Tech, Conservation/IoT, Retail AI, HR/AI, EdTech/AI |
| **Scale** | The expected number of users, transactions, or data volume the system must support | Ordinal: Small / Medium / Large / Very Large | Small: hundreds of users; Medium: thousands; Large: hundreds of thousands; Very Large: millions |
| **Budget Context** | The financial constraints and organizational funding model | Categorical | Startup, Non-Profit, Established Enterprise, Startup-to-Enterprise transition |
| **Compliance/Regulatory** | The regulatory frameworks that constrain the architecture | Categorical | Food Safety, HIPAA, GDPR, PCI-DSS, None explicit, Certification Integrity |
| **Integration Complexity** | The number and difficulty of external system integrations | Ordinal: Low / Medium / High / Very High | Low: 0-1 external systems; Medium: 2-3; High: 4-6; Very High: 7+ |
| **Real-time Needs** | Whether the system requires sub-second or near-real-time data processing | Ordinal: None / Low / Medium / High / Critical | None: batch only; Low: minutes acceptable; Medium: seconds acceptable; High: sub-second needed; Critical: lives depend on latency |
| **Edge/Offline** | Whether the system must operate in disconnected or resource-constrained environments | Boolean + context | Yes: smart fridges, wildlife cameras, hospital appliances; No: cloud-only |
| **AI/ML Component** | The role of AI or machine learning in the system | Ordinal: None / Peripheral / Supporting / Central | None: no AI; Peripheral: recommendation engine as nice-to-have; Supporting: AI enhances core workflow; Central: AI is the core value proposition |
| **Greenfield/Brownfield** | Whether the system is being built from scratch or extending/replacing an existing system | Categorical | Greenfield, Brownfield (migration), Brownfield (extension), Hybrid |
| **Key Tension** | The central architectural trade-off that teams must resolve | Free text | The one dilemma that, if resolved wrong, undermines the entire architecture |

---

## Challenge Classification Matrix

| Challenge | Season | Teams | Domain Type | Scale | Budget Context | Compliance | Integration | Real-time | Edge/Offline | AI/ML | Greenfield | Key Tension |
|-----------|--------|-------|-------------|-------|----------------|------------|-------------|-----------|-------------|-------|------------|-------------|
| Farmacy Food | Fall 2020 | 10 | Food / Logistics | Small to Large | Startup | Food Safety, PCI | High (POS, fridges, ChefTec, QuickBooks) | Medium (inventory sync) | Yes (smart fridges) | None | Greenfield | Scale cheaply now vs. architect for national growth |
| Sysops Squad | Spring 2021 | 7 | Enterprise IT / Field Service | Large | Established Enterprise | PCI (payment data) | Medium (payment, notification) | Medium (ticket routing) | No | None | Brownfield (migration) | Migrate a failing monolith without losing the business |
| Farmacy Family | Fall 2021 | 7 | Health / Community | Small to Medium | Startup | HIPAA, GDPR | High (Farmacy Foods, clinics, health APIs) | Low (community, analytics) | No | Peripheral (dietary recommendations) | Brownfield (extension) | Startup budget vs. enterprise-grade health compliance |
| Spotlight Platform | Spring 2022 | 8 | Non-Profit / HR Tech | Medium | Non-Profit | GDPR (PII) | Medium (non-profit systems, content) | Low (matching, reporting) | No | Peripheral (candidate matching) | Greenfield | Non-profit budget vs. platform ambition |
| Hey Blue! | Fall 2022 | 6 | Civic Tech / Social Impact | Large to Very Large | Non-Profit | GDPR, Officer Safety | Medium (social media, retail) | High (geolocation, proximity) | No | None | Greenfield | Real-time officer safety vs. community engagement at scale |
| Wildlife Watcher | Fall 2023 | 6 | Conservation / IoT | Small to Medium | Non-Profit (charity) | Geoprivacy (endangered species) | Very High (iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite) | Medium (camera alerts) | Yes (edge cameras, LoRaWAN/3G/satellite) | Supporting (on-device species ID) | Greenfield | Ultra-constrained edge hardware vs. cloud AI sophistication |
| Road Warrior | Fall 2023 (Ext) | 9 | Travel / Consumer | Very Large (15M users) | Startup | GDPR, PCI | High (SABRE, APOLLO, email providers, social media) | High (5-min travel updates) | No | None | Greenfield | 99.99% availability at startup cost |
| MonitorMe | Winter 2024 | 7 | Healthcare / MedTech | Medium (500 patients per install) | Established Enterprise | Not explicitly HIPAA (on-prem, proprietary) | Medium (MyMedicalData, MonitorThem) | Critical (sub-1s vital signs, alerting) | Yes (on-premises hospital appliance) | None | Greenfield | Life-critical latency on constrained on-premises hardware |
| ShopWise AI | AI Winter 2024 | 4 | Retail / E-Commerce | Small (single store) | Not specified | None explicit | Low (product/order database) | Low (chatbot response) | No | Central (AI chatbot is the product) | Greenfield | AI accuracy and cost vs. rapid prototyping |
| ClearView | Fall 2024 | 7 | HR / AI for Bias Reduction | Medium | Non-Profit | PII protection, anti-bias | High (unbounded HR systems) | Low (batch matching) | No | Central (resume anonymization, matching) | Greenfield | LLM cost/non-determinism vs. bias-free hiring at non-profit budget |
| Certifiable Inc. | Winter 2025 | 7 | EdTech / Certification | Medium to Large (200/wk to 2000/wk) | Established (thin margins) | Certification integrity, data accuracy | Low (existing SoftArchCert platform) | Low (batch grading) | No | Central (AI grading is the value proposition) | Brownfield (extension) | AI autonomy vs. career-affecting accuracy in high-stakes grading |

---

## Detailed Problem Profiles

### Farmacy Food (Fall 2020)

**Domain**: Food tech / Ghost kitchen logistics
**Scale trajectory**: Single city (Detroit) to national expansion -- hundreds to thousands of customers
**Budget context**: Startup with limited funding and small development team. ArchColider's cost model projected $12K-$23K/year infrastructure costs across three growth scenarios.
**Compliance needs**: Food safety (expiry management, allergen tracking), PCI-DSS (payment processing). Future HIPAA concerns if health data integration proceeds.
**Integration complexity**: HIGH -- Byte Technology smart fridges (RFID, cloud API), Toast POS kiosks, ChefTec kitchen management (unclear API, $500-$5000+ integration cost per Jaikaturi's vendor research), QuickBooks accounting.
**Real-time needs**: Medium -- inventory sync between fridges and central system must handle eventual consistency; order processing; push notifications.
**Edge/offline needs**: Yes -- smart fridges must authenticate customers and release meals even without internet connectivity. Jaikaturi designed a CDN-based offline authentication using hashed credit card subsets.
**AI/ML component**: None in core requirements. Self-Driven Team proposed an ML recommendation engine as an extension.
**Greenfield/brownfield**: Greenfield -- new system, though integrating with existing third-party platforms.
**Key architectural tension**: How to build a system cheaply enough for a startup but with enough structural integrity to scale nationally. The winner (ArchColider) chose a modular monolith specifically to avoid premature distributed systems complexity.
**Number of external systems**: 4+ (Byte Technology, Toast, ChefTec, QuickBooks, payment processor)
**Data sensitivity**: Medium -- payment data (PCI), dietary preferences, future health data

---

### Sysops Squad (Spring 2021)

**Domain**: Enterprise IT / Field service management
**Scale trajectory**: Existing nationwide operation -- large-scale consumer electronics retailer across the United States with established customer base.
**Budget context**: Established enterprise (Penultimate Electronics). Cost is a concern but not existential -- the business line will be shut down entirely if the architecture is not fixed.
**Compliance needs**: PCI-DSS (credit card data for service plan billing). Teams universally separated billing into its own domain with dedicated storage.
**Integration complexity**: Medium -- payment processing system, notification (SMS/email), existing monolithic database. The integration challenge is primarily internal (decomposing the monolith) rather than external.
**Real-time needs**: Medium -- ticket routing and assignment should be responsive; expert availability tracking needs near-real-time updates; reporting can be batch.
**Edge/offline needs**: No -- web portals, mobile apps, and call-center interfaces all assume connectivity.
**AI/ML component**: None in core requirements. Global Architects proposed an ML chatbot for demand reduction.
**Greenfield/brownfield**: Brownfield (migration) -- the entire challenge is about decomposing a failing monolith into a target architecture while maintaining operations. Team Seven's winning approach centered on the transition architecture, not just the target state.
**Key architectural tension**: How to migrate from a monolith to a decomposed architecture without disrupting an active nationwide business. The transition path matters more than the destination.
**Number of external systems**: 2-3 (payment processor, notification services, existing monolithic database)
**Data sensitivity**: Medium-high -- customer PII, credit card data, service history, expert location data

---

### Farmacy Family (Fall 2021)

**Domain**: Health / Community engagement platform
**Scale trajectory**: Small to medium -- extending an existing startup's customer base from transactional to engaged. Hundreds to low thousands of users.
**Budget context**: Startup. The existing Farmacy Foods system constrains the budget. Architects++ explicitly chose Facebook Groups, Eventbrite, and WordPress to minimize custom build surface.
**Compliance needs**: HIPAA (medical data sharing between customers, dieticians, and clinics), GDPR (data privacy, right to erasure). The Archangels addressed GDPR via crypto-shredding. Architects++ made the deliberate decision NOT to isolate HIPAA functionality initially, arguing the operational burden outweighed the technical architecture concern.
**Integration complexity**: HIGH -- must integrate with the existing Farmacy Foods reactive monolith, plus health data APIs (Human API, Epic EHR/EMR per Pentagram 2021), community platforms, and analytics pipelines. Kafka appeared in 5 of 7 submissions as the integration backbone.
**Real-time needs**: Low -- community engagement, forums, classes, and analytics are not latency-sensitive. Customer segmentation is explicitly a batch process.
**Edge/offline needs**: No.
**AI/ML component**: Peripheral -- dietary recommendations and customer segmentation. Sever Crew proposed AWS Forecast ML. Not a core requirement.
**Greenfield/brownfield**: Brownfield (extension) -- the system sits alongside and integrates with an existing platform (ArchColider's Farmacy Foods design from Fall 2020).
**Key architectural tension**: Startup budget vs. enterprise-grade health compliance. Teams had to balance rapid time-to-market for community features against the legal and technical weight of HIPAA compliance.
**Number of external systems**: 4+ (Farmacy Foods, health APIs, community platforms, analytics)
**Data sensitivity**: High -- medical data (HIPAA), dietary preferences, customer behavioral data

---

### Spotlight Platform (Spring 2022)

**Domain**: Non-profit / HR tech / Diversity & inclusion
**Scale trajectory**: Medium -- connecting underrepresented candidates with non-profit training organizations. PegasuZ defined availability targets of 3-4 nines, implying thousands of concurrent users at maturity.
**Budget context**: Non-profit (Diversity Cyber Council, 501(c)(3)). Severely cost-constrained. PegasuZ asked: "Why should the business invest to build a fortress when it is not sure if anyone would be staying in it?" TheGlobalVariables calculated per-user costs as low as $0.002/month.
**Compliance needs**: GDPR (candidate PII). Multiple teams addressed data purging and consent management.
**Integration complexity**: Medium -- non-profit organizations' systems, content management, notification systems. The challenge emphasized rich content (text, links, PDFs) and automatic matching rather than complex external integrations.
**Real-time needs**: Low -- candidate-to-offering matching and reporting are not latency-sensitive. Notifications need reasonable timeliness but not sub-second delivery.
**Edge/offline needs**: No. Wright-Stuff proposed an IVR system for phoneless candidates, but this is connectivity-constrained rather than offline.
**AI/ML component**: Peripheral -- candidate matching and recommendation. The Marmots planned a data-first approach (collect assignment data before building ML models). TheGlobalVariables proposed AWS SageMaker for predictions.
**Greenfield/brownfield**: Greenfield -- entirely new platform.
**Key architectural tension**: Non-profit budget vs. platform ambition. The kata required enterprise-grade features (matching, analytics, content management, reporting) at non-profit funding levels. The winner (PegasuZ) resolved this by starting with a modular monolith MVP.
**Number of external systems**: 2-3 (non-profit systems, content platforms, notification)
**Data sensitivity**: Medium -- candidate PII, demographic data, progress tracking

---

### Hey Blue! (Fall 2022)

**Domain**: Civic tech / Social impact / Community-police relations
**Scale trajectory**: Large to Very Large -- the stated target was 1.2 billion annual connections across U.S. cities, implying millions of users. Initial launch is startup-scale.
**Budget context**: Non-profit (EcoSchool). Grant-funded. MonArch projected $2,780/month for 50K MAU on GCP.
**Compliance needs**: GDPR (international expansion potential per IPT), officer safety/privacy (location tracking of law enforcement creates serious safety risks). It Depends deliberately deviated from requirements to protect officer locations.
**Integration complexity**: Medium -- social media APIs, retail storefront systems for points redemption, charity/donation platforms. IPT's Microkernel Dispatcher for business integration recognized that participating businesses range from REST-capable chains to phone/fax-only shops.
**Real-time needs**: High -- officer proximity detection, real-time connection workflows, WebSocket-based location streaming, push notifications. MonArch designed an in-memory graph database for O(log n) proximity lookups.
**Edge/offline needs**: No, though Black Cat Manifestation's QR code approach bypassed geolocation entirely for in-person interactions.
**AI/ML component**: None.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: Real-time officer safety vs. community engagement at scale. The system must make officers discoverable while protecting their locations from misuse, and must handle enterprise-grade geolocation on a non-profit budget.
**Number of external systems**: 3-5 (social media, retail partners, charity platforms, payment processing)
**Data sensitivity**: High -- officer location data (safety-critical), user PII, transaction data

---

### Wildlife Watcher (Fall 2023)

**Domain**: Conservation technology / IoT / Edge computing
**Scale trajectory**: Small to medium -- hundreds of cameras and users initially, with open-source community growth potential. Not a mass-consumer application.
**Budget context**: Non-profit (Wildlife.ai charitable trust). Cost-consciousness drove architecture decisions across all teams. Wonderous Toys chose modular monolith explicitly for cost-effectiveness.
**Compliance needs**: Geoprivacy for endangered species (AnimAI's ADR-003 recognized that camera location data could be exploited by poachers). Wildlife Watchers implemented user vetting before granting data access.
**Integration complexity**: VERY HIGH -- the challenge required integration with 8+ external platforms: iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite. Each has different APIs, deployment models (SaaS vs. self-hosted), data formats, and authentication mechanisms. Celus Ceals produced comparative analysis tables for all platforms.
**Real-time needs**: Medium -- camera alerts should propagate in near-real-time, but conservation observation workflows tolerate minutes of delay. Rapid Response calculated actual transmission times (31KB image over LoRaWAN = 240 seconds).
**Edge/offline needs**: Yes -- this is the defining constraint. Wildlife cameras operate on ultra-low-power microcontrollers (up to 512KB Flash) with unreliable connectivity (LoRaWAN at 1kbps, 3G, satellite). AI species identification must run on-device. Cameras may be physically inaccessible.
**AI/ML component**: Supporting -- on-device AI for species identification is a core requirement, but the system's primary value is the observation platform, not the AI itself. ML training is explicitly external (Roboflow, Edge Impulse, TensorFlow Lite).
**Greenfield/brownfield**: Greenfield -- open-source project.
**Key architectural tension**: Ultra-constrained edge hardware vs. cloud AI sophistication. Teams had to design for 512KB microcontrollers that run AI inference while connected via LoRaWAN at 1kbps, yet integrate with cloud-based labeling and training platforms.
**Number of external systems**: 8+ (iNaturalist, GBIF, Wildlife Insights, TrapTagger, Trapper, Roboflow, Edge Impulse, TensorFlow Lite)
**Data sensitivity**: Medium -- geoprivacy for endangered species, open data risks

---

### Road Warrior (Fall 2023 External)

**Domain**: Travel / Consumer technology
**Scale trajectory**: Very Large -- 15 million total users, 2 million active weekly. The largest user base of any kata challenge.
**Budget context**: Startup with time-to-market urgency. Iconites proposed a tiered business model (Freemium/Silver/Gold) and phased MVP with cost projections ($496.95/month initial infrastructure).
**Compliance needs**: GDPR (international travelers), PCI-DSS (payment processing for premium tiers). Street Fighters produced a comprehensive GDPR ADR covering data classification, consent management, encryption, breach notification, and DPO designation.
**Integration complexity**: HIGH -- SABRE and APOLLO travel agency APIs, email providers (Gmail, Outlook, iCloud via IMAP/webhooks), social media APIs, analytics platforms. Email integration was the hardest technical challenge -- Street Fighters estimated 4,000 email filtering requests/second.
**Real-time needs**: High -- travel updates must be reflected within 5 minutes (hard requirement), web response times under 800ms, mobile first contentful paint under 1.4s. 99.99% availability requirement (max 5 minutes unplanned downtime per month).
**Edge/offline needs**: No.
**AI/ML component**: None in core requirements. Analytics data collection for future monetization.
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: 99.99% availability for millions of users at startup cost. The system demands enterprise-grade reliability and performance (the strictest SLAs of any kata) while being built by a startup without established infrastructure.
**Number of external systems**: 5+ (SABRE, APOLLO, email providers, social media, payment)
**Data sensitivity**: High -- travel itineraries, email access, payment data, location data

---

### MonitorMe (Winter 2024)

**Domain**: Healthcare / Medical device monitoring
**Scale trajectory**: Medium -- up to 500 patients per installation, up to 25 nurse stations. Fixed ceiling, not open-ended growth. BluzBrothers explicitly downplayed scalability (ADR-008) since the 500-patient ceiling was hard.
**Budget context**: Established enterprise (StayHealthy, Inc. already has two cloud-based SaaS products). Budget supports proprietary hardware development.
**Compliance needs**: The kata explicitly stated HIPAA compliance was not required. The system operates on-premises with proprietary hardware, behind hospital infrastructure. Security was consistently acknowledged but deferred by most teams.
**Integration complexity**: Medium -- must integrate with StayHealthy's existing cloud products (MyMedicalData via secure HTTP API, MonitorThem for analytics). 8 device types with different sampling rates (heart rate at 500ms, ECG at 1s, blood pressure at 1hr, etc.).
**Real-time needs**: CRITICAL -- sub-1-second average response time for nurse station displays. Vital sign anomaly alerting is life-critical. BluzBrothers proved 693ms end-to-end latency through fitness function calculations. This is the highest real-time requirement of any kata.
**Edge/offline needs**: Yes -- the entire system is an on-premises hospital appliance. It must operate independently of cloud connectivity. LowCode designed a distributed 3-node appliance with graceful degradation (3 nodes = full function, 2 nodes = full function, 1 node = alerting only).
**AI/ML component**: None -- anomaly detection uses configurable threshold rules, not ML.
**Greenfield/brownfield**: Greenfield -- new product, though it integrates with existing StayHealthy cloud products.
**Key architectural tension**: Life-critical latency on constrained on-premises hardware. The system must guarantee sub-second vital sign display and reliable alerting while running entirely on proprietary hardware in a hospital, with no cloud fallback.
**Number of external systems**: 2 (MyMedicalData, MonitorThem) plus 8 medical device types
**Data sensitivity**: Very High -- vital signs, patient health data (even though HIPAA was explicitly excluded)

---

### ShopWise AI Assistant (AI Winter 2024)

**Domain**: Retail / E-commerce / AI chatbot
**Scale trajectory**: Small -- single e-commerce store with product catalog and order database. No explicit user count requirements.
**Budget context**: Not specified. Implicit cost consciousness around LLM API costs. ConnectedAI used a dual-LLM strategy (Claude for reasoning, Gemini Flash for routing) to manage costs.
**Compliance needs**: None explicit. IntelliMutual acknowledged their database was in a public subnet as a security concern. SQL injection via LLM-generated queries is an implicit risk.
**Integration complexity**: Low -- product/order database is the primary integration. No external third-party systems beyond LLM API providers.
**Real-time needs**: Low -- chatbot response times should be conversational (seconds), but there are no hard latency SLAs.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- the AI chatbot IS the product. This was the first AI-focused kata. All four teams converged on text-to-SQL as the core pattern. ConnectedAI implemented a multi-agent supervisor hierarchy with four specialist agents. Breakwater validated that SQL outperformed RAG for structured data retrieval.
**Greenfield/brownfield**: Greenfield -- new system with a provided database.
**Key architectural tension**: AI accuracy and cost vs. rapid prototyping. Teams had to balance sophisticated multi-agent architectures (ConnectedAI) against practical working prototypes (Breakwater's n8n low-code approach). The kata uniquely required working software, not just diagrams.
**Number of external systems**: 1 (LLM API provider -- though multiple models were used)
**Data sensitivity**: Low -- product catalog and order data. No health or financial data.

---

### ClearView (Fall 2024)

**Domain**: HR / AI for bias reduction in recruitment
**Scale trajectory**: Medium -- Pragmatic and Katamarans designed for initial deployment with a manageable candidate pool. Equihire Architects explicitly scoped to 5,000 candidates.
**Budget context**: Non-profit (Diversity Cyber Council). LLM costs are a primary architectural concern. Katamarans calculated $0.06 per candidate for a full hiring flow. DevExperts estimated $8,448/year total infrastructure.
**Compliance needs**: PII protection (resume data, demographic information), anti-bias requirements (the system must eliminate bias while relying on LLMs that carry biases). Katamarans dedicated two ADRs to PII safety.
**Integration complexity**: HIGH -- the platform must integrate with an unbounded number of third-party HR systems (ATS, HRIS), each with different APIs, data formats, and authentication mechanisms. Every team identified HR integration as a first-class architectural concern, using adapter/connector patterns.
**Real-time needs**: Low -- resume anonymization and matching are batch or near-batch processes. No sub-second requirements.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- AI performs resume anonymization, candidate story construction, and job matching. This is the core value proposition. Pragmatic's deterministic matching approach (extract features with LLM, then match deterministically) reduced LLM calls from O(n*m) to O(n+m).
**Greenfield/brownfield**: Greenfield.
**Key architectural tension**: LLM cost and non-determinism vs. bias-free hiring at non-profit budget. Teams must build an AI-centric platform that eliminates bias (the whole point) while controlling costs and maintaining transparency/explainability.
**Number of external systems**: Unbounded (HR systems) + LLM providers
**Data sensitivity**: High -- resumes, demographic data, employment history, PII requiring anonymization

---

### Certifiable Inc. (Winter 2025)

**Domain**: EdTech / AI-assisted certification grading
**Scale trajectory**: Medium to Large -- 200 candidates/week currently, with projected 5-10X surge to 1,000-2,000/week from international expansion.
**Budget context**: Established organization with thin margins. The $800 exam fee and $550 grading cost (11 expert-hours at $50/hr) leave slim profitability. AI must reduce costs, not add them. ZAITects projected 80% cost reduction ($940K to $190K grading costs/week).
**Compliance needs**: Certification integrity -- errors can derail careers. This is not regulatory compliance but an ethical/reputational constraint that is arguably more demanding than formal regulation. Every team implemented human-in-the-loop; no team proposed fully autonomous AI grading.
**Integration complexity**: Low -- the AI system integrates with the existing SoftArchCert platform. No complex external system integrations.
**Real-time needs**: Low -- grading is a batch process. Candidates wait days for results.
**Edge/offline needs**: No.
**AI/ML component**: CENTRAL -- AI grading is the entire value proposition. This is the highest-stakes AI challenge in the kata series (career-affecting outcomes). ZAITects separated the Grader from the Judge (LLM-as-a-Judge pattern). Software Architecture Guild ran six parallel AI solution variants via microkernel architecture. Usfive deliberately rejected RAG to avoid homogenizing acceptable answers.
**Greenfield/brownfield**: Brownfield (extension) -- adding AI capabilities to an existing certification platform.
**Key architectural tension**: AI autonomy vs. career-affecting accuracy. How much grading autonomy should the AI have when errors can derail someone's professional career? Every team used confidence-based escalation to human reviewers.
**Number of external systems**: 1 (existing SoftArchCert platform) + LLM providers
**Data sensitivity**: High -- candidate exam responses, personal career data, certification outcomes

---

## Problem Dimension Deep Dives

### By Domain Type

**Food / Logistics** (Farmacy Food)
Domain-specific constraints: physical-digital bridge (RFID, smart fridges, POS), food safety regulations (expiry management, allergen tracking), cold chain logistics. Teams that engaged with the physical reality of fridges and kiosks (Hananoyama, Jaikaturi) produced more nuanced architectures. The key insight: event-driven inventory propagation is universal when physical goods are involved, because physical state changes are inherently asynchronous.

**Enterprise IT / Field Service** (Sysops Squad)
Domain-specific constraints: existing monolith with active users, nationwide operations that cannot tolerate downtime, expert workforce management (skills, location, availability). The monolith migration constraint drove near-unanimous convergence on service-based architecture (6 of 7 teams). The key insight: the transition architecture matters more than the target architecture.

**Health / Community** (Farmacy Family)
Domain-specific constraints: HIPAA compliance for medical data sharing, integration with an existing system (Farmacy Foods), community engagement features alongside medical-grade data security. The compliance tension (startup budget vs. HIPAA) was the primary architectural driver. The key insight: compliance can be addressed honestly by deferring it with documented rationale (Architects++) rather than superficially claiming it.

**Non-Profit / HR Tech** (Spotlight Platform, ClearView)
Domain-specific constraints: severe budget limitations, non-technical end users, need for accessibility. Both challenges were for the Diversity Cyber Council. Cost analysis separated winners from runners-up in both cases. The key insight: for non-profits, the architecture must justify its own cost of operation -- TheGlobalVariables' $0.002/user/month and Katamarans' $0.06/candidate are the kinds of numbers that make architectures credible.

**Civic Tech / Social Impact** (Hey Blue!)
Domain-specific constraints: real-time geolocation with safety implications, points-based incentive system, retail integration for redemption, social media amplification. Officer safety was the domain-specific constraint that no generic architecture pattern addresses. The key insight: when location tracking involves safety-sensitive populations, privacy is a driving architectural characteristic, not a compliance checkbox.

**Conservation / IoT** (Wildlife Watcher)
Domain-specific constraints: ultra-low-power edge hardware (512KB Flash), unreliable connectivity (LoRaWAN, 3G, satellite), open-source requirements, integration with a constellation of scientific platforms. This was the most physically constrained challenge. The key insight: physical constraints demand quantitative analysis -- Rapid Response's bandwidth calculations (31KB image, 240 seconds over LoRaWAN) drove design decisions that abstract analysis would have missed.

**Travel / Consumer** (Road Warrior)
Domain-specific constraints: massive user scale (15M), stringent availability SLAs (99.99%), multi-source data aggregation (email, travel APIs, manual entry), real-time update propagation. The near-universal convergence on event-driven + microservices (8 of 9 teams) reflects the domain's inherent asynchronous nature (email polling, API updates). The key insight: email integration at scale is a harder problem than it appears -- Street Fighters estimated 4,000 email filtering requests/second.

**Healthcare / MedTech** (MonitorMe)
Domain-specific constraints: life-critical latency, on-premises deployment, 8 device types at different sampling rates, 24-hour rolling data window, graceful degradation. All 7 teams converged on event-driven architecture -- the domain is a textbook fit. The key insight: on-premises deployment IS the architecture when cloud fallback is not available.

**Retail / AI** (ShopWise AI)
Domain-specific constraints: first AI-focused kata, requirement for working software, text-to-SQL as universal pattern, multi-turn conversation handling. This challenge tested AI engineering rather than traditional system architecture. The key insight: text-to-SQL beats RAG for structured data retrieval (validated by Breakwater's explicit comparison).

**HR / AI for Bias Reduction** (ClearView)
Domain-specific constraints: non-deterministic AI must produce bias-free outcomes, unbounded HR system integrations, PII protection, explainability requirements. Pragmatic's deterministic matching approach was the standout innovation. The key insight: architecture must constrain the AI, not just enable it -- create deterministic boundaries around non-deterministic components.

**EdTech / AI Certification** (Certifiable Inc.)
Domain-specific constraints: high-stakes grading where errors affect careers, labor-intensive expert workflows, thin margins, differentiated treatment of objective vs. subjective assessments. This is the most demanding AI challenge because the stakes are personal and irreversible. The key insight: in high-stakes AI, what you reject matters as much as what you build (ZAITects' rejection of Agentic AI, Usfive's rejection of RAG).

---

### By Scale Requirements

Challenges ordered from smallest to largest expected scale:

| Tier | Challenge | User/Transaction Scale | What Changes Architecturally |
|------|-----------|----------------------|------------------------------|
| **Small** | ShopWise AI | Single store, no explicit user count | Monolithic pipeline viable; focus on AI quality over infrastructure |
| **Small-Medium** | Farmacy Food (initial) | Hundreds of customers in Detroit | Modular monolith wins; startup simplicity over distributed systems overhead |
| **Small-Medium** | Wildlife Watcher | Hundreds of cameras/users | Edge constraints dominate; scale is secondary to connectivity and hardware |
| **Small-Medium** | Farmacy Family | Low thousands, community platform | Batch processing for analytics; community features are not scale-sensitive |
| **Medium** | Spotlight Platform | Thousands, non-profit platform | Cost-per-user matters more than raw throughput; serverless excels here |
| **Medium** | ClearView | Thousands of candidates, batch AI | LLM cost scales linearly with candidates; deterministic matching reduces this |
| **Medium** | MonitorMe | 500 patients, but intensive data (4,000 events/sec) | Data throughput matters more than user count; time-series DB essential |
| **Medium-Large** | Certifiable Inc. | 200-2,000 candidates/week | Grading throughput, not concurrent users, is the scaling dimension |
| **Large** | Sysops Squad | Nationwide retailer, existing base | Migration architecture must handle current load while transitioning |
| **Large-Very Large** | Hey Blue! | Millions of users, 1.2B annual connections | Real-time geolocation at scale; space-based or in-memory data structures |
| **Very Large** | Road Warrior | 15M users, 2M active weekly | 99.99% availability; CQRS mandatory; multiple scaling groups needed |

**Architectural transitions by scale tier:**
- **Small**: Single-process or monolithic architectures are not only acceptable but preferred. AI quality and domain logic dominate.
- **Medium**: Service-based architecture is the sweet spot. Event-driven for specific async concerns. Cost efficiency matters.
- **Large**: Microservices become justified. Event-driven becomes pervasive. CQRS and read/write separation emerge. Dedicated analytics pipelines.
- **Very Large**: Space-based patterns, in-memory data grids, multiple scaling groups, aggressive caching, and CDN-based distribution become necessary.

---

### By Integration Complexity

| Tier | Challenge | External Systems | Pattern That Emerges |
|------|-----------|-----------------|---------------------|
| **Low** | ShopWise AI | LLM APIs only | Direct API calls sufficient; abstraction layer for model swapping |
| **Low** | Certifiable Inc. | Existing platform + LLM APIs | Extension architecture; AI gateway pattern for LLM governance |
| **Medium** | Sysops Squad | Payment, notification, monolith DB | Internal decomposition harder than external integration; adapter pattern |
| **Medium** | Spotlight Platform | Non-profit systems, content, notification | BFF pattern; standard REST/webhook integrations |
| **Medium** | MonitorMe | 2 cloud products + 8 device types | Device protocol heterogeneity (different sampling rates); edge gateway pattern |
| **Medium** | Hey Blue! | Social media, retail, charity, payment | Microkernel/Plugin for business integration (IPT); diverse API capabilities |
| **High** | Farmacy Food | Smart fridges, POS, ChefTec, QuickBooks | Eventual consistency is non-negotiable; vendor research is architecture |
| **High** | Farmacy Family | Existing platform, health APIs, community | Kafka as universal integration backbone (5/7 teams); event-driven bridge |
| **High** | Road Warrior | SABRE, APOLLO, email, social media | Dual-speed polling (ArchEnemies); email integration is the hardest problem |
| **High** | ClearView | Unbounded HR systems + LLM providers | Adapter/connector pattern universal; abstraction layers around AI services |
| **Very High** | Wildlife Watcher | 8+ scientific/ML platforms | Microkernel plugin architecture (Wonderous Toys); comparative platform analysis essential |

**Patterns by integration tier:**
- **Low**: Direct API calls with abstraction layers for future swapping.
- **Medium**: Adapter pattern, dedicated integration services, webhook-based communication.
- **High**: Event-driven integration backbone (Kafka), dedicated integration modules per external system, vendor research as an architectural activity.
- **Very High**: Microkernel/plugin architecture for extensibility; comparative analysis of all integration targets as a pre-architecture activity.

---

### By Compliance/Regulatory Load

| Challenge | Compliance Regime | How It Constrained Solutions |
|-----------|------------------|-----------------------------|
| ShopWise AI | None explicit | Freed teams to focus on AI accuracy and prototyping |
| Wildlife Watcher | Geoprivacy (informal) | AnimAI identified poacher risk; Wildlife Watchers added user vetting |
| MonitorMe | HIPAA excluded | Teams deferred security; focused on performance and reliability |
| Spotlight Platform | GDPR (PII) | Data purging workflows; consent management; encryption at rest |
| Hey Blue! | GDPR + Officer Safety | IPT elevated GDPR to top-level ADR; It Depends deviated from requirements for safety |
| Road Warrior | GDPR + PCI-DSS | Street Fighters' comprehensive GDPR ADR (data classification, consent, breach notification); universal payment delegation |
| Farmacy Food | Food Safety + PCI | Expiry management, allergen tracking; external payment processors (Stripe universal) |
| Farmacy Family | HIPAA + GDPR | Crypto-shredding (Archangels); HIPAA-eligible AWS services; honest deferral (Architects++) |
| ClearView | PII + Anti-bias | PII as cross-cutting concern; architecture must constrain AI bias, not just process data |
| Certifiable Inc. | Certification Integrity | Universal human-in-the-loop; confidence-based escalation; no team proposed fully autonomous AI |
| Sysops Squad | PCI-DSS | Universal billing separation; credit card data isolation |

**Key finding**: Compliance load correlates with the importance of ADR quality. In high-compliance challenges (Farmacy Family, ClearView, Certifiable Inc.), the top teams all documented compliance decisions with specific ADRs, referenced specific standards (NIST 800-111, HIPAA-eligible AWS services, OWASP Top 10), or made explicit decisions to defer with documented rationale. Teams that mentioned compliance as a quality attribute without specific architectural responses consistently placed lower.

---

### By AI/ML Component

The evolution of AI in the kata series traces a clear arc:

**Phase 1: No AI (2020-2022)**
- Farmacy Food, Sysops Squad, Farmacy Family, Spotlight Platform, Hey Blue!
- AI was absent from requirements or appeared only as a peripheral "nice-to-have" (ML recommendations in Farmacy Family, candidate matching in Spotlight Platform)
- Architecture was dominated by traditional distributed systems concerns: decomposition, integration, scaling, migration

**Phase 2: IoT/Edge AI (2023)**
- Wildlife Watcher introduced on-device AI species identification as a core requirement
- AI was constrained by hardware (512KB Flash) and connectivity (LoRaWAN)
- The architectural challenge was deploying AI to the edge, not building AI systems
- Traditional architecture patterns (microservices, event-driven) still dominated

**Phase 3: AI as the Product (2024-2025)**
- ShopWise AI (Winter 2024): AI chatbot as the entire product; text-to-SQL, multi-agent architectures
- ClearView (Fall 2024): AI for resume anonymization and matching; LLM cost optimization, deterministic boundaries
- Certifiable Inc. (Winter 2025): AI for high-stakes grading; LLM-as-a-Judge, confidence-based escalation, microkernel for parallel AI variants

**What changed architecturally with AI:**

| Concern | Pre-AI Katas (2020-2023) | AI-Era Katas (2024-2025) |
|---------|-------------------------|-------------------------|
| **Primary architecture style** | Microservices, Service-Based, Event-Driven | Service-Based + Event-Driven + AI-specific patterns (multi-agent, pipeline) |
| **Cost optimization** | Infrastructure costs (cloud services, databases) | LLM API costs (per-token pricing, model selection by task) |
| **Testing** | Deterministic integration and unit tests | Non-deterministic AI evaluation frameworks (Ragas, LangFuse) |
| **ADR topics** | Database selection, decomposition, deployment | LLM selection, guardrails, evaluation strategy, prompt engineering |
| **Key risk** | Over-engineering, scaling prematurely | AI non-determinism, cost runaway, bias, hallucination |
| **Winner differentiator** | Cost analysis + evolutionary approach | AI risk analysis + production operationalization + deterministic boundaries |

---

## Problem Similarity Matrix

This matrix scores pairwise similarity between challenges on a 0-5 scale, where 5 = highly similar and 0 = no meaningful overlap. Similarity is assessed across all dimensions: domain, scale, budget, compliance, integration, real-time, edge/offline, AI/ML, and greenfield/brownfield.

|  | FF | SS | FaFa | SP | HB | WW | RW | MM | SA | CV | CI |
|--|----|----|------|----|----|----|----|----|----|----|-----|
| **Farmacy Food (FF)** | -- | 1 | 4 | 2 | 2 | 2 | 1 | 1 | 0 | 1 | 0 |
| **Sysops Squad (SS)** | 1 | -- | 2 | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 1 |
| **Farmacy Family (FaFa)** | 4 | 2 | -- | 3 | 2 | 1 | 1 | 1 | 0 | 2 | 1 |
| **Spotlight Platform (SP)** | 2 | 1 | 3 | -- | 3 | 2 | 1 | 0 | 0 | 4 | 1 |
| **Hey Blue! (HB)** | 2 | 1 | 2 | 3 | -- | 1 | 2 | 1 | 0 | 2 | 0 |
| **Wildlife Watcher (WW)** | 2 | 0 | 1 | 2 | 1 | -- | 0 | 3 | 0 | 0 | 0 |
| **Road Warrior (RW)** | 1 | 1 | 1 | 1 | 2 | 0 | -- | 1 | 0 | 0 | 0 |
| **MonitorMe (MM)** | 1 | 1 | 1 | 0 | 1 | 3 | 1 | -- | 0 | 0 | 0 |
| **ShopWise AI (SA)** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | -- | 3 | 4 |
| **ClearView (CV)** | 1 | 0 | 2 | 4 | 2 | 0 | 0 | 0 | 3 | -- | 3 |
| **Certifiable Inc. (CI)** | 0 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 4 | 3 | -- |

### Reading the Similarity Matrix

**Strongest pairings (score 4):**

- **Farmacy Food / Farmacy Family (4)**: Same organization (Farmacy), food/health domain, startup budget, external integration challenges. Farmacy Family explicitly extends Farmacy Food. Studying both reveals how architectures evolve from greenfield to brownfield extension.

- **Spotlight Platform / ClearView (4)**: Same client (Diversity Cyber Council), non-profit budget, HR domain, PII concerns, candidate matching. ClearView adds AI centrality. Studying both reveals how the same organization's architecture needs evolved from traditional platform (2022) to AI-centric platform (2024).

- **ShopWise AI / Certifiable Inc. (4)**: Both AI-centric challenges where AI is the core value proposition. Both require text understanding and structured data integration. Certifiable Inc. adds high-stakes accountability. Studying both reveals how AI architecture patterns mature from low-stakes (e-commerce chatbot) to high-stakes (career-affecting grading).

**Moderate pairings (score 3):**

- **Farmacy Family / Spotlight Platform (3)**: Both serve community/social missions, involve matching people to resources, face compliance requirements (HIPAA vs. GDPR), and operate on constrained budgets. Different domains but similar architectural tensions.

- **Spotlight Platform / Hey Blue! (3)**: Both non-profit, both civic/social impact, both greenfield platforms needing cost-conscious architectures. Hey Blue! adds real-time geolocation.

- **Wildlife Watcher / MonitorMe (3)**: Both involve hardware/device integration, edge computing, event-driven architectures, and real-time data processing from constrained devices. Different domains (conservation vs. healthcare) but similar physical-digital bridge problems.

- **ShopWise AI / ClearView (3)**: Both AI-centric, both require LLM integration, both face cost optimization challenges. ClearView is higher-stakes and more complex.

- **ClearView / Certifiable Inc. (3)**: Both AI-centric, both require AI to make consequential decisions about people's lives/careers, both need human-in-the-loop patterns.

**Zero-similarity pairings** (no meaningful overlap): Wildlife Watcher has zero similarity with Sysops Squad, Road Warrior, ShopWise AI, ClearView, and Certifiable Inc. -- its unique combination of edge computing, IoT, and conservation makes it an outlier. MonitorMe similarly shows zero overlap with Spotlight Platform, ShopWise AI, ClearView, and Certifiable Inc. -- life-critical on-premises medical monitoring occupies its own problem space.

---

### How to Use the Similarity Matrix

1. **Find your closest match**: Identify the challenge whose detailed profile most closely matches your situation.
2. **Check similarity scores of 3+**: These challenges share enough dimensions to provide additional relevant solution evidence.
3. **Read the challenge analyses**: The detailed comparative analyses in `docs/analysis/challenges/` contain team-by-team comparisons, architecture style rationale, and lessons learned.
4. **Study winning teams from similar challenges**: Winners from similar challenges likely faced analogous trade-offs. Their ADRs and architecture decisions are the most directly transferable evidence.

---

*Generated from evidence in 78 team submissions across 11 O'Reilly Architecture Kata seasons (Fall 2020 -- Winter 2025). Source data: `docs/catalog/_index.yaml`, `docs/analysis/challenges/*.md`, `docs/analysis/cross-cutting.md`.*
