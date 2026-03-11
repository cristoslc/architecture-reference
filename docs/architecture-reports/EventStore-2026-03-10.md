---
project: "EventStore (KurrentDB)"
date: 2026-03-10
scope: platform
use-type: production
primary-language: C#
confidence: 0.94
styles:
  - name: Microkernel
    role: primary
    confidence: 0.94
  - name: Layered
    role: secondary
    confidence: 0.85
---

# Architecture Analysis: EventStore (KurrentDB)

## Metadata

| Field | Value |
|---|---|
| Project | EventStore / KurrentDB |
| Version | 25.1 |
| Repo | https://github.com/EventStore/EventStore |
| Date | 2026-03-10 |
| Scope | platform |
| Use-type | production |
| Primary Language | C# (.NET 10) |
| Other Languages | JavaScript, TypeScript (Blazor UI, protocol tooling) |

## Style Rationales

**Microkernel (primary, 0.94):** The central `ClusterVNodeHostedService` bootstraps a minimal core (`KurrentDB.Core`) and assembles the runtime by loading two distinct plugin mechanisms — a legacy MEF-based `CompositionContainer` with `DirectoryCatalog` and a modern `PluginLoader` using per-plugin `AssemblyLoadContext` isolation (`src/KurrentDB.PluginHosting/PluginLoader.cs`). All capabilities beyond append/read primitives — authentication (LDAP, OAuth, UserCertificates), authorization (StreamPolicy), transport (TcpPlugin, ApiV2Plugin), infrastructure (AutoScavenge, EncryptionAtRest, SecondaryIndexing, SchemaRegistry), observability (OtlpExporter, LogsEndpointPlugin), and connectors (HTTP, Kafka, MongoDB, RabbitMQ, Elasticsearch) — are delivered as implementations of `IPlugableComponent` / `ISubsystemsPlugin`, activated via `ConfigureServices` / `ConfigureApplication` lifecycle callbacks. The `KurrentDB.Plugins` project defines the formal extension contracts (`IAuthenticationPlugin`, `IAuthorizationPlugin`, `ISubsystem`, `IChunkTransform`, `IMD5Plugin`, `IPersistentSubscriptionConsumerStrategyPlugin`), and the kernel remains valid with any subset of plugins present or absent.

**Layered (secondary, 0.85):** Within `KurrentDB.Core`, components are stratified into clear horizontal layers with unidirectional downward dependencies: Transport (`Services/Transport/Grpc/`, `Http/`, `Tcp/`), Business/Request Processing (`Services/RequestManager/`, `Services/PersistentSubscription/`), Storage (`Services/Storage/ReaderIndex/`, `StorageReaderService`, `StorageWriterService`), and Transaction Log (`TransactionLog/Chunks/`, `TransactionLog/LogRecords/`, `TransactionLog/Scavenging/`). The `InMemoryBus` (`Bus/InMemoryBus.cs`) mediates cross-layer communication via typed `Message` dispatch with `IHandle<T>` subscribers, preserving layer independence while enabling the `ClusterVNodeController` finite state machine to coordinate node lifecycle transitions (`VNodeState.Leader`, `Follower`, `CatchingUp`, etc.).

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `IPlugableComponent` interface with `ConfigureServices`/`ConfigureApplication` | `src/KurrentDB.Plugins/IPlugableComponent.cs` | Microkernel |
| Dual plugin loading: MEF `CompositionContainer` + `PluginLoader` with `AssemblyLoadContext` | `src/KurrentDB/ClusterVNodeHostedService.cs:68-69` | Microkernel |
| 12+ plugins registered in `LoadSubsystemsPlugins` | `src/KurrentDB/ClusterVNodeHostedService.cs:282-304` | Microkernel |
| `Plugin` abstract base class with lifecycle, licensing, diagnostics hooks | `src/KurrentDB.Plugins/Plugin.cs` | Microkernel |
| `PluginLoadContext` isolates plugin assemblies, shares only `Serilog`, `YamlDotNet`, `EventStore.Plugins` | `src/KurrentDB.PluginHosting/PluginLoader.cs:49-66` | Microkernel |
| Auth plugins: `IAuthenticationPlugin`, `IAuthorizationPlugin` | `src/KurrentDB.Plugins/Authentication/`, `Authorization/` | Microkernel |
| Subsystem plugins: `ISubsystem`, `ISubsystemsPlugin` | `src/KurrentDB.Plugins/Subsystems/` | Microkernel |
| Transport layer: `Services/Transport/{Grpc,Http,Tcp}` | `src/KurrentDB.Core/Services/Transport/` | Layered |
| Storage layer: `ReaderIndex/`, `StorageReaderService`, `StorageWriterService` | `src/KurrentDB.Core/Services/Storage/` | Layered |
| Transaction log: `TransactionLog/Chunks/`, `LogRecords/`, `Scavenging/` | `src/KurrentDB.Core/TransactionLog/` | Layered |
| `InMemoryBus` typed message dispatch for cross-component coordination | `src/KurrentDB.Core/Bus/InMemoryBus.cs` | Layered |
| `ClusterVNodeController` FSM with 10+ `VNodeState` transitions | `src/KurrentDB.Core/Services/VNode/ClusterVNodeController.cs` | Layered |
| 3-node cluster via gossip protocol (docker-compose) | `docker-compose.yml` (3 `esdb-node*` services) | Distribution |
| `SecondaryIndexingPlugin` (DuckDB-backed), `SchemaRegistryPlugin` | `src/KurrentDB.SecondaryIndexing/`, `src/SchemaRegistry/` | Microkernel |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Extensibility** | Runtime plugin loading via `AssemblyLoadContext` allows new capabilities (auth, connectors, indexes) to be added as DLLs dropped into `plugins/` directory without recompile |
| **Availability** | Quorum-based 3-node cluster with gossip protocol, leader election FSM (`VNodeState.Leader/Follower/CatchingUp`), and read-only replicas; docker-compose defines 3 nodes with certificate-backed inter-node TLS |
| **Performance** | Server GC enabled by default; `StreamInfoCacheCapacity` 100,000 entries; `ReaderIndex` bloom filters; DuckDB-backed secondary indexes for category and event-type queries; `BufferManagement` project for pooled I/O buffers |
| **Security** | Pluggable authentication (LDAP, OAuth, UserCertificates, internal) and authorization (StreamPolicy, Legacy) with license-gated entitlement checks; `EncryptionAtRest` plugin for chunk-level encryption; mutual TLS for cluster nodes |
| **Observability** | Prometheus metrics on `/metrics` (prefixed `kurrentdb_`); `OtlpExporterPlugin` for OpenTelemetry (license-gated); `LogsEndpointPlugin` for structured log streaming; projection metrics for state size, serialization, execution duration |
| **Evolvability** | Dual log format support (V2 stable, V3 experimental); dual plugin mechanisms (MEF legacy + `PluginLoader` new); API v2 plugin (`ApiV2Plugin`) coexists with legacy gRPC API for gradual protocol migration |

## Domain

Event-native database / streaming platform. Core domains: append-only event streams (write-ahead log), persistent subscriptions (competing consumers), server-side projections (JavaScript), secondary indexing (category/event-type), schema validation (Schema Registry), and data connectors (catch-up subscription sinks). Primary use case: event sourcing and event-driven application backends.

## Production Context

- Single binary (`KurrentDB.dll`) deployable as standalone node, 3-node HA cluster, or read-only replica; Kurrent Cloud offers fully managed GCP/AWS/Azure hosting
- Quorum-based replication requires certificate-authenticated gossip; cluster nodes expose port 2113 for gRPC/HTTP client traffic and a separate internal replication port
- Licensed enterprise features (TCP plugin, OTLP exporter, archiving, encryption at rest) are enforced at plugin activation via `ILicenseService` entitlement checks
- 90+ projects in solution; 594+ C# source files in `KurrentDB.Core` alone; active development areas include API v2 protocol, secondary indexing strategies, and Schema Registry integration with the Surge event processing framework
