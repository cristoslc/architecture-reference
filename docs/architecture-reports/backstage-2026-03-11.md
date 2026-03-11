# Architecture Report: Backstage

**Date:** 2026-03-11
**Repository:** https://github.com/backstage/backstage
**Classification:** Microkernel, Modular Monolith
**Confidence:** 0.95
**Model:** claude-sonnet-4-6

---

## Summary

Backstage is Spotify's open-source developer portal platform implemented as a TypeScript/Node.js monorepo. Its dominant architectural style is **Microkernel**: a thin core runtime kernel (the `BackstageBackend` and `createApp` instances) that hosts an extensible ecosystem of independently registered plugins and modules. Each plugin is a fully self-contained unit that communicates exclusively through declared service contracts and extension points — never through direct cross-plugin imports. The secondary style is **Modular Monolith**: despite the microkernel extensibility model, everything is assembled and deployed as a single backend process (by default), with strict inter-package boundaries enforced by naming conventions, a monorepo workspace, and lint rules.

---

## Evidence

### Repository Scale

- `packages/` — 53 core framework packages (plugin API, service factories, catalog model, CLI, frontend/backend defaults, etc.)
- `plugins/` — 154 plugin packages across all domains (catalog, scaffolder, auth, search, events, signals, notifications, kubernetes, techdocs, permission, devtools, gateway, home, org, user-settings, etc.)
- Primary language: TypeScript; also JavaScript, Shell, Python (tooling scripts)

### Structural Layout

```
backstage/
  packages/
    backend-plugin-api/      # Core plugin/module/extension-point contracts
    backend-defaults/        # Default service factory implementations (DI kernel)
    backend-app-api/         # BackstageBackend, BackendInitializer, ServiceRegistry
    frontend-plugin-api/     # Frontend extension/plugin contracts
    core-plugin-api/         # Base utility APIs
    catalog-model/           # Shared entity model (Component, API, System, Domain, etc.)
    catalog-client/          # HTTP client for catalog service
    config/                  # Config schema and loading
    cli/                     # Developer tooling
    ...
  plugins/
    catalog-backend/         # Entity ingestion, processing pipeline, stitching
    scaffolder-backend/      # Template execution engine (NunjucksWorkflowRunner)
    auth-backend/            # OAuth/OIDC providers
    search-backend/          # Collator/decorator/indexer pipeline
    events-backend/          # In-process + distributed event bus
    signals-backend/         # SSE real-time signal relay
    notifications-backend/   # Notification delivery
    permission-backend/      # Policy enforcement
    kubernetes-backend/      # Kubernetes API proxy
    techdocs-backend/        # Documentation generation/serving
    ...
  app-config.yaml            # YAML-based configuration tree
  packages/backend/src/index.ts   # Application entry point
```

---

## Styles Identified

### 1. Microkernel (Primary — strong evidence)

**Evidence:**

The entire system is constructed around a plugin kernel. `packages/backend-plugin-api` defines the three primitive constructs that compose the kernel:

- `createBackendPlugin` — declares a plugin with an ID and an `init` function that receives injected services
- `createBackendModule` — extends an existing plugin through its extension points, initialized before the target plugin
- `createExtensionPoint` — typed interface objects that plugins expose and modules consume to inject behavior

The backend runtime (`packages/backend-app-api/src/wiring/BackendInitializer.ts`, `ServiceRegistry.ts`) acts as the kernel: it resolves service factory dependencies, topologically sorts plugin initialization order, and coordinates startup. Plugins never import each other's code; they communicate exclusively over HTTP (DiscoveryService resolves plugin URLs) or through the EventsService.

Directly from the architecture docs (`docs/backend-system/architecture/04-plugins.md`):
> "Each plugin operates completely independently of all other plugins and they only communicate with each other through network calls... each plugin can be considered a separate microservice."

Extension points are first-class (`docs/backend-system/architecture/05-extension-points.md`):
> "Extension points are used by modules, which are installed in the backend adjacent to plugins. Modules are covered more in-depth in the next section."

The default service implementations (`packages/backend-defaults`) form the kernel's service layer — logger, scheduler, database, cache, auth, discovery, httpRouter, urlReader, lifecycle, permissions — all swappable by installing alternate service factories.

The frontend uses the same pattern via `packages/frontend-plugin-api`: `createFrontendPlugin`, `createExtension`, `createExtensionBlueprint`, and extension overrides compose the UI into a single app extension tree.

The naming convention enforced by ADR-011 makes the layering explicit:
- `@backstage/plugin-<name>` — frontend plugin
- `@backstage/plugin-<name>-backend` — backend plugin
- `@backstage/plugin-<name>-backend-module-<module>` — extension module
- `@backstage/plugin-<name>-node` — shared extension point and node utilities package

**Plugin count as microkernel evidence:** 154 plugin packages, each independently installable, with `backend.add(import('@backstage/plugin-X'))` as the registration idiom (`packages/backend/src/index.ts`).

### 2. Modular Monolith (Secondary — strong evidence)

**Evidence:**

Despite the microkernel extensibility model, the default deployment is a single Node.js process hosting all plugins. The entry point `packages/backend/src/index.ts` calls `createBackend()`, registers ~20 plugins via `backend.add(...)`, and calls `backend.start()`. All plugins share one HTTP listener (Express) routing each plugin under `/api/<pluginId>`.

The httpRouterServiceFactory (`packages/backend-defaults/src/entrypoints/httpRouter/httpRouterServiceFactory.ts`) mounts each plugin at `rootHttpRouter.use('/api/${plugin.getId()}', router)` — all on a single Express server.

The monorepo workspace structure (`"workspaces": ["packages/*", "plugins/*"]` in root `package.json`) enforces module boundaries through package-level dependency declarations rather than runtime service meshes. Circular dependency checking is enforced via `yarn lint:circular-deps` using `madge`.

The docs acknowledge optional splitting: "it is also possible to split this setup into multiple backends" (`docs/backend-system/architecture/02-backends.md`) — but that is a deployment option, not the primary pattern.

### What This Is Not

**Not Microservices:** All plugins run in a single process by default. No container orchestration, no service mesh, no independent deployment pipeline per plugin. The "microservice" characterization in the docs refers to the isolation boundary concept, not the deployment topology.

**Not Event-Driven:** The `EventsService` and event bus (`plugins/events-backend`) are supplementary infrastructure for webhook ingestion and cross-plugin notifications. They are not the primary communication backbone — the dominant integration pattern is synchronous HTTP via DiscoveryService. The catalog processing engine, search indexing pipeline, and scaffolder all operate as synchronous pipelines, not event-sourced workflows.

**Not Pipeline:** While the catalog has a `TaskPipeline` (load/process/stitch) and search has a collator → decorator → indexer `node:stream pipeline`, these are internal implementation details of specific plugins, not the system's overarching communication model.

**Not Hexagonal:** There are no explicit port/adapter boundaries. The extension point system is a plugin customization mechanism, not ports-and-adapters isolation between domain and infrastructure.

**Not Domain-Driven Design:** Entity kinds (Component, API, System, Domain, Group, User, Resource) exist in `packages/catalog-model`, but there are no aggregates, domain events, or value objects in the DDD sense. The primary organizing principle is the plugin boundary, not the domain model.

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| **Extensibility** | The entire system is designed for extensibility: plugins, modules, extension points, and extension overrides are the primary composition mechanism. 154 plugin packages demonstrate this in practice. |
| **Modularity** | Strict package-level boundaries enforced by the monorepo workspace, ADR-011 naming conventions, lint rules, and the architectural constraint that plugins may not import each other's code. |
| **Maintainability** | Declarative plugin registration (`backend.add()`), consistent package naming patterns, per-plugin CHANGELOG and API reports (`report.api.md`), and `@alpha`/`@public` release tag discipline aid long-term maintainability. |
| **Observability** | First-class integration with OpenTelemetry (`@opentelemetry/api` traces in catalog processing, scaffolder), metrics (`MetricsService`), structured logging (`LoggerService`), and an auditing service (`AuditorService`). |
| **Testability** | Dedicated test utilities packages (`backend-test-utils`, `frontend-test-utils`, `backend-dev-utils`), mock service implementations, and a `TestBackend` harness for plugin integration testing. |
| **Scalability** | Optional multi-backend deployment splits plugins across processes; event bus (`DatabaseEventBusStore`) supports distributed deployments with PostgreSQL; `SchedulerService` uses global-scope task locks for distributed scheduling. |
| **Developer Experience** | `packages/cli` provides a full developer toolchain (new, start, build, test, lint, fix commands); `packages/create-app` scaffolds new instances; hot reloading in development. |
| **Security** | `HttpAuthService`, `PermissionsService`, credential barriers on every plugin HTTP router, JWT-based service-to-service auth, configurable CSP/CORS, and auditing are all built into the kernel services. |

---

## Classification Reasoning

Backstage's architecture is definitively **Microkernel** as its primary pattern, with **Modular Monolith** as the secondary deployment and packaging pattern. The microkernel verdict is well-supported by:

1. The explicit architectural decision to isolate plugins from each other and route all cross-plugin communication through service contracts
2. The formal plugin/module/extension-point primitive trio exposed by `backend-plugin-api` and `frontend-plugin-api`
3. The 154 plugin packages that are independently installable and removable
4. The kernel's service registry implementing constructor injection for all plugin dependencies
5. The official documentation characterizing each plugin as "a separate microservice" with no direct code coupling to peers

The modular monolith classification applies because the standard deployment is a single backend process, and the monorepo enforces strict intra-process module boundaries through package-level APIs rather than network contracts. The system is not truly microservices (no independent deployability by default), not event-driven (events are supplementary), and not hexagonal (no ports/adapters boundary pattern).

Confidence: **0.95** — architectural intent is unambiguous from both code structure and primary documentation.
