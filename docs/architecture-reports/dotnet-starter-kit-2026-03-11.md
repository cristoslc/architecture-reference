# Architecture Report: dotnet-starter-kit

**Date:** 2026-03-11
**Source URL:** https://github.com/fullstackhero/dotnet-starter-kit
**Classification:** Modular Monolith, Domain-Driven Design
**Confidence:** 0.95
**Method:** deep-analysis

---

## Executive Summary

The **dotnet-starter-kit** (FullStackHero .NET 10 Starter Kit) is a production-oriented application scaffold built on .NET 10 for multi-tenant SaaS and enterprise APIs. Its primary architecture is a **Modular Monolith** with comprehensive **Domain-Driven Design (DDD)** foundations. All modules deploy as a single process; bounded contexts (Identity, Multitenancy, Auditing) are physically separated into independent projects with strictly enforced dependency rules, but they are loaded and wired at runtime by a central host process via a reflection-based module loader. The DDD influence is deep and structural: aggregate roots, domain events, bounded contexts, vertical slice features, and domain-layer purity tests are all first-class citizens of the codebase.

---

## Repository Structure

```
src/
  BuildingBlocks/         # Cross-cutting primitives
    Core/                 # DDD base types (AggregateRoot, BaseEntity, IDomainEvent)
    Persistence/          # EF Core base context, specifications, domain event interceptor
    Eventing/             # Integration event bus (InMemory + RabbitMQ), outbox/inbox
    Eventing.Abstractions/# IIntegrationEvent, IEventBus interfaces
    Web/                  # Minimal API host wiring, ModuleLoader, Mediator behaviors
    Caching/              # Redis-backed distributed cache
    Jobs/                 # Hangfire background jobs
    Mailing/              # Mail service abstraction
    Storage/              # Local + S3 storage abstractions
    Shared/               # Cross-cutting DTOs for Identity, Multitenancy, Auditing
    Blazor.UI/            # Shared Blazor component library
  Modules/
    Identity/
      Modules.Identity.Contracts/   # DTOs, commands/queries, integration event contracts
      Modules.Identity/             # Features (vertical slices), domain, EF data, authorization
    Multitenancy/
      Modules.Multitenancy.Contracts/
      Modules.Multitenancy/
    Auditing/
      Modules.Auditing.Contracts/
      Modules.Auditing/
  Playground/
    Playground.Api/           # Reference host (single deployable unit)
    FSH.Playground.AppHost/   # .NET Aspire orchestration (Postgres + Redis + API + Blazor)
    Playground.Blazor/        # Blazor Server front end
    Migrations.PostgreSQL/    # EF Core migrations per module DbContext
  Tests/
    Architecture.Tests/       # NetArchTest suite enforcing all structural rules
    Identity.Tests/
    Multitenancy.Tests/
    Auditing.Tests/
    Generic.Tests/
  Tools/
    CLI/                      # FSH CLI scaffolding tool
```

---

## Architecture Style Analysis

### Primary: Modular Monolith

**Evidence:**

1. **Single deployable unit.** `Playground.Api/Program.cs` contains one `WebApplication.CreateBuilder` call that loads all module assemblies and maps all endpoints from a single host process. There is no inter-service network communication, no separate deployment artifact per module, and no container-per-module in the Aspire orchestration.

2. **Reflection-based module loader.** `src/BuildingBlocks/Web/Modules/ModuleLoader.cs` discovers modules via `[assembly: FshModule(typeof(IdentityModule), 100)]` assembly attributes, instantiates them via `Activator.CreateInstance`, calls `module.ConfigureServices(builder)` and `module.MapEndpoints(endpoints)` for each. This is the canonical Modular Monolith plugin-host pattern.

3. **Module isolation enforced by tests.** `src/Tests/Architecture.Tests/ModuleArchitectureTests.cs` scans `.csproj` files at test time and asserts that no module runtime project holds a `ProjectReference` to another module runtime project — only to that module's own contracts or BuildingBlocks projects.

4. **Contracts/implementation split.** Each module is split into two projects: a `*.Contracts` project (pure DTOs, command/query records, integration event interfaces) and a `*.Implementation` project (features, persistence, services). `ContractsPurityTests.cs` uses NetArchTest to assert contracts assemblies have zero dependency on EF Core, FluentValidation, Hangfire, or any module's implementation namespaces.

5. **Layer dependency tests.** `LayerDependencyTests.cs` enforces:
   - `BuildingBlocks.Core` has no dependency on EF Core or ASP.NET Core.
   - Domain types inside modules have no dependency on persistence, EF Core, or infrastructure.
   - Feature handlers (non-endpoint) have no direct dependency on `HttpContext` or `Microsoft.AspNetCore.Mvc`.

6. **Shared in-process IPC.** Cross-module communication uses the in-process `IEventBus` (default: `InMemoryEventBus`) with the Outbox/Inbox pattern backed by EF Core. RabbitMQ is a pluggable alternative for the same contract but is not required or the default. Modules communicate only through each other's published `IIntegrationEvent` contracts, never through direct project references.

### Secondary: Domain-Driven Design

**Evidence:**

1. **DDD primitives in `BuildingBlocks/Core/Domain/`.** `AggregateRoot<TId>`, `BaseEntity<TId>` with `IHasDomainEvents`, `IDomainEvent`, `DomainEvent` base record. `BaseEntity<TId>` maintains an internal `_domainEvents` list dispatched via `DomainEventsInterceptor` on EF Core `SaveChangesAsync`.

2. **Bounded contexts as modules.** Identity, Multitenancy, and Auditing map cleanly to distinct bounded contexts. Each has its own `DbContext` (`IdentityDbContext`, `TenantDbContext`, `AuditDbContext`), domain model, feature slices, and event definitions.

3. **Domain events.** Identity domain raises `UserRegisteredEvent`, `PasswordChangedEvent`, `SessionRevokedEvent`, `UserActivatedEvent`, `UserDeactivatedEvent`, `UserRoleAssignedEvent` — all extending `DomainEvent`. `DomainEventsInterceptor` (EF Core `SaveChangesInterceptor`) publishes these via Mediator post-save.

4. **Integration events from domain events.** The module translates internal domain events into integration events (`UserRegisteredIntegrationEvent`, `TokenGeneratedIntegrationEvent`) published via `IEventBus` so cross-module consumers (e.g., `UserRegisteredEmailHandler`) can react without direct coupling to the source module's domain.

5. **Vertical slice feature organization.** Each use case lives in its own folder: `Features/v1/Users/RegisterUser/` contains `RegisterUserEndpoint.cs`, `RegisterUserCommandHandler.cs`, and `RegisterUserCommandValidator.cs` — the complete slice in one place.

6. **Specification pattern.** `BuildingBlocks/Persistence/Specifications/` provides `Specification<T>` and `SpecificationEvaluator` — a classic DDD persistence query pattern for encapsulating query logic.

7. **Mediator pipeline.** Commands and queries are routed through `Mediator` (Mediator library for .NET). A `ValidationBehavior<TMessage, TResponse>` pipeline behavior applies FluentValidation before handlers execute — the application layer cross-cutting concern idiom from DDD.

---

## What This Architecture Is Not

- **Not Microservices.** There is one deployable API process. Modules are in-process, share a host, and rely on in-memory event dispatch by default. No inter-service HTTP or gRPC calls between modules.
- **Not Hexagonal Architecture (primary).** The codebase is organized around bounded contexts/modules, not ports and adapters. There are no explicit "port" interfaces per module boundary isolating the application from infrastructure; the organizational unit is the module slice, not the hexagonal ring.
- **Not Event-Driven (primary).** Eventing infrastructure (`IEventBus`, Outbox, RabbitMQ adapter) exists as a supporting mechanism for cross-module integration after state changes. It is not the primary architectural driver — the command/query dispatch model (Mediator) is the primary processing path.
- **Not CQRS (separate read/write models).** While Mediator separates commands from queries at the handler level, there is no segregated read model or separate read store. Queries use the same EF Core `DbContext` as commands.
- **Not Microkernel.** Modules are not independently deployed plugins to a kernel runtime; they are compiled into the host and loaded at startup.

---

## Quality Attributes

| Attribute | Assessment |
|---|---|
| Maintainability | High — vertical slices, architecture tests, contracts/implementation split prevent regression |
| Modularity | High — independent bounded context projects, enforced isolation via NetArchTest |
| Testability | High — domain layer independent of EF/ASP.NET, handler isolation, extensive test suites |
| Scalability | Moderate — single process; scales vertically or via load balancing; RabbitMQ option for distributed eventing |
| Observability | High — OpenTelemetry traces/metrics/logs baked in, Serilog structured logging, Aspire OTLP export |
| Multi-tenancy | High — Finbuckle-powered tenancy across all module DbContexts from day one |
| Developer Experience | High — CLI scaffolding, Aspire local dev environment, comprehensive README and docs |
| Extensibility | High — module loader pattern allows drop-in of new bounded contexts without modifying existing modules |

---

## Key Files

| File | Significance |
|---|---|
| `src/Playground/Playground.Api/Program.cs` | Single host entry point; demonstrates module loading |
| `src/BuildingBlocks/Web/Modules/ModuleLoader.cs` | Core modular monolith plugin infrastructure |
| `src/BuildingBlocks/Web/Modules/IModule.cs` | Module contract (`ConfigureServices` + `MapEndpoints`) |
| `src/BuildingBlocks/Web/Modules/FshModuleAttribute.cs` | Assembly-level module registration attribute |
| `src/BuildingBlocks/Core/Domain/BaseEntity.cs` | DDD base entity with domain event collection |
| `src/BuildingBlocks/Core/Domain/AggregateRoot.cs` | DDD aggregate root marker |
| `src/BuildingBlocks/Persistence/Inteceptors/DomainEventsInterceptor.cs` | EF Core post-save domain event dispatch |
| `src/BuildingBlocks/Eventing/ServiceCollectionExtensions.cs` | InMemory/RabbitMQ event bus wiring |
| `src/Tests/Architecture.Tests/ModuleArchitectureTests.cs` | Enforces no cross-module runtime dependencies |
| `src/Tests/Architecture.Tests/ContractsPurityTests.cs` | Enforces clean contracts (no EF/Hangfire/implementation) |
| `src/Tests/Architecture.Tests/LayerDependencyTests.cs` | Enforces Domain → Application → Infrastructure flow |
| `src/Modules/Identity/Modules.Identity/Features/v1/Users/RegisterUser/` | Representative vertical slice (command/validator/endpoint) |

---

## Classification Confidence Rationale

Confidence is **0.95**. The Modular Monolith classification is unambiguous: single deployable artifact, reflection-based module loader, enforced isolation between modules, no inter-process communication. The DDD classification is equally strong: aggregate roots, domain events, bounded contexts with per-context `DbContext`, vertical slice feature organization, specification pattern, and domain purity tests. The 0.05 margin reflects that eventing infrastructure (Outbox/RabbitMQ) could theoretically support a future microservices decomposition, but in its current form the system is firmly a single-process monolith.
