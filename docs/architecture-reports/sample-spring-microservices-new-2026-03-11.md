# Architecture Report: sample-spring-microservices-new

**Date:** 2026-03-11
**Source URL:** https://github.com/piomin/sample-spring-microservices-new
**Classification:** Microservices
**Confidence:** 0.97
**Method:** deep-analysis
**Model:** claude-sonnet-4-6

---

## Summary

`sample-spring-microservices-new` is a canonical Spring Cloud microservices reference implementation by Piotr Minkowski. It consists of six independently deployable Spring Boot applications — three business services (employee, department, organization), an API gateway, a centralized configuration server, and a Eureka-based service discovery server — all orchestrated via Docker Compose. Services communicate synchronously through OpenFeign HTTP clients, register dynamically with Eureka, draw their configuration from a central Spring Cloud Config Server, and emit distributed traces to Zipkin via OpenTelemetry. There is no message broker, no shared database, and no asynchronous event bus anywhere in the codebase.

---

## Service Inventory

| Service | Role | Port | Deployment Image |
|---|---|---|---|
| `employee-service` | Employee CRUD — owns employee data | dynamic (0) | `piomin/employee-service:1.2-SNAPSHOT` |
| `department-service` | Department CRUD — calls employee-service via Feign | dynamic (0) | `piomin/department-service:1.2-SNAPSHOT` |
| `organization-service` | Organization CRUD — calls both employee-service and department-service | dynamic (0) | `piomin/organization-service:1.2-SNAPSHOT` |
| `gateway-service` | Spring Cloud Gateway — routes /employee/**, /department/**, /organization/** | 8060 | `piomin/gateway-service:1.1-SNAPSHOT` |
| `config-service` | Spring Cloud Config Server (native mode) — serves YAML configs per service | 8088 | `piomin/config-service:1.1-SNAPSHOT` |
| `discovery-service` | Netflix Eureka Server — service registry | 8061 | `piomin/discovery-service:1.1-SNAPSHOT` |

---

## Architecture Classification

**Primary style: Microservices**

The codebase satisfies all defining criteria of the Microservices style with no ambiguity.

### 1. Independent deployability

Each of the six modules is a standalone Spring Boot application with its own `pom.xml`, its own `main` class, its own `Dockerfile`-equivalent build profile (`build-image`), and its own container image in `docker-compose.yml`. The root `pom.xml` declares packaging as `pom` with six child modules; each child builds to a separate JAR and container image. Services can be started, stopped, and redeployed independently.

### 2. Isolated data ownership

Each business service maintains its own in-memory repository with no shared state:

- `EmployeeRepository` (in-memory `List<Employee>`) — owned exclusively by `employee-service`
- `DepartmentRepository` — owned exclusively by `department-service`
- `OrganizationRepository` — owned exclusively by `organization-service`

No shared database or shared JPA data source exists. This is the canonical database-per-service microservices pattern (in-memory variant for demo purposes).

### 3. Service discovery via Eureka

All business services and the gateway declare `spring-cloud-starter-netflix-eureka-client` as a dependency and are annotated with `@EnableDiscoveryClient`. They register under their application name and are discovered by service name:

```java
// department-service/src/main/java/.../client/EmployeeClient.java
@FeignClient(name = "employee-service")
public interface EmployeeClient { ... }
```

The Eureka server (`discovery-service`) runs at port 8061; all clients point `eureka.client.serviceUrl.defaultZone` to it.

### 4. Synchronous inter-service communication via OpenFeign

Services communicate over synchronous HTTP using Spring Cloud OpenFeign declarative clients:

- `department-service` → `employee-service`: `EmployeeClient.findByDepartment(departmentId)`
- `organization-service` → `employee-service`: `EmployeeClient.findByOrganization(organizationId)`
- `organization-service` → `department-service`: `DepartmentClient.findByOrganization(organizationId)` and `findByOrganizationWithEmployees(organizationId)`

All calls are synchronous and blocking. There is no asynchronous messaging anywhere in the project.

### 5. API Gateway as the single entry point

`gateway-service` uses Spring Cloud Gateway to route and load-balance external traffic:

```yaml
# gateway-service.yml (via Config Server)
spring.cloud.gateway.routes:
  - id: employee-service
    uri: lb://employee-service
    predicates: [Path=/employee/**]
    filters: [RewritePath=/employee/(?<path>.*), /$\{path}]
  - id: department-service
    uri: lb://department-service
    predicates: [Path=/department/**]
    ...
```

The gateway also aggregates Swagger UI across all registered services via a dynamic `RouteDefinitionLocator`-based bean.

### 6. Centralized configuration

`config-service` runs Spring Cloud Config Server in native mode and serves per-service YAML files from classpath:

```
config-service/src/main/resources/config/
  employee-service.yml
  department-service.yml
  organization-service.yml
  gateway-service.yml
  discovery-service.yml
  *-docker.yml   (profile overrides for Docker networking)
```

All services import their config via `spring.config.import: "optional:configserver:http://..."`.

### 7. Distributed tracing

All three business services depend on `micrometer-tracing-bridge-otel` and `opentelemetry-exporter-zipkin`. Configuration sets `management.tracing.sampling.probability: 1.0`, meaning 100% of requests are traced and exported to the Zipkin container defined in `docker-compose.yml`.

---

## Communication Topology

```
Client (HTTP)
  └── gateway-service :8060
        ├── /employee/**  --> lb://employee-service  (Eureka-discovered)
        ├── /department/** --> lb://department-service (Eureka-discovered)
        └── /organization/** --> lb://organization-service (Eureka-discovered)

organization-service
  ├── --> department-service (OpenFeign, synchronous)
  └── --> employee-service   (OpenFeign, synchronous)

department-service
  └── --> employee-service   (OpenFeign, synchronous)

All services
  ├── <-- config-service :8088  (Spring Cloud Config, at startup)
  ├── --> discovery-service :8061 (Eureka registration + heartbeat)
  └── --> zipkin :9411           (distributed trace export)
```

All cross-service communication is synchronous HTTP. No pub/sub, no message broker, no async queues.

---

## Why Not Other Styles

- **Not Event-Driven:** There is no message broker (no Kafka, RabbitMQ, or any JMS provider), no `@KafkaListener`, no `@RabbitListener`, no Spring Integration, and no event-sourcing infrastructure anywhere in the codebase or in `docker-compose.yml`. All inter-service calls are blocking OpenFeign HTTP requests.

- **Not Service-Based:** Service-Based architecture uses a small number of coarse-grained services (typically 4-12) that share a common database. Here, each of the three business services owns its own isolated data store and is fine-grained enough to own a single domain entity. There is no shared database layer.

- **Not Modular Monolith:** The project explicitly builds six separate container images and deploys them as separate Docker Compose services. Each is a fully independent process; there is no shared JVM, no shared classpath, and no single deployable artifact.

- **Not Layered:** The project is not organized into horizontal technical layers (presentation, business logic, data access) shared across business capabilities. Each service has its own internal controller/repository stack, fully encapsulated within its service boundary.

- **Not Hexagonal Architecture:** There are no explicit ports and adapters. Business services use standard Spring MVC `@RestController` classes and plain Java repository objects. Dependency inversion through interface-defined inbound/outbound ports is not present; the `EmployeeClient` Feign interfaces are infrastructure clients, not outbound ports in a hexagonal sense.

- **Not CQRS:** There is no read-model/write-model separation, no command bus, no event store, and no projection mechanism. All services expose unified CRUD REST endpoints.

- **Not Serverless:** Services run as long-lived, always-on Spring Boot processes. There is no FaaS trigger or function-as-a-service deployment model.

- **Not DDD:** Models are simple POJO entities (`Employee`, `Department`, `Organization`) with no aggregates, value objects, domain events, or bounded context infrastructure. The in-memory repositories are CRUD lists, not domain-driven repositories with invariant enforcement.

---

## Quality Attributes

- **Scalability:** Business services configure `server.port: 0` (dynamic port assignment), enabling multiple instances to register with Eureka simultaneously. Spring Cloud Gateway load-balances across instances using the `lb://` URI scheme.
- **Deployability:** Per-service Maven build profiles produce independent container images (`spring-boot-maven-plugin` with `build-image` goal). Docker Compose orchestrates the full topology with health-check-based startup ordering.
- **Observability:** 100%-sampled distributed tracing via OpenTelemetry → Zipkin; Micrometer metrics via Spring Boot Actuator (health, SBOM endpoints); structured log patterns with trace/span ID injection.
- **Maintainability:** Small, single-responsibility services with minimal cross-cutting dependencies. Each service's source tree is under 10 Java files, making the codebase highly readable as a learning reference.
- **Fault Tolerance:** No circuit breaker or retry library is present (this is a deliberate simplification for the reference use case). The Spring Cloud Gateway can route around unavailable instances if Eureka deregisters them.
- **Testability:** Each service has its own test directory; the project uses JaCoCo for coverage reporting and SonarCloud for static analysis. Integration with `instancio-junit` enables randomized test data generation.
- **Discoverability:** Gateway aggregates Swagger/OpenAPI 3.1 UIs for all registered services behind a single `/swagger-ui.html` endpoint, lowering the barrier for API exploration.
- **Operational Simplicity:** Full local startup via Docker Compose with a single `docker-compose up`; each service dependency order is managed by health-check conditions.

---

## Evidence Summary

| Evidence Type | Detail |
|---|---|
| Root `pom.xml` | 6 Maven modules; `packaging=pom`; Spring Cloud BOM 2025.1.1 |
| Per-module POMs | Each child module builds an independent Spring Boot JAR + container image |
| `docker-compose.yml` | 7 containers (6 services + Zipkin); health-check ordered startup; each service on its own image |
| `discovery-service` | `@EnableEurekaServer` — Eureka server on port 8061 |
| `config-service` | Spring Cloud Config native server; 11 per-service YAML files on classpath |
| `gateway-service` | Spring Cloud Gateway with `lb://` routing to all three business services |
| `EmployeeClient.java` | `@FeignClient(name = "employee-service")` — synchronous service-to-service call |
| `DepartmentClient.java` | `@FeignClient(name = "department-service")` — synchronous service-to-service call |
| `OrganizationClient.java` | Calls both employee-service and department-service |
| Repository classes | `EmployeeRepository`, `DepartmentRepository`, `OrganizationRepository` — no shared state |
| `employee-service.yml` | `server.port: 0` — dynamic port for multi-instance Eureka registration |
| No messaging | Zero references to kafka, rabbitmq, activemq, jms, `@KafkaListener`, or any message broker in all source and config files |
| Distributed tracing | `micrometer-tracing-bridge-otel` + `opentelemetry-exporter-zipkin` in each business service POM |
