# Architecture Report: microservices-demo (Online Boutique)

**Date:** 2026-03-11
**Source URL:** https://github.com/GoogleCloudPlatform/microservices-demo
**Classification:** Microservices
**Confidence:** 0.98
**Method:** deep-analysis
**Model:** claude-sonnet-4-6

---

## Summary

Online Boutique is Google Cloud Platform's canonical Kubernetes-native microservices reference application — a web-based e-commerce demo composed of 11 independently deployable services that communicate exclusively over synchronous gRPC using a shared Protocol Buffers contract. It is authored in five different programming languages and designed to showcase GKE, Cloud Service Mesh, gRPC, Cloud Operations (OpenTelemetry), and optional managed cloud services (Spanner, Memorystore, AlloyDB, Gemini). There is no shared process boundary, no message broker, and no event-driven communication; every cross-service call is a synchronous RPC.

---

## Service Inventory

| Service | Language | Port | Role |
|---|---|---|---|
| frontend | Go | 8080 (HTTP) | Web BFF — aggregates gRPC calls from all backend services |
| cartservice | C# / .NET | 7070 (gRPC) | Session cart stored in Redis |
| productcatalogservice | Go | 3550 (gRPC) | Product listing from JSON file |
| currencyservice | Node.js | 7000 (gRPC) | Currency conversion using ECB rates |
| paymentservice | Node.js | 50051 (gRPC) | Mock credit-card charge |
| shippingservice | Go | 50051 (gRPC) | Shipping quote and mock fulfillment |
| emailservice | Python | 5000 (gRPC) | Mock order-confirmation email |
| checkoutservice | Go | 5050 (gRPC) | Orchestrates the full order flow |
| recommendationservice | Python | 8080 (gRPC) | Product recommendations |
| adservice | Java | 9555 (gRPC) | Context-based text advertisements |
| shoppingassistantservice | Python | 8080 (HTTP/REST) | Optional: Gemini + AlloyDB RAG assistant |
| loadgenerator | Python (Locust) | — | Synthetic traffic generator |

---

## Architecture Classification

**Primary style: Microservices**

The codebase satisfies every defining criterion of the Microservices style:

1. **Independent deployability.** Each service lives in its own subdirectory (`src/<service>/`), has its own `Dockerfile`, its own Kubernetes `Deployment` and `Service` manifest in `kubernetes-manifests/`, and its own Skaffold build context. Services can be built, pushed, and redeployed independently without touching other containers.

2. **Single-service, single-responsibility.** Each service owns exactly one business capability: cart state, product catalog, currency conversion, payment charging, shipping quotes, email notification, checkout orchestration, ad serving, or recommendations. There is no shared library that contains domain logic crossing service boundaries.

3. **Database-per-service.** `cartservice` connects exclusively to its own `redis-cart` Redis instance (injected via `REDIS_ADDR`). No other service touches that Redis. Optional kustomize overlays support replacing Redis with Cloud Memorystore, Spanner, or AlloyDB — all owned solely by `cartservice`. There is no shared relational database across services.

4. **Polyglot implementation.** Services are written in Go (frontend, checkoutservice, productcatalogservice, shippingservice), C# (cartservice), Node.js (currencyservice, paymentservice), Python (emailservice, recommendationservice, shoppingassistantservice, loadgenerator), and Java (adservice). Technology choice per service is unconstrained.

5. **Synchronous gRPC communication.** All inter-service calls are synchronous request/response gRPC calls defined in a single shared `protos/demo.proto` contract. Nine services expose a gRPC server; clients hold persistent `grpc.ClientConn` instances connected at startup. There is no publish/subscribe mechanism, no message queue (Kafka, RabbitMQ, Pub/Sub, NATS), and no asynchronous event bus anywhere in the codebase.

6. **Service mesh ready.** Kubernetes manifests include an Istio annotation (`sidecar.istio.io/rewriteAppHTTPProbers: "true"` on the frontend), and the `kustomize/components/service-mesh-istio/` overlay enables full Istio mTLS and traffic management. Istio serves as the cross-cutting infrastructure layer (observability, security, traffic control).

7. **Distributed tracing.** Go services (frontend, checkoutservice, productcatalogservice, shippingservice) instrument OpenTelemetry with OTLP gRPC export. Node.js services use `@opentelemetry/instrumentation-grpc`. This is a characteristic cross-cutting concern handled through instrumentation rather than shared code.

---

## Communication Topology

```
Browser
  └── frontend (HTTP :8080)
        ├── productcatalogservice (gRPC)
        ├── currencyservice (gRPC)
        ├── cartservice (gRPC) --> redis-cart
        ├── recommendationservice (gRPC) --> productcatalogservice (gRPC)
        ├── checkoutservice (gRPC)
        │     ├── cartservice (gRPC)
        │     ├── productcatalogservice (gRPC)
        │     ├── currencyservice (gRPC)
        │     ├── shippingservice (gRPC)
        │     ├── paymentservice (gRPC)
        │     └── emailservice (gRPC)
        ├── shippingservice (gRPC)
        ├── adservice (gRPC)
        └── shoppingassistantservice (HTTP, optional)
```

All communication paths are synchronous. `checkoutservice` is the heaviest orchestrator, fanning out to six downstream services in sequence to complete a `PlaceOrder` operation.

---

## Why Not Other Styles

- **Not Event-Driven:** No message broker, no pub/sub topics, no async queues anywhere. All calls block on gRPC responses.
- **Not Service-Based:** Services are fine-grained single-capability units, not coarse-grained domain services grouping multiple business capabilities. Deployment granularity is per-service-per-container, not per-domain-cluster.
- **Not Modular Monolith:** Each service is a separate process with its own binary and container image. There is no shared runtime or monorepo module boundary.
- **Not CQRS:** There is no read-model / write-model split, no command bus, and no event sourcing. `cartservice` does maintain alternative datastore adapters (Redis, Spanner, AlloyDB) but they are storage backends for the same CRUD model, not CQRS read/write sides.
- **Not Serverless:** Services run as always-on Kubernetes `Deployment` replicas, not function-as-a-service invocations.
- **Not Hexagonal / DDD:** There is no explicit ports-and-adapters structuring of inbound/outbound adapters, no domain layer isolation, and no explicit bounded-context design beyond natural service separation. The `shoppingassistantservice` (optional RAG pipeline using LangChain + Gemini) uses a simple Flask HTTP handler, not a port/adapter structure.

---

## Quality Attributes

- **Scalability:** Independent horizontal scaling of each service via Kubernetes Deployment replicas.
- **Deployability:** Per-service Docker images + Kubernetes manifests + Skaffold + Kustomize enable independent CI/CD pipelines.
- **Observability:** OpenTelemetry distributed tracing (OTLP), gRPC health checks on every service, Cloud Operations integration, structured JSON logging via logrus/pino/log4j.
- **Fault Tolerance:** gRPC health probes for readiness/liveness; services degrade gracefully (e.g., checkout warnings on email failure without aborting the order).
- **Maintainability:** Polyglot services can be iterated independently; shared contract enforced by proto definitions.
- **Testability:** Each service has its own test directory; the load generator (`Locust`) exercises end-to-end user flows.
- **Cloud Portability:** Runs on any Kubernetes cluster (kind, GKE, AKS, EKS) by default; GCP-specific extensions are opt-in kustomize overlays.
- **Security:** Non-root containers, read-only root filesystems, dropped Linux capabilities, optional Istio mTLS enforced per overlay.

---

## Evidence Summary

| Evidence Type | Detail |
|---|---|
| Directory structure | 12 independent service directories each with dedicated Dockerfile and build context |
| Kubernetes manifests | 11 separate Deployment + Service + ServiceAccount trios in `kubernetes-manifests/` |
| Proto definitions | `protos/demo.proto` defines 9 separate gRPC service contracts; no shared domain library |
| Checkout orchestration | `checkoutservice/main.go` connects to 6 downstream gRPC services via environment-injected addresses |
| Frontend BFF | `frontend/main.go` `frontendServer` struct holds 7 independent gRPC client connections |
| No messaging | Zero references to kafka, pubsub, rabbitmq, NATS, or any queue/topic primitive across all source files |
| Polyglot | Go, C#, Node.js, Python, Java — five languages across 11 services |
| Optional AI service | `shoppingassistantservice` adds Gemini + AlloyDB RAG without modifying any core service |
| Skaffold | `skaffold.yaml` lists 11 independent image build contexts confirming per-service build isolation |
