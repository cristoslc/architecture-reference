---
project: Practical.CleanArchitecture
date: 2026-03-10
scope: application
use-type: reference
primary-language: C#
confidence: 0.95
styles:
  - Modular Monolith
  - Microservices
  - Layered
  - Hexagonal Architecture
  - CQRS
  - Domain-Driven Design
---

# Practical.CleanArchitecture — Architecture Report

## Metadata

| Field           | Value                                                                         |
|-----------------|-------------------------------------------------------------------------------|
| Repository      | https://github.com/phongnguyend/Practical.CleanArchitecture                   |
| Author          | Phong Nguyen                                                                  |
| Language        | C# (.NET 8), TypeScript/JavaScript (Angular, React, Vue frontends)            |
| Framework       | ASP.NET Core 8, Entity Framework Core, Duende IdentityServer, .NET Aspire     |
| Package manager | NuGet, npm                                                                    |
| Deployment      | Three variants: Monolith, Modular Monolith, and Microservices (Docker Compose / Kubernetes / Helm) |
| Scope           | application                                                                   |
| Use-type        | reference                                                                     |
| Date analyzed   | 2026-03-10                                                                    |

## Architecture Style Rationale

### Primary: Modular Monolith (confidence 0.95)

The `src/ModularMonolith/` solution is the most architecturally sophisticated variant.
It deploys as a single process while enforcing strict vertical module boundaries via
separate C# projects: `ClassifiedAds.Modules.AuditLog`, `ClassifiedAds.Modules.Configuration`,
`ClassifiedAds.Modules.Identity`, `ClassifiedAds.Modules.Notification`,
`ClassifiedAds.Modules.Product`, and `ClassifiedAds.Modules.Storage`. Each module owns its
entities, commands, queries, event handlers, persistence DbContext, and registration
extension method. The `docker-compose.yml` in `src/ModularMonolith/` deploys a single
`webapi` container. Modules are composed at startup via
`.AddAuditLogModule().AddConfigurationModule()...` in `Program.cs`. Inter-module
communication is mediated through the shared `ClassifiedAds.Contracts` project, which
defines typed service interfaces (`IAuditLogService`, etc.) rather than direct project
references between modules.

### Secondary: Microservices (confidence 0.93)

`src/Microservices/` is an independently deployable variant with six autonomous services
(`Services.AuditLog`, `Services.Configuration`, `Services.Identity`, `Services.Notification`,
`Services.Product`, `Services.Storage`). Each service has its own `.sln` file, separate
database (per-service connection string in `docker-compose.yml`), dedicated API and gRPC
endpoints, and independent Docker build artifacts. The Microservices compose file provisions
RabbitMQ for async messaging alongside per-service SQL Server databases. API gateways
(`Gateways.WebAPI`, `Gateways.GraphQL`) aggregate service responses. Kubernetes manifests
(`.k8s/*.yaml`) and Helm charts (`.helm/`) confirm production-grade independent deployment.

### Supporting: Layered Architecture with Hexagonal inner structure (confidence 0.95)

All three variants share the same inner layer decomposition: `Domain` (no dependencies, pure
domain entities, repository interfaces, domain event interfaces, value objects, and
infrastructure ports like `IFileStorageManager` and `IMessageBus`), `Application` (CQRS
commands and queries organized per feature, `Dispatcher` for in-process dispatch, domain
event handlers), `Infrastructure` (adapter implementations for storage, messaging, caching,
AI, monitoring, notifications), and `Persistence` (EF Core `DbContext` per database engine).
Architecture tests in `ClassifiedAds.ArchTests` enforce that `Domain` has no dependency on
`Application`, `Infrastructure`, or `Persistence` at compile time via `NetArchTest`.

### Supporting: CQRS (confidence 0.95)

The `Application` layer implements CQRS using a custom, hand-rolled dispatcher — not MediatR.
Every feature area (Products, FileEntries, Users, Roles, etc.) exposes `Commands/` and
`Queries/` sub-folders. Generic base commands (`AddEntityCommand<T>`, `DeleteEntityCommand<T>`,
`UpdateEntityCommand<T>`) and queries (`GetEntitiesQuery<T>`, `GetEntityByIdQuery<T>`) are
defined in `Common/`. The `Dispatcher.cs` resolves handlers dynamically by reflection and
dispatches both commands and domain events through the DI container. Commands and queries are
decoupled at the interface level: `ICommand` / `ICommandHandler<T>` / `IQuery<TResult>` /
`IQueryHandler<TQuery, TResult>`.

### Supporting: Domain-Driven Design (tactical) (confidence 0.85)

The `Domain` project contains `IAggregateRoot`, an abstract `Entity<TKey>` base with concurrency
tokens, value objects (`Address`, `Money`), domain events (`EntityCreatedEvent<T>`,
`EntityUpdatedEvent<T>`, `EntityDeletedEvent<T>`), and `IDomainEvent` / `IDomainEventHandler<T>`
interfaces. The Outbox pattern (`OutboxMessage` entity, `OutBoxEventPublishers/` in each module
and service) ensures reliable async event delivery. Bounded contexts map directly to modules
in the Modular Monolith and to services in the Microservices variant.

## Evidence Table

| Evidence                                                         | Location                                                                    | Supports Style      |
|------------------------------------------------------------------|-----------------------------------------------------------------------------|---------------------|
| Six module projects with self-contained Commands/Queries/Persistence | `src/ModularMonolith/ClassifiedAds.Modules.*/`                          | Modular Monolith    |
| Single docker container in ModularMonolith compose file          | `src/ModularMonolith/docker-compose.yml`                                    | Modular Monolith    |
| `ClassifiedAds.Contracts` inter-module service interfaces        | `src/ModularMonolith/ClassifiedAds.Contracts/`                              | Modular Monolith    |
| Module registration extension methods                            | Each `ClassifiedAds.Modules.*/ServiceCollectionExtensions.cs`               | Modular Monolith    |
| Six independent services, each with own `.sln` and `Dockerfile`  | `src/Microservices/Services.*/`                                             | Microservices       |
| Per-service SQL Server databases in compose                      | `src/Microservices/docker-compose.yml`                                      | Microservices       |
| `Gateways.WebAPI` and `Gateways.GraphQL` API gateways           | `src/Microservices/Gateways.*/`                                             | Microservices       |
| Kubernetes manifests and Helm charts                             | `.k8s/`, `.helm/` under `deployments/`                                      | Microservices       |
| `Domain.csproj` — zero project dependencies                     | `src/Monolith/ClassifiedAds.Domain/ClassifiedAds.Domain.csproj`             | Hexagonal/Layered   |
| `IFileStorageManager`, `IMessageBus` ports in Domain            | `src/Monolith/ClassifiedAds.Domain/Infrastructure/`                         | Hexagonal           |
| Multiple storage adapters: Local, Azure Blob, Amazon S3          | `src/Monolith/ClassifiedAds.Infrastructure/Storages/`                       | Hexagonal           |
| Messaging adapters: RabbitMQ, Kafka, Azure Service Bus          | `src/Monolith/ClassifiedAds.Infrastructure/Messaging/`                      | Hexagonal           |
| `NetArchTest` dependency enforcement in `ClassifiedAds.ArchTests` | `src/Monolith/ClassifiedAds.ArchTests/DomainTests.cs`                      | Layered/Hexagonal   |
| `ICommand`, `IQuery<T>`, hand-rolled `Dispatcher.cs`            | `src/Monolith/ClassifiedAds.Application/Common/`                            | CQRS                |
| Per-feature `Commands/` and `Queries/` folders                  | `src/Monolith/ClassifiedAds.Application/Products/`, `FileEntries/`, etc.    | CQRS                |
| `IAggregateRoot`, `Entity<TKey>`, `IDomainEvent`, value objects  | `src/Monolith/ClassifiedAds.Domain/Entities/`, `ValueObjects/`, `Events/`   | DDD                 |
| Outbox pattern for reliable async event delivery                 | `src/Monolith/ClassifiedAds.Domain/Entities/OutboxMessage.cs`               | DDD / Event-Driven  |

## Quality Attributes

- **Testability**: `ClassifiedAds.ArchTests` enforces dependency rules at compile time via `NetArchTest`; each module and service includes dedicated unit, integration, and end-to-end test projects (`ClassifiedAds.UnitTests`, `ClassifiedAds.Modules.Product.UnitTests`, `ClassifiedAds.Modules.Product.IntegrationTests`, `ClassifiedAds.Modules.Product.EndToEndTests`); ports-and-adapters design enables in-process substitution of infrastructure adapters.
- **Modularity**: Vertical module boundaries are enforced by project isolation; each module owns its domain entities, commands, queries, event handlers, and EF Core persistence; `ClassifiedAds.Contracts` provides typed inter-module seams.
- **Evolvability**: All three deployment topologies (Monolith, Modular Monolith, Microservices) are maintained in parallel, demonstrating a clear migration path; new adapters can be added without touching domain or application code.
- **Scalability**: Microservices variant supports independent horizontal scaling per service with per-service databases, Kubernetes orchestration, and Helm charts; Modular Monolith supports vertical scaling of a single process.
- **Observability**: OpenTelemetry (traces and metrics), Azure Application Insights, file-based logging, and Elasticsearch logging are all implemented as pluggable options via configuration; health check UI endpoint is included.
- **Security**: Duende IdentityServer provides OpenID Connect / OAuth 2.0; per-service authentication configuration in `appsettings.json`; multiple identity provider adapters (Azure AD B2C, Auth0, Google, Facebook, Microsoft); security headers middleware in WebMVC.
- **Operability**: Docker Compose for local development, Kubernetes manifests and Helm charts for production; .NET Aspire app host for orchestrated local runs; per-environment configuration via `appsettings.*.json`.

## Domain

Classified ads / e-commerce reference application ("ClassifiedAds") covering Products, File Storage, User Management, Roles, Audit Logging, Configuration, and Notifications. The domain is intentionally simple — a "classified ads" marketplace — to keep the focus on demonstrating architectural patterns rather than business complexity.

## Production Context

- Reference implementation showcasing Clean Architecture across three deployment topologies.
- Monolith: single ASP.NET Core process with WebMVC, WebAPI, Blazor, and multiple SPA frontends (Angular, React, Vue).
- Modular Monolith: single deployable with enforced module boundaries and shared-database multi-schema configuration.
- Microservices: six independently deployable services communicating via REST, gRPC, and RabbitMQ/Kafka message bus, fronted by WebAPI and GraphQL gateways.
- CI/CD: Azure Pipelines and Jenkinsfile for both variant families.
- IdentityServer: Duende IdentityServer with separate `.sln` in `src/IdentityServers/`.
