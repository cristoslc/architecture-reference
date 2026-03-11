# Architecture Report: Mattermost

**Date:** 2026-03-11
**Source URL:** https://github.com/mattermost/mattermost
**Classification:** Modular Monolith, Microkernel
**Confidence:** high

---

## Overview

Mattermost is an open-core, self-hosted collaboration platform providing team messaging, workflow automation, voice/video, and AI integration. It ships as a single Linux binary backed by PostgreSQL, with a React/Redux single-page application frontend. The repository is a monorepo containing the Go server (`server/`), React webapp (`webapp/`), and API specifications (`api/`).

---

## Repository Structure

```
mattermost/
├── server/                         # Go backend (single deployable binary)
│   ├── channels/                   # Core product domain
│   │   ├── api4/                   # REST API handlers (HTTP routing layer)
│   │   ├── app/                    # Business logic layer (App, Server, Channels structs)
│   │   │   ├── platform/           # Infrastructure services (Hub, WebSocket, cluster)
│   │   │   ├── email/              # Email subsystem
│   │   │   ├── users/              # User subdomain
│   │   │   ├── teams/              # Team subdomain
│   │   │   └── jobs/               # Background job framework + workers
│   │   ├── store/                  # Storage abstraction layer
│   │   │   ├── sqlstore/           # PostgreSQL implementation
│   │   │   ├── localcachelayer/    # In-memory caching decorator
│   │   │   ├── retrylayer/         # Retry decorator
│   │   │   ├── searchlayer/        # Elasticsearch decorator
│   │   │   └── timerlayer/         # Metrics/timing decorator
│   │   ├── wsapi/                  # WebSocket API handlers
│   │   └── web/                    # HTTP static serving + web handler
│   ├── einterfaces/                # Enterprise interface contracts (plugin points)
│   ├── enterprise/                 # Enterprise feature implementations (loaded at binary link time)
│   ├── platform/
│   │   ├── services/               # Platform-level services (cache, search, telemetry, remotecluster)
│   │   └── shared/                 # Shared utilities (filestore, mail, templates)
│   └── public/                     # Public SDK / plugin API surface
│       ├── model/                  # Shared domain model types
│       ├── plugin/                 # Plugin host SDK (hooks protocol, RPC bridge)
│       └── pluginapi/              # Plugin helper client API
├── webapp/
│   ├── channels/src/               # React SPA (components, actions, reducers, selectors)
│   └── platform/
│       ├── mattermost-redux/       # Redux state management library
│       ├── client/                 # REST + WebSocket client
│       └── types/                  # Shared TypeScript types
└── api/                            # OpenAPI specifications (v4, playbooks)
```

---

## Architectural Layers (Server)

The server exhibits a clear, enforced separation into four horizontal layers:

| Layer | Package | Responsibility |
|---|---|---|
| HTTP/WS API | `channels/api4`, `channels/wsapi` | Request routing, auth, serialization |
| Application | `channels/app` | Business logic, domain operations, orchestration |
| Platform | `channels/app/platform`, `platform/services` | Infrastructure: WebSocket hub, cluster, cache, filestore, search |
| Store | `channels/store` | Storage interface + SQL + decorator chain |

The `App` struct is explicitly documented as a "pure functional, request-scoped component" that holds no state of its own — it delegates to `Channels` (long-lived domain state) and `Server` (infrastructure). This is a textbook layered architecture with strict downward dependency flow.

### Store Decorator Chain

The store layer uses a chain of decorators applied at startup:

```
sqlstore → localcachelayer → searchlayer → retrylayer → timerlayer → (app)
```

Each decorator wraps the `Store` interface, adding caching, Elasticsearch routing, retry logic, and Prometheus timer instrumentation without modifying the core SQL implementation.

---

## Microkernel Pattern (Plugin System)

The plugin architecture is the second dominant pattern. The `server/public/plugin` package defines:

- **49 hook event IDs** (`OnActivateID` through `TotalHooksID`) that any plugin may subscribe to.
- An RPC bridge (`client_rpc.go`, `supervisor.go`) allowing plugins to run as isolated subprocesses communicating via gRPC-like channels.
- A `plugin.Environment` runtime that manages plugin lifecycle, health checks, and hook dispatch.

Enterprise features (`einterfaces/`) follow the same contract pattern: they define Go interfaces (`ClusterInterface`, `ComplianceInterface`, `LdapInterface`, `DataRetentionInterface`, etc.) that are injected into the `Channels` and `Server` structs at startup. Implementations are linked in via the `server/enterprise/` package at compile time (open-core model).

This gives Mattermost a microkernel topology: a stable core runtime with extension points for both open-source plugins (isolated processes, RPC) and enterprise modules (compiled-in interface implementations).

---

## Event-Driven Patterns (WebSocket)

While not a standalone Event-Driven architecture, Mattermost uses event-driven messaging internally for real-time delivery:

- The `Hub` struct in `channels/app/platform/web_hub.go` is the central WebSocket connection manager, running a dedicated goroutine per hub instance (sharded by CPU count × 4).
- `model.WebSocketEvent` defines ~50 named event types (`posted`, `channel_created`, `user_updated`, etc.) broadcast to connected clients.
- The `Publish` method propagates events through the hub to all relevant `WebConn` instances.
- In clustered mode, `ClusterInterface.SendClusterMessage` fans events across nodes.

The plugin hooks (`MessageWillBePosted`, `MessageHasBeenPosted`, etc.) further use an event-notification model internally, but these are synchronous within a single request rather than asynchronous queue-based messaging.

---

## Background Jobs

A custom job framework in `channels/jobs/` provides worker + scheduler pairs for long-running tasks:

- Elasticsearch indexing, data retention, compliance export, LDAP sync, product notices, recap generation, S3 migration, materialized view refresh, and more (~25 job types).
- Workers implement `model.Worker` interface; schedulers trigger them on cron-like intervals.
- Jobs persist state in the database, providing durability and crash recovery.

This is a standard batch pipeline within the monolith rather than a separate pipeline architecture.

---

## Frontend Architecture

The React webapp follows a Redux-based layered architecture:

- **Components** (`channels/src/components/`) — presentational and container components.
- **Actions** (`channels/src/actions/`) — Redux action creators, side effects via thunks.
- **Reducers** (`channels/src/reducers/`) — immutable state updates.
- **Selectors** — memoized state projections.
- **Plugin registry** (`channels/src/plugins/registry.ts`) — a client-side plugin extension system mirroring the server-side microkernel concept.

The webapp communicates with the server exclusively via REST (v4 API) and WebSocket. There is no server-side rendering.

---

## AI / Agents Integration

The `channels/app/agents.go` file introduces an AI bridge pattern: the `mattermost-ai` plugin (v1.5.0+) is treated as a first-class extension point. The `GetBridgeClient` and `GetAgents` APIs delegate AI operations to the plugin via RPC, keeping AI concerns entirely outside the core monolith. This is an extension of the existing microkernel pattern rather than a distinct multi-agent architecture.

---

## Deployment Topology

- **Single binary**: All channels, jobs, API, and WebSocket are served from one process.
- **Horizontal scaling**: Multiple instances are supported via `ClusterInterface` (gossip via memberlist, `hashicorp/memberlist` dependency visible in `go.mod`). Leader election is provided for scheduled jobs and shared channel sync.
- **Database**: PostgreSQL only (MySQL support was dropped). Redis is not a hard dependency; the in-process cache layer handles most caching.
- **File storage**: Abstracted via `filestore.FileBackend`, supporting local disk, S3-compatible stores, and Azure Blob.

---

## Classification Reasoning

**Primary: Modular Monolith** — The server runs as a single deployable process with a strongly enforced four-layer architecture (API → App → Platform → Store). Internal modules (channels, jobs, platform services, enterprise features) are well-separated by package boundaries and explicit interface contracts but are not independently deployable. The decorator chain on the store layer and the use of interface injection throughout reflect deliberate modular design within a monolith.

**Secondary: Microkernel** — The plugin system is a first-class architectural concern, providing a stable core runtime with 49 hook points, isolated subprocess plugins via RPC, and enterprise feature injection via `einterfaces`. This is the canonical microkernel pattern applied to an application platform.

Event-driven WebSocket broadcast and the job framework are significant internal mechanisms but are not sufficient to classify this as a primary Event-Driven or Pipeline architecture — they serve the monolith's real-time delivery and background processing needs rather than defining the overall system decomposition.

---

## Quality Attributes

- **Extensibility**: Plugin hooks and enterprise interfaces allow deep customization without forking core.
- **Scalability**: Horizontal clustering via gossip protocol; sharded WebSocket hub.
- **Reliability**: Retry decorator on store, persistent job state, WebSocket reconnect with reliable message queuing.
- **Observability**: Prometheus metrics via timer layer decorator; Sentry error tracking; structured logging via `mlog`.
- **Portability**: Single binary deployment; file storage and config backend are pluggable.
- **Maintainability**: Strong package-boundary enforcement; generated timer/retry layers reduce boilerplate; extensive test coverage.
- **Security**: SAML, LDAP, MFA, OAuth2, rate limiting, content flagging, and IP filtering all implemented as interface-injected or built-in layers.
