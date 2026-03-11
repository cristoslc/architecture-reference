---
project: "Rocket.Chat"
date: 2026-03-10
scope: platform
use-type: production
primary-language: TypeScript
confidence: 0.91
styles:
  - name: Modular Monolith
    role: primary
    confidence: 0.88
  - name: Service-Based
    role: secondary
    confidence: 0.85
  - name: Event-Driven
    role: secondary
    confidence: 0.78
  - name: Microkernel
    role: secondary
    confidence: 0.72
---

# Architecture Analysis: Rocket.Chat

## Metadata

| Field | Value |
|---|---|
| Project | Rocket.Chat |
| Repo | https://github.com/RocketChat/Rocket.Chat |
| Date | 2026-03-10 |
| Scope | platform |
| Use-type | production |
| Primary Language | TypeScript |
| Other Languages | JavaScript, CSS |

## Style Rationales

**Modular Monolith (primary, 0.88):** The Meteor app (`apps/meteor/`) is the core and ships as a single deployable unit in the default configuration. It contains ~97 self-contained feature modules under `app/` (2fa, authorization, livechat, push-notifications, integrations, omnichannel, federation, search, etc.) and ~20 internal services under `server/services/` (RoomService, TeamService, MessageService, UserService, etc.). All modules share a single MongoDB database. Services are registered via `api.registerService()` against a `LocalBroker` (in-process event emitter) when `TRANSPORTER` is unset, making the default deployment a modular monolith with well-defined internal service boundaries. The monorepo manages ~50+ `packages/` providing typed contracts (`core-typings`, `rest-typings`, `model-typings`) that enforce module interfaces.

**Service-Based (secondary, 0.85):** When `TRANSPORTER=nats://...` is set, the same codebase switches to a distributed topology. Independent service containers — `account-service`, `authorization-service`, `presence-service`, `ddp-streamer-service`, `queue-worker-service`, `omnichannel-transcript-service` — each bootstrap via the same `api.registerService()` pattern but connect through `NetworkBroker` (backed by Moleculer + NATS) instead of `LocalBroker`. This is not Microservices: all services still share a single MongoDB replica set (evidenced by every service container accepting `MONGO_URL` as its sole data store) and inter-service calls use a shared RPC protocol over NATS rather than independent bounded contexts with separate schemas. The broker abstraction (`IBroker` / `IApiService` / `proxify()`) provides transparent switching between modes.

**Event-Driven (secondary, 0.78):** `EventSignatures` in `packages/core-services/src/events/Events.ts` declares ~60+ typed domain events (`accounts.login`, `accounts.logout`, `message`, `room.video-conference`, `banner.new`, `license.sync`, `presence.status`, `livechat-inquiry-queue-observer`, etc.). Both `LocalBroker` (in-process `EventEmitter`) and `NetworkBroker` (Moleculer broadcast over NATS) implement `broadcast()` / `broadcastLocal()` / `broadcastToServices()`. Services subscribe with `this.onEvent(...)` and react to state changes asynchronously. The real-time client layer is driven by DDP streamers (`StreamerCentral`) that re-emit broker broadcasts to WebSocket subscribers — composing internal event-driven service coordination with external real-time push.

**Microkernel (secondary, 0.72):** The Apps Engine (`packages/apps-engine/`) implements a formal third-party plugin system. `AppManager` orchestrates app lifecycle (install, enable, disable, uninstall). A rich bridge layer (~20 bridge classes: `MessageBridge`, `RoomBridge`, `UserBridge`, `LivechatBridge`, `CommandBridge`, `SchedulerBridge`, `HttpBridge`, etc.) defines the stable API surface that third-party apps call. Apps run in a sandboxed Deno runtime (`packages/apps-engine/src/server/runtime/`), isolated from core internals. The slash command system (`app/slashcommands-*`) further demonstrates the extensibility-via-plugin pattern at the application level.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `LocalBroker` in-process event emitter | `packages/core-services/src/LocalBroker.ts` | Modular Monolith |
| ~97 feature modules sharing single MongoDB | `apps/meteor/app/` | Modular Monolith |
| `api.registerService()` + `isRunningMs()` dual-mode switch | `apps/meteor/server/startup/localServices.ts`, `server/lib/isRunningMs.ts` | Modular Monolith / Service-Based |
| `account-service`, `authorization-service`, `presence-service`, `ddp-streamer-service` | `ee/apps/*/src/service.ts`, `docker-compose-local.yml` | Service-Based |
| `NetworkBroker` wrapping Moleculer + NATS | `ee/packages/network-broker/src/NetworkBroker.ts` | Service-Based |
| All services share `MONGO_URL` — no separate data stores | `docker-compose-local.yml` | Service-Based (not Microservices) |
| `EventSignatures` with ~60+ typed domain events | `packages/core-services/src/events/Events.ts` | Event-Driven |
| `broadcast()` / `broadcastToServices()` on `IBroker` | `packages/core-services/src/lib/Api.ts` | Event-Driven |
| `NotificationsModule` with 15+ DDP streamers | `apps/meteor/server/modules/notifications/notifications.module.ts` | Event-Driven |
| `AppManager` + 20 bridge classes | `packages/apps-engine/src/server/AppManager.ts`, `server/bridges/` | Microkernel |
| Deno sandbox runtime for third-party apps | `packages/apps-engine/src/server/runtime/` | Microkernel |
| Prometheus metrics via `prom-client` | `apps/meteor/app/metrics/server/lib/metrics.ts` | Observability |
| OpenTelemetry OTLP tracing | `packages/tracing/src/index.ts` | Observability |

## Quality Attributes

- **Scalability:** Horizontal scaling via the TRANSPORTER env switch; `ddp-streamer-service` handles all WebSocket traffic independently of the core; NATS provides fan-out messaging for multi-node presence and notifications.
- **Deployability:** Single container for small deployments (Meteor monolith); multi-container topology for enterprise scale (Traefik + NATS + dedicated service containers); Docker Compose and Kubernetes supported.
- **Extensibility:** Apps Engine plugin system with Deno-sandboxed third-party apps, ~20 bridge interfaces, marketplace distribution; 20+ built-in slash command modules as first-class extensibility points.
- **Observability:** Prometheus metrics (`prom-client`) covering Meteor methods, callbacks, hooks, DDP sessions, and Livechat queues; OpenTelemetry OTLP distributed tracing across services.
- **Fault Tolerance:** `ServiceStarter` (used in `OmnichannelQueue`) with start/stop lifecycle; NATS transporter retries; health check endpoints (`/health`) on every service container; MongoDB replica set for data durability.
- **Modularity:** `core-typings`, `rest-typings`, `model-typings` packages enforce typed contracts between modules; `IBroker` abstraction enables runtime topology switching without code changes.

## Ruled Out

- **Microservices:** All service containers consume the same MongoDB instance — there is no per-service data store isolation. The shared data layer disqualifies true Microservices.
- **Layered:** Vertical feature organization dominates; cross-cutting dependencies between app modules (e.g., `RoomService` importing from `app/lib/server/functions/`) preclude strict horizontal layering.
- **CQRS / Event Sourcing:** No explicit command/query separation or event store pattern detected. MongoDB is used as a conventional mutable document store.
- **Hexagonal Architecture:** The federation service shows adapter patterns (`infrastructure/rocket-chat/adapters/`) but this is not applied consistently across the codebase as a whole.
