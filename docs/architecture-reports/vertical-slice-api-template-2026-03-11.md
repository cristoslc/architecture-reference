# Architecture Report: vertical-slice-api-template

**Date:** 2026-03-11
**Repo URL:** https://github.com/mehdihadeli/vertical-slice-api-template
**Classification:** Modular Monolith
**Confidence:** 0.92

---

## Summary

`vertical-slice-api-template` is an ASP.NET Core 9 dotnet project template that demonstrates Vertical Slice Architecture applied to a single-deployable, single-process application. The codebase organises all business logic around use-case slices (CreateProduct, GetProductById, GetProductsByPage) rather than horizontal technical layers. Each slice is a self-contained unit of code containing its Minimal API endpoint, command or query record, handler, validator, DTOs, and database executors. A shared infrastructure library (`src/Shared/`) provides cross-cutting capabilities — caching, EF Core persistence, messaging via MassTransit/RabbitMQ, observability via OpenTelemetry — without imposing traditional layer boundaries on the slices themselves. The single deployable unit and single `CatalogsDbContext` confirm the Modular Monolith classification; Vertical Slice Architecture is the design approach structuring the internals of that monolith. CQRS via the source-generated Mediator library and an outbound integration event bus via MassTransit are supporting design patterns, not distinct architectural styles.

---

## Evidence from Code Exploration

### Deployment Topology

`deployments/docker-compose/docker-compose.services.yaml` defines a single service container (`vertical-slice-template`) that runs the one API project. There are no multiple independently deployable components. Infrastructure dependencies (PostgreSQL, RabbitMQ, Redis, OpenTelemetry Collector, Jaeger, Grafana, Loki, Prometheus, Elasticsearch, Kibana) are declared in a separate `docker-compose.infrastructure.yaml` but are observability/storage backends, not application services.

`src/App/Vertical.Slice.Template.Api/Program.cs` wires a single `WebApplication` with a single composition root. There is one solution file (`Vertical.Slice.Template.sln`) targeting the single `CatalogsDbContext`.

### Source Structure — Vertical Slice Organisation

```
src/App/Vertical.Slice.Template/
  Products/
    Features/
      CreatingProduct/v1/     — CreateProduct.cs, CreateProductEndpoint.cs, ProductCreated*.cs
      GettingProductById/v1/  — GetProductById.cs, GetProductByIdEndpoint.cs
      GettingProductsByPage/v1/ — GetProductsByPage.cs, GetProductsByPageEndpoint.cs
    Models/Product.cs
    Dtos/v1/ProductDto.cs
    ReadModel/ProductReadModel.cs
    Data/ (EF type configurations)
    ProductConfigurations.cs  — module boundary registration
```

Each feature folder contains the complete vertical unit:
- **Endpoint**: Minimal API route handler using `IMediator.Send()` / typed results
- **Command/Query record**: implements `ICommand<TResult>` or `CacheQuery<TRequest, TResult>`
- **Handler** (`ICommandHandler` / `IQueryHandler`): contains all business logic and data access
- **Validator**: inline `AbstractValidator<T>` using FluentValidation
- **DTOs**: request and response records scoped to the slice
- **DbExecutors**: delegate-typed database accessors registered as transient dependencies, keeping EF Core out of the handler constructor directly

This structure ensures that adding a new feature never touches existing feature code — only new files are added.

### Module Boundary Pattern

`ProductConfigurations.cs` acts as the module registration contract:
- `AddProductsModuleServices()` — registers module-level DI services
- `UseProductsModule()` — configures module middleware
- `MapProductsModuleEndpoints()` — wires Minimal API endpoints with API versioning

`CatalogsConfigurations.cs` composes the Catalogs domain by calling each module's three registration methods. `Program.cs` calls only the Catalogs-level extension methods, maintaining a clean composition hierarchy.

### CQRS Implementation

`src/Shared/Abstractions/Core/CQRS/` defines:
- `ICommand<TResponse>` / `ICommandHandler<TCommand, TResponse>`
- `IQuery<TResponse>` / `IQueryHandler<TQuery, TResponse>`
- `IPageQuery<TResponse>`

`src/Shared/Cache/CacheQuery.cs` provides a base record for cache-aware queries (used by `GetProductById`).

Dispatching is performed by the source-generated `Mediator` library (not MediatR), with a pipeline of registered `IPipelineBehavior<,>` implementations: `RequestValidationBehavior`, `EfTxBehavior`, `ObservabilityPipelineBehavior`, `CachingBehavior`, `InvalidateCachingBehavior`, `StreamCachingBehavior`, `StreamLoggingBehavior`.

### Integration Events (Outbound Messaging)

`CreateProductHandler` publishes both:
1. An in-process domain event (`ProductCreatedDomainEvent`) via `mediator.Publish()`
2. An outbound integration event (`ProductCreatedIntegrationEventV1`) via `IExternalEventBus`

`IExternalEventBus` is implemented by `MasstransitExternalBus` which publishes to RabbitMQ exchanges via MassTransit. This is an outbound notification channel only — there are no consumers defined in the template's application code, making this an outbound integration pattern rather than a full Event-Driven Architecture. RabbitMQ is declared as an infrastructure dependency but event-driven communication is not the primary or symmetric mode of operation.

### Shared Infrastructure Library

`src/Shared/` contains reusable infrastructure that all slices depend on:
- `Shared.csproj`: EF Core, MassTransit, Mediator abstractions, FluentValidation, Serilog, OpenTelemetry, Redis (HybridCache), Polly, Scrutor, API versioning, Dapper, SqlKata
- `Shared/Cache/`: Redis-backed hybrid caching with MediatR pipeline behaviors
- `Shared/EF/`: `EfDbContextBase`, `EfTxBehavior`, `GenericRepository<T>`, migration and seeding infrastructure
- `Shared/Observability/`: OpenTelemetry trace/metric/log pipeline behaviors
- `Shared/Messaging.MassTransit/`: `MasstransitExternalBus` adapter to RabbitMQ
- `Shared/Web/`: Problem Details, CORS, versioning, Minimal API extensions
- `Shared/Validation/`: FluentValidation pipeline behavior

This shared layer provides horizontal capabilities but does not enforce horizontal layering within the application — slices reach through it directly.

### Domain Model Assessment

`Products/Models/Product.cs` is an anemic POCO (`record`-like class with `init` setters, no methods or invariants). DDD abstractions (`IAggregate`, `IEntity`, `IBusinessRule`) exist in `Shared/Abstractions/Core/Domain/` but are not used by the Product model. The template scaffolds DDD-compatible infrastructure without applying rich domain modelling.

### Test Coverage

Five distinct test projects: UnitTests, IntegrationTests, ContractTests (Kiota + ConnectedService clients), ClientsTests (REST, Kiota, NSwag), EndToEndTests, DependencyTests. The breadth of test types is a notable quality attribute of the template.

---

## Architecture Styles (canonical)

| Style | Confidence | Role |
|---|---|---|
| Modular Monolith | Primary | Single deployable, single DbContext, module registration boundary via `IModuleConfiguration` convention |

---

## Architecture Qualifiers (design approaches, not styles)

| Type | Value | Notes |
|---|---|---|
| design-approach | vertical-slice | Primary internal organisation: each use case is a self-contained feature folder across all technical concerns |
| data-pattern | cqrs | Explicit command/query interface segregation dispatched through source-generated Mediator pipeline |
| integration-pattern | integration-events | Outbound MassTransit/RabbitMQ integration events published per command handler; no inbound consumers in template |
| structural-support | domain-events | In-process domain event dispatch via mediator within handlers |

---

## Quality Attributes

| Attribute | Assessment |
|---|---|
| Maintainability | High — new features are new files only; existing slices are not touched; feature folders are self-documenting |
| Testability | High — comprehensive test pyramid (unit, integration, contract, E2E, dependency); handlers are thin and injectable |
| Scalability | Moderate — single-process deployment; vertical slice isolation allows internal concurrency scaling but not independent service scaling |
| Observability | High — OpenTelemetry traces/metrics/logs with OTLP export; Jaeger, Grafana Tempo, Loki, Prometheus, Elasticsearch stacks supported; per-request pipeline telemetry behavior |
| Deployability | Simple — single Docker image, single service container; PM2 and Tye orchestration for local dev |
| Cohesion | High — slice-internal cohesion is maximised; cross-slice coupling is minimised by design |
| Caching | Built-in — Redis HybridCache with declarative per-query cache key derivation via `CacheQuery<T>` base class |
| Resilience | Moderate — Polly via `Microsoft.Extensions.Http.Resilience` for HTTP clients; no circuit breakers on internal paths |

---

## Technology Stack

- Language: C# / .NET 9
- Framework: ASP.NET Core Minimal APIs
- ORM: Entity Framework Core (Npgsql / PostgreSQL) + Dapper / SqlKata for read-side projections
- Mediator: `Mediator` (source-generated, high-performance, not MediatR)
- Messaging: MassTransit + RabbitMQ (outbound integration events only in template)
- Caching: Redis via `Microsoft.Extensions.Caching.Hybrid` + `StackExchange.Redis`
- Mapping: Mapperly (source-generated, no runtime reflection)
- Validation: FluentValidation with pipeline behavior
- Observability: OpenTelemetry (traces, metrics, logs) → OTLP Collector → Jaeger / Tempo / Loki / Prometheus
- Auth: JWT Bearer (configured but not exercised by template endpoints)
- Testing: xUnit, NSubstitute, contract tests (Kiota + NSwag clients), E2E tests
- API Versioning: Asp.Versioning.Http
- Deployment: Docker / Docker Compose, PM2, Microsoft Tye

---

## Classification Reasoning

The dominant architectural style is **Modular Monolith**: one deployable unit, one database context, one process, with a structured module registration boundary. The "modular" claim is modest — the template has a single `Products` module as its domain scope, making the module boundary more of a scaffold convention than a multi-module enforced partition. Nevertheless, the `IModuleConfiguration` convention (`AddProductsModuleServices`, `UseProductsModule`, `MapProductsModuleEndpoints`) is a first-class pattern in the template, and the intent is explicitly for consumers to add additional modules following the same convention.

**Vertical Slice Architecture** is the defining *design approach* structuring the interior of the monolith. It is explicitly named in the README, in code comments, and in the NuGet template description. It is the reason all feature code lives under `Products/Features/CreatingProduct/v1/` rather than in separate controllers, service, or repository layers. This is correctly classified as a design approach (architecture qualifier) rather than a canonical architecture style per ADR-006.

**CQRS** is a supporting data pattern implemented via the source-generated Mediator library. Command and query interfaces are explicitly segregated. The pipeline behaviors exploit the CQRS separation (e.g., `CachingBehavior` applies only to `ICacheQuery`; `EfTxBehavior` applies only to commands). There is no event-sourced read model — reads go through the same EF Core context as writes, projecting to read models at query time.

**Event-Driven Architecture** is rejected as a style classification. The template publishes integration events outbound to RabbitMQ, but there are no event consumers in the application code, no choreography topology, and no event-driven inter-component communication pattern. The synchronous request-response via Minimal APIs is the primary interaction model. The messaging infrastructure is present as a scaffolded capability for consumers of the template to extend.

**Microservices** is definitively rejected: one process, one database, one Docker service.

**Layered Architecture** is rejected: there are no horizontal technical layers. The `src/Shared/` library provides infrastructure capabilities but is not a layer that application code must pass through in prescribed sequence. Each slice uses Shared utilities directly and in any combination appropriate to the use case.
