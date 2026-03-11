# Architecture Report: rabbitmq-server

**Date:** 2026-03-11
**Source URL:** https://github.com/rabbitmq/rabbitmq-server
**Classification:** Microkernel + Modular Monolith
**Confidence:** 0.95
**Method:** deep-analysis
**Model:** claude-sonnet-4-6

---

## Summary

RabbitMQ Server is a multi-protocol messaging and streaming broker built on Erlang/OTP. Its internal architecture is a **Microkernel** (primary style), with the `rabbit` and `rabbit_common` Erlang applications forming the minimal kernel and a rich ecosystem of ~50+ pluggable Erlang applications extending it. The entire system ships and runs as a single Erlang/OTP release, making it simultaneously a **Modular Monolith** in its deployment topology. OTP's actor-based supervision trees give each virtual host, connection, channel, and queue its own fault-isolated process, and an internal event bus (`rabbit_event`) provides internal pub/sub decoupling — but neither of these is topology-defining in the Richards & Ford sense; they are implementation mechanisms within the Microkernel structure.

---

## Evidence

### 1. Microkernel (Primary)

#### 1a. Core Kernel — `deps/rabbit/` and `deps/rabbit_common/`

The minimal kernel provides:

- **Boot coordination:** `rabbit_boot_steps.erl` implements a topologically sorted DAG of boot steps declared via `-rabbit_boot_step` module attributes. Plugins participate by declaring their own boot steps; the kernel sorts and executes them in dependency order. This is the canonical microkernel "initialization protocol" for extensions.
- **Plugin registry:** `deps/rabbit_common/src/rabbit_registry.erl` is a `gen_server` backed by an ETS table. Plugins call `rabbit_registry:register(Class, TypeName, ModuleName)` to register themselves; the kernel looks up implementations at runtime via `rabbit_registry:lookup_module/2`. There is no compile-time enumeration of plugins — discovery is purely dynamic.
- **Plugin lifecycle:** `deps/rabbit/src/rabbit_plugins.erl` handles dynamic enable/disable of Erlang OTP applications at runtime, with `rabbit_event:sync_notify(plugins_changed, ...)` broadcasting the change to interested components.
- **Feature flag framework:** `deps/rabbit/src/rabbit_feature_flags.erl` provides a cluster-wide capability mechanism (`-rabbit_feature_flag()` attribute) that allows the kernel to evolve without breaking mixed-version clusters.

#### 1b. Extension Point Behaviours (Plugin Contracts)

Every major axis of extensibility is modelled as an Erlang behaviour (interface) that plugins implement:

| Behaviour | Location | Implementations |
|---|---|---|
| `rabbit_exchange_type` | `deps/rabbit_common/src/` | `rabbit_exchange_type_direct`, `rabbit_exchange_type_topic`, `rabbit_exchange_type_fanout`, `rabbit_exchange_type_headers`, `rabbit_consistent_hash_exchange`, `rabbit_random_exchange` |
| `rabbit_queue_type` | `deps/rabbit/src/rabbit_queue_type.erl` | `rabbit_classic_queue`, `rabbit_quorum_queue`, `rabbit_stream_queue` |
| `rabbit_backing_queue` | `deps/rabbit/src/rabbit_backing_queue.erl` | `rabbit_variable_queue`, `rabbit_priority_queue` |
| `rabbit_authn_backend` | `deps/rabbit_common/src/rabbit_authn_backend.erl` | `rabbit_auth_backend_internal`, `rabbit_auth_backend_http`, `rabbit_auth_backend_ldap`, `rabbit_auth_backend_oauth2`, `rabbit_auth_backend_cache` |
| `rabbit_authz_backend` | `deps/rabbit_common/src/` | (same set as authn) |
| `rabbit_peer_discovery_backend` | `deps/rabbit_common/src/rabbit_peer_discovery_backend.erl` | `rabbitmq_peer_discovery_k8s`, `rabbitmq_peer_discovery_consul`, `rabbitmq_peer_discovery_etcd`, `rabbitmq_peer_discovery_aws` |
| `rabbit_mgmt_extension` | `deps/rabbitmq_management/src/` | per-protocol management extensions |
| `rabbit_registry_class` | `deps/rabbit_common/src/rabbit_registry_class.erl` | meta-behaviour for registry participants |
| `rabbit_policy_validator` / `rabbit_policy_merge_strategy` | `deps/rabbit/src/` | `rabbit_policies`, `rabbit_quorum_queue`, queue type modules |

All these behaviours are checked and registered at boot via the `-rabbit_boot_step` mechanism; plugins declare `requires, rabbit_registry` to ensure the registry is available before they register.

#### 1c. Plugin Ecosystem (~57 Erlang applications)

The `deps/` directory contains the full plugin set co-located with the kernel in the monorepo:

- **Protocol adapters:** `rabbitmq_mqtt`, `rabbitmq_stomp`, `rabbitmq_amqp1_0`, `rabbitmq_stream`, `rabbitmq_web_mqtt`, `rabbitmq_web_stomp`
- **Auth backends:** `rabbitmq_auth_backend_http`, `rabbitmq_auth_backend_ldap`, `rabbitmq_auth_backend_oauth2`, `rabbitmq_auth_backend_cache`, `rabbitmq_auth_mechanism_ssl`
- **Exchange types:** `rabbitmq_consistent_hash_exchange`, `rabbitmq_random_exchange`, `rabbitmq_recent_history_exchange`, `rabbitmq_jms_topic_exchange`
- **Management:** `rabbitmq_management`, `rabbitmq_management_agent`, `rabbitmq_prometheus`
- **Federation & Shovel:** `rabbitmq_federation`, `rabbitmq_exchange_federation`, `rabbitmq_queue_federation`, `rabbitmq_shovel`
- **Peer discovery:** `rabbitmq_peer_discovery_k8s`, `rabbitmq_peer_discovery_consul`, `rabbitmq_peer_discovery_etcd`, `rabbitmq_peer_discovery_aws`
- **Observability:** `rabbitmq_tracing`, `rabbitmq_top`, `rabbitmq_event_exchange`

Each plugin is an independent Erlang/OTP application that depends on `rabbit` and/or `rabbit_common`, declares its boot steps, registers its behaviours, and can be enabled or disabled at runtime without restarting the broker.

### 2. Modular Monolith (Secondary)

Despite the extensive plugin architecture, all components compile into and run within a single Erlang/OTP release artifact. The `Makefile` and `plugins.mk` define Tier-1 plugins bundled with the release. All plugins run in the same BEAM VM process group. There are no network boundaries between components — extension points are resolved by in-process function calls and message passing. The `deps/` layout enforces structural module separation (each app has its own `src/`, `include/`, `test/`), but runtime coupling is via a shared kernel, not separate deployments.

This secondary Modular Monolith character is confirmed by:
- `erlang.mk` / `Makefile` building a single release
- `rebar.config` listing all apps as workspace members
- `rabbit_plugins.erl` loading/unloading Erlang OTP applications within the same VM
- No Docker Compose or Kubernetes manifests for intra-component isolation in the main repo

### 3. Notable Implementation Patterns (not topology-defining)

**OTP Actor Model:** Every connection (`rabbit_reader`), channel (`rabbit_channel`), queue process (`rabbit_amqqueue_process`), and vhost (`rabbit_vhost_sup`) has its own Erlang process under a supervision tree. Fault isolation is structural, not architectural.

**Internal Event Bus (`rabbit_event`):** Uses `gen_event` for internal pub/sub. Stats emitters call `rabbit_event:notify/2`; management agents, tracing, and other components subscribe. This is a decoupling mechanism within the Microkernel, not an Event-Driven topology.

**Raft-Based Queue Replication:** Quorum queues use the `ra` library (implementing Raft) via `rabbit_fifo.erl` (a `ra_machine` behaviour implementation). Stream queues use the `osiris` append-only log. Both are implemented as queue-type plugins registered via `rabbit_queue_type`.

**Khepri Metadata Store:** `rabbit_khepri.erl` wraps Khepri (a Raft-based tree store), providing a migration path from Mnesia for cluster metadata. The `khepri_db` feature flag gates the migration.

**DB Abstraction Layer:** `deps/rabbit/src/rabbit_db*.erl` modules provide a facade over both Mnesia (legacy) and Khepri (new), with fallback dispatch via `rabbit_khepri:handle_fallback/1`.

---

## Quality Attributes

- **Extensibility:** Behaviour-based extension points and the runtime plugin registry allow new protocols, auth backends, exchange types, and queue types without kernel modification.
- **Fault Tolerance:** OTP supervision trees isolate failures to individual connections, channels, or queues; quorum queues and stream replication provide data-level fault tolerance.
- **Scalability:** Virtual-host isolation, per-queue processes, distributed queue replicas (quorum/stream), and configurable peer-discovery backends for cluster formation.
- **Evolvability:** Feature flags provide a safe mechanism for rolling cluster upgrades; Mnesia-to-Khepri migration path demonstrates deep evolvability investment.
- **Operability:** `rabbitmq_management` HTTP API and UI, `rabbitmq_prometheus` metrics endpoint, `rabbitmq_cli` Elixir CLI commands; all implemented as plugins.
- **Protocol Breadth:** AMQP 0-9-1, AMQP 1.0, MQTT 3.x/5.0, STOMP 1.0-1.2, RabbitMQ Stream Protocol — each a first-class plugin, not a hard-coded feature.
- **Multi-Tenancy:** Virtual hosts each get their own supervisor tree (`rabbit_vhost_sup`), message stores, queues, exchanges, and bindings.

---

## Why Not Other Styles

**Not Microservices:** All components run in the same Erlang VM; there are no independently deployable services with network boundaries. Plugins are OTP applications, not services.

**Not Event-Driven (primary):** `rabbit_event` is an internal instrumentation bus, not the defining communication topology. The broker itself implements message routing — it *is* the event infrastructure for external systems.

**Not Layered (primary):** While there is a layered dependency direction (`rabbit_common` → `rabbit` → plugins), the organizing principle is the kernel/plugin distinction with dynamic registry, not strict horizontal layers with unidirectional architectural boundaries.

**Not Pipeline:** The message routing path (reader → channel → exchange → queue) resembles a pipeline, but there are no composable pipe/filter stages; the path is determined by runtime binding table lookups, not a static topology.
