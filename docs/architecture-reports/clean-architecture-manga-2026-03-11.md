---
project: "clean-architecture-manga"
date: 2026-03-11
scope: application
use-type: reference
primary-language: C#
confidence: 0.97
styles:
  - name: Hexagonal Architecture
    role: primary
    confidence: 0.97
  - name: Domain-Driven Design
    role: secondary
    confidence: 0.88
  - name: Layered
    role: secondary
    confidence: 0.82
---

# Architecture Analysis: clean-architecture-manga

## Metadata

| Field | Value |
|---|---|
| Project | clean-architecture-manga |
| Repo | https://github.com/ivanpaulovich/clean-architecture-manga |
| Date | 2026-03-11 |
| Scope | application |
| Use-type | reference |
| Primary Language | C# |
| Other Languages | JavaScript |

## Summary

clean-architecture-manga is a pedagogical .NET 6 reference implementation of Hexagonal Architecture (Ports and Adapters), also described in its README as "Clean Architecture." It models a virtual wallet domain (open account, deposit, withdraw, transfer, close account) using explicit use-case-centric application layer, port interfaces defined in the inner rings, and adapter implementations confined to the outer infrastructure layer. A React SPA front-end, IdentityServer 4 identity provider, NGINX reverse proxy, and SQL Server database are coordinated via Docker Compose, but the architectural showcase lives entirely in the `accounts-api` component. The project is widely starred as a teaching resource and is intentionally not a production codebase.

## Architecture Styles Identified

### Primary: Hexagonal Architecture (Ports and Adapters) — confidence 0.97

The structural evidence is unambiguous and explicitly documented in the README wiki (sections: "Hexagonal Architecture Style", "Ports", "Adapters", "Left Side", "Right Side"):

**Project layer layout (`accounts-api/src/`):**
- `Domain/` — core entities, value objects, aggregate root (`Account`), and port interfaces (`IAccountRepository`, `IAccountFactory`). Zero project references; no framework imports.
- `Application/` — orchestration use cases per business operation (`UseCases/OpenAccount/`, `Deposit/`, `Withdraw/`, `Transfer/`, `CloseAccount/`, `GetAccount/`, `GetAccounts/`), application port interfaces (`IUnitOfWork`, `ICurrencyExchange`, `IUserService`), output port interfaces (`IOutputPort`) in each use case folder. References only `Domain`.
- `Infrastructure/` — driven-side adapter implementations: `AccountRepository : IAccountRepository` (EF Core), `UnitOfWork : IUnitOfWork`, `CurrencyExchangeService : ICurrencyExchange`, `ExternalUserService : IUserService`. References `Application` and `Domain`.
- `WebApi/` — driving-side adapter. ASP.NET Core controllers implement `IOutputPort` directly, receiving use case results via the Presenter pattern. References `Application` and `Infrastructure` (for DI wiring only).

**Dependency direction enforced by project references:**
- `Domain.csproj` has no ProjectReferences.
- `Application.csproj` references only `Domain`.
- `Infrastructure.csproj` references `Application` (and transitively `Domain`).
- `WebApi.csproj` references `Application` and `Infrastructure`.

**Port-Adapter mapping:**
- Driving ports: `IOpenAccountUseCase`, `IDepositUseCase`, etc. (called by controllers)
- Driving adapters: ASP.NET Core controllers in `WebApi/UseCases/V1/`
- Driven ports: `IAccountRepository`, `IUnitOfWork`, `ICurrencyExchange`, `IUserService`
- Driven adapters: `AccountRepository`, `UnitOfWork`, `CurrencyExchangeService`, `ExternalUserService`
- Test doubles: `AccountRepositoryFake`, `UnitOfWorkFake`, `MangaContextFake` swapped in via feature flags without touching inner layers

**Output port / Presenter pattern:** Each use case folder contains its own `IOutputPort` interface listing all possible outcomes (e.g., `Ok`, `NotFound`, `Invalid`, `HasFunds`). Controllers implement `IOutputPort`, and use cases call the port rather than constructing HTTP responses. This is canonical hexagonal "output port" design.

### Secondary: Domain-Driven Design — confidence 0.88

The Domain layer applies DDD tactical patterns, acknowledged in the README wiki section "Domain-Driven Design Patterns":

- **Aggregate Root:** `Account` is the aggregate root, owning `CreditsCollection` and `DebitsCollection`. Domain logic such as `IsClosingAllowed()` and `GetCurrentBalance()` lives on the aggregate.
- **Value Objects:** `Money` (immutable struct with `Amount` + `Currency`, custom equality, `Subtract`, `Add`, `IsZero`), `Currency`, `AccountId`, `CreditId`, `DebitId`.
- **Entities:** `Credit` and `Debit` have identity via `CreditId`/`DebitId`.
- **Repository:** `IAccountRepository` in `Domain/` abstracts persistence; infrastructure provides the implementation.
- **Factory:** `IAccountFactory` in `Domain/` with `EntityFactory` implementation in `Infrastructure`.
- **Null Object:** `AccountNull` and `CreditNull`/`DebitNull` avoid null checks inside domain logic.
- **Use Case pattern** (Application Services): each operation is a discrete, self-contained class encapsulating a single business use case.

The DDD tactical patterns serve the hexagonal structure rather than replacing it; there are no bounded context separations or domain events, so strategic DDD does not apply.

### Secondary: Layered Architecture — confidence 0.82

The four-layer horizontal separation (Domain → Application → Infrastructure → WebApi) is present and enforces a dependency hierarchy. However, the Dependency Inversion Principle causes dependencies to point inward rather than downward through all layers uniformly, which is the distinguishing characteristic of Hexagonal over classical Layered. The layered decomposition is real but subordinate to the hexagonal dependency rule.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| Explicit port interfaces in Domain | `accounts-api/src/Domain/IAccountRepository.cs`, `IAccountFactory.cs` | Hexagonal Architecture |
| Application port interfaces | `accounts-api/src/Application/Services/IUnitOfWork.cs`, `ICurrencyExchange.cs`, `IUserService.cs` | Hexagonal Architecture |
| Output port per use case | `accounts-api/src/Application/UseCases/*/IOutputPort.cs` (7 use cases) | Hexagonal Architecture |
| Controllers implement IOutputPort | `accounts-api/src/WebApi/UseCases/V1/Accounts/OpenAccount/AccountsController.cs` | Hexagonal Architecture |
| Driven adapters in Infrastructure | `accounts-api/src/Infrastructure/DataAccess/Repositories/AccountRepository.cs` | Hexagonal Architecture |
| Feature-flag-swappable adapters | `accounts-api/src/WebApi/Modules/SQLServerExtensions.cs` | Hexagonal Architecture |
| Domain zero project references | `accounts-api/src/Domain/Domain.csproj` | Hexagonal Architecture |
| Application → Domain only | `accounts-api/src/Application/Application.csproj` | Hexagonal Architecture |
| Decorator pattern for validation use cases | `accounts-api/src/WebApi/Modules/UseCasesExtensions.cs` (`services.Decorate`) | Hexagonal Architecture |
| Aggregate root with domain logic | `accounts-api/src/Domain/Account.cs` | Domain-Driven Design |
| Value object Money (immutable struct) | `accounts-api/src/Domain/ValueObjects/Money.cs` | Domain-Driven Design |
| Repository interface in Domain layer | `accounts-api/src/Domain/IAccountRepository.cs` (wiki comment: "Repository DDD Pattern") | Domain-Driven Design |
| Null Object pattern | `accounts-api/src/Domain/AccountNull.cs` | Domain-Driven Design |
| Four-layer horizontal separation | `accounts-api/src/{Domain,Application,Infrastructure,WebApi}` | Layered |
| README wiki explicitly describes Hexagonal, Onion, Clean Architecture styles | `README.md` lines 93-99 | Architecture documentation |

## Quality Attributes

| Attribute | Assessment | Evidence |
|---|---|---|
| Testability | High | Inner layers (Domain, Application) have zero framework dependencies; `AccountRepositoryFake`, `UnitOfWorkFake` enable in-process component testing. `ComponentTests/` project exercises the HTTP stack via `CustomWebApplicationFactory` with fake adapters. |
| Maintainability | High | Each use case is a discrete, self-contained class (~80 lines). Output ports enumerate all outcomes explicitly, preventing hidden control flow. Decorator chain (`services.Decorate`) adds validation without modifying use case logic. |
| Evolvability | High | Adapters can be replaced transparently (feature flags switch between SQL Server and in-memory fakes at runtime). New transport protocols (gRPC, CLI) could drive the same use cases with no changes to Application or Domain. |
| Separation of Concerns | High | HTTP concerns are confined to WebApi; persistence details to Infrastructure; business rules to Application/Domain. No framework types cross layer boundaries except via DI registration. |
| Observability | Moderate | Prometheus metrics exposed via `endpoints.MapMetrics()` and `AddHttpMetrics()`; health checks registered via `HealthChecksExtensions`. No structured distributed tracing. |
| Scalability | Low-Moderate | Single-service deployment with SQL Server; no horizontal scaling mechanisms, message queues, or caching. Appropriate for reference scope. |
| Security | Moderate | IdentityServer 4 OAuth2/OIDC integration; JWT bearer authentication; CORS configured; data protection extensions. |

## Classification Reasoning

The repository is a deliberate, high-fidelity demonstration of Hexagonal Architecture (Ports and Adapters). The evidence is explicit at every level: the README wiki names the style and maps components to ports/adapters/left-side/right-side; the project reference graph enforces the inward dependency rule structurally (not just by convention); every use case exposes an `IOutputPort` for each output path and receives its driven ports by constructor injection; and test doubles swap in via feature flags without touching any inner-layer code.

The Domain-Driven Design tactical patterns (aggregate root, value objects, repository interface in domain, factory) complement and strengthen the hexagonal structure by ensuring the Domain layer is genuinely rich, not anemic. However, there are no bounded contexts, domain events, or event sourcing, so DDD does not rise to a primary classification.

Classical Layered Architecture is present as a structural observation (four distinct horizontal layers), but it is subordinate: the dependency inversion that defines Hexagonal overrides the downward-only flow of classical layering.

No CQRS split (reads and writes use the same repository), no event-driven messaging, no microservices boundaries, and no plugin/kernel structure were observed. The classification is Hexagonal Architecture (primary) with Domain-Driven Design and Layered as secondary styles. Confidence is 0.97 given the explicit self-documentation and clean structural enforcement.
