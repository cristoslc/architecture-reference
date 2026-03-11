---
project: "PostgREST"
date: 2026-03-11
scope: service
use-type: production
primary-language: Haskell
confidence: 0.94
styles:
  - name: Layered
    role: primary
    confidence: 0.94
  - name: Pipeline
    role: secondary
    confidence: 0.85
---

# Architecture Analysis: PostgREST

## Summary

PostgREST is a single-binary Haskell web server that automatically generates a RESTful API from a PostgreSQL database schema. It is a compact, purpose-built service with a strict horizontal layering of concerns (HTTP → Auth → Request Parsing → Planning → Query Building → Transaction Execution → Response) and an explicit per-request processing pipeline through those layers. There are no plugins, no microservices, and no event bus — just a cleanly separated stack with PostgreSQL as the authoritative source of truth for both data and schema.

## Architecture Styles

### Primary: Layered (0.94)

The codebase is organized as a set of horizontal layers, each consuming the output of the one below it and exposing a clean interface upward. This is the dominant structural pattern at the module level:

| Layer | Module(s) |
|---|---|
| HTTP / Transport | `App.hs`, `Network.hs`, Warp integration |
| Middleware chain | `Auth.hs`, `Cors.hs`, `Logger.hs` |
| Request parsing | `ApiRequest.hs`, `ApiRequest/{Payload,QueryParams,Preferences,Types}.hs` |
| Planning / IR | `Plan.hs`, `Plan/{ReadPlan,MutatePlan,CallPlan,Types,Negotiate}.hs` |
| Query building | `Query.hs`, `Query/{PreQuery,QueryBuilder,SqlFragment,Statements}.hs` |
| Transaction execution | `MainTx.hs` |
| Response rendering | `Response.hs`, `Response/{OpenAPI,GucHeader,Performance}.hs` |
| Schema knowledge | `SchemaCache.hs`, `SchemaCache/{Identifiers,Relationship,Representations,Routine,Table}.hs` |
| Cross-cutting | `Config.hs`, `AppState.hs`, `Observation.hs`, `Error.hs`, `Metrics.hs` |

Each layer has a defined responsibility and a unidirectional dependency rule: layers consume downward, not upward. The `Plan` layer, for example, takes `ApiRequest` and `SchemaCache` as inputs and emits an `ActionPlan` — it never reaches back into HTTP concerns. The `Query` layer converts an `ActionPlan` into SQL snippets without knowing how the response will be rendered.

The WAI middleware composition in `App.hs` makes the layer structure explicit and ordered:

```haskell
postgrest logLevel appState connWorker =
  traceHeaderMiddleware appState .
  Cors.middleware appState .
  Auth.middleware appState .
  Logger.middleware logLevel Auth.getRole $
    \req respond -> ...
```

### Secondary: Pipeline (0.85)

Within the Layered structure, every HTTP request flows through a strict five-stage processing pipeline that transforms a raw WAI `Request` into a final `Wai.Response`:

1. **Parse** — `ApiRequest.userApiRequest` decodes the HTTP request into a domain `ApiRequest`
2. **Plan** — `Plan.actionPlan` converts `ApiRequest` + `SchemaCache` into an `ActionPlan` (an intermediate representation)
3. **Build** — `Query.mainQuery` translates `ActionPlan` into a `MainQuery` (SQL snippet bundle)
4. **Execute** — `MainTx.mainTx` runs the transaction against the PostgreSQL pool via hasql
5. **Render** — `Response.actionResponse` converts the `DbResult` into a `PgrstResponse`

This is made concrete in `postgrestResponse` in `App.hs`:

```haskell
(parseTime, apiReq) <- withTiming $ liftEither ... $ ApiRequest.userApiRequest ...
(planTime,  plan)   <- withTiming $ liftEither $ Plan.actionPlan ...
let mainQ = Query.mainQuery plan ...
    tx    = MainTx.mainTx mainQ ...
(txTime,   txResult) <- withTiming $ ...
(respTime, resp)     <- withTiming $ ...
```

Timing is instrumented at each stage gate for the `Server-Timing` header, reinforcing that these are discrete, sequential pipeline stages. An error at any stage short-circuits via `ExceptT Error IO`.

## Structural Evidence

### Single deployment unit

PostgREST ships as a single executable (`main/Main.hs` → one Cabal `executable` stanza). All modules compile into one library (`postgrest.cabal` `library` stanza with ~55 exposed modules). There is no inter-service communication, no message bus, and no distributed coordination.

### Admin server as a lightweight sidecar

`Admin.hs` launches a second Warp server on a separate socket for `/live` and `/ready` health endpoints, plus Prometheus metrics. It shares `AppState` directly via Haskell STM references — this is a thread inside the same process, not a separate service.

### Schema cache as the knowledge layer

`SchemaCache` queries PostgreSQL system catalogs at startup (and on LISTEN notification reload) to build an in-memory index of tables, views, functions, relationships, and data representations. It is the architectural foundation that enables the planning layer to infer JOIN trees and relationship traversal without inspecting user data. The schema cache is the only stateful component — everything else is pure per-request computation.

### LISTEN/NOTIFY for hot reload

`Listener.hs` subscribes to a PostgreSQL channel via `hasql-notifications`. Notifications trigger `AppState.schemaCacheLoader` to refresh the schema cache without restarting the process. This is a narrow operational mechanism (cache invalidation), not an event-driven data flow — it does not change the request-handling architecture.

### Observation / telemetry abstraction

`Observation.hs` defines a single `ObservationHandler` type that centralises all logging and metrics. Components call `observer (SomeObservation ...)` — the handler decides what to log and what to expose as a Prometheus counter. This is a cross-cutting concern, not a separate architectural style.

### What was rejected

**Not Hexagonal / Ports-and-Adapters:** There is no explicit "ports" abstraction for the database adapter or the HTTP driver. PostgREST uses `hasql` and Warp directly; there are no swappable adapter interfaces defined in the codebase.

**Not Microkernel:** There is no plugin registry, no extension point contract, and no dynamically loaded capabilities. The feature set is fixed at compile time.

**Not Modular Monolith:** While the module organisation is clean, the modules do not represent independently deployable or independently releasable vertical slices. They are horizontal layers of a single application.

**Not Event-Driven:** LISTEN/NOTIFY is limited to schema cache reload. There is no event broker, no event sourcing, and no asynchronous data flow between components.

**Not CQRS:** Read and write paths are unified through the same `Plan → Query → MainTx → Response` pipeline with branching via `WrappedReadPlan`, `MutateReadPlan`, and `CallReadPlan` — but this is routing inside a unified pipeline, not separate read/write models.

## Quality Attributes

- **Simplicity:** Single binary, ~55 modules, no external dependencies beyond PostgreSQL. The entire feature surface is a mapping of HTTP semantics to SQL.
- **Performance:** Compiled Haskell via Warp; connection pooling via `hasql-pool`; JSON serialization delegated to PostgreSQL itself; JWT caching in `Auth/JwtCache.hs`; schema cache avoids per-request catalog queries.
- **Correctness:** Schema cache ensures plan-time validation of all resource embeddings, column names, and function signatures before SQL is sent. Errors surface with structured `PGRST` error codes.
- **Observability:** Prometheus metrics via `prometheus-client`; structured `Server-Timing` headers per pipeline stage; centralized `Observation` handler for logging and metrics; configurable log level and query logging.
- **Security:** JWT middleware runs before any request reaches the application logic; PostgreSQL row-level security and role-based access are the primary authorization mechanism; CORS middleware is configurable.
- **Operability:** LISTEN/NOTIFY-driven schema cache hot reload; `/live` and `/ready` health endpoints; configurable via file, environment, and in-database settings (`config.database`).
