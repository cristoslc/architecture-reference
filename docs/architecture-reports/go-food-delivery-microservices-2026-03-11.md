# Architecture Report: go-food-delivery-microservices

**Date:** 2026-03-11
**Repository:** https://github.com/mehdihadeli/go-food-delivery-microservices
**Classification:** Microservices, Event-Driven, CQRS, Domain-Driven Design
**Confidence:** 0.95
**Analyst Model:** claude-sonnet-4-6
**Method:** deep-analysis
**SPEC:** SPEC-031

---

## Summary

go-food-delivery-microservices is an intentionally instructional Go codebase that implements a food delivery platform as three independently deployable microservices (`catalogwriteservice`, `catalogreadservice`, `orderservice`). The README is explicit about the design intent: "Microservices Architecture, Vertical Slice Architecture, CQRS Pattern, Domain Driven Design (DDD), Event Sourcing, Event Driven Architecture." Every structural and behavioral signal in the repository confirms this. Services are independently built and deployed (separate `go.mod` files, separate `Dockerfile`s, separate port allocations), communicate asynchronously over RabbitMQ and synchronously over gRPC, maintain strict database-per-service isolation (PostgreSQL for catalog writes, MongoDB + Redis for catalog reads, MongoDB + EventStoreDB for orders), and organize internal code using vertical feature slices mediated by a `go-mediatr` dispatcher. The Order aggregate is fully event-sourced with MongoDB and Elasticsearch projections. This is a textbook Microservices system with Event-Driven, CQRS, and DDD as integral secondary styles.

---

## Repository Structure

```
go-food-delivery-microservices/
├── internal/
│   ├── pkg/                         # Shared infrastructure packages
│   │   ├── core/cqrs/               # Command/Query interface types
│   │   ├── core/messaging/bus/      # Bus interface (Producer + Consumer)
│   │   ├── es/                      # Event Sourcing framework (EventSourcedAggregateRoot)
│   │   ├── rabbitmq/                # RabbitMQ producer/consumer implementation
│   │   ├── postgresgorm/            # PostgreSQL/GORM integration
│   │   ├── mongodb/                 # MongoDB integration
│   │   ├── elasticsearch/           # Elasticsearch integration
│   │   ├── redis/                   # Redis integration
│   │   ├── eventstroredb/           # EventStoreDB integration
│   │   └── otel/                    # OpenTelemetry tracing/metrics
│   └── services/
│       ├── catalogwriteservice/     # Write side of Catalog bounded context
│       │   ├── Dockerfile
│       │   ├── go.mod               # Independent Go module
│       │   ├── config/config.development.json  # HTTP :7000, gRPC :6003, PostgreSQL
│       │   └── internal/products/features/
│       │       ├── creatingproduct/v1/
│       │       ├── updatingproduct/
│       │       ├── deletingproduct/
│       │       ├── gettingproductbyid/
│       │       ├── gettingproducts/
│       │       └── searchingproduct/
│       ├── catalogreadservice/      # Read side of Catalog bounded context
│       │   ├── Dockerfile
│       │   ├── go.mod               # Independent Go module
│       │   ├── config/config.development.json  # HTTP :7001, gRPC :6004, MongoDB + Redis
│       │   └── internal/products/features/
│       │       ├── creating_product/v1/
│       │       ├── getting_products/
│       │       ├── get_product_by_id/
│       │       └── searching_products/
│       └── orderservice/            # Order bounded context with Event Sourcing
│           ├── Dockerfile
│           ├── go.mod               # Independent Go module
│           ├── config/config.development.json  # HTTP :8000, gRPC :6005, MongoDB + EventStoreDB
│           └── internal/orders/
│               ├── models/orders/aggregate/order.go  # EventSourced aggregate
│               ├── models/orders/value_objects/
│               ├── projections/                      # Mongo + Elastic projections
│               └── features/
│                   ├── creating_order/
│                   ├── getting_orders/
│                   ├── getting_order_by_id/
│                   ├── submitting_order/
│                   └── updating_shopping_card/
├── api/
│   ├── protobuf/                    # gRPC service definitions
│   └── openapi/                     # Swagger/OpenAPI specs
└── deployments/
    ├── docker-compose/              # Full infrastructure docker-compose
    └── kubernetes/                  # Kubernetes manifests (in progress)
```

---

## Styles Identified with Evidence

### Primary: Microservices

**1. Three Independently Deployable Services**

Each service is a fully independent Go module with its own `Dockerfile`, `go.mod`, and port allocation. The `replace` directive in each service's `go.mod` resolves the shared `internal/pkg` locally without coupling the module graph at publish time:

```
# catalogwriteservice/go.mod
module github.com/mehdihadeli/go-food-delivery-microservices/internal/services/catalogwriteservice
go 1.22
replace github.com/mehdihadeli/go-food-delivery-microservices/internal/pkg => ../../pkg/

# catalogreadservice/go.mod
module github.com/mehdihadeli/go-food-delivery-microservices/internal/services/catalogreadservice

# orderservice/go.mod
module github.com/mehdihadeli/go-food-delivery-microservices/internal/services/orderservice
```

Each service has its own `Dockerfile` for independent container build and deployment.

**2. Database-per-Service Pattern — Polyglot Persistence**

Each service owns an isolated database schema using different storage engines:

| Service | Databases | Config key |
|---|---|---|
| `catalogwriteservice` | PostgreSQL (`catalogs_write_service`) | `gormOptions` |
| `catalogreadservice` | MongoDB (`catalogs_read_service`) + Redis | `mongoDbOptions`, `redisOptions` |
| `orderservice` | EventStoreDB + MongoDB (`orders_service`) | `eventStoreDbOptions`, `mongoDbOptions` |

From `catalogwriteservice/config/config.development.json`:
```json
"gormOptions": {
  "host": "localhost",
  "port": 5432,
  "dbName": "catalogs_write_service"
}
```

From `catalogreadservice/config/config.development.json`:
```json
"mongoDbOptions": { "database": "catalogs_read_service" },
"redisOptions": { "host": "localhost", "port": 6379 }
```

From `orderservice/config/config.development.json`:
```json
"mongoDbOptions": { "database": "orders_service" },
"eventStoreDbOptions": { "host": "localhost", "httpPort": 2113 }
```

**3. Separate Port Allocations per Service**

- `catalogwriteservice`: HTTP `:7000`, gRPC `:6003`
- `catalogreadservice`: HTTP `:7001`, gRPC `:6004`
- `orderservice`: HTTP `:8000`, gRPC `:6005`

**4. Dual Communication Protocols**

- **Asynchronous**: RabbitMQ integration events for cross-service state propagation (product creation triggers catalog read service update)
- **Synchronous**: gRPC for real-time inter-service calls (protobuf definitions in `api/protobuf/catalogwriteservice/`, `api/protobuf/catalogreadservice/`, `api/protobuf/orderservice/`)

---

### Secondary: Event-Driven

**1. RabbitMQ as Async Integration Fabric**

All three services declare `rabbitmqOptions` in their configurations. The shared `internal/pkg/rabbitmq/` package implements a full consumer/producer lifecycle with retry, backoff, and OpenTelemetry tracing:

```go
// internal/pkg/rabbitmq/consumer/rabbitmq_consumer.go
const (
    retryAttempts = 3
    retryDelay    = 300 * time.Millisecond
)
var retryOptions = []retry.Option{
    retry.Attempts(retryAttempts),
    retry.Delay(retryDelay),
    retry.DelayType(retry.BackOffDelay),
}
```

**2. Integration Events Published at Command Completion**

The `createProductHandler` publishes a `ProductCreatedV1` integration event immediately after persisting to PostgreSQL:

```go
// internal/services/catalogwriteservice/internal/products/features/creatingproduct/v1/create_product_handler.go
productCreated := integrationevents.NewProductCreatedV1(productDto)
err = c.RabbitmqProducer.PublishMessage(ctx, productCreated, nil)
```

**3. Consumer-Side Event Projection**

`catalogreadservice` subscribes to `ProductCreatedV1` via a `productCreatedConsumer`. On receipt, it dispatches a `CreateProduct` command through the local mediator, writing the product to MongoDB and Redis:

```go
// creating_product/v1/events/integrationevents/externalevents/product_created_consumer.go
func (c *productCreatedConsumer) Handle(ctx context.Context, consumeContext types.MessageConsumeContext) error {
    product, ok := consumeContext.Message().(*ProductCreatedV1)
    // ... dispatch CreateProduct command to local handler
}
```

**4. Typed Event Bus Interface**

```go
// internal/pkg/core/messaging/bus/bus.go
type Bus interface {
    producer.Producer
    consumer2.BusControl
    consumer2.ConsumerConnector
}
```

---

### Secondary: CQRS

**1. Physical Separation of Read and Write Services**

The Catalog domain is split across two entirely separate services: `catalogwriteservice` (writes to PostgreSQL) and `catalogreadservice` (reads from MongoDB + Redis). This is CQRS at the service boundary level, not just within a single process.

**2. Command and Query Type System**

```go
// internal/pkg/core/cqrs/command.go
type Command interface {
    isCommand()
    Request
    TypeInfo
}

// internal/pkg/core/cqrs/query.go
type Query interface {
    isQuery()
    Request
    TypeInfo
}
```

**3. Mediator Dispatch via go-mediatr**

All commands and queries are dispatched through `go-mediatr` registered handlers. Each feature folder registers its handler at startup:

```go
// createProductHandler.RegisterHandler()
return mediatr.RegisterRequestHandler[*CreateProduct, *dtos.CreateProductResponseDto](c)
```

**4. Event Sourcing as Write Model in Order Service**

The Order service uses EventStoreDB as its write store and projects to MongoDB and Elasticsearch as read models. `mongoOrderProjection` and `elasticOrderProjection` both implement `projection.IProjection` and are driven by domain event streams:

```go
// projections/mongo_order_projection.go
func (m mongoOrderProjection) ProcessEvent(ctx context.Context, streamEvent *models.StreamEvent) error {
    switch evt := streamEvent.Event.(type) {
    case *createOrderDomainEventsV1.OrderCreatedV1:
        return m.onOrderCreated(ctx, evt)
    }
    return nil
}
```

---

### Secondary: Domain-Driven Design

**1. Event-Sourced Aggregate Root**

The `Order` aggregate extends `models.EventSourcedAggregateRoot`, providing full event-sourcing lifecycle (append, fold, uncommitted events, optimistic concurrency via version):

```go
// internal/services/orderservice/internal/orders/models/orders/aggregate/order.go
type Order struct {
    *models.EventSourcedAggregateRoot
    shopItems       []*value_objects.ShopItem
    accountEmail    string
    deliveryAddress string
    cancelReason    string
    totalPrice      float64
    deliveredTime   time.Time
    paid            bool
    submitted       bool
    completed       bool
    canceled        bool
    paymentId       uuid.UUID
}
```

`NewEmptyAggregate()` wires the `When` function dispatcher, and every state transition raises a domain event applied via `When()`.

**2. Value Objects with Encapsulated State**

`ShopItem` is a proper value object — all fields are unexported, accessed only through methods, with no setters:

```go
// value_objects/shop_item.go
type ShopItem struct {
    title       string
    description string
    quantity    uint64
    price       float64
}
func (s *ShopItem) Title() string       { return s.title }
func (s *ShopItem) Quantity() uint64    { return s.quantity }
```

**3. Domain Events with Business Invariant Validation**

`OrderCreatedV1` enforces business rules in its factory function:

```go
// features/creating_order/v1/events/domain_events/order_created.go
func NewOrderCreatedEventV1(...) (*OrderCreatedV1, error) {
    if shopItems == nil || len(shopItems) == 0 {
        return nil, domainExceptions.NewOrderShopItemsRequiredError("shopItems is required")
    }
    if deliveryAddress == "" {
        return nil, domainExceptions.NewInvalidDeliveryAddressError("deliveryAddress is invalid")
    }
    // ...
}
```

**4. Bounded Context Isolation**

Each service owns entirely separate domain models. The Order service has no dependency on catalog domain types — it receives product information only via integration event DTOs. The `internal/pkg` layer provides infrastructure abstractions, not shared domain logic.

**5. Domain Exceptions as First-Class Types**

`domainExceptions` package under the Order service contains typed errors (`OrderShopItemsRequiredError`, `InvalidDeliveryAddressError`, `OrderNotFoundError`) rather than generic error strings.

---

### Notable: Vertical Slice Architecture within Services

Each microservice organizes its internals by feature slice rather than technical layer. Every feature folder contains all the code it needs end-to-end:

```
catalogwriteservice/internal/products/features/creatingproduct/v1/
├── create_product.go           # Command type
├── create_product_endpoint.go  # HTTP handler (Echo)
├── create_product_handler.go   # Command handler (mediator)
├── dtos/                       # Request/response DTOs
└── events/integrationevents/   # Integration event type
```

This is a consistent convention across all three services. Vertical Slice Architecture is the intra-service organizing principle; Microservices is the inter-service organizing principle.

---

### Notable: OpenTelemetry Observability Stack

Full distributed tracing and metrics are wired throughout:

- **Distributed tracing**: OpenTelemetry with Jaeger and Grafana Tempo exporters configured in all three services
- **Metrics**: Prometheus + Grafana stack in `deployments/docker-compose/docker-compose.infrastructure.yaml`
- **Structured logging**: Uber Zap across all services
- **Swagger UI**: `swaggo/swag` annotations on all REST endpoints

---

## Ruled Out

- **Modular Monolith**: Services are separately compiled modules with independent `Dockerfile`s and database schemas. They are not modules within a single deployment unit.
- **Layered (N-Tier)**: No horizontal technical layers. Within each service, code is organized vertically by feature slice, not by presentation/business/data layers.
- **Hexagonal / Ports-and-Adapters**: Repository and gRPC interfaces serve as adapters, but the primary organizing principle is bounded context decomposition and vertical feature slices, not port-centric design.
- **Service-Based Architecture**: Three fine-grained services with strict database-per-service isolation and event-driven integration goes well beyond the coarse-grained, shared-database pattern of service-based architecture.
- **Serverless**: All services are containerized long-running processes. No function-as-a-service deployment present.
- **Space-Based / Pipeline / Microkernel**: No evidence of any of these patterns as a primary organizing structure.

---

## Quality Attributes with Justification

| Attribute | Justification |
|---|---|
| **Scalability** | Each service is independently containerized and can be scaled horizontally without affecting siblings. Kubernetes manifests in `deployments/kubernetes/` are in progress to support replica-based scaling per service. Services expose separate ports and have no shared state in application memory. |
| **Deployability** | Three independent `Dockerfile`s, three independent `go.mod` files, and per-service `Makefile`/`taskfile.yml` enable fully independent build and deploy pipelines. Changes to the Order service do not require redeploying catalog services. |
| **Data Isolation** | Strict database-per-service: PostgreSQL for catalog writes, MongoDB + Redis for catalog reads, EventStoreDB + MongoDB for orders. No cross-service direct database access is possible by architecture. |
| **Fault Tolerance** | RabbitMQ consumer includes exponential backoff retry (3 attempts, 300ms initial delay, backoff type). EventStoreDB subscription for order events has a named `subscriptionId` supporting durable at-least-once delivery. Each service fails independently. |
| **Consistency (Eventual)** | Cross-service state is propagated asynchronously via RabbitMQ integration events. The catalog read model is eventually consistent with the write model. The order read model (MongoDB projection) is eventually consistent with the EventStoreDB event stream. |
| **Testability** | Each service uses `testcontainers-go` for integration tests with real infrastructure (Docker containers spun up per test). Mockery-generated mocks (`mocks/` directories) for all interface boundaries. `config.test.json` provides isolated test configurations. |
| **Observability** | OpenTelemetry distributed tracing with Jaeger and Tempo exporters; Prometheus metrics with Grafana dashboards; Uber Zap structured logging; Swagger UI on all REST endpoints. All wired per-service, not globally. |
| **Evolvability** | Bounded context isolation means each service's domain model evolves independently. Integration events use versioned type names (`ProductCreatedV1`, `OrderCreatedV1`) allowing backward-compatible evolution. The `internal/pkg` shared infrastructure is a local module replacement, not a published dependency. |

---

## Classification Reasoning

The go-food-delivery-microservices project is a deliberately constructed reference implementation of a Go microservices system. The README explicitly states the design intent and lists all architectural styles applied. Every structural and behavioral signal confirms this:

1. **Three independently deployable services** — separate `go.mod`, separate `Dockerfile`, separate port allocations, each buildable in isolation.

2. **Database-per-service enforced at the configuration level** — PostgreSQL for writes, MongoDB + Redis for reads, EventStoreDB + MongoDB for event-sourced orders. No shared database access across service boundaries.

3. **RabbitMQ as the async integration fabric** — `ProductCreatedV1` flows from catalogwriteservice to catalogreadservice, keeping the read projection synchronized. The Bus interface (Producer + BusControl + ConsumerConnector) is the canonical inter-service integration mechanism.

4. **CQRS at the service boundary** — catalogwriteservice and catalogreadservice are physically separate services, not just separate classes. The Order service additionally applies CQRS internally via EventStoreDB (write) and MongoDB/Elasticsearch projections (read).

5. **Full DDD tactical pattern application** — `Order` is a proper event-sourced aggregate with `EventSourcedAggregateRoot`, domain events carrying business invariants, value objects with encapsulated state, and typed domain exceptions.

6. **Vertical Slice Architecture within services** — all code for a feature (endpoint, command, handler, DTOs, events) lives together in a feature folder. This is the intra-service organizing principle.

7. **OpenTelemetry observability stack** — distributed tracing, metrics, and structured logging wired throughout, reflecting production-readiness intent.

The Microservices primary classification is unambiguous. The Event-Driven, CQRS, and DDD secondary classifications are all load-bearing: Event-Driven because RabbitMQ integration events are the only mechanism for cross-service state propagation; CQRS because read and write models are physically separated services with different storage engines; DDD because the Order aggregate, value objects, domain events, and bounded context isolation are first-class design elements rather than incidental organization.

Confidence is **0.95**. The design intent is explicitly documented, confirmed by code structure, and implemented consistently across all three services.
