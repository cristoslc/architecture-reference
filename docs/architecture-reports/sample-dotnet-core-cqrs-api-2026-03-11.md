# Architecture Report: sample-dotnet-core-cqrs-api

**Repository:** https://github.com/kgrzybek/sample-dotnet-core-cqrs-api
**Classification date:** 2026-03-11
**Model:** claude-sonnet-4-6
**Confidence:** 0.97

---

## Summary

Primary styles: **CQRS** + **Domain-Driven Design**
Secondary styles: **Hexagonal Architecture** (Ports and Adapters), **Layered**

This is a focused teaching repository demonstrating CQRS with segregated read/write models backed by a rich DDD domain layer, all organized around clean/hexagonal architectural boundaries. It is a single-process .NET Core monolith with no service boundaries, distributed messaging infrastructure, or plugin system.

---

## Project structure

```
src/
  SampleProject.API/           — HTTP adapters (controllers, middleware)
  SampleProject.Application/  — Use cases: commands, queries, domain event handlers
  SampleProject.Domain/       — Aggregates, entities, value objects, domain events
  SampleProject.Infrastructure/ — EF Core, Dapper, Outbox, Quartz, Autofac modules
  Tests/
    SampleProject.UnitTests/
    SampleProject.IntegrationTests/
```

Four projects with a strict unidirectional dependency graph:
`API → Application ← Domain ← Infrastructure`
(Infrastructure implements interfaces defined in Domain and Application.)

---

## Evidence by classification

### CQRS (primary, 0.97)

The write side and read side are entirely separate code paths with different persistence strategies:

- **Write model:** `ICommand<TResult>` / `ICommandHandler<T>` types routed through MediatR. Command handlers load aggregates via EF Core repositories, mutate domain state, and call `IUnitOfWork.CommitAsync()`. Example: `PlaceCustomerOrderCommandHandler` retrieves a `Customer` aggregate, invokes `customer.PlaceOrder(...)`, and persists via EF Core change tracking.
- **Read model:** `IQuery<TResult>` / `IQueryHandler<T>` types also routed through MediatR, but handlers use raw SQL via Dapper against database views (`orders.v_Orders`, `orders.v_OrderProducts`). No domain objects are instantiated on the read path. Example: `GetCustomerOrderDetailsQueryHandler` issues two Dapper queries and returns a plain DTO.
- The segregation is enforced by distinct interface hierarchies rather than separate databases, making this the "simple CQRS" variant (one database, two models).
- `CommandsScheduler` and `ProcessInternalCommandsCommandHandler` implement a durable internal command queue persisted to `app.InternalCommands`, enabling reliable async command re-execution without a message broker.

### Domain-Driven Design (primary, 0.96)

The domain layer is a fully realized DDD implementation:

- **Aggregates:** `Customer` is the aggregate root (`IAggregateRoot`), with `Order` as a nested entity accessible only through `Customer`. `Payment` is a separate aggregate.
- **Entities and value objects:** `Entity` base class carries a `List<IDomainEvent>` and exposes `AddDomainEvent()`/`ClearDomainEvents()`. Value objects such as `MoneyValue`, `CustomerId`, `OrderId`, `ProductId` encapsulate identity and equality.
- **Domain events:** `OrderPlacedEvent`, `OrderChangedEvent`, `OrderRemovedEvent`, `CustomerRegisteredEvent` are raised inside aggregate methods. `IDomainEvent` extends MediatR's `INotification` so events dispatch in-process via `DomainEventsDispatcher`.
- **Business rules:** The `IBusinessRule` / `CheckRule(IBusinessRule)` pattern is used throughout — e.g., `CustomerEmailMustBeUniqueRule`, `CustomerCannotOrderMoreThan2OrdersOnTheSameDayRule`, `OrderMustHaveAtLeastOneProductRule`.
- **Repository pattern:** `ICustomerRepository`, `IProductRepository`, `IPaymentRepository` are domain interfaces; implementations live in Infrastructure.
- **Domain services:** `ICustomerUniquenessChecker` is a domain service interface injected into the factory method `Customer.CreateRegistered(...)`.
- **Shared kernel:** `SharedKernel/MoneyValue.cs` with associated validation rules.
- **Ubiquitous language:** Folder names and type names (`PlaceCustomerOrder`, `MarkCustomerAsWelcomed`, `OrderPlacedEvent`) directly reflect domain language.

### Hexagonal Architecture / Ports and Adapters (secondary, 0.91)

The four-project structure maps precisely onto hexagonal zones:

- **Domain (core):** Pure business logic with no framework dependencies.
- **Application (use-case ring):** Defines port interfaces (`ISqlConnectionFactory`, `IEmailSender`, `ICommandsScheduler`). All application dependencies on infrastructure are expressed as interfaces.
- **Infrastructure (adapters):** Autofac modules (`DataAccessModule`, `MediatorModule`, `ProcessingModule`, `EmailModule`, `DomainModule`) wire concrete implementations to the port interfaces. The entire composition occurs in `ApplicationStartup.Initialize(...)` via Autofac.
- **API (driving adapter):** Controllers receive MediatR and dispatch Commands/Queries — they have no direct knowledge of domain or persistence.
- The project reference graph enforces the inward dependency rule: Domain has no references to Application or Infrastructure.

### Layered (secondary, 0.85)

The four-project stack also exhibits a conventional horizontal layering:

- Presentation (API) → Application → Domain → Infrastructure (data/external services)

The primary difference from pure layered architecture is that the dependency inversion principle is strictly applied — Infrastructure depends on Application and Domain abstractions, not the other way around.

---

## Notable infrastructure patterns

**Outbox Pattern:** `DomainEventsDispatcher` serializes domain event notifications as `OutboxMessage` rows in `app.OutboxMessages`. A Quartz.NET job (`ProcessOutboxJob`) polls every 15 seconds and re-publishes unprocessed messages via MediatR. This provides at-least-once delivery for integration events without an external broker.

**Internal Command Queue:** `CommandsScheduler.EnqueueAsync()` persists `InternalCommand` rows to `app.InternalCommands`. A second Quartz.NET job (`ProcessInternalCommandsJob`) processes them. Used in the `CustomerRegisteredNotificationHandler` to durably schedule `MarkCustomerAsWelcomedCommand`.

**Decorator pipeline:** `UnitOfWorkCommandHandlerDecorator`, `LoggingCommandHandlerDecorator`, and `DomainEventsDispatcherNotificationHandlerDecorator` are registered via Autofac to wrap every command handler, providing cross-cutting concerns without modifying handlers.

**Cache-Aside:** `ConversionRatesCache` wraps `IForeignExchange` with a memory cache using a typed cache key. The `ICacheStore` interface is injected, keeping the domain service independent of caching infrastructure.

---

## What was considered and rejected

**Microservices / Service-Based:** There is exactly one deployable unit. No HTTP-to-HTTP service calls, no service registry, no message broker.

**Event-Driven (primary):** Domain events are dispatched synchronously within the same process. The Outbox Pattern adds durable async delivery but only for integration notifications within the same application — not to external consumers.

**Modular Monolith:** The codebase is not organized into self-contained vertical modules each with their own data access and domain. Instead, the domain is a single coherent model. The layering is horizontal, not vertical.

**Pipeline:** No data-pipeline or ETL-style filter/pipe structure is present. The Quartz job scheduling is operational plumbing, not a pipeline architecture.

**Microkernel:** No plugin system or hot-swappable extension points beyond standard DI registration.

---

## Quality attributes

| Attribute | Evidence |
|---|---|
| Maintainability | Strict layer separation, decorator pattern for cross-cutting concerns, business rules encapsulated in domain objects |
| Testability | Integration tests bootstrap the full Autofac container; unit tests exercise aggregates and domain rules in isolation without any infrastructure |
| Correctness | Business rule enforcement is centralized in aggregates via `CheckRule()`, preventing invalid state transitions |
| Reliability | Outbox pattern guarantees at-least-once delivery for domain event notifications; internal command queue survives process restarts |
| Evolvability | Port interfaces allow infrastructure swaps (e.g., email sender, cache store) without touching domain or application logic |
| Observability | Serilog structured logging with correlation middleware; decorator-based command logging captures command identity and timing |
