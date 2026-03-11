# Architecture Report: eShopOnWeb

**Date:** 2026-03-11
**Source:** https://github.com/dotnet-architecture/eShopOnWeb
**Classification:** Layered, Hexagonal Architecture, Domain-Driven Design
**Confidence:** 0.95
**Method:** deep-analysis
**Model:** claude-sonnet-4-6

---

## Summary

eShopOnWeb is a Microsoft reference application explicitly demonstrating a **single-process monolithic architecture** for ASP.NET Core 8. It combines three mutually reinforcing architectural styles: **Layered Architecture** (the primary structural skeleton), **Hexagonal Architecture / Clean Architecture** (the dependency inversion discipline that shapes how layers relate), and **Domain-Driven Design** tactical patterns (the vocabulary used inside the domain core). The combination is intentional and canonical — the project accompanies the official "Architecting Modern Web Applications with ASP.NET Core and Azure" eBook.

---

## Project Structure

```
src/
├── ApplicationCore/          # Domain layer: entities, interfaces, domain services, specifications
│   ├── Entities/
│   │   ├── BasketAggregate/  # Basket (IAggregateRoot), BasketItem
│   │   ├── OrderAggregate/   # Order (IAggregateRoot), OrderItem, Address, CatalogItemOrdered
│   │   └── BuyerAggregate/
│   ├── Interfaces/           # Ports: IRepository<T>, IReadRepository<T>, IBasketService,
│   │                         #        IOrderService, IAppLogger<T>, IEmailSender,
│   │                         #        IBasketQueryService, ITokenClaimsService, IUriComposer
│   ├── Services/             # Domain services: BasketService, OrderService, UriComposer
│   └── Specifications/       # Query specifications (Ardalis.Specification)
├── Infrastructure/           # Adapters: EF Core, Identity, logging, queries
│   ├── Data/
│   │   ├── EfRepository<T>   # Generic repository adapter (IRepository<T>, IReadRepository<T>)
│   │   ├── CatalogContext    # EF DbContext
│   │   └── Queries/          # BasketQueryService (optimized query adapter)
│   ├── Identity/             # ASP.NET Identity adapter
│   ├── Logging/              # LoggerAdapter<T>
│   └── Services/             # EmailSender
├── Web/                      # MVC/Razor Pages presentation layer + Blazor WASM host
│   ├── Controllers/          # MVC controllers (OrderController, ManageController, UserController)
│   ├── Pages/                # Razor Pages (basket, catalog, checkout)
│   ├── Features/             # MediatR request/handler slices (GetMyOrders, GetOrderDetails)
│   └── Services/             # View-layer services
├── PublicApi/                # Minimal API endpoints (Ardalis.ApiEndpoints pattern)
│   └── CatalogItemEndpoints/ # CRUD endpoints for catalog admin (consumed by BlazorAdmin)
├── BlazorAdmin/              # Blazor WebAssembly admin SPA (deployed inside Web host)
└── BlazorShared/             # Shared models/interfaces between BlazorAdmin and Web
```

---

## Dependency Graph

```
BlazorAdmin ──► BlazorShared
ApplicationCore ──► BlazorShared
Infrastructure ──► ApplicationCore
Web ──► ApplicationCore, Infrastructure, BlazorAdmin, BlazorShared
PublicApi ──► ApplicationCore, Infrastructure
```

Key structural invariant: **ApplicationCore has zero upward dependencies** — it does not reference Infrastructure, Web, or PublicApi. All coupling flows inward toward the domain core.

---

## Architecture Style Evidence

### Primary Style: Layered Architecture

The codebase is explicitly a horizontal three-layer application:

1. **Domain Layer (ApplicationCore)** — entities, interfaces, domain services, specifications. No framework dependencies.
2. **Infrastructure Layer** — EF Core repository implementations, ASP.NET Identity, logging adapters, email. Depends only on ApplicationCore.
3. **Presentation Layer (Web + PublicApi)** — ASP.NET Core MVC, Razor Pages, Minimal API, Blazor WebAssembly.

The README states: *"demonstrating a single-process (monolithic) application architecture and deployment model."*

The `.csproj` references confirm strict layering:
- `ApplicationCore.csproj`: no project references (only `BlazorShared` for shared view models)
- `Infrastructure.csproj`: references `ApplicationCore` only
- `Web.csproj`: references `ApplicationCore`, `Infrastructure`, `BlazorAdmin`, `BlazorShared`

### Secondary Style: Hexagonal Architecture (Ports and Adapters)

The dependency inversion is systematic and deliberate:

**Ports** defined in `ApplicationCore/Interfaces/`:
- `IRepository<T>`, `IReadRepository<T>` — persistence ports
- `IBasketService`, `IOrderService` — application service ports
- `IBasketQueryService` — optimized query port (separate from repository)
- `IAppLogger<T>`, `IEmailSender` — infrastructure ports
- `ITokenClaimsService`, `IUriComposer` — utility ports

**Adapters** implemented in `Infrastructure/`:
- `EfRepository<T>` implements `IRepository<T>` and `IReadRepository<T>`
- `BasketQueryService` implements `IBasketQueryService` (raw EF for performance-sensitive count)
- `LoggerAdapter<T>` implements `IAppLogger<T>`
- `IdentityTokenClaimService` implements `ITokenClaimsService`

The domain core is completely isolated — it can be tested against any adapter. This is canonical hexagonal / clean architecture.

### Tertiary Style: Domain-Driven Design (tactical patterns)

DDD tactical patterns are applied inside ApplicationCore:

**Aggregates with IAggregateRoot marker:**
```csharp
public class Basket : BaseEntity, IAggregateRoot { ... }
public class Order : BaseEntity, IAggregateRoot { ... }
```

**Encapsulated collections (aggregate boundary enforcement):**
```csharp
// Order.cs — DDD comment is verbatim in the source
private readonly List<OrderItem> _orderItems = new List<OrderItem>();
public IReadOnlyCollection<OrderItem> OrderItems => _orderItems.AsReadOnly();
```

**Repository-per-aggregate pattern** via `IRepository<T> where T : class, IAggregateRoot`.

**Specifications** for composable query logic (Ardalis.Specification library):
- `BasketWithItemsSpecification`, `CustomerOrdersSpecification`, `CatalogFilterSpecification`, etc.

**Domain Services** for cross-aggregate logic: `BasketService`, `OrderService`.

### MediatR for in-process CQRS-lite (not classified as CQRS)

MediatR is used in the Web layer's `Features/` folder for request dispatch:
- `GetMyOrders` / `GetMyOrdersHandler`
- `GetOrderDetails` / `GetOrderDetailsHandler`

This is a query-dispatch pattern, not full CQRS: there are no separate read/write models, no distinct query stores, and write operations are handled directly through domain services and repositories. MediatR is used for decoupling the controller from the handler, not for command/event segregation.

---

## Deployment Topology

`docker-compose.yml` runs two processes against a shared SQL Server instance:
- `eshopwebmvc` — the Web application (MVC + Razor Pages + Blazor host)
- `eshoppublicapi` — the PublicApi (Minimal API, consumed by BlazorAdmin)
- `sqlserver` — shared database

Both processes share the same `CatalogConnection` and `IdentityConnection` strings, confirming a **monolithic data model** with no service-level data isolation. This is not microservices and not a modular monolith with enforced vertical boundaries — it is a horizontally layered monolith deployed as two coarse processes.

---

## Rejected Styles

| Style | Reason for rejection |
|---|---|
| Microservices | README explicitly calls this monolithic; both services share database schema |
| Modular Monolith | No vertical module boundaries with isolated schemas; organization is horizontal by layer |
| Service-Based | The two Docker services are not independently owned business capabilities; they share all data and are one cohesive application split only for Blazor admin purposes |
| Event-Driven | No message broker, no domain events published/consumed, no async event handlers |
| CQRS | MediatR is query-dispatch only; no separate read/write models or stores |
| Serverless | Deployed as standard ASP.NET Core processes |
| Pipeline | No pipeline/filter processing model |
| Microkernel | No plugin system or core-plus-extensions model |
| Space-Based | No tuple space or in-memory data grid |
| Multi-Agent | No agent coordination |

---

## Quality Attributes

- **Testability:** High. ApplicationCore has no framework dependencies; the ports-and-adapters design makes unit testing domain logic trivial with mock adapters.
- **Maintainability:** High. Clear layer boundaries, explicit interface contracts, Ardalis.Specification for reusable query logic.
- **Modularity:** Medium. Horizontal layering provides cohesion within layers but no vertical module isolation; changes to a domain concept touch multiple layers.
- **Deployability:** Medium. Single-process monolith; both processes must deploy together since they share the same database migrations.
- **Scalability:** Low-Medium. Monolithic architecture; scale-out requires running multiple instances of the whole application.
- **Observability:** Basic. Health checks are present (`/health`, `api_health_check`, `home_page_health_check`); structured logging via `IAppLogger<T>` abstraction.

---

## Conclusion

eShopOnWeb is a **Layered + Hexagonal Architecture + DDD** reference implementation. These three styles are composable, not competing: Layered defines the structural tiers, Hexagonal enforces the dependency rule (all dependencies point inward), and DDD provides the tactical vocabulary inside the domain layer. The classification confidence is high (0.95) because the project is intentionally designed to demonstrate these exact patterns and both the README and the eBook confirm the intent.
