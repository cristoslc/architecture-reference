# Architecture Report: Elasticsearch

**Date:** 2026-03-11
**Analyst:** claude-sonnet-4-6 (deep-analysis)
**Source:** https://github.com/elastic/elasticsearch
**Commit:** depth-1 clone, HEAD as of 2026-03-11

---

## Summary

Elasticsearch is a **Microkernel** architecture, secondarily exhibiting strong **Layered** and **Modular Monolith** characteristics. The system is a single deployable JVM process whose minimal core (cluster coordination, transport, thread pool, resource management) is extended at runtime by a rich plugin and module system. This is the archetypal microkernel pattern: a kernel that defines extension contracts and manages plugin lifecycle, with virtually all user-facing features (analysis, ingestion, search extensions, security, ML, SQL, etc.) expressed as plugins loaded from the filesystem.

---

## Classification

| Field | Value |
|---|---|
| Primary style | Microkernel |
| Secondary style | Layered |
| Tertiary style | Modular Monolith |
| Confidence | 0.95 |

---

## Evidence

### 1. Microkernel (primary)

**Plugin base class and SPI contracts**

`server/src/main/java/org/elasticsearch/plugins/Plugin.java` is the formal extension point. Every feature — whether open-source module or commercial X-Pack plugin — must extend this class. The directory `server/src/main/java/org/elasticsearch/plugins/` defines 17+ typed extension interfaces:

- `ActionPlugin` — additional REST handlers and transport actions
- `AnalysisPlugin` — tokenizers, analyzers, char filters
- `ClusterPlugin` — shard allocation deciders and weighers
- `ClusterCoordinationPlugin` — custom election strategies
- `DiscoveryPlugin` — node discovery and seed host providers
- `EnginePlugin` — pluggable index storage engines
- `HealthPlugin` — custom health indicators
- `IndexStorePlugin` — index directory implementations
- `IngestPlugin` — document ingest processors
- `MapperPlugin` — custom field type mappers
- `NetworkPlugin` — custom transport and HTTP implementations
- `PersistentTaskPlugin` — persistent background tasks
- `RepositoryPlugin` — snapshot storage backends
- `ScriptPlugin` — scripting language runtimes
- `SearchPlugin` — custom query types, aggregations, fetch phases
- `SystemIndexPlugin` — internal system index management
- `TelemetryPlugin` — custom telemetry/APM providers
- `ExtensiblePlugin` — plugins that can themselves be extended by other plugins

**Plugin loading infrastructure**

`PluginsService.java` and `PluginsLoader.java` manage plugin discovery (from `plugins/` and `modules/` directories), classloader isolation (separate `ModuleLayer` per plugin), descriptor parsing (`plugin-descriptor.properties`), and lifecycle (start/stop). The `libs/entitlement/` library provides a security sandbox that restricts what sensitive operations each plugin classloader may perform.

**Three tiers of extension**

| Tier | Location | Count | Example |
|---|---|---|---|
| Built-in modules | `modules/` | ~30 | `lang-painless`, `transport-netty4`, `analysis-common`, `ingest-common`, `repository-s3` |
| Optional plugins | `plugins/` | ~15 | `analysis-icu`, `discovery-ec2`, `repository-hdfs` |
| X-Pack commercial plugins | `x-pack/plugin/` | ~60 | `security`, `ml`, `sql`, `esql`, `transform`, `watcher`, `inference`, `monitoring` |

All three tiers use the identical plugin mechanism. Built-in modules are simply pre-installed. This demonstrates the microkernel at industrial scale.

**Representative plugin class declarations**

```
// Commercial security plugin
public class Security extends Plugin implements ActionPlugin, IngestPlugin, NetworkPlugin, ...

// Commercial ML plugin
public class MachineLearning extends Plugin implements ActionPlugin, AnalysisPlugin, ...

// Open-source ingest pipeline module
public class IngestCommonPlugin extends Plugin implements ActionPlugin, IngestPlugin
```

**Settings.gradle — automated plugin discovery**

```groovy
addSubProjects('', new File(rootProject.projectDir, 'modules'))
addSubProjects('', new File(rootProject.projectDir, 'plugins'))
addSubProjects('', new File(rootProject.projectDir, 'x-pack'))
```

The build system recursively discovers plugin projects, reinforcing that the entire repository is structured around the kernel + plugin topology.

---

### 2. Layered (secondary)

The official internal architecture documentation (`docs/internal/GeneralArchitectureGuide.md`, `docs/internal/DistributedArchitectureGuide.md`) explicitly describes a layered request path. The layers, top-to-bottom:

| Layer | Key classes |
|---|---|
| REST / HTTP | `RestController`, `BaseRestHandler`, `Rest*Action`, `Netty4HttpServerTransport` |
| Transport / Action | `NodeClient`, `ActionModule`, `TransportService`, `Transport*Action` |
| Cluster / Coordination | `ClusterService`, `Coordinator`, `ClusterModule`, `DiscoveryModule` |
| Index / Shard | `IndicesService`, `IndexService`, `IndexShard`, `IndexModule` |
| Engine / Storage | `Engine`, `EngineFactory`, `Translog`, `TranslogWriter` |
| Lucene | `ElasticsearchConcurrentMergeScheduler`, `ElasticsearchReaderManager` |

Each layer has strict directional coupling: REST handlers call transport actions; transport actions call services; services interact with shards; shards invoke the engine; the engine writes to Lucene and the translog.

The Guice-based DI system (`injection/guice/`) and module classes (`ActionModule`, `ClusterModule`, `IndicesModule`, `DiscoveryModule`, `GatewayModule`) structurally enforce these layer boundaries.

---

### 3. Modular Monolith (tertiary)

Elasticsearch is packaged as a single deployable artifact. `distribution/archives/` and `distribution/docker/` produce one tar/zip/Docker image per platform; `distribution/packages/` produces rpm/deb. There is no service-to-service network boundary within a single node. All modules run in the same JVM with shared thread pools (`ThreadPool.java`), a shared `ClusterService`, and direct in-process method calls. Despite having ~100 independently buildable Gradle subprojects, the runtime is one monolith with plugin-layer extension points — the defining characteristic of a modular monolith.

---

### What Was Ruled Out

**Microservices** — There is no service decomposition within a node. The `distribution/` directory packages one server binary. While nodes form a cluster, each node is a monolithic JVM process, not a mesh of small services.

**Service-Based** — There are not 2–5 coarse-grained services with independent deployments sharing a database. The entire cluster state is managed by a single Raft-based consensus mechanism (`Coordinator.java`, `CoordinationState.java`) across all nodes.

**Event-Driven** — Cluster state changes propagate via Raft publish/commit, not via message brokers or event queues. Ingest pipelines within the system are a feature (the `ingest-*` modules), not an architectural organising principle.

**Pipeline** — The ingest pipeline is a subsystem, not the primary structural pattern. The codebase's topology is kernel + plugins, not a sequence of independent processing stages.

**CQRS** — There is no explicit command/query responsibility segregation. Read and write paths share the same shard and engine. The translog is a WAL for durability, not a CQRS event log.

**Hexagonal / Ports-and-Adapters** — While the transport and REST layers are swappable via plugins (NetworkPlugin, ActionPlugin), the code is not organized around explicit named "ports" and "adapters" in the Hexagonal sense. The primary organizing principle is plugin extension points, not inbound/outbound port segregation.

**Domain-Driven Design** — Rich domain objects (Index, Shard, Cluster) exist but there are no bounded contexts, aggregates, or explicit domain/application/infrastructure layer decomposition in the DDD sense.

**Multi-Agent** — Not applicable; this is a search infrastructure system.

**Space-Based / Serverless** — Not applicable.

---

## Key Files

- `server/src/main/java/org/elasticsearch/plugins/Plugin.java` — extension base class
- `server/src/main/java/org/elasticsearch/plugins/PluginsService.java` — plugin lifecycle manager
- `server/src/main/java/org/elasticsearch/plugins/PluginsLoader.java` — plugin discovery and classloading
- `server/src/main/java/org/elasticsearch/plugins/` — 17+ typed extension interfaces
- `server/src/main/java/org/elasticsearch/node/Node.java` — node bootstrap and service wiring
- `server/src/main/java/org/elasticsearch/action/ActionModule.java` — action and REST handler registry
- `server/src/main/java/org/elasticsearch/cluster/ClusterModule.java` — cluster layer DI module
- `server/src/main/java/org/elasticsearch/injection/guice/` — embedded Guice DI framework
- `libs/entitlement/` — plugin security sandbox
- `x-pack/plugin/security/src/main/java/org/elasticsearch/xpack/security/Security.java` — flagship commercial plugin
- `docs/internal/GeneralArchitectureGuide.md` — official internal architecture documentation
- `docs/internal/DistributedArchitectureGuide.md` — distributed architecture internals
- `settings.gradle` — automated plugin subproject discovery
