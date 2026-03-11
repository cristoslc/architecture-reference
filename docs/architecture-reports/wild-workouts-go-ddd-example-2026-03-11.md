---
project: "Wild Workouts Go DDD Example"
date: 2026-03-11
scope: application
use-type: reference
primary-language: Go
confidence: 0.95
styles:
  - name: Microservices
    role: primary
    confidence: 0.95
---

# Architecture Analysis: Wild Workouts Go DDD Example

## Metadata

| Field | Value |
|---|---|
| Project | Wild Workouts Go DDD Example |
| Repo | https://github.com/ThreeDotsLabs/wild-workouts-go-ddd-example |
| Date | 2026-03-11 |
| Scope | application |
| Use-type | reference / teaching |
| Primary Language | Go |
| Other Languages | JavaScript (Vue.js frontend), HCL (Terraform) |

## Style Rationales

**Microservices (primary, 0.95):** The application is decomposed into three independently deployable services — `trainer`, `trainings`, and `users` — each with its own `go.mod` module and its own `main.go` entry point. The Go workspace (`go.work`) coordinates them during development but each is built and deployed separately. Infrastructure confirms independent deployment: `terraform/cloud-run.tf` defines five distinct Cloud Run services (`trainer-grpc`, `trainer-http`, `trainings-http`, `users-grpc`, `users-http`). `docker-compose.yml` runs them as separate containers. Services communicate exclusively via synchronous gRPC calls over defined Protobuf contracts (`api/protobuf/trainer.proto`, `api/protobuf/users.proto`); there are no shared databases — each service controls its own Firestore collection. The `trainings` service reaches across service boundaries to both `trainer` and `users` via generated gRPC stubs in `internal/trainings/adapters/trainer_grpc.go` and `users_grpc.go`. A shared `internal/common` library provides cross-cutting concerns (auth, logging, metrics, gRPC/HTTP server helpers, decorator framework) without coupling business logic.

## Design Approach Qualifiers

**DDD (domain-driven design):** Each service is a bounded context with a `domain/` package containing entities with private fields, rich behaviour, and factory-enforced invariants. `internal/trainer/domain/hour/hour.go` encapsulates `hour` and `availability` with no public setters; `hour/availability.go` implements a type-safe value object enum (`Availability` struct) with domain behaviour methods (`ScheduleTraining()`, `CancelTraining()`, `MakeAvailable()`). `internal/trainer/domain/hour/repository.go` defines the repository interface inside the domain layer, applying the Dependency Inversion Principle. The `trainings` bounded context mirrors this with `internal/trainings/domain/training/training.go` — separate constructors for normal creation versus database unmarshalling, enforcing invariants on creation.

**Hexagonal architecture (ports and adapters):** All three modern services (`trainer`, `trainings`) follow the same internal structure: `domain/` (core), `app/` (application/use-case layer), `ports/` (inbound adapters — HTTP and gRPC handlers), `adapters/` (outbound adapters — Firestore repositories, gRPC clients). `internal/trainer/ports/grpc.go` shows a `GrpcServer` that holds an `app.Application` and delegates to command/query handlers; it has no business logic. `internal/trainer/adapters/hour_firestore_repository.go` and `hour_mysql_repository.go` are interchangeable implementations behind the domain repository interface.

**CQRS (command-query responsibility segregation):** Each bounded context structures its application layer into `app/command/` and `app/query/` subdirectories. `app/app.go` in both `trainer` and `trainings` declares an `Application` struct with separate `Commands` and `Queries` fields. The `internal/common/decorator` package provides generic `CommandHandler[C]` and `QueryHandler[Q, R]` interfaces with `ApplyCommandDecorators` and `ApplyQueryDecorators` composition functions that wrap handlers with logging and metrics. Read models are separate from write models.

## Evidence Table

| Evidence | File/Location | Style / Qualifier |
|---|---|---|
| Three independent `go.mod` modules, one per service | `internal/trainer/go.mod`, `internal/trainings/go.mod`, `internal/users/go.mod` | Microservices |
| Five Cloud Run services in Terraform | `terraform/cloud-run.tf` | Microservices |
| Eight containers in Docker Compose (3 services + gRPC/HTTP splits + DB) | `docker-compose.yml` | Microservices |
| gRPC-only inter-service communication via Protobuf contracts | `api/protobuf/trainer.proto`, `api/protobuf/users.proto` | Microservices |
| Outbound gRPC adapters crossing service boundaries | `internal/trainings/adapters/trainer_grpc.go`, `users_grpc.go` | Microservices |
| Shared `internal/common` for cross-cutting concerns only | `internal/common/` | Microservices |
| Private-field entity with factory invariants | `internal/trainer/domain/hour/hour.go` | DDD |
| Type-safe value object enum with domain behaviour | `internal/trainer/domain/hour/availability.go` | DDD |
| Repository interface defined inside domain layer | `internal/trainer/domain/hour/repository.go` | DDD |
| Separate `NewTraining` vs `UnmarshalTrainingFromDatabase` constructors | `internal/trainings/domain/training/training.go` | DDD |
| `ports/` (HTTP + gRPC inbound) and `adapters/` (Firestore + gRPC outbound) in each service | `internal/trainer/ports/`, `internal/trainer/adapters/` | Hexagonal |
| Swappable Firestore, MySQL, and in-memory repository implementations | `internal/trainer/adapters/` | Hexagonal |
| `GrpcServer` holding `app.Application`, no business logic | `internal/trainer/ports/grpc.go` | Hexagonal |
| `Application` struct with `Commands` and `Queries` fields | `internal/trainer/app/app.go`, `internal/trainings/app/app.go` | CQRS |
| Separate `app/command/` and `app/query/` subdirectories | `internal/trainer/app/command/`, `internal/trainer/app/query/` | CQRS |
| Generic `CommandHandler[C]` / `QueryHandler[Q,R]` interfaces with decorator composition | `internal/common/decorator/command.go`, `query.go` | CQRS |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Testability** | Each bounded context has in-memory repository implementations (`hour_memory_repository.go`) enabling unit tests without infrastructure; `adapters/hour_repository_test.go` provides a shared test suite run against all implementations; command handler unit tests in `internal/trainings/app/command/cancel_training_test.go` |
| **Maintainability** | Strict layering — domain has zero infrastructure dependencies; application layer depends only on domain interfaces; ports/adapters depend on the application interface. Changes to persistence (e.g. Firestore to MySQL) require only adapter changes. |
| **Deployability** | Each service deployed independently to Cloud Run; Terraform manages per-service image tags and environment config; Docker Compose mirrors production topology locally |
| **Evolvability** | CQRS separation means read and write paths can evolve independently; repository interface in the domain layer means persistence technology can be swapped without touching business logic; separate Go modules prevent accidental coupling between services |
| **Observability** | Generic decorator framework (`internal/common/decorator/logging.go`, `metrics.go`) wraps every command and query handler with structured logging (logrus) and metrics; `generateActionName` introspects handler types for automatic naming |
| **Security** | Firebase Auth JWT validation in `internal/common/auth/`; gRPC services (trainer-grpc, users-grpc) deployed with `authentication = true` in Cloud Run, requiring signed tokens; HTTP services sit behind authenticated gRPC backends |

## Domain

Fitness scheduling platform. Core bounded contexts: trainer availability management (hour scheduling, availability windows), training session lifecycle (schedule, reschedule, cancel, approval workflows), and user account management (training balance tracking). The `users` service is a simpler CRUD-style service without full DDD structure, while `trainer` and `trainings` are the primary DDD exemplars.

## Production Context

- Explicitly a teaching / reference project accompanying a 14-article series on Three Dots Labs blog covering DDD, Clean Architecture, CQRS, and testing in Go
- Deployed to Google Cloud Run (serverless container platform); Firebase/Firestore for persistence; Terraform for infrastructure as code
- The `users` service retains a flat structure (no `domain/`, `app/`, `ports/`, `adapters/` layers) intentionally, to contrast the refactored DDD services and illustrate incremental adoption
- Go Workspaces (`go.work`) used for local monorepo development while preserving per-service module independence
- OpenAPI specs (`api/openapi/`) generated and used for HTTP contract validation between the Vue.js frontend and services
