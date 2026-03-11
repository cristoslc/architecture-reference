# Architecture Report: Bank of Anthos

**Date:** 2026-03-11
**Repository:** https://github.com/GoogleCloudPlatform/bank-of-anthos
**Classification:** Microservices
**Confidence:** 0.97
**Analyst Model:** claude-sonnet-4-6

---

## Summary

Bank of Anthos is a canonical reference implementation of a Microservices architecture, designed by Google Cloud to demonstrate cloud-native deployment patterns on Kubernetes (GKE/Anthos). The system simulates a bank's payment processing network with nine independently deployable services spanning two bounded domains — accounts and ledger — each with its own dedicated PostgreSQL database. Services communicate synchronously over HTTP/REST. No message broker or event bus is present.

---

## Evidence

### Repository Structure

```
bank-of-anthos/
├── src/
│   ├── accounts/
│   │   ├── userservice/        # Python/Flask — user account management + JWT issuance
│   │   ├── contacts/           # Python/Flask — per-user contact lists
│   │   └── accounts-db/        # PostgreSQL — accounts domain database
│   ├── ledger/
│   │   ├── ledgerwriter/       # Java/Spring Boot — transaction write path
│   │   ├── balancereader/      # Java/Spring Boot — read-optimized balance cache
│   │   ├── transactionhistory/ # Java/Spring Boot — read-optimized history cache
│   │   └── ledger-db/          # PostgreSQL — ledger domain database
│   ├── frontend/               # Python/Flask — BFF web server
│   ├── loadgenerator/          # Python/Locust — synthetic traffic generator
│   └── ledgermonolith/         # Java — reference monolith (migration comparison only)
├── kubernetes-manifests/       # One manifest file per service
└── skaffold.yaml               # Root build orchestration referencing 6 sub-modules
```

---

## Styles Identified with Evidence

### Primary: Microservices

**1. Independent Deployment Units — one container per service**

Each of the nine services has its own `Dockerfile`, `skaffold.yaml`, and Kubernetes manifest (`kubernetes-manifests/<service>.yaml`). The root `skaffold.yaml` orchestrates separate build modules:

```yaml
requires:
- configs: [accounts]
  path: src/accounts/skaffold.yaml
- configs: [ledger]
  path: src/ledger/skaffold.yaml
- configs: [frontend]
  path: src/frontend/skaffold.yaml
```

Kubernetes manifests deploy each service as an independent `Deployment` or `StatefulSet` with its own `Service` object of type `ClusterIP`.

**2. Database-Per-Service Pattern**

Two independent PostgreSQL StatefulSets with strict domain ownership:

- `accounts-db` — owned by `userservice` and `contacts` (accounts domain)
- `ledger-db` — owned by `ledgerwriter`, `balancereader`, and `transactionhistory` (ledger domain)

ConfigMaps confirm separate connection strings (`ACCOUNTS_DB_URI` vs `SPRING_DATASOURCE_URL`), and each database is tagged with its owning team label (`team: accounts`, `team: ledger`).

**3. Synchronous HTTP/REST Service-to-Service Communication**

The `config.yaml` ConfigMap registers service endpoints by DNS name:

```yaml
TRANSACTIONS_API_ADDR: "ledgerwriter:8080"
BALANCES_API_ADDR: "balancereader:8080"
HISTORY_API_ADDR: "transactionhistory:8080"
CONTACTS_API_ADDR: "contacts:8080"
USERSERVICE_API_ADDR: "userservice:8080"
```

The frontend (`frontend.py`) makes parallel HTTP calls to three backend services using a `TracedThreadPoolExecutor`, confirming synchronous REST orchestration at the BFF layer. `LedgerWriterController.java` uses `RestTemplate` to call `balancereader` directly before accepting a write.

**4. Polyglot Technology Stack**

- Accounts domain: Python/Flask with SQLAlchemy
- Ledger domain: Java/Spring Boot with Spring Data JPA
- Frontend: Python/Flask with Jinja2 templating
- Databases: PostgreSQL (containerized)
- Observability: OpenTelemetry with Cloud Trace, Stackdriver metrics (Micrometer)

**5. Istio Service Mesh**

Manifests carry `proxy.istio.io/config: '{ "holdApplicationUntilProxyStarts": true }'` annotations, and the `extras/istio/` directory provides gateway manifests for Anthos Service Mesh. The project README lists ASM as a primary demonstrated technology.

**6. Shared JWT Authentication Pattern**

`userservice` issues JWT tokens signed with an RSA private key. All other services validate requests using the corresponding public key mounted via Kubernetes Secret (`jwt-key`). This is a distributed, stateless auth pattern appropriate to microservices.

**7. Ledger Polling Pattern (Lightweight CQRS-adjacent)**

`balancereader` and `transactionhistory` both embed a `LedgerReader` component that runs a background thread polling `ledger-db` for new transaction IDs (via `POLL_MS` interval). On new rows, a callback updates the in-memory Guava `LoadingCache`. This achieves a read-path that is decoupled from the write path (`ledgerwriter`) while sharing the same underlying PostgreSQL store — a CQRS-flavored read optimization within the microservices model, but not a formal CQRS implementation (no event sourcing, no separate command/query buses).

### Ruled Out

- **Event-Driven**: No message broker, no pub/sub topics, no Kafka/RabbitMQ/Cloud Pub/Sub configuration found anywhere in the repo. Services are polled or called synchronously.
- **CQRS**: While `balancereader` and `transactionhistory` implement read-side caching via DB polling, there is no command bus, no event sourcing, and `ledgerwriter` writes directly to the same `ledger-db`. The separation is an optimization, not a CQRS contract.
- **Service-Based**: Nine fine-grained services far exceeds the 2–5 coarse-grained services typical of Service-Based architecture. Each service has a single well-defined responsibility.
- **Modular Monolith**: There is no single deployable artifact. Each service is independently containerized and deployed.
- **Hexagonal / DDD**: No formal ports-and-adapters structure, no domain aggregates, no bounded context maps, no domain events.
- **Serverless / Pipeline / Space-Based / Microkernel / Multi-Agent**: No evidence of any of these patterns.

---

## Quality Attributes with Justification

| Attribute | Justification |
|---|---|
| **Scalability** | Each service can be scaled independently via Kubernetes Deployment replicas. The `postgres-hpa` extras directory contains Horizontal Pod Autoscaler configs. |
| **Deployability** | Independent containers with dedicated `skaffold.yaml` and `cloudbuild.yaml` per service enable independent CI/CD pipelines. |
| **Observability** | OpenTelemetry tracing (Cloud Trace exporter), Stackdriver/Micrometer metrics, structured logging with log4j2, liveness/readiness/startup probes on all services. |
| **Security** | JWT-based stateless auth with RSA key pair. Read-only root filesystems on containers. Non-root user enforcement (`runAsNonRoot: true`). Istio mTLS via service mesh. |
| **Fault Tolerance** | Services use health probes (`/ready`, `/healthy`) and handle upstream failures gracefully. `LedgerReader` catches DB connectivity errors and suspends rather than crashing. |
| **Maintainability** | Clear domain decomposition (accounts vs. ledger teams) enforced by Kubernetes labels. Polyglot allows domain-appropriate technology choices. |
| **Testability** | Each service has its own `tests/` directory. Services are independently unit-testable with mocked dependencies. `loadgenerator` provides integration-level synthetic traffic. |
| **Cloud Portability** | Kubernetes-native manifests work on any conformant cluster. README explicitly states "this application works on any Kubernetes cluster." |

---

## Classification Reasoning

Bank of Anthos is a textbook **Microservices** implementation, designed specifically as a Google Cloud reference application to demonstrate cloud-native patterns. The classification is supported by overwhelming, direct evidence:

1. Nine independently deployable, independently containerized services — each with its own build pipeline, Kubernetes manifest, and resource limits.
2. Database-per-service enforced at the infrastructure level via separate StatefulSets with distinct connection credentials.
3. Synchronous HTTP/REST communication with service discovery via Kubernetes DNS (no shared library calls, no shared in-process coupling).
4. Polyglot implementation (Python and Java) reflecting technology-per-service freedom.
5. Service mesh (Istio/ASM) for cross-cutting concerns (observability, mTLS, traffic management) without embedding these in application code.
6. The `src/ledgermonolith/` module exists explicitly as a migration-comparison artifact — its presence reinforces that the primary architecture is microservices (the monolith is what is being migrated away from).

The `LedgerReader` polling pattern in `balancereader` and `transactionhistory` is a notable read-side cache optimization but does not elevate the classification to CQRS — there is no event sourcing, no formal command/query separation, and both read and write services share `ledger-db` via standard JPA repositories.

Confidence is **0.97**. The microservices pattern is the explicit design intent of the project, documented in the README and confirmed by every structural and behavioral signal in the codebase.
