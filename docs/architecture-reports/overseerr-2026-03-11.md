---
project: "Overseerr"
date: 2026-03-11
scope: application
use-type: production
primary-language: TypeScript
confidence: 0.91
styles:
  - name: Layered
    role: primary
    confidence: 0.91
  - name: Modular Monolith
    role: secondary
    confidence: 0.83
---

# Architecture Analysis: Overseerr

## Metadata

| Field | Value |
|---|---|
| Project | Overseerr |
| Repo | https://github.com/sct/overseerr |
| Date | 2026-03-11 |
| Scope | application |
| Use-type | production |
| Primary Language | TypeScript |
| Other Languages | JavaScript, CSS |

## Style Rationales

**Layered (primary, 0.91):** The entire application is organized as a strict horizontal-layer stack within a single deployable process. The presentation layer is a Next.js React SPA (`src/pages/`, `src/components/`). The API layer is an Express router tree (`server/routes/`) validated against an OpenAPI spec (`overseerr-api.yml`) via `express-openapi-validator`. The business logic and integration layer sits in `server/lib/` (notification manager, scanners, permission system, settings) and `server/subscriber/` (TypeORM entity event subscribers that enforce request-lifecycle rules). The data access layer is TypeORM with SQLite (`server/entity/`, `server/datasource.ts`, `server/migration/`). Finally, the external integration layer is in `server/api/` (ExternalAPI base class with caching, rate-limiting; Plex, Radarr, Sonarr, TheMovieDb, Pushover clients). Each layer depends only on layers below it: routes call lib/subscribers, which call entities and api clients, never the reverse. The entrypoint in `server/index.ts` wires the layers together in a single Express+Next process on port 5055.

**Modular Monolith (secondary, 0.83):** Within the single process and single SQLite database, the codebase is clearly partitioned into vertical feature modules that map to the API route tree: `auth`, `user`, `request`, `media`, `movie`, `tv`, `search`, `discover`, `issue`, `collection`, `service`, `settings`. Each feature module owns its routes file, corresponding entity or entities, and any lib helpers. They are deployed together as one artifact (Docker image), share a single TypeORM data source, and there is no inter-service communication — but internal cohesion within each module is notably higher than coupling across modules. The `server/entity/` types (`MediaRequest`, `Media`, `User`, `Issue`, `Season`) form the shared domain model across modules.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| Express + Next.js in single process, port 5055 | `server/index.ts:44,207` | Layered |
| OpenAPI validation middleware on all API routes | `server/index.ts:166-171`, `overseerr-api.yml` | Layered |
| 14-route Express router tree | `server/routes/index.ts:24-153` | Layered |
| `ExternalAPI` base class with caching and rate-limit | `server/api/externalapi.ts:22-138` | Layered |
| TypeORM entity layer with 33 migrations | `server/entity/`, `server/migration/` (33 files) | Layered |
| SQLite single data source | `server/datasource.ts:5-35` | Layered |
| TypeORM `@EventSubscriber` hooks enforce business rules | `server/subscriber/MediaRequestSubscriber.ts:32` | Layered |
| `NotificationManager` + 10 pluggable agents | `server/lib/notifications/index.ts`, `agents/` | Layered |
| `node-schedule` cron jobs (Plex, Radarr, Sonarr scans) | `server/job/schedule.ts:27-186` | Layered |
| Feature route modules map 1:1 to route prefixes | `server/routes/{auth,user,request,movie,tv,...}.ts` | Modular Monolith |
| Shared TypeORM entities across all feature modules | `server/entity/{Media,MediaRequest,User,Issue}.ts` | Modular Monolith |
| Single Docker image, single entrypoint | `Dockerfile:46-49` | Modular Monolith |
| `src/` and `server/` share no runtime boundary — same process | `server/index.ts:43-44` | Modular Monolith |

## What Was Rejected and Why

**Not Microservices:** There is exactly one deployable process (one Docker image, one port, one SQLite file). The frontend (Next.js SSR) and backend (Express API) share the same Node.js process and are not separately deployable.

**Not Event-Driven:** TypeORM `@EventSubscriber` decorators react to entity lifecycle events, but this is an in-process synchronous ORM hook, not a message bus or event broker. The notification system is also synchronous (`notificationManager.sendNotification` iterates agents in the same thread).

**Not Hexagonal Architecture:** There are no formal ports/adapters contracts. The `ExternalAPI` base class is an integration convenience, not an adapter implementing a domain-defined port interface. Business logic in `server/lib/` calls API clients directly.

**Not CQRS:** All reads and writes go through the same TypeORM repositories; there is no read model or command/query segregation.

**Not Pipeline:** The cron jobs process data sequentially in scanners, but this is a background maintenance feature, not the primary architectural style. The main request path is synchronous HTTP → route → subscriber → entity save.

## Quality Attributes Evidence

**Operability:** Swagger UI served at `/api-docs`; OpenAPI spec enforced at runtime; Winston structured logging throughout with per-module `label` fields.

**Extensibility:** Notification agents implement a `NotificationAgent` interface and are registered at startup — new channels can be added without changing the notification manager. External service integrations (Radarr, Sonarr, Plex) are encapsulated in `server/api/` with a common base class.

**Security:** CSRF protection middleware (`csurf`), session-based auth via `express-session` + TypeORM session store, granular permission system (`Permission` bitmask in `server/lib/permissions.ts`), rate limiting via `express-rate-limit`.

**Deployability:** Single Docker multi-stage build; configurable via environment variables and `config/` volume; supports `linux/amd64`, `linux/arm64`, `linux/arm/v7`.

**Maintainability:** TypeScript throughout; strict OpenAPI contract enforced at runtime; 33 schema migrations managed by TypeORM; Cypress end-to-end test suite.

**Performance:** In-process `node-cache` for TMDB API responses; image proxy with CDN-friendly no-cookie headers; rolling cache strategy for frequently-accessed data.
