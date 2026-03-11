# self-hosted — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/getsentry/self-hosted
**Classification:** Service-Based + Event-Driven
**Confidence:** 0.91

## Summary

Sentry self-hosted is a Docker Compose deployment package that assembles the full Sentry observability stack from independently developed, purpose-built services. The dominant pattern is Service-Based: five coarse-grained application services (Sentry web/workers, Snuba, Relay, Symbolicator, Vroom) share infrastructure databases (PostgreSQL, Redis, ClickHouse) and are deployed together as a single unit via `install.sh` + `docker-compose.yml`. Kafka is the structural backbone of all inter-service event flow, making Event-Driven a strong secondary style. This repository is not the Sentry application source code — it is the operational packaging and deployment layer that composes separately maintained upstream images into a runnable self-hosted instance.

## Evidence

### Repository Structure

```
docker-compose.yml        # 857-line orchestration manifest defining all services
install.sh                # Main installer (sources ~20 install/ subscripts)
install/                  # Step-by-step install scripts (volumes, migrations, secrets…)
sentry/                   # Sentry Docker build context + sentry.conf.example.py
  Dockerfile
  sentry.conf.example.py  # Django settings override for self-hosted
  entrypoint.sh
relay/                    # Relay config (config.example.yml)
clickhouse/               # ClickHouse Docker build context + config.xml
symbolicator/             # Symbolicator config (config.example.yml)
nginx.conf                # Reverse proxy routing: /api/* → relay, / → sentry web
cron/                     # Cleanup cron Dockerfile (sentry-cleanup, vroom-cleanup)
optional-modifications/   # Community patch system for configuration overrides
geoip/                    # MaxMind GeoLite2 database
redis.conf                # Redis configuration
```

### Services Defined in docker-compose.yml

The manifest defines more than 60 container instances across ~10 logical service boundaries:

| Service Group | Containers | Role |
|---|---|---|
| **Sentry** | `web`, `events-consumer`, `attachments-consumer`, `post-process-forwarder-*`, `subscription-consumer-*`, `taskworker`, `taskscheduler`, `sentry-cleanup` | Core Django app: HTTP API, Kafka consumers, task execution |
| **Relay** | `relay` | Event ingestion frontend; validates, filters, and forwards events to Kafka |
| **Snuba** | `snuba-api`, `snuba-*-consumer` (20+ variants), `snuba-replacer`, `snuba-subscription-consumer-*` | Event search/analytics layer over ClickHouse |
| **Symbolicator** | `symbolicator`, `symbolicator-cleanup` | Stack trace symbolication service |
| **Vroom** | `vroom`, `vroom-cleanup` | Session replay / profiling processing |
| **Taskbroker** | `taskbroker` | SQLite-backed Kafka task activation broker |
| **Uptime Checker** | `uptime-checker` | Synthetic uptime monitoring |
| **Infrastructure** | `kafka`, `clickhouse`, `postgres`, `pgbouncer`, `redis`, `memcached`, `seaweedfs`, `smtp`, `nginx` | Shared data and network infrastructure |

### Key Architectural Files

**`docker-compose.yml`** — The definitive structural artefact. Key observations:
- `x-sentry-defaults` anchor: all Sentry-family containers share a single `sentry-self-hosted-local` image and are differentiated only by their `command` (`run web`, `run consumer ingest-events`, `run taskworker`, etc.). This is a single codebase deployed as multiple specialized process roles — characteristic of Service-Based, not Microservices.
- Shared infrastructure is explicit: every `sentry` container depends on `redis`, `kafka`, `pgbouncer`, `memcached`, and `seaweedfs`. Every `snuba` container depends on `clickhouse`, `kafka`, and `redis`. No service owns its own data store exclusively.
- `profiles: [feature-complete]` gates advanced consumers (transactions, metrics, replays, profiling, monitors, uptime). The baseline profile provides error monitoring only.
- `taskbroker` uses SQLite (`/opt/sqlite/taskbroker-activations.sqlite`) as a local activation store, bridging Kafka task delivery to `taskworker` gRPC calls.

**`sentry/sentry.conf.example.py`** — Django settings for self-hosted. Key signals:
- `SENTRY_EVENTSTREAM = "sentry.eventstream.kafka.KafkaEventStream"` — all events are written to Kafka topics first; consumers read from those topics asynchronously.
- `SENTRY_NODESTORE = "sentry_nodestore_s3.S3PassthroughDjangoNodeStorage"` pointing to `seaweedfs:8333` — raw event blobs stored in S3-compatible object storage, not PostgreSQL.
- `SENTRY_SEARCH = "sentry.search.snuba.EventsDatasetSnubaSearchBackend"` — search delegated to Snuba (ClickHouse-backed), not Postgres full-text search.
- Redis used for cache, rate limiting, buffers, quotas, TSDB, and digest backends — a heavily shared coordination layer.
- `KAFKA_CLUSTERS["default"]` with `bootstrap.servers: "kafka:9092"` is the sole inter-service communication medium between Relay, Sentry, and Snuba.

**`relay/config.example.yml`** — Relay configuration:
- `upstream: "http://web:9000/"` — Relay authenticates against Sentry web and forwards metadata.
- `processing.enabled: true` with `kafka_config` — Relay publishes accepted events directly to Kafka, bypassing Sentry web for the hot write path.
- Relay is the edge ingestion service; clients send to Relay, not directly to Sentry.

**`nginx.conf`** — Reverse proxy routing:
- `/api/store/` and `/api/[1-9]\d*/` → `relay:3000` (SDK event ingestion)
- `/api/0/relays/` → `relay:3000` (Relay registration)
- `/` → `web:9000` (Sentry web UI and management API)
- This routing separates the read-heavy UI path from the write-heavy ingestion path at the network edge.

**`optional-modifications/patches/`** — A diff-based patch system for configuration customization (e.g., `external-kafka`). Patches modify `docker-compose.yml`, `.env`, and `sentry.conf.example.py` to redirect to external infrastructure. This is an operational extensibility mechanism, not a runtime plugin architecture.

### Event Flow

```
SDK clients
    │
    ▼
nginx (port 80)
    ├─ /api/{n}/*  → relay:3000
    └─ /           → web:9000
         │
         ▼
      Relay
  (validates + enriches)
         │
         ▼
      Kafka  ◄────────────── Sentry web (eventstream writes)
         │
         ├──► snuba-*-consumer → ClickHouse (event analytics store)
         ├──► events-consumer (Sentry) → PostgreSQL (issue/group mutations)
         ├──► post-process-forwarder-* (Sentry) → alerts, notifications, plugins
         ├──► attachments-consumer (Sentry) → SeaweedFS blob storage
         ├──► taskbroker → taskworker (async task execution)
         └──► vroom (profiling) → SeaweedFS profiles bucket
```

### Patterns Found

**Service-Based (Primary Style)**

The architecture fits the Service-Based definition: a small number of coarse-grained services sharing databases, deployed as a coordinated unit.

- Five named application services (Sentry, Snuba, Relay, Symbolicator, Vroom) map cleanly to Service-Based's "2–9 services" criterion.
- Services share PostgreSQL (via PgBouncer), Redis, ClickHouse, Kafka, and SeaweedFS — no database-per-service isolation.
- Deployment is a single `docker-compose up`; no independent release or version lifecycle per service.
- Sentry spawns many process-role containers from one image (web, consumer, worker, scheduler, cleanup) — process segmentation within one service, not separate services.
- Snuba spawns 20+ typed consumer containers from one image — same pattern, typed by `--storage` flag.

**Event-Driven (Strong Secondary Style)**

Kafka is not optional or peripheral; it is structurally central to all cross-service data flow:

- Relay produces to Kafka; all Sentry and Snuba consumers read from Kafka. No direct Relay-to-Sentry or Relay-to-Snuba HTTP calls exist on the data path.
- `SENTRY_EVENTSTREAM = "sentry.eventstream.kafka.KafkaEventStream"` makes Kafka the mandatory write path for event ingestion.
- Snuba's entire purpose is Kafka consumption: every `snuba-*-consumer` is a dedicated Kafka consumer writing a specific event type to a ClickHouse storage.
- `post-process-forwarder-*` consumers synchronize with Snuba commit logs before triggering downstream actions — a distributed event coordination pattern.
- Subscription consumers (`snuba-subscription-consumer-*`, `subscription-consumer-events`) implement real-time alert evaluation via Kafka-coordinated scheduler-executor pairs.
- `taskbroker` routes Kafka task messages to `taskworker` via gRPC, making async work dispatch event-driven end-to-end.

**Pipeline (Internal Pattern)**

The event ingest path is a sequential pipeline: SDK → Relay (validate/enrich) → Kafka (buffer) → consumer (parse/normalize) → storage (ClickHouse/Postgres). Each stage is a discrete transformation step, though the pipeline is encoded in Kafka topic routing rather than an explicit pipeline framework.

### What This Is NOT

- **Not Microservices**: Services share databases (PostgreSQL, Redis, ClickHouse, Kafka) and cannot be deployed, versioned, or scaled independently. There is no service registry, no mTLS service mesh, no independent schema ownership. The `docker-compose.yml` is one monolithic deployment descriptor.
- **Not Modular Monolith**: This repository contains no application source code. It is a deployment and configuration package that references upstream images. The Sentry application monolith lives in `getsentry/sentry`; this repo assembles pre-built images.
- **Not Microkernel**: The `optional-modifications/patches/` system applies configuration diffs at install time, not runtime extensions loaded by a kernel. There is no plugin host process.
- **Not Serverless**: All services are long-running Docker containers with persistent volumes.
- **Not Space-Based**: No in-memory data grid, no processing units with local tuple-space partitioning.
- **Not Layered**: The architecture is organized around service boundaries and event flow, not horizontal presentation/business/data layers.

## Quality Attributes

- **Reliability**: Kafka provides durable event buffering across all service boundaries; PgBouncer handles connection pooling to prevent PostgreSQL exhaustion; Redis buffers protect the database from high-frequency counter updates; health checks on every container with configurable retry/interval policies; `taskbroker` SQLite store preserves in-flight tasks across restarts.
- **Scalability**: Consumer containers can be horizontally scaled by adding replicas behind the same Kafka consumer group; `--concurrency` flag on `taskworker` allows vertical scaling of task throughput; `COMPOSE_PROFILES=feature-complete` gates advanced consumers so baseline deployments are lighter; SeaweedFS provides scalable S3-compatible blob storage with configurable replication.
- **Operability**: `install.sh` automates the full lifecycle (volume creation, DB migrations, secret generation, snuba bootstrap, ClickHouse upgrades); `sentry-admin.sh` provides admin CLI access; `scripts/backup.sh` and `scripts/restore.sh` handle data backup; statsd integration available for all named services (Relay, Snuba, Symbolicator, Sentry) via `STATSD_ADDR` environment variable.
- **Deployability**: Single-command install (`./install.sh`) and start (`docker compose up -d`); `optional-modifications/patches/` allow site-specific configuration overrides without forking; `COMPOSE_PROFILES` enables staged feature enablement (errors-only vs. feature-complete); Docker Compose health-check dependency graph ensures correct startup ordering.
- **Observability**: Structured health checks on all containers; statsd metrics emitted by Relay, Snuba, Symbolicator, and Sentry web; Kafka commit-log synchronization (`snuba-commit-log`) provides cross-service processing visibility; GeoIP enrichment via MaxMind integrated into Relay.
- **Security**: Relay validates and authenticates SDK clients before events enter the Kafka pipeline; nginx terminates external HTTP and enforces routing; PgBouncer isolates the database connection pool; `SENTRY_DISALLOWED_IPS` prevents SSRF; CSRF protection via Django 4 middleware; support for custom CA certificates and TLS.
- **Maintainability**: Upstream images are versioned and pulled from registries (no application code modified); patch system provides clean extension points without forking; environment variable-driven configuration (`SENTRY_EVENT_RETENTION_DAYS`, `SENTRY_SYSTEM_SECRET_KEY`, `COMPOSE_PROFILES`) separates deployment policy from configuration schema.
