---
project: "domain-driven-hexagon"
date: 2026-03-11
scope: application
use-type: reference
primary-language: TypeScript
confidence: 0.97
styles:
  - name: Hexagonal Architecture
    role: primary
    confidence: 0.97
  - name: Domain-Driven Design
    role: primary
    confidence: 0.97
  - name: CQRS
    role: secondary
    confidence: 0.90
  - name: Modular Monolith
    role: secondary
    confidence: 0.85
---

# Architecture Analysis: domain-driven-hexagon

## Metadata

| Field | Value |
|---|---|
| Project | domain-driven-hexagon |
| Version | 2.0.0 |
| Repo | https://github.com/Sairyss/domain-driven-hexagon |
| Date | 2026-03-11 |
| Scope | application |
| Use-type | reference |
| Primary Language | TypeScript |
| Other Languages | JavaScript |

## Style Rationales

**Hexagonal Architecture (primary, 0.97):** The entire codebase is structured around the Ports and Adapters pattern. Domain-defined port interfaces (`src/libs/ddd/repository.port.ts`, `src/libs/ports/logger.port.ts`, `src/modules/user/database/user.repository.port.ts`) are the sole coupling surface between the application core and the outside world. Infrastructure adapters (`UserRepository`, `WalletRepository` extending `SqlRepositoryBase`) implement these ports, while inbound adapters (HTTP controllers, CLI controller, GraphQL resolvers, message controller) all translate external requests into domain Commands/Queries and dispatch them through the application layer — never calling domain logic directly. Architecture rules are machine-enforced: the `.dependency-cruiser.js` file encodes five hard `error`-severity rules (no-domain-to-api-deps, no-domain-to-app-deps, no-domain-to-infra-deps, no-infra-to-api-deps, no-command-query-to-api-deps) that fail the CI build if any dependency violates the hexagon boundary.

**Domain-Driven Design (primary, 0.97):** The `src/libs/ddd/` library provides the complete DDD tactical toolkit: `AggregateRoot`, `Entity`, `ValueObject`, `DomainEvent`, repository port, mapper interface, command base, and query base — all purpose-built for domain isolation. `UserEntity extends AggregateRoot<UserProps>` demonstrates rich-domain behavior: factory method `create()` emitting `UserCreatedDomainEvent`, guarded mutation methods (`makeAdmin()`, `updateAddress()`), and an explicit `validate()` hook. Value objects (e.g., `Address`) encapsulate domain invariants. Bounded contexts are expressed as NestJS modules (`UserModule`, `WalletModule`) with explicit DI tokens isolating cross-module access. Domain events cross aggregate boundaries asynchronously (`CreateWalletWhenUserIsCreatedDomainEventHandler` uses `@OnEvent(UserCreatedDomainEvent.name)` via NestJS EventEmitter2), preserving aggregate root encapsulation.

**CQRS (secondary, 0.90):** The project applies CQRS rigorously at the application layer. Write operations flow through Command objects (`CreateUserCommand`, `DeleteUserCommand`) dispatched via `@nestjs/cqrs` `CommandBus` to `ICommandHandler` services (`CreateUserService`, `DeleteUserService`) that always pass through the domain model and repository. Read operations use `QueryHandler` (`FindUsersQueryHandler`) that bypass the domain and repository layers entirely, executing raw SQL against the database pool directly for performance — a clear read-model pattern. The `@CommandHandler` / `@QueryHandler` decorators make the split explicit and IDE-navigable.

**Modular Monolith (secondary, 0.85):** All modules (`UserModule`, `WalletModule`) are composed into a single `AppModule` and deploy as one NestJS process with a single PostgreSQL database (Slonik connection pool). The module structure enforces bounded-context separation through NestJS DI token isolation (`USER_REPOSITORY`, `WALLET_REPOSITORY`), with explicit export boundaries preventing direct cross-module repository access. Docker Compose (`docker/docker-compose.yml`) brings up a single application container alongside Postgres — no service mesh, no independent deployment units.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `RepositoryPort<Entity>` interface (domain-owned port) | `src/libs/ddd/repository.port.ts` | Hexagonal Architecture |
| `LoggerPort` interface (domain-owned port) | `src/libs/ports/logger.port.ts` | Hexagonal Architecture |
| `UserRepositoryPort extends RepositoryPort<UserEntity>` | `src/modules/user/database/user.repository.port.ts` | Hexagonal Architecture |
| `SqlRepositoryBase implements RepositoryPort` (infrastructure adapter) | `src/libs/db/sql-repository.base.ts` | Hexagonal Architecture |
| HTTP, CLI, GraphQL, message controllers all as inbound adapters | `src/modules/user/commands/create-user/` | Hexagonal Architecture |
| `.dependency-cruiser.js` 5 hard error rules enforcing layer isolation | `.dependency-cruiser.js` | Hexagonal Architecture |
| `AggregateRoot`, `Entity`, `ValueObject`, `DomainEvent` base classes | `src/libs/ddd/` | Domain-Driven Design |
| `UserEntity.create()` emits `UserCreatedDomainEvent` | `src/modules/user/domain/user.entity.ts` | Domain-Driven Design |
| `Address` value object with structural encapsulation | `src/modules/user/domain/value-objects/address.value-object.ts` | Domain-Driven Design |
| `CreateWalletWhenUserIsCreatedDomainEventHandler` cross-aggregate reaction | `src/modules/wallet/application/event-handlers/` | Domain-Driven Design |
| `UserMapper` implements `Mapper<Domain, DbRecord, Response>` | `src/modules/user/user.mapper.ts` | Domain-Driven Design |
| `@CommandHandler(CreateUserCommand)` on `CreateUserService` | `src/modules/user/commands/create-user/create-user.service.ts` | CQRS |
| `FindUsersQueryHandler` queries DB pool directly (read model bypass) | `src/modules/user/queries/find-users/find-users.query-handler.ts` | CQRS |
| `CommandBus.execute()` in all controllers | `src/modules/user/commands/create-user/create-user.http.controller.ts` | CQRS |
| `UserModule` + `WalletModule` composed in single `AppModule` | `src/app.module.ts` | Modular Monolith |
| Single NestJS process, single Postgres DB | `docker/docker-compose.yml` | Modular Monolith |
| DI token isolation: `USER_REPOSITORY`, `WALLET_REPOSITORY` | `src/modules/user/user.di-tokens.ts`, `src/modules/wallet/wallet.di-tokens.ts` | Modular Monolith |

## Quality Attributes

| Attribute | Assessment |
|---|---|
| Testability | Very high. Domain is pure TypeScript with no framework dependencies; can be unit-tested in isolation. Ports allow infrastructure to be mocked at the boundary. E2E tests in `tests/` via Jest with supertest. |
| Maintainability | High. Strict dependency direction enforced by dependency-cruiser prevents accidental coupling. CQRS separates read and write responsibilities. DDD tactical patterns make business rules explicit and localized. |
| Extensibility | High. New inbound adapters (e.g., gRPC controller) can be added without touching domain or application logic. New aggregates slot in as new modules with their own ports and DI tokens. |
| Modularity | High. Bounded context boundaries expressed as NestJS modules with token-isolated repositories. Explicit mapper pattern decouples domain, persistence, and API representations. |
| Observability | Moderate. Request context tracking via `nestjs-request-context` with request IDs propagated through all log messages. No built-in metrics or distributed tracing visible in the codebase. |
| Scalability | Moderate. Single-process NestJS monolith backed by a single Postgres instance limits horizontal scale. The README notes bounded-context separation makes microservice extraction straightforward if needed. |
| Portability | High. Framework is used at the edges only; domain and application layers have no NestJS imports. Language-agnostic patterns mean the design transfers to any OO language. |

## What Was Considered and Rejected

**Not Microservices:** A single deployable NestJS application backed by one PostgreSQL database. `@nestjs/microservices` is present solely as a transport option for the message controller (demonstrating the adapter pattern), not as a distributed service topology.

**Not Event-Driven (primary):** Domain events (`EventEmitter2`) are used as a DDD coordination mechanism within the monolith, not as the primary architectural organizing principle. There is no message broker, event store, or event-sourcing infrastructure.

**Not Layered (traditional):** While layers exist, the defining characteristic is dependency inversion via ports. Traditional layered architecture has controllers calling services calling repositories in a downward stack; here the domain core owns the interfaces and infrastructure provides implementations pointing inward.

**Not CQRS (primary):** CQRS is a valuable secondary pattern but the governing architecture is Hexagonal. The outer hexagon structure (ports/adapters with enforced dependency rules) wraps and contains the CQRS application layer.
