# Architecture Report: practical-dotnet-aspire

**Date:** 2026-03-11
**Source URL:** https://github.com/thangchung/practical-dotnet-aspire
**Classification Method:** deep-analysis
**Model:** claude-sonnet-4-6

---

## Summary

`practical-dotnet-aspire` (also called "CoffeeShop on .NET Aspire") is a reference implementation demonstrating microservices architecture on .NET 9 and .NET Aspire 9. It models a coffee-shop ordering system decomposed into independently deployable services that communicate through a combination of HTTP and asynchronous message passing via RabbitMQ, layered over DDD building blocks and CQRS command/query patterns within each service.

---

## Primary Architecture Styles

| Style | Confidence | Role |
|---|---|---|
| Microservices | Primary | Five distinct services, each with its own process, deployment unit, and independent codebase |
| Event-Driven | Strong secondary | Inter-service communication is predominantly asynchronous via MassTransit on RabbitMQ; publish/subscribe and event-consumer patterns are the backbone of the order workflow |
| CQRS | Strong secondary | Each service separates commands (PlaceOrderCommand, OrderInEndpoint) from queries (OrderFulfillmentQuery, ItemTypesQuery) using MediatR |
| Domain-Driven Design | Supporting | Rich domain model with Aggregate Roots, Entity base classes, Domain Events, Value Objects, bounded-context naming, and explicit domain event propagation |

---

## Project Structure

```
coffeeshop-aspire/
├── app-host/           # .NET Aspire AppHost — orchestration entry point
├── counter-api/        # Order-taking service: commands, domain, integration events
├── barista-api/        # Beverage preparation service: event consumer only
├── kitchen-api/        # Food preparation service: event consumer only
├── product-api/        # Product catalog service: query API + AI/embedding
├── order-summary/      # (commented out) Event-sourced read model via Marten
├── yarp/               # YARP reverse proxy / API gateway
├── shared/             # CoffeeShop.Shared — cross-cutting concerns library
└── service-defaults/   # .NET Aspire ServiceDefaults extension
```

---

## Service Decomposition

### counter-api
The primary write-side service. Accepts an HTTP `POST /orders` command, builds an `Order` aggregate, raises domain events (`BaristaOrderIn`, `KitchenOrderIn`), aggregates them, and publishes integration events to RabbitMQ via MassTransit. Also subscribes to `BaristaOrderUpdated` and `KitchenOrderUpdated` to track order completion. Integrates with `product-api` over HTTP for item pricing.

### barista-api
Pure event consumer. Subscribes to `BaristaOrderPlaced` messages from RabbitMQ, simulates preparation delay per item type, then publishes `BaristaOrderUpdated`. Has no HTTP API surface of its own.

### kitchen-api
Mirrors `barista-api` for food items. Subscribes to a kitchen-dedicated RabbitMQ queue and replies with `KitchenOrderUpdated`.

### product-api
Read-oriented catalog service backed by PostgreSQL (pgvector). Exposes item type queries over versioned HTTP endpoints. Integrates with Ollama (local) or Azure OpenAI for semantic search (vector embeddings) and chat completion for data seeding.

### order-summary (commented out in app-host)
Intended as a Marten-based event-sourced read-model service subscribing to all order events for a full order view.

### yarp
YARP reverse proxy providing a single gateway entry point, routing traffic to `product-api` and `counter-api`.

---

## Communication Patterns

| Pattern | Transport | Services Involved |
|---|---|---|
| Synchronous HTTP | REST | customer → yarp → counter-api, product-api |
| Service-to-service HTTP | HTTP (service discovery) | counter-api → product-api |
| Async publish | RabbitMQ (MassTransit) | counter-api → barista-api, kitchen-api |
| Async publish | RabbitMQ (MassTransit) | barista-api, kitchen-api → counter-api (update events) |
| Async subscribe | RabbitMQ (MassTransit) | order-summary (event-sourced read model, disabled) |

---

## DDD Building Blocks

- **Aggregate Root:** `Order` extends `EntityRootBase`, maintains `HashSet<IDomainEvent>`, calls `DomainEventAggregation()` and `RelayAndPublishEvents()`
- **Domain Events:** `BaristaOrderIn`, `KitchenOrderIn`, `BaristaOrdersPlacedDomainEvent`, `KitchenOrdersPlacedDomainEvent`, `OrderUp`, `OrderUpdate`
- **Value Objects:** `ValueObject` base class with equality components
- **Entities:** `EntityBase`, `ItemLine`
- **Repository interface:** `IOrderRepository` (counter-api infrastructure)
- **Gateway interface:** `IItemGateway` / `ItemHttpGateway` (anti-corruption for product-api calls)

---

## CQRS Pattern

MediatR is used uniformly across all services:
- **Commands:** `PlaceOrderCommand : IRequest<IResult>` handled by `PlaceOrderHandler`
- **Queries:** `OrderFulfillmentQuery : IRequest<IResult>`, `ItemTypesQuery`, `ItemsByIdsQuery`
- **Behaviors (pipeline):** `ValidationBehavior<,>` (FluentValidation) and `HandlerBehavior<,>` (OpenTelemetry metrics) applied to all commands and queries

---

## Infrastructure and Orchestration

- **.NET Aspire AppHost:** Declares all services and infrastructure resources (PostgreSQL with pgvector, Redis, RabbitMQ, Ollama with models) with lifecycle management, health checks, and service references
- **MassTransit 8.3 on RabbitMQ:** Message consumer definitions with retry policies, in-memory outbox, concurrency limits, and OpenTelemetry filters
- **OpenTelemetry:** Shift-left observability; custom instrumentation for MediatR handlers (via `HandlerBehavior`), MassTransit consumers (`OtelSendFilter`, `OtelPublishFilter`, `OTelConsumeFilter`), and enriched .NET global logging
- **YARP 2.2:** Reverse proxy with Aspire service discovery integration
- **EF Core + Npgsql + pgvector:** Used in `product-api` for relational data and vector embeddings
- **Marten:** Referenced in `order-summary` (disabled) for event-sourced document storage

---

## Quality Attributes

| Attribute | Evidence |
|---|---|
| Scalability | Independent services allow per-service horizontal scaling |
| Loose coupling | Async messaging decouples counter from barista/kitchen; gateway interface isolates product-api |
| Observability | Full OpenTelemetry stack with custom MediatR and MassTransit instrumentation |
| Testability | Integration test project (`counter-api-tests`) using Aspire testing + WireMock.NET; code coverage badges |
| Evolvability | API versioning (v1/v2), central package management, shared service defaults |
| Resilience | MassTransit retry policies, in-memory outbox, Aspire health checks, HTTP resilience extensions |
| AI-extensibility | product-api supports pluggable AI backends (Ollama local, Azure OpenAI) via `Microsoft.Extensions.AI` abstractions |

---

## Key Observations

1. The README explicitly states "Microservices architectural style" and references DDD bounded contexts. Service granularity is intentionally fine-grained for demonstration purposes.
2. Event-driven communication is the dominant inter-service integration pattern; synchronous HTTP is used only at the API gateway boundary and for the counter→product read dependency.
3. CQRS is applied intra-service via MediatR, not as a system-level pattern with separate read/write stores (though `order-summary` with Marten was intended for that purpose).
4. DDD building blocks are implemented in the shared library and applied consistently: aggregate roots own domain events, which are relayed through MediatR to MassTransit for external publication.
5. The `.NET Aspire` orchestration layer is a first-class architectural concern, providing unified service discovery, health checking, and observability wiring across all services.
