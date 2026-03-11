# Architecture Report: Spring PetClinic Microservices

**Date:** 2026-03-11
**Repository:** https://github.com/spring-petclinic/spring-petclinic-microservices
**Classification:** Microservices
**Confidence:** 0.97
**Analyst Model:** claude-sonnet-4-6

---

## Summary

Spring PetClinic Microservices is an official Spring Cloud reference implementation that demonstrates how to decompose a monolithic Spring application into independently deployable microservices. The system exposes veterinary clinic functionality through eight separately containerized services — four business services (customers, vets, visits, genai), one API gateway, one config server, one Eureka discovery server, and one admin server. Services communicate exclusively via synchronous HTTP/REST over load-balanced service discovery. No message broker or event bus is present. Each business service owns its own embedded database schema, satisfying the database-per-service invariant. A GenAI service using Spring AI adds an LLM-backed chatbot with vector-store RAG for veterinarian lookups.

---

## Evidence

### Repository Structure

```
spring-petclinic-microservices/
├── pom.xml                                  # Root Maven multi-module POM (8 modules)
├── docker-compose.yml                       # 12-container deployment topology
├── spring-petclinic-customers-service/      # Business service — owners, pets, pet types
│   └── src/main/resources/db/hsqldb/schema.sql  # owners, pets, types tables
├── spring-petclinic-vets-service/           # Business service — vets and specialties
│   └── src/main/resources/db/hsqldb/schema.sql  # vets, specialties, vet_specialties tables
├── spring-petclinic-visits-service/         # Business service — visit records
│   └── src/main/resources/db/hsqldb/schema.sql  # visits table
├── spring-petclinic-genai-service/          # Business service — LLM chatbot + RAG
├── spring-petclinic-api-gateway/            # Spring Cloud Gateway — routing + circuit breaker
├── spring-petclinic-config-server/          # Spring Cloud Config — centralized config
├── spring-petclinic-discovery-server/       # Netflix Eureka — service registry
├── spring-petclinic-admin-server/           # Spring Boot Admin — operational dashboard
└── docker/                                  # Prometheus + Grafana observability configs
```

---

## Styles Identified with Evidence

### Primary: Microservices

**1. Eight Independently Deployable Services**

The root `pom.xml` defines eight Maven modules, each producing a self-contained Spring Boot fat JAR with its own lifecycle:

```xml
<modules>
    <module>spring-petclinic-admin-server</module>
    <module>spring-petclinic-customers-service</module>
    <module>spring-petclinic-vets-service</module>
    <module>spring-petclinic-visits-service</module>
    <module>spring-petclinic-genai-service</module>
    <module>spring-petclinic-config-server</module>
    <module>spring-petclinic-discovery-server</module>
    <module>spring-petclinic-api-gateway</module>
</modules>
```

The `docker-compose.yml` confirms 12-container deployment (8 application containers + Zipkin + admin + Prometheus + Grafana), each with its own image, exposed port, health check, and resource limits. Startup ordering is enforced via `depends_on: condition: service_healthy` chains.

**2. Database-Per-Service Pattern**

Each of the three business services owns a completely isolated database schema with no cross-service foreign keys:

- `customers-service`: `owners`, `pets`, `types` tables (HSQLDB / MySQL)
- `vets-service`: `vets`, `specialties`, `vet_specialties` tables (HSQLDB / MySQL)
- `visits-service`: `visits` table (HSQLDB / MySQL)

The `genai-service` uses an in-process `SimpleVectorStore` (in-memory) for RAG. No shared database artifact exists across services, distinguishing this from Service-Based Architecture.

**3. Spring Cloud Gateway with Load-Balanced Service Discovery**

All external traffic routes through the API gateway using Eureka-registered `lb://` URIs:

```yaml
routes:
  - id: customers-service
    uri: lb://customers-service
    predicates:
      - Path=/api/customer/**
    filters:
      - StripPrefix=2
  - id: genai-service
    uri: lb://genai-service
    predicates:
      - Path=/api/genai/**
    filters:
      - StripPrefix=2
      - CircuitBreaker=name=genaiCircuitBreaker,fallbackUri=/fallback
```

The Eureka Discovery Server (`spring-petclinic-discovery-server`) provides the service registry. Each business service registers itself as a Eureka client.

**4. Synchronous REST Service-to-Service Communication**

All inter-service calls are synchronous HTTP. The `ApiGatewayController` composes owner details by calling two downstream services reactively:

```java
return customersServiceClient.getOwner(ownerId)
    .flatMap(owner ->
        visitsServiceClient.getVisitsForPets(owner.getPetIds())
            .transform(it -> {
                ReactiveCircuitBreaker cb = cbFactory.create("getOwnerDetails");
                return cb.run(it, throwable -> emptyVisitsForPets());
            })
            .map(addVisitsToOwner(owner))
    );
```

The `genai-service` `AIDataProvider` calls `customers-service` via `RestClient` using `DiscoveryClient` for URI resolution, and calls `vets-service` via load-balanced `WebClient`.

**5. Resilience4j Circuit Breaker**

Circuit breakers wrap all cross-service calls. The gateway applies a `defaultCircuitBreaker` filter globally and a dedicated `genaiCircuitBreaker` for the LLM service. The `ApiGatewayController` uses `ReactiveCircuitBreakerFactory` directly. This is standard microservices fault-tolerance infrastructure.

**6. Centralized Configuration**

`spring-petclinic-config-server` (Spring Cloud Config Server) provides centralized configuration for all services from a Git-backed external repository. All services bootstrap with `spring.config.import: optional:configserver:${CONFIG_SERVER_URL:http://localhost:8888/}`.

**7. GenAI Service with Spring AI and RAG**

The `genai-service` integrates Spring AI to provide a natural-language chatbot backed by an OpenAI (or Azure OpenAI) LLM. It uses:
- `ChatClient` with `MessageChatMemoryAdvisor` for conversation memory
- `PetclinicTools` with `@Tool`-annotated methods enabling the LLM to invoke CRUD operations on owners, pets, and vets via function calling
- `VectorStore` (in-memory `SimpleVectorStore`) loaded with vet data at startup via `VectorStoreController` for retrieval-augmented generation (RAG)

This represents AI-augmented microservices rather than a standalone architectural style change.

**8. Full Observability Stack**

- Distributed tracing: Zipkin via OpenTelemetry / Micrometer Tracing (Brave bridge)
- Metrics: Micrometer with Prometheus registry; custom `@Timed` annotations on controllers (`petclinic.owner`, `petclinic.pet`, `petclinic.visit`)
- Dashboards: Grafana with pre-built Spring PetClinic dashboard
- Admin: Spring Boot Admin server aggregating all service health/info endpoints

---

### Ruled Out

- **Event-Driven**: No message broker (Kafka, RabbitMQ, NATS) anywhere in the codebase or compose file. No `@KafkaListener`, `@RabbitListener`, `@StreamListener`, or message channel configurations. All communication is synchronous HTTP.
- **CQRS**: No command/query separation, no command bus, no event sourcing. CRUD operations are handled directly by JPA repositories within each service. The read/write split in visits vs. customers is a domain boundary, not a CQRS pattern.
- **Service-Based**: Services do not share a database. Each business service has its own private schema — a defining counter-indicator for Service-Based Architecture.
- **Modular Monolith**: Eight separately containerized applications with independent deployment lifecycles. This is not a single deployable unit.
- **Hexagonal Architecture**: Controllers directly call repository interfaces; no explicit ports-and-adapters structure with defined inbound/outbound ports.
- **Domain-Driven Design**: Simple CRUD entities with JPA (`@Entity`, `@OneToMany`). No aggregates, value objects, domain events, bounded contexts, or repositories in the DDD sense.
- **Serverless / Pipeline / Space-Based / Microkernel**: No evidence of any of these patterns.
- **Multi-Agent**: The `genai-service` integrates a single LLM with tool-calling capability, not a multi-agent orchestration framework.

---

## Quality Attributes with Justification

| Attribute | Justification |
|---|---|
| **Scalability** | Each service is independently containerizable and scalable. The `lb://` URI scheme in the gateway supports multiple registered instances. Memory limits per container are defined in `docker-compose.yml`. |
| **Deployability** | Eight independently buildable Spring Boot JARs with Docker images. CI/CD via GitHub Actions (`maven-build.yml`). Docker Hub images published under `springcommunity/`. Maven `buildDocker` profile automates image builds. |
| **Fault Tolerance** | Resilience4j circuit breakers on all cross-service paths. Default circuit breaker on gateway; dedicated genai circuit breaker with fallback URI. Retry filter for `SERVICE_UNAVAILABLE` responses. Spring Boot Chaos Monkey profile for fault injection. |
| **Observability** | Distributed tracing via Zipkin/OpenTelemetry. Micrometer Prometheus metrics with custom `@Timed` annotations. Grafana dashboard. Spring Boot Admin aggregating health across all services. Logback structured logging. |
| **Maintainability** | Clear domain decomposition by business capability. Each service is a self-contained Spring Boot module with its own configuration, schema, and test suite. Startup ordering enforced by health checks. |
| **Testability** | 9 test files across service modules with `@SpringBootTest` integration tests and `application-test.yml` test profiles. Services can be tested in isolation with mocked downstream clients. |
| **Extensibility** | The GenAI service was added as an independent module without modifying existing services. New services register with Eureka automatically; the gateway config is the only required change for routing. |
| **Security** | Config externalized from code (no secrets in source). Chaos Monkey profile allows targeted fault injection without code changes. API gateway as single ingress point. |

---

## Classification Reasoning

Spring PetClinic Microservices is a textbook **Microservices** implementation, designed explicitly as a Spring Cloud reference application. The README states: "This microservices branch was initially derived from the AngularJS version to demonstrate how to split sample Spring application into microservices."

Every architectural signal confirms this classification:

1. **Eight independently deployable services**, each a separate Spring Boot application with its own Maven module, Docker image, and container lifecycle.
2. **Database-per-service pattern** strictly enforced — three isolated schemas (owners/pets, vets, visits) with no cross-service joins or shared datasources.
3. **Synchronous REST communication** via Eureka service discovery with load-balanced `lb://` URIs and Spring Cloud Gateway routing.
4. **Microservices infrastructure pattern** fully realized: Config Server (externalized config), Discovery Server (service registry), API Gateway (single entry point), circuit breakers (fault tolerance), distributed tracing (observability).
5. **Independent technology evolution** demonstrated by the GenAI service, which uses Spring AI, WebClient, and vector stores without touching any other service.

The GenAI chatbot with function-calling tools (`@Tool` annotations on `PetclinicTools`) is a notable addition that enables LLM-driven CRUD via REST calls to other microservices — this is an AI-augmented microservice, not a separate architectural style. The `VectorStore` RAG pattern for vet lookup is similarly a feature of the GenAI service, not an ecosystem-level architectural concern.

Confidence is **0.97**. The microservices pattern is the explicit design intent of the project, confirmed by every structural, configurational, and behavioral signal in the codebase. The small deduction reflects that some services (config server, discovery server, admin server) are infrastructure scaffolding rather than true business microservices, which is characteristic of Spring Cloud reference architectures.
