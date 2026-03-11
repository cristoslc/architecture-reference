---
project: NorthwindTraders
date: 2026-03-10
scope: application
use-type: reference
primary-language: C#
confidence: 0.93
styles:
  - Hexagonal Architecture
  - CQRS
---

# NorthwindTraders — Architecture Report

## Metadata

| Field           | Value                                                                  |
|-----------------|------------------------------------------------------------------------|
| Repository      | https://github.com/JasonGT/NorthwindTraders                           |
| Author          | Jason Taylor                                                           |
| Language        | C# (.NET Core 3.0), TypeScript/JavaScript (Angular frontend)          |
| Framework       | ASP.NET Core 3.0, Entity Framework Core 3.0, MediatR 7, IdentityServer |
| Package manager | NuGet                                                                  |
| Deployment      | Single deployable ASP.NET Core Web process (archived reference project)|
| Scope           | application                                                            |
| Use-type        | reference                                                              |
| Date analyzed   | 2026-03-10                                                             |

## Architecture Style Rationale

### Primary: Hexagonal Architecture (confidence 0.93)

The solution is organized into concentric rings where all dependencies point inward: `Domain` (zero references, pure .NET Standard 2.1) at the core, `Application` defining five ports as interfaces (`INorthwindDbContext`, `ICurrentUserService`, `INotificationService`, `ICsvFileBuilder`, `IUserManager`), and outer `Infrastructure`/`Persistence` projects implementing those ports as adapters. `NorthwindDbContext : DbContext, INorthwindDbContext` in `Src/Persistence/` is the canonical adapter, and `Src/WebUI/Services/CurrentUserService` implements `ICurrentUserService` from the HTTP context. The solution file groups projects into explicit "Core", "Infrastructure", and "Presentation" solution folders, confirming the concentric-ring intent as structural policy.

### Secondary: CQRS (confidence 0.91)

The `Application` layer is partitioned into `Commands/` and `Queries/` sub-folders for every feature (Categories, Customers, Employees, Products). Commands (`CreateProductCommand`, `UpdateProductCommand`, `DeleteProductCommand`) are dispatched through MediatR `IRequestHandler<TCommand, TResult>` and mutate state via the `INorthwindDbContext` port. Queries (`GetProductsListQuery`, `GetProductDetailQuery`) return read-optimized ViewModels (`ProductsListVm`, `ProductDetailVm`) mapped via AutoMapper. Cross-cutting concerns are applied uniformly through MediatR pipeline behaviours: `RequestValidationBehavior` (FluentValidation), `RequestPerformanceBehaviour` (500 ms threshold logging), and `RequestLogger`.

## Evidence Table

| Evidence                                                  | Location                                                              | Supports Style    |
|-----------------------------------------------------------|-----------------------------------------------------------------------|-------------------|
| `INorthwindDbContext` interface in Application            | `Src/Application/Common/Interfaces/INorthwindDbContext.cs`            | Hexagonal         |
| `NorthwindDbContext : DbContext, INorthwindDbContext`      | `Src/Persistence/NorthwindDbContext.cs`                               | Hexagonal         |
| `ICurrentUserService`, `INotificationService` ports       | `Src/Application/Common/Interfaces/`                                  | Hexagonal         |
| `Domain.csproj` — zero project references                 | `Src/Domain/Domain.csproj`                                            | Hexagonal         |
| Application references only Domain and Common             | `Src/Application/Application.csproj`                                  | Hexagonal         |
| Infrastructure/Persistence reference Application (inward) | `Src/Infrastructure/Infrastructure.csproj`, `Persistence.csproj`      | Hexagonal         |
| Solution folders: Core / Infrastructure / Presentation    | `Northwind.sln`                                                       | Hexagonal         |
| `Commands/` and `Queries/` per feature domain             | `Src/Application/Products/`, `Src/Application/Customers/`, etc.       | CQRS              |
| `CreateProductCommandHandler : IRequestHandler<,>`        | `Src/Application/Products/Commands/CreateProduct/`                    | CQRS              |
| `GetProductsListQueryHandler` returns `ProductsListVm`    | `Src/Application/Products/Queries/GetProductsList/`                   | CQRS              |
| MediatR pipeline behaviours (validation, perf, logging)   | `Src/Application/Common/Behaviours/`                                  | CQRS / Pipeline   |
| `ValueObject` base class, `AdAccount` value object        | `Src/Domain/Common/ValueObject.cs`, `Src/Domain/ValueObjects/`        | DDD (tactical)    |
| `AuditableEntity` with CreatedBy/LastModifiedBy tracking  | `Src/Domain/Common/AuditableEntity.cs`                                | Domain modeling   |
| Angular SPA served from single WebUI host                 | `Src/WebUI/WebUI.csproj` (SpaRoot + SpaServices)                      | Single deployment |

## Quality Attributes

- **Testability**: Ports-and-adapters design means all Application handlers can be unit-tested by substituting in-memory implementations of `INorthwindDbContext`; Tests folder contains Application.UnitTests, Domain.UnitTests, WebUI.IntegrationTests, and Persistence.IntegrationTests.
- **Modularity**: Strict compile-time project boundaries (6 projects) enforce layer separation; infrastructure concerns are swappable at composition time without touching Application or Domain code.
- **Evolvability**: FluentValidation validators and MediatR pipeline behaviours are independently addable; new use cases require only a new Command/Query + Handler + Validator triple without modifying existing code.
- **Observability**: `RequestPerformanceBehaviour` logs a warning for any MediatR request exceeding 500 ms; `RequestLogger` logs every request with user context; ASP.NET Core standard logging pipeline is used throughout.
- **Security**: IdentityServer 4 via `Microsoft.AspNetCore.ApiAuthorization.IdentityServer` provides OpenID Connect / OAuth 2.0; `[Authorize]` on controllers; `ICurrentUserService` abstracts authenticated identity across the Application layer.
- **Scalability**: Single deployable monolith with a single SQL Server database; no horizontal scaling primitives; stateless request handling is scale-out compatible in principle but not explicitly configured.

## Domain

E-Commerce / trade management based on the classic Microsoft Northwind database schema (Customers, Products, Orders, Employees, Suppliers). The repository's stated purpose is to demonstrate the simplest approach to Clean Architecture with .NET Core; it is archived in favor of the actively maintained [CleanArchitecture](https://github.com/jasontaylordev/CleanArchitecture) template.

## Production Context

- Archived reference repository; not intended for production deployment.
- Single process: ASP.NET Core 3.0 host serving both REST API (`/api/...`) and Angular SPA (`ClientApp/`).
- Database: SQL Server via Entity Framework Core with migrations in `Src/Persistence/Migrations/`.
- CI/CD: Azure Pipelines (`azure-pipelines.yml`) for build validation.
- Identity: IdentityServer 4 with separate `ApplicationDbContext` for identity data alongside `NorthwindDbContext` for business data.
