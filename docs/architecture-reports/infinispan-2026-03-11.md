# Architecture Report: Infinispan

**Date:** 2026-03-11
**Analyst:** claude-sonnet-4-6 (deep-analysis)
**Source:** https://github.com/infinispan/infinispan
**Commit:** depth-1 clone, HEAD as of 2026-03-11

---

## Summary

Infinispan is a **Modular Monolith** at the code-organization level, with a strong secondary **Space-Based** identity reflecting its runtime topology as a distributed in-memory data grid, and a tertiary **Microkernel** layer that governs how optional capabilities and protocol handlers plug into the core engine. The repository consists of 60+ Maven modules (8,462 Java source files) organized around a single multi-module build rooted at `pom.xml`. All core capabilities — distribution, replication, transactions, querying, locking, persistence — run within the same JVM process on each node. Internally the codebase enforces strict module boundaries through the `@InfinispanModule` annotation and a compile-time annotation processor (`build/component-processor`) that validates module dependency declarations. At runtime, each cluster node owns a consistent-hash-assigned slice of a segmented keyspace and executes read/write operations locally against its segments — the textbook Space-Based processing-unit pattern. A formal `@InfinispanModule` / `ModuleLifecycle` plugin system, the `NonBlockingStore` SPI for swappable persistence backends, and an `AsyncInterceptorChain` extension point for cache command processing provide the Microkernel extensibility layer. The server tier adds a second Microkernel dimension: a single `server/runtime` bootstrap hosts five independently loaded protocol modules (HotRod, REST, Memcached, RESP, and router) that plug in as named `@InfinispanModule` extensions.

---

## Classification

| Field | Value |
|---|---|
| Primary style | Modular Monolith |
| Secondary style | Space-Based |
| Tertiary style | Microkernel |
| Confidence | 0.93 |

---

## Evidence

### 1. Modular Monolith (primary)

**Single-artifact multi-module build**

`pom.xml` at the repository root declares 55+ Maven modules that all build into a single deployable distribution:

```
api, commons, core, counter, counter-api, multimap, lock, query,
persistence/jdbc, persistence/jdbc-common, persistence/remote, persistence/rocksdb, persistence/sql,
server/core, server/hotrod, server/rest, server/memcached, server/resp, server/router, server/runtime,
client/hotrod-client, client/rest-client,
tasks/api, tasks/manager, tasks/scripting,
cdi/common, cdi/embedded, cdi/remote,
spring, jcache, graalvm, quarkus, hibernate, gridfs, cli, anchored-keys, jboss-marshalling
```

The build produces one distribution archive (assembled under `distribution/`) that runs as a single Infinispan Server process. There are no in-process network boundaries between modules at runtime.

**Formal module boundary enforcement via `@InfinispanModule`**

Infinispan enforces module boundaries through a compile-time annotation processor. Every Maven module that contributes to the runtime must contain exactly one class annotated `@InfinispanModule`:

```java
// build/component-annotations/src/main/java/org/infinispan/factories/annotations/InfinispanModule.java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.CLASS)
public @interface InfinispanModule {
    String name();
    String[] requiredModules() default {};
    String[] optionalModules() default {};
}
```

The `build/component-processor` annotation processor validates at compile time that `@InfinispanModule` is present on exactly one class per module and that dependency names resolve to real modules. The `ModuleLifecycle` interface (`core/src/main/java/org/infinispan/lifecycle/ModuleLifecycle.java`) is the lifecycle contract that annotated classes must implement, receiving `cacheManagerStarting`, `cacheManagerStarted`, `cacheStarting`, `cacheStopping`, and equivalent stop hooks.

**Representative module dependency graph**

```
core                    (@InfinispanModule, CoreModule.java — the kernel)
├── query               (requiredModules = {"core"})
├── clustered-lock      (requiredModules = "core")
├── clustered-counter   (requiredModules = "core")
├── multimap            (requiredModules = "core")
├── jcache              (requiredModules = "core")
├── scripting           (requiredModules = "core")
├── tasks               (requiredModules = "core")
├── anchored-keys       (requiredModules = "core")
├── spring-embedded     (requiredModules = "core")
├── jboss-marshalling   (requiredModules = "core")
├── cachestore-remote   (requiredModules = "core")
├── server-core         (requiredModules = {"core", "query"})
│   ├── server-hotrod   (requiredModules = "core")
│   ├── server-rest     (no explicit required → "core" implicitly via server-core)
│   ├── server-memcached(requiredModules = "core")
│   ├── resp            (requiredModules = "core")
│   └── server-runtime  (requiredModules = {"core", "query"})
│       └── insights    (requiredModules = {"core", "server-runtime"})
└── hibernate-cache-commons (requiredModules = "core")
```

**API / Commons / Core three-tier abstraction stack**

The repository enforces a three-level API abstraction:

| Layer | Module | Purpose |
|---|---|---|
| Public API | `api/` | Stable async API (`org.infinispan.api.*`): `MutinyCache`, `AsyncCache`, `SyncCache` |
| Commons | `commons/` | Shared utilities, `CacheException`, marshalling, encoding, `Version` |
| Core | `core/` | Full implementation: distribution, interceptors, topology, transactions, replication |

Code in `core` may use `commons`; neither `api` nor `commons` may use `core`. This upward-only dependency rule is the hallmark of a modular monolith.

**Internal component registry**

`GlobalComponentRegistry.java` (`core/src/main/java/org/infinispan/factories/GlobalComponentRegistry.java`) is the kernel's IoC container — a global component registry that initializes and wires all singleton components (`Transport`, `ClusterTopologyManager`, `LocalTopologyManager`, `EmbeddedCacheManager`, `GlobalConfigurationManager`, `CacheManagerNotifier`, etc.) with lazy initialization and lifecycle-managed start/stop ordering.

**Module layer stack**

| Layer | Modules / Packages |
|---|---|
| Public API | `api/` — async/sync/reactive cache interfaces |
| Commons & Marshalling | `commons/`, `jboss-marshalling/` |
| Core Engine | `core/` — distribution, interceptors, topology, transactions, replication, persistence SPI |
| Data Structures | `counter/`, `multimap/`, `lock/`, `anchored-keys/` |
| Query / Search | `query/` — Lucene-based full-text and Ickle query language |
| Persistence | `persistence/jdbc`, `persistence/rocksdb`, `persistence/remote`, `persistence/sql` |
| Server / Protocols | `server/core`, `server/hotrod`, `server/rest`, `server/memcached`, `server/resp`, `server/router`, `server/runtime` |
| Client | `client/hotrod-client`, `client/rest-client` |
| Integrations | `spring/`, `cdi/`, `quarkus/`, `hibernate/`, `jcache/`, `graalvm/`, `gridfs/` |
| Tooling | `cli/`, `tasks/`, `archetypes/`, `tools/` |

---

### 2. Space-Based (secondary)

The runtime topology is a distributed in-memory data grid. Each Infinispan cluster member (a JVM process) owns a segment-assigned slice of the keyspace, stores its assigned data in off-heap or heap memory, and executes operations locally against its segments — the processing-unit pattern that defines Space-Based architecture.

**Segment-based consistent hashing**

`DefaultConsistentHash.java` (`core/src/main/java/org/infinispan/distribution/ch/impl/DefaultConsistentHash.java`) implements the routing table that maps segments to owning members. The consistent hash is immutable and updated atomically on cluster topology changes:

```java
// DefaultConsistentHash — "The routing table"
private final int numOwners;  // configurable replication factor
// Every key hashes to a segment; every segment has exactly one primary owner
```

The `ConsistentHashFactory` SPI (`DefaultConsistentHashFactory`, `SyncConsistentHashFactory`, `ReplicatedConsistentHashFactory`, `TopologyAwareConsistentHashFactory`) allows swapping the partitioning strategy — topology-aware hashing ensures replicas land in different racks/datacenters.

**DistributionManager — compute moves to data**

`DistributionManager.java` returns the `LocalizedCacheTopology` that tells each operation whether its target key is local or remote:

```java
// core/src/main/java/org/infinispan/distribution/DistributionManager.java
LocalizedCacheTopology getCacheTopology();
```

Remote operations are forwarded to the segment's primary owner, executing there rather than transferring data back — the defining Space-Based property.

**State transfer and elastic rebalancing**

`StateConsumerImpl.java` and `StateProviderImpl.java` (`core/src/main/java/org/infinispan/statetransfer/`) implement elastic rebalancing: when nodes join or leave, segment ownership is redistributed and in-flight state is transferred to the new owners. `StateTransferLock` prevents concurrent modifications during transfer:

- `InboundTransferTask` — receives segments from current owners
- `OutboundTransferTask` — sends owned segments to new owners
- `RebalanceType` — distinguishes full rebalances from segment transfers

**Cluster topology management**

`ClusterTopologyManagerImpl.java` (`core/src/main/java/org/infinispan/topology/`) manages the authoritative view of cluster membership and per-cache topology. It coordinates rebalancing via `LocalTopologyManagerImpl` on each node. The topology includes read and write consistent hashes (separate hashes during rebalance transitions) and the set of current members.

**JGroups for cluster transport**

The root `pom.xml` declares `org.jgroups:jgroups` and `org.jgroups:jgroups-raft` as managed dependencies. JGroups provides the cluster membership protocol (PING, MERGE, FD, GMS) and reliable multicast/unicast transport. `jgroups-raft` provides the Raft consensus implementation used by the distributed counter and clustered lock features.

**Partition handling and split-brain protection**

`PartitionHandling.java` and `AvailabilityMode.java` (`core/src/main/java/org/infinispan/partitionhandling/`) govern cache behavior during network partitions: `ALLOW_READ_WRITES`, `DENY_READ_WRITES` (strong consistency mode that sacrifices availability when a partition cannot form a quorum). This is the CP/AP trade-off dial characteristic of Space-Based systems.

**Cross-site replication (XSite)**

`BackupSenderImpl.java` and `ClusteredCacheBackupReceiver.java` (`core/src/main/java/org/infinispan/xsite/`) provide active-active and active-passive data replication across geographically separate Infinispan clusters. The IRAC (Infinispan Reliable Async Cross-site) implementation (`xsite/irac/`) provides conflict-resolution for asynchronous replication. This allows the data grid to span data centers with local data ownership per region.

---

### 3. Microkernel (tertiary)

Infinispan has two interlocking plugin systems: the `@InfinispanModule` / `ModuleLifecycle` system for general module extensibility, and the `NonBlockingStore` SPI for swappable persistence backends. A third extension axis is the `AsyncInterceptorChain` that allows modules to inject interceptors into the cache command pipeline.

**`@InfinispanModule` — the formal module plugin contract**

As shown under Modular Monolith, every module registers via `@InfinispanModule`. The `build/component-processor` processes these annotations at compile time and generates wiring code for the `GlobalComponentRegistry`. The `ModuleLifecycle` callbacks (`cacheStarting`, `cacheStarted`, etc.) are how modules inject their components — for example, `query/src/main/java/org/infinispan/query/impl/LifecycleManager.java` (`@InfinispanModule(name = "query", requiredModules = {"core"})`) registers query interceptors and indexing backends during `cacheStarting`.

**`AsyncInterceptorChain` — the command pipeline extension point**

`AsyncInterceptorChain.java` (`core/src/main/java/org/infinispan/interceptors/AsyncInterceptorChain.java`) exposes `addInterceptor(AsyncInterceptor, int)`, `addInterceptorAfter(...)`, `addInterceptorBefore(...)`, and `removeInterceptor(...)` — a runtime-modifiable ordered chain of command handlers. Core interceptors (locking, distribution, caching, statistics) are registered by the `InterceptorChainFactory`; optional modules (query, transactions, state transfer) insert additional interceptors during `cacheStarting`. This is the mechanism through which the Microkernel's "plugin" modules attach behavior to the central cache engine.

**`NonBlockingStore` SPI — swappable persistence backends**

`NonBlockingStore<K, V>` (`core/src/main/java/org/infinispan/persistence/spi/NonBlockingStore.java`) is the formal contract for all persistence backends:

```java
// Never block the invoking thread — all operations return CompletionStage
public interface NonBlockingStore<K, V> {
    CompletionStage<Void> start(InitializationContext ctx);
    CompletionStage<MarshallableEntry<K, V>> load(int segment, Object key);
    CompletionStage<Void> write(int segment, MarshallableEntry<K, V> entry);
    CompletionStage<Boolean> delete(int segment, Object key);
    Publisher<MarshallableEntry<K, V>> publishEntries(IntSet segments, Predicate<? super K> filter, boolean fetchValue);
    EnumSet<Characteristic> characteristics();  // advertises BULK_READ, SEGMENTABLE, TRANSACTIONAL, etc.
    // ...
}
```

Four production implementations plug in via this SPI:

| Module | Implementation |
|---|---|
| `persistence/jdbc` | JDBC-backed store (PostgreSQL, MySQL, Oracle, etc.) |
| `persistence/rocksdb` | RocksDB embedded store for off-heap durability |
| `persistence/remote` | Remote Infinispan cluster as a backing store |
| `persistence/sql` | SQL query-based store with table mapping |

**`ServerTask` SPI — server-side task execution**

`archetypes/server-task/src/main/resources/META-INF/services/org.infinispan.tasks.ServerTask` demonstrates the `ServiceLoader` extension point for server-side tasks. The `tasks/manager` module provides the task registry; custom tasks are loaded as JARs deployed to the server and discovered via `ServiceLoader<ServerTask>`.

**Protocol modules as Microkernel plugins**

The server tier (`server/runtime`) bootstraps a Netty-based network layer and loads protocol handlers as named modules:

```
server-runtime
├── server-hotrod   — Binary HotRod protocol (custom binary, intelligent client routing)
├── server-rest     — REST/HTTP API (JSON, Protobuf, text/plain)
├── server-memcached— Memcached ASCII protocol
├── server-resp     — RESP protocol (Redis-compatible wire format)
└── server/router   — Single-port TLS ALPN router: RoutingTable, Router
```

Each protocol handler registers as a separate `@InfinispanModule` and is loaded during server startup. The `server/router` module (`Router.java`, `RoutingTable.java`) provides a single-port ALPN/SNI demultiplexer that routes to the appropriate protocol handler — a single entry point in front of the protocol plugins.

**Archetypes for third-party extension**

`archetypes/` contains Maven archetypes for building custom extensions:

- `archetypes/custom-module` — generate a new `@InfinispanModule` extension with `ModuleLifecycle`
- `archetypes/store` — generate a `NonBlockingStore` implementation
- `archetypes/server-task` — generate a `ServerTask` for server-side execution

These archetypes formalize the plugin authoring contract for external developers.

---

### What Was Ruled Out

**Microservices** — A single JVM process constitutes an Infinispan server node. All protocols (HotRod, REST, Memcached, RESP) run within the same process. Modules are not independently deployable services with private data stores. There are no inter-service network calls; the server router is a single-port demultiplexer, not a service mesh.

**Event-Driven** — Infinispan provides `CacheListener`, `ClusterListener`, and event notifications as product capabilities. These are features of the data grid exposed to application code, not the primary organizing principle of the codebase. There is no message-broker-mediated event flow as the structural backbone of module-to-module communication.

**Pipeline** — The `AsyncInterceptorChain` is a cache-command execution chain within a single cache operation, not a data-flow pipeline between independent processing stages. The streaming and query capabilities are subsystems within the modular monolith, not an architectural organizing principle.

**Layered** — The codebase has clear internal layering (API → Commons → Core → Features → Server), but the dominant organizing principle is capability-based module decomposition (distribution, query, persistence, server protocols) enforced by `@InfinispanModule`, not strict horizontal tiers with upward-only dependencies across the full codebase.

**Hexagonal** — While the `NonBlockingStore` SPI and `@InfinispanModule` make many behaviors swappable, the code is not organized around explicit named inbound/outbound ports in the Hexagonal sense. The `GlobalComponentRegistry` is a general IoC container, not a ports-and-adapters isolation boundary.

**Domain-Driven Design** — Code is organized by technical capability (distribution, topology, persistence, server) rather than business bounded contexts with aggregates and ubiquitous language.

---

## Key Files

- `pom.xml` — Maven multi-module root; 55+ modules, single distribution artifact
- `build/component-annotations/src/main/java/org/infinispan/factories/annotations/InfinispanModule.java` — module registration annotation
- `build/component-processor/` — compile-time annotation processor enforcing `@InfinispanModule` constraints
- `core/src/main/java/org/infinispan/lifecycle/ModuleLifecycle.java` — lifecycle callback interface for all modules
- `core/src/main/java/org/infinispan/CoreModule.java` — kernel `@InfinispanModule`, core bootstrap
- `core/src/main/java/org/infinispan/factories/GlobalComponentRegistry.java` — global IoC container / kernel component registry
- `core/src/main/java/org/infinispan/interceptors/AsyncInterceptorChain.java` — runtime-modifiable command pipeline
- `core/src/main/java/org/infinispan/interceptors/AsyncInterceptor.java` — plugin contract for command interceptors
- `core/src/main/java/org/infinispan/persistence/spi/NonBlockingStore.java` — persistence backend SPI contract
- `core/src/main/java/org/infinispan/distribution/ch/impl/DefaultConsistentHash.java` — segment routing table (Space-Based)
- `core/src/main/java/org/infinispan/distribution/DistributionManager.java` — local vs. remote routing decision
- `core/src/main/java/org/infinispan/topology/ClusterTopologyManagerImpl.java` — cluster membership and per-cache topology
- `core/src/main/java/org/infinispan/statetransfer/StateConsumerImpl.java` — inbound segment transfer during rebalance
- `core/src/main/java/org/infinispan/statetransfer/StateProviderImpl.java` — outbound segment transfer during rebalance
- `core/src/main/java/org/infinispan/partitionhandling/PartitionHandling.java` — CP/AP trade-off dial
- `core/src/main/java/org/infinispan/xsite/BackupSenderImpl.java` — cross-site replication sender
- `core/src/main/java/org/infinispan/xsite/irac/DefaultIracManager.java` — async cross-site conflict resolution
- `query/src/main/java/org/infinispan/query/impl/LifecycleManager.java` — query module registration (`@InfinispanModule`)
- `server/runtime/src/main/java/org/infinispan/server/Bootstrap.java` — server bootstrap
- `server/runtime/src/main/java/org/infinispan/server/LifecycleCallbacks.java` — server-runtime `@InfinispanModule`
- `server/router/src/main/java/org/infinispan/server/router/Router.java` — single-port ALPN/SNI protocol router
- `server/router/src/main/java/org/infinispan/server/router/RoutingTable.java` — protocol handler registry
- `server/hotrod/src/main/java/org/infinispan/server/hotrod/HotRodServer.java` — HotRod binary protocol server
- `persistence/rocksdb/` — RocksDB `NonBlockingStore` implementation
- `persistence/jdbc/` — JDBC `NonBlockingStore` implementation
- `archetypes/custom-module/` — archetype for third-party `@InfinispanModule` extensions
- `archetypes/store/` — archetype for third-party `NonBlockingStore` implementations
- `archetypes/server-task/` — archetype for `ServerTask` server-side execution plugins
