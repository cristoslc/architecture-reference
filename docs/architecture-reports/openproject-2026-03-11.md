---
project: "openproject"
date: 2026-03-11
scope: application
use-type: production
primary-language: Ruby
confidence: 0.92
styles:
  - name: Modular Monolith
    role: primary
    confidence: 0.93
  - name: Microkernel
    role: secondary
    confidence: 0.88
  - name: Layered
    role: secondary
    confidence: 0.82
---

# Architecture Analysis: OpenProject

## Metadata

| Field | Value |
|---|---|
| Project | OpenProject |
| Repo | https://github.com/opf/openproject |
| Date | 2026-03-11 |
| Scope | application |
| Use-type | production |
| Primary Language | Ruby |
| Additional Languages | TypeScript, JavaScript, SCSS |
| Domain | Project Management |
| Confidence | 0.92 |

## Classification

**Primary Style:** Modular Monolith
**Secondary Styles:** Microkernel, Layered

## Executive Summary

OpenProject is a Rails 8 web application for project management that organizes its capabilities as 27 independently-loadable Rails engine modules (Gemfile `:opf_plugins` group), each with its own MVC stack, migrations, and gemspec, all sharing a single PostgreSQL database and deployed as one process. A first-class plugin/hook system (Hook, Notifications pub/sub, PatchRegistry) allows modules to extend or override core behavior. A strict horizontal layering of controllers, contracts, services, and workers underlies each module. The frontend is a hybrid Angular + Hotwire (Turbo) SPA served from the same Rails process.

## Architectural Evidence

### Modular Monolith (primary, 0.93)

The defining characteristic is the `modules/` directory containing 27 domain-specific Rails engines: `storages`, `meeting`, `backlogs`, `github_integration`, `gitlab_integration`, `boards`, `bim`, `gantt`, `calendar`, `webhooks`, etc. Each module ships with:

- Its own `app/` tree (models, controllers, views, services, contracts, workers, components)
- Independent `db/migrate/` migrations merged into the shared database at boot
- A `*.gemspec` declaring it as a proper Ruby gem
- Its own `config/routes.rb` prepended to the host application's routes

All modules are declared as path-based gems in `Gemfile.modules` under `group :opf_plugins`, which means they load into the same Ruby process sharing a single ActiveRecord-connected PostgreSQL database. The `ActsAsOpEngine#append_migrations` initializer merges each module's migrations into the host `db/migrate` paths. The `Bundler.require(*Rails.groups(:opf_plugins))` call in `application.rb` pulls all modules into a single monolithic boot. Modules communicate with the core and each other through shared models, the ActiveSupport notifications bus, and direct Ruby method calls — there are no network boundaries.

### Microkernel (secondary, 0.88)

A structured plugin integration system complements the modular structure:

**Hook system:** `OpenProject::Hook` provides a `Listener` / `hook_listeners(hook)` mechanism. Plugins register singleton listener classes that implement named hook methods (e.g., `view_account_login_auth_provider`) to inject behavior at declared extension points. `Hook.call(hook_name, context)` dispatches to all listeners for that hook.

**PatchRegistry:** `OpenProject::Plugins::PatchRegistry.register(target, patch)` enables modules to inject concern modules into core classes via `ActiveSupport.on_load`. The `10-load_patches.rb` initializer fires all registered patches after boot.

**Notifications pub/sub:** `OpenProject::Notifications` wraps `ActiveSupport::Notifications` with a named subscription API. The `subscribe_listeners.rb` initializer wires domain events (`JOURNAL_CREATED`, `MEMBER_CREATED`, `WATCHER_ADDED`, `WORK_PACKAGE_SHARED`, etc.) to background job dispatch, creating a lightweight in-process event bus. Modules can subscribe to core events without modifying core source.

**Events constants:** `OpenProject::Events` defines 30+ named string constants (`PROJECT_CREATED`, `STORAGE_TURNED_UNHEALTHY`, `OAUTH_CLIENT_TOKEN_CREATED`, etc.) as the public event vocabulary modules can publish or subscribe to.

**Access control registration:** Each module calls `OpenProject::AccessControl.map` to declaratively register permissions and project modules, which the core merges into a centralized capability registry.

This plugin core distinguishes OpenProject from a pure Modular Monolith: the core exposes structured extension points rather than expecting modules to subclass or fork core code.

### Layered (secondary, 0.82)

Both the core `app/` and each module's `app/` adhere to a consistent service-oriented layering within Rails MVC:

- **HTTP layer:** Controllers (thin), Grape-based REST API v3 (`lib/api/v3/`), ViewComponents (Primer-based)
- **Contract layer:** `app/contracts/` — `BaseContract` with validation and permission checking; per-resource contracts enforce who may perform which mutations
- **Service layer:** `app/services/` — `BaseContracted` service base class with a well-defined `perform` pipeline: `validate_params` → `before_perform` → `validate_contract` → `after_validate` → `persist` → `after_persist` → `after_perform`. Services return `ServiceResult` value objects.
- **Background layer:** `app/workers/` — GoodJob-backed `ApplicationJob` subclasses for async work (notifications, webhooks, mail, cron jobs)
- **Data layer:** ActiveRecord models with shared schema; `paper_trail` for audit journaling; Statesman for state machines

The strict `BaseContracted` pipeline ensures every mutation passes through authorization and validation before touching the database, a pattern enforced across all 80+ services and all 27 modules.

### Frontend Architecture

The frontend is a hybrid SPA under `frontend/src/`:

- **Angular (core SPA):** `frontend/src/app/` with feature directories (`work-packages`, `boards`, `team-planner`, `bim`, etc.) matching the server-side modules. Uses HAL+JSON hypermedia responses from the API v3 layer.
- **Hotwire / Turbo:** Used for server-rendered progressive enhancement in newer features
- **Stimulus controllers:** `frontend/src/stimulus/` for lightweight JS behavior on server-rendered HTML
- **React:** `frontend/src/react/` — minor presence, likely for specific isolated components

The Angular app is served by a separate `frontend` container in development (`Procfile.dev`), proxied through Rails. In production, the compiled output is served as Rails assets.

### Background Processing and Async Architecture

GoodJob (`good_job ~> 4.13.3`) runs as a separate `worker` process (see `Procfile.dev`). Jobs are PostgreSQL-backed (same database), eliminating the need for a separate message broker. Notable async patterns:

- **Notification workflow:** `Notifications::WorkflowJob` implements `StateMachineJob` to orchestrate a multi-step notification pipeline: immediate in-app notification creation → journal aggregation window wait → aggregated journal event → mail dispatch
- **Webhook delivery:** `WebhookJob` base class with exponential backoff retry (`retry_on Timeout::Error, wait: :polynomially_longer, attempts: 3`), extended by per-resource webhook jobs
- **ActionCable / Redis:** `config/cable.yml` configures Redis-backed ActionCable for production real-time channels; `hocuspocus` extension provides collaborative editing via a separate Node.js process

### What Was Ruled Out

**Microservices:** All modules share one database, one Ruby process, and one Gemfile. The `worker` process shares the same codebase and database. No inter-service HTTP calls between independently deployable units.

**Event-Driven (primary):** The notification pub/sub is in-process (ActiveSupport instrumentation), not a broker-backed async event stream. Events trigger job dispatch rather than replacing request-response communication. The system is event-aware but not event-driven as a primary integration topology.

**Hexagonal Architecture:** No explicit ports/adapters separation. The API layer and controllers are not treated as adapters to domain ports; ActiveRecord models are used directly in services.

**CQRS:** While the journals table provides an append-only audit log, there is no separate read/write model split or event store pattern. Reads and writes share the same ActiveRecord models.

**Domain-Driven Design:** No bounded contexts with separate ubiquitous languages, no aggregate roots, no value objects in the DDD sense. `BaseContract` provides validation but not DDD contract semantics.

## Quality Attributes

| Attribute | Evidence |
|---|---|
| Extensibility | 27 Rails engine modules; Hook/PatchRegistry extension points; Notifications pub/sub; AccessControl.map for permission registration |
| Maintainability | Consistent `BaseContracted` service pipeline; contract-based validation; ViewComponent for UI encapsulation |
| Modularity | Each module ships with own MVC, DB migrations, gemspec; modules are path-local gems |
| Observability | AppSignal APM integration; OpenTelemetry initializer; GoodJob dashboard; structured logging (Lograge); health checks endpoint |
| Security | Doorkeeper OAuth2; Warden authentication; OmniAuth SSO; `rack-attack` rate limiting; `rack-cors`; BCrypt passwords; SSRF protection (`ssrf_protection.rb`) |
| Scalability | Horizontal via Puma multi-process; background jobs scale independently as additional `worker` processes; GoodJob concurrency per-process |
| Auditability | `paper_trail` audit log on all state changes; journal aggregation system with `AGGREGATED_*_JOURNAL_READY` events; journalized concerns on all major models |
| Internationalisation | i18n-js; Crowdin translation workflow; per-module locale files merged at boot |
