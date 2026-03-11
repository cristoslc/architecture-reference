---
project: "Confluent Schema Registry"
date: 2026-03-11
scope: platform
use-type: production
primary-language: Java
confidence: 0.91
styles:
  - name: Modular Monolith
    role: primary
    confidence: 0.90
  - name: Microkernel
    role: primary
    confidence: 0.87
  - name: Layered
    role: secondary
    confidence: 0.80
---

# Architecture Analysis: Confluent Schema Registry

## Metadata

| Field | Value |
|---|---|
| Project | Confluent Schema Registry |
| Version | 8.3.0-0 |
| Repo | https://github.com/confluentinc/schema-registry |
| Date | 2026-03-11 |
| Scope | platform |
| Use-type | production |
| Primary Language | Java |
| Other Languages | Kotlin |

## Style Rationales

**Modular Monolith (primary, 0.90):** The repository is a Maven multi-module monorepo with 30+ clearly bounded modules, all deploying as a single JVM process. Modules are separated by concern: `core` (REST server, storage, leader election), `client` (REST client SDK), `avro-serializer`, `json-schema-serializer`, `protobuf-serializer`, `avro-serde`, `json-schema-serde`, `protobuf-serde`, `avro-data`, `avro-converter`, `json-schema-converter`, `protobuf-converter`, `schema-rules`, `client-encryption`, `dek-registry`, and three cloud-KMS encryption modules (AWS, Azure, GCP). These modules share a single runtime process and communicate via in-process method calls through well-defined Java interfaces (`SchemaRegistry`, `Store`, `SchemaProvider`, `IdGenerator`). The entire system ships in a single package artifact (`package-schema-registry`) and is deployed as one service process — follower nodes forward writes to the leader over HTTP, not over a message bus or separate service boundary.

**Microkernel (primary, 0.87):** The `core` module defines three formal plugin extension points that allow external capabilities to be loaded at runtime without modifying core code. First, `SchemaProvider` (`client/src/main/java/io/confluent/kafka/schemaregistry/SchemaProvider.java`) is a `Configurable` interface loaded by class name from the `schema.providers` config; three built-in providers (Avro, JSON Schema, Protobuf) are registered at startup, and custom providers can be added. Second, `SchemaRegistryResourceExtension` (`core/.../rest/extensions/SchemaRegistryResourceExtension.java`) is a JAX-RS extension point loaded via `resource.extension.classes`; the entire `dek-registry` module (`DekRegistryResourceExtension`) installs itself as a plugin that adds DEK/KEK management REST endpoints without modifying core routing. Third, `IdGenerator` (`core/.../id/IdGenerator.java`) is a pluggable interface for schema ID allocation; `IncrementalIdGenerator` is the default but the contract is explicitly extensible. The core discovers and wires these plugins at startup via Guice/Governator DI inside the application container.

**Layered (secondary, 0.80):** Within `core`, the code is organized in strict horizontal layers. The REST layer (`rest/resources/`) contains JAX-RS resource classes (`SubjectsResource`, `SchemasResource`, `CompatibilityResource`, `ConfigResource`, `ModeResource`, `SubjectVersionsResource`, `ContextsResource`, `AssociationsResource`) that delegate directly to the service/domain layer. The service/domain layer (`storage/KafkaSchemaRegistry`, `storage/AbstractSchemaRegistry`) implements all business logic: schema registration, compatibility checking, versioning, subject management, and config management. The storage layer (`storage/KafkaStore`, `storage/InMemoryCache`, `storage/LookupCache`) handles all persistence via a Kafka compacted topic (`_schemas` by default) plus an in-memory cache. A `KafkaStoreReaderThread` continuously tail-reads the compacted topic to keep the local cache consistent across nodes. Calls flow strictly downward: REST resources → `SchemaRegistry` interface → `KafkaSchemaRegistry` → `KafkaStore` / `InMemoryCache`. The DEK registry sub-system (`dek-registry`) replicates this exact three-layer structure internally.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| 30+ Maven modules in single monorepo, single deployable process | `pom.xml` `<modules>` block | Modular Monolith |
| Single `package-schema-registry` assembly artifact | `package-schema-registry/` | Modular Monolith |
| In-process wiring via `SchemaRegistry` interface | `core/.../storage/SchemaRegistry.java` | Modular Monolith |
| Follower nodes HTTP-forward writes to leader | `KafkaSchemaRegistry.java` "forward registering request to the leader" comments | Modular Monolith |
| `SchemaProvider` plugin interface loaded by `schema.providers` config | `client/.../SchemaProvider.java`, `SchemaRegistryConfig.java:SCHEMA_PROVIDERS_CONFIG` | Microkernel |
| Built-in Avro, JSON Schema, Protobuf providers registered at startup | `AbstractSchemaRegistry.initProviders()` | Microkernel |
| `SchemaRegistryResourceExtension` loaded by `resource.extension.classes` | `core/.../rest/extensions/SchemaRegistryResourceExtension.java` | Microkernel |
| `DekRegistryResourceExtension` installs DEK REST endpoints as a plugin | `dek-registry/.../DekRegistryResourceExtension.java` | Microkernel |
| `IdGenerator` pluggable interface for schema ID allocation | `core/.../id/IdGenerator.java` | Microkernel |
| Guice/Governator DI wires plugin instances inside `DekRegistryResourceExtension.register()` | `dek-registry/.../DekRegistryResourceExtension.java:InjectorBuilder` | Microkernel |
| JAX-RS resource classes in `rest/resources/` delegate to storage layer | `core/.../rest/resources/SubjectsResource.java` etc. | Layered |
| `KafkaSchemaRegistry extends AbstractSchemaRegistry implements LeaderAwareSchemaRegistry` | `core/.../storage/KafkaSchemaRegistry.java` | Layered |
| `KafkaStore implements Store<K,V>` wraps Kafka producer + consumer reader thread | `core/.../storage/KafkaStore.java` | Layered |
| `KafkaStoreReaderThread` tails `_schemas` compacted topic into `InMemoryCache` | `core/.../storage/KafkaStoreReaderThread.java` | Layered |
| `KafkaGroupLeaderElector` uses Kafka consumer group protocol for leader election | `core/.../leaderelector/kafka/KafkaGroupLeaderElector.java` | Layered |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Extensibility** | Three formal plugin extension points: `SchemaProvider` (schema type plugins), `SchemaRegistryResourceExtension` (REST extension plugins), `IdGenerator` (ID allocation plugins); all configurable by class name; DEK registry is a fully functional plugin installed via `DekRegistryResourceExtension` without core modification |
| **Availability** | Kafka consumer group leader election (`KafkaGroupLeaderElector`) provides automatic failover; follower nodes can serve reads locally from in-memory cache; writes are forwarded to the leader, which re-elects on failure; replication factor 3 default for `_schemas` topic |
| **Consistency** | All writes go to the Kafka compacted topic first, then propagate to all nodes via `KafkaStoreReaderThread`; the leader waits for the reader thread to catch up before serving reads after a leader change (`markLastWrittenOffsetInvalid`); single-writer leader model eliminates concurrent write conflicts |
| **Scalability** | All nodes serve reads from local in-memory cache without contacting Kafka or the leader; horizontal scaling of read throughput by adding follower nodes; `Caffeine`-backed `LoadingCache` in `AbstractSchemaRegistry` provides low-latency parsed schema caching |
| **Schema Compatibility** | Compatibility checking (BACKWARD, FORWARD, FULL, TRANSITIVE variants) is performed in `AbstractSchemaRegistry` via `SchemaProvider.isCompatible()`; `CompatibilityResource` exposes compatibility check as a first-class REST operation; rules engine in `schema-rules` module supports CEL and JSONata rule expressions |
| **Security** | Field-level encryption via `client-encryption` and `dek-registry` modules; cloud KMS integrations (AWS, Azure, GCP, HashiCorp Vault) via pluggable `KmsDriver`; mTLS and SSL configuration for both Kafka and REST listeners; auth extension point via `SchemaRegistryResourceExtension` |
| **Deployability** | Deployed as a single JVM process; Debian packaging in `debian/`; `schema-registry-start` launch script; configurable via properties file; compatible with Docker/Kubernetes deployments as a Confluent Platform component |

## Domain

Schema management platform for Apache Kafka ecosystems. Core domains: schema registration and versioning, compatibility enforcement, subject management, multi-format schema support (Avro, JSON Schema, Protobuf), data encryption key (DEK) lifecycle management, schema rules and data governance, multi-context namespace isolation.

## Production Context

- Deployed as a standalone JVM service alongside Kafka; uses a Kafka compacted topic (`_schemas`) as its durable state store — no external database required
- Leader election via Kafka consumer group protocol; follower nodes serve reads, forward writes to the leader via HTTP REST
- 30+ Maven modules but a single deployable process; DEK registry, cloud KMS integrations, and custom schema providers are loaded as plugins at startup
- Schema evolution compatibility checking (BACKWARD, FORWARD, FULL, TRANSITIVE) enforced at registration time; supports Avro, JSON Schema, and Protobuf natively with additional providers configurable
- Field-level encryption keys managed via `dek-registry` with pluggable KMS backends (AWS KMS, Azure Key Vault, GCP KMS, HashiCorp Vault, local)
- Data governance via `schema-rules` module: CEL and JSONata rule expressions can be attached to schemas to enforce field-level constraints or transformations
