# Architecture Report: cal.com

**Date:** 2026-03-11
**Repo URL:** https://github.com/calcom/cal.com
**Classification:** Modular Monolith + Microkernel
**Confidence:** 0.92

---

## Summary

cal.com is an open-source scheduling platform built as a **Modular Monolith** with a strong **Microkernel** (plugin) secondary pattern. The core application is a Next.js monolith (`apps/web`) organized into well-bounded feature modules under `packages/features/`, all sharing a single PostgreSQL database via Prisma. A separate NestJS service (`apps/api/v2`) provides an external REST API surface for platform consumers but shares the same database — it does not constitute an independent microservice. The plugin system (`packages/app-store/`) implements a textbook microkernel with 140+ dynamically-loaded integrations (calendar providers, video conferencing, CRM, payment processors). An async task/webhook pipeline (trigger.dev + internal tasker) layers limited event-driven behavior on top of the synchronous core, but does not constitute a primary Event-Driven architecture.

---

## Evidence from Code Exploration

### Monorepo Structure

The project uses **Turborepo** (`turbo.json`) with Yarn workspaces to manage a multi-package monorepo. Key top-level workspaces:

- `apps/web` — Primary Next.js application (the monolith)
- `apps/api/v1`, `apps/api/v2` — REST API surfaces (v2 is NestJS)
- `packages/features/` — Domain feature modules (bookings, availability, eventtypes, auth, webhooks, etc.)
- `packages/trpc/` — Shared tRPC API layer consumed by `apps/web`
- `packages/prisma/` — Single shared Prisma schema (119 models, PostgreSQL)
- `packages/app-store/` — Plugin registry (140+ integrations)
- `packages/lib/` — Cross-cutting utilities
- `packages/platform/` — Platform SDK (atoms/embeds for external consumers)

### Deployment Topology (docker-compose.yml)

Two deployable services sharing one database:
- `calcom` — Main Next.js web app on port 3000
- `calcom-api` — NestJS v2 API on port 80/443
- `database` — Single shared PostgreSQL instance
- `redis` — Shared Redis (rate limiting, task queuing, slot caching)

Both services point to the same `DATABASE_URL`, confirming a shared-database monolithic data architecture.

### Feature Module Organization (packages/features/)

Feature modules follow consistent vertical-slice structure with explicit layering:
- `bookings/`: repositories/, services/, lib/, di/, hooks/, components/
- `eventtypes/`: repositories/, service/, di/, lib/, components/
- `webhooks/`: lib/service/, lib/interface/, lib/tasker/, lib/repository/
- `availability/`, `calendars/`, `auth/`, `billing/`, `workflows/`, `routing-forms/` similarly structured

Each feature exposes interfaces through its `di/` (dependency injection) directory using `@evyweb/ioctopus` IoC containers with typed token maps.

### Shared tRPC API Layer

`packages/trpc/server/routers/` exposes a unified API surface consumed by the Next.js web app:
- `_app.ts` — Root router
- `viewer/` — Authenticated viewer endpoints
- `publicViewer/` — Public endpoints (booking pages, slot availability)
- `loggedInViewer/` — Session-scoped queries
- `apps/` — App-store routing form handlers

### Repository Pattern + Dependency Injection

Explicit repository interfaces throughout (`IBookingRepository`, `IAttendeeRepository`, `IWebhookRepository`, etc.) with concrete Prisma implementations. DI wiring is done via container modules:

```typescript
// packages/features/bookings/di/RegularBookingService.module.ts
const loadModule = bindModuleToClassOnToken({
  module: thisModule,
  token: DI_TOKENS.REGULAR_BOOKING_SERVICE,
  classs: RegularBookingService,
  depsMap: {
    bookingRepository: bookingRepositoryModuleLoader,
    webhookProducer: webhookProducerModuleLoader,
    bookingEventHandler: bookingEventHandlerModuleLoader,
    // ...
  },
});
```

### Microkernel Plugin System (packages/app-store/)

Auto-generated plugin registry files confirm microkernel pattern:
- `apps.server.generated.ts` — Dynamic import map for 140+ plugins
- `apps.metadata.generated.ts` — Metadata registry
- `apps.schemas.generated.ts`, `apps.keys-schemas.generated.ts` — Plugin contracts
- `app-store-cli/` — Scaffolding tool for `create-app`, `edit-app`, `delete-app`

Each plugin follows a standardized contract: `index.ts`, `_metadata.ts`, `config.json`, `api/` (OAuth/webhooks), `lib/` (service implementations), `components/` (UI).

### Async Task Pipeline (trigger.dev + InternalTasker)

A growing async layer handles post-booking side effects:
- `packages/lib/tasker/Tasker.ts` — Abstract base with async/sync dispatch with fallback
- `packages/features/tasker/` — Task type registry (`sendWebhook`, `sendSms`, `bookingAudit`, `createCRMEvent`, `executeAIPhoneCall`, `sendWorkflowEmails`, etc.)
- `packages/features/trigger.config.ts` — Defines trigger.dev task dirs: bookings notifications, calendars, webhooks, billing proration
- `packages/features/webhooks/lib/tasker/WebhookTasker.ts` — WebhookTasker dispatches to `WebhookTriggerTasker` (trigger.dev) or `WebhookSyncTasker` (fallback)
- Queue names defined: `webhook-delivery` (concurrency 25), `calendars` (concurrency 10), booking notifications

The `BookingEventHandlerService` queues audit events after booking state changes (`queueCreatedAudit`, `queueCancelledAudit`, `queueRescheduledAudit`, etc.) via `BookingAuditProducerService`. This is an internal producer/consumer pattern, not a full event bus.

### NestJS API v2 (apps/api/v2)

A standalone NestJS application with module-based architecture:
- `app.module.ts` — Root module with Redis (Bull + Throttler), Sentry, JWT, Prisma
- `modules/endpoints.module.ts` — Aggregates domain modules: `UsersModule`, `WebhooksModule`, `OrganizationsBookingsModule`, `ConferencingModule`, `BillingModule`, `OAuthClientModule`, etc.
- Uses NestJS DI (decorators), Redis-backed rate limiting, Bull queue

This is a service-layer API — it does not own independent data; it shares the `calcom` database.

---

## Architecture Styles Identified

### Primary: Modular Monolith

**Evidence:**
1. Single deployable unit (`apps/web`) contains all core scheduling functionality
2. Single shared PostgreSQL database (119 Prisma models in one `schema.prisma`)
3. Packages under `packages/features/` are domain modules, not independent services — they compile into the same deployment artifact
4. tRPC router in `packages/trpc/` provides a unified internal API for `apps/web`
5. No database-per-domain pattern; all reads/writes go through shared Prisma client
6. Turborepo workspace dependency graph enforces module boundaries without service independence

### Secondary: Microkernel

**Evidence:**
1. `packages/app-store/` contains 140+ integration plugins (Google Calendar, Zoom, Stripe, HubSpot, Salesforce, Slack, etc.)
2. Auto-generated registries (`apps.server.generated.ts`, `apps.metadata.generated.ts`) dynamically load plugin implementations
3. `packages/app-store-cli/` provides plugin lifecycle CLI (`create-app`, `edit-app`, `delete-app`)
4. Each plugin implements a standardized interface: metadata contract, OAuth handlers, service implementations
5. Plugin extension points: `api/` (OAuth callbacks/webhooks), `lib/` (CalendarService implementations), `components/` (UI widgets)

### Tertiary (emerging): Event-Driven elements

**Evidence:**
1. trigger.dev integration with named queues (`webhook-delivery`, `calendars`, booking notifications)
2. Producer/consumer webhook architecture (`WebhookTaskerProducerService`, `WebhookTaskConsumer`)
3. `BookingEventHandlerService` with named booking lifecycle events (onBookingCreated, onBookingCancelled, etc.)
4. `InternalTasker`/`TaskerFactory` for async task dispatch with sync fallback

This is **not** classified as primary Event-Driven because: (a) the core booking flow is synchronous, (b) trigger.dev is gated by `ENABLE_ASYNC_TASKER` env flag with synchronous fallback, (c) no message broker (Kafka, RabbitMQ) is present, (d) no event sourcing or CQRS patterns.

---

## Quality Attributes

| Attribute | Assessment | Justification |
|---|---|---|
| Extensibility | High | 140+ plugins via microkernel; new integrations added without core changes |
| Maintainability | High | Vertical-slice feature modules with repository pattern, DI, and interface abstractions |
| Testability | High | Repository interfaces enable mocking; vitest unit + Playwright E2E; explicit DI containers |
| Scalability | Medium | Single shared database limits horizontal scaling; Redis helps with rate limiting and slots caching |
| Deployability | Medium | Two-service topology (web + api) behind shared DB; simple docker-compose setup |
| Reliability | Medium-High | Async task fallback (sync fallback when trigger.dev unavailable); retry configs on queues |
| Observability | Medium | Sentry integrated in both services; Axiom logging tokens; distributed tracing in booking flow |
| Developer Experience | High | Turborepo task caching, explicit env-check steps, biome formatting, lint-staged hooks |

---

## Classification Reasoning

cal.com is classified as **Modular Monolith + Microkernel** at confidence 0.92.

The **Modular Monolith** classification is strongly supported by: a single shared PostgreSQL database (the definitive monolith marker), a single primary deployable artifact (`apps/web`), and feature code organized into internal packages that compile together rather than deploying independently. The modular aspect is enforced through Turborepo workspace boundaries, tRPC as internal contract layer, DI containers with typed tokens, and repository interfaces.

The **Microkernel** classification is strongly supported by the app-store plugin system — a textbook microkernel where the core scheduling engine is the "kernel" and 140+ integrations are "plugins" loaded dynamically via generated registries, each conforming to a standard plugin contract.

The separate NestJS API (`apps/api/v2`) does not promote this to **Service-Based** or **Microservices** because it shares the same database and is better understood as an alternate API surface (REST alongside tRPC) for platform consumers, not an independently deployable service domain.

The async task pipeline (trigger.dev) adds **Event-Driven elements** but remains secondary: the core booking, availability, and scheduling flows are synchronous; async dispatch is a performance/reliability enhancement with synchronous fallback, not an architectural commitment.

**Rejected styles:**
- *Microservices*: Services do not own independent databases; no service mesh or independent deployment per domain
- *Event-Driven*: No message broker; synchronous core with async bolt-on
- *CQRS*: No explicit read/write model separation; single Prisma client for reads and writes
- *Serverless*: Docker container deployment; no FaaS functions
- *DDD*: Feature organization by domain but no formal aggregates, value objects, or bounded context documentation
