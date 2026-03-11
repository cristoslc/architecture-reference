# discourse — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/discourse/discourse
**Classification:** Microkernel + Layered
**Confidence:** 0.93

## Summary

Discourse is a Ruby on Rails community platform whose defining architectural characteristic is a Microkernel (Plugin) system: a stable core "kernel" exposes ~172 named registration hooks through which 43 bundled plugins (chat, AI, polls, calendar, etc.) inject routes, models, serializers, assets, and behaviour without touching core source. The Microkernel rests on a classic Layered Rails foundation (Controllers → Services → Models → Serializers), augmented by a large Sidekiq background-job subsystem and a real-time MessageBus layer for live updates.

## Evidence

### Directory Structure

```
app/
  controllers/          # HTTP request handling (86+ controllers, admin/ sub-tree)
  services/             # Business logic (76 service objects, Service::Base pipeline)
  models/               # ActiveRecord domain models (279 files)
  serializers/          # API response formatting (219 files)
  jobs/
    regular/            # Async Sidekiq jobs (90 files, e.g. emit_web_hook_event.rb)
    scheduled/          # Cron-style jobs (96 files)
    onceoff/            # One-time migration jobs (30 files)
  queries/              # Query objects (reports sub-tree)
  mailers/
  views/
lib/
  plugin/
    instance.rb         # 1,662-line Plugin::Instance — 172+ registration methods
  discourse_event.rb    # DiscourseEvent: publish/subscribe hub for plugin hooks
  discourse_plugin_registry.rb  # Central registry with define_register / define_filtered_register
config/
  application.rb        # Activates plugins via Discourse.activate_plugins!
  routes.rb             # 1,917-line monolithic route file
  sidekiq.yml
plugins/
  chat/                 # Full sub-app: controllers, services, models, jobs, serializers
  discourse-ai/         # AI assistant plugin with own service layer
  poll/, automation/,
  discourse-calendar/,  # 40 more self-contained feature plugins
  … (43 total bundled)
frontend/
  discourse/            # Ember.js SPA (components, routes, models, services, adapters)
  discourse-plugins/    # Per-plugin JS loaded dynamically
```

### Key Architectural Files

- `lib/plugin/instance.rb`: `Plugin::Instance` class — 1,662 lines, 172+ methods covering `register_asset`, `add_to_serializer`, `add_admin_route`, `register_modifier`, `after_initialize`, `reloadable_patch`, and more. This is the plugin API surface.
- `lib/discourse_plugin_registry.rb`: `define_register` and `define_filtered_register` class macros generate typed, plugin-aware registers. Filtered registers honour `plugin.enabled?` at lookup time, providing clean enable/disable semantics.
- `lib/discourse_event.rb`: Lightweight pub/sub (`DiscourseEvent.on(:event_name) { }` / `DiscourseEvent.trigger(:event_name, ...)`). Core fires 102+ distinct events; plugins subscribe to inject cross-cutting logic.
- `app/services/flags/create_flag.rb`: Illustrates `Service::Base` pipeline — `policy`, `params`, `model`, `transaction`, `step` DSL providing a declarative, testable service layer distinct from controllers and models.
- `config/application.rb`: Plugin bootstrap sequence — loads `register_provider.rb` from each plugin directory, then calls `Discourse.activate_plugins!`, establishing the kernel→plugin initialization contract.
- `plugins/chat/plugin.rb`: Canonical large plugin — declares `enabled_site_setting :chat_enabled`, registers assets, routes (`add_admin_route`), then inside `after_initialize` uses `reloadable_patch` to prepend `Chat::GuardianExtensions`, `Chat::UserNotificationsExtension`, etc. into core classes.

### Patterns Found

**Microkernel (Plugin):** The primary organizing principle. The core application is intentionally minimal with respect to features; 43 bundled plugins plus 85 official external plugins add all domain-specific functionality through a versioned, named hook API. The kernel fires events; plugins subscribe. The kernel exposes registers; plugins populate them. Enable/disable is runtime — no rebuild required. The plugin directory structure mirrors the core (`app/`, `lib/`, `config/`, `db/`) but is activated lazily.

**Layered (Rails MVC + Service Layer):** The core Rails skeleton is a clear four-layer stack: HTTP controllers handle routing and auth, a service layer (`Service::Base` DSL, 76 service objects) owns business logic, ActiveRecord models manage persistence (279 models, 1,655 migration files), and serializers format API responses (219 files). This is the secondary structural style — the rails on which the plugin system runs.

**Event-Driven (supporting mechanism):** `DiscourseEvent` provides an in-process pub/sub bus (102+ trigger sites in app/). `MessageBus` provides WebSocket/long-poll real-time delivery to browsers (116 publish sites in app/). Sidekiq background workers (216 jobs) handle async processing. These are implementation mechanisms rather than a primary architectural style — they operate within and between layers rather than replacing the layered structure.

**Webhook integration (outbound):** `WebHook` + `WebHookEvent` models and the `EmitWebHookEvent` Sidekiq job provide outbound event delivery to external systems. Well-defined but supplementary.

## Architecture Styles Identified

### Microkernel (Primary)

The defining characteristic of Discourse is the plugin system, not its use of Rails. A thin, stable core exposes a rich extension surface (~172 registration hooks) through `Plugin::Instance`, `DiscoursePluginRegistry`, and `DiscourseEvent`. Major features — chat, AI, polls, calendar, gamification, data explorer — live entirely in plugins and are toggled by site settings without code changes. The plugin API is formally versioned and documented. New plugins can add routes, models, database migrations, admin UI, serializer fields, and JS components without touching core files. This is a textbook Microkernel architecture where the core is a stable platform and plugins are the primary delivery vehicle for domain functionality.

### Layered (Secondary)

The core Rails application follows a strict four-layer hierarchy: controllers (request/response boundary), services (business logic with a pipeline DSL), models (data and persistence), serializers (API contract). Each layer has a well-defined responsibility. The service layer is particularly mature — the `Service::Base` pipeline (`policy`, `params`, `model`, `step`, `transaction`) enforces explicit data flow and guards through each operation. The layered structure provides the internal organization of both the core kernel and individual plugins, which each replicate the same layer hierarchy.

### Event-Driven (Supporting)

`DiscourseEvent` (in-process), `MessageBus` (real-time browser delivery), and Sidekiq (background job queuing) collectively provide event-driven capabilities as implementation mechanisms. They do not define the system's primary decomposition — they enable loose coupling and async execution within the layered and microkernel structure.

## Quality Attributes

- **Extensibility:** The dominant quality driver. The entire plugin system exists to allow extending Discourse without forking. 172 named hooks, runtime enable/disable, and standardized plugin layouts make third-party extension the primary use case. New plugins can be added with zero core changes.
- **Maintainability:** The `Service::Base` pipeline DSL produces small, declarative, single-responsibility service objects. Clear layer separation (controller/service/model/serializer) in core and every plugin makes the codebase navigable. The plugin boundary also limits the blast radius of changes — core modifications do not break plugins unless the hook contract changes.
- **Scalability:** Sidekiq with dedicated queues (default, critical, low, ultra_low) enables horizontal worker scaling. Redis is used for caching, job queuing, and rate limiting. Pitchfork/Puma multi-process server deployment supports high concurrency. Database connection pooling and query optimization are managed at the model layer.
- **Reliability:** Sidekiq provides persistent, retryable async job execution. Rails Failover gems (`rails_failover/active_record`, `rails_failover/redis`) provide automatic database and Redis failover. Background jobs include retry logic and error tracking integration.
- **Modifiability:** Site settings and plugin enable/disable flags allow runtime feature toggling. The plugin's `enabled_site_setting` declaration ties plugin activation to an admin-configurable flag, enabling A/B deployment without code deploys.
- **Security:** Guardian-based authorization is threaded through controllers, services, and serializers. Plugins extend Guardian via prepend rather than bypassing it. Admin actions are logged through `StaffActionLogger`. Rate limiting is applied at the model layer via `RateLimiter`.
- **Observability:** Sidekiq Web UI, structured logging, and webhook event delivery provide operational visibility. The admin dashboard aggregates stats from background report jobs. Logstash integration is available.

## Classification Reasoning

The decisive classification question for Discourse is whether the plugin system rises to the level of a primary architectural style (Microkernel) or is simply an add-on mechanism on top of a Layered Rails app. The evidence clearly supports Microkernel as primary:

1. **Scale of extension surface:** 172 named registration hooks in `Plugin::Instance` alone is not a convenience feature — it represents the entire feature delivery mechanism for a large portion of the product's capabilities.
2. **Major features live in plugins:** Chat (a full real-time messaging system), AI, gamification, polls, and calendar are not "extras" — they are first-class product features delivered entirely as plugins with their own models, services, controllers, database migrations, and frontend code. This would not happen if the plugin system were secondary.
3. **Runtime lifecycle:** Plugin enable/disable is a runtime operation (`plugin.enabled?` is checked at every registry lookup), not a compile-time or deploy-time concern. This is the defining Microkernel characteristic — the kernel operates with or without any given plugin.
4. **Core is intentionally thin:** `config/application.rb` bootstraps plugins as a primary initialization concern, not an afterthought. The core's job is to provide the platform; plugins provide the domain functionality.

The Layered style is a genuine secondary classification, not a mere implementation detail. The service layer DSL, the strict controller/model/serializer separation, and the fact that each plugin replicates this layer structure all demonstrate a deliberate commitment to layered organization as an architectural principle within the kernel and within plugins.

Confidence is 0.93. The Microkernel + Layered classification is strongly supported by code-level evidence at multiple scales. The minor gap accounts for the fact that the event-driven mechanisms (DiscourseEvent, MessageBus, Sidekiq) are substantial enough that some analysts might weigh them more heavily as a co-primary style.
