# argo-workflows — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/argoproj/argo-workflows
**Classification:** Pipeline + Microkernel
**Confidence:** 0.91

## Summary

Argo Workflows is a Kubernetes-native container workflow engine whose primary architectural expression is the Pipeline (DAG/Steps pipe-and-filter) pattern, with a well-defined Microkernel/plugin model enabling extension of artifact backends, template executors, and step-level execution through sidecar plugins. It is deployed as a small set of coordinated processes (workflow-controller, argo-server, argoexec) sharing a single Go module, not independent microservices.

## Evidence

### Directory Structure

```
cmd/
  argo/                   # CLI
  argoexec/               # executor binary injected into workflow pods
  workflow-controller/    # Kubernetes controller binary
workflow/
  controller/             # reconciliation loop, DAG and Steps execution
    dag.go                # dagContext, dependency resolution, DAG traversal
    operator.go           # core workflow operator (~4600 lines)
    steps.go              # sequential/parallel step execution
  executor/               # argoexec in-pod executor
    agent.go              # AgentExecutor coordinating in-pod tasks
    emissary/             # emissary sidecar execution pattern
    plugins/rpc/          # RPC bridge to template executor plugins
  artifacts/              # ArtifactDriver interface + implementations
    common/common.go      # ArtifactDriver interface (Load/Save/OpenStream)
    s3/, gcs/, azure/...  # built-in drivers
    plugin/               # plugin-based artifact driver
server/
  apiserver/argoserver.go # gRPC+HTTP API server (10+ gRPC services registered)
  event/                  # event receipt and async dispatch
  workflow/               # workflow CRUD and streaming
persist/sqldb/            # SQL persistence (workflow archive, offload)
pkg/plugins/
  spec/plugin_types.go    # Plugin/PluginSpec/Sidecar types (microkernel contract)
  executor/               # TemplateExecutor interface
```

### Key Architectural Files

- `workflow/controller/dag.go`: `dagContext` struct holds task dependencies, visited tracking, dependency caching. Methods like `GetTaskDependencies` resolve DAG edges at runtime.
- `workflow/controller/operator.go`: `executeDAG`, `executeSteps`, `executeScript`, `executeResource`, `executePlugin` — the central dispatch table for all template types.
- `workflow/artifacts/common/common.go`: `ArtifactDriver` interface defines the port that all artifact backends implement.
- `pkg/plugins/spec/plugin_types.go`: `Plugin`, `PluginSpec`, `Sidecar` — formal plugin contract including required port, resource, and security context declarations.
- `workflow/executor/plugins/rpc/plugin.go`: RPC bridge calling `template.execute` on sidecar plugins over HTTP.
- `server/apiserver/argoserver.go`: Registers 10 independent gRPC services (Info, Event, EventSource, Sensor, Workflow, WorkflowTemplate, CronWorkflow, ArchivedWorkflow, ClusterWorkflowTemplate, Sync).

### Patterns Found

**Pipeline (DAG/Steps):** The core user-facing abstraction is a workflow as a DAG or sequential Steps structure. Template types include `TemplateTypeDAG`, `TemplateTypeSteps`, `TemplateTypeContainer`, `TemplateTypeScript`, `TemplateTypeResource`, `TemplateTypeHTTP`, `TemplateTypePlugin`. Each step produces outputs (artifacts or parameters) that feed subsequent steps. The emissary sidecar binary captures output parameters and artifacts and places them in a shared volume for handoff.

**Microkernel (Plugin):** Formal plugin contracts at three levels:
1. Template Executor Plugins — sidecar containers with a defined port, resource budget, and security context that implement `ExecuteTemplate(ctx, args, reply)` over RPC.
2. Artifact Driver Plugins — implement the `ArtifactDriver` interface, invokable via the plugin artifact driver (gRPC/Unix socket).
3. The artifact `NewDriver` factory dispatches to built-in drivers (S3, GCS, Azure, HDFS, Git, HTTP, raw, OSS) or the plugin driver.

**Event-Driven (implementation mechanism):** The workflow-controller uses Kubernetes informers + work queues (`workqueue.TypedRateLimitingInterface`) as the reconciliation mechanism. `WorkflowEventBinding` CRDs allow external events to trigger workflow submissions. This is an implementation mechanism rather than the defining architectural style.

**Single-module Monolith (deployment topology):** All components share one `go.mod` module (`github.com/argoproj/argo-workflows/v4`). The workflow-controller, argo-server, and argoexec binaries are compiled from the same module. There are two deployed Kubernetes `Deployment` resources (argo-server, workflow-controller), plus ephemeral per-workflow executor pods.

## Architecture Styles Identified

### Pipeline (Primary)

The dominant user-facing model: workflows are DAGs or sequential Steps where each node is a container step acting as a filter. Artifact passing between steps (outputs of step A become inputs of step B) is the canonical data-flow mechanism. The DAG template type with `depends:` clauses, combined with the artifact system, is a textbook pipe-and-filter architecture at the workflow definition level. The entire execution engine in `workflow/controller/dag.go` and `operator.go` is organized around resolving, ordering, and executing pipeline stages.

### Microkernel (Secondary)

The system exposes formal extension points with well-defined interfaces:
- `TemplateExecutor` plugin interface (RPC over HTTP to sidecar containers)
- `ArtifactDriver` interface with a plugin-based implementation
- `Plugin`/`PluginSpec`/`Sidecar` type contract enforced at registration time

These extension mechanisms allow third-party code to extend the core engine without modifying it, the defining characteristic of the microkernel style.

### Event-Driven (Supporting mechanism)

Kubernetes informers, work queues, and `WorkflowEventBinding` CRDs provide event-driven triggering and reconciliation, but this is the implementation substrate for the pipeline execution engine rather than a primary architectural style.

## Quality Attributes

- **Scalability:** Horizontal scaling of workflow-controller workers; per-workflow pod parallelism; leader election for HA.
- **Extensibility:** Three formal plugin extension points (template executors, artifact drivers, sensor/eventsource via argo-events integration).
- **Reliability:** Rate-limiting work queues, exponential backoff retry, leader election, liveness/readiness probes on all deployments.
- **Observability:** Rich Prometheus/OpenTelemetry metrics (`workflow/metrics/`), distributed tracing (`workflow/tracing/`), structured logging throughout.
- **Security:** RBAC enforcement via Kubernetes service accounts, SSO/OIDC support, read-only root filesystems and `runAsNonRoot` enforced in all container specs.
- **Portability:** Cloud-agnostic; artifact backends for S3, GCS, Azure, HDFS, OSS, HTTP, Git; runs on any Kubernetes cluster.
- **Maintainability:** Single Go module, clear package boundaries by concern (`workflow/controller`, `workflow/executor`, `server/`, `persist/`), extensive test coverage alongside every production file.
- **Interoperability:** gRPC + REST (grpc-gateway) dual protocol API; protobuf-generated clients; Go, TypeScript, Python SDKs.

## Classification Reasoning

The decisive question is: what is the primary organizing principle of the system? For Argo Workflows, it is unambiguously the pipeline metaphor — workflows are DAGs or sequential Steps, every step is a filter container, and data flows via artifacts and output parameters. This drives the entire internal architecture (the DAG executor, steps executor, artifact system, operator dispatch).

The Microkernel label is merited as a secondary style because the plugin system is formal and deliberate: typed interfaces, sidecar contracts with mandatory resource/port/security declarations, RPC bridging, and an artifact plugin sub-system. This is not an ad-hoc escape hatch but a designed extension model.

Confidence is 0.91 (high). The Pipeline classification is strongly supported by both the user-facing API (workflow YAML templates) and the internal execution engine. The Microkernel secondary is clearly evidenced by three distinct plugin subsystems with formal contracts. Minor confidence gap accounts for the fact that the Kubernetes operator/reconciler pattern (event-driven reconciliation) is also a significant structural pattern, though it functions as the delivery mechanism for pipeline execution rather than a primary style in its own right.
