---
project: "Pachyderm"
date: 2026-03-11
scope: platform
use-type: production
primary-language: Go
confidence: 0.91
styles:
  - name: Pipeline
    role: primary
    confidence: 0.93
  - name: Modular Monolith
    role: primary
    confidence: 0.87
  - name: Event-Driven
    role: secondary
    confidence: 0.74
---

# Architecture Analysis: Pachyderm

## Metadata

| Field | Value |
|---|---|
| Project | Pachyderm |
| Repo | https://github.com/pachyderm/pachyderm |
| Date | 2026-03-11 |
| Scope | platform |
| Use-type | production |
| Primary Language | Go |
| Other Languages | Python, TypeScript, JavaScript |

## Style Rationales

**Pipeline (primary, 0.93):** Pachyderm's central abstraction is the data pipeline — a directed acyclic graph of user-defined transform stages connected through versioned PFS (Pachyderm File System) repositories. The pipeline controller in `src/server/pps/server/pipeline_controller.go` manages pipeline lifecycle state machines, and workers subscribe to jobs via `SubscribeJob` gRPC streaming (`src/server/worker/pipeline/transform/transform.go`). Each pipeline stage consumes a specific set of input repos and commits exclusively to its own output repo; the `src/server/pfs/server/master_trigger.go` implements a trigger-chain mechanism that fires downstream stages when upstream commits satisfy size/time/count thresholds. The datum model in `src/server/worker/datum/` partitions input file sets into parallelizable work units, driving the MapReduce-style horizontal scaling of each pipeline stage. PPS (Pipeline Processing Service) and PFS (Pachyderm File System) enforce a strict one-way flow: data lands in PFS repos, triggers are evaluated, PPS schedules jobs, worker pods process datums, and results commit back into output repos — a canonical multi-stage pipeline topology.

**Modular Monolith (primary, 0.87):** All functional areas — PFS, PPS, Auth, Identity, Transaction, Proxy, Enterprise, License, PJS (Pipeline Job Scheduler), Snapshot, Storage, Debug, Admin, Logs, and Metadata — are compiled and deployed as a single binary (`pachd`) through the `src/internal/pachd/full.go` builder, which registers all gRPC API servers in-process via a structured builder pattern. The `src/internal/serviceenv/service_env.go` `ServiceEnv` interface is the shared dependency container binding all services together inside the monolith. Internal cross-service calls are direct Go interface calls, not network hops. Domain boundaries are well-demarcated: each service lives in its own `src/server/<service>/` tree with a public proto contract under `src/<service>/`, an internal interface in `src/server/<service>/iface.go`, and server implementations under `src/server/<service>/server/`. The `src/internal/` tree contains shared infrastructure (`pachsql`, `collection`, `task`, `transactionenv`, `storage`, `grpcutil`, `middleware`) preventing duplication across services. The single Helm chart (`etc/helm/pachyderm/`) deploys the monolith as one Kubernetes deployment, with `pachw` as a separately scalable worker pool mode of the same binary.

**Event-Driven (secondary, 0.74):** Pachyderm uses commit-triggered reactive propagation as its primary coordination signal rather than a standalone message broker. The PFS PostgreSQL-backed collection listener (`src/internal/collection/postgres_listener.go`) implements a `PostgresListener` / `Notifier` interface that receives LISTEN/NOTIFY events from PostgreSQL for state-change propagation. Pipeline workers subscribe to job state changes via the `SubscribeJob` gRPC streaming RPC and commit state changes via `SubscribeCommit`. The PPS master (`src/server/pps/server/master.go` and `poller.go`) runs dedicated watcher goroutines — `watchPipelines`, `pollPipelines`, `pollPipelinePods` — that react to pipeline and pod state-change events via Kubernetes watch streams and internal DB watches. Branch triggers (`src/server/pfs/server/master_trigger.go`) recursively fire based on commit events. However, there is no external message broker (no Kafka, RabbitMQ, or NATS); the event transport is Postgres LISTEN/NOTIFY and etcd watches, making this reactive event routing secondary to the pipeline topology.

## What Was Rejected and Why

**Not Microservices:** PFS, PPS, Auth, Identity, Transaction, and all other services are compiled into and served from a single `pachd` binary. They share a single PostgreSQL database and etcd cluster. Cross-service calls go through in-process Go interfaces (the `ServiceEnv` contract), not network boundaries. Pipeline worker Kubernetes pods are not separate services — they run the same binary in `sidecar` mode.

**Not Service-Based:** No independent deployable units with separate data stores per service. The `pachw` worker pool is a horizontally scaled mode of the same binary, not a separate service.

**Not Hexagonal Architecture:** While interfaces are used at service boundaries (`iface.go` files), the codebase is not structured around inward-facing domain ports with outward-facing adapters. The `src/internal/` infrastructure layer is shared code, not adapter wiring.

**Not Microkernel:** There is no runtime plugin system. Services are statically compiled into the daemon. Pipeline container images are user-supplied, but the architectural core (PFS, PPS, gRPC layer) is not extended through a formal plugin contract.

## Quality Attributes Evidence

**Scalability:** Datum-level parallelism distributes work across dynamically scaled Kubernetes ReplicationControllers (one per pipeline). The `pachw` controller (`src/server/pachw/server/pachw.go`) auto-scales a pool of storage-worker replicas based on task queue depth. PJS (Pipeline Job Scheduler) in `src/internal/pjs/` provides a second-generation task queuing layer with namespace/group-based fair scheduling.

**Data Lineage & Reproducibility:** Every commit in PFS records `direct_provenance` (parent commits by branch), enabling full data lineage walks via `WalkCommitProvenance` and `WalkBranchProvenance` RPCs. Immutable content-addressed storage with deduplication at the chunk level (`src/internal/storage/chunk/`) ensures any past pipeline output can be reconstructed.

**Reliability:** The PPS master uses distributed locks via etcd (`dlock` package) to ensure a single master drives pipeline state transitions. Worker lifecycle is managed with monitor goroutines for crash detection and standby transitions. Transaction support (`src/server/transaction/`, `src/internal/transactionenv/`) allows atomic batching of PFS and PPS operations.

**Extensibility:** Multiple deployment modes (`full`, `enterprise`, `sidecar`, `pachw`, `paused`, `preflight`, `restore`) use the same binary with different service registration subsets. The Helm chart exposes pachw as a separately tunable worker pool.

**Observability:** Jaeger distributed tracing (`src/internal/tracing/`), Prometheus metrics (`src/internal/promutil/`, `src/server/worker/stats/`), Loki log aggregation (`src/internal/lokiutil/`), and structured logging with `go.uber.org/zap` are used throughout. The `debug` server provides cluster-wide diagnostics.

**Portability:** Storage is abstracted via the `obj.Bucket` interface (`src/internal/obj/`) supporting GCS, S3, Azure Blob, and MinIO. The Helm chart supports `GOOGLE`, `AMAZON`, `MINIO`, `MICROSOFT`, `CUSTOM`, and `LOCAL` deploy targets.
