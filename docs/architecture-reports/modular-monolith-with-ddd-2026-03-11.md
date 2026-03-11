# Architecture Report: modular-monolith-with-ddd

**Date:** 2026-03-11
**Source URL:** https://github.com/kgrzybek/modular-monolith-with-ddd
**Classification:** Modular Monolith, Domain-Driven Design, CQRS, Event-Driven
**Confidence:** 0.99

---

## Summary

`modular-monolith-with-ddd` (project name: MyMeetings) is a reference application demonstrating a production-quality .NET Modular Monolith built with DDD tactical patterns. All modules run in a single process/binary behind one REST API host. Modules are isolated by explicit public contracts (Facade interfaces), communicate asynchronously via an in-memory integration event bus, and each owns its own IoC container, database schema, and Outbox/Inbox infrastructure. The write side of every module applies Clean Architecture layering (API / Application / Domain / Infrastructure) and DDD tactical building blocks; the read side uses a flat two-layer CQRS query model.

---

## Evidence

### 1. Deployment topology confirms monolith

`docker-compose.yml` runs a single `backend` container from one Dockerfile targeting `src/`. `Startup.cs` initialises all five module startup classes (`MeetingsStartup`, `AdministrationStartup`, `UserAccessStartup`, `PaymentsStartup`, `RegistrationsStartup`) inside one process. There is no service mesh, sidecar, or inter-service HTTP.

ADR-0002 states explicitly: *"All modules must run in one single process as single application (Monolith)".*

### 2. Module boundaries enforce the Modular Monolith style

`src/Modules/` contains five top-level directories: `Meetings`, `Administration`, `Payments`, `Registrations`, `UserAccess`. Each module exposes only a single Facade interface (e.g., `IMeetingsModule`) with `ExecuteCommandAsync` / `ExecuteQueryAsync` — the sole cross-module entry point. Direct type references across module namespaces are prohibited and enforced by architecture unit tests (`src/Tests/ArchTests/Modules/`). Each module has its own Autofac `IContainer` initialised at startup (ADR-0016).

### 3. CQRS applied within every module

ADR-0007 mandates CQRS. Application layer file layout confirms it: every business capability has a `*Command.cs` + `*CommandHandler.cs` pair for writes, and a `*Query.cs` + `*QueryHandler.cs` pair for reads. The Facade interfaces expose `ExecuteCommandAsync` and `ExecuteQueryAsync` as separate paths. Write-side handlers load/mutate Aggregate Roots through Repositories; read-side handlers issue SQL directly via `ISqlConnectionFactory`.

ADR-0009 documents the read side as a deliberate 2-layer style (no Domain objects involved); ADR-0010 documents the write side as Clean Architecture (4-layer).

### 4. DDD tactical patterns throughout

`src/BuildingBlocks/Domain/` provides the shared kernel: `Entity`, `ValueObject`, `IDomainEvent`, `IAggregateRoot`, `IBusinessRule`, `TypedIdValueBase`. Every business module's `Domain/` folder applies these: Aggregate Roots with strongly-typed IDs, Value Objects, domain events raised inside aggregates, Repository interfaces, and business rule guard methods. ADR-0011 and ADR-0012 formalise this choice.

The Payments module goes further and implements **Event Sourcing** for its aggregates (`SqlStreamAggregateStore` backed by SqlStreamStore), demonstrating an ES-backed Aggregate Store variant of DDD.

### 5. Event-Driven integration between modules

ADR-0014 chooses asynchronous Publish/Subscribe over direct method calls. `InMemoryEventBus` (singleton) dispatches `IntegrationEvent` subclasses between modules. Each module has an `IntegrationEvents/` project exposing its published contract (e.g., `MeetingGroupProposedIntegrationEvent`). The Outbox pattern (`BuildingBlocks/Application/Outbox/`, `BuildingBlocks/Infrastructure/Inbox/`) guarantees at-least-once delivery. Quartz.NET jobs in each module poll the Outbox and Inbox on a configurable interval.

Domain events internal to a module are dispatched synchronously via `DomainEventsDispatcher` and converted to MediatR notifications, keeping intra-module coupling tight while inter-module coupling remains event-based.

### 6. Hexagonal / Clean Architecture ports-and-adapters within modules

Each module's write path uses inward-facing dependency rules: Domain layer has no outward dependencies; Application layer depends only on Domain abstractions; Infrastructure implements those abstractions. The `Application/Contracts/ICommand`, `IQuery`, repository interfaces in Domain, and `ISqlConnectionFactory` in Application are ports. Infrastructure wires the adapters (Entity Framework Core, SqlStreamStore, Quartz, IdentityServer4). This is a clean expression of Hexagonal Architecture at the module level.

### 7. Layered structure is explicit and tested

ADR-0010 describes four layers. Architecture tests in `src/Tests/ArchTests/` and each module's `Tests/ArchTests/` use NetArchTest to enforce that the Domain layer has no reference to Infrastructure or Application layers, and that the Application layer has no reference to Infrastructure.

---

## Architecture Styles (canonical)

| Style | Confidence | Role |
|---|---|---|
| Modular Monolith | Primary | Single deployable, multiple autonomous modules |
| Domain-Driven Design | Primary | Aggregates, Value Objects, Domain Events, Repositories, Bounded Contexts |
| CQRS | Primary | Separate command/query models and handlers within each module |
| Event-Driven | Supporting | Async integration events via in-memory event bus with Outbox/Inbox |
| Hexagonal Architecture | Supporting | Ports-and-adapters layering inside each module's write path |
| Layered | Supporting | Explicit 4-layer enforced by architecture tests |

---

## Quality Attributes

- **Modularity**: Strong — modules are physically separated, independently testable, with enforced boundary rules.
- **Maintainability**: High — Clean Architecture layering, rich domain model, architecture tests prevent erosion.
- **Testability**: High — Domain layer has zero infrastructure dependencies; dedicated unit, integration, and architecture test suites.
- **Eventual Consistency**: Accepted trade-off — Outbox/Inbox with polling provides reliable async delivery between modules.
- **Deployability**: Simple — single process, single database, containerised with one Dockerfile.
- **Observability**: Serilog structured logging with per-module context tags.

---

## Domain

Meeting management platform (Meetup-style): Members, Meeting Groups, Meetings, Payments, Subscriptions, User Registration and Access Control.

---

## Technology Stack

- Language: C# / .NET
- Framework: ASP.NET Core (REST API)
- ORM: Entity Framework Core (most modules); SqlStreamStore (Payments event sourcing)
- IoC: Autofac per module
- Messaging: In-process InMemoryEventBus (Publish/Subscribe)
- Scheduling: Quartz.NET (Outbox/Inbox polling, internal commands)
- Auth: IdentityServer4 / JWT Bearer
- Database: SQL Server (shared server, schema-per-module)
- Testing: xUnit, NSubstitute, NetArchTest, Stryker (mutation testing)
- Build: NUKE Build
