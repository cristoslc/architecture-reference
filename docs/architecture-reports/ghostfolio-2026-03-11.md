# Architecture Report: ghostfolio

**Date:** 2026-03-11
**Repository:** https://github.com/ghostfolio/ghostfolio
**Classification:** Modular Monolith, Layered
**Confidence:** 0.90
**Analyst:** claude-sonnet-4-6

---

## Summary

Ghostfolio is an open-source wealth management application (AGPL-3.0) built as a NestJS modular monolith deployed as a single container, with PostgreSQL as the primary database, Redis for caching and job queues, and an Angular 21 Progressive Web App (PWA) as the frontend. The API server statically serves the built Angular client, making the entire product a single deployable unit. Background processing runs through two Bull/Redis queues (data gathering and portfolio snapshots). Event-Driven patterns are present but limited to two internal domain events used for debounced cache invalidation, making them insufficient to elevate Event-Driven to a co-primary style. Within the NestJS backend, clear controller-service-repository layering is enforced consistently across all ~30 feature modules.

---

## Evidence

### Repository structure

- **Monorepo managed with Nx** (`nx.json`)
- Top-level workspaces:
  - `apps/api` — NestJS backend (single deployable unit)
  - `apps/client` — Angular PWA frontend
  - `libs/common` — Shared DTOs, interfaces, helpers, enums, config constants
  - `libs/ui` — Shared Angular component library (Storybook-documented)

### Server entry point and deployment

`apps/api/src/main.ts` bootstraps a single `NestFactory.create<NestExpressApplication>(AppModule)` instance listening on one port (default 3333). The NestJS API serves the compiled Angular client via two `ServeStaticModule.forRoot()` registrations — one for the Angular app and one for `/.well-known/`. The entire product ships as a single Docker image.

`docker/docker-compose.yml` defines exactly three services:
- `ghostfolio` — the single application container (API + Angular client served together)
- `postgres` — PostgreSQL 15
- `redis` — Redis

There are no sidecar workers, no API gateway, no service mesh, no separately deployable backend services.

### Module structure (~30 NestJS feature modules)

`apps/api/src/app/app.module.ts` imports all feature modules into one root `AppModule`:

**Domain modules:** `AccessModule`, `AccountModule`, `ActivitiesModule`, `AdminModule`, `AssetModule`, `AuthDeviceModule`, `AuthModule`, `CacheModule`, `ExchangeRateModule`, `ExportModule`, `HealthModule`, `ImportModule`, `InfoModule`, `LogoModule`, `PlatformModule`, `PortfolioModule`, `RedisCacheModule`, `SubscriptionModule`, `SymbolModule`, `UserModule`

**Endpoint modules (under `app/endpoints/`):** `AiModule`, `ApiKeysModule`, `AssetsModule`, `BenchmarksModule`, `GhostfolioModule`, `MarketDataModule`, `PlatformsModule`, `PublicModule`, `SitemapModule`, `TagsModule`, `WatchlistModule`

**Infrastructure services (under `services/`):** `ConfigurationModule`, `CronModule`, `DataProviderModule`, `ExchangeRateDataModule`, `DataGatheringModule`, `PortfolioSnapshotQueueModule`, `PrismaModule`, `PropertyModule`

### Internal layering within modules

Every module follows a consistent controller → service → Prisma repository structure:

- `*.controller.ts` — HTTP presentation layer with NestJS guards and pipes
- `*.service.ts` — Business logic layer
- `prisma.service.ts` (shared) — Data access via Prisma ORM to PostgreSQL

Example from `PortfolioModule`:
- `portfolio.controller.ts` (674 lines) — 20+ HTTP endpoints for positions, performance, holdings, risk analysis
- `portfolio.service.ts` (2247 lines) — Portfolio analytics engine; delegates to `PortfolioCalculatorFactory`
- `calculator/portfolio-calculator.factory.ts` — Factory producing one of four calculator implementations (MWR, TWR, ROAI, ROI) via Strategy pattern

### Portfolio analytics — Strategy pattern within the domain layer

`apps/api/src/app/portfolio/calculator/portfolio-calculator.factory.ts` implements a clean Strategy pattern:
- `MwrPortfolioCalculator` — Money-Weighted Return
- `TwrPortfolioCalculator` — Time-Weighted Return
- `RoiPortfolioCalculator` — Return on Investment
- `RoaiPortfolioCalculator` — Return on Average Investment

This reflects deliberate financial domain modeling and is one of the more sophisticated internal design elements.

### Portfolio risk rules engine

`apps/api/src/models/rules/` defines eight typed rule classes:
- `account-cluster-risk/`
- `asset-class-cluster-risk/`
- `currency-cluster-risk/`
- `economic-market-cluster-risk/`
- `emergency-fund/`
- `fees/`
- `liquidity/`
- `regional-market-cluster-risk/`

`apps/api/src/models/rule.ts` provides the base `Rule` class; `portfolio/rules.service.ts` evaluates all rules against user holdings.

### Background queue processing (Bull + Redis)

Two Bull queues provide asynchronous background processing:

**`DataGatheringModule` (`DATA_GATHERING_QUEUE`):**
- `DataGatheringProcessor` — processes `GATHER_ASSET_PROFILE_PROCESS_JOB_NAME` and `GATHER_HISTORICAL_MARKET_DATA_PROCESS_JOB_NAME` jobs
- Configurable concurrency via `PROCESSOR_GATHER_ASSET_PROFILE_CONCURRENCY` env var
- `CronService` schedules data gathering every hour (random minute offset), with weekly full refresh

**`PortfolioSnapshotQueueModule`:**
- Computes and caches portfolio snapshots asynchronously for each user

Both queues use Redis as the broker. Bull Board is available at a configurable route when `ENABLE_FEATURE_BULL_BOARD=true`.

### Event-Driven patterns (limited scope)

`apps/api/src/events/` defines exactly two domain events:
- `PortfolioChangedEvent` + `PortfolioChangedListener` — debounced (5-second) Redis cache invalidation for portfolio snapshots when a portfolio changes
- `AssetProfileChangedEvent` + `AssetProfileChangedListener` — cache invalidation when an asset profile is updated

These events use `@nestjs/event-emitter`. The scope is intentionally narrow — cache coordination only, not cross-module business logic coordination. There is no broader event mesh or publish-subscribe topology across modules.

### Data provider abstraction (Plugin/Strategy pattern)

`apps/api/src/services/data-provider/` implements a clean plugin architecture with a `DataProviderInterface` and eight concrete implementations:
- `YahooFinanceService` — Yahoo Finance (primary free provider)
- `CoinGeckoService` — Cryptocurrency market data
- `AlphaVantageService`
- `EodHistoricalDataService`
- `FinancialModelingPrepService`
- `GhostfolioService` — Ghostfolio Premium data feed
- `GoogleSheetsService`
- `ManualService` — manual price overrides
- `RapidApiService`

`DataProviderService.onModuleInit()` reads a configurable `PROPERTY_DATA_SOURCE_MAPPING` to route symbols to providers at runtime.

### Authentication architecture

`apps/api/src/app/auth/` implements four Passport strategies:
- `JwtStrategy` — JWT bearer tokens
- `ApiKeyStrategy` — header-based API key auth
- `GoogleOAuthStrategy` — Google OAuth 2.0 (optional)
- `OidcStrategy` — OpenID Connect (optional)
- `WebAuthService` — WebAuthn/passkey support (`@simplewebauthn/server`)

### Privacy and access sharing

`apps/api/src/app/access/` and `apps/api/src/services/impersonation/` provide portfolio sharing: users can grant read-only access to their portfolio to other users, with an `AccessPermission` model in the Prisma schema.

### SaaS / self-hosting duality

`apps/api/src/app/subscription/subscription.service.ts` integrates Stripe for the hosted Ghostfolio Premium offering. The `ENABLE_FEATURE_SUBSCRIPTION` env flag toggles this feature, allowing the same codebase to run as a fully self-hosted, subscription-free instance.

### Angular PWA frontend

`apps/client/` is an Angular 21 single-page application with:
- Lazy-loaded routes (20+ pages: `home`, `portfolio`, `accounts`, `markets`, `admin`, `auth`, `zen`, etc.)
- `@angular/service-worker` (PWA) — `ngsw-config.json` defines prefetch strategy for app shell and lazy asset caching
- `@ionic/angular` for mobile UI components (mobile-first design)
- Angular Material + Bootstrap for UI components
- Storybook component documentation at `libs/ui/`
- `ObservableStore` (`@codewithdan/observable-store`) for in-app state management

### Technology stack summary

| Concern | Technology |
|---|---|
| Backend framework | NestJS 11 |
| ORM | Prisma 6 |
| Database | PostgreSQL 15 |
| Cache | Redis (keyv adapter) |
| Job queues | Bull 4 + Redis |
| Event bus | @nestjs/event-emitter (2 events) |
| Auth | Passport (JWT, API key, Google OAuth, OIDC) + SimpleWebAuthn |
| Payments | Stripe |
| AI | OpenRouter AI SDK (@openrouter/ai-sdk-provider) |
| Frontend framework | Angular 21 |
| Frontend UI | Angular Material + Ionic + Bootstrap |
| PWA | @angular/service-worker |
| Build system | Nx 22 monorepo |
| Language | TypeScript 5.9 |
| Node.js | >=22.18.0 |

---

## Architecture Styles Identified

### 1. Modular Monolith (primary)

**Evidence:**
- Single NestJS application process deploying as one container in both development (`docker-compose.dev.yml`) and production (`docker-compose.yml`)
- The API statically serves the Angular client — both frontend and backend ship in the same container image
- ~30 NestJS feature modules all co-located in `apps/api`, sharing one DI container, one Prisma client, and one PostgreSQL connection pool
- No inter-service communication, no service discovery, no API gateway between backend components
- `AppModule` in `app.module.ts` imports all feature modules into one cohesive application root
- Dockerfile produces a single deployable image from a single build process

### 2. Layered (co-primary, within modules and system-wide)

**Evidence:**
- All 30+ feature modules enforce a consistent three-tier stack: `*.controller.ts` (HTTP/presentation) → `*.service.ts` (business logic) → `PrismaService` (data access)
- `PortfolioModule` illustrates the depth: `portfolio.controller.ts` (674 lines, HTTP boundary) → `portfolio.service.ts` (2247 lines, domain logic + analytics) → Prisma (data access) → external data providers (infrastructure)
- `PortfolioCalculatorFactory` adds a fourth strategy sub-layer within the domain tier for financial calculation abstraction
- NestJS Guards (`AuthGuard`, `ImpersonationGuard`), Interceptors (`RedactValuesInResponseInterceptor`), and Pipes (`ValidationPipe`) enforce cross-cutting concerns as distinct layers outside module business logic
- `libs/common` (shared types/interfaces/DTOs) and `libs/ui` (shared UI components) form explicit cross-cutting library layers separate from application code

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| **Privacy** | Data ownership is the project's core value proposition; self-hosting supported via Docker; access-sharing feature (read-only portfolio grants) with fine-grained `AccessPermission` model; response redaction via `RedactValuesInResponseInterceptor` |
| **Extensibility** | Data provider plugin architecture with `DataProviderInterface` and 9 concrete implementations; new providers are added without modifying core; `DataProviderService` dynamically routes symbols to providers via `PROPERTY_DATA_SOURCE_MAPPING` |
| **Security** | Four Passport authentication strategies (JWT, API key, Google OAuth, OIDC); WebAuthn/passkey support; Helmet CSP headers; JWT-signed tokens with configurable salt; `ENABLE_FEATURE_*` feature flags for capability isolation |
| **Deployability** | Single Docker image for API + Angular client; official multi-arch images (`linux/amd64`, `linux/arm/v7`, `linux/arm64`); Docker Compose with health checks; Prisma migrations in entrypoint |
| **Performance** | Redis caching via `@keyv/redis` and `RedisCacheService`; portfolio snapshot queue pre-computes expensive analytics; debounced cache invalidation via `PortfolioChangedListener`; Angular PWA with service-worker prefetch caching |
| **Modularity** | 30+ NestJS modules with explicit boundary enforcement; `libs/common` and `libs/ui` as independently versioned shared libraries; Storybook documents UI component library independently |
| **Maintainability** | Full TypeScript codebase; Prisma type-safe ORM; Nx monorepo with dependency graph and affected-build caching; consistent module structure across all feature areas; ~63,500 lines of TypeScript source |
| **Integrations** | 9 market data providers (Yahoo Finance, CoinGecko, Alpha Vantage, etc.); Stripe for SaaS subscriptions; OpenRouter/AI SDK for AI portfolio analysis; Google Sheets as a manual data source; Twitter/X bot for fear-and-greed index |

---

## Classification Reasoning

Ghostfolio is classified as **Modular Monolith (primary) + Layered (co-primary)**.

**Modular Monolith** is unambiguous. A single NestJS process, compiled into a single Docker image, serves both the REST API and the Angular frontend as static files. The `docker-compose.yml` contains exactly one application container. All ~30 feature modules share one DI container, one PostgreSQL connection (via Prisma), and one Redis connection. There is no inter-service communication, service discovery, or API gateway between backend components. The Nx monorepo build (`apps/api`, `apps/client`, `libs/common`, `libs/ui`) compiles to a single deployable artifact.

**Layered** is co-primary rather than a tertiary internal detail because the layering is *system-wide and structural*. Every feature module enforces the same three-tier boundary: HTTP controllers at the top (decorated with NestJS guards, interceptors, and validation pipes), service classes holding all business logic in the middle, and Prisma as the data access layer at the bottom. This is not accidental — NestJS's architecture and Ghostfolio's consistent conventions make layering the primary organizational principle within the monolith. `PortfolioService` (2,247 lines) exemplifies this: it is the domain logic layer, with `portfolio.controller.ts` strictly above it (HTTP boundary) and Prisma strictly below it (data boundary). The separation between `libs/common` (shared domain types) and application code, and between `libs/ui` (UI component library) and the Angular app, adds system-level layering beyond the module level.

**Ruled out — Event-Driven**: Only two `@nestjs/event-emitter` events exist (`PortfolioChangedEvent`, `AssetProfileChangedEvent`), both used exclusively for cache invalidation. There is no broader event mesh, no pub-sub topology for cross-module business logic, and no event-sourcing. The Bull queues (`DataGatheringQueue`, `PortfolioSnapshotQueue`) are infrastructure-level background processing, not an architectural integration mechanism between modules. Event-Driven patterns are present but incidental, not structural.

**Ruled out — Microservices**: No NestJS `@nestjs/microservices` usage, no `MessagePattern`, no gRPC, no independently deployable services. All backend logic co-exists in one process.

**Ruled out — PWA as separate style**: The Angular PWA is the UI layer of the modular monolith's presentation tier, not a separate architectural classification. PWA capabilities (service worker, offline caching, mobile-first design) are a quality attribute (Performance, Deployability) rather than an architectural style.
