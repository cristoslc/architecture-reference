# Architecture Report: Hazelcast

**Date:** 2026-03-11
**Analyst:** claude-sonnet-4-6 (deep-analysis)
**Source:** https://github.com/hazelcast/hazelcast
**Commit:** depth-1 clone, HEAD as of 2026-03-11 (f5e059e)

---

## Summary

Hazelcast is a **Modular Monolith** at the code-organization level, with a strong secondary **Space-Based** identity reflecting its runtime topology as a distributed in-memory data grid, and a tertiary **Microkernel** layer that governs how optional capabilities (extensions, connectors, enterprise features) plug into the core engine. The repository builds a single core JAR (`hazelcast.jar`) from a Maven multi-module root (`pom.xml`). All distributed data-structure services (MapService, QueueService, CacheService, TopicService, etc.) run within the same JVM process on each node. Internally the codebase enforces strict module boundaries via ArchUnit rules that bar public-API classes from exposing `impl`/`internal` packages. At runtime, 271 partitions are distributed across the cluster: each node owns a slice of the total keyspace and executes operations locally against its partitions — the textbook Space-Based processing-unit pattern. A pervasive `ServiceLoader`-based plugin mechanism (`NodeExtension`, `DataConnectionRegistration`, `DiscoveryStrategyFactory`, `SerializerHook`, `ServiceDescriptorProvider`) and an `extensions/` directory of optional connectors (Kafka, MongoDB, Elasticsearch, Kinesis, S3, gRPC, CDC, Avro, Python, Hadoop) provide the Microkernel extensibility layer. The embedded Jet engine adds a pipeline DAG execution model as a first-class subsystem, but this is an internal feature of the monolith, not a separate architectural style for the codebase.

---

## Classification

| Field | Value |
|---|---|
| Primary style | Modular Monolith |
| Secondary style | Space-Based |
| Tertiary style | Microkernel |
| Confidence | 0.92 |

---

## Evidence

### 1. Modular Monolith (primary)

**Single deployment artifact**

`pom.xml` at the repository root declares a Maven multi-module build with eight core modules:

```
hazelcast-parent, hazelcast-tpc-engine, hazelcast, hazelcast-archunit-rules,
hazelcast-spring, hazelcast-spring-boot-autoconfiguration, hazelcast-sql,
hazelcast-build-utils
```

`extensions/` and `distribution/` are optional Maven profiles, not independent deployable services. The build produces one `hazelcast.jar` from the `hazelcast/` module. All services run in the same JVM process on a single node — there are no in-process network boundaries.

**Service-oriented internal decomposition**

`ServiceManagerImpl.java` (`hazelcast/src/main/java/com/hazelcast/spi/impl/servicemanager/impl/ServiceManagerImpl.java`) registers 20+ named services in `registerDefaultServices()`:

```java
registerService(MapService.SERVICE_NAME, createService(MapService.class));
registerService(QueueService.SERVICE_NAME, new QueueService(nodeEngine));
registerService(TopicService.SERVICE_NAME, new TopicService());
registerService(ReliableTopicService.SERVICE_NAME, new ReliableTopicService(nodeEngine));
registerService(MultiMapService.SERVICE_NAME, new MultiMapService(nodeEngine));
registerService(ListService.SERVICE_NAME, new ListService(nodeEngine));
registerService(SetService.SERVICE_NAME, new SetService(nodeEngine));
registerService(DistributedExecutorService.SERVICE_NAME, new DistributedExecutorService());
registerService(FlakeIdGeneratorService.SERVICE_NAME, new FlakeIdGeneratorServiceImpl(nodeEngine));
registerService(ReplicatedMapService.SERVICE_NAME, new ReplicatedMapService(nodeEngine));
registerService(RingbufferService.SERVICE_NAME, new RingbufferService(nodeEngine));
registerService(CardinalityEstimatorService.SERVICE_NAME, new CardinalityEstimatorService());
registerService(PNCounterService.SERVICE_NAME, new PNCounterService());
registerService(MetricsService.SERVICE_NAME, new MetricsService(nodeEngine));
```

Each service implements a well-defined SPI. `MapService` is representative:

```java
public class MapService implements ManagedService, ChunkedMigrationAwareService,
        TransactionalService, RemoteService,
        EventPublishingService<Object, ListenerAdapter>,
        PostJoinAwareService, SplitBrainHandlerService,
        WanSupportingService, StatisticsAwareService<LocalMapStats>,
        PartitionAwareService, ClientAwareService,
        SplitBrainProtectionAwareService, NotifiableEventListener,
        ClusterStateListener, LockInterceptorService<Data>,
        DynamicMetricsProvider, TenantContextAwareService,
        OffloadedReplicationPreparation {
```

This service-interface contract pattern, with each service wired to partition lifecycle events through `MigrationAwareService` and `PartitionAwareService`, is characteristic of a modular monolith organized by technical capability.

**Enforced public-API / internal boundary**

`PublicApiClassesExposingInternalImplementationCondition.java` (`hazelcast-archunit-rules/src/main/java/com/hazelcast/test/archunit/`) enforces at build time that no public API class exposes types from `impl` or `internal` packages:

```java
private static final Set<String> INTERNAL_PACKAGE_NAMES = Set.of("impl", "internal");
```

This is the defining structural discipline of a modular monolith: explicit, machine-checked module boundaries inside a single build and deployment unit.

**Module layer stack**

| Layer | Modules / Packages |
|---|---|
| Foundation | `hazelcast-tpc-engine` (thread-per-core I/O), `com.hazelcast.internal.serialization`, `com.hazelcast.logging` |
| Cluster Membership | `com.hazelcast.internal.cluster.impl` (`ClusterServiceImpl`), `com.hazelcast.spi.discovery` |
| Partition & Migration | `com.hazelcast.internal.partition.impl` (`InternalPartitionServiceImpl`, `MigrationManager`) |
| Distributed Data Structures | `com.hazelcast.map`, `com.hazelcast.collection`, `com.hazelcast.topic`, `com.hazelcast.cache`, `com.hazelcast.replicatedmap`, `com.hazelcast.ringbuffer`, `com.hazelcast.cp` |
| Streaming / SQL | `com.hazelcast.jet` (Jet engine + pipeline API), `hazelcast-sql` module |
| Connectivity | `com.hazelcast.client`, `com.hazelcast.wan` |
| Spring Integration | `hazelcast-spring`, `hazelcast-spring-boot-autoconfiguration` |

---

### 2. Space-Based (secondary)

The runtime topology is a distributed data grid. Each Hazelcast node (a JVM process) owns a contiguous slice of the 271-partition keyspace, stores its assigned data in-memory, and executes read/write operations locally to its partition — the processing-unit pattern that defines Space-Based architecture.

**271-partition keyspace with consistent hashing**

`ClusterProperty.java` defines the default:

```java
public static final HazelcastProperty PARTITION_COUNT
        = new HazelcastProperty("hazelcast.partition.count", 271);
```

`InternalPartitionServiceImpl.java` assigns and redistributes partitions across members via `MigrationManager` and `MigrationPlanner`. Every key is hashed to a partition via `HashUtil.hashToIndex(key.getPartitionHash(), partitionCount)`.

**Node-local execution**

Every `Operation` in `com.hazelcast.spi.impl.operationservice` is routed to the member that owns the target partition. If the operation is dispatched locally, it executes directly without network overhead; if remotely, it is sent to the owning member. This is the defining Space-Based property: compute moves to the data, not data to the compute.

**Partition replication and redundancy**

`InternalPartitionServiceImpl` maintains configurable backup replicas per partition. `MigrationManagerImpl` (`docs/design/partitioning/07-parallel-migrations.md`) describes parallel migration of partition replicas. The design docs under `docs/design/partitioning/` cover anti-entropy (`03-fine-grained-anti-entropy-mechanism.md`), split-brain recovery (`docs/design/cluster/03-split-brain-recovery-improvements.md`), and zero-downtime migration.

**CP Subsystem (Raft) for strong consistency**

`com.hazelcast.cp.internal.raft` provides a Raft consensus implementation for the CP (Consistent-Partition-tolerant) subsystem: `IAtomicLong`, `IAtomicReference`, `ICountDownLatch`, `ISemaphore`, distributed locks. This is a complementary in-memory coordination layer on top of the AP data grid.

**WAN replication**

`com.hazelcast.wan` (`WanPublisher`, `WanConsumer`) provides active-active and active-passive data replication across data centers, allowing the data grid to span geographic regions while maintaining local data ownership per region.

---

### 3. Microkernel (tertiary)

Hazelcast's extensibility is built around a multi-point `ServiceLoader`-based plugin system. The `META-INF/services/` directory in the core module declares eleven extension points:

```
com.hazelcast.client.impl.ClientExtension
com.hazelcast.client.impl.protocol.MessageTaskFactoryProvider
com.hazelcast.dataconnection.DataConnectionRegistration
com.hazelcast.DataSerializerHook
com.hazelcast.instance.impl.NodeExtension
com.hazelcast.internal.util.phonehome.MetricsProvider
com.hazelcast.PortableHook
com.hazelcast.SerializerHook
com.hazelcast.spi.discovery.DiscoveryStrategyFactory
com.hazelcast.spi.impl.servicemanager.ServiceDescriptorProvider
javax.cache.spi.CachingProvider
```

**NodeExtension — the enterprise seam**

`NodeExtension.java` is the primary plugin contract for the enterprise edition. `DefaultNodeExtension.java` provides the open-source implementation. Hazelcast Enterprise replaces this with a richer implementation via the `com.hazelcast.instance.impl.NodeExtension` service-loader entry, enabling security (`SecurityContext`), HD memory, and hot restart without changing core code.

**DataConnectionRegistration — pluggable data sources**

`DataConnectionRegistration` allows external connectors to register named data source types. The core registers JDBC and Hazelcast-native connections. Extensions register their own:

- `extensions/kafka/`: `KafkaDataConnectionRegistration`
- `extensions/mongodb/`: `MongoDataConnectionRegistration`

**Optional extensions directory**

`extensions/` contains 18 optional connector modules:

| Extension | Purpose |
|---|---|
| `kafka` | Kafka sources and sinks for Jet pipelines (`StreamKafkaP`, `WriteKafkaP`) |
| `mongodb` | MongoDB connector (change-data-capture and batch) |
| `cdc-postgres`, `cdc-mysql`, `cdc-debezium` | Change-data-capture via Debezium |
| `elasticsearch` | Elasticsearch sink |
| `kinesis` | AWS Kinesis source/sink |
| `s3` | AWS S3 connector |
| `hadoop`, `hadoop-dist` | Hadoop/HDFS source/sink |
| `kafka-connect` | Kafka Connect source API bridge |
| `grpc` | gRPC mapping for Jet pipeline stages |
| `protobuf` | Protobuf serialization support |
| `python` | Python model deployment for Jet pipelines |
| `avro` | Avro serialization support |
| `csv` | CSV file connector |
| `mapstore` | External `MapStore` implementations |

Each extension registers into the core through `DataConnectionRegistration` or as a Jet `Processor`/`ProcessorMetaSupplier` — consumers of the Microkernel extension contracts.

**ServiceDescriptorProvider — dynamic service registration**

`ServiceManagerImpl` loads `ServiceDescriptorProvider` implementations via `ServiceLoader` to allow additional named services to register without modifying `registerDefaultServices()`. The `LongRegisterServiceDescriptorProvider` is the built-in example.

---

### What Was Ruled Out

**Microservices** — A single JVM process constitutes a Hazelcast server node. Nodes form a peer-to-peer cluster through cluster membership, not independently deployed microservices with private data stores. The entire `extensions/` directory contains optional connectors, not separate deployable service components.

**Event-Driven** — Hazelcast provides `Topic`, `ReliableTopic`, `CacheListener`, and `EntryListener` as capabilities. These are product features exposed by the data structure services, not the primary organizing principle of the codebase. There is no message-broker-mediated event flow as a structural backbone.

**Pipeline** — The Jet engine (DAG-based `com.hazelcast.jet.core.DAG`, `Vertex`, `Edge`) provides a first-class streaming pipeline feature. However, this is a subsystem within the monolith — one service (`JetServiceBackend`) among many — not the codebase's organizing principle. The pipeline pattern describes how Jet jobs execute data, not how the codebase is structured.

**Layered** — The codebase has clear internal layering (foundation → transport → partitioning → data structures → streaming/SQL), but the dominant organizing principle is service-capability decomposition (map, queue, topic, CP, Jet), not strict horizontal tiers with enforced upward-only dependencies across all modules. Layering is structural scaffolding within the Modular Monolith, not a separate primary style.

**CQRS / Event Sourcing** — There is no command/query separation. Read and write operations share the same partition and `RecordStore`. The `IMap.journal()` map event journal is a streaming feature, not an event-sourcing architectural pattern.

**Hexagonal** — While the SPI layer (`NodeExtension`, `DataConnectionRegistration`) makes core contracts swappable, the code is not organized around explicit named inbound/outbound ports in the Hexagonal sense.

**Domain-Driven Design** — Code is organized by technical capability (map, queue, CP, jet, wan) rather than by business bounded contexts with aggregates and ubiquitous language.

---

## Key Files

- `pom.xml` — Maven multi-module root; single-artifact build topology
- `hazelcast/src/main/java/com/hazelcast/spi/impl/servicemanager/impl/ServiceManagerImpl.java` — central service registry: `registerDefaultServices()`, ServiceLoader loop for `ServiceDescriptorProvider`
- `hazelcast/src/main/java/com/hazelcast/spi/impl/NodeEngine.java` — kernel interface injected into every `ManagedService`
- `hazelcast/src/main/java/com/hazelcast/map/impl/MapService.java` — representative service implementing 15+ SPI contracts
- `hazelcast/src/main/java/com/hazelcast/internal/partition/impl/InternalPartitionServiceImpl.java` — 271-partition keyspace, consistent-hash routing, migration management
- `hazelcast/src/main/java/com/hazelcast/internal/partition/impl/MigrationManagerImpl.java` — partition migration planner and executor
- `hazelcast/src/main/java/com/hazelcast/spi/properties/ClusterProperty.java` — `PARTITION_COUNT` default (271)
- `hazelcast/src/main/java/com/hazelcast/instance/impl/NodeExtension.java` — primary enterprise extension contract
- `hazelcast/src/main/java/com/hazelcast/instance/impl/DefaultNodeExtension.java` — open-source NodeExtension implementation
- `hazelcast/src/main/java/com/hazelcast/dataconnection/DataConnectionRegistration.java` — pluggable data source SPI
- `hazelcast/src/main/resources/META-INF/services/` — eleven ServiceLoader extension points
- `hazelcast/src/main/java/com/hazelcast/cp/internal/raft/` — Raft consensus implementation for CP subsystem
- `hazelcast/src/main/java/com/hazelcast/jet/core/DAG.java` — Jet streaming pipeline DAG model
- `hazelcast/src/main/java/com/hazelcast/jet/pipeline/Pipeline.java` — high-level Jet pipeline builder API
- `hazelcast-archunit-rules/src/main/java/com/hazelcast/test/archunit/PublicApiClassesExposingInternalImplementationCondition.java` — build-time enforcement of impl/internal boundaries
- `extensions/kafka/src/main/java/com/hazelcast/jet/kafka/impl/StreamKafkaP.java` — Kafka source as a Jet Processor
- `extensions/mongodb/src/main/java/com/hazelcast/jet/mongodb/dataconnection/impl/MongoDataConnectionRegistration.java` — MongoDB DataConnectionRegistration plugin
- `docs/design/partitioning/` — design docs for partition migration, anti-entropy, split-brain recovery
- `docs/design/cluster/` — cluster split-brain recovery and partial disconnection design docs
