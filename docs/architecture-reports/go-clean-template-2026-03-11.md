# Architecture Report: go-clean-template

**Date:** 2026-03-11
**Repo URL:** https://github.com/evrone/go-clean-template
**Classification:** Layered
**Confidence:** 0.95
**Method:** deep-analysis
**Model:** claude-sonnet-4-6

---

## Summary

`go-clean-template` is a production-oriented Go service template implementing Clean Architecture as described by Robert C. Martin. The codebase is organized into four strictly-ordered horizontal layers — entity, usecase, controller, and repo — with dependencies enforced by convention and demonstrated through zero cross-layer imports at the business logic level. The template ships four pluggable transport adapters (REST/Fiber, gRPC, AMQP RPC via RabbitMQ, NATS RPC) to illustrate that the same business logic can be driven by any transport without modification. This is a reference template, not a production application: its business domain is a trivial translation proxy, chosen to keep the example easy to follow while demonstrating the architectural pattern.

---

## Evidence from Code Exploration

### Repository Structure

```
go-clean-template/
├── cmd/app/main.go              # Entry point: config load, hands off to app.Run()
├── config/config.go             # 12-factor config via env vars
├── internal/
│   ├── app/app.go               # Composition root: wires all layers, starts servers
│   ├── app/migrate.go           # DB migration on startup (build-tag-gated)
│   ├── controller/
│   │   ├── amqp_rpc/            # Driving adapter: RabbitMQ RPC
│   │   ├── grpc/                # Driving adapter: gRPC (protobuf)
│   │   ├── nats_rpc/            # Driving adapter: NATS RPC
│   │   └── restapi/             # Driving adapter: REST (Fiber framework)
│   ├── entity/
│   │   ├── translation.go       # Domain entity: Translation struct
│   │   └── translation.history.go
│   ├── repo/
│   │   ├── contracts.go         # Port interfaces: TranslationRepo, TranslationWebAPI
│   │   ├── persistent/          # Driven adapter: PostgreSQL (pgx/v5 + squirrel)
│   │   └── webapi/              # Driven adapter: Google Translate HTTP API
│   └── usecase/
│       ├── contracts.go         # Application port: Translation interface
│       ├── translation/
│       │   └── translation.go   # Business logic: UseCase struct
│       ├── translation_test.go  # Unit tests against mocked interfaces
│       ├── mocks_repo_test.go
│       └── mocks_usecase_test.go
├── pkg/                         # Reusable infrastructure packages
│   ├── grpcserver/
│   ├── httpserver/
│   ├── logger/
│   ├── nats/nats_rpc/
│   ├── postgres/
│   └── rabbitmq/rmq_rpc/
├── migrations/                  # SQL migration files (golang-migrate)
├── integration-test/            # Integration tests in a separate container
├── docs/                        # Swagger + protobuf generated files
├── docker-compose.yml
├── Dockerfile
└── .github/workflows/ci.yml
```

### Dependency Direction (from imports in `internal/app/app.go`)

The composition root imports all layers outward:
- `internal/controller/amqp_rpc`, `internal/controller/grpc`, `internal/controller/nats_rpc`, `internal/controller/restapi` (controllers)
- `internal/repo/persistent`, `internal/repo/webapi` (adapters)
- `internal/usecase/translation` (business logic)

The `internal/usecase/translation/translation.go` imports only `internal/entity` and `internal/repo` (the port interfaces). It does NOT import `internal/controller` or any `pkg` packages. The business logic layer has no outward dependencies — this is the Dependency Rule in practice.

### Layer Interfaces

**Application port** (`internal/usecase/contracts.go`):
```go
type Translation interface {
    Translate(context.Context, entity.Translation) (entity.Translation, error)
    History(context.Context) (entity.TranslationHistory, error)
}
```

**Repository ports** (`internal/repo/contracts.go`):
```go
type TranslationRepo interface {
    Store(context.Context, entity.Translation) error
    GetHistory(context.Context) ([]entity.Translation, error)
}

type TranslationWebAPI interface {
    Translate(entity.Translation) (entity.Translation, error)
}
```

### Business Logic Constructor (dependency injection pattern)

```go
func New(r repo.TranslationRepo, w repo.TranslationWebAPI) *UseCase {
    return &UseCase{repo: r, webAPI: w}
}
```

The `UseCase` struct holds interface references — never concrete types. Concrete implementations (`persistent.TranslationRepo`, `webapi.TranslationWebAPI`) are injected at the composition root.

### Four Transport Adapters (all implement the same `Translation` interface)

Each adapter in `internal/controller/` receives the `usecase.Translation` interface and delegates to it. They are structurally identical in pattern:
- **REST (`restapi/v1/translation.go`)**: Fiber HTTP handlers, Swagger annotations, request validation via `go-playground/validator`.
- **gRPC (`grpc/v1/translation.go`)**: protobuf-generated service registration, delegates to `r.t.History()`.
- **AMQP RPC (`amqp_rpc/v1/translation.go`)**: RabbitMQ Request-Reply over AMQP.
- **NATS RPC (`nats_rpc/v1/translation.go`)**: NATS Request-Reply.

Changing the business logic does not require modifying any controller. Adding a new transport requires only implementing a new controller that calls the existing use case interface.

### Two Repository Adapters

- `internal/repo/persistent/translation_postgres.go` — PostgreSQL via pgx/v5 with squirrel query builder. Implements `TranslationRepo`.
- `internal/repo/webapi/translation_google.go` — Google Translate API via `go-googletrans`. Implements `TranslationWebAPI`.

Swapping either adapter (e.g., replacing PostgreSQL with Redis) requires implementing the port interface and rewiring in `app.go` — the use case is unmodified.

### Infrastructure (`pkg/`)

Cross-cutting packages (HTTP server, gRPC server, logger, PostgreSQL connection pool, NATS/RabbitMQ clients) live in `pkg/` and are decoupled from business logic entirely. They are framework wrappers, not domain code.

### Testing Evidence

- Unit tests in `internal/usecase/translation_test.go` use `go.uber.org/mock`-generated mocks for both port interfaces. The test instantiates `translation.New(repo, webAPI)` with mock adapters — no database, no HTTP.
- CI (`ci.yml`) runs: golangci-lint, yamllint, hadolint, dotenv-linter, dependency CVE scan (Nancy), unit tests with coverage upload to Codecov, integration tests in Docker Compose.
- Integration tests run the full stack in a separate container (`integration-test/`) against a real PostgreSQL instance.

### Observability

- Prometheus metrics integrated via `ansrivas/fiberprometheus` on the REST adapter.
- `/healthz` health check endpoint.
- Structured logging via `rs/zerolog`.

---

## Architecture Styles Identified

### Primary: Layered

**Evidence:**

1. **Four explicit horizontal layers** with defined responsibilities and dependency direction:
   - `entity/` — Domain entities, no dependencies. Inner-most.
   - `usecase/` — Business logic. Depends on `entity/` and `repo/` (port interfaces). Cannot import `controller/`.
   - `repo/` — Port interfaces + adapter implementations. Depends on `entity/`. Implementations live in `persistent/` and `webapi/`.
   - `controller/` — Transport handlers. Depends on `usecase/` (interface) and `entity/`. Outer-most.

2. **Dependency inversion at the repo boundary**: The `usecase` layer defines what it needs from the data layer through interfaces in `repo/contracts.go`. The actual implementations (`persistent/`, `webapi/`) fulfill those contracts. This is the repository pattern — standard in layered architectures — not the full hexagonal pattern.

3. **The README explicitly labels this a "Layered" architecture** with diagrams (`docs/img/layers-1.png`, `docs/img/layers-2.png`) showing the horizontal layer stack. It describes Clean Architecture as its model, which Richards and Ford classify as a variant of Layered architecture with dependency inversion.

4. **Composition root (`app.go`) wires the entire stack** — a standard characteristic of layered systems where the application entry point assembles the layer chain top-to-bottom.

5. **`pkg/` as a cross-cutting layer** — infrastructure utilities available to any layer but containing no business logic, the standard pattern in layered architectures.

6. **No feature-vertical or module-vertical organization** — there is one use case (Translation), and all layers implement it. This is classic horizontal layering, not vertical slicing or modular decomposition.

---

## Quality Attributes

| Attribute | Assessment |
|-----------|-----------|
| **Testability** | High. Use case layer has no framework or infrastructure dependencies. Unit tests mock both port interfaces, running in milliseconds without a database or network. CI enforces unit + integration testing on every PR. |
| **Maintainability** | High. Strict dependency direction makes the impact of changes predictable. Adding a use case means adding to `usecase/contracts.go` and a new file in `usecase/`. Transport details never bleed into business logic. |
| **Extensibility** | High for transports. Adding a fifth transport adapter requires implementing a new controller package and wiring it in `app.go`. The use case is untouched. Swapping the database similarly requires only a new `persistent/` implementation. |
| **Portability** | Moderate. The template is a Go-specific instantiation but the design patterns transfer. The business logic layer has minimal Go-specific dependencies (only stdlib and `entity` package). |
| **Observability** | Moderate. Prometheus metrics and zerolog structured logging are built in. No distributed tracing (no OpenTelemetry instrumentation), which would be expected in a microservice deployment. |
| **Deployability** | High. Single Dockerfile, Docker Compose for local development, CI-enforced linting and testing. Twelve-factor config via environment variables ensures deployment portability. |
| **Modularity** | Moderate. Layer separation is enforced by convention (import discipline) and visible from the directory structure, but not enforced by the Go module system — there is a single `go.mod`. No tooling (e.g., `go-arch-lint`) auto-checks boundaries. |

---

## Classification Reasoning

`go-clean-template` is best classified as **Layered** architecture — specifically the "Clean Architecture" (Uncle Bob) variant of Layered, which applies dependency inversion at the data access boundary.

The defining structural property is the four horizontal layer stack with dependencies flowing consistently inward (controller → usecase → repo-interface ← repo-implementation). The business logic layer is framework-free and testable in isolation. This is the textbook definition of a layered architecture with dependency inversion.

This is NOT:
- **Hexagonal Architecture (primary style)**: True Hexagonal Architecture (Cockburn's original definition) positions the application core at the center with all inbound and outbound ports defined by the core, and treats HTTP, gRPC, AMQP, and persistence as interchangeable adapters of equal standing. While go-clean-template exhibits adapter-like pluggability, the `repo/` package contains both the port interfaces AND the implementations in the same directory tree, and the README's own diagrams show a horizontal layer model, not a hexagonal core-with-ports model. Hexagonal is listed in `architecture_qualifiers` as a design-approach qualifier (`clean-architecture`), not as the primary topology.
- **Microservices**: Single `go.mod`, single `Dockerfile`, single `cmd/app/main.go`. All transports run in one process. This is explicitly a single-service template.
- **Domain-Driven Design**: No aggregates, bounded contexts, value objects, domain events, or ubiquitous language patterns. `entity.Translation` is a plain struct with no behavior. Entities are data carriers, not rich domain models.
- **Modular Monolith**: While there is one binary, there are no module boundaries (Go module isolation or enforced package boundaries). All `internal/` code is one flat package namespace. The separation is layer-based, not feature-module-based.
- **Event-Driven**: AMQP and NATS are used as synchronous RPC transports (Request-Reply pattern), not for asynchronous event streaming. There is no event bus, no publish-subscribe, no event sourcing.
