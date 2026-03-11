# eventuous — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/eventuous/eventuous
**Classification:** Microkernel + Event-Driven
**Confidence:** 0.93
**Model:** claude-sonnet-4-6
**Method:** deep-analysis

## Summary

Eventuous is an opinionated Event Sourcing framework for .NET built around two reinforcing architecture styles. The primary style is **Microkernel (Plugin)**: a minimal, dependency-free core (`Eventuous.Domain`, `Eventuous.Persistence`, `Eventuous.Subscriptions`, `Eventuous.Producers`) defines all abstract contracts (`IEventStore`, `IEventReader`, `IEventWriter`, `ICheckpointStore`, `IEventHandler`, `IProducer<T>`), and a rich ecosystem of pluggable adapters (KurrentDB, Kafka, RabbitMQ, PostgreSQL, MongoDB, Redis, SQLite, SQL Server, Azure Service Bus, Elasticsearch, Google PubSub) provide the concrete implementations registered via .NET DI. The secondary style is **Event-Driven**: the entire runtime model is choreographed by domain events — aggregates emit events that are persisted as the source of truth, subscriptions react to those events through a composable `ConsumePipe` filter chain, and projectors maintain read-side views asynchronously.

## Evidence

### Directory Structure

```
src/
  Core/src/
    Eventuous.Domain/          # Aggregate<T>, State<T>, Id — pure domain model
    Eventuous.Application/     # CommandService<TAggregate,TState,TId>, CommandService<TState>
    Eventuous.Persistence/     # IEventStore, IEventReader, IEventWriter, ICheckpointStore (abstractions)
    Eventuous.Subscriptions/   # EventSubscription<T>, ConsumePipe, IConsumeFilter, IEventHandler
    Eventuous.Producers/       # IProducer<T>, BaseProducer, ProduceRequest
    Eventuous.Serialization/   # IEventSerializer — JSON/binary pluggable
    Eventuous.Diagnostics/     # ActivitySource, Meter — OpenTelemetry instrumentation
  KurrentDB/                   # Adapter: IEventStore, subscriptions, producers for EventStoreDB/KurrentDB
  Kafka/                       # Adapter: IProducer<T>, IMessageSubscription for Apache Kafka
  RabbitMq/                    # Adapter: IProducer<T>, IMessageSubscription for RabbitMQ
  Postgres/                    # Adapter: IEventStore, PostgresProjector, checkpoint store
  Mongo/                       # Adapter: MongoProjector (read-side projection engine)
  Redis/                       # Adapter: IEventStore, checkpoint store backed by Redis
  Sqlite/                      # Adapter: IEventStore, SqliteProjector
  SqlServer/                   # Adapter: IEventStore, SqlServerProjector
  Relational/                  # Shared SQL base for relational adapters, UniversalProducer
  Azure/                       # Adapter: Azure Service Bus IProducer
  GooglePubSub/                # Adapter: Google Pub/Sub subscriptions and producers
  Experimental/                # Elasticsearch projector, Spyglass source-code-generation tool
  Diagnostics/                 # OpenTelemetry tracer/meter extension packages
  Gateway/                     # Subscription-to-producer bridge (shovel/fanout pattern)
  Extensions/                  # ASP.NET Core HTTP endpoints, DI registration helpers
  Testing/                     # InMemoryEventStore, domain-test harness
samples/
  kurrentdb/                   # Booking domain sample (KurrentDB + MongoDB projections)
  postgres/                    # Booking domain sample (PostgreSQL event store + MongoDB projections)
```

### Key Architectural Files

**Core Abstractions (Microkernel Core):**

- `src/Core/src/Eventuous.Persistence/EventStore/IEventStore.cs`: Root persistence contract extending `IEventReader` and `IEventWriter`. Defines `StreamExists`, `TruncateStream`, `DeleteStream`. All concrete stores implement this one interface.
- `src/Core/src/Eventuous.Persistence/EventStore/IEventWriter.cs`: `AppendEvents(stream, expectedVersion, events, cancellationToken)` — single-stream append with optimistic concurrency via `ExpectedStreamVersion`. Also provides a default multi-stream sequential append.
- `src/Core/src/Eventuous.Persistence/StateStore/IStateStore.cs`: Alternative read interface for functional-style command services that operate on folded state rather than aggregates.
- `src/Core/src/Eventuous.Subscriptions/Checkpoints/ICheckpointStore.cs`: `GetLastCheckpoint` / `StoreCheckpoint` — the contract allowing subscriptions to survive restarts across any backing store.
- `src/Core/src/Eventuous.Producers/IProducer.cs`: `Produce(stream, messages, options, cancellationToken)` — the contract satisfied by all event broker adapters.
- `src/Core/src/Eventuous.Subscriptions/Handlers/IEventHandler.cs`: `HandleEvent(IMessageConsumeContext)` — the contract for all subscription consumers (projectors, saga handlers, gateway handlers).

**Domain Model (Event Sourcing Aggregate Pattern):**

- `src/Core/src/Eventuous.Domain/Aggregate.cs`: `Aggregate<T>` base class tracking `Original` (persisted events), `Changes` (pending events), and `OriginalVersion` for optimistic concurrency. The `Apply<TEvent>()` method calls `AddChange()` + `State.When(evt)`. The `Load()` method folds historical events via `state.Aggregate(State, Fold)`.
- `src/Core/src/Eventuous.Domain/State.cs`: `State<T>` is an immutable record with a `When(object event)` dispatch table built by calling `On<TEvent>(Func<T, TEvent, T>)` in the constructor. Pure functional fold — no side effects.
- `src/Core/src/Eventuous.Domain/Id.cs`: Strongly-typed aggregate identity.

**Application Layer (Command Services):**

- `src/Core/src/Eventuous.Application/AggregateService/CommandService.cs`: Object-oriented command service for aggregate-style modeling. `On<TCommand>().InState(ExpectedState.New/Existing/Any).GetId(...).ActAsync(...)` builder registers handlers. `Handle<TCommand>()` orchestrates: load aggregate → execute handler → append events → return `Result<TState>`.
- `src/Core/src/Eventuous.Application/FunctionalService/CommandService.cs`: Functional command service operating on `State<T>` + event arrays rather than aggregate objects. Both styles accept the same `IEventReader`/`IEventWriter` abstractions.

**Subscription Infrastructure (Event-Driven Runtime):**

- `src/Core/src/Eventuous.Subscriptions/EventSubscription.cs`: Abstract `EventSubscription<T>` provides the base loop — deserializes events from the source, pushes `IMessageConsumeContext` through the `ConsumePipe`, handles drop/resubscribe logic with exponential backoff, integrates `ActivitySource` tracing per message.
- `src/Core/src/Eventuous.Subscriptions/Filters/ConsumePipe.cs`: Doubly-linked `LinkedList<IConsumeFilter>` implementing the pipeline pattern. `AddFilterFirst` / `AddFilterLast` compose filters with type-safe context flow. `Send()` traverses nodes; each filter calls `Move(node.Next, context)` to continue the chain.
- `src/Core/src/Eventuous.Subscriptions/Filters/`: Reusable filters — `MessageFilter` (type routing), `PartitioningFilter` (MurmurHash3 key-based parallel lanes), `AsyncHandlingFilter` (non-blocking ack), `TracingFilter` (OTEL spans).

**Plug-in Adapters:**

- `src/KurrentDB/src/Eventuous.KurrentDB/KurrentDBEventStore.cs`: `IEventStore` implementation for KurrentDB (EventStoreDB). Supports `AllStreamSubscription`, `StreamSubscription`, and persistent subscriptions. Primary production target.
- `src/Kafka/src/Eventuous.Kafka/Producers/KafkaBasicProducer.cs`: `IProducer<KafkaProduceOptions>` wrapping `Confluent.Kafka`. Paired with `KafkaBasicSubscription`.
- `src/RabbitMq/src/Eventuous.RabbitMq/Producers/RabbitMqProducer.cs`: `IProducer<RabbitMqProduceOptions>` wrapping `RabbitMQ.Client`.
- `src/Postgres/src/Eventuous.Postgresql/PostgresStore.cs`: `IEventStore` using Npgsql. Includes `PostgresProjector` and Postgres-backed `ICheckpointStore`.
- `src/Mongo/src/Eventuous.Projections.MongoDB/MongoProjector.cs`: `IEventHandler` implementation providing a typed builder API for MongoDB upsert/update/insert/delete operations against a read model collection.

**Cross-Cutting Infrastructure:**

- `src/Core/src/Eventuous.Persistence/EventStore/TieredEventStore.cs`: Hot + archive store composition — writes to hot store, reads from both. Demonstrates composability of the `IEventStore` abstraction.
- `src/Gateway/src/Eventuous.Gateway/GatewayHandler.cs`: `RouteAndTransform` delegate bridges a subscription to a producer — events from any source can be re-published to any broker adapter. Enables event-driven service-to-service integration without code coupling.
- `src/Diagnostics/src/Eventuous.Diagnostics.OpenTelemetry/`: `AddEventuousTracing()` and `AddEventuousMetrics()` extension methods hook into .NET `ActivitySource` / `Meter` instrumentation natively into OpenTelemetry pipelines.

**Sample Applications (Architecture Demonstration):**

- `samples/postgres/Bookings/Application/BookingsCommandService.cs`: `CommandService<Booking, BookingState, BookingId>` with two command handlers wired via the fluent builder.
- `samples/postgres/Bookings/Application/Queries/BookingStateProjection.cs`: `MongoProjector<BookingDocument>` subscribing to three domain events and maintaining a MongoDB read model — the CQRS read side.

### Patterns Found

**Microkernel (Primary Style):**

The core `src/Core/` packages are explicitly free of infrastructure dependencies — only `Microsoft.Extensions.*` abstractions for DI and logging. All runtime behavior is injected through the plug-in interfaces. The framework provides:

- **Core system**: `Eventuous.Domain`, `Eventuous.Application`, `Eventuous.Persistence`, `Eventuous.Subscriptions`, `Eventuous.Producers` — collectively ~180 source files with zero external I/O.
- **Plug-in registry**: .NET Dependency Injection container acts as the plug-in registry. `AddKurrentDB()`, `AddKafka()`, `AddRabbitMq()`, `AddPostgresStore()`, etc., are the plug-in registration entry points.
- **Plug-in contracts**: `IEventStore`, `IEventReader`, `IEventWriter`, `ICheckpointStore`, `IProducer<T>`, `IEventHandler`, `IEventSerializer` define the extension points.
- **8+ production plug-ins**: KurrentDB, Kafka, RabbitMQ, PostgreSQL, MongoDB, Redis, SQLite, SQL Server, Azure Service Bus, Google Pub/Sub, Elasticsearch.

The `TieredEventStore` (composing two `IEventStore` instances) and the `Gateway` (composing any `IMessageSubscription` + `IProducer<T>`) further demonstrate open composition against the plug-in interfaces.

**Event-Driven (Primary Co-Style):**

The runtime computation model is fundamentally event-driven:

1. Commands arrive at `CommandService`, which loads aggregate state by replaying events from `IEventStore`.
2. The aggregate's `Apply()` records new domain events as `Changes`.
3. `CommandService` appends those events back to the store via `IEventWriter.AppendEvents()` with `ExpectedStreamVersion` for optimistic concurrency.
4. `EventSubscription` implementations subscribe to the event stream (all-stream or filtered), pushing each event through the `ConsumePipe` for async reactive processing.
5. `IEventHandler` implementations (projectors, saga handlers, gateway handlers) react to events to update read models or produce downstream events.

The `ConsumePipe` filter chain itself is a structural Pipeline within the Event-Driven style: `TracingFilter → MessageFilter → PartitioningFilter → AsyncHandlingFilter → ConsumerFilter → [user handlers]`.

**Domain-Driven Design (Qualifier):**

The aggregate model (`Aggregate<T>`, `State<T>`, `Id`) directly implements DDD tactical patterns. `Aggregate<T>` enforces business invariants, manages the event log, and exposes domain events as the sole state-change mechanism. `State<T>` is a pure immutable record projecting events through a typed dispatch table. Strongly-typed identities (`Id`) prevent primitive obsession. Two command service styles (OO aggregate-based and functional state-based) accommodate different DDD modeling preferences.

**CQRS (Qualifier):**

The write side (`CommandService` → `IEventWriter`) is fully separated from the read side (`Projector → IEventHandler → read model`). The samples demonstrate explicit separation: `BookingsCommandService` handles writes via `Booking` aggregate; `BookingStateProjection` maintains a denormalized MongoDB document for reads. `IStateStore` provides an alternative read path folding events directly without a projector.

### Rejected Styles

- **Layered:** No horizontal layer enforcement at the framework level. The core → adapter relationship is vertical plug-in decomposition, not layered with upward-call restrictions.
- **Modular Monolith:** This is a library/framework, not a deployed application. When used, it enables any topology the user chooses.
- **Microservices:** Eventuous is a framework enabling services, not itself a system of independently deployed services.
- **Pipeline:** The `ConsumePipe` is a local intra-process pipeline pattern embedded within the subscription processing path, not the primary organizing topology.
- **Service-Based:** No shared database topology. Each plug-in adapter is independently chosen.
- **Space-Based:** No in-memory data grid or tuple-space runtime.
- **Serverless:** Long-running subscriptions via hosted services, not FaaS.
- **Multi-Agent:** No agent orchestration model.

## Quality Attributes

| Attribute | Evidence |
|---|---|
| Extensibility | 10+ plug-in adapters; all extension points are interfaces; DI-registered |
| Testability | `Eventuous.Testing` provides `InMemoryEventStore` and domain test harness |
| Observability | Native OpenTelemetry tracing + metrics via `ActivitySource` and `Meter` |
| Consistency | Optimistic concurrency via `ExpectedStreamVersion` on all writes |
| Resilience | Auto-resubscribe with exponential backoff on subscription drops |
| Performance | `ConsumePipe` uses `LinkedList` + `ValueTask`; `PartitioningFilter` parallelizes via MurmurHash3 |
| Maintainability | Immutable `State<T>` records, strongly-typed identities, explicit event versioning |

## Key Technologies

- .NET 8+ (C#)
- KurrentDB / EventStoreDB (primary event store target)
- Apache Kafka, RabbitMQ, Azure Service Bus, Google Pub/Sub (broker adapters)
- PostgreSQL (Npgsql), MongoDB, Redis, SQLite, SQL Server (persistence adapters)
- OpenTelemetry (.NET `System.Diagnostics.DiagnosticSource` + `Meter`)
- Microsoft.Extensions.DependencyInjection, Hosting, Logging (DI/hosting integration)
- Polly (resilience in relational adapters)
