# Signal-to-Style Mapping Rules

Rules for classifying architecture styles from filesystem signals. Applied in order of specificity — more specific rules override general ones. Multiple styles can match (multi-style composition is normal; 73% of winning kata teams use 2+ styles).

## Signal categories

### 1. Package manifests

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| Node.js project | `package.json` | JavaScript/TypeScript ecosystem |
| Go module | `go.mod` | Go ecosystem |
| Java/Maven | `pom.xml` | Java ecosystem (Maven) |
| Java/Gradle | `build.gradle`, `build.gradle.kts` | Java/Kotlin ecosystem (Gradle) |
| Python | `requirements.txt`, `pyproject.toml`, `setup.py`, `Pipfile` | Python ecosystem |
| .NET | `*.csproj`, `*.sln`, `*.fsproj` | .NET ecosystem |
| Rust | `Cargo.toml` | Rust ecosystem |
| Multi-language | 2+ distinct ecosystems | Potential microservices (separate services in different languages) |

### 2. Container orchestration

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| Docker | `Dockerfile` | Containerized deployment |
| Multi-container | 2+ `Dockerfile` files | Multiple deployable units → Microservices signal |
| Docker Compose | `docker-compose.yml`, `docker-compose.*.yml` | Multi-service local orchestration |
| Kubernetes | `**/k8s/**`, `**/kubernetes/**`, files matching `kind: Deployment` | K8s orchestration → Microservices signal |
| Helm | `Chart.yaml`, `**/charts/**` | Helm-packaged K8s → Microservices signal |

### 3. Infrastructure as Code

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| Terraform | `*.tf`, `**/.terraform/**` | IaC-managed infrastructure |
| CloudFormation | `template.yaml` with `AWSTemplateFormatVersion`, `*.cfn.json` | AWS IaC |
| Pulumi | `Pulumi.yaml` | Multi-cloud IaC |
| Bicep | `*.bicep` | Azure IaC |
| CDK | `cdk.json` | AWS CDK |
| Serverless Framework | `serverless.yml`, `serverless.ts` | **Serverless** style signal |
| SAM | `template.yaml` with `AWS::Serverless` | **Serverless** style signal |
| Lambda functions | `**/lambda/**`, `**/functions/**` with handler patterns | **Serverless** style signal |

### 4. Messaging and event infrastructure

| Signal | Files / patterns | What it indicates |
|--------|-----------------|-------------------|
| Kafka | `kafka` in configs, `KafkaProducer`/`KafkaConsumer` imports | **Event-Driven** style signal |
| RabbitMQ | `rabbitmq` in configs, `amqplib`/`pika` imports | **Event-Driven** style signal |
| NATS | `nats` in configs/imports | **Event-Driven** style signal |
| Redis pub/sub | Redis with pub/sub patterns | **Event-Driven** style signal |
| AWS SNS/SQS | SNS/SQS in configs or IaC | **Event-Driven** style signal |
| Azure Service Bus | Service Bus in configs | **Event-Driven** style signal |
| Event schemas | `*.avsc` (Avro), `*.proto` (Protobuf), AsyncAPI specs | **Event-Driven** style signal (strong) |
| Domain events | Files/classes matching `*Event`, `*EventHandler`, `event-bus` | **Event-Driven** + **DDD** signal |

### 5. API specifications

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| OpenAPI/Swagger | `openapi.yaml`, `swagger.json`, `*.swagger.*` | REST API presence |
| gRPC | `*.proto` files | gRPC service definitions → potential Microservices |
| GraphQL | `schema.graphql`, `*.graphql` | GraphQL API |
| AsyncAPI | `asyncapi.yaml`, `asyncapi.json` | Async API definition → **Event-Driven** signal |
| API Gateway | Kong, Envoy, API Gateway configs | **Microservices** signal (gateway pattern) |
| Multiple API specs | 2+ separate OpenAPI/proto specs | **Microservices** signal (multiple service APIs) |

### 6. Architecture decision records

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| ADR directory | `docs/adr/`, `docs/decisions/`, `adr/`, `doc/adr/` | Architecture documentation maturity |
| ADR count | Number of `*.md` files in ADR directories | Quality signal (winners avg 15 ADRs) |
| MADR format | Files matching `NNNN-*.md` pattern | Structured decision records |

### 7. Directory structure patterns

| Signal | Pattern | What it indicates |
|--------|---------|-------------------|
| Layered N-tier | `controllers/`, `services/`, `repositories/` (or `models/`, `views/`, `controllers/`) | **Layered** style |
| Hexagonal ports/adapters | `ports/`, `adapters/`, `domain/`, `application/`, `infrastructure/` | **Hexagonal Architecture** |
| DDD tactical patterns | `domain/`, `aggregates/`, `entities/`, `value-objects/`, `bounded-contexts/` | **Domain-Driven Design** |
| Modular boundaries | Top-level `modules/` with self-contained subfolders each having their own layers | **Modular Monolith** |
| Service decomposition | Top-level `services/` or `apps/` with independent deployable subdirectories | **Microservices** or **Service-Based** |
| CQRS separation | `commands/`, `queries/` (or `read-models/`, `write-models/`) | **CQRS** |
| Pipe stages | `pipeline/`, `stages/`, `filters/`, `processors/` with sequential naming | **Pipe-and-Filter** |
| Monorepo with packages | `packages/` with shared libraries + service directories | **Microservices** in monorepo |

### 8. CI/CD

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| GitHub Actions | `.github/workflows/*.yml` | CI/CD automation |
| GitLab CI | `.gitlab-ci.yml` | CI/CD automation |
| Jenkins | `Jenkinsfile` | CI/CD automation |
| Multiple deploy targets | Separate CI jobs deploying different services | **Microservices** signal |

### 9. Test structure

| Signal | Pattern | What it indicates |
|--------|---------|-------------------|
| Unit tests | `test/`, `tests/`, `__tests__/`, `*_test.go`, `*Test.java` | Basic test coverage |
| Integration tests | `integration-test/`, `e2e/`, `test/integration/` | Integration testing |
| Contract tests | Pact files, contract test directories | **Microservices** signal (consumer-driven contracts) |
| Architecture tests | ArchUnit, fitness function patterns | Architecture governance maturity |

### 10. Documentation

| Signal | Files | What it indicates |
|--------|-------|-------------------|
| C4 diagrams | `c4-*.md`, `*.puml` with C4 keywords, Structurizr files | Architecture documentation maturity |
| Architecture docs | `ARCHITECTURE.md`, `docs/architecture/` | Documentation maturity |
| Domain model docs | `docs/domain/`, bounded context maps | **DDD** signal |

## Classification rules

Rules are applied after all signals are collected. Confidence scores are cumulative — more matching signals increase confidence.

### Microservices

**Strong signals (confidence += 0.3 each):**
- Multiple Dockerfiles (2+) in separate service directories
- Kubernetes manifests or Helm charts
- API Gateway configuration
- Multiple independent OpenAPI/gRPC specs

**Supporting signals (confidence += 0.1 each):**
- Docker Compose with 3+ services
- Service discovery configuration
- Contract tests
- Multiple CI deploy targets
- Multi-language codebase

**Threshold:** Classify as Microservices if confidence >= 0.4

### Event-Driven

**Strong signals (confidence += 0.3 each):**
- Message broker configuration (Kafka, RabbitMQ, NATS, SNS/SQS)
- Event schema definitions (Avro, AsyncAPI)
- Domain event classes/handlers

**Supporting signals (confidence += 0.1 each):**
- Pub/sub patterns in code
- Event sourcing patterns (event store, projections)
- Saga/choreography patterns

**Threshold:** Classify as Event-Driven if confidence >= 0.3

### Modular Monolith

**Strong signals (confidence += 0.3 each):**
- Single deployable (1 Dockerfile or no container)
- `modules/` directory with self-contained subfolders
- Internal event bus (in-process messaging)

**Supporting signals (confidence += 0.1 each):**
- Module-level encapsulation (each module has its own layers)
- Shared database with module-scoped schemas
- No service discovery or API gateway

**Threshold:** Classify as Modular Monolith if confidence >= 0.4
**Conflict rule:** If both Microservices and Modular Monolith signal, prefer Microservices if Kubernetes/Helm present, otherwise prefer Modular Monolith.

### Domain-Driven Design

**Strong signals (confidence += 0.3 each):**
- `domain/` + `aggregates/` or `entities/` directory structure
- Bounded context boundaries visible in code organization
- Domain event classes

**Supporting signals (confidence += 0.1 each):**
- Value object patterns
- Repository pattern (distinct from data access layer)
- Anti-corruption layer patterns
- Ubiquitous language in naming conventions

**Threshold:** Classify as DDD if confidence >= 0.3
**Note:** DDD is almost always a secondary style alongside a primary (Event-Driven, Microservices, Modular Monolith).

### Hexagonal Architecture

**Strong signals (confidence += 0.3 each):**
- `ports/` and `adapters/` directories
- `application/` + `infrastructure/` + `domain/` separation
- Explicit dependency inversion (interfaces in domain, implementations in infrastructure)

**Supporting signals (confidence += 0.1 each):**
- Clean Architecture naming patterns (`use-cases/`, `interactors/`)
- Inbound/outbound adapter separation

**Threshold:** Classify as Hexagonal if confidence >= 0.3

### CQRS

**Strong signals (confidence += 0.3 each):**
- `commands/` and `queries/` directory separation
- Separate read and write models
- MediatR or similar mediator pattern usage

**Supporting signals (confidence += 0.1 each):**
- Read replicas or projection patterns
- Command handler / query handler classes
- Event sourcing alongside command processing

**Threshold:** Classify as CQRS if confidence >= 0.3

### Serverless

**Strong signals (confidence += 0.3 each):**
- `serverless.yml` or SAM template
- Lambda/Cloud Functions handler patterns
- Function-level deployment units

**Supporting signals (confidence += 0.1 each):**
- API Gateway + Lambda integration
- Step Functions / Durable Functions
- No long-running process configuration

**Threshold:** Classify as Serverless if confidence >= 0.4

### Layered

**Strong signals (confidence += 0.2 each):**
- `controllers/` + `services/` + `repositories/` pattern
- MVC directory structure
- Traditional N-tier organization

**Supporting signals (confidence += 0.1 each):**
- Single deployment unit
- Shared database access from service layer
- No event infrastructure

**Threshold:** Classify as Layered if confidence >= 0.3
**Note:** Layered is the default/fallback when no other style signals strongly. Apply only if no other style exceeds its threshold.

### Service-Based

**Strong signals (confidence += 0.2 each):**
- 2-5 coarse-grained service directories (fewer than typical microservices)
- Shared database across services
- Simpler orchestration than full microservices

**Threshold:** Classify as Service-Based if confidence >= 0.3
**Conflict rule:** If Microservices also signals, prefer Microservices if service count > 5 or k8s present.

### Space-Based

**Strong signals (confidence += 0.3 each):**
- In-memory data grid (Hazelcast, Apache Ignite, Redis Cluster)
- Processing unit pattern
- Virtualized middleware configuration

**Threshold:** Classify as Space-Based if confidence >= 0.4

### Pipe-and-Filter

**Strong signals (confidence += 0.3 each):**
- `pipeline/` or `stages/` directory with sequential processors
- ETL or data transformation pipeline patterns
- Filter chain patterns

**Threshold:** Classify as Pipe-and-Filter if confidence >= 0.3

### Multi-Agent

**Strong signals (confidence += 0.3 each):**
- Agent definitions (AGENTS.md, agent configs)
- Multi-agent coordination patterns
- Autonomous agent processing units

**Threshold:** Classify as Multi-Agent if confidence >= 0.4

## Overall confidence calculation

1. Sum per-style confidences from signal matches
2. Overall confidence = max(per-style confidences)
3. If no style exceeds its threshold: overall confidence < 0.3, classify as "Indeterminate"
4. If only Layered matches: cap overall confidence at 0.5 (it's the default fallback)
5. Multi-style bonus: if 2+ styles exceed threshold, add 0.1 to overall confidence (capped at 1.0)

## Quality attribute inference

Infer quality attributes from detected signals:

| Signal | Inferred quality attribute |
|--------|---------------------------|
| Horizontal scaling configs (k8s replicas, auto-scaling) | Scalability |
| Circuit breaker / retry patterns | Fault Tolerance |
| Monitoring / observability setup (OpenTelemetry, Prometheus) | Observability |
| Multiple environments in CI/CD | Deployability |
| Feature flags | Evolvability |
| Encryption / auth configs | Security |
| Cache layers | Performance |
| Event sourcing | Data Integrity |
| Contract tests | Interoperability |
| Modular boundaries | Modularity |
