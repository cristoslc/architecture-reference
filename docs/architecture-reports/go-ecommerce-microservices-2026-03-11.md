# Architecture Report: go-ecommerce-microservices

**Date:** 2026-03-11
**Repository:** https://github.com/mehdihadeli/go-ecommerce-microservices
**Classification:** Microservices, Vertical Slice Architecture, CQRS, Event-Driven, Domain-Driven Design, Event Sourcing
**Confidence:** 0.97
**Analyst Model:** claude-sonnet-4-6
**Method:** deep-analysis

---

## Summary

go-ecommerce-microservices (marketed as "Go Food Delivery Microservices") is a polyglot-free, pure-Go reference implementation demonstrating how to combine Microservices, Vertical Slice Architecture, CQRS, Event-Driven communication, Domain-Driven Design, and Event Sourcing in a single cohesive codebase. Three independently deployable Go services — Catalog Write, Catalog Read, and Order — share no runtime process. Each service organises its internals as vertical slices (one folder per use-case feature), dispatches commands and queries through a Go-MediatR mediator, publishes and consumes integration events over RabbitMQ, and uses Uber Fx for compile-time dependency injection. The Order service elevates the pattern further with a full EventSourcedAggregateRoot backed by EventStoreDB, making it a true Event Sourcing implementation. Synchronous inter-service calls use gRPC. The observability stack (OpenTelemetry, Prometheus, Grafana, Jaeger, Tempo) is first-class. Traefik acts as the API gateway. Kubernetes manifests and Skaffold configuration are provided for cloud deployment.

---

## Evidence

### Repository Top-Level Layout

```
go-ecommerce-microservices/
├── internal/
│   ├── services/
│   │   ├── catalogwriteservice/   # Catalog Write — Postgres (GORM), RabbitMQ producer
│   │   ├── catalogreadservice/    # Catalog Read — MongoDB + Elasticsearch, RabbitMQ consumer
│   │   └── orderservice/         # Order — EventStoreDB (Event Sourcing), MongoDB read model
│   └── pkg/                       # Shared infrastructure library (never domain logic)
│       ├── rabbitmq/              # Custom RabbitMQ bus, producer, consumer abstractions
│       ├── es/                    # EventSourcedAggregateRoot base implementation
│       ├── eventstroredb/         # EventStoreDB client wiring
│       ├── grpc/                  # gRPC server + client helpers
│       ├── otel/                  # OpenTelemetry tracing + metrics pipeline
│       ├── postgresgorm/          # GORM/Postgres wiring
│       ├── mongodb/               # MongoDB wiring
│       └── fxapp/                 # Uber Fx application lifecycle helpers
├── api/
│   ├── protobuf/                  # gRPC service contracts (catalogwriteservice, orderservice)
│   └── openapi/                   # Swagger/OpenAPI REST contracts
├── deployments/
│   ├── docker-compose/            # Infra compose (RabbitMQ, Postgres, MongoDB, EventStoreDB,
│   │                              #   Elasticsearch, Redis, Prometheus, Grafana, Jaeger, Tempo)
│   └── kubernetes/                # Skaffold config for Kubernetes deployment
└── buf.work.yaml                  # Buf workspace for Protobuf linting
```

### Service-Level Layout (Catalog Write — representative)

```
catalogwriteservice/
├── cmd/app/main.go                          # Entry point — Cobra + Uber Fx bootstrap
├── config/                                  # Viper-based config (JSON per env)
└── internal/
    ├── shared/configurations/catalogs/
    │   ├── infrastructure/                  # Fx modules: GORM, RabbitMQ, gRPC, OTel
    │   └── catalogs_configurator.go         # Top-level DI wiring
    └── products/
        ├── features/
        │   ├── creatingproduct/v1/          # Vertical slice: endpoint + handler + DTOs + events
        │   ├── updatingproduct/v1/
        │   ├── deletingproduct/v1/
        │   ├── gettingproducts/v1/
        │   └── gettingproductbyid/v1/
        ├── models/                          # Domain model (Product)
        ├── data/repositories/               # Repository contract + GORM implementation
        └── configurations/                  # Mediator + RabbitMQ + mapping registrations
```

---

## Styles Identified with Evidence

### Primary: Microservices

**1. Three Independent Deployable Services with Separate Go Modules**

Each service has its own `go.mod`, `Dockerfile`, `cmd/app/main.go`, `Makefile`, and `taskfile.yml`. They share no runtime process and no shared in-process state:

- `internal/services/catalogwriteservice/go.mod`
- `internal/services/catalogreadservice/go.mod`
- `internal/services/orderservice/go.mod`

The `internal/pkg/` library is a shared *infrastructure* dependency (imported as a versioned Go module), not a shared domain; all domain logic remains isolated per service.

**2. Database-Per-Service**

Each service uses a dedicated, distinct data store:

| Service | Write Store | Read Store |
|---|---|---|
| Catalog Write | PostgreSQL (GORM) | — |
| Catalog Read | — | MongoDB + Elasticsearch |
| Order | EventStoreDB (events) | MongoDB (read model) |

Development configs confirm separate connection strings with distinct DB names (`catalogs_write_service`, no shared schema). The Catalog Read service has no direct Postgres access and is fed exclusively via RabbitMQ integration events.

**3. Asynchronous Integration via RabbitMQ**

The `internal/pkg/rabbitmq/` package implements a full custom event bus (producer, consumer, bus) using `github.com/rabbitmq/amqp091-go`. Integration events flow one-way from producers to consumers:

- `catalogwriteservice` publishes `ProductCreatedV1`, `ProductUpdatedV1`, `ProductDeletedV1`
- `catalogreadservice` consumes those events to maintain its MongoDB/Elasticsearch read model
- `orderservice` consumes product events and produces `OrderCreatedV1`

Consumer handlers in `catalogreadservice` (e.g., `productUpdatedConsumer.Handle`) are wired independently of the write side, enforcing full decoupling.

**4. Synchronous gRPC for Real-Time Inter-Service Calls**

Protobuf contracts exist for both catalog and order services:

- `api/protobuf/catalogwriteservice/products.proto`
- `api/protobuf/orderservice/orders.proto`

The `internal/pkg/grpc/` package provides a generic gRPC server and typed client. This allows real-time query calls between services when asynchronous messaging latency is unacceptable.

**5. Traefik API Gateway**

`deployments/docker-compose/traefik/traefik.toml` configures Traefik with HTTP (`:80`), HTTPS (`:443`), and a metrics endpoint. `dynamic_conf.toml` defines routing rules to backend services, confirming that external traffic enters through a single gateway.

**6. Kubernetes + Skaffold Deployment**

`deployments/kubernetes/skaffold.yaml` provides cloud-native deployment configuration. Each service is independently containerizable and deployable.

---

### Secondary: Vertical Slice Architecture

**Feature-Folder Organisation — Every Use-Case is a Self-Contained Slice**

Within each service, code is not split by technical layer (controllers, services, repositories) but by *feature*. Each feature folder contains everything needed for that use-case: endpoint, command/query, handler, DTOs, events, and mappings.

Representative structure for `creatingproduct/v1/`:

```
creatingproduct/v1/
├── create_product_endpoint.go       # Echo HTTP endpoint handler
├── create_product.go                # Command struct (CreateProduct)
├── create_product_handler.go        # MediatR handler — orchestrates persistence + event
├── dtos/
│   ├── create_product_request_dto.go
│   └── create_product_response_dto.go
└── events/integrationevents/
    └── product_created.go            # Integration event published to RabbitMQ
```

The handler (`create_product_handler.go`) is a single-purpose function that:
1. Persists the product via `gormdbcontext.AddModel`
2. Maps to DTO
3. Publishes `ProductCreatedV1` to RabbitMQ

No shared "ProductService" class coordinates across features. Each slice is independently testable and independently deployable in terms of change surface.

**Version Namespacing in Slices**

All features are namespaced under `v1/` subfolders, enabling additive versioning (`v2/`) without modifying existing slices.

---

### Secondary: CQRS

**Mediator Pattern via Go-MediatR**

The project imports `github.com/mehdihadeli/go-mediatr` across all three services. Every feature either registers a command handler (write) or a query handler (read):

```go
// create_product_handler.go
func (c *createProductHandler) RegisterHandler() error {
    return mediatr.RegisterRequestHandler[*CreateProduct, *dtos.CreateProductResponseDto](c)
}
```

Endpoints dispatch commands/queries via `mediatr.Send[TResponse]()`, never calling handlers directly. This enforces a pipeline between the HTTP/gRPC layer and the application layer.

**Structural Command/Query Separation**

Features are named and organised to signal their intent:
- Commands: `creatingproduct`, `updatingproduct`, `deletingproduct`, `creating_order`, `submitting_order`
- Queries: `gettingproducts`, `gettingproductbyid`, `getting_orders`, `getting_order_by_id`

The Catalog Read service has no write-path features at all — it is a pure query projection service. This is the clearest CQRS signal: write and read models run in separate processes backed by separate databases.

**Mediator Pipelines for Cross-Cutting Concerns**

`internal/pkg/otel/metrics/mediatr/pipelines/mediator_metrics_pipeline.go` shows a metrics pipeline decorating the mediator, confirming that logging, validation, and observability are applied as pipeline behaviours rather than inline in handlers.

---

### Secondary: Event-Driven Architecture

**Integration Events as the Inter-Service Contract**

Events are defined as typed Go structs embedding `*types.Message` (which carries a UUID `MessageId` and timestamp). The write service publishes; the read service consumes:

```go
// catalogwriteservice — integration event definition
type ProductCreatedV1 struct {
    *types.Message
    *dtoV1.ProductDto
}
```

```go
// catalogreadservice — consumer
func (c *productUpdatedConsumer) Handle(ctx context.Context, consumeContext types.MessageConsumeContext) error {
    message, ok := consumeContext.Message().(*ProductUpdatedV1)
    // ... dispatches UpdateProduct command via mediatr
}
```

The consumer dispatches an internal CQRS command, maintaining clean separation between the messaging layer and application logic.

**Domain Events Within Aggregates (Order Service)**

The Order aggregate raises domain events on state transitions:

```go
// order.go — aggregate root
event, err := createOrderDomainEventsV1.NewOrderCreatedEventV1(id, itemsDto, ...)
err = order.Apply(event, true)
```

These domain events are applied via the `When(event IDomainEvent)` dispatch method, which is the standard event sourcing pattern for updating aggregate state from events rather than from direct mutation.

---

### Secondary: Domain-Driven Design

**Aggregate with Value Objects**

The Order service implements a full DDD aggregate:

- `internal/services/orderservice/internal/orders/models/orders/aggregate/order.go` — `Order` struct embedding `*models.EventSourcedAggregateRoot` with private fields enforcing encapsulation
- `internal/services/orderservice/internal/orders/models/orders/value_objects/shop_item.go` — `ShopItem` value object
- Domain invariants enforced in the aggregate factory: nil shop items rejected with a typed domain exception (`domainExceptions.NewOrderShopItemsRequiredError`)
- Domain exceptions in `internal/services/orderservice/internal/orders/exceptions/domain_exceptions/`
- Repository contracts (`contracts/repositories/`) separated from implementations

The Catalog Write service also uses a domain model (`models/Product`) with a repository interface defined in `contracts/` and implemented in `data/repositories/`, following the repository pattern.

**Bounded Context Isolation**

Each service represents a distinct bounded context:
- **Catalog Write Context**: product catalogue management, Postgres, write-optimized
- **Catalog Read Context**: product discovery and search, MongoDB + Elasticsearch, read-optimized
- **Order Context**: order lifecycle, EventStoreDB, DDD aggregate with Event Sourcing

No domain types cross service boundaries. The Catalog Read service defines its own local copies of product event payloads rather than importing types from the Catalog Write service.

---

### Secondary: Event Sourcing

**EventSourcedAggregateRoot Base Class**

`internal/pkg/es/models/event_sourced_aggregate.go` defines the full event sourcing contract:

- `Apply(event IDomainEvent, isNew bool) error` — records events to pending changes; increments `CurrentVersion`
- `fold(event IDomainEvent, metadata Metadata) error` — replays events to rebuild state; advances `LastCommittedVersion`
- `When(event IDomainEvent) error` — the aggregate-defined state transition function
- `OriginalVersion()` / `SetOriginalVersion()` — optimistic concurrency control

The `Order` aggregate embeds this base class and delegates state mutations exclusively to `onOrderCreated`, `onShoppingCartUpdated`, etc., which are called only from `When`. No direct field assignment outside of the `When` dispatch path.

**EventStoreDB as the Event Store**

`internal/pkg/eventstroredb/eventstroredb.go` wires the official EventStore Go client (`github.com/EventStore/EventStore-Client-Go/esdb`). EventStoreDB is the authoritative write store for the Order service — events are the source of truth, not a relational table.

**Read Model Projection**

`internal/services/orderservice/internal/orders/models/orders/read_models/order_read.go` defines a separate flat read model for MongoDB, confirming the event sourcing projection pattern: events stored in EventStoreDB are projected into a denormalized MongoDB document for query access.

---

## Quality Attributes with Justification

| Attribute | Justification |
|---|---|
| **Scalability** | Three independently deployable services scale independently. RabbitMQ decouples producer and consumer throughput. Read service can scale horizontally with MongoDB/Elasticsearch replication. Each Go service is a single binary with minimal resource footprint. |
| **Observability** | First-class OpenTelemetry integration across all three services and the messaging pipeline. Traces exported to Jaeger and Tempo. Metrics via Prometheus and Grafana. OTel mediator pipeline (`mediator_metrics_pipeline.go`) instruments every command/query dispatch. Structured logging with Uber Zap. |
| **Maintainability** | Vertical Slice Architecture localises change to a single feature folder. Adding a new use-case adds a new directory without modifying any existing handler, service class, or route registration. Uber Fx DI wiring isolates infrastructure provisioning from application logic. |
| **Testability** | Integration tests use `testcontainers-go` to spin up real RabbitMQ, Postgres, MongoDB, and EventStoreDB instances per test run. Unit tests mock via Mockery-generated interfaces (`mocks/` directories per service). CQRS mediator handler boundary is the natural test seam. |
| **Decoupling** | Database-per-service, message-based integration, and separate Go modules prevent any runtime or compile-time coupling between services. The Catalog Read service has zero direct knowledge of the Catalog Write service's domain model. |
| **Evolvability** | Versioned feature slices (`v1/`) allow additive API versioning without breaking changes. Protobuf contracts with Buf workspace enable backward-compatible gRPC evolution. Event Sourcing on the Order service provides a full audit log enabling future replay-based projections. |
| **Fault Tolerance** | RabbitMQ consumer retry logic. `avast/retry-go` used in infrastructure calls. Health check endpoints registered per service. Docker Compose infrastructure services include restart policies (`restart: unless-stopped`) and healthchecks. |
| **Auditability** | Event Sourcing in the Order service means every state change is recorded as an immutable event in EventStoreDB, providing a complete, replayable audit trail for the most business-critical domain. |

---

## Ruled Out

- **Monolith / Modular Monolith**: Three separate Go modules, separate `go.mod` files, separate binaries, separate Dockerfiles. No single deployable artifact.
- **Layered (N-Tier)**: Code is organised by feature, not by technical layer. There is no shared `services/` or `controllers/` folder spanning the whole application.
- **Hexagonal / Ports-and-Adapters**: While repository interfaces and messaging abstractions resemble port definitions, the architecture is explicitly documented as Vertical Slice, not Hexagonal. The adapter naming convention and strict port/adapter separation are absent.
- **Service Mesh**: No Istio or Envoy. Traefik is an API gateway (L7 routing), not a service mesh (no mTLS, no sidecar proxies).
- **Serverless / Pipeline / Space-Based / Microkernel / Multi-Agent**: No evidence of any of these patterns.

---

## Classification Reasoning

go-ecommerce-microservices is a deliberate, reference-quality implementation of multiple complementary architectural patterns that the Go ecosystem community has increasingly adopted together. The classification reflects the actual source code, not just the README claims.

**Microservices** is the outermost structural pattern: three independent Go modules, three Dockerfiles, three separate database clusters, and a message broker as the integration boundary. This is confirmed and unambiguous.

**Vertical Slice Architecture** is the intra-service organisation strategy. Feature folders, not technical layers, are the primary unit of change. The `creatingproduct/v1/` slice contains the endpoint, command, handler, DTOs, and integration event in one place — confirmed by directory structure and file contents.

**CQRS** is enforced mechanically via the Go-MediatR mediator. Commands and queries are distinct types dispatched through a pipeline. The Catalog Read service existing as a separate process with a separate database is the ultimate CQRS signal: the query model is not just a read projection on the write database — it is a completely separate service.

**Event-Driven Architecture** is the inter-service communication mechanism. RabbitMQ integration events (`ProductCreatedV1`, `ProductUpdatedV1`, `ProductDeletedV1`, `OrderCreatedV1`) flow through the custom messaging bus. Consumers dispatch internal CQRS commands, maintaining clean layer separation.

**Domain-Driven Design** is applied where it adds value: the Order aggregate is a textbook DDD aggregate root with value objects, domain events, domain exceptions, and repository contracts. The Catalog Write service uses a lighter DDD model (repository pattern, domain model, but no aggregate root).

**Event Sourcing** is applied exclusively to the Order service, which is the audit-critical bounded context. `EventSourcedAggregateRoot` enforces the event-append-only write pattern. EventStoreDB is the primary store. A separate MongoDB read model is projected from events, completing the Event Sourcing + CQRS + Event-Driven trifecta for that service.

Confidence is **0.97**. The patterns are not incidental — they are the explicit design intent, implemented correctly and consistently across all three services, with every key mechanism verifiable directly in source code.
