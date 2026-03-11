# Architecture Report: bigcapital

**Date:** 2026-03-11
**Repository:** https://github.com/bigcapitalhq/bigcapital
**Classification:** Modular Monolith, Event-Driven
**Confidence:** 0.93
**Analyst:** claude-sonnet-4-6

---

## Summary

Bigcapital is an open-source, multi-tenant accounting and financial management application built as a NestJS-based modular monolith. The backend is organized into over 60 fine-grained NestJS feature modules deployed as a single server process. Cross-module coordination is achieved primarily through NestJS's built-in event emitter (synchronous in-process events) and BullMQ job queues (asynchronous background processing via Redis). The frontend is a React SPA served separately. All modules share the same NestJS runtime and DI container — there are no independently deployable services.

---

## Evidence

### Repository structure

- **Monorepo managed with pnpm workspaces + Lerna** (`lerna.json`, `pnpm-workspace.yaml`)
- Top-level packages:
  - `packages/server` — NestJS backend (single deployable unit)
  - `packages/webapp` — React + Vite SPA frontend
  - `shared/` — Shared libraries: `bigcapital-utils`, `email-components`, `pdf-templates`, `sdk-ts`

### Server entry point

`packages/server/src/main.ts` bootstraps a single `NestFactory.create(AppModule)` instance listening on one port. There is no service registry, API gateway, or inter-process communication between multiple backend services.

### Production deployment

`docker-compose.prod.yml` defines:
- `proxy` (Envoy)
- `webapp` (React SPA)
- `server` (single NestJS server container)
- `mysql` (MariaDB)
- `redis`
- `gotenberg` (PDF generation)
- `database_migration` (one-shot init container)

No independent microservices; all business logic runs in the `server` container.

### Module structure (60+ NestJS modules)

`packages/server/src/modules/App/App.module.ts` imports all feature modules, including:
`AccountsModule`, `BillsModule`, `SaleInvoicesModule`, `LedgerModule`, `InventoryCostModule`, `FinancialStatementsModule`, `BankingTransactionsModule`, `SubscriptionModule`, `TenancyModule`, and ~50 others.

Each module follows a consistent internal layering:
- `*.controller.ts` — HTTP presentation layer
- `*.application.ts` — Use-case orchestration
- `commands/` — Write operations (Create, Edit, Delete services)
- `queries/` — Read operations (Get services)
- `subscribers/` — Event listeners
- `processors/` — BullMQ queue processors
- `models/` — Objection.js ORM models
- `dtos/` — Data transfer objects

Example from `SaleInvoices` module:
- `commands/CreateSaleInvoice.service.ts`, `EditSaleInvoice.service.ts`, `DeleteSaleInvoice.service.ts`
- `queries/GetSaleInvoice.service.ts`, `GetSaleInvoices.ts`
- `subscribers/InvoiceGLEntriesSubscriber.ts`, `SaleInvoiceAutoIncrementSubscriber.ts`
- `processors/SendSaleInvoiceMail.processor.ts`

### Event-driven patterns

`packages/server/src/common/events/events.ts` defines a comprehensive domain event catalog covering all major aggregates: `accounts`, `saleInvoice`, `bill`, `expenses`, `inventory`, `paymentReceive`, `creditNote`, `vendorCredit`, `bankTransactions`, `plaid`, `stripeWebhooks`, `reports`, and more — over 150 typed event names.

Subscribers use `@OnEvent(events.saleInvoice.onCreated)` from `@nestjs/event-emitter` to react to domain state changes:
- `InvoiceGLEntriesSubscriber` — writes general ledger entries when an invoice is created/edited/delivered
- `InvoiceCostGLEntriesSubscriber` — records cost GL entries
- `SaleInvoiceAutoIncrementSubscriber` — updates invoice sequence numbers
- `BillGLEntriesSubscriber`, `BillWriteInventoryTransactionsSubscriber` — same pattern for bills

This subscriber/event pattern is applied consistently across all modules, making Event-Driven a co-primary style — it is how modules decouple side effects (GL entries, inventory updates, notifications, analytics tracking) from core command execution.

### Background queue processing (BullMQ + Redis)

`InventoryCostModule` registers two BullMQ queues:
- `ComputeItemCostQueue` — asynchronously recomputes FIFO/average-cost lots after inventory transactions
- `WriteInventoryTransactionsGLEntriesQueue` — writes cost GL entries asynchronously

`SaleInvoicesModule` registers:
- `SendSaleInvoiceQueue` — delivers invoice mail asynchronously via `SendSaleInvoiceMailProcessor`

These queues are visible in a Bull Board dashboard (`/queues` route).

### Multi-tenant architecture

- **System database** (MariaDB): stores tenant metadata, user accounts, subscriptions
- **Per-tenant databases**: each tenant organization gets its own MariaDB schema (`bigcapital_tenant_{organizationId}`)
- `TenancyGlobalGuard`, `EnsureTenantIsInitializedGuard`, `EnsureTenantIsSeededGuard` enforce tenant context on every request
- `ClsService` (continuation-local storage) propagates `organizationId` through the async call stack
- `UnitOfWork.service.ts` wraps tenant DB operations in Knex transactions with configurable isolation levels

### Internal layering within modules

Each module enforces a clear layered structure:
- Presentation: NestJS controllers with Swagger decorators
- Application: application-service facade delegating to granular command/query services
- Domain logic: command/query services
- Data access: Objection.js models + repository classes
- Infrastructure: mail, S3, Gotenberg (PDF), Redis, BullMQ

### Technology stack

| Concern | Technology |
|---|---|
| Framework | NestJS 10 |
| ORM | Objection.js + Knex |
| Database | MariaDB (MySQL) |
| Cache / Queues | Redis, BullMQ, Bull |
| Events | @nestjs/event-emitter |
| Auth | Passport.js (JWT, local, Google OAuth, API key) |
| Realtime | Socket.IO (WebSocket gateway) |
| PDF | Gotenberg (headless Chromium) |
| File storage | AWS S3 |
| Banking | Plaid API |
| Payments | Stripe, LemonSqueezy |
| Email | Nodemailer |
| Frontend | React + Vite |

---

## Architecture Styles Identified

### 1. Modular Monolith (primary)

**Evidence:**
- Single NestJS application process with 60+ encapsulated feature modules
- Single server container in production (`docker-compose.prod.yml`)
- All modules share one DI container and runtime
- Module boundaries enforced by NestJS's explicit import/export mechanism
- No service discovery, no API gateway between backend components
- Root `App.module.ts` imports all feature modules into one cohesive application

### 2. Event-Driven (co-primary)

**Evidence:**
- `src/common/events/events.ts` — 150+ named domain events across all aggregates
- `@OnEvent()` subscribers in every major feature module for GL writes, inventory updates, mail notifications, and analytics
- BullMQ queues decouple long-running operations (cost computation, email delivery) from request-response cycle
- WebSocket gateway emits real-time events (`NEW_TRANSACTIONS_DATA`, `SUBSCRIPTION_CHANGED`) to frontend clients
- Events serve as the primary integration mechanism between modules (not direct service calls), making this a structural pattern, not merely an implementation detail

### 3. Layered (tertiary, within modules)

**Evidence:**
- Every module exhibits a consistent four-layer stack: Controller → Application Service → Command/Query Service → Repository/Model
- `commands/` and `queries/` subdirectory conventions enforce CQRS-lite separation within modules
- DTO validation layer (`class-validator`) at the presentation boundary
- `UnitOfWork.service.ts` at the data access boundary

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| **Multi-tenancy** | Separate per-tenant MariaDB schemas with dynamic connection routing; CLS-based tenant context propagation through async call stacks |
| **Modularity** | 60+ discrete NestJS modules with explicit boundary enforcement; each module is independently testable |
| **Extensibility** | Event-subscriber pattern enables adding new side effects without modifying core command code |
| **Observability** | Bull Board queue dashboard; PostHog analytics (`EventsTracker` module); New Relic metrics (configured in prod env vars); Socket.IO real-time notifications |
| **Security** | Multi-strategy Passport auth (JWT, local, Google OAuth, API key); CASL ability-based authorization; throttling with Redis-backed rate limiter |
| **Scalability** | Redis-backed BullMQ queues for async background processing; per-tenant DB isolation supports horizontal scaling; stateless server via CLS |
| **Maintainability** | Single-responsibility services (`CreateSaleInvoice`, `EditSaleInvoice`, `DeleteSaleInvoice`); consistent module structure across all 60+ modules |
| **Integrations** | First-class support for Plaid (bank sync), Stripe (payments), LemonSqueezy (subscriptions), S3 (file storage) |

---

## Classification Reasoning

Bigcapital is classified as **Modular Monolith + Event-Driven**.

The Modular Monolith classification is unambiguous: a single NestJS server process deploys in one container; all modules share the same runtime and DI container; no inter-service communication or service registry exists. The 60+ NestJS modules provide meaningful boundary enforcement through explicit imports/exports, but they are co-located in one deployable unit.

The Event-Driven classification is co-primary rather than secondary because events are the *structural* integration mechanism between modules, not just an implementation convenience. Every major domain operation (invoice created, bill posted, inventory transaction recorded, bank transaction matched) emits a named event from `events.ts`. Other modules react via `@OnEvent()` subscribers to write GL entries, update inventory quantities, send notifications, and track analytics — all without direct service-to-service coupling. BullMQ further extends this pattern to asynchronous background processing.

Layered architecture is present but tertiary — it describes the internal organization within each module (controller → application service → command/query service → repository), not the overall system structure.

The previous classification (Modular Monolith + Layered) correctly identified the primary style but understated the role of Event-Driven patterns. The event infrastructure is pervasive and structural, not incidental.
