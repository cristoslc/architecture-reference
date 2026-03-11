# canvas-lms — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/instructure/canvas-lms
**Classification:** Modular Monolith + Microkernel
**Confidence:** 0.88

## Summary

Canvas LMS is a large-scale Ruby on Rails application that deploys as a single process (Puma web server + Delayed Job workers) backed by a single PostgreSQL database. Internally it applies two distinct architectural patterns: a **Modular Monolith** strategy enforced through ~55 local gems under `gems/` (boundaries between business domains without physical service separation), and a **Microkernel** plugin architecture through `Canvas::Plugin.register` / `Rails::Engine` that allows discrete feature extensions to be registered, discovered, and swapped at runtime. The classic Rails MVC layering (controllers → models → views, with an additional services/presenters/serializers strata) organises the application internally, but is better understood as the delivery mechanism for the modular monolith rather than an independent architectural style.

## Evidence

### Directory Structure

```
app/
  controllers/          # 220+ HTTP controllers, ApplicationController base
  models/               # 329+ ActiveRecord models (Course, Account, User, Assignment …)
  services/             # 37 service-object directories/files (GradeService, VideoCaptionService …)
  graphql/              # GraphQL schema, types, mutations, loaders, resolvers
  observers/            # LiveEventsObserver — AR observer emitting events to AWS Kinesis
  presenters/           # Presentation-layer extraction
  serializers/          # JSON API response serialisers
  middleware/           # Rack middleware (throttle, session, request context …)
  views/                # ERB templates
gems/
  canvas_security/      # Auth/security domain gem
  canvas_quiz_statistics/ # Quizzing analytics gem
  event_stream/         # DynamoDB/Cassandra event-stream abstraction
  live_events/          # AWS Kinesis event emission client
  lti-advantage/        # LTI 1.3 / Advantage protocol gem
  lti_outbound/         # LTI 1.x outbound launch gem
  incoming_mail_processor/ # Mail processing gem
  canvas_partman/       # PostgreSQL partitioned-table management
  canvas_dynamodb/      # DynamoDB abstraction
  workflow/             # Workflow state-machine gem (used by models)
  … (55 total local gems)
  plugins/
    academic_benchmark/ # Plugin: academic standards importer
    account_reports/    # Plugin: account-level reporting
    moodle_importer/    # Plugin: Moodle migration
    qti_exporter/       # Plugin: QTI quiz format conversion
    respondus_soap_endpoint/ # Plugin: Respondus SOAP integration
    simply_versioned/   # Plugin: model versioning
ui/
  features/             # 234 feature bundles (React/TypeScript per-feature UI)
  shared/               # 230 shared React component libraries
  engine/               # Yarn workspace engine
packages/               # 35 standalone JS packages (canvas-rce, canvas-media …)
lib/
  base/canvas/plugin.rb # Canvas::Plugin registry (microkernel core)
  canvas/live_events.rb # LiveEvents event posting helpers
  api/v1/               # API serialisation concern modules
config/
  routes.rb             # Single routes file; GraphQL + REST + plugin pre_routes
  code_ownership.yml    # Module ownership metadata
  teams/                # Team ownership YAML files
```

### Key Architectural Files

- `config.ru`: Single entry point — `run CanvasRails::Application`. Confirms single-process monolith.
- `docker-compose.yml`: Two services — `web` (Puma) and `jobs` (Delayed Job worker). Both build the same image and share the same PostgreSQL + Redis; no independent service boundaries.
- `lib/base/canvas/plugin.rb`: `Canvas::Plugin.register(id, tag, meta)` — the plugin registry. `Canvas::Plugin.find`, `Canvas::Plugin.all_for_tag` implement microkernel dispatch.
- `Gemfile.d/plugins.rb`: Loads `gems/plugins/*` as Rails Engines; six shipped plugins listed explicitly as `inline_plugins`.
- `gems/plugins/qti_exporter/lib/qti_exporter/engine.rb`: Representative plugin — `Canvas::Plugin.register :qti_converter, :export_system, { worker: "QtiWorker", provides: { qti: Qti::Converter } }` — registers into the `:export_system` extension point.
- `app/observers/live_events_observer.rb`: `LiveEventsObserver < ActiveRecord::Observer` — observes 40+ domain models; on change, calls `Canvas::LiveEvents.post_event_stringified` which enqueues to AWS Kinesis via `gems/live_events/lib/live_events/client.rb`.
- `gems/live_events/lib/live_events/client.rb`: Wraps `Aws::Kinesis::Client`; events stream outward for analytics consumers, not for intra-application routing.
- `config/application.rb`: `config.autoloader = :zeitwerk`; confirms single-application loading model.
- `package.json` workspaces: `gems/plugins/*`, `packages/*`, `ui/engine`, `ui/shared/*` — front-end modules are Yarn workspaces, mirroring the backend local-gem modularisation on the JS side.

### Patterns Found

**Modular Monolith (Primary):**
Canvas manages complexity through internal gem decomposition rather than deployment decomposition. The `gems/` directory holds ~55 Ruby gems that encapsulate bounded domains: security (`canvas_security`), quizzing analytics (`canvas_quiz_statistics`), LTI (`lti-advantage`, `lti_outbound`), event streaming (`event_stream`, `live_events`), database partitioning (`canvas_partman`), workflow state machines (`workflow`), etc. These gems have their own `Gemfile`, `Rakefile`, test suites, and dependency graphs — enforcing module boundaries. The same pattern appears on the front end: 234 `ui/features/` bundles and 230 `ui/shared/` libraries, managed as Yarn workspaces. Code ownership files (`CODEOWNERS`, `config/teams/`) formalise team-level module ownership across both stacks.

**Microkernel / Plugin Architecture (Secondary):**
`Canvas::Plugin` is the explicit extension registry. External capabilities register via `Canvas::Plugin.register(id, tag, meta_hash)` and are retrieved via `Canvas::Plugin.all_for_tag(tag)`. The six bundled Rails Engine plugins (`academic_benchmark`, `account_reports`, `moodle_importer`, `qti_exporter`, `respondus_soap_endpoint`, `simply_versioned`) each declare a `config.to_prepare` block, register with the plugin system, and extend specific tagged extension points (`:export_system`, `:account_report`, etc.). `config/routes.rb` supports plugin pre-routes via `Rails.root.glob("{gems,vendor}/plugins/*/config/pre_routes.rb")`.

**Layered (MVC Delivery Mechanism — not a distinct top-level style):**
The Rails MVC stack (controllers → services → models → views) is the delivery mechanism inside the monolith. It is not an architectural style in its own right here, but the structural form through which the modular monolith operates. The services layer (`app/services/`) adds explicit orchestration objects above models. Presenters and serialisers form a further output layer.

**Event Emission (supplemental, not Event-Driven):**
`LiveEventsObserver` fires events to AWS Kinesis for 40+ domain objects on state change. However, these events are consumed externally (analytics, integrations) and do not drive internal application flow. The application does not react to its own events; this is outbound integration, not an event-driven architecture.

**What was rejected:**
- **Microservices**: Single Dockerfile builds one image; `docker-compose.yml` shows `web` + `jobs` as the same image, single PostgreSQL, single Redis. No service mesh, no independent deployable units.
- **Service-Based**: No coarse-grained remote services. Internal services (`app/services/`) are in-process object-oriented service objects, not remote callable services.
- **Event-Driven**: Kinesis events are outbound analytics integration, not the intra-application communication backbone.
- **Hexagonal Architecture**: No explicit ports/adapters isolation. ActiveRecord models couple directly to the database; controllers couple directly to models.
- **Domain-Driven Design**: No aggregates, value objects, or bounded contexts in the DDD sense. Models use ActiveRecord with table-centric organisation, not domain-model-centric design.
- **CQRS**: Separate read/write pipelines are not used. API V1 includes read helpers alongside write controllers with no segregated query/command paths.

## Architecture Styles

| Style | Confidence | Evidence |
|---|---|---|
| Modular Monolith | High | ~55 local gems with own test suites, 234 UI feature bundles, team code ownership, single deployment unit |
| Microkernel | High | `Canvas::Plugin.register`, 6 Rails Engine plugins, tagged extension points, plugin pre-routes |
| Layered (delivery) | Medium | Classical Rails MVC + services/presenters/serialisers strata |
| Event Emission | Low | `LiveEventsObserver` → Kinesis, but events are outbound-only, not architectural |

## Quality Attributes

- **Maintainability**: High. Local gem decomposition with independent test suites, code ownership files, CODEOWNERS by team, and Zeitwerk autoloading all reduce coupling between domains. 55 gems enforce explicit dependency declarations.
- **Extensibility**: High. The `Canvas::Plugin` microkernel allows new capabilities to be registered without modifying the core. Rails Engine plugins can contribute routes, views, and behaviour through standard extension points.
- **Scalability**: Moderate. Horizontal scaling is achieved by running multiple Puma workers and multiple Delayed Job processes (same image, stateless web tier). Background job scaling is independent of web scaling. PostgreSQL partitioning (`canvas_partman`) supports data volume growth. True independent service scaling is not available without architectural rework.
- **Deployability**: Moderate. Single deployable artefact is simple to reason about but means all modules deploy together. Blue/green or canary deployments require whole-application rollout.
- **Testability**: High. Each local gem has its own RSpec test suite; the `gems/` structure enforces isolation. The overall suite uses RSpec, Selenium for UI, and Jest/Vitest for TypeScript.
- **Interoperability**: High. LTI 1.x and LTI 1.3/Advantage support (`lti_outbound`, `lti-advantage` gems), GraphQL API, REST API v1, SIS import/export, and LIS grade passback make Canvas highly integrable with external tools.
- **Observability**: Moderate. Structured logging, Sentry error tracking (middleware), Datadog APM initialiser, and InstStatsd telemetry are all present. LiveEvents / Kinesis stream provides an audit trail for downstream systems.

## Classification Reasoning

Canvas LMS is classified primarily as a **Modular Monolith** because it is a single deployable Rails application that deliberately manages internal complexity through ~55 local Ruby gems (and mirrored JS Yarn workspaces), each with own dependencies and tests, rather than through physical service boundaries. This is a conscious architectural strategy to prevent the "Big Ball of Mud" at scale, as evidenced by code ownership configuration and team-aligned CODEOWNERS files.

The secondary classification is **Microkernel** because the application ships an explicit plugin registry (`Canvas::Plugin`) and six bundled Rails Engine plugins that register into tagged extension points, with infrastructure to support third-party plugins via `vendor/plugins`. This is not a metaphor — the codebase distinguishes between "core" and "plugin" at the level of Gemfile loading, route injection, and plugin lifecycle management.

The Modular Monolith is the dominant structural pattern (governs how ~55 gems decompose the application); the Microkernel governs the extension/customisation dimension. Together they describe a large, intentionally organised enterprise application that prioritises team autonomy within a shared deployable unit.

Confidence is 0.88 (not 0.95+) because: (1) the boundary between "organisational local gems" and "true module boundaries" is soft in Rails — gems can and do reach across gem boundaries via shared ActiveRecord models; (2) the Kinesis event emission adds an ambient event-driven smell that could strengthen in future; (3) some services directories show signs of a transitional service-layer extraction that is not yet fully consistent.
