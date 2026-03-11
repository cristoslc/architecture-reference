# coherence — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/oracle/coherence
**Classification:** Space-Based + Modular Monolith
**Confidence:** 0.93

## Summary

Oracle Coherence is a canonical Space-Based Architecture: a distributed in-memory data grid that eliminates the central database bottleneck by partitioning data and co-locating compute with storage across a cluster of peer nodes. Processing is inverted — code (EntryProcessors, Aggregators) travels to where the data lives rather than pulling data to the client. The codebase is organized as a Modular Monolith: 38+ Maven modules with enforced boundaries that produce a single shaded distribution JAR. Event-driven messaging (topics, MapListeners, EventInterceptors) is a first-class feature layer on top of the grid, but is a capability, not the defining style.

## Evidence

### Directory Structure

```
prj/
  coherence-core/           # Core grid engine (2,866 Java files)
    src/main/java/com/tangosol/
      net/                  # Grid service interfaces
        Cluster.java        # Cluster membership interface
        DistributedCacheService.java  # Partitioned cache service
        PartitionedService.java       # Partition ownership and assignment
        InvocationService.java        # Distributed compute service
        ProxyService.java             # Client-facing proxy (Extend)
        PagedTopicService.java        # Pub/sub topic service (extends DistributedCacheService)
        partition/          # Partitioning engine
          PartitionAssignmentStrategy.java  # Pluggable distribution strategy
          PartitionEvent.java               # Partition transfer events
          DistributionManager.java          # Coordinates partition redistribution
        events/             # Event interception framework
          EventInterceptor.java
          EventDispatcher.java
          partition/        # Partition-level event types
          federation/       # WAN federation event types (FederatedChangeEvent, etc.)
          topics/           # Topic lifecycle events
        cache/              # Cache implementations
          ContinuousQueryCache.java  # CQC: server-side filtered live view
          NearCache.java             # Client-side near cache with invalidation
          ReadWriteBackingMap.java   # Read-through/write-through/write-behind cache store
      util/
        InvocableMap.java   # "Send code to data" inversion interface
        aggregator/         # 20+ parallel aggregators (BigDecimalSum, Count, etc.)
        processor/          # EntryProcessor implementations (co-located mutations)
        MapListener.java    # Data change event listener interface
        MapEvent.java       # Cache entry change event
  coherence-core-components/  # Generated component model (310 Java files)
    net/extend/             # Coherence*Extend protocol (polyglot remote access)
      proxy/                # NamedCacheProxy, TopicServiceProxy, etc.
      RemoteService.java
  coherence-concurrent/     # Distributed java.util.concurrent primitives
    locks/RemoteLock.java   # Cluster-wide distributed lock
    Semaphore.java          # Cluster-wide semaphore
    CountDownLatch.java
  coherence-grpc/           # gRPC protocol support
  coherence-grpc-proxy/     # gRPC proxy (alongside Extend proxy)
  coherence-rest/           # REST access layer
  coherence-cdi/            # CDI/Jakarta EE integration
  coherence-mp/             # MicroProfile integration
  coherence-management/     # JMX + REST management
  coherence-hnsw/           # HNSW vector index for AI/similarity search
  coherence-rag-parent/     # RAG (Retrieval-Augmented Generation) support
  coherence-json/           # JSON serialization
  coherence-jcache/         # JSR-107 JCache adapter
  coherence-lucene/         # Lucene full-text search integration
  coherence-bedrock/        # Test framework for cluster in-process
src/main/resources/
  tangosol-coherence.xml    # Operational config: cluster, multicast, WKA, services
  coherence-cache-config.xsd/coherence-operational-config.xsd  # XML-driven service config
```

### Key Architectural Files

- `prj/coherence-core/src/main/java/com/tangosol/util/InvocableMap.java`: The defining interface of the Space-Based pattern. Javadoc states explicitly: *"the InvocableMap allows that model of operation to be inverted such that the operations against the Map contents are executed by (and thus within the localized context of) a Map... enables the processing to be moved to the location at which the entries-to-be-processed are being managed."*

- `prj/coherence-core/src/main/java/com/tangosol/net/DistributedCacheService.java`: Combines `CacheService` and `PartitionedService`; governs which members hold which partitions and whether local storage is enabled per member.

- `prj/coherence-core/src/main/java/com/tangosol/net/partition/PartitionAssignmentStrategy.java`: Pluggable strategy that manages how partitions (shards) are assigned and redistributed across cluster members. The `DistributionManager` binding and `analyzeDistribution()` contract are the heart of the Space-Based topology management.

- `prj/coherence-core/src/main/java/com/tangosol/net/PagedTopicService.java`: Pub/sub topics built as a distributed, partitioned service extending `DistributedCacheService`. Supports publish-subscribe and consumer groups (queue semantics), stored in the grid rather than a separate broker.

- `prj/coherence-core/src/main/resources/tangosol-coherence.xml`: Cluster operational configuration. Defines cluster name, member identity (site/rack/machine/role), unicast and multicast discovery, WKA (Well-Known Addresses), reliable transport, and TCMP protocol parameters. All service personalities are declaratively configured through XML.

- `prj/coherence-core-components/src/main/java/com/tangosol/coherence/component/net/extend/proxy/`: Service proxies for Coherence*Extend — the remoting layer that allows non-cluster clients (C++, .NET, Go, Python, JavaScript) to access the grid through a proxy member.

### Patterns Found

**Space-Based (Primary):** The entire architecture is organized around a distributed in-memory data space:

1. `PartitionedService` shards data across N partitions (configurable, default 257) distributed across storage-enabled cluster members. Each member owns a primary partition set and backup partitions.
2. `InvocableMap` sends `EntryProcessor` lambdas to storage nodes for partition-local execution with exclusive lock, eliminating cross-network round trips for mutations.
3. `InvocationService` sends arbitrary `Invocable` tasks to one or more members for distributed computation.
4. Aggregations are parallel map/reduce: each storage node aggregates its local partition data; results stream back to the client for final reduction.
5. `NearCache` and `ContinuousQueryCache` provide client-side caching with automatic invalidation via `MapListener` events, a derived read model on top of the grid.
6. `PagedTopicService` implements pub/sub messaging natively inside the grid; topics are stored in partitioned backing maps — no external message broker is needed.
7. Cluster membership ("service 0") handles death detection, partition rebalancing on member join/leave, and failover — the grid is self-healing.

**Modular Monolith (Secondary):** 38+ Maven modules under `prj/` with clear dependency hierarchy, compiled and shaded into a single `coherence.jar` distribution. Extension capabilities (CDI, gRPC, MicroProfile, JCache, Lucene, REST, HNSW, RAG) are optional modules that compose into the single artifact. There are no independently deployable service binaries within the platform itself.

**Event-Driven (feature layer, not defining style):** MapListeners, EventInterceptors, partition events, federation events, and topic pub/sub are all first-class features. However, they operate within the grid rather than defining the overall system topology. Events are a reactive notification mechanism on top of the data grid, not the structural organizing principle.

**WAN Federation (cross-cluster replication):** `FederatedChangeEvent`, `FederatedConnectionEvent`, `FederatedPartitionEvent` in `net/events/federation/` indicate active-active or active-passive geo-replication between clusters. This is a data-grid capability, not a separate architectural style.

**Layered (within coherence-core):** Package structure follows technical layers (`net`, `io`, `util`, `coherence/config`, `internal`) but this is internal code organization, not the deployment or interaction style.

## Architecture Styles Identified

### Space-Based (Primary)

Oracle Coherence is a textbook implementation of Space-Based Architecture as defined by Richards and Ford. All seven hallmarks are present:

1. **In-memory data grid:** `NamedMap<K,V>` / `NamedCache<K,V>` — the cluster-partitioned shared data space.
2. **Data partitioning:** `PartitionedService` + `PartitionAssignmentStrategy` managing key-to-partition and partition-to-member mappings.
3. **Data-local processing:** `InvocableMap.EntryProcessor` and `InvocationService.Invocable` move compute to data.
4. **Parallel aggregation:** Map/reduce aggregators execute in parallel across all storage partitions.
5. **Messaging grid:** `PagedTopicService` + `NamedTopic` provide pub/sub within the grid.
6. **Processing unit:** Each cluster member is a processing unit with local storage and local compute.
7. **Virtual middleware:** Coherence*Extend proxy and gRPC proxy decouple remote clients from internal grid topology — clients see a stable API while the grid rebalances internally.

### Modular Monolith (Secondary)

38+ Maven modules with clear boundary enforcement that compile into a single shaded distribution artifact. The module hierarchy is:

```
coherence (shaded distribution)
├── coherence-core (2,866 Java files — grid engine, service interfaces)
├── coherence-core-components (310 files — Extend protocol, component model)
├── coherence-discovery (cluster discovery)
├── coherence-grpc[-proxy|-proxy-common|-proxy-helidon] (gRPC layer)
├── coherence-cdi[-server] (CDI/Jakarta integration)
├── coherence-concurrent (distributed java.util.concurrent)
├── coherence-json, coherence-protobuf (serialization formats)
├── coherence-management (JMX + REST management)
├── coherence-rest (REST access layer)
├── coherence-jcache (JSR-107 adapter)
├── coherence-lucene (full-text search)
├── coherence-hnsw (vector index)
└── coherence-rag-parent (RAG / AI retrieval)
```

Each module has clear separation of concerns and enforced Maven dependency boundaries, yet all are deployed together in the same JVM process per cluster member.

## Quality Attributes

- **Scalability:** Linear horizontal scaling via partition redistribution — adding members increases both storage capacity and aggregate CPU. The data-local processing model means throughput scales with node count, not with a central bottleneck.
- **Availability:** Zero-downtime rolling upgrades with backward/forward compatibility across major versions. Configurable redundancy (N-way backup), with backups placed on distinct machines/racks/sites.
- **Performance:** Sub-millisecond latency for single-entry get/put; distributed aggregations and EntryProcessors avoid serializing data across the network. NearCache and ContinuousQueryCache provide client-side caching with automatic invalidation.
- **Fault Tolerance:** "Service 0" cluster service performs continuous death detection and collaborative partition rebalancing on member failure. Quorum policies prevent split-brain.
- **Consistency:** Partition-local transactions provide scalable ACID semantics within a partition. Read/write through CacheStore integration enables database consistency for durable data.
- **Elasticity:** Partition assignment strategy dynamically rebalances partitions on join/leave with minimal data movement. Supports storage-disabled client members that only hold references to partitioned data.
- **Observability:** JMX MBean hierarchy with single-server view across all members; Management-over-REST with full cluster visibility; Micrometer metrics integration (`coherence-micrometer`).
- **Extensibility:** Pluggable partition assignment strategies, cache stores, serializers, event interceptors, aggregators, entry processors, near-cache invalidation strategies, and socket providers via XML-driven configuration.

## Classification Reasoning

The prior classification (Space-Based + Modular Monolith, confidence 0.92) is confirmed and slightly extended. Deep exploration of the codebase validates every key evidence point in both directions:

**For Space-Based:** The `DistributedCacheService` + `PartitionedService` + `PartitionAssignmentStrategy` trinity is the textbook data-grid partition management model. `InvocableMap`'s documented inversion of the processing model ("send code to data, not data to code") is the canonical Space-Based characteristic. The `PagedTopicService` extending `DistributedCacheService` confirms that even messaging is implemented inside the data grid rather than through an external broker. The `coherence-concurrent` module (distributed locks, semaphores, latches, queues) further confirms that the grid is the substrate for all distributed coordination.

**For Modular Monolith:** 38+ Maven modules with well-enforced boundaries that produce a single shaded `coherence.jar`. Extension modules (CDI, gRPC, REST, Lucene, HNSW, RAG) are optional add-ons to the core. No independently deployable service components within the platform — each cluster member runs a single JVM with the full grid engine.

**What was rejected:**
- **Microservices:** The platform itself is not decomposed into independently deployable microservices. It is a platform used to build microservices applications.
- **Event-Driven (primary):** Events are a rich feature layer (MapListeners, EventInterceptors, topics, federation events) but are operational mechanisms within the grid, not the defining topology.
- **CQRS:** While `ContinuousQueryCache` and `NearCache` create read-side derived views, there is no formal command/event sourcing model or separate write/read path as a first-class architectural concern.
- **Hexagonal:** No ports-and-adapters isolation pattern. Configuration and extensions are handled via XML service configuration and Java SPI, not explicit port/adapter contracts.
- **Microkernel:** The XML service configuration and pluggable strategies (assignment, serialization, filtering) provide extensibility, but the core grid is not structured as a minimal kernel with pluggable service personalities in the Microkernel style.

Confidence is raised slightly to 0.93 based on breadth of code evidence confirming both primary and secondary styles with no ambiguity.
