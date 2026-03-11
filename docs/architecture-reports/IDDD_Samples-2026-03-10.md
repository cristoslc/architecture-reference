---
project: IDDD_Samples
date: 2026-03-10
scope: application
use-type: reference
primary-language: Java
confidence: 0.97
styles:
  - Modular Monolith
qualifiers:
  - design-approach: ddd
  - design-approach: hexagonal
  - data-pattern: event-sourcing
  - data-pattern: cqrs
---

# IDDD_Samples — Architecture Report

## Metadata

| Field           | Value                                                              |
|-----------------|--------------------------------------------------------------------|
| Repository      | https://github.com/VaughnVernon/IDDD_Samples                      |
| Author          | Vaughn Vernon                                                      |
| Language        | Java 7                                                             |
| Framework       | Spring 2.5.6, Hibernate 3.2, RESTEasy 2.0, RabbitMQ AMQP 3.0     |
| Build           | Gradle multi-module                                                |
| Deployment      | Single Gradle build; MySQL + RabbitMQ via Docker (startContainers.sh) |
| Scope           | application                                                        |
| Use-type        | reference                                                          |
| Date analyzed   | 2026-03-10                                                         |

## Architecture Style Rationale

### Primary: Modular Monolith (confidence 0.97)

The entire system compiles and deploys as a single Gradle multi-project build (`settings.gradle` declares `iddd_agilepm`, `iddd_collaboration`, `iddd_identityaccess`, `iddd_common`). There is no independent deployment, no service registry, and no network boundary between bounded contexts — inter-context integration is handled by shared RabbitMQ message listeners within the same process or by direct in-process calls through `iddd_common`. Each Gradle module represents a hard internal boundary (packages cannot bleed across modules without an explicit `compile project(...)` dependency), satisfying the Modular Monolith definition of well-defined internal module boundaries in a single deployable unit.

### Design Approach: Domain-Driven Design (confidence 0.98)

Each module maps to a canonical DDD bounded context with its own package root (`com.saasovation.agilepm`, `com.saasovation.collaboration`, `com.saasovation.identityaccess`) and its own Ubiquitous Language. All three contexts implement the full suite of DDD tactical patterns: Aggregate roots (`Product extends Entity`, `Calendar extends EventSourcedRootEntity`, `User extends ConcurrencySafeEntity`), Value Objects (`TenantId`, `CalendarId`, `EmailAddress`), Domain Services (`AuthenticationService`, `GroupMemberService`, `CollaboratorService`), Repository interfaces defined inside the domain layer (`ProductRepository`, `CalendarRepository`, `UserRepository`), and Domain Events published via `DomainEventPublisher.instance().publish(...)`. The `iddd_common` module provides the shared kernel: `Entity`, `ConcurrencySafeEntity`, `EventSourcedRootEntity`, `DomainEvent`, `DomainEventPublisher`, and `DomainEventSubscriber`.

### Design Approach: Hexagonal Architecture / Ports and Adapters (confidence 0.95)

All three contexts explicitly organize their secondary adapters under `port/adapter/` packages, cleanly separated from the domain model: `port/adapter/persistence/` (LevelDB, Hibernate, EventStore implementations), `port/adapter/messaging/rabbitmq/` and `port/adapter/messaging/sloth/` (message listeners), `port/adapter/notification/` (REST notification publishers), and `port/adapter/service/` (external service adapters). Application services (`ProductApplicationService`, `CalendarApplicationService`, `IdentityApplicationService`) act as primary ports, translating external requests into domain method calls. Repository interfaces are defined inside the domain layer and implemented in adapters, enforcing the dependency-inversion principle at every context boundary.

### Data Pattern: CQRS + Event Sourcing (collaboration context, confidence 0.97)

The README explicitly states "the iddd_collaboration project uses Event Sourcing and CQRS." Calendar, CalendarEntry, Forum, Discussion, and Post aggregates all extend `EventSourcedRootEntity` and mutate state only via `apply(DomainEvent)` and corresponding `when(EventType)` methods. The event journal is stored in LevelDB via `EventStoreCalendarRepository`. The read model is maintained in MySQL by five projection handlers (`MySQLCalendarProjection`, `MySQLForumProjection`, `MySQLDiscussionProjection`, `MySQLCalendarEntryProjection`, `MySQLPostProjection`), each implementing `EventDispatcher` and updating denormalized `tbl_vw_*` view tables. Separate `CalendarQueryService`, `ForumQueryService`, `DiscussionQueryService`, and `PostQueryService` classes implement the query side using raw JDBC against those view tables.

## Evidence Table

| Evidence                                                    | Location                                                                                               | Supports                    |
|-------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|-----------------------------|
| Single Gradle build, four sub-projects, no network boundary | `settings.gradle`, `build.gradle`                                                                      | Modular Monolith             |
| `compile project(':iddd_common')` cross-module dep          | `build.gradle` lines 42, 57, 70                                                                        | Modular Monolith             |
| `Product extends Entity`, `Calendar extends EventSourcedRootEntity` | `iddd_agilepm/.../Product.java`, `iddd_collaboration/.../Calendar.java`               | DDD Aggregates               |
| `DomainEventPublisher.instance().publish(new ProductCreated(...))` | `iddd_agilepm/.../Product.java:68`                                                    | DDD Domain Events            |
| `ProductRepository`, `CalendarRepository` interfaces in domain | `iddd_agilepm/domain/model/product/ProductRepository.java`, `iddd_collaboration/...` | DDD Repositories             |
| `LevelDBProductRepository`, `HibernateUserRepository`       | `iddd_agilepm/.../port/adapter/persistence/`, `iddd_identityaccess/.../infrastructure/` | Hexagonal Adapters         |
| `RabbitMQDiscussionStartedListener`, `SlothMQTeamMemberEnablerListener` | `iddd_agilepm/.../port/adapter/messaging/rabbitmq/`, `sloth/`                    | Hexagonal Adapters           |
| `port/adapter/persistence/view/MySQLCalendarProjection`     | `iddd_collaboration/.../port/adapter/persistence/view/`                                                | CQRS Read Model              |
| `CalendarQueryService` — raw JDBC against `tbl_vw_calendar` | `iddd_collaboration/.../application/calendar/CalendarQueryService.java`                                | CQRS Query Side              |
| `EventStoreCalendarRepository` — LevelDB event journal      | `iddd_collaboration/.../port/adapter/persistence/repository/EventStoreCalendarRepository.java`         | Event Sourcing               |
| `EventSourcedRootEntity.apply()` / `when()` dispatch        | `iddd_common/.../domain/model/EventSourcedRootEntity.java`                                             | Event Sourcing               |
| JAX-RS `@Path("/notifications")` REST interface             | `iddd_identityaccess/.../resource/NotificationResource.java`                                           | REST notification log        |

## Quality Attributes

- **Modularity**: Hard compile-time module boundaries enforced by Gradle project references; no cross-context domain model leakage; shared kernel isolated to `iddd_common`.
- **Maintainability**: Ubiquitous Language enforced per bounded context; domain model is independent of framework plumbing; `ApplicationServiceLifeCycle` and `@Transactional` keep transaction management orthogonal to business logic.
- **Evolvability**: Hexagonal ports-and-adapters pattern makes persistence and messaging technology swappable without touching domain logic; three different persistence strategies (LevelDB, Hibernate, EventStore) coexist across contexts demonstrating this property.
- **Auditability**: Full event sourcing in the collaboration context provides a complete audit trail; `NotificationResource` exposes domain-event notification logs via REST for downstream consumers.
- **Testability**: Domain model and application services are decoupled from infrastructure, enabling unit tests without containers; each context has its own test suite with in-memory or test-double persistence (e.g., `HashMapEventStore`).
- **Consistency**: Single-process deployment means within-context operations can use a single transaction; cross-context consistency is eventual, mediated by RabbitMQ exchange listeners.

## Domain

Multi-tenant SaaS collaboration platform ("SaaSOvation") modelling three bounded contexts: Identity & Access Management (`iddd_identityaccess`), Collaboration tools — forums, calendars, discussions (`iddd_collaboration`), and Agile Project Management — products, sprints, backlog (`iddd_agilepm`). The repository is the official companion code for Vaughn Vernon's book *Implementing Domain-Driven Design* (2013).

## Production Context

- Reference implementation only; not production-grade (Java 7 minimum, Spring 2.5.6, Hibernate 3.2 — all end-of-life).
- No CI/CD configuration; no containerized deployment beyond `startContainers.sh` for MySQL and RabbitMQ.
- Requires MySQL schema import and RabbitMQ setup; `iddd_agilepm` has no container dependency (LevelDB only).
- README explicitly notes: "The code is not meant to be a reflection of a production quality work, but rather as a set of reference projects for the book."
