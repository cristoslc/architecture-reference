# Architecture Report: go-clean-arch

**Date:** 2026-03-11
**Repo URL:** https://github.com/bxcodec/go-clean-arch
**Classification:** Hexagonal Architecture, Layered
**Confidence:** 0.95
**Model:** claude-sonnet-4-6
**Method:** deep-analysis
**SPEC:** SPEC-031

---

## Summary

`go-clean-arch` is a widely-referenced Go implementation of Clean Architecture (Uncle Bob's variant of Hexagonal Architecture / Ports and Adapters). The project — now at version 4 on the master branch — deliberately structures a simple articles API to demonstrate the dependency rule: all compile-time imports point inward toward the domain core, never outward toward infrastructure. The v4 revision introduced consumer-side interface declarations and the Go `internal/` package boundary, strengthening the Hexagonal pattern. It is a single deployable binary backed by a single MySQL instance, making it an application-scoped reference implementation rather than a production system.

---

## Evidence from Code Exploration

### Repository Structure

```
go-clean-arch/
├── app/
│   └── main.go                          # Composition root / entry point
├── domain/
│   ├── article.go                       # Article entity (no external deps)
│   ├── author.go                        # Author entity (no external deps)
│   └── errors.go                        # Domain error sentinels
├── article/
│   ├── service.go                       # Use case layer + port interfaces
│   ├── service_test.go                  # Pure unit tests via mocks
│   └── mocks/
│       ├── ArticleRepository.go         # Generated mock
│       └── AuthorRepository.go          # Generated mock
├── internal/
│   ├── README.md                        # Explains Go internal visibility
│   ├── repository/
│   │   ├── helper.go                    # Cursor encode/decode utilities
│   │   └── mysql/
│   │       ├── article.go               # MySQL driven adapter
│   │       ├── article_test.go
│   │       ├── author.go                # MySQL driven adapter
│   │       └── author_test.go
│   ├── rest/
│   │   ├── article.go                   # Echo HTTP driving adapter
│   │   ├── article_test.go
│   │   ├── middleware/
│   │   │   ├── cors.go
│   │   │   └── timeout.go
│   │   └── mocks/
│   │       └── ArticleService.go        # Generated mock for handler tests
│   └── workers/
│       └── README.md                    # Placeholder for async workers
├── go.mod
├── Dockerfile
├── compose.yaml
└── README.md
```

### Dependency Graph

| Package | Imports | Role |
|---------|---------|------|
| `domain` | stdlib only | Innermost layer: entities + error sentinels |
| `article` | `domain`, `logrus`, `errgroup` | Use case layer; defines port interfaces consumed here |
| `internal/repository/mysql` | `domain`, `database/sql`, `logrus` | Driven adapter: implements `ArticleRepository` + `AuthorRepository` |
| `internal/rest` | `domain`, `echo/v4`, `logrus`, `validator` | Driving adapter: HTTP handlers; defines `ArticleService` interface |
| `app/main.go` | all of the above | Composition root: wires adapters into use case |

`domain` has zero application-level dependencies. This enforces the dependency rule at source level.

### Port Interfaces (Consumer-Side Declaration — v4 pattern)

**In `article/service.go`** (business logic layer defines what it needs from persistence):
```go
type ArticleRepository interface {
    Fetch(ctx context.Context, cursor string, num int64) (res []domain.Article, nextCursor string, err error)
    GetByID(ctx context.Context, id int64) (domain.Article, error)
    GetByTitle(ctx context.Context, title string) (domain.Article, error)
    Update(ctx context.Context, ar *domain.Article) error
    Store(ctx context.Context, a *domain.Article) error
    Delete(ctx context.Context, id int64) error
}

type AuthorRepository interface {
    GetByID(ctx context.Context, id int64) (domain.Author, error)
}
```

**In `internal/rest/article.go`** (delivery layer defines what it needs from the service):
```go
type ArticleService interface {
    Fetch(ctx context.Context, cursor string, num int64) ([]domain.Article, string, error)
    GetByID(ctx context.Context, id int64) (domain.Article, error)
    Update(ctx context.Context, ar *domain.Article) error
    GetByTitle(ctx context.Context, title string) (domain.Article, error)
    Store(context.Context, *domain.Article) error
    Delete(ctx context.Context, id int64) error
}
```

This is the v4 hallmark: interfaces are declared at the point of consumption, not at the point of implementation. The `article.Service` struct satisfies `ArticleService` structurally without referencing the interface.

### Composition Root (`app/main.go`)

```go
authorRepo := mysqlRepo.NewAuthorRepository(dbConn)
articleRepo := mysqlRepo.NewArticleRepository(dbConn)
svc := article.NewService(articleRepo, authorRepo)
rest.NewArticleHandler(e, svc)
```

Manual dependency injection at the outermost layer. No DI framework; just constructor functions accepting interfaces.

### Go `internal/` Visibility Boundary

The `internal/README.md` explicitly documents that `internal/repository/mysql` and `internal/rest` are hidden from external importers at the compiler level. This is the Go-idiomatic enforcement of the adapter-encapsulation principle.

### Testing Architecture

- `article/service_test.go` uses `mocks.ArticleRepository` and `mocks.AuthorRepository` (generated by mockery). The service is tested with zero MySQL, zero HTTP, zero framework setup.
- `internal/rest/article_test.go` uses `mocks.ArticleService` — the handler is tested without a real service.
- `internal/repository/mysql/article_test.go` uses `go-sqlmock` — database behavior tested without a real MySQL.

Full testing isolation at every layer is a direct consequence of the Hexagonal pattern.

### Single Deployable Unit

`Dockerfile` builds a single Go binary. `compose.yaml` defines two services: the application and MySQL. There is no message broker, no service mesh, no distributed runtime — this is a single-process application.

---

## Architecture Styles Identified

### Primary: Hexagonal Architecture (Ports and Adapters)

**Evidence:**

1. **Consumer-side port interfaces**: `ArticleRepository` and `AuthorRepository` are defined in `article/service.go` (the use-case consumer), not in the `internal/repository/mysql` package (the implementation). `ArticleService` is defined in `internal/rest/article.go` (the driving adapter), not in `article/service.go`. This is the canonical v4 advancement over v1-v3 and is explicitly documented in the README as the primary v4 change.

2. **Structural interface satisfaction**: The `article.Service` type satisfies `internal/rest.ArticleService` without any `implements` declaration — Go's implicit interfaces make the dependency inversion clean and explicit at the same time.

3. **Driving adapters** (inbound ports): `internal/rest/article.go` — Echo HTTP handlers translate HTTP requests into service calls.

4. **Driven adapters** (outbound ports): `internal/repository/mysql/article.go` and `internal/repository/mysql/author.go` — MySQL implementations of repository interfaces defined by the use-case layer.

5. **Composition root**: `app/main.go` is the single place where concrete types are instantiated and wired. All other layers see only interfaces.

6. **Go `internal/` as adapter encapsulation**: The compiler enforces that adapter implementations in `internal/` cannot be imported by external projects — this is a language-level port/adapter boundary.

7. **Testing isolation**: All three layers are unit-testable in isolation, which is only achievable when the Hexagonal boundary is correctly maintained.

### Secondary: Layered

**Evidence:**

1. The README explicitly names four layers: Models Layer, Repository Layer, Usecase Layer, Delivery Layer — this is the canonical Layered taxonomy.

2. The package structure reflects these horizontal layers: `domain/` (Models), `internal/repository/mysql/` (Repository), `article/` (Usecase), `internal/rest/` (Delivery).

3. Dependencies flow strictly downward through the layer stack: Delivery → Usecase → Repository → Domain.

4. The `clean-arch.png` diagram in the repo visualizes the concentric circle model (Clean Architecture) which maps to a Layered interpretation with inward-only dependencies.

**Note on relationship to Hexagonal**: Layered and Hexagonal are not mutually exclusive here. The project's README frames it as "4 domain layers", which is a Layered conceptualization. The implementation details (consumer-side interfaces, adapters, composition root) are Hexagonal. This is the standard Clean Architecture pattern: a Layered mental model expressed through Hexagonal mechanisms.

---

## Quality Attributes

| Attribute | Justification |
|-----------|--------------|
| **Testability** | Every layer has full unit-test isolation: service tests use generated mocks for repositories (no DB), handler tests use a mock service (no business logic), repository tests use `go-sqlmock` (no real MySQL). The Hexagonal boundary makes this structurally guaranteed, not a convention. |
| **Maintainability** | The README explicitly cites Uncle Bob's clean architecture principles. Business logic is confined to `article/service.go`. Adding a new use case does not require touching adapters; swapping a framework requires touching only the adapter package. |
| **Modularity** | The Go `internal/` boundary enforces that adapter implementations are not importable by external projects. The layered structure segments concerns so that each package has a single, clearly bounded responsibility. |
| **Flexibility / Evolvability** | The README states: "Independent of Frameworks", "Independent of Database", "Independent of UI." Because business logic depends only on interfaces, an alternative transport (gRPC, CLI) or alternative database (Postgres, MongoDB) can be added by writing a new adapter without modifying the use-case or domain layers. The workers placeholder (`internal/workers/`) signals planned extensibility. |
| **Learnability** | The project's primary purpose is pedagogical — it is a canonical Go reference implementation cited in the Go community. The progression from v1 to v4 documents the evolution of the pattern, making it a teaching artifact. |

---

## Classification Reasoning

`go-clean-arch` is unambiguously a **Hexagonal Architecture** implementation. The primary classification evidence is structural and explicit:

- Port interfaces are declared on the consuming side (v4 pattern), which is the defining characteristic of Ports and Adapters.
- Adapters are isolated in `internal/` with compiler-enforced visibility restrictions.
- The composition root in `app/main.go` is the only place where concrete types are instantiated.
- Full testing isolation at each layer is only achievable when Hexagonal boundaries are correctly maintained.

The secondary classification of **Layered** is supported by the project's own documentation (four named layers) and the clear horizontal dependency stack. The Layered label here describes the conceptual framing; Hexagonal describes the mechanism. This is the standard Clean Architecture signature.

This is NOT:

- **Microservices**: Single binary, single process, single MySQL instance. Docker Compose runs exactly two containers: app and database.
- **Modular Monolith**: There are no explicit module boundaries enforced by build tooling (no separate `go.mod` per module, no inter-module import restrictions beyond `internal/`). The `internal/` boundary is a visibility rule, not a module boundary in the Modular Monolith sense.
- **Domain-Driven Design**: No aggregates, value objects, domain events, bounded contexts, or rich domain behavior. `Article` and `Author` are anemic data structs. There is no ubiquitous language enforcement.
- **Event-Driven**: No message broker, no event channels, no async messaging patterns (the `internal/workers/` placeholder is empty).
- **CQRS**: No separation of read/write models. `ArticleRepository` is a single interface for both reads and writes.
- **Service-Based**: No distributed service boundaries; single deployable.
