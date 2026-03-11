# Architecture Report: go-backend-clean-architecture

**Date:** 2026-03-11
**Repo URL:** https://github.com/amitshekhariitbhu/go-backend-clean-architecture
**Classification:** Hexagonal Architecture, Layered
**Confidence:** 0.95
**Method:** deep-analysis
**Model:** claude-sonnet-4-6
**SPEC:** SPEC-031

---

## Summary

`go-backend-clean-architecture` is a Go reference implementation of Clean Architecture (Robert C. Martin's variant of Hexagonal Architecture / Ports and Adapters), built on Gin, MongoDB, and JWT. The project explicitly demonstrates how to structure a single Go backend so that the domain core is isolated from all frameworks, databases, and HTTP delivery mechanisms. The dependency rule — all imports point inward toward `domain/` — is the architectural fingerprint and is consistently enforced throughout the codebase. The project deploys as a single binary (one Dockerfile, one `docker-compose` service) against a standalone MongoDB instance: a self-contained monolith, not microservices.

---

## Project Structure

```
go-backend-clean-architecture/
├── cmd/
│   └── main.go                  # Entry point: wires all dependencies, starts Gin
├── bootstrap/
│   ├── app.go                   # Application struct: composes Env + Mongo client
│   ├── database.go              # MongoDB connection lifecycle
│   └── env.go                   # Viper-based .env config loading
├── domain/
│   ├── task.go                  # Task entity + TaskRepository interface + TaskUsecase interface
│   ├── user.go                  # User entity + UserRepository interface
│   ├── login.go                 # LoginRequest/Response DTOs + LoginUsecase interface
│   ├── signup.go                # SignupRequest/Response + SignupUsecase interface
│   ├── profile.go               # ProfileResponse + ProfileUsecase interface
│   ├── refresh_token.go         # RefreshTokenRequest/Response + RefreshTokenUsecase interface
│   ├── jwt_custom.go            # JWT claims structs
│   ├── error_response.go        # Shared error DTO
│   ├── success_response.go      # Shared success DTO
│   └── mocks/                   # mockery-generated mocks for all domain interfaces
├── usecase/
│   ├── task_usecase.go
│   ├── login_usecase.go
│   ├── signup_usecase.go
│   ├── profile_usecase.go
│   ├── refresh_token_usecase.go
│   └── task_usecase_test.go
├── repository/
│   ├── task_repository.go
│   ├── user_repository.go
│   └── user_repository_test.go
├── mongo/
│   ├── mongo.go                 # Abstract Database/Collection/Client/Cursor interfaces + concrete wrappers
│   └── mocks/                   # mockery-generated mocks for mongo interfaces
├── api/
│   ├── controller/              # HTTP handlers (Gin); delegate to usecase interfaces
│   ├── middleware/              # JwtAuthMiddleware
│   └── route/                  # Composition root: wires repository → usecase → controller per route
├── internal/
│   └── tokenutil/               # JWT creation/validation helpers (shared, framework-free)
├── Dockerfile                   # Single-stage Go build → single binary
└── docker-compose.yaml          # Two services: `web` (the app) + `mongodb`
```

---

## Dependency Graph

```
cmd/main.go
  └── bootstrap      (App, Env, MongoDB client)
  └── api/route      (Setup)
        └── api/controller  (imports domain interfaces only)
        └── usecase         (imports domain interfaces only)
        └── repository      (imports domain + mongo interfaces)
        └── mongo           (concrete MongoDB adapter)
              ↑ implements mongo.Database/Collection/Client interfaces

domain/             ← imported by ALL other layers; imports nothing above itself
internal/tokenutil/ ← imported by usecase and middleware; no domain upward imports
```

All compile-time import arrows point **inward toward `domain/`**. The `domain` package has a single external dependency: `go.mongodb.org/mongo-driver/bson/primitive` for ObjectID types in entity structs (a minor coupling to MongoDB's wire type, not to the driver's runtime behavior).

---

## Architecture Style Evidence

### Primary Style: Hexagonal Architecture (Ports and Adapters)

The codebase implements the canonical hexagonal pattern throughout.

**Ports defined in `domain/`:**

```go
// domain/task.go
type TaskRepository interface {
    Create(c context.Context, task *Task) error
    FetchByUserID(c context.Context, userID string) ([]Task, error)
}

type TaskUsecase interface {
    Create(c context.Context, task *Task) error
    FetchByUserID(c context.Context, userID string) ([]Task, error)
}
```

Every business interface (`LoginUsecase`, `SignupUsecase`, `ProfileUsecase`, `RefreshTokenUsecase`, `TaskUsecase`, `UserRepository`, `TaskRepository`) is defined in `domain/` and implemented in outer layers. Domain never imports its implementors.

**Driven adapters (outbound ports — persistence):**

- `repository/task_repository.go`: `NewTaskRepository` returns `domain.TaskRepository`; depends on `mongo.Database` interface, never on the concrete MongoDB driver.
- `repository/user_repository.go`: `NewUserRepository` returns `domain.UserRepository`; same pattern.

**Database adapter layer (`mongo/mongo.go`):**

The `mongo` package defines its own abstract interfaces (`Database`, `Collection`, `Client`, `Cursor`, `SingleResult`) and provides concrete structs (`mongoDatabase`, `mongoCollection`, `mongoClient`, etc.) that wrap `go.mongodb.org/mongo-driver`. Repositories depend only on `mongo.Database`, not on the driver directly. This is a double adapter layer: repositories adapt to domain ports, and `mongo/` adapts to the external driver.

**Driving adapters (inbound ports — HTTP delivery):**

`api/controller/task_controller.go` stores `TaskUsecase domain.TaskUsecase` — an interface field, never a concrete usecase struct. Controllers depend only on domain abstractions:

```go
type TaskController struct {
    TaskUsecase domain.TaskUsecase
}
```

**Composition root (`api/route/`):**

Each route file (`task_route.go`, `login_route.go`, etc.) instantiates and wires the full dependency chain:

```go
// api/route/task_route.go
tr := repository.NewTaskRepository(db, domain.CollectionTask)
tc := &controller.TaskController{
    TaskUsecase: usecase.NewTaskUsecase(tr, timeout),
}
```

This is the standard hexagonal wiring pattern: the composition root assembles concrete adapters and injects them through port interfaces. Use cases and controllers are constructed with injected interface values; neither knows about the other's concrete type.

**Testability evidence:**

- `domain/mocks/` contains mockery-generated mocks for every domain interface (`TaskRepository`, `TaskUsecase`, `UserRepository`, `LoginUsecase`, `ProfileUsecase`, `RefreshTokenUsecase`, `SignupUsecase`).
- `mongo/mocks/` contains mockery-generated mocks for `Client`, `Collection`, `Cursor`, `Database`, `SingleResult`.
- `usecase/task_usecase_test.go` tests business logic using `domain/mocks.TaskRepository` — no real database, no Gin context, no framework wiring.
- `repository/user_repository_test.go` uses `mongo/mocks` to test repository logic without a live MongoDB instance.

This two-level mock pyramid is only achievable in a properly hexagonal system.

### Secondary Style: Layered

The project's horizontal ring structure maps to classic layers:

| Layer | Package(s) | Role |
|---|---|---|
| Presentation | `api/route`, `api/controller`, `api/middleware` | HTTP routing, request binding, JWT guard |
| Application | `usecase/` | Use case orchestration; delegates to repository ports |
| Domain | `domain/` | Entities, port interfaces, shared DTOs |
| Infrastructure | `repository/`, `mongo/`, `bootstrap/` | Persistence adapters, MongoDB driver wrapper, app wiring |

The README explicitly documents: "Architecture Layers of the project: Router → Controller → Usecase → Repository → Domain."

Hexagonal and Layered are complementary here, not competing: Layered describes the ring structure, Hexagonal describes the dependency rule that governs how rings relate (dependencies flow inward, never outward).

---

## Deployment Topology

`docker-compose.yaml` defines exactly two services:
- `web` — the single Go binary built from `cmd/main.go` via `Dockerfile`
- `mongodb` — a standalone `mongo:6.0` container

There is one `go.mod` (single Go module), one `Dockerfile`, one application process. No inter-service communication, no message broker, no API gateway. This is a **single-process monolith** with a dedicated database.

The Dockerfile is single-stage:
```dockerfile
FROM golang:1.19-alpine
RUN go build -o main cmd/main.go
CMD ["/app/main"]
```

---

## Rejected Styles

| Style | Reason for rejection |
|---|---|
| Microservices | Single Go module, single binary, single deployable container; no inter-service communication |
| Modular Monolith | No vertical business module boundaries with isolated schemas; organization is horizontal by technical layer, not by domain capability |
| Domain-Driven Design | No aggregates, value objects, domain events, bounded contexts, or rich domain behavior; domain layer contains anemic structs and interface contracts only |
| CQRS | Single read/write model; no command/query separation at any level |
| Event-Driven | Synchronous request-response throughout; no message broker or async event channels |
| Service-Based | No coarse-grained services with independent deployment; one deployable unit |
| Serverless | Standard long-running HTTP server process |
| Pipeline | No pipeline/filter processing model |
| Microkernel | No plugin system or extensible core |

---

## Quality Attributes

| Attribute | Assessment | Evidence |
|---|---|---|
| **Testability** | High | Two-level mock pyramid (`domain/mocks/`, `mongo/mocks/`); usecase tests run without a database or HTTP framework; complete isolation at both the business and infrastructure boundary |
| **Maintainability** | High | Business logic is centralized in `usecase/`; each package has a single bounded role; new features follow a clear template (add domain interface → implement usecase → implement repository → wire route) |
| **Flexibility / Evolvability** | High | The `mongo/` adapter layer means the database driver can be swapped by replacing only that package; the delivery mechanism (Gin) can be replaced by changing only `api/`; neither change touches `domain/` or `usecase/` |
| **Separation of Concerns** | High | HTTP framework code (`gin`) is confined to `api/`; MongoDB driver is confined to `mongo/`; JWT logic is confined to `internal/tokenutil/`; business rules are confined to `usecase/` |
| **Learnability** | High | The project is explicitly designed as a teaching reference; the layer structure is documented in the README with diagrams; the code is minimal and repetition-free |
| **Deployability** | Medium | Single binary; straightforward Docker build; but no health endpoints, no graceful shutdown, no configuration hot-reload |
| **Scalability** | Low-Medium | Monolithic single process; horizontal scale requires running multiple instances with shared MongoDB; no sharding or caching strategy in the codebase |

---

## Classification Reasoning

This repository is a textbook implementation of **Hexagonal Architecture** (Ports and Adapters), specifically Robert C. Martin's "Clean Architecture" variant applied to Go. The evidence is structural and code-level:

1. **Dependency rule is enforced at the import level**: `domain/` imports only `context` and `go.mongodb.org/mongo-driver/bson/primitive` (entity ID types). No upward imports exist anywhere. Every other package imports `domain/` to obtain interface contracts.

2. **Ports are explicitly defined in the core**: `TaskRepository`, `TaskUsecase`, `UserRepository`, `LoginUsecase`, `SignupUsecase`, `ProfileUsecase`, `RefreshTokenUsecase` are all declared as Go interfaces in `domain/` and implemented outside.

3. **Double adapter layer for the database**: The `mongo/` package provides abstract interfaces (`Database`, `Collection`, `Client`) that the `repository/` layer depends on, with concrete structs wrapping the real driver. This enables mocking the database at the collection level, not just at the repository level.

4. **Composition root in route files**: Each route file instantiates and wires all dependencies by injecting concrete adapters through interface types. This is the standard hexagonal assembly pattern.

5. **Mock-based testing confirms ports-and-adapters discipline**: The `mockery`-generated mocks exist for every port interface, enabling independent unit testing of each hexagonal ring.

The **secondary classification of Layered** is accurate because the project also exhibits explicit horizontal rings (Presentation / Application / Domain / Infrastructure) and the README self-documents them as layers. However, Hexagonal is the stronger and more specific classification because it explains the dependency direction, the interface-based boundaries, and the testability strategy — none of which are features of plain Layered Architecture.

This is a single-deployable Go monolith, not microservices. Its domain layer is anemic (no DDD invariants), not DDD. It has no command/query separation, no event bus, and no plugin mechanism.
