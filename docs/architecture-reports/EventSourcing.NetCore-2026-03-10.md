---
project: EventSourcing.NetCore
date: 2026-03-10
scope: framework-and-samples
use-type: reference-and-learning
primary-language: C#
confidence: 0.95
styles:
  - Event-Driven
  - CQRS
  - Domain-Driven Design
---

## EventSourcing.NetCore Architecture Report

| Field | Value |
|---|---|
| Repository | https://github.com/oskardudycz/EventSourcing.NetCore |
| Classified | 2026-03-10 |
| Primary Language | C# (.NET 9) |
| Domain | Event Sourcing / CQRS Reference Implementation |
| Scope | Framework and Samples |
| Use-Type | Reference / Learning |
| Confidence | 0.95 |

---

## Architecture Styles

### Primary: Event-Driven

Every state change in the system is encoded as an immutable domain event — `ShoppingCartOpened`, `ProductAdded`, `IncidentLogged`, etc. — persisted to an append-only event store (EventStoreDB or Marten/PostgreSQL). Aggregates in `Core/Aggregates/Aggregate.cs` expose an `Enqueue(event)` method that queues domain events; the `MartenRepository` and `EventStoreDBRepository` flush these to the event stream on save, and `EventStoreDBSubscriptionToAll` and Marten's async daemon consume the stream to drive projections, sagas, and Kafka producers. The entire system is built around events as the source of truth rather than mutable state.

### Secondary: CQRS

Commands and queries are formally separated throughout the codebase. `Core/Commands/` defines `ICommandBus`, `ICommandHandler<TCommand>`, and an `InMemoryCommandBus`; `Core/Queries/` defines `IQueryBus` and `IQueryHandler<TQuery, TResponse>`. The ECommerce sample's `ShoppingCartsController` routes writes exclusively through `commandBus.Send()` and reads exclusively through `queryBus.Query()`. Read models (`ShoppingCartDetails`, `IncidentDetails`, `CustomerIncidentsSummary`) are maintained as separate projections (`SingleStreamProjection`, `MultiStreamProjection`) updated by the event stream, enabling independently-optimized read and write paths.

### Tertiary: Domain-Driven Design

The design centres on DDD building blocks: Aggregates (`Aggregate<TEvent, TId>`) with version-checked persistence, Domain Events as named past-tense facts, Commands as intent-bearing value records, Process Managers / Sagas (`OrderSaga` reacting to cross-aggregate events to drive a distributed order lifecycle), the Decider pattern (`Core/Decider/Decider.cs` — a pure `Decide(command, state) → events[]` function), and strong ubiquitous language in event names and bounded context modules (Carts, Orders, Payments, Shipments). The Helpdesk sample applies the functional approach (immutable `record Incident` rebuilt from events without an OO aggregate base class).

---

## Evidence Table

| Evidence | Location | Supports |
|---|---|---|
| `Aggregate<TEvent>` enqueues events; repository appends to event stream | `Core/Aggregates/Aggregate.cs`, `Core.Marten/Repository/MartenRepository.cs` | Event-Driven |
| `EventStoreDBSubscriptionToAll` subscribes to all events for downstream handlers | `Core.EventStoreDB/Subscriptions/EventStoreDBSubscriptionToAll.cs` | Event-Driven |
| `EventBus` dispatches to `IEventHandler<TEvent>` per event type | `Core/Events/EventBus.cs` | Event-Driven |
| Kafka topics `Carts`, `Orders`, `Payments`, `Shipments` created in docker-compose | `docker-compose.yml` init-kafka | Event-Driven |
| `KafkaProducer` registered as Marten subscription | `Sample/Helpdesk/Helpdesk.Api/Program.cs` | Event-Driven |
| Formal `ICommandBus` / `ICommandHandler<T>` interfaces | `Core/Commands/ICommandHandler.cs`, `Core/Commands/ICommandBus.cs` | CQRS |
| Formal `IQueryBus` / `IQueryHandler<TQuery, TResponse>` interfaces | `Core/Queries/IQueryHandler.cs`, `Core/Queries/QueryBus.cs` | CQRS |
| `ShoppingCartsController` routes writes to `commandBus`, reads to `queryBus` | `Sample/ECommerce/Carts/Carts.Api/Controllers/ShoppingCartsController.cs` | CQRS |
| `HandleGetCartById` reads from `IQuerySession` (Marten read-model) | `Carts/ShoppingCarts/GettingCartById/GetCartById.cs` | CQRS |
| `IncidentDetailsProjection : SingleStreamProjection<IncidentDetails>` | `Helpdesk.Api/Incidents/GetIncidentDetails/IncidentDetails.cs` | CQRS |
| `Aggregate<TEvent, TId>` base class with `Version`, `Apply()`, `DequeueUncommittedEvents()` | `Core/Aggregates/Aggregate.cs` | DDD |
| `OrderSaga` reacts to `CartFinalized` → `InitializeOrder` → `RequestPayment` → ... | `Sample/ECommerce/Orders/Orders/Orders/OrderSaga.cs` | DDD / Event-Driven |
| `ProcessManager` base in `Core/ProcessManagers/ProcessManager.cs` | `Core/ProcessManagers/ProcessManager.cs` | DDD |
| `Decider<TState, TCommand, TEvent>` pure function record | `Core/Decider/Decider.cs` | DDD |
| Bounded contexts: Carts, Orders, Payments, Shipments, ECommerce.AppHost (Aspire) | `Sample/ECommerce/` subdirectories | DDD |
| OpenTelemetry activity tracing on command handling, event handling, messaging | `Core/OpenTelemetry/TelemetryTags.cs`, `Core/Commands/CommandHandlerActivity.cs` | Observability |
| Polly retry policies wrapping event handler invocations | `Core/Events/EventBus.cs` | Fault Tolerance |
| ETag-based optimistic concurrency on aggregates | `Core.Marten/Repository/MartenRepositoryWithETagDecorator.cs` | Evolvability |

---

## Quality Attributes

| Attribute | Evidence |
|---|---|
| **Evolvability** | `Core.EventStoreDB/Subscriptions/EventStoreDBSubscriptionToAll.cs` tracks checkpoint positions, enabling replay. `Sample/EventsVersioning/` provides nine concrete versioning strategies (upcasting, new schema, weak schema, event transformations). ETag-based optimistic concurrency decorators allow safe concurrent updates. |
| **Modularity** | Core library factored into pluggable adapters: `Core.EventStoreDB`, `Core.Marten`, `Core.Kafka`, `Core.ElasticSearch`, `Core.EntityFramework`. Samples pick and compose adapters independently. Each bounded context is a self-contained C# project with no cross-context dependencies. |
| **Observability** | `Core/OpenTelemetry/` wires distributed tracing (ActivityScope, ActivitySource) and custom telemetry tags for commands, queries, events, and Kafka messaging. `Core/Commands/CommandHandlerMetrics.cs` tracks active command count, total commands, and handling duration. Jaeger exporter is configured in docker-compose. |
| **Fault Tolerance** | `EventBus` accepts a configurable Polly `AsyncPolicy` (default no-op, overridable per service). `EventStoreDBSubscriptionToAll` has `ProcessingStatus` tracking and checkpoint persistence to survive restarts. `GetCartById` query handler applies a Polly retry for read-after-write consistency. |
| **Correctness** | Optimistic concurrency is enforced by expected-version checks in `MartenRepository.Update()` and `EventStoreDBRepository`. `IFMatchHeader` (ETag) is propagated from HTTP headers to repository version checks, preventing lost-update conflicts. |
| **Testability** | `Core.Testing` module provides test harnesses. All samples include companion `.Tests` projects using `Testcontainers.PostgreSql`, `Alba`, and `Ogooreck` for BDD-style scenario testing against live event stores. |

---

## Domain

Event Sourcing reference implementation and learning resource — demonstrates foundational and advanced patterns (Event Sourcing, CQRS, DDD Aggregates, Process Managers, Decider pattern, projections, event versioning) across multiple realistic sample applications (e-commerce, helpdesk, hotel management, warehouse), backed by pluggable event stores (EventStoreDB, Marten/PostgreSQL) and optional Kafka integration.

---

## Production Context

- This is a reference and tutorial repository, not a production application. It is maintained by the author of the *Architecture Weekly* newsletter and actively used for conference talks and workshops.
- The infrastructure manifests (docker-compose, Aspire AppHost) and testing setup (`Testcontainers`) suggest the patterns are production-validated even if the repo itself is educational.
- `Sample/ECommerce/ECommerce.AppHost` uses .NET Aspire orchestration, indicating the target deployment model for the e-commerce sample is cloud-native with Aspire service discovery.
- `Sample/ECommerce.Equinox` provides an F# variant using the Equinox library with CosmosStore, DynamoStore, and SqlStreamStore, demonstrating cross-language applicability of the patterns.
