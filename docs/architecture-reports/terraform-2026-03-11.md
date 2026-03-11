# terraform — Architecture Classification Report

**Date:** 2026-03-11
**Repo:** https://github.com/hashicorp/terraform
**Classification:** Microkernel + Modular Monolith
**Confidence:** 0.93

## Summary

Terraform is a source-available infrastructure-as-code CLI tool written in Go that converts declarative HCL configuration into provider API calls. Its primary architectural pattern is Microkernel: a stable, minimal core (the CLI, graph engine, state manager, and configuration loader) is extended at runtime by external provider and provisioner plugins that communicate over a gRPC-based protocol (tfplugin5/6). The entire system ships as a single binary compiled from one `go.mod` (Modular Monolith), with 65+ tightly-bounded internal packages organized around clear responsibilities. A newer Stacks subsystem adds an experimental higher-level deployment abstraction on top of the existing engine.

## Evidence

### Directory Structure

```
main.go                          # entry point → CLI runner
commands.go                      # command registry: init/plan/apply/destroy/…
internal/
  command/                       # CLI command implementations (~140 files)
    meta.go                      # shared Meta struct mediating CLI ↔ backend
    arguments/                   # argument parsing layer
    views/                       # human and JSON output rendering
    jsonformat/                   # structured diff rendering
  backend/
    backend.go                   # Backend interface (StateMgr, Workspaces)
    local/                       # default local execution backend
    remote/                      # Terraform Cloud/Enterprise delegation backend
    cloud/                       # HCP Terraform backend
    remote-state/                # pluggable state backends (S3, GCS, Azure, consul, pg, oss, oci, k8s, http, inmem)
    pluggable/                   # pluggable backend host
  terraform/
    context.go                   # Context: central execution orchestrator
    graph_builder_plan.go        # ~30-transformer pipeline building plan DAG
    graph_builder_apply.go       # apply graph builder
    context_plan.go              # Plan() operation
    context_apply.go             # Apply() operation
  dag/
    dag.go                       # AcyclicGraph: topological sort, concurrent walk
  configs/
    config.go                    # Config tree representing module hierarchy
    configload/                  # recursive module loading
  states/
    state.go                     # State type (modules → resources → instances)
    statemgr/                    # Filesystem and remote state managers
    remote/                      # remote state protocol
  providers/
    provider.go                  # Provider Interface (30+ methods)
  provisioners/                  # Provisioner Interface
  addrs/                         # immutable address types for all referenceable objects
  stacks/                        # Stacks subsystem (experimental)
    stackruntime/                # plan/apply evaluation for stacks
    stackconfig/                 # HCL parsing for .tfstack.hcl files
    stackstate/                  # stacks-level state management
  rpcapi/                        # gRPC API bypassing CLI layer
    terraform1/                  # service definitions for automation consumers
  genconfig/                     # HCL code generation from provider schemas
  refactoring/                   # moved/removed block execution on state
  dag/                           # directed acyclic graph engine
  promising/                     # async promise primitives for stacks eval
  tfplugin5/                     # generated protobuf stubs (plugin protocol v5)
  tfplugin6/                     # generated protobuf stubs (plugin protocol v6)
docs/
  architecture.md                # official architectural narrative
  plugin-protocol/
    tfplugin6.proto              # gRPC service definition for provider plugins
```

### Plugin Protocol (Microkernel Core Evidence)

`docs/plugin-protocol/tfplugin6.proto` defines the `Provider` gRPC service with ~25 RPC methods:

- **Schema & capability negotiation**: `GetMetadata`, `GetProviderSchema`, `GetResourceIdentitySchemas`
- **Validation**: `ValidateProviderConfig`, `ValidateResourceConfig`
- **Resource lifecycle**: `ReadResource`, `PlanResourceChange`, `ApplyResourceChange`, `ImportResourceState`, `MoveResourceState`
- **Data sources**: `ReadDataSource`
- **Ephemeral resources**: `OpenEphemeralResource`, `RenewEphemeralResource`, `CloseEphemeralResource`
- **Advanced**: `CallFunction`, `ListResource`, `PlanAction`, `InvokeAction`, state store operations

Providers are normal executable binaries that expose this gRPC service. Terraform Core discovers, downloads (via `internal/getproviders`), launches, handshakes, and connects to each as a gRPC client. The go-plugin library (`github.com/hashicorp/go-plugin v1.7.0`) manages the subprocess lifecycle.

### Graph Engine (Core Mechanism)

`internal/dag`: An `AcyclicGraph` supporting topological ordering, transitive reduction, cycle detection, and concurrent vertex walking with "happens-after" edge semantics.

`internal/terraform/graph_builder_plan.go` constructs the plan graph by composing ~30 `GraphTransformer` implementations in a fixed sequence:
1. `ConfigTransformer` — creates vertices from configuration resource blocks
2. `StateTransformer` — adds vertices for tracked resource instances
3. `ReferenceTransformer` — builds dependency edges from HCL expression analysis
4. `ProviderTransformer` — links resources to provider vertices
5. `OrphanResourceInstanceTransformer` — adds orphan cleanup nodes
6. `TargetsTransformer`, `DestroyEdgeTransformer`, `TransitiveReductionTransformer` — graph refinement and optimization

Graph walks execute concurrent vertex evaluation where no dependency edge separates nodes (parallelism default: 10, controlled by semaphore in `Context`).

### Backend Interface (State Separation)

`internal/backend/backend.go` defines a minimal `Backend` interface: `ConfigSchema`, `PrepareConfig`, `Configure`, `StateMgr`, `DeleteWorkspace`, `Workspaces`. State management is fully delegated to the `statemgr.Full` object returned by `StateMgr()`. This allows 10+ remote-state backend implementations (S3, GCS, Azure Blob, Consul, PostgreSQL, Kubernetes Secrets, OCI, Alibaba OSS, HTTP, in-memory) to be swapped without changing core logic.

The Cloud backend (`internal/cloud/`) wraps the TFE API client and proxies operations to HCP Terraform remote workspaces, falling back to the local backend when workspace execution mode is set to `local`.

### Module Hierarchy (Configuration)

`internal/configs/config.go`: A `Config` tree mirrors the static module hierarchy. Each node holds a `Module`, parent/child pointers, and path information. Loaded recursively by `configload.Loader`, producing a single `configs.Config` representing the entire configuration. This is the static tree; runtime instances expand from `count`/`for_each` during graph execution.

### Address System

`internal/addrs/`: Every referenceable object (resource instance, module instance, provider, variable, output, check rule, etc.) has an immutable typed address with both a string/HCL traversal form and an in-memory form. Local and absolute (`Abs`) variants handle module-relative vs. root-relative contexts.

### Stacks Subsystem

`internal/stacks/`: An experimental higher-order abstraction above modules. A Stack is an instantiated `StackConfig` with explicit repetition, first-class component lifecycle management, phase-aware evaluation (plan vs. apply), and its own state representation (`stackstate`). Uses a promise-based async evaluation model (`internal/promising`) to manage inter-component dependencies during planning.

### RPC API Layer

`internal/rpcapi/`: A gRPC API ("handled differently because the whole point of this interface is to bypass the CLI layer so wrapping automation can get as-direct-as-possible access to Terraform Core functionality"). Exposes Packages, Dependencies, Setup, and Stacks services. Registered as a hidden command `rpcapi`.

### Key External Dependencies (Architectural Signal)

| Dependency | Architectural Role |
|---|---|
| `github.com/hashicorp/go-plugin v1.7.0` | Plugin subprocess management and gRPC bridge |
| `github.com/hashicorp/hcl/v2` | HCL configuration language parsing |
| `github.com/zclconf/go-cty` | Type system for provider schema values |
| `github.com/hashicorp/go-tfe v1.94.0` | HCP Terraform/Enterprise API client |
| `google.golang.org/grpc` | Plugin protocol transport |
| `github.com/hashicorp/terraform-svchost` | Service discovery for registry/cloud endpoints |
| `go.opentelemetry.io/*` | Distributed tracing support |

## Architecture Styles

### Primary: Microkernel

Terraform is canonically a Microkernel system. The kernel is the graph engine + CLI + state manager + configuration loader. All resource-type-specific logic (API calls, schema definitions, lifecycle methods) lives in external provider plugins. The kernel:

- Defines the plugin contract (gRPC protocol, version negotiation via `ServerCapabilities`/`ClientCapabilities`)
- Discovers and downloads plugins from the registry
- Launches plugins as child processes (go-plugin)
- Connects as gRPC client and drives the resource lifecycle through the `Provider` interface
- Composes plugins into a DAG and evaluates them concurrently

This is the explicit design intent: README states "This repository contains only Terraform core... Providers are implemented as plugins."

Backends follow a compiled-in variant of the same pattern: a `Backend` interface with multiple implementations. The code notes they are hardcoded rather than truly external because "supporting that over the plugin system is currently prohibitively difficult."

### Secondary: Modular Monolith

The kernel itself is a well-factored monolith:

- Single Go module (`go.mod`), single deployable binary
- 65+ internal packages each with bounded responsibility
- Clear dependency direction: `command` → `backend` → `terraform` (context/graph) → `configs`/`states`/`providers`/`dag`
- No runtime service boundaries within the kernel; all in-process

The stacks remote-state backends use separate `go.mod` files (e.g., `internal/backend/remote-state/azure/go.mod`) to manage conflicting SDK dependencies, but they compile into the same binary.

## Quality Attributes

| Attribute | Assessment |
|---|---|
| **Extensibility** | Very High — any team can publish a provider without touching Terraform Core |
| **Correctness** | Very High — DAG-based dependency tracking with cycle detection; typed values via go-cty |
| **Concurrency** | High — graph walks parallelize independent nodes up to configurable limit |
| **Portability** | High — single static Go binary; runs on Linux, macOS, Windows |
| **Testability** | High — package-level isolation; extensive testdata fixtures; mock provider interfaces |
| **Operational simplicity** | High — one binary, no runtime daemon, local state by default |
| **Evolvability** | Medium-High — plugin protocol versioning (v5/v6) allows backward-compatible provider updates; Stacks is additive |
| **Observability** | Medium — OpenTelemetry tracing; JSON output mode; limited metrics |

## Qualifiers / Cross-Cutting Patterns

- **Graph-Based Execution**: The DAG engine is the dominant execution model — not incidental, but the explicit organizing principle of the core engine. All plan and apply operations are graph walks.
- **Pipeline (Graph Construction)**: The ~30-step `GraphTransformer` composition in graph builders is a sequential transformation pipeline that produces the execution graph. This is internal to the Microkernel, not an architectural style at the system level.
- **Plugin Protocol Versioning**: Explicit v5/v6 protocol generations with forward-capability negotiation, enabling provider SDK evolution without core rebuilds.
- **Declarative Input, Imperative Execution**: Users write declarative HCL; Terraform resolves ordering and concurrency internally.
- **Separation of Plan and Apply**: The two-phase design (plan produces a diff; apply executes it) is a fundamental architectural invariant enforced throughout the codebase.

## Rejected Styles

- **Microservices**: Single binary, single process. Providers are child processes spawned per-run, not independently deployed network services. No service mesh, no inter-service HTTP.
- **Layered**: While a request flow exists (CLI → Backend → Context → Graph), the system is organized around the plugin contract and graph model, not horizontal abstraction layers with strict upward dependency rules.
- **Pipeline (system-level)**: The pipeline pattern appears inside the graph builder, but the overall system architecture is plugin-host + graph engine, not a data-flow pipeline.
- **Event-Driven**: No event bus, message queue, or publish/subscribe; all coordination is synchronous or via Go channels within a single process.
