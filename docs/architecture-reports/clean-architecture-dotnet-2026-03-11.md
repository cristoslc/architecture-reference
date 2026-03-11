# Architecture Report: clean-architecture-dotnet

**Date:** 2026-03-11
**Repo URL:** https://github.com/thangchung/clean-architecture-dotnet
**Classification:** Microservices, Hexagonal Architecture, Domain-Driven Design, CQRS
**Confidence:** 0.95

---

## Summary

clean-architecture-dotnet is a .NET 6 reference implementation demonstrating "Minimal Clean Architecture, Domain-driven Design Lite, CQRS Lite, and just enough Cloud-native patterns." The project is organized as a monorepo containing multiple independently deployable microservices (Product, Customer, Setting), a shared infrastructure library, an API gateway, an Identity Server, and a Blazor frontend. Services communicate through Dapr's pub/sub and service invocation abstractions. Within each service, the architecture follows Hexagonal (Ports and Adapters) principles with clear domain core isolation, CQRS command/query segregation via MediatR, and DDD aggregate roots with domain events.

---

## Evidence from Code Exploration

### Repository Structure
- `src/` — Shared infrastructure building blocks: `N8T.Core`, `N8T.Infrastructure`, `N8T.Infrastructure.EfCore`, `N8T.Infrastructure.OTel`
- `samples/` — Concrete microservices and support infrastructure:
  - `Product/` (ProductService.Api, ProductService.AppCore, ProductService.Infrastructure)
  - `Customer/` (CustomerService.Api, CustomerService.AppCore, CustomerService.Infrastructure)
  - `Setting/` (SettingService.Api, SettingService.AppCore, SettingService.Infrastructure)
  - `AppGateway/` — YARP reverse proxy gateway
  - `IdentityServer/` — Duende IdentityServer for OAuth2/OIDC
  - `WebBlazor/` — Blazor WASM client with BFF pattern
  - `DataContracts/` — Shared DTOs and integration event contracts

### Deployment Configuration
- `docker-compose.yml`: Each service gets its own container plus a co-located Dapr sidecar (`productapp-dapr`, `customerapp-dapr`, `settingapp-dapr`). Shared infrastructure: PostgreSQL, Redis (pub/sub state store), Dapr placement service.
- `samples/tye.yaml`: Microsoft Tye orchestration registering 7 distinct services (postgres, productapp, customerapp, settingapp, identityserver, webblazor, gatewayapp).
- `samples/components/pubsub.yaml`: `pubsub.redis` Dapr component for async messaging.

### Per-Service Hexagonal Structure
Every domain service follows an identical tripartite layering:
1. `*.Api` — HTTP controllers (primary adapters), Dapr subscription handlers (`IntegrationEventHandler.cs`), transactional outbox processors
2. `*.AppCore` — Domain core: entities, value objects, specifications, use case handlers (Commands/Queries); no infrastructure dependencies
3. `*.Infrastructure` — Secondary adapters: EF Core DbContext, repository implementations, database migrations

### CQRS Pattern
`N8T.Core/Domain/Cqrs.cs` defines framework interfaces: `ICommand<T>`, `IQuery<T>`, `ICreateCommand`, `IUpdateCommand`, `IDeleteCommand`, `IListQuery`, `IItemQuery`. Each AppCore project's `UseCases/Commands/` and `UseCases/Queries/` folders implement these. MediatR dispatches all handlers via a pipeline with `RequestValidationBehavior`, `LoggingBehavior`, and `TxBehavior` (transactional wrapping for commands).

### DDD Aggregate Roots with Domain Events
Entities extend `EntityRootBase` (which implements `IAggregateRoot`). Domain events are raised inline during factory methods:
```csharp
product.AddDomainEvent(new ProductCreatedIntegrationEvent { ... });
```
`TxBehavior.cs` publishes collected domain events after transaction commit via `_mediator.Publish(new EventWrapper(@event))`. Bounded contexts (Product, Customer, Setting) each own their database schema.

### Event-Driven Integration Events
- `CoolStore.IntegrationEvents` package defines cross-service integration events: `CustomerCreatedIntegrationEvent`, `ProductCreatedIntegrationEvent`, `ProductCodeCreatedIntegrationEvent`.
- `DaprEventBus` publishes events to Dapr pub/sub topics by event type name.
- `ProductService.Api/V1/IntegrationEventHandler.cs` subscribes to `CustomerCreatedIntegrationEvent` via `[Topic("pubsub", "CustomerCreatedIntegrationEvent")]` attribute.
- Transactional Outbox pattern implemented to guarantee at-least-once delivery from DB transaction to message broker.

### Ports and Adapters (Hexagonal)
- Port: `IRepository<TEntity>`, `IGridRepository<TEntity>` in `N8T.Core`
- Adapter: `Repository<TDbContext, TEntity>` in `N8T.Infrastructure.EfCore`
- Port: `IEventBus` in `N8T.Infrastructure/Bus`
- Adapter: `DaprEventBus` in `N8T.Infrastructure/Bus/Dapr`
- Port: `ICountryApi` (RestEase typed client) in `CoolStore.AppContracts`
- Adapter: Dapr service invocation via `AddDaprInvocationHandler()`

---

## Architecture Styles Identified

### Primary: Microservices
Three independently deployable services (Product, Customer, Setting), each with its own database context, Dockerfile, and Dapr sidecar. An API gateway (YARP) routes external traffic. Services communicate asynchronously via Dapr pub/sub (Redis-backed) and synchronously via Dapr service invocation. Integration events and a shared DataContracts library provide the inter-service contract layer.

### Primary: Hexagonal Architecture (Ports and Adapters)
Every service enforces strict dependency direction: Api → AppCore ← Infrastructure. Domain core defines interfaces (ports); infrastructure provides implementations (adapters). Application core has zero infrastructure package references.

### Secondary: Domain-Driven Design
Aggregate roots with factory methods and domain events, bounded contexts per service, Specification pattern for queries, rich domain behavior encapsulated in entities rather than anemic models.

### Secondary: CQRS
Explicit command/query separation at the interface and handler level. Commands carry transactional semantics (`ITxRequest`); queries are read-only. Pipeline behaviors for cross-cutting concerns (validation, logging, transactions, OpenTelemetry tracing).

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| Maintainability | Clear tripartite structure per service; shared infrastructure building blocks reduce boilerplate |
| Testability | Domain core has no infrastructure dependencies, enabling pure unit tests of business logic |
| Scalability | Independent microservices deployable and scalable per service; Dapr abstracts state and messaging |
| Observability | OpenTelemetry integration (`N8T.Infrastructure.OTel`), Serilog structured logging, trace ID propagation via `TraceIdEnricher` |
| Resilience | Transactional Outbox pattern for reliable event delivery; Polly for retry/circuit-breaker policies |
| Modularity | Monorepo with explicit bounded context boundaries and no direct cross-service code coupling |

---

## Classification Reasoning

The codebase is unambiguously a Microservices reference implementation: multiple separately deployable services, database-per-service, API gateway, Dapr sidecar per service, integration event contracts, and container orchestration via both Tye and Docker Compose.

Within each service, Hexagonal Architecture is the structural pattern: the tripartite `.Api`/`.AppCore`/`.Infrastructure` split implements ports-and-adapters with strict inward dependency flow. This is not coincidental — the README explicitly credits domain-driven-hexagon and ardalis/CleanArchitecture.

DDD is applied at the tactical level: aggregate roots, domain events, specifications, bounded contexts with separate databases, and integration events for cross-context communication.

CQRS is applied at the use-case level as "CQRS Lite": command/query interface segregation via MediatR without event sourcing. Commands go through a transactional pipeline; queries go through validation and logging pipelines.

The combination is intentional and explicitly documented: the project's README states it implements "Minimal DDD, CQRS, and Clean Architecture" for the microservice approach. The four styles are co-primary and mutually reinforcing rather than competing.
