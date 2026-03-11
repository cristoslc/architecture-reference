# Architecture Report: ddd-playground

**Date:** 2026-03-11
**Source:** https://github.com/jorge07/ddd-playground
**Classification Model:** claude-sonnet-4-6
**Method:** deep-analysis

---

## Summary

ddd-playground is a PHP/Symfony 3 reference application demonstrating a Wallet API built according to Domain-Driven Design (DDD) principles. It is a textbook implementation of DDD tactical patterns (Aggregates, Value Objects, Domain Events, Repository interfaces) within a deliberately explicit four-layer architecture. Hexagonal Architecture (Ports and Adapters) is applied as the structural mechanism enforcing dependency inversion between the domain core and all external concerns. A Command Bus (Tactician) separates command and query paths, with domain events published asynchronously to RabbitMQ and stored in Elasticsearch — but these are supplementary patterns, not the primary architectural style.

---

## Architecture Styles

### Primary: Domain-Driven Design

The repository is an explicit teaching artifact for DDD tactical patterns. Evidence:

- **Aggregates and Aggregate Roots:** `User` and `AbstractTransaction` both extend `AggregateRoot` (`src/Domain/User/Model/User.php`, `src/Domain/Transaction/Model/AbstractTransaction.php`). Each aggregate encapsulates its own invariants.
- **Value Objects:** Rich value object hierarchy — `UserId`, `WalletId`, `TransactionId`, `Credit`, `Money`, `Currency`, `AuthUser`, `TransactionType`, `TransactionState`. All are self-validating and immutable by convention.
- **Bounded Contexts:** The `src/Domain/` directory is partitioned by domain context: `User`, `Wallet`, `Transaction`, `Payment`, `Money`, `Security`. Each has its own models, events, exceptions, and repository interfaces.
- **Domain Events raised from Aggregates:** `User.create()` calls `$this->raise(new UserWasCreated(...))`. `AbstractTransaction` calls `$this->raise(new TransactionWasCreated(...))`. The `AggregateRoot` base class delegates raising through a static `EventPublisher` singleton.
- **Repository Interfaces in the Domain layer:** `UserRepositoryInterface`, `WalletRepositoryInterface`, `TransactionRepositoryInterface` are defined inside `src/Domain/`, enforcing that the domain dictates its persistence contract.
- **Application Use Cases as Handlers:** The `src/Application/UseCase/` layer contains plain handler classes (e.g. `RegisterUserHandler`, `CreateDepositHandler`) that orchestrate domain objects without containing business logic.
- **README self-identification:** "Wallet API in Symfony following DDD (Domain Driver Design)" and "Code structured in layers as appears in DDD in php book."

### Secondary: Hexagonal Architecture (Ports and Adapters)

The four-layer layout implements Hexagonal Architecture via dependency inversion:

- **Ports (Domain interfaces):** `UserRepositoryInterface`, `WalletRepositoryInterface`, `TransactionRepositoryInterface`, `UserFactoryInterface`, `EventDispatcherInterface` — all live in `src/Domain/`.
- **Adapters (Infrastructure implementations):** `UserRepository`, `WalletRepository`, `TransactionRepository` in `src/Infrastructure/*/Repository/` implement the domain interfaces. `UserFactory` implements `UserFactoryInterface`. `EventDispatcher` implements `EventDispatcherInterface`.
- **Dependency inversion enforced at application boundaries:** `RegisterUserHandler` accepts `UserRepositoryInterface` and `UserFactoryInterface` by constructor injection, never referencing concrete infrastructure classes.
- **UI Adapter:** `src/UI/RestBundle/` exposes the domain via a REST API using FOSRestBundle, acting as an inbound adapter that delegates to the Command Bus.
- **Technology isolation:** Infrastructure bundles (`UserBundle`, `WalletBundle`, etc.) in `src/Infrastructure/` isolate Doctrine ORM, RabbitMQ, and Elasticsearch from the domain core entirely.

### Supporting: Layered Architecture

The README explicitly describes the four-layer structure, and the `src/` tree enforces it:

| Layer | Path | Responsibility |
|---|---|---|
| UI | `src/UI/RestBundle/` | REST controllers, routing, HTTP concerns |
| Application | `src/Application/UseCase/` | Use case orchestration, Command/Query Handlers, DTOs |
| Domain | `src/Domain/` | Business logic, Aggregates, Value Objects, Domain Events, Repository interfaces |
| Infrastructure | `src/Infrastructure/` | Doctrine ORM, RabbitMQ, Elasticsearch, Redis, JWT adapters |

The dependency direction flows strictly inward: UI depends on Application, Application depends on Domain interfaces, Infrastructure implements Domain interfaces.

---

## Evidence: Event-Driven Characteristics (Supplementary)

The project integrates an event pipeline, but this is supplementary to the DDD + Hexagonal core, not the primary organizing principle:

- **Command Bus (Tactician):** `app/config/bundles/bus.yml` defines two buses — `default` (command) and `query`. The command bus pipeline includes: `EventDispatcherMiddleware` → `tactician.middleware.doctrine` → `EventPublisherMiddleware` → `EventStoreMiddleware` → `tactician.middleware.command_handler`.
- **Event publication to RabbitMQ:** `EventPublisherMiddleware` serializes domain events and publishes them to a topic exchange (`events`) after command handling completes.
- **Topic-based routing in RabbitMQ:** `app/config/bundles/rmq.yml` routes `UserWasCreated` to a `user` queue, `TransactionWasCreated` to a `transactions` queue, and all events (`#`) to an `elastic` queue for indexing.
- **Elasticsearch Event Store:** `AsyncElasticEventStore` is a RabbitMQ consumer that reads from the `elastic` queue and writes events to Elasticsearch for query/audit purposes via Kibana.
- **Domain Event Listener pattern:** `OnUserWasCreated` handler in `src/Domain/User/Event/Handler/` is a placeholder for side effects (e.g. sending a welcome email).

These event-driven elements demonstrate DDD domain event patterns and are a natural consequence of the DDD architecture, not a standalone Event-Driven Architecture.

---

## Evidence: What This Is Not

- **Not Microservices:** A single `AppKernel.php` registers all bundles. A single `docker-compose.yml` deploys one application container (fpm) behind one nginx. No inter-service communication, no independent deployability across boundaries.
- **Not CQRS (full):** The project uses separate command and query buses (AbstractBusController has `handle()` and `ask()`), but there are no separate read models or projections. Queries retrieve from the same Doctrine ORM entities as commands. This is a partial CQRS bus separation pattern, not architectural CQRS.
- **Not Modular Monolith:** Organization is by layer (horizontal slicing), not by feature module (vertical slicing). Domains cross-depend inside `src/Domain/` (e.g. `User` references `Wallet`).
- **Not Event Sourcing:** There is an event store in Elasticsearch (via the async consumer), but the system state is not derived from replaying events. The primary state lives in MySQL via Doctrine ORM.

---

## Infrastructure Stack

| Component | Technology |
|---|---|
| Framework | Symfony 3.3 |
| Language | PHP 7.1 |
| ORM | Doctrine ORM 2.5 |
| Database | MySQL 5.7 |
| Cache / Sessions | Redis |
| Message Broker | RabbitMQ 3 (topic exchange) |
| Event Index | Elasticsearch 5.5 + Kibana 5.5 |
| Auth | JWT (LexikJWTAuthenticationBundle) |
| Command Bus | League Tactician |
| API | FOSRestBundle + JMS Serializer + HATEOAS |

---

## Classification

| Field | Value |
|---|---|
| Architecture Styles | Domain-Driven Design, Hexagonal Architecture, Layered |
| Classification Confidence | 0.97 |
| Domain | Finance / Payments |
| Primary Language | PHP |

---

## Key File References

- `src/Domain/Common/ValueObject/AggregateRoot.php` — base aggregate with event raising
- `src/Domain/Common/Event/EventPublisher.php` — static event publisher singleton
- `src/Domain/User/Model/User.php` — canonical Aggregate Root example
- `src/Domain/Transaction/Model/AbstractTransaction.php` — Transaction aggregate with state machine
- `src/Application/UseCase/User/RegisterUserHandler.php` — application layer use case handler
- `src/UI/RestBundle/Controller/AbstractBusController.php` — UI layer delegating to command/query bus
- `src/Infrastructure/CommonBundle/Bus/Middleware/EventPublisherMiddleware.php` — RabbitMQ event publishing
- `src/Infrastructure/CommonBundle/Event/AsyncElasticEventStore.php` — async Elasticsearch consumer
- `app/config/bundles/bus.yml` — command bus middleware pipeline definition
- `app/config/bundles/rmq.yml` — RabbitMQ topic routing for domain events
- `etc/infrastructure/dev/docker-compose.yml` — single-application deployment topology
