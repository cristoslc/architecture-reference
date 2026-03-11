# Architecture Report: Netflix Conductor

**Date:** 2026-03-11
**Repo URL:** https://github.com/Netflix/conductor
**Classification:** Microkernel, Hexagonal Architecture, Modular Monolith
**Confidence:** 0.92

---

## Summary

Netflix Conductor is a workflow orchestration platform built as a single deployable Spring Boot application. Its architecture is structured around three interlocking styles: a **Microkernel (Plugin)** core that defines extension points for tasks, persistence, queuing, locking, and event queues; a **Hexagonal Architecture** that cleanly separates domain ports (DAO interfaces) from infrastructure adapters (Redis, Cassandra, Elasticsearch implementations); and a **Modular Monolith** physical structure composed of 20+ Gradle subprojects that compile into one `conductor-server.jar`. Event-driven patterns are present internally (Spring `ApplicationEventPublisher` for workflow lifecycle events, `ObservableQueue` for external event ingestion) but are a secondary structural feature rather than the primary architectural style.

---

## Evidence from Code Exploration

### Module Structure (settings.gradle)

The build file declares 20+ Gradle subprojects with a consistent `conductor-*` prefix:

```
include 'annotations', 'annotations-processor'
include 'server', 'common', 'core', 'client', 'client-spring'
include 'cassandra-persistence', 'redis-persistence'
include 'es6-persistence', 'redis-lock'
include 'awss3-storage', 'awssqs-event-queue', 'redis-concurrency-limit'
include 'json-jq-task', 'http-task'
include 'rest', 'grpc', 'grpc-server', 'grpc-client'
include 'java-sdk', 'test-harness'
```

All 20+ modules assemble into a single Spring Boot JAR via the `server` module's `bootJar` task with `mainClass = 'com.netflix.conductor.Conductor'`.

### Hexagonal Architecture: Ports (DAO Interfaces in `conductor-core`)

The `core` module defines eight pure Java interfaces in `com.netflix.conductor.dao`:

- `ExecutionDAO` — workflow and task execution storage
- `QueueDAO` — queue push/pop/ack/nack operations
- `MetadataDAO` — workflow and task definition CRUD
- `IndexDAO` — full-text search and indexing
- `EventHandlerDAO` — event handler registration
- `PollDataDAO` — worker polling metadata
- `RateLimitingDAO` — rate limiting data
- `ConcurrentExecutionLimitDAO` — concurrency enforcement

These interfaces contain no implementation detail. They are the "ports" of the hexagonal model.

### Hexagonal Architecture: Adapters (Infrastructure Modules)

Multiple modules provide implementations of these ports, selected via Spring `@Conditional` annotations:

- `conductor-redis-persistence`: `RedisExecutionDAO`, `RedisMetadataDAO`, `RedisQueueDAO`
- `conductor-cassandra-persistence`: `CassandraExecutionDAO`, `CassandraMetadataDAO`
- `conductor-es6-persistence`: `ElasticSearchDAOV6` (implements `IndexDAO`)
- `conductor-awss3-storage`: external payload storage adapter
- `conductor-awssqs-event-queue`: `SQSObservableQueue` (implements `ObservableQueue`)
- `conductor-redis-lock`: `RedisLock` (implements `Lock`)

### Microkernel Plugin Architecture

The core defines `WorkflowSystemTask` as the abstract plugin contract with three lifecycle hooks:

```java
public abstract class WorkflowSystemTask {
    public void start(WorkflowModel workflow, TaskModel task, WorkflowExecutor executor) {}
    public boolean execute(WorkflowModel workflow, TaskModel task, WorkflowExecutor executor) { return false; }
    public void cancel(WorkflowModel workflow, TaskModel task, WorkflowExecutor executor) {}
}
```

`SystemTaskRegistry` auto-discovers all registered `WorkflowSystemTask` implementations via Spring DI injection of `Set<WorkflowSystemTask>`, mapping them by task type at startup. Optional plugin modules extend this:

- `conductor-http-task`: `HttpTask extends WorkflowSystemTask`
- `conductor-json-jq-task`: JSON processing task
- Built-in tasks: `Fork`, `Join`, `ExclusiveJoin`, `Switch`, `Decision`, `DoWhile`, `SubWorkflow`, `Wait`, `Human`, `Lambda`, `Inline`, `SetVariable`, `Terminate`, `Event`, `StartWorkflow`

The `EventQueueProvider` interface extends the microkernel pattern to external event queues: `SQSEventQueueProvider` implements `EventQueueProvider`, registered via `EventQueues` which maintains a map of `type -> provider`.

### Event-Driven Patterns (Internal + External)

**Internal (Spring events):** `WorkflowExecutor` uses Spring's `ApplicationEventPublisher` to publish `WorkflowCreationEvent` and `WorkflowEvaluationEvent`. The `@EventListener(WorkflowEvaluationEvent.class)` annotation wires `handleWorkflowEvaluationEvent` within the same JVM.

**External (Observable queues):** The `ObservableQueue` interface (extending `rx.Observable`) abstracts external message queues (SQS, AMQP, Conductor internal). `DefaultEventProcessor` subscribes to these queues to trigger workflow actions based on event handlers stored in `EventHandlerDAO`.

**Task Queues:** `QueueDAO` provides a poll/ack task dispatch model: workers poll REST endpoints (`/tasks/poll/{taskType}`) and post results back. This is an orchestration-pull pattern, not a reactive event-driven push.

### Deployment Topology (docker-compose.yaml)

```yaml
services:
  conductor-server:    # single Spring Boot container
  conductor-redis:     # external Redis for queuing + persistence
  conductor-elasticsearch:  # external ES for indexing
```

A single `conductor-server` container runs all application logic. Redis and Elasticsearch are infrastructure concerns, not separate application services.

### Layered Internal Organization

Within the server, packages follow a clear layered hierarchy:

- `conductor-rest` / `conductor-grpc-server` — Presentation (REST + gRPC endpoints)
- `conductor-core` / `service/` — Application services (`WorkflowServiceImpl`, `TaskServiceImpl`, `MetadataServiceImpl`)
- `conductor-core` / `execution/` — Domain logic (`WorkflowExecutor`, `DeciderService`)
- `conductor-core` / `dal/` + `dao/` — Data access abstraction layer
- `conductor-*-persistence` — Infrastructure adapters

---

## Architecture Styles Identified

### Primary: Microkernel (Plugin Architecture)
- **Evidence:** `WorkflowSystemTask` abstract base class + `SystemTaskRegistry` auto-discovery; `EventQueueProvider` interface with SQS/AMQP/Conductor implementations; `Lock` interface with `NoopLock`, `LocalOnlyLock`, `RedisLock` implementations; `ExternalPayloadStorage` with S3 adapter. All extension points are defined as interfaces/abstract classes in `core` and discovered via Spring DI.
- **Confidence:** Very high. The entire module decomposition strategy is plug-in oriented.

### Primary: Hexagonal Architecture (Ports and Adapters)
- **Evidence:** Eight pure DAO interfaces in `core` with zero implementation code; multiple infrastructure modules implementing these ports; `@ConditionalOnProperty`/`@Conditional` annotations for runtime adapter selection. The `core` module has no compile-time dependency on any adapter module — all wiring happens in `server`.
- **Confidence:** Very high.

### Primary: Modular Monolith
- **Evidence:** Single `bootJar` output from `server/build.gradle`; all modules included as `implementation project(...)` dependencies in `server/build.gradle`; one Docker container in `docker-compose.yaml`; enforced module boundaries via Gradle's explicit dependency declarations (no circular dependencies possible).
- **Confidence:** Very high.

### Secondary: Event-Driven
- **Evidence:** Spring `ApplicationEventPublisher` for internal workflow lifecycle events; `ObservableQueue` + `DefaultEventProcessor` for external event ingestion; `WorkflowStatusListener` and `TaskStatusListener` extension interfaces. However, the primary task-dispatch model is polling (REST pull), not event push.
- **Confidence:** Moderate — present but structurally secondary.

### Rejected Styles

- **Microservices:** Single deployable unit. No independent deployment of components, no service-to-service network calls within the application.
- **Service-Based:** While REST and gRPC APIs exist, they expose the monolithic application externally — they are not internal boundaries.
- **CQRS:** The same DAO interfaces handle reads and writes. `IndexDAO` for search is a technical optimization, not a CQRS command/query model split.
- **Pipeline:** Conductor *orchestrates* pipelines for external workers but is not itself structured as a data pipeline.
- **Domain-Driven Design:** Domain concepts exist (Workflow, Task, WorkflowDef) but the code is not organized around bounded contexts, aggregates, and domain events as a primary structuring mechanism.

---

## Quality Attributes

| Attribute | Justification |
|---|---|
| **Extensibility** | Microkernel plugin system allows adding new task types, storage backends, queue adapters, and lock implementations without modifying core. `@ConditionalOnProperty` enables runtime feature toggling. |
| **Testability** | DAO interfaces enable in-memory test doubles. Modules have explicit test harness (`conductor-test-harness`). `@ConditionalOnProperty` allows disabling features in test contexts. |
| **Maintainability** | Clear module separation (20+ Gradle submodules) enforces single-responsibility boundaries. `conductor-common` defines shared models without coupling to infrastructure. |
| **Scalability** | Stateless server design with Redis-backed queues allows horizontal scaling. `sweeperThreadCount`, `systemTaskWorkerThreadCount`, and `eventProcessorThreadCount` are configurable. Distributed locking via Redis prevents double-execution. |
| **Operability** | Spring Boot Actuator, Prometheus metrics endpoint, Datadog export, structured logging with log4j2, health check endpoints in REST and gRPC. |
| **Reliability** | `WorkflowSweeper` / `WorkflowReconciler` provide background repair for workflows that miss state transitions. Retry templates via Spring Retry. Distributed locking prevents race conditions. |
| **Portability** | Pluggable persistence (Redis/Cassandra), indexing (ES6/ES7), queuing (Redis/SQS/AMQP), and locking (Noop/Local/Redis/Zookeeper) allow deployment in diverse infrastructure environments. |

---

## Classification Reasoning

Netflix Conductor's architecture is most precisely described as a **Microkernel + Hexagonal Architecture** system deployed as a **Modular Monolith**.

The Microkernel pattern governs extensibility: the `core` module is a stable "kernel" that defines abstract extension points (`WorkflowSystemTask`, `EventQueueProvider`, `Lock`, `ExternalPayloadStorage`) and an auto-discovery mechanism (`SystemTaskRegistry`, `EventQueues`). Optional plugin modules (`http-task`, `json-jq-task`, `awssqs-event-queue`, `redis-lock`, `awss3-storage`) register implementations without touching the kernel.

The Hexagonal Architecture pattern governs infrastructure isolation: the `core` module defines DAO ports as pure Java interfaces, and all infrastructure modules (Redis, Cassandra, Elasticsearch) implement these ports as adapters, selected at runtime via Spring conditional annotations. The `server` module is the "application assembly" that wires ports to adapters — an explicit hexagonal composition root.

The Modular Monolith designation reflects the physical deployment model: all modules compile into a single Spring Boot JAR deployed as one container, with shared in-process memory and no network boundaries between components.

Event-driven patterns are present (Spring events, `ObservableQueue`, status listeners) but serve as implementation mechanisms within the monolith rather than a primary architectural style. The core task dispatch model (worker polling) is synchronous request-response at the API boundary.

The prior classification (Hexagonal Architecture + Modular Monolith + Microkernel) in the existing YAML is correct. This re-analysis confirms and strengthens that classification with deeper evidence. Confidence is raised to 0.92 given the clear structural consistency of all three styles throughout the codebase.
