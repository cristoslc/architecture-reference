---
project: "analytics"
date: 2026-03-10
scope: application
use-type: production
primary-language: Elixir
confidence: 0.93
styles:
  - name: Modular Monolith
    role: primary
    confidence: 0.92
  - name: Layered
    role: secondary
    confidence: 0.88
  - name: Pipeline
    role: secondary
    confidence: 0.78
---

# Architecture Analysis: Plausible Analytics

## Metadata

| Field | Value |
|---|---|
| Project | Plausible Analytics |
| Repo | https://github.com/plausible/analytics |
| Date | 2026-03-10 |
| Scope | application |
| Use-type | production |
| Primary Language | Elixir |
| Other Languages | JavaScript, TypeScript |

## Style Rationales

**Modular Monolith (primary, 0.92):** A single OTP application (`:plausible`) ships as one Elixir release (one `Dockerfile`, one `mix release plausible`). Internally, `lib/plausible/` is partitioned into ~20 vertical domain modules — `auth/`, `billing/`, `teams/`, `sites/`, `stats/`, `ingestion/`, `shield/`, `goals/`, `segments/`, `imported/`, `session/`, `plugins/`, `google/`, `s3/`, etc. — each encapsulating its own business logic, Ecto schemas, and often its own repository access. Modules communicate through direct function calls with no service boundary or API gateway. `Plausible.Application` assembles all supervisors at startup from a single OTP entry point.

**Layered (secondary, 0.88):** A clear horizontal three-layer separation runs across the entire codebase: `lib/plausible_web/` (Phoenix controllers, plugs, LiveViews, router, email templates) is the presentation layer; `lib/plausible/` contains all domain logic; and a data-access sublayer is expressed through four specialised Ecto repos — `Plausible.Repo` (PostgreSQL: accounts, sites, billing), `Plausible.ClickhouseRepo` (ClickHouse reads), `Plausible.IngestRepo` (ClickHouse writes), and `Plausible.AsyncInsertRepo`. Each layer calls downward only; web controllers call domain contexts, which call repos.

**Pipeline (secondary, 0.78):** `Plausible.Ingestion.Event.pipeline/0` defines a named, ordered list of filter/transform steps (`drop_verification_agent`, `drop_datacenter_ip`, `drop_threat_ip`, `drop_shield_rule_hostname`, `drop_shield_rule_page`, `drop_shield_rule_ip`, `put_geolocation`, `drop_shield_rule_country`, `put_user_agent`, `put_basic_info`, `put_source_info`, `maybe_infer_medium`, `put_props`, `put_revenue`, `put_salts`, `put_user_id`, `validate_clickhouse_event`, `register_session`). `process_unless_dropped/3` executes them with `Enum.reduce_while/3`, short-circuiting on drop. Events flow through the pipe into `WriteBuffer` GenServers that batch-flush RowBinary to ClickHouse.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| Single OTP app `Plausible.Application`, one release `plausible` | `lib/plausible/application.ex`, `mix.exs` | Modular Monolith |
| ~20 vertical domain modules in `lib/plausible/` | `lib/plausible/{auth,billing,teams,sites,stats,ingestion,shield,goals,...}` | Modular Monolith |
| CE/EE macro `on_ee`/`on_ce` for single-codebase edition variants | `lib/plausible.ex`, throughout | Modular Monolith |
| `PlausibleWeb` presentation layer (controllers, live, plugs, router) | `lib/plausible_web/` | Layered |
| 4 specialised Ecto repos: Repo, ClickhouseRepo, IngestRepo, AsyncInsertRepo | `lib/plausible/{repo,clickhouse_repo,ingest_repo,async_insert_repo}.ex` | Layered |
| 18-step named ingestion pipeline with `reduce_while` short-circuit | `lib/plausible/ingestion/event.ex` | Pipeline |
| `WriteBuffer` GenServer batching RowBinary flushes to ClickHouse | `lib/plausible/ingestion/write_buffer.ex` | Pipeline |
| `Persistor` with pluggable backends: `Embedded`, `Remote`, `EmbeddedWithRelay` | `lib/plausible/ingestion/persistor/` | Pipeline |
| Oban workers for async background jobs | `lib/workers/` (21 worker modules) | Modular Monolith |
| Cache warming system (`Plausible.Cache.Warmer`) for shields, sessions, sites | `lib/plausible/cache/`, `application.ex` | Layered |
| OpenTelemetry + PromEx instrumentation | `lib/plausible/open_telemetry.ex`, `lib/plausible/prom_ex.ex` | Observability |
| `libcluster` for Erlang host clustering (EE only) | `mix.exs`, `application.ex` | Scalability |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Deployability** | Single Docker image (`alpine`-based multistage build), single `mix release plausible`; CE and EE editions compiled from the same source via `MIX_ENV`; self-hostable without external orchestration |
| **Modularity** | ~20 domain modules in `lib/plausible/` with internal encapsulation; four Ecto repos provide clean data-access boundaries; Oban workers isolated in `lib/workers/` |
| **Scalability** | ClickHouse for high-volume event and session storage; `WriteBuffer` GenServer batch-flushing RowBinary reduces write pressure; ELT per-user hash routing in `Persistor`; `libcluster` Erlang host clustering for EE; partitioned `Task.Supervisor` for UA parsing |
| **Observability** | OpenTelemetry (Cowboy, Phoenix, Ecto, Oban); PromEx with Prometheus metrics; telemetry events for every pipeline step (`:plausible, :ingest, :pipeline, :step`), every buffered/dropped event, and UA parse timeouts |
| **Evolvability** | `on_ee`/`on_ce` compile-time macros allow safe divergence of CE and EE features in a single codebase; `fun_with_flags` feature flag library; pluggable `Persistor` backends via configuration; legacy tracker script variants generated from the same source |
| **Fault Tolerance** | OTP supervision tree (`one_for_one` root supervisor); `WriteBuffer` traps exits and flushes on shutdown; `Plausible.Session.Transfer` for session handoff; rate limiting via `Plausible.RateLimit`; Sentry error reporting; Oban job retry semantics |

## Domain

Web analytics. Core domains: event ingestion (tracker JS → Phoenix ingest → ClickHouse), session management, stats query and aggregation, site management, team/user auth, billing (Paddle), traffic shielding, data import/export, and a REST Plugins API.

## Production Context

- Deployed as a single Elixir release; self-hostable via Docker; cloud offering at `plausible.io`
- Dual database: PostgreSQL for transactional/relational data (accounts, sites, teams, billing) and ClickHouse for all event/session analytics data
- Tracker JS (`tracker/`) builds 1000+ script variants from a single source via `rollup` + `@swc/core`; served dynamically with per-site configuration interpolated at the endpoint
- EE clustering via `libcluster` (Erlang host strategy); CE runs standalone with optional HTTPS via `site_encrypt`
