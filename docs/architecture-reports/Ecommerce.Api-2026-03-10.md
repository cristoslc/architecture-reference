---
project: Ecommerce.Api
date: "2026-03-10"
scope: application
use-type: reference
primary-language: C#
confidence: 0.92
styles:
  - Layered
  - CQRS
  - Domain-Driven Design
---

## Ecommerce.Api (Streetwood) — Architecture Report

| Field | Value |
|---|---|
| Project | [Ecommerce.Api](https://github.com/marcinstelmach/Ecommerce.Api) |
| Internal name | Streetwood API |
| Language | C# (.NET Core 2.2) |
| Classification date | 2026-03-10 |
| Model | claude-sonnet-4-6 |
| Confidence | 0.92 |
| Primary styles | Layered, CQRS, Domain-Driven Design |
| Domain | E-Commerce |

---

## Style Rationales

### Layered Architecture (primary)

The solution is divided into three strict horizontal layers — `Streetwood.API` (presentation), `Streetwood.Infrastructure` (application/services), and `Streetwood.Core` (domain). Dependency direction is enforced at the project-reference level: API references only Infrastructure, and Infrastructure references only Core. This strict downward-only flow is the defining trait of Layered Architecture.

### CQRS

The README explicitly states "CQRS (one database)" and the Infrastructure project physically separates `Commands/` and `Queries/` trees, each with their own `Models/` and `Handlers/` sub-directories. Command handlers implement `IRequestHandler<TCommand, TResult>` for write paths; query handlers do the same for read paths. Controllers dispatch exclusively through a `IBus.SendAsync()` abstraction over MediatR, keeping the API layer free of business logic.

### Domain-Driven Design (lite)

The README states "Smart domain objects (DDD)" and the Core layer contains rich entities with protected setters and behavior-encoding methods (`Order.Close()`, `User.SetPassword()`, `User.SetRefreshToken()`). Collections are encapsulated via `IReadOnlyCollection`. Repository interfaces are defined in the domain layer and implemented away from it. Full DDD tactical patterns are absent (no explicit Aggregate Roots, Bounded Contexts, or Value Objects), hence the classification is "DDD lite".

---

## Evidence Table

| Evidence item | Location | Supports |
|---|---|---|
| README: "CQRS (one database :))" | `README.md` | CQRS |
| README: "Smart domain objects (DDD)" | `README.md` | DDD |
| `Commands/` and `Queries/` tree separation | `src/Streetwood.Infrastructure/` | CQRS |
| `IBus` / `MediatorBus` abstraction over MediatR | `src/Streetwood.API/Bus/` | CQRS |
| API only references Infrastructure `.csproj` | `src/Streetwood.API/Streetwood.API.csproj` | Layered |
| Infrastructure only references Core `.csproj` | `src/Streetwood.Infrastructure/Streetwood.Infrastructure.csproj` | Layered |
| Rich entities with protected setters, domain methods | `src/Streetwood.Core/Domain/Entities/` | DDD |
| Repository interfaces in Core domain | `src/Streetwood.Core/Domain/Abstract/Repositories/` | DDD, Layered |
| Autofac module registration separating concerns | `src/Streetwood.API/Startup.cs` | Modularity |
| Convention tests: services must be internal + implement interface | `tests/Streetwood.Convention.Tests/` | Evolvability |
| Serilog structured logging + log levels in middleware | `src/Streetwood.API/Middleware/ExceptionHandlerMiddleware.cs` | Observability |
| Azure Storage Queue for exception routing | `AzureStorageQueueManager.cs`, `ExceptionQueueFunction.cs` | Fault Tolerance |
| Memory cache registered in DI | `src/Streetwood.API/Startup.cs` | Scalability |

---

## Quality Attributes

| Attribute | Evidence |
|---|---|
| Modularity | Autofac modules (`RepositoriesModule`, `ServicesModule`, `FactoriesModule`, etc.) partition registrations; convention tests enforce internal-plus-interface pattern |
| Evolvability | Interface-per-service rule enforced by automated convention tests; strict layer boundaries prevent cross-cutting dependencies |
| Observability | Serilog integrated at host level; structured error logging with log levels (Warning vs Error) in `ExceptionHandlerMiddleware`; Azure Queue for async error alerting |
| Fault Tolerance | Unhandled exceptions are serialised to Azure Storage Queue; a separate Azure Functions project (`ExceptionQueueFunction`) picks them up and sends alert emails |
| Deployability | Azure Pipelines CI pipeline builds, tests, and publishes the web project; `Streetwood.Functions` targets Azure Functions v2 as a separate deployable |
| Scalability | `services.AddMemoryCache()` registered; single SQL Server database is the primary scale constraint acknowledged in README ("one database") |

---

## Domain

E-Commerce — product catalogue, orders with discount/promo-code support, shipment and payment processing, user management with JWT auth, image hosting via Azure Blob Storage, and email notification workflows.

---

## Production Context

- Deployed as a single ASP.NET Core 2.2 web application targeting SQL Server; migrations are managed in `Streetwood.Core/Migrations/`.
- A companion Azure Functions app (`Streetwood.Functions`) handles two background concerns: a timer-triggered keep-alive ping (`AlwaysOnFunction`) and a queue-triggered exception-email relay (`ExceptionQueueFunction`).
- Azure Blob Storage is used for image file management; Azure Storage Queue is the async error-reporting channel between the API and the Functions app.
- CI via Azure Pipelines with build, test, and publish steps; no containerisation or orchestration configuration is present.
