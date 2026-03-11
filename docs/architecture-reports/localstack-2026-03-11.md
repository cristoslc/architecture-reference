# localstack — Architecture Classification Report
**Date:** 2026-03-11
**Repository:** https://github.com/localstack/localstack
**Primary Style(s):** Microkernel, Modular Monolith
**Confidence:** 0.91
**Summary:** A cloud-service emulator structured as a Microkernel (a central gateway + plugin-managed service providers) combined with a Modular Monolith (all AWS service implementations coexist in one deployable Python package), running in a single Docker container.

## Evidence

- `localstack-core/localstack/` — single Python package containing every AWS service emulator: S3, SQS, SNS, DynamoDB, Lambda, Kinesis, EventBridge, CloudFormation, IAM, and ~35 more, all in `localstack/services/<service>/`.
- `plux.ini` — declares plugin namespaces `localstack.aws.provider`, `localstack.runtime.components`, `localstack.runtime.server`, `localstack.hooks.*`, `localstack.extensions`, `localstack.packages`, and ~100 CloudFormation resource providers. Every extensibility point is a `plux` plugin.
- `localstack/aws/app.py` — `LocalstackAwsGateway` wires a `HandlerChain` with 20+ handlers (auth, CORS, codec, routing, service loading, tracing, metrics) plus a `ServiceRequestRouter`; this is the kernel.
- `localstack/aws/chain.py` / `rolo.gateway.HandlerChain` — middleware chain pattern; the kernel dispatches through an ordered chain of request/response handlers before reaching a service plugin.
- `localstack/services/plugins.py` — `ServicePluginManager` wraps a `plux.PluginManager` with lazy-loading, lifecycle states (STARTING, RUNNING, ERROR, STOPPED), and thread-safe plugin initialization. Services are loaded on first request.
- `localstack/services/providers.py` — factory functions decorated with `@aws_provider()` register each AWS service implementation into the `localstack.aws.provider` plugin namespace.
- `localstack/runtime/hooks.py` — lifecycle hooks (`on_infra_start`, `on_infra_ready`, `on_infra_shutdown`, `configure_localstack_container`, `prepare_host`) are themselves plugins, allowing the kernel lifecycle to be extended without modifying core code.
- `localstack/extensions/api/extension.py` — `Extension` base class exposes `update_gateway_routes`, `update_request_handlers`, `update_response_handlers`, `on_platform_start`, `on_platform_ready` — the external plugin surface.
- `localstack/runtime/runtime.py` — `LocalstackRuntime` is the top-level orchestrator: it initializes the filesystem, runs lifecycle hooks, and starts the ASGI/WSGI gateway server.
- `localstack/aws/components.py` — `AwsComponents` is itself a `plux.Plugin` (`localstack.runtime.components`), allowing alternative runtime assemblies (e.g., Snowflake backend) to swap the gateway.
- `localstack/services/stores.py` — `AccountRegionBundle` / `BaseStore` provides per-account/per-region state containers shared within each service plugin; all state is in-process memory (not a separate data tier).
- `localstack/services/lambda_/invocation/` — Lambda service spawns Docker containers per invocation via `DockerRuntimeExecutorPlugin` (another `plux` plugin), demonstrating nested plugin extensibility inside a service plugin.
- `localstack/aws/skeleton.py` — `Skeleton` + `create_dispatch_table` introspect `@handler`-decorated methods on provider classes to build operation dispatch tables, linking the protocol parser output to provider method calls.
- `Dockerfile` — single container image; all services co-deployed; no inter-service networking at runtime.

## Architecture Styles

### Microkernel (Primary — 0.92)
The central kernel is `LocalstackAwsGateway` (the `HandlerChain`-based gateway) plus `ServicePluginManager`. The kernel handles: protocol parsing, authentication, CORS, tracing, metrics, and request routing. Every AWS service is a plugin registered under `localstack.aws.provider` and loaded lazily on first use. The `plux` library provides the plugin registry, discovery, and lifecycle. Additional extensibility surfaces (lifecycle hooks, runtime components, server backends, extensions, packages) are all separate plugin namespaces. Third-party extensions attach via the `localstack.extensions` namespace without modifying core code. This matches the Microkernel pattern precisely: minimal core + independently loadable plug-in modules.

### Modular Monolith (Secondary — 0.88)
All ~35 AWS service implementations live in a single Python package (`localstack-core`) and are co-deployed in one Docker container. Services are separated by module boundaries (`localstack/services/sqs/`, `localstack/services/sns/`, etc.) with consistent internal structure (`provider.py`, `models.py`, `utils.py`, `resource_providers/`). They share a single process, in-memory state stores (`AccountRegionBundle`), and a single network port (4566 by default). There is no database-per-service and no inter-service message bus for cross-service calls — services call each other via in-process `connect_to()` clients or direct imports. This distinguishes it from Microservices: it is a well-structured monolith with enforced module boundaries.

### Event-Driven (Tertiary — 0.60, subordinate)
Event-driven patterns appear as emulated AWS service behavior rather than as a structural principle of LocalStack itself. SNS publishes to SQS via `publisher.py`; Lambda has an `event_manager.py` with an internal SQS-backed async invocation queue (`internal_sqs_queue.py`); EventBridge (`services/events/`) routes events to targets. These are implementations of AWS event-driven services, not the architectural style of LocalStack as a platform. LocalStack's own runtime is synchronous and request/response oriented.

## Quality Attributes

- Modularity — strict per-service module boundaries, consistent internal structure, plugin isolation
- Extensibility — `plux`-based plugin system enables third-party extensions, alternative providers, and alternative server backends without modifying core code
- Deployability — single Docker container, single port; minimal operational footprint
- Testability — full test suite (`tests/unit/`, `tests/integration/`, `tests/aws/`); `testing/` module provides test utilities; snapshot testing support
- Performance Efficiency — lazy service loading (only loaded on first request); optional eager loading via `EAGER_SERVICE_LOADING`; async ASGI server (Hypercorn or Twisted)
- Fault Isolation — service plugin failures are contained; `ServiceState.ERROR` prevents repeated load attempts; per-service lifecycle hooks
- Evolvability — multiple provider variants per service (e.g., `apigateway:default`, `apigateway:legacy`, `apigateway:next_gen`); `plux.ini` switches active provider via config; CloudFormation resource providers as separate plugins
- Observability — metrics collection via `MetricHandler`; per-request tracing handlers; analytics event publishing; structured logging throughout

## Classification Reasoning

LocalStack's dominant architectural characteristic is the **Microkernel** pattern. The evidence is unambiguous:

1. **Kernel definition**: `LocalstackAwsGateway` in `aws/app.py` is the minimal kernel — it handles cross-cutting concerns (authentication, CORS, codec, tracing, metrics, routing) via a `HandlerChain` of 20 handlers, but contains zero AWS service business logic itself.

2. **Plugin system**: `plux` provides a registry-based plugin system with 8+ namespaces. `plux.ini` is the plugin manifest. `ServicePluginManager` is the plugin host. Every service is discovered, loaded, and lifecycle-managed as a plugin.

3. **Plugin isolation**: Service plugins are loaded lazily under a per-service `RLock`. Failures set `ServiceState.ERROR` without crashing the kernel. Plugins can be disabled via `SERVICES` env var.

4. **Extension surface**: The `Extension` class (in `extensions/api/extension.py`) provides a clean external plugin API with hooks into the gateway routes, request handlers, and response handlers — a classic Microkernel extension interface.

5. **Alternative implementations**: Multiple providers per service (`apigateway:default`/`legacy`/`next_gen`; `cloudformation:default`/`engine-legacy`; `events:v1`/`v2`) demonstrate the Microkernel pattern's ability to swap implementations without kernel changes.

**Modular Monolith** is the secondary style because the deployment unit is a single container/process. All service plugins are in one Python package, share in-process memory, and communicate via direct method calls or in-process clients — not network. There is no independent deployability of individual services. The modular boundaries (per-service directories with consistent structure) are enforced by convention, not by deployment isolation.

**Microservices is ruled out**: services share a single process, single port, and in-memory state. There is no per-service database, no inter-service network communication, and no independent deployment.

**Layered is ruled out**: organization is vertical by AWS service domain, not horizontal by technical layer. The `HandlerChain` layers are cross-cutting infrastructure, not business logic tiers.

**Event-Driven is ruled out as a primary style**: LocalStack's runtime is synchronous HTTP request/response. Event-driven patterns appear only inside the emulated AWS services (SNS, SQS, Lambda async invocation), which is LocalStack faithfully emulating AWS behavior, not a structural choice for LocalStack itself.
