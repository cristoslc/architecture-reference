# Architecture Report: CockroachDB (cockroach)

**Date:** 2026-03-11
**Repo URL:** https://github.com/cockroachdb/cockroach
**Classification:** Layered, Modular Monolith
**Confidence:** 0.97

---

## Summary

CockroachDB is a cloud-native distributed SQL database built on a transactional and strongly-consistent key-value store. The codebase is organized as a classic **Layered Architecture** — SQL on top of KV on top of Replication/Consensus on top of Storage — each layer providing a clean abstraction interface to the one above it. This layering is explicitly called out in design documentation and is structurally enforced through Go package boundaries. The single-binary, homogeneous-node deployment model and the well-demarcated internal packages make **Modular Monolith** a strong secondary classification. All nodes run the same binary; no process-level service decomposition exists.

---

## Evidence from Code Exploration

### Repository Layout (top-level)

```
pkg/
  sql/         -- SQL layer: parsing, planning, optimization, execution
  kv/          -- KV client and kvserver (Raft, replication, range management)
  storage/     -- MVCC storage engine abstraction (backed by Pebble)
  raft/        -- Raft consensus implementation
  server/      -- Node server, API v2, admin, status
  gossip/      -- Cluster topology and state gossip
  rpc/         -- gRPC-based inter-node RPC
  multitenant/ -- Multi-tenancy abstractions
  jobs/        -- Background job scheduling and execution
  changefeed/  -- Change data capture (CDC) plumbing
  spanconfig/  -- Span configuration reconciliation
  ccl/         -- Commercial feature extensions (loaded via init() hooks)
  ...
```

### Layer Stack (from design.md)

The project's own `docs/design.md` explicitly states:

> "CockroachDB implements a layered architecture. The highest level of abstraction is the SQL layer... The SQL layer in turn depends on the distributed key value store, which handles the details of range addressing to provide the abstraction of a single, monolithic key value store."

The layers and their corresponding packages:

| Layer | Package(s) | Responsibility |
|---|---|---|
| Protocol / Client interface | `sql/pgwire/` | PostgreSQL wire protocol |
| SQL | `sql/` | Parse, plan (cost-based optimizer), DistSQL execution |
| KV Client | `kv/` | Transactional KV API, distributed batching |
| KV Server / Replication | `kv/kvserver/` | Raft consensus, range management, allocator |
| Consensus | `raft/` | Raft log, state machine |
| Storage Engine | `storage/` | MVCC, Pebble integration |

Dependency direction is strictly downward; `sql/` imports `kv/`, `kv/kvserver/` imports `storage/` and `raft/`, and so on.

### SQL Optimizer (Cascades-style, `pkg/sql/opt/`)

The `opt` package implements a Cascades-style cost-based query optimizer with eight distinct phases: Parse, Analyze, Prep, Rewrite, Search, Properties, Stats, and Cost Model. Its `doc.go` fully documents the pipeline and memo data structure. The optimizer generates physical plans for DistSQL execution — distributing computation across nodes close to data ranges.

### Distributed SQL (`pkg/sql/distsql/`, `pkg/sql/execinfra/`)

Query execution is distributed via DistSQL: a gateway node constructs a physical plan and ships sub-plans to remote nodes via gRPC `ScheduleFlows` RPCs. Worker processors (row-based and vectorized/columnar via `colexec/`) stream results back. This is a **pipeline** processing model internal to query execution, not a separate architectural style for the overall system.

### Raft Consensus (`pkg/raft/`, `pkg/kv/kvserver/`)

Each key-value range is replicated using Raft consensus. `pkg/raft/` is a standalone Raft implementation (derived from etcd's). The `kvserver` package drives it: manages range replicas, leases, and inter-node Raft message transport over gRPC.

### Storage (`pkg/storage/`)

The storage layer abstracts local engine access via the `Engine` interface backed by [Pebble](https://github.com/cockroachdb/pebble) (a LevelDB/RocksDB variant). It provides MVCC semantics over raw key-value bytes.

### Single Binary / Homogeneous Nodes

From `docs/design.md`:
> "CockroachDB nodes are symmetric; a design goal is homogeneous deployment (one binary) with minimal configuration and no required external dependencies."

All nodes run the same `cockroach` binary. Kubernetes deployment (`cloud/kubernetes/`) uses a StatefulSet of identical pods. There is no process-level service decomposition; no external message broker is required for core operation.

### Commercial Features (CCL)

`pkg/ccl/ccl_init.go` registers commercial features (multi-region, changefeeds, SQL proxy, OIDC, LDAP, etc.) via Go `import _` blank-import init-hooks — build-time inclusion, not runtime plugin loading. This is **not** Microkernel architecture.

### Changefeed / CDC

`pkg/ccl/changefeedccl/` implements Change Data Capture. Changefeeds stream KV mutations to external sinks (Kafka, GCS, Pulsar, SQL). This is an outbound feature, not a core architectural driver; the internal system is synchronous Raft-based request/response.

---

## Architecture Styles Identified

### Primary: Layered

- Explicitly documented in `docs/design.md` and `pkg/sql/opt/doc.go`.
- Five distinct horizontal strata: Protocol → SQL → KV → Raft/Replication → Storage.
- Dependency arrows flow strictly downward.
- Each layer exposes a clean interface to the layer above it (e.g., `kv.DB` for the SQL layer, `Engine` interface for the storage layer).
- Confidence: **0.97**

### Secondary: Modular Monolith

- Single deployable binary (`cockroach`) with 50+ well-bounded internal packages under `pkg/`.
- No inter-service network boundaries; all communication within a node is in-process via Go interfaces.
- Go's package system enforces module boundaries; explicit imports make dependencies visible.
- CCL commercial features are loaded at compile time via blank imports, not as separate services.
- Confidence: **0.92**

### Tertiary (pipeline, internal only): Pipeline

- DistSQL query execution uses a dataflow/pipeline model internally: logical plan → physical plan → processor DAG → streaming rows.
- This is an implementation detail of the SQL execution layer, not a system-wide architectural style.

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| **Fault Tolerance** | Raft consensus with configurable replication factor (N=2F+1); automatic range re-replication after node failure; no manual intervention required. |
| **Horizontal Scalability** | Adding nodes increases storage capacity and query throughput linearly; DistSQL pushes computation to data. |
| **Strong Consistency** | Serializable snapshot isolation (SSI) by default; single-key mutations are mediated by Raft; multi-range transactions use non-locking distributed commit. |
| **Survivability** | Tolerates disk, machine, rack, and datacenter failures; zone configurations allow cross-datacenter replication. |
| **Operational Simplicity** | Homogeneous one-binary deployment; auto-rebalancing via the allocator; minimal external dependencies. |
| **SQL Compatibility** | PostgreSQL wire protocol (`pgwire`) compatibility; full ANSI SQL with extensions. |
| **Observability** | Prometheus metrics export; distributed tracing (OpenTelemetry/gRPC interceptors); structured logging via `pkg/util/log`. |
| **Extensibility** | CCL commercial feature layer adds multi-tenancy, CDC, OIDC/LDAP, geo-partitioning without modifying OSS core. |

---

## Classification Reasoning

CockroachDB's architecture is unambiguously **Layered**. The design document, package structure, and dependency graph all corroborate a strict five-layer hierarchy (Protocol → SQL → KV → Consensus → Storage) where each layer depends only on the layer below it. This is not incidental — the Raft RFC and distributed SQL RFC both explicitly frame design decisions in terms of layer responsibility.

The **Modular Monolith** classification is equally well-supported: all functionality ships in a single binary, nodes are homogeneous, and module boundaries are enforced by Go packages rather than by network or process boundaries. This distinguishes it clearly from Microservices.

It is not Microservices (single binary, symmetric nodes), not Event-Driven (core path is synchronous Raft, not message-broker-mediated), not CQRS (no separate read/write models at the architectural level), and not Microkernel (CCL plugins are compile-time blanked imports, not runtime-loadable). The internal DistSQL pipeline pattern is an implementation technique within the SQL layer, not a system-wide Pipeline architecture.
