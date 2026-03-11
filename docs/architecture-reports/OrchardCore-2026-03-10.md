---
project: "OrchardCore"
date: 2026-03-10
scope: framework
use-type: production
primary-language: C#
confidence: 0.93
styles:
  - name: Microkernel
    role: primary
    confidence: 0.94
  - name: Modular Monolith
    role: secondary
    confidence: 0.88
  - name: Pipeline
    role: secondary
    confidence: 0.72
---

# Architecture Analysis: OrchardCore

## Metadata

| Field | Value |
|---|---|
| Project | OrchardCore |
| Version | 3.0.0 (main branch) |
| Repo | https://github.com/OrchardCMS/OrchardCore |
| Date | 2026-03-10 |
| Scope | framework |
| Use-type | production |
| Primary Language | C# |
| Other Languages | JavaScript, TypeScript |

## Style Rationales

**Microkernel (primary, 0.94):** The entire system is built around a formal extension kernel. `IExtensionManager` (src/OrchardCore/OrchardCore.Abstractions/Extensions/IExtensionManager.cs) manages dynamic loading of extensions and their features. Each of the 94 modules in `src/OrchardCore.Modules/` declares itself via `[Module]` and `[Feature]` assembly attributes (e.g., `Manifest.cs` in every module), with explicit `Dependencies` arrays that the kernel resolves at startup through `ExtensionManager.cs`. `IShellHost` manages an independent DI container (`ShellContext`) per tenant, and `ModularTenantContainerMiddleware` swaps the active service provider per HTTP request. Features can be individually enabled or disabled per tenant at runtime via `IShellDescriptorFeaturesManager.UpdateFeaturesAsync()`, demonstrating true plug-in lifecycle management rather than compile-time composition. `IStartup.ConfigureServices()` / `IStartup.Configure()` on each module is the plug-in contract.

**Modular Monolith (secondary, 0.88):** All 94 modules deploy as a single ASP.NET Core process (one Dockerfile builds `OrchardCore.Cms.Web.dll`, one `dotnet run`). `OrchardCoreBuilder.ConfigureServices()` wires every tenant's modules into a shared in-process DI container per tenant shell. The `ShellDescriptor` records the list of enabled `ShellFeature` entries stored in a single YesSql/SQL database shared per tenant. There is no inter-module network boundary; modules communicate through shared DI interfaces (e.g., `IContentManager`, `IContentHandler`, `IWorkflowManager`). Horizontal scaling is achieved by running multiple identical process instances behind a load balancer with the optional Redis (`OrchardCore.Redis.*`) modules providing distributed cache and distributed lock.

**Pipeline (secondary, 0.72):** The recipe/deployment subsystem implements a formal pipeline: `IRecipeStep` handlers (one per module, e.g., `AdminMenuStep`, `WorkflowTypeStep`, `UrlRewritingStep`) process JSON recipe documents sequentially stage-by-stage. Content item lifecycle is expressed as a chain of before/after handler pairs (`ContentHandlerBase`: `CreatingAsync`/`CreatedAsync`, `PublishingAsync`/`PublishedAsync`, `RemovingAsync`/`RemovedAsync`, etc.) invoked sequentially by `ContentPartHandlerCoordinator`. Display rendering uses `IDisplayManager` with ordered display driver invocations. The Workflows module (`WorkflowManager.cs`) adds a visual DAG-based activity pipeline for user-defined automation flows.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `IExtensionManager`, `ExtensionManager`, feature dependency graph | `src/OrchardCore/OrchardCore/Extensions/ExtensionManager.cs` | Microkernel |
| `[Module]`/`[Feature]` assembly attributes on all 94 modules | `src/OrchardCore.Modules/*/Manifest.cs` | Microkernel |
| `IShellHost`, `ShellHost` – per-tenant DI container lifecycle | `src/OrchardCore/OrchardCore/Shell/ShellHost.cs` | Microkernel |
| `ModularTenantContainerMiddleware` – per-request container swap | `src/OrchardCore/OrchardCore/Modules/ModularTenantContainerMiddleware.cs` | Microkernel |
| `IShellDescriptorFeaturesManager.UpdateFeaturesAsync()` – runtime feature toggle | `src/OrchardCore/OrchardCore.Abstractions/Shell/IShellDescriptorFeaturesManager.cs` | Microkernel |
| Single `dotnet publish` → single binary; single `ENTRYPOINT` | `Dockerfile` | Modular Monolith |
| `OrchardCoreBuilder` accumulates all module `IStartup` registrations in-process | `src/OrchardCore/OrchardCore.Abstractions/Modules/Builder/OrchardCoreBuilder.cs` | Modular Monolith |
| `ShellDescriptor` with `IList<ShellFeature>` in one YesSql session | `src/OrchardCore/OrchardCore.Abstractions/Shell/Descriptor/Models/ShellDescriptor.cs` | Modular Monolith |
| Redis distributed cache, bus, lock modules for horizontal scale | `src/OrchardCore.Modules/OrchardCore.Redis/Manifest.cs` | Modular Monolith |
| `IRecipeStep` per-module handlers executed sequentially | `src/OrchardCore.Modules/*/Recipes/*Step.cs` | Pipeline |
| `ContentHandlerBase` before/after paired lifecycle hooks | `src/OrchardCore/OrchardCore.ContentManagement.Abstractions/Handlers/ContentHandlerBase.cs` | Pipeline |
| `WorkflowManager` DAG activity pipeline with `IActivityLibrary` | `src/OrchardCore.Modules/OrchardCore.Workflows/Services/WorkflowManager.cs` | Pipeline |
| `IHealthChecksResponseWriter`, `AddHealthChecks()` | `src/OrchardCore.Modules/OrchardCore.HealthChecks/Startup.cs` | Observability |
| `ModularBackgroundService` schedules `IBackgroundTask` per shell | `src/OrchardCore/OrchardCore/Modules/ModularBackgroundService.cs` | Evolvability |

## Quality Attributes

- **Modularity**: 94 independently packaged modules with `[Module]`/`[Feature]` metadata and explicit dependency declarations; features enabled/disabled per tenant at runtime without recompilation.
- **Deployability**: Single-binary Docker image; optional Redis modules enable multi-instance horizontal deployment with shared distributed state; recipe/deployment module for environment promotion via JSON snapshots.
- **Evolvability**: `IStartup`-based plug-in contract allows new modules to be added without touching existing code; `IShellDescriptorFeaturesManager` enables safe feature rollout per tenant; Migrations pattern for schema evolution.
- **Fault Tolerance**: `IDistributedLock` (local `LocalLock` or Redis `RedisLock`) prevents concurrent workflow execution and index rebuild races; `ModularBackgroundService` isolates per-shell background failures; shell reload retries up to 9 times on transient errors.
- **Scalability**: Redis distributed cache, bus, and lock decouple state for multi-node deployments; `ShellHost` supports hundreds of tenant shells each with independent feature sets and DI containers.
- **Observability**: Built-in `HealthChecks` module (`/health` endpoint with configurable detail level); `AuditTrail` module for event logging; NLog integration in the CMS web host (`UseNLogHost()`).
