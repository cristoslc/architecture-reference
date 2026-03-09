# Architecture Style Reference

Production frequency data from 142 production repos (SPEC-022 deep-analysis, ADR-002). Use this context to inform classifications — knowing what's common vs rare helps calibrate confidence.

## Production Frequency Rankings

| Rank | Style | Count | % | Platform % | Application % |
|------|-------|-------|---|-----------|--------------|
| 1 | Microkernel | 83 | 58.5% | 61% | 55% |
| 2 | Layered | 78 | 54.9% | 47% | 67% |
| 3 | Modular Monolith | 57 | 40.1% | 41% | 38% |
| 4 | Event-Driven | 17 | 12.0% | 8% | 18% |
| 5 | Pipeline | 13 | 9.2% | 13% | 4% |
| 6 | Microservices | 12 | 8.5% | 13% | 2% |
| 7 | Service-Based | 7 | 4.9% | 5% | 5% |
| 8 | Hexagonal Architecture | 5 | 3.5% | 3% | 4% |
| 9 | Domain-Driven Design | 3 | 2.1% | 2% | 2% |
| 10 | Multi-Agent | 1 | 0.7% | 0% | 2% |
| 11 | Space-Based | 1 | 0.7% | 1% | 0% |
| 12 | CQRS | 1 | 0.7% | 0% | 2% |

74% of production repos exhibit exactly 2 styles. Multi-style composition is normal.

## Style Definitions

### Microkernel (Plugin Architecture)

A host application with extension points through which independently deployable plugins extend core functionality. The core provides lifecycle management, configuration, and shared services. Plugins provide domain-specific behavior and can be added, removed, or replaced without modifying the core.

**Distinguishing signals in code:**
- Plugin/extension registries or loaders
- Extension point interfaces or contracts
- Dynamic module loading or hot-reloading
- Host/plugin separation in directory structure
- Configuration-driven feature activation

**Common confusion:** Having configurable components doesn't make something Microkernel. Look for explicit extension points designed for third-party or unknown-at-build-time plugins.

**Examples:** VS Code (extensions), WordPress (plugins), n8n (nodes), Grafana (panels/datasources), ESLint (rules/plugins)

### Layered Architecture (N-Tier)

Horizontal separation into layers (typically presentation, business logic, data access), where each layer depends only on the layer below. Enforces strict dependency direction.

**Distinguishing signals in code:**
- Layer-named directories (controllers/, services/, repositories/, models/)
- Clear dependency flow: upper layers import from lower, never reverse
- Service/repository pattern separating business logic from data access
- Request flows down through layers and responses flow back up

**Common confusion with Pipeline:** Layered is about separating concerns by responsibility type (all UI here, all business logic there). Pipeline is about data transformation through stages. In Layered, every request goes through the same layers. In Pipeline, data flows forward through processing steps.

### Modular Monolith

Single deployable unit organized into well-defined, cohesive modules with clear boundaries. Modules are logically independent but share process, memory, and deployment.

**Distinguishing signals in code:**
- Module-per-directory structure with clear APIs between modules
- Module registries or feature management
- Internal module interfaces (not just folders, but actual boundary enforcement)
- Single deployment artifact (one Dockerfile, one deploy script)
- Feature toggles enabling/disabling entire modules

**Common confusion with Layered:** Layered separates by concern type (presentation/business/data). Modular Monolith separates by domain (orders module, users module, billing module). A system can be both.

### Event-Driven Architecture

Components communicate through events rather than direct synchronous calls. Producers emit events without knowledge of consumers.

**Distinguishing signals in code:**
- Message broker configuration (Kafka, RabbitMQ, NATS, Redis pub/sub)
- Event bus implementations (in-process or distributed)
- Event handler registrations
- Async message processing patterns
- Event schemas (Avro, Protobuf, AsyncAPI)

**Common confusion:** Having a message queue doesn't automatically make the ARCHITECTURE event-driven. Look at whether events are the PRIMARY communication mechanism or just used for one specific integration.

**Note:** Event-Driven means different things in different contexts: event-loop concurrency (NGINX), event sourcing as data model (Squidex), message-based integration (most common in code), or pub/sub communication.

### Pipeline (Pipe-and-Filter)

Data flows through ordered processing stages where each stage transforms input to output. Stages are independent, composable, and often stateless.

**Distinguishing signals in code:**
- Middleware chains or filter pipelines
- Stage-based processing with clear input/output contracts
- Data transformation chains
- Compiler/transpiler pass architectures
- ETL or data processing workflows

**Common confusion with Layered:** Pipeline is about data flowing FORWARD through transformation stages. Layered is about request/response flowing DOWN through concern layers. Pipeline stages are composable and can be rearranged; layers are fixed structural boundaries.

### Microservices

Independent, loosely coupled services deployed, scaled, and developed independently. Each service owns its data and communicates via APIs or messaging.

**Distinguishing signals in code:**
- Multiple independently deployable services (separate Dockerfiles, separate CI/CD)
- Per-service databases or data stores
- API gateway or service mesh configuration
- Inter-service communication code (HTTP clients, gRPC, message passing)
- Independent versioning per service

**Common confusion with Service-Based:** Microservices have full independence (own database, own deployment, own team ownership). Service-Based shares infrastructure (shared database, coordinated deployment).

### Service-Based Architecture

Coarse-grained service decomposition with shared infrastructure. Less distributed than microservices.

**Distinguishing signals in code:**
- Multiple services sharing a database
- Coarse service boundaries (fewer, larger services)
- Simple inter-service communication (direct HTTP, shared message bus)
- Coordinated deployment (single docker-compose, shared CI/CD)

### Hexagonal Architecture (Ports and Adapters, Clean Architecture)

Core business logic isolated with dependencies pointing inward. External concerns connect through ports (interfaces) and adapters (implementations).

**Distinguishing signals in code:**
- Port interfaces in the domain/application layer
- Adapter implementations in infrastructure layer
- Domain layer with ZERO external imports (no database, no HTTP, no framework)
- Explicit dependency inversion at module boundaries

**Common confusion with Microkernel:** Hexagonal is about dependency direction (keeping domain pure). Microkernel is about runtime extensibility (adding unknown future capabilities). A Hexagonal system has no plugin system. A Microkernel system may have terrible internal dependency management.

### Domain-Driven Design

Code organized around business domains using bounded contexts, aggregates, domain events, and ubiquitous language.

**Distinguishing signals in code:**
- Bounded context directories or packages
- Aggregate root patterns
- Domain event implementations
- Repository pattern (domain-specific, not generic ORM)
- Value objects and entities with behavior (not anemic models)

**Note:** DDD production frequency is very low (2.1%). It is far more common in tutorials and reference implementations than in production code. Be cautious about classifying based on directory names alone — many repos have a `domain/` folder without practicing DDD.

### Multi-Agent

Multiple autonomous agents with specialized capabilities collaborating through coordination protocols.

**Distinguishing signals in code:**
- Agent role definitions and specialization
- Multi-agent coordination (supervisor, orchestrator, swarm)
- Tool-use registries
- Agent-to-agent communication protocols

### Space-Based Architecture

In-memory distributed data grid with peer-to-peer replication and no central database.

**Distinguishing signals in code:**
- Distributed in-memory data structures
- Consistent hashing implementations
- Masterless replication protocols
- Eventual consistency mechanisms

### CQRS (Command Query Responsibility Segregation)

Separate read and write models. Commands modify state; queries operate on read-optimized projections.

**Distinguishing signals in code:**
- Explicit command and query separation (separate classes, handlers)
- Event store implementations
- Projection/read-model builders
- Separate write and read database configurations

**Note:** CQRS production frequency is very low (0.7%). Commonly seen in tutorials but rare in production. Be cautious.
