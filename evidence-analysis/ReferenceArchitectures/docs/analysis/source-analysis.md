# Reference Architectures Source Analysis: Patterns Across 8 Curated Implementations

## Dataset Overview

This analysis covers **8 curated open-source reference implementations** selected for popularity, documentation quality, and pattern coverage aligned with the repository's 12 canonical architecture styles. Unlike the KataLog (design-phase competition submissions) and AOSA (production narratives), these are **working, deployable codebases** explicitly designed to teach architecture patterns.

| Project | Language | Domain | Stars | Year Created | Status |
|---------|----------|--------|-------|-------------|--------|
| eShopOnContainers | C# | E-Commerce | ~25,000 | 2017 | Archived (2023) |
| Clean Architecture Template | C# | To-Do / Task Management | ~17,000 | 2019 | Active |
| Modular Monolith with DDD | C# | Conference Management | ~11,000 | 2019 | Maintained |
| eShop | C# | E-Commerce | ~6,000 | 2023 | Active |
| Wild Workouts Go | Go | Fitness / Scheduling | ~5,000 | 2020 | Maintained |
| BuckPal | Java | Banking / Money Transfer | ~3,500 | 2019 | Maintained |
| AKS Baseline Cluster | Bicep/Bash | Container Platform | ~1,500 | 2020 | Active |
| Serverless Microservices | C# | Ride-Sharing | ~600 | 2019 | Maintained |

**Total combined GitHub stars**: ~70,100

---

## Architecture Style Distribution

Each project may demonstrate multiple architecture styles:

| Architecture Style | Count | Projects |
|-------------------|-------|----------|
| **Microservices** | 5 | eShopOnContainers, eShop, Wild Workouts Go, Serverless Microservices, AKS Baseline |
| **Event-Driven** | 4 | eShopOnContainers, eShop, Modular Monolith with DDD, Serverless Microservices |
| **Hexagonal Architecture** | 3 | Clean Architecture Template, BuckPal, Wild Workouts Go |
| **CQRS** | 3 | eShopOnContainers, Clean Architecture Template, Wild Workouts Go |
| **Domain-Driven Design** | 3 | eShopOnContainers, Modular Monolith with DDD, Wild Workouts Go |
| **Modular Monolith** | 1 | Modular Monolith with DDD |
| **Serverless** | 1 | Serverless Microservices |
| **Service-Based** | 1 | AKS Baseline Cluster |

### Key Findings

1. **Microservices is the most-represented style** (5 of 8 projects). This reflects the pattern's dominance in the cloud-native era and the demand for reference implementations showing how to decompose systems into independently deployable services. It also matches Microservices being the most commonly cited style in KataLog (48.7%).

2. **Event-Driven is the second most common** (4 of 8), appearing as a complementary pattern to Microservices or Modular Monolith — never standalone. This mirrors the KataLog finding that Event-Driven is near-universal among placed teams but always paired with another style.

3. **Hexagonal Architecture has strong representation** (3 of 8) despite appearing in only 5.1% of KataLog teams. Reference implementations fill a clear gap: Hexagonal is taught conceptually in books but teams struggle to implement it in practice. BuckPal, Clean Architecture Template, and Wild Workouts each show the code-level realization in a different language (Java, C#, Go).

4. **CQRS appears in 3 of 8 projects**, always paired with other patterns. In every case, CQRS is implemented via MediatR (C#) or equivalent command/query separation — suggesting that CQRS has a canonical implementation pattern in the .NET ecosystem.

5. **Modular Monolith has only 1 reference** despite correlating with the highest per-team placement score in KataLog (3.0/4.0). This is a significant coverage gap — teams that want to implement the statistically most successful KataLog pattern have only one reference to learn from.

6. **Serverless has only 1 reference.** Given that 9% of KataLog teams use Serverless and it appears in major cloud provider reference architectures, this is another coverage gap.

---

## Language and Technology Landscape

### Language Distribution

| Language | Projects | % of Total |
|----------|----------|------------|
| **C#** | 5 | 62.5% |
| **Java** | 1 | 12.5% |
| **Go** | 1 | 12.5% |
| **Bicep/Bash** | 1 | 12.5% |

### Key Findings

1. **Heavy C#/.NET skew.** Five of eight projects are C#. This reflects Microsoft's investment in reference architectures (eShopOnContainers, eShop, AKS Baseline, Serverless Microservices are all Microsoft-backed) and the .NET community's strong convention of publishing template/reference projects.

2. **No Python, TypeScript/JavaScript, or Rust.** These are among the most widely used languages for modern applications, yet have no representation. A team building in Node.js, Python/FastAPI, or Rust must translate patterns from C# or Java examples.

3. **Go is the only non-JVM/non-.NET representation** (Wild Workouts). It demonstrates that Clean Architecture can work in Go without Java-like interface hierarchies — an important lesson for language communities that value simplicity.

4. **Infrastructure-as-Code** (AKS Baseline) fills a unique niche: it's the only project focused on deployment topology rather than application architecture. Bicep/Bash are IaC languages, not application languages.

### Technology Ecosystem

Key technologies across all 8 projects:

| Category | Technologies | Count |
|----------|-------------|-------|
| **Messaging** | RabbitMQ (3), Azure Service Bus (1), Google Pub/Sub (1), Azure Event Grid (1) | 6 projects |
| **ORM / Data** | Entity Framework Core (3), Dapper (1), Firestore (1), Cosmos DB (1), MongoDB (1) | 6 projects |
| **Containers** | Docker (5), Kubernetes/AKS (2) | 5 projects |
| **CQRS Framework** | MediatR (3) | 3 projects |
| **API** | gRPC (3), REST/OpenAPI (4) | 5 projects |
| **Cloud Provider** | Azure (4), Google Cloud (1), Cloud-agnostic (3) | 8 projects |

**Azure dominance**: 4 of 8 projects are Azure-specific or Azure-optimized. Combined with the C# skew, the collection has a strong Microsoft ecosystem bias.

---

## Code Artifact Completeness

A key differentiator of reference implementations: they can be assessed on code-level artifacts.

| Artifact | Present | Absent | % Present |
|----------|---------|--------|-----------|
| **Running code** | 8 | 0 | 100% |
| **Documentation** | 8 | 0 | 100% |
| **Tests** | 7 | 1 | 87.5% |
| **CI/CD** | 5 | 3 | 62.5% |
| **ADRs** | 1 | 7 | 12.5% |

### Key Findings

1. **All 8 have running code and documentation** — the baseline expectation for reference implementations is met universally.

2. **Only 1 of 8 has ADRs** (Modular Monolith with DDD). This is a striking gap given that ADR discipline is the second-strongest predictor of placement in KataLog (after feasibility analysis). Reference implementations teach *what* to build but rarely *why* — the decision rationale that the KataLog evidence shows is most valuable.

3. **3 of 8 lack CI/CD** (BuckPal, Serverless Microservices, AKS Baseline). For projects meant to demonstrate production-readiness, the absence of CI/CD configuration means teams must figure out the build/deploy pipeline themselves.

4. **7 of 8 have tests**, with only AKS Baseline lacking application-level tests (it's infrastructure-focused). Test coverage varies significantly: Clean Architecture Template has unit, integration, and functional test projects at each layer, while some projects have only basic unit tests.

---

## Quality Attributes Prioritized

| Quality Attribute | Count | Projects |
|------------------|-------|----------|
| **Testability** | 4 | Clean Architecture Template, BuckPal, Wild Workouts Go, Modular Monolith with DDD |
| **Maintainability** | 3 | Clean Architecture Template, BuckPal, Wild Workouts Go |
| **Scalability** | 3 | eShop, eShopOnContainers, Serverless Microservices |
| **Deployability** | 3 | eShop, Wild Workouts Go, eShopOnContainers |
| **Evolvability** | 2 | eShopOnContainers, Modular Monolith with DDD |
| **Modularity** | 1 | Modular Monolith with DDD |
| **Simplicity** | 2 | BuckPal, Wild Workouts Go |
| **Security** | 1 | AKS Baseline Cluster |
| **Reliability** | 1 | AKS Baseline Cluster |
| **Resilience** | 1 | eShopOnContainers, Serverless Microservices |
| **Cost Efficiency** | 1 | Serverless Microservices |
| **Developer Experience** | 1 | eShop |
| **Observability** | 1 | eShop |
| **Framework Independence** | 2 | Clean Architecture Template, BuckPal |
| **Separation of Concerns** | 1 | Clean Architecture Template |
| **Cognitive Simplicity** | 1 | Modular Monolith with DDD |
| **Operational Excellence** | 1 | AKS Baseline Cluster |

### Key Findings

1. **Testability is the #1 quality attribute** (4 of 8), reflecting the teaching purpose of these projects. Reference implementations exist to show developers how to write testable code — and Hexagonal Architecture (BuckPal, Clean Architecture, Wild Workouts) is specifically chosen *because* it enables testing each layer independently.

2. **Maintainability is #2** (3 of 8). This aligns with the Hexagonal/Clean Architecture pattern, where the explicit goal is dependency inversion to prevent coupling to frameworks, databases, and external services. BuckPal's book subtitle is literally about "clean architecture" for maintainability.

3. **Security appears in only 1 project** (AKS Baseline). This is notable — security is the 2nd most cited quality attribute in KataLog (37 of 78 teams) but is treated as an infrastructure concern (network policies, Key Vault, Azure Policy) rather than an application architecture concern in the reference implementations.

4. **Cost Efficiency appears in only 1 project** (Serverless Microservices), despite being the strongest quality-attribute predictor of KataLog placement (45% of winners vs. 14% of runners-up). Reference implementations generally ignore operational cost as a design consideration.

5. **Observability appears in only 1 project** (eShop with OpenTelemetry). The older projects predate the observability movement; only the newest project (eShop, 2023) includes distributed tracing.

---

## Project Maturity and Evolution

### Lifecycle Analysis

| Status | Projects | Implications |
|--------|----------|-------------|
| **Active (2025)** | eShop, Clean Architecture Template, AKS Baseline | Current best practices; actively incorporating new framework features |
| **Maintained (2024)** | Modular Monolith with DDD, BuckPal, Wild Workouts Go | Stable; occasional updates but core architecture frozen |
| **Maintained (2023)** | Serverless Microservices | Potentially stale; Azure Functions may have evolved |
| **Archived** | eShopOnContainers | Superseded by eShop; still valuable for its richer pattern set |

### The eShop → eShopOnContainers Succession

The evolution from eShopOnContainers (2017--2023) to eShop (2023--present) is itself architectural evidence:

- **eShopOnContainers** (25,000 stars): Full DDD, CQRS with MediatR, Envoy API Gateway, multiple UI frameworks, Kubernetes deployment, both RabbitMQ and Azure Service Bus implementations. Architecturally comprehensive but complex to run locally.
- **eShop** (6,000 stars): Simplified to .NET 8 Aspire, YARP reverse proxy, OpenTelemetry, Blazor-only UI. Trades architectural completeness for developer experience.

This succession demonstrates a real-world tension: **comprehensive reference architectures become too complex to learn from**, leading to simplification that sacrifices the very patterns teams need to see. The archived eShopOnContainers remains more architecturally informative than its successor for patterns like DDD bounded contexts, CQRS, and API Gateway.

---

## Pattern Coverage Analysis

Mapping the 8 reference implementations against the 12 canonical architecture styles used in the repository:

| Canonical Style | Reference Impl Coverage | Coverage Quality |
|----------------|------------------------|-----------------|
| **Microservices** | eShopOnContainers, eShop, Wild Workouts, Serverless Microservices, AKS Baseline | **Excellent** — 5 examples across C#, Go, Bicep |
| **Event-Driven** | eShopOnContainers, eShop, Modular Monolith, Serverless Microservices | **Good** — 4 examples, always as complementary pattern |
| **Hexagonal Architecture** | Clean Architecture Template, BuckPal, Wild Workouts | **Good** — 3 examples across C#, Java, Go |
| **CQRS** | eShopOnContainers, Clean Architecture Template, Wild Workouts | **Good** — 3 examples, all using command/query separation |
| **Domain-Driven Design** | eShopOnContainers, Modular Monolith, Wild Workouts | **Good** — 3 examples with aggregates, bounded contexts |
| **Modular Monolith** | Modular Monolith with DDD | **Minimal** — 1 example (C# only) |
| **Service-Based** | AKS Baseline | **Minimal** — 1 example (infrastructure only) |
| **Serverless** | Serverless Microservices | **Minimal** — 1 example (Azure only) |
| **Layered Architecture** | — | **None** |
| **Space-Based** | — | **None** |
| **Orchestration-Driven** | — | **None** |
| **Pipe-and-Filter** | — | **None** |

### Coverage Gaps

1. **Modular Monolith** — Only 1 reference despite being the highest-performing style in KataLog competitions. Teams interested in this pattern have Kamil Grzybek's C# project and nothing else. No Java, Go, Python, or TypeScript equivalents.

2. **Layered Architecture** — The most basic and widely taught style has zero reference implementations. This may be intentional (too simple to warrant a reference) or an oversight.

3. **Serverless** — Only 1 Azure-specific reference. Teams targeting AWS Lambda or GCP Cloud Functions have no equivalent.

4. **Service-Based** — Only represented by AKS Baseline, which is infrastructure-focused, not application-focused. Service-Based architecture is the 3rd most common style in KataLog (30.8%) but lacks a proper code-level reference.

5. **Pipeline/Pipe-and-Filter** — The dominant pattern in AOSA production systems (5 of 12) has no reference implementation. This is a significant gap between what production systems actually use and what reference architectures teach.

---

## Notable Strengths Across the Collection

### 1. Hexagonal Architecture Code-Level Clarity
The three Hexagonal implementations (BuckPal, Clean Architecture Template, Wild Workouts) collectively show the pattern in three languages with three approaches to package structure:

- **BuckPal** (Java): `adapter/in`, `adapter/out`, `application/port/in`, `application/port/out`, `domain` — the textbook ports-and-adapters structure
- **Clean Architecture Template** (C#): `Domain`, `Application`, `Infrastructure`, `Web` — four-layer structure with strict dependency rules
- **Wild Workouts** (Go): Idiomatic Go structure that achieves Clean Architecture without Java-like interface hierarchies

### 2. Module Boundary Enforcement
Modular Monolith with DDD is the only reference implementation that uses **architecture tests** (ArchUnit) to enforce that modules cannot reference each other's internals. This moves architectural constraints from documentation into automated verification — a practice the KataLog evidence shows correlates with winning (fitness functions).

### 3. Evolutionary Architecture Evidence
The eShopOnContainers → eShop succession and the Modular Monolith with DDD's "clear evolutionary path to microservices" design both provide concrete evidence for the evolutionary architecture approach that 73% of KataLog first-place winners employ.

### 4. Multi-Language Pattern Translation
For Hexagonal Architecture and Microservices, having examples in C#, Java, and Go allows practitioners to see how the same architectural pattern adapts to different language idioms. This is particularly valuable for Go (Wild Workouts), which demonstrates that clean architecture doesn't require Java-style abstraction.

---

## Notable Gaps Across the Collection

### 1. ADR Absence (7 of 8)
Only Modular Monolith with DDD documents architectural decisions. The other 7 projects show *what* was built but not *why*. This means the most impactful evidence from KataLog (ADR discipline predicts placement) is absent from the reference implementations that teams use to learn.

### 2. No Cost/Feasibility Analysis
None of the 8 projects include cost projections, capacity planning, or feasibility analysis — the single strongest predictor of KataLog placement. Reference implementations are "free to clone" but give no guidance on what they cost to operate.

### 3. No Fitness Functions
Only Modular Monolith with DDD includes architecture tests. None of the 8 projects demonstrate fitness functions for runtime architectural governance. This is the most underutilized winning practice from KataLog (~17% usage, 55% of winners).

### 4. Sample Domains Are Trivial
Six of eight projects use intentionally simple domains (To-Do, Conference Management, Banking, Fitness Scheduling, E-Commerce, Ride-Sharing). While this keeps the focus on architecture, it means complex domain challenges — multi-tenancy, regulatory compliance, real-time collaboration — are unaddressed.

### 5. No AI/ML Architecture Patterns
None of the 8 reference implementations cover AI-era patterns (multi-agent, RAG, LLM orchestration, vector databases) that dominate the most recent KataLog seasons (2024--2025).

---

## What Reference Architectures Uniquely Contribute

Compared to the other two evidence sources:

| Dimension | Reference Architectures | KataLog | AOSA |
|-----------|------------------------|---------|------|
| **Evidence type** | Working, deployable code | Design documents, diagrams | Production narratives by creators |
| **Validation** | Community adoption (stars), CI/CD | Judge evaluation, placement scoring | Years of production operation |
| **Key strength** | Can run it, read the code, step through it | Decision rationale, ADRs, tradeoff analysis | Operational reality, failure modes |
| **Key limitation** | Trivial domains, no decision rationale | No running code, no production validation | 2011--2012 era, no cloud-native |
| **Unique value** | Code-level pattern realization | What judges reward and statistical patterns | What survives production at scale |

**Reference Architectures are the only source where you can `git clone`, `docker compose up`, and see the architecture running.** This makes them indispensable for teams transitioning from architectural understanding to implementation — but their value is diminished by the absence of ADRs, cost analysis, and fitness functions that the KataLog evidence shows drive successful outcomes.

---

## Appendix: Per-Project Summary Table

| Project | Styles | Lang | Stars | Tests | CI/CD | ADRs | Key Contribution |
|---------|--------|------|-------|-------|-------|------|-----------------|
| eShopOnContainers | Microservices, EDA, DDD, CQRS | C# | 25K | Yes | Yes | No | Canonical .NET microservices reference with full DDD bounded contexts |
| Clean Architecture | Hexagonal, CQRS | C# | 17K | Yes | Yes | No | Most-starred .NET Clean Architecture; `dotnet new` scaffoldable |
| Modular Monolith | Modular Monolith, DDD, CQRS, EDA | C# | 11K | Yes | Yes | Yes | Only reference with ADRs and ArchUnit boundary tests |
| eShop | Microservices, EDA | C# | 6K | Yes | Yes | No | Modern .NET 8 Aspire successor with OpenTelemetry |
| Wild Workouts | DDD, Hexagonal, CQRS, Microservices | Go | 5K | Yes | Yes | No | Go-idiomatic Clean Architecture with gRPC + Pub/Sub |
| BuckPal | Hexagonal | Java | 3.5K | Yes | No | No | Minimal ports-and-adapters with companion book |
| AKS Baseline | Microservices, Service-Based | Bicep | 1.5K | No | Yes | No | Official Microsoft AKS production baseline |
| Serverless Microservices | Serverless, Microservices, EDA | C# | 600 | Yes | No | No | Azure serverless with Event Grid + Cosmos DB change feed |

---

*Generated: 2026-02-26 from structured YAML metadata in `evidence-analysis/ReferenceArchitectures/docs/catalog/`.*
