# Architecture Report: kotlin-fullstack-sample

**Date:** 2026-03-11
**Model:** claude-sonnet-4-6
**Method:** deep-analysis
**Source:** https://github.com/Kotlin/kotlin-fullstack-sample
**SPEC:** SPEC-031

---

## Summary

kotlin-fullstack-sample (branded "Thinkter") is an official JetBrains reference application demonstrating how to build a full-stack web application entirely in Kotlin. The backend runs on the JVM using Ktor + Jetty, and the frontend compiles Kotlin/JS to JavaScript and renders using React. It implements a minimal microblogging application.

**Primary style:** Layered
**Secondary style:** Service-Based
**Confidence:** 0.87

---

## Deployment Topology (Service-Based)

The project is a Gradle multi-project build with exactly two subprojects:

```
settings.gradle:
  include "backend", "frontend"
```

| Subproject | Runtime | Role |
|------------|---------|------|
| `backend` | JVM / Jetty on port 9090 | Ktor HTTP server, REST API, H2 database |
| `frontend` | Webpack dev server on port 8080 | Kotlin/JS SPA compiled to JavaScript |

The frontend webpack configuration (`frontend/build.gradle`) proxies API calls to the backend:

```groovy
webpackBundle {
    publicPath = "/frontend/"
    port = 8080
    proxyUrl = "http://localhost:9090"
}
```

This is a coarse-grained **Service-Based** two-service layout: backend owns the database exclusively, and the frontend communicates with it exclusively over synchronous HTTP. There is no shared module, no message broker, and no independent data store per service.

### Evidence against Microservices

- Only two services — no domain-decomposed fleet of fine-grained services
- Backend and frontend work across the same domain (thoughts/users); this is a presentation/logic split, not a bounded-context decomposition
- No service mesh, no event bus, no circuit-breaker infrastructure
- Communication is synchronous HTTP only (`Rpc.kt` uses `window.fetch`)

---

## Backend Internal Structure (Layered)

Within the `backend/` module, the code is organized into clear horizontal layers by technical responsibility:

```
backend/src/org/jetbrains/demo/thinkter/
├── Application.kt          # Entry point: wires features and routing
├── Locations.kt            # URL-to-class location definitions (Ktor @location)
├── Index.kt                # Route handler: home / poll endpoints
├── Login.kt                # Route handler: login / logout
├── Register.kt             # Route handler: user registration
├── PostThought.kt          # Route handler: thought posting
├── Delete.kt               # Route handler: thought deletion
├── UserPage.kt             # Route handler: user page
├── ViewThought.kt          # Route handler: view single thought
├── Utilities.kt            # Cross-cutting: hashing, security codes, redirects
├── ApplicationPage.kt      # Server-side HTML scaffold (Ktor HTML builder)
├── dao/
│   ├── ThinkterStorage.kt  # Data access abstraction: interface defining all operations
│   ├── ThinkterDatabase.kt # Data access implementation: Squash ORM over H2
│   ├── Users.kt            # Table definition: users schema
│   └── Thoughts.kt         # Table definition: thoughts schema
└── model/
    ├── atoms.kt            # Domain entities: Thought, User
    └── responses.kt        # Response DTOs: IndexResponse, LoginResponse, etc.
```

### Layer breakdown

**Presentation / API Layer** (`*.kt` route handlers at package root)

Ktor route functions (`Route.index`, `Route.login`, `Route.register`, `Route.postThought`, etc.) handle HTTP request routing, session management, input validation, and response serialization. Each function receives a `ThinkterStorage` instance injected from `Application.kt`; no HTTP concern leaks downward.

**Data Access Layer** (`dao/`)

`ThinkterStorage` is an interface declaring all data operations:

```kotlin
interface ThinkterStorage : Closeable {
    fun countReplies(id: Int): Int
    fun createThought(user: String, text: String, replyTo: Int? = null, date: LocalDateTime): Int
    fun deleteThought(id: Int)
    fun getThought(id: Int): Thought
    fun userThoughts(userId: String): List<Int>
    fun user(userId: String, hash: String? = null): User?
    fun userByEmail(email: String): User?
    fun createUser(user: User)
    fun top(count: Long): List<Int>
    fun latest(count: Long): List<Int>
}
```

`ThinkterDatabase` implements this interface using the Squash ORM against an embedded H2 database. Schema tables (`Users`, `Thoughts`) are defined as `TableDefinition` objects in the `dao/` package.

**Model / DTO Layer** (`model/`)

Data classes `Thought` and `User` (domain entities) and response DTOs (`IndexResponse`, `LoginResponse`, `PostThoughtToken`, etc.) are defined here. These types flow upward to the presentation layer and are serialized to JSON via Gson.

### Layer dependency rule

Dependencies flow strictly downward: route handlers → storage interface → database implementation → table definitions. No upward dependencies observed. The storage interface decouples route handlers from the ORM implementation — it would be possible to swap H2/Squash for another backend without touching route handlers.

---

## Frontend Internal Structure (Component-Based within Service-Based)

The `frontend/` module is a Kotlin/JS SPA using custom React bindings located in `org/jetbrains/react/`:

```
frontend/src/org/jetbrains/demo/thinkter/
├── Application.kt           # Root ReactDOMComponent, view router, session bootstrap
├── HomeView.kt              # Home page component: top/latest thoughts + polling
├── Login.kt                 # Login form component
├── Register.kt              # Registration form component
├── NewThoughtComponent.kt   # Compose-new-thought form
├── NavBarComponent.kt       # Navigation sidebar
├── ThoughtsListComponent.kt # List renderer for thought collections
├── ViewThoughtComponent.kt  # Single thought detail view + reply
├── Polling.kt               # Client-side polling timer (20s interval)
├── ReactMarkdown.kt         # Wrapper for react-markdown npm package
├── Rpc.kt                   # HTTP client layer: all suspend funs for backend calls
└── model/                   # Duplicated: Thought, User, response DTOs (mirroring backend)
```

The frontend is a component tree rooted at `Application`, which manages a `MainView` enum as application state:

```kotlin
enum class MainView {
    Loading, Register, Login, User, PostThought, Thought, Home
}
```

`Application` renders the appropriate component based on the current `MainView`. No client-side router library is used — state management is entirely via React `setState`.

**RPC layer** (`Rpc.kt`)

All backend communication is encapsulated in `Rpc.kt` as top-level `suspend` functions using Kotlin coroutines and the browser Fetch API. Functions like `index()`, `login()`, `postThought()`, `pollFromLastTime()` all call `requestAndParseResult`, which serializes responses from dynamic JSON manually (no code-gen or shared serialization contract with the backend).

**Model duplication**

The `model/atoms.kt` and `model/responses.kt` files are **identical in both subprojects** — they are duplicated source files, not shared via a common Kotlin module. This is a deliberate simplification in the sample to avoid requiring a third `shared` subproject.

---

## Key Architectural Characteristics

| Attribute | Finding |
|-----------|---------|
| Communication | Synchronous HTTP REST; polling via `/poll` endpoint (20s client timer) |
| Database | Embedded H2 (in-memory by default, file-backed via config); single writer (backend) |
| Session management | Server-side cookie sessions with HMAC-SHA1 authentication |
| Security pattern | Token + timestamp HMAC codes for write operations (CSRF mitigation) |
| Concurrency model | Kotlin coroutines (experimental) in both frontend (`async`/`launch`) and backend |
| Build system | Gradle multi-project; Kotlin 1.1.51 (deprecated toolchain) |
| Frontend framework | React via hand-written Kotlin/JS wrappers (no official kotlin-react library) |
| Testing | Backend has test source sets; Ktor test host available as dep; no test files found in clone |

---

## Quality Attributes

- **Simplicity** — deliberately minimal; the entire backend is ~15 Kotlin files; easy to follow end-to-end
- **Educational value** — demonstrates Kotlin multiplatform approach (JVM backend + JS frontend in one language and build)
- **Maintainability** — clear layer separation in backend makes it easy to trace a request from HTTP handler to database and back
- **Portability** — H2 embedded database requires no external infrastructure; runs with a single `./gradlew backend:run`
- **Testability** — `ThinkterStorage` interface enables mocking the DAO for unit tests; Ktor test host is configured as a dependency
- **Security** — cookie sessions use HMAC-SHA1 message authentication; write operations require time-scoped HMAC tokens

---

## Evidence Against Alternative Styles

**Not Modular Monolith:** No enforced internal module boundaries. The backend `dao/`, `model/`, and handler packages are organizational, not architectural enforcement boundaries. There is no ArchUnit, module-info.java, or Gradle module isolation.

**Not Microservices:** Only two coarse-grained services (frontend/backend split is a presentation concern, not domain decomposition). Both services operate on the same domain model (thoughts + users). No independent data stores.

**Not Event-Driven:** All communication is synchronous request/response. The polling mechanism (`Polling.kt`) is client-pull, not server-push or event-driven. No message broker.

**Not Hexagonal / Ports-and-Adapters:** The `ThinkterStorage` interface is a DAO abstraction, not a hexagonal port. There is no inbound port (the Ktor routing functions are framework-coupled directly). The pattern is repository abstraction within Layered, not Hexagonal.

---

## Classification Reasoning

The dominant topology is **Layered**: the backend exhibits three clear horizontal layers (presentation/API handlers → storage interface → database implementation + table definitions) with unidirectional downward dependencies. The `ThinkterStorage` interface as a clean seam between the presentation and persistence layers is the strongest structural signal.

The **Service-Based** secondary classification applies at the deployment level: two coarse-grained services sharing a single database, communicating over HTTP. At two services, this is the minimum viable instance of the Service-Based topology. The pattern matches Richards & Ford's Service-Based definition (coarse-grained services, shared database, synchronous HTTP communication) more accurately than Client-Server (which is not a canonical style in this taxonomy) or Microservices (which requires domain-bounded data ownership and fine granularity).

The classification is essentially identical to the prior entry (classification_model: openrouter/z-ai/glm-5, 0.82) with refined confidence and additional frontend analysis. The fundamental characterization — Layered primary, Service-Based secondary — is correct and confirmed.
