# Architecture Report: Dragonfly

**Date:** 2026-03-11
**Source URL:** https://github.com/dragonflydb/dragonfly
**Classification:** Modular Monolith (primary), Layered (secondary)
**Confidence:** 0.96
**Model:** claude-sonnet-4-6

---

## Summary

Dragonfly is a high-performance, Redis/Memcached-compatible in-memory data store that deploys as a single binary process. Its architecture is a textbook **Modular Monolith**: one deployable unit composed of explicitly bounded, independently compilable modules with enforced dependency rules. A secondary **Layered** pattern organizes the codebase top-to-bottom from protocol handling through business logic down to custom data-structure primitives. The signature internal innovation is a shared-nothing, thread-per-core execution model that partitions all mutable database state across per-thread shards, using only message passing (via Boost.Fibers) for inter-thread coordination—no mutex locks on the data path.

---

## Evidence

### 1. Single Deployable Unit

The root `src/server/CMakeLists.txt` produces one executable:

```cmake
add_executable(dragonfly dfly_main.cc version_monitor.cc)
cxx_link(dragonfly base dragonfly_lib)
```

There is no container orchestration, no service mesh, and no inter-process communication. The entire system runs in a single OS process.

### 2. Enforced Module Boundaries (Modular Monolith)

The codebase is partitioned into four CMake library targets with strict, documented dependency rules:

| Target | Role |
|---|---|
| `dfly_facade` | TCP connection handling, Redis/Memcache protocol parsing |
| `dfly_core` | Custom data structures (DashTable, compact objects, sorted maps, Lua interpreter) |
| `dfly_transaction` | Transaction framework, db_slice, blocking controller, journaling |
| `dragonfly_lib` | Command families (server business logic), replication, RDB persistence |

The `src/facade/README.md` enforces the boundary explicitly:

> "It should be separated from the rest of dragonfly server logic and should be self-contained, i.e no redis-lib or server dependencies are allowed."

This is the canonical sign of a Modular Monolith: module contracts enforced at build time, not only by convention.

### 3. Layered Architecture (Secondary Pattern)

The source tree follows a strict vertical layering strategy:

```
src/
├── facade/       Layer 1 — Network/protocol (Redis RESP, Memcache parsers, TLS, connections)
├── core/         Layer 2 — Data-structure primitives (DashTable, compact_object, tx_queue)
├── server/       Layer 3 — Business logic (command families, transactions, ACL, replication)
│   ├── cluster/  Sub-layer — Cluster coordination and slot migration
│   ├── journal/  Sub-layer — Write-ahead journaling for replication
│   ├── tiering/  Sub-layer — Async disk tiering for values that spill from RAM
│   └── search/   Sub-layer — Full-text / vector search index (FT.SEARCH commands)
└── redis/        Layer 4 — Redis compatibility shims
```

Each layer depends only on lower layers; upper layers are never imported by lower ones.

### 4. Shared-Nothing, Thread-Per-Core Execution (Architectural Specialization)

This is not a separate architectural style but the defining internal mechanism of the Modular Monolith. From `docs/df-share-nothing.md`:

> "The DF in-memory database is sharded into N parts, where N is less or equal to the number of threads in the system. Each database shard is owned and accessed by a single thread."
>
> "Inter-thread interactions in Dragonfly occur only via passing messages from thread to thread."

Each `EngineShard` (`src/server/engine_shard.h`) is a thread-local singleton that owns:
- Its own `TxQueue` for serializing transaction execution
- Its own `TaskQueue` (primary and secondary fiber queues)
- Its own `DbSlice` (the actual key-value store partition)
- Tiered storage handle and search indices

`EngineShardSet` (`src/server/engine_shard_set.h`) provides the cross-shard dispatch API (`Await`, `Add`, `RunBriefInParallel`, `RunBlockingInParallel`) used by the `Transaction` coordinator to fan out operations without locking.

### 5. VLL Transaction Protocol (Coordinator Pattern)

From `docs/transaction.md`, multi-key/multi-shard operations are orchestrated by a **coordinator layer** (each client connection fiber acts as the coordinator). The algorithm is based on the VLL paper and guarantees strict serializability:

1. **Schedule hop**: coordinator fans out to all involved shards, which add the transaction to their `TxQueue` under a global sequence counter.
2. **Execute hops**: coordinator sends one or more micro-op messages to shards; each shard runs them in TxQueue order.
3. **Finalization**: shards release intent locks and dequeue the transaction.

This coordinator pattern is internal to the monolith—not a separate microservice or event bus.

### 6. Command Family Pattern (Domain Partitioning)

Business logic is partitioned by Redis data type into "families":
- `string_family.cc`, `list_family.cc`, `hset_family.cc`, `zset_family.cc`
- `set_family.cc`, `geo_family.cc`, `json_family.cc`, `hll_family.cc`
- `bloom_family.cc`, `bitops_family.cc`, `stream_family.cc`

Each family handles commands for one Redis data type. This is a clean **domain partitioning** within the monolith, not DDD in the Evans sense (no aggregates, repositories, or bounded context deployment artifacts).

### 7. Optional Subsystems (Compile-Time Feature Flags)

Advanced subsystems are conditionally compiled:
- `WITH_TIERING` — async disk-spill for cold values
- `WITH_SEARCH` — full-text and vector search (FT.* commands)
- `WITH_AWS`, `WITH_GCP` — cloud object-storage snapshot targets
- `DF_USE_SSL` — TLS termination

This demonstrates mature modular design: capabilities can be included or excluded without restructuring the module graph.

---

## What This Is NOT

- **Not Microservices**: One process, one executable, no network boundaries between components, designed for vertical scaling within a single instance.
- **Not Event-Driven**: Inter-shard message passing uses direct fiber dispatch into typed `TaskQueue` entries, not a publish/subscribe event bus or broker.
- **Not Space-Based**: The Space-Based style requires a distributed in-memory data grid with multiple processing units and tuple-space coordination. Dragonfly is explicitly single-process.
- **Not Hexagonal**: The `facade` layer handles protocol compatibility but it is a network ingress layer, not a ports-and-adapters pattern with swappable drivers and driven-side adapters.
- **Not Domain-Driven Design**: Command families partition by Redis data type (a protocol/API concept), not by business domain. There are no DDD aggregates, repositories, or domain events.

---

## Quality Attributes

| Attribute | Assessment |
|---|---|
| Performance | Exceptional. 25x Redis throughput on equivalent hardware; 3.8M+ QPS on large instances; 10-15M QPS in pipeline mode. |
| Scalability | Vertical scaling only (by design). Scales linearly with core count on a single node. Horizontal cluster mode is available but secondary. |
| Reliability | Strict serializability for all operations (single-key and multi-key). RDB/AOF-compatible persistence. Replication via journal streaming. |
| Maintainability | Module boundaries enforced by CMake build targets. Clean layering. Separate command families. Well-documented architecture in /docs/. |
| Memory Efficiency | Custom DashTable hash map; mimalloc allocator; compact object encoding; optional disk tiering for cold values. Claims up to 80% memory reduction vs. Redis for equivalent workloads. |
| Operability | Redis/Memcached wire-compatible (no client code changes required). HTTP admin API. ACL support. Namespace isolation (experimental). |

---

## Classification Confidence Rationale

Confidence is **0.96** (high). The evidence is unambiguous:
- A single CMake `add_executable` target establishes the Modular Monolith boundary conclusively.
- Module separation is enforced by build-system targets with documented dependency rules.
- The layered directory and dependency structure is explicit and intentional.
- Official architecture documentation confirms the design intent throughout.

The only ambiguity worth noting is the cluster subsystem (`src/server/cluster/`), which adds multi-node slot-migration capabilities. This does not alter the classification—each Dragonfly node remains a standalone Modular Monolith, and cluster coordination is managed via client-side routing, not a separate architectural tier within the node.
