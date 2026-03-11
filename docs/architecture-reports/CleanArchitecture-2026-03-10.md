---
project: CleanArchitecture
date: 2026-03-10
scope: application
use-type: reference
primary-language: C#
confidence: 0.96
styles:
  - Hexagonal Architecture
  - Domain-Driven Design
  - CQRS
---

# CleanArchitecture — Architecture Report

## Metadata

| Field           | Value                                                              |
|-----------------|--------------------------------------------------------------------|
| Repository      | https://github.com/jasontaylordev/CleanArchitecture               |
| Author          | Jason Taylor                                                       |
| Language        | C# (.NET 10), TypeScript/JavaScript (Angular or React frontend)   |
| Framework       | ASP.NET Core 10, .NET Aspire, Entity Framework Core 10             |
| Package manager | NuGet (central package management via Directory.Packages.props)   |
| Deployment      | Azure App Service via Azure Developer CLI (azd); Bicep IaC        |
| Scope           | application                                                        |
| Use-type        | reference                                                          |
| Date analyzed   | 2026-03-10                                                         |

## Architecture Style Rationale

### Primary: Hexagonal Architecture (confidence 0.96)

The codebase is explicitly structured around the dependency inversion principle with four concentric rings: Domain (no external dependencies), Application (depends only on Domain, defines ports as interfaces), Infrastructure (implements ports: EF Core `ApplicationDbContext`, `IdentityService`), and Web (composition root). Dependency flow is strictly inward. Infrastructure `DependencyInjection.cs` registers `ApplicationDbContext` as `IApplicationDbContext`, making the adapter plug into the port at runtime. Layer READMEs explicitly state the dependency rules ("Domain must not depend on any other project", "Application must not depend on Infrastructure or Web").

### Secondary: Domain-Driven Design (confidence 0.90)

The Domain layer uses DDD tactical patterns: `BaseEntity` with a domain-event collection (`AddDomainEvent`, `ClearDomainEvents`), `BaseAuditableEntity`, `ValueObject` base class, and domain events (`TodoItemCompletedEvent`, `TodoItemCreatedEvent`, `TodoItemDeletedEvent`). The `TodoItem` entity encapsulates its own invariant — emitting `TodoItemCompletedEvent` inside the `Done` property setter — demonstrating behavior-rich domain objects rather than anemic data containers.

### Secondary: CQRS (confidence 0.92)

The Application layer is organized into `Commands/` and `Queries/` folders for each feature (TodoItems, TodoLists, WeatherForecasts). Commands (`CreateTodoItemCommand`, `UpdateTodoItemCommand`, `DeleteTodoItemCommand`) mutate state and return minimal results (e.g., `int` id). Queries (`GetTodoItemsWithPaginationQuery`) return read-optimized DTOs via AutoMapper `ProjectTo`. MediatR 14 dispatches both patterns through a pipeline of composable `IPipelineBehavior<,>` implementations.

## Evidence Table

| Evidence                                             | Location                                                              | Supports Style       |
|------------------------------------------------------|-----------------------------------------------------------------------|----------------------|
| `IApplicationDbContext` interface in Application     | `src/Application/Common/Interfaces/IApplicationDbContext.cs`          | Hexagonal            |
| `ApplicationDbContext : IApplicationDbContext`       | `src/Infrastructure/Data/ApplicationDbContext.cs`                     | Hexagonal            |
| Domain has zero project references                   | `src/Domain/Domain.csproj`, `src/Domain/README.md`                    | Hexagonal            |
| `BaseEntity.DomainEvents` collection                 | `src/Domain/Common/BaseEntity.cs`                                     | DDD                  |
| `TodoItem.Done` setter emits domain event            | `src/Domain/Entities/TodoItem.cs`                                     | DDD                  |
| `DispatchDomainEventsInterceptor` via MediatR        | `src/Infrastructure/Data/Interceptors/DispatchDomainEventsInterceptor.cs` | DDD + Event-Driven |
| `Commands/` and `Queries/` per feature               | `src/Application/TodoItems/`, `src/Application/TodoLists/`            | CQRS                 |
| MediatR pipeline behaviours (5 behaviours)           | `src/Application/Common/Behaviours/`                                  | CQRS / Pipeline      |
| `LoggingBehaviour`, `PerformanceBehaviour`           | `src/Application/Common/Behaviours/`                                  | Observability        |
| OpenTelemetry (traces, metrics, logs) in Aspire      | `src/ServiceDefaults/Extensions.cs`                                   | Observability        |
| Health checks `/health`, `/alive`                    | `src/ServiceDefaults/Extensions.cs`                                   | Observability        |
| Azure Bicep IaC, `azd up` deployment                 | `infra/main.bicep`, `azure.yaml`                                      | Deployability        |
| .NET Aspire AppHost orchestration                    | `src/AppHost/Program.cs`                                              | Deployability        |
| Multi-database support (SQLite/PostgreSQL/SQLServer) | `src/Infrastructure/DependencyInjection.cs`                           | Modularity           |
| `FluentValidation` in pipeline                       | `src/Application/Common/Behaviours/ValidationBehaviour.cs`            | Evolvability         |

## Quality Attributes

- **Observability**: `ServiceDefaults/Extensions.cs` registers OpenTelemetry traces, metrics (ASP.NET Core + HTTP client + runtime), and structured logging; performance warnings logged when requests exceed 500 ms (`PerformanceBehaviour`); health check endpoints `/health` and `/alive` provided.
- **Modularity**: Strict compile-time layer boundaries enforced by project references; infrastructure is plug-replaceable (SQLite, PostgreSQL, SQL Server) via conditional compilation; MediatR pipeline behaviours are independently addable.
- **Evolvability**: FluentValidation and MediatR behaviours allow cross-cutting concerns (auth, validation, logging) to be added without touching handlers; `dotnet new ca-usecase` scaffolding template reduces friction when adding use cases; central package management simplifies dependency upgrades.
- **Deployability**: Azure Developer CLI (`azd up`) provisions full Azure infrastructure from Bicep IaC; .NET Aspire AppHost manages local multi-service orchestration including database provisioning; Docker support for frontend via `PublishAsDockerFile()`.
- **Fault Tolerance**: `ServiceDefaults` configures `AddStandardResilienceHandler()` on all HTTP clients, providing default retry and circuit-breaker policies; `UnhandledExceptionBehaviour` in MediatR pipeline catches and logs all unhandled exceptions.
- **Scalability**: Single deployable unit targeted at Azure App Service; no horizontal scaling primitives (stateless by design); Aspire configuration supports database scaling out-of-process.

## Domain

Task/productivity management (TodoList/TodoItem domain). Primary purpose is to serve as a **reference template** for developers building enterprise .NET applications following Clean Architecture principles. Published to NuGet as `Clean.Architecture.Solution.Template`.

## Production Context

- Distributed as a .NET project template (`dotnet new ca-sln`); not a standalone production application.
- Azure Bicep IaC provisions App Service, Key Vault, Log Analytics, Application Insights, and relational database (PostgreSQL or SQL Server).
- CI/CD supported via `azd pipeline config` for GitHub Actions or Azure DevOps.
- Database is auto-deleted and reseeded on startup in development; migration bundles recommended for production per README guidance.
