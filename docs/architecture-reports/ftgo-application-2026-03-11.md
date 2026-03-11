# Architecture Report: ftgo-application

**Date:** 2026-03-11
**Repository:** https://github.com/microservices-patterns/ftgo-application
**Classification:** Microservices, Event-Driven, Domain-Driven Design
**Confidence:** 0.97
**Analyst Model:** claude-sonnet-4-6
**Method:** deep-analysis
**SPEC:** SPEC-031

---

## Summary

The ftgo-application is the canonical reference implementation accompanying Chris Richardson's "Microservices Patterns" book. It simulates a food delivery platform (FTGO — Food to Go) decomposed into seven independently deployable services. The system demonstrates the full microservices pattern vocabulary: database-per-service, API Gateway, Saga orchestration for distributed transactions, CQRS read model, event sourcing (in the Accounting Service), and transactional outbox via Apache Kafka and the Eventuate Tram framework. This is a textbook microservices codebase with strong Event-Driven and Domain-Driven Design secondary styles.

---

## Repository Structure

```
ftgo-application/
├── ftgo-consumer-service/        # Consumer domain — manages consumers
├── ftgo-order-service/           # Order domain — saga orchestrator
├── ftgo-kitchen-service/         # Kitchen domain — ticket management
├── ftgo-accounting-service/      # Accounting domain — event-sourced Account aggregate
├── ftgo-restaurant-service/      # Restaurant domain — menus, availability
├── ftgo-delivery-service/        # Delivery domain — courier tracking
├── ftgo-order-history-service/   # CQRS read model — DynamoDB-backed order history
├── ftgo-api-gateway/             # API Gateway — Spring WebFlux reactive proxy
├── ftgo-api-gateway-graphql/     # GraphQL API Gateway variant (Node.js/TypeScript)
├── ftgo-restaurant-service-aws-lambda/  # Lambda variant of Restaurant Service
├── ftgo-*-api/                   # Shared API contracts per service (events, commands)
├── ftgo-*-contracts/             # Spring Cloud Contract test stubs
├── docker-compose.yml            # Full stack orchestration
├── skaffold.yaml                 # Kubernetes deployment descriptor
└── deployment/kubernetes/        # Kubernetes manifests
```

---

## Styles Identified with Evidence

### Primary: Microservices

**1. Seven Independently Deployable Services — one container per service**

Each of the seven business services has its own `Dockerfile` and is built and deployed as an independent Spring Boot container:

```
/tmp/classify-ftgo/ftgo-accounting-service/Dockerfile
/tmp/classify-ftgo/ftgo-api-gateway/Dockerfile
/tmp/classify-ftgo/ftgo-consumer-service/Dockerfile
/tmp/classify-ftgo/ftgo-delivery-service/Dockerfile
/tmp/classify-ftgo/ftgo-kitchen-service/Dockerfile
/tmp/classify-ftgo/ftgo-order-history-service/Dockerfile
/tmp/classify-ftgo/ftgo-order-service/Dockerfile
/tmp/classify-ftgo/ftgo-restaurant-service/Dockerfile
```

The `docker-compose.yml` assigns each service an isolated port and environment block. The `skaffold.yaml` provides Kubernetes deployment support.

**2. Database-per-Service Pattern**

Eight separate MySQL schemas are provisioned — one per service — enforcing data ownership at the infrastructure level. The CDC service reads binlogs from each schema independently:

```yaml
# docker-compose.yml — environment blocks per service
ftgo-consumer-service:
  SPRING_DATASOURCE_URL: jdbc:mysql://mysql/ftgo_consumer_service
  EVENTUATE_DATABASE_SCHEMA: ftgo_consumer_service

ftgo-order-service:
  SPRING_DATASOURCE_URL: jdbc:mysql://mysql/ftgo_order_service
  EVENTUATE_DATABASE_SCHEMA: ftgo_order_service

ftgo-kitchen-service:
  SPRING_DATASOURCE_URL: jdbc:mysql://mysql/ftgo_kitchen_service
  EVENTUATE_DATABASE_SCHEMA: ftgo_kitchen_service

ftgo-accounting-service:
  SPRING_DATASOURCE_URL: jdbc:mysql://mysql/ftgo_accounting_service
  EVENTUATE_DATABASE_SCHEMA: ftgo_accounting_service
```

The Order History Service diverges further by using **DynamoDB** (with a `dynamodblocal` container for development), demonstrating true polyglot persistence across service boundaries.

**3. API Gateway Pattern**

`ftgo-api-gateway` (Spring WebFlux) is the sole external entry point. It proxies to downstream services using service-specific destination configurations:

```yaml
ORDER_DESTINATIONS_ORDERSERVICEURL: http://ftgo-order-service:8080
ORDER_DESTINATIONS_ORDERHISTORYSERVICEURL: http://ftgo-order-history-service:8080
CONSUMER_DESTINATIONS_CONSUMERSERVICEURL: http://ftgo-consumer-service:8080
```

`OrderHandlers.java` uses reactive Mono composition to aggregate responses from four services in parallel, demonstrating the API Composition pattern:

```java
Mono<Tuple4<OrderInfo, Optional<TicketInfo>, Optional<DeliveryInfo>, Optional<BillInfo>>> combined =
        Mono.zip(orderInfo, ticketInfo, deliveryInfo, billInfo);
```

A second gateway variant (`ftgo-api-gateway-graphql`) provides a GraphQL facade (Node.js/TypeScript) over the same services.

**4. Service Decomposition by Business Capability**

Each service owns a distinct bounded context: Consumer, Order, Kitchen, Accounting, Restaurant, Delivery, and Order History. No cross-service domain classes are shared — only API contracts (`ftgo-*-api` modules) define inter-service message types.

---

### Secondary: Event-Driven

**1. Apache Kafka as Message Broker (Transactional Outbox)**

All async inter-service communication flows through Apache Kafka via the **Eventuate Tram** framework. The `cdc-service` container implements the transactional outbox pattern: it reads MySQL binary logs and publishes domain events to Kafka topics. This guarantees at-least-once delivery without two-phase commit:

```yaml
cdc-service:
  image: eventuateio/eventuate-cdc-service
  EVENTUATE_CDC_READER_READER1_TYPE: mysql-binlog
  EVENTUATE_CDC_PIPELINE_PIPELINE1_TYPE: eventuate-tram
  EVENTUATE_CDC_PIPELINE_PIPELINE1_EVENTUATEDATABASESCHEMA: ftgo_consumer_service
  # ... one pipeline per service schema
```

**2. Domain Events for Cross-Service Communication**

Services emit domain events and subscribe to events from other services' aggregates. `OrderHistoryEventHandlers` subscribes to `Order` aggregate events to maintain the CQRS read model:

```java
public DomainEventHandlers domainEventHandlers() {
    return DomainEventHandlersBuilder
            .forAggregateType("net.chrisrichardson.ftgo.orderservice.domain.Order")
            .onEvent(OrderCreatedEvent.class, this::handleOrderCreated)
            .onEvent(OrderAuthorized.class, this::handleOrderAuthorized)
            .onEvent(OrderCancelled.class, this::handleOrderCancelled)
            .onEvent(OrderRejected.class, this::handleOrderRejected)
            .build();
}
```

**3. Saga Pattern for Distributed Transactions**

The Order Service orchestrates three multi-step sagas across services using the Eventuate Tram Saga framework. `CreateOrderSaga` coordinates a six-step distributed transaction spanning Order, Consumer, Kitchen, and Accounting services with compensation steps:

```java
// CreateOrderSaga.java
this.sagaDefinition =
         step()
          .withCompensation(orderService.reject, CreateOrderSagaState::makeRejectOrderCommand)
        .step()
          .invokeParticipant(consumerService.validateOrder, ...)
        .step()
          .invokeParticipant(kitchenService.create, ...)
          .withCompensation(kitchenService.cancel, ...)
        .step()
          .invokeParticipant(accountingService.authorize, ...)
        .step()
          .invokeParticipant(kitchenService.confirmCreate, ...)
        .step()
          .invokeParticipant(orderService.approve, ...)
        .build();
```

Additional sagas: `CancelOrderSaga`, `ReviseOrderSaga`.

---

### Secondary: Domain-Driven Design

**1. Aggregates as Primary Modeling Pattern**

Every service models its core domain concept as a DDD aggregate:

- `Order` aggregate (`ftgo-order-service`) — JPA entity with domain event emission, state machine enforcement, and `ResultWithDomainEvents` return type
- `Ticket` aggregate (`ftgo-kitchen-service`) — kitchen ticket lifecycle
- `Consumer` aggregate (`ftgo-consumer-service`)
- `Account` aggregate (`ftgo-accounting-service`) — event-sourced via Eventuate Client
- `Restaurant` aggregate (`ftgo-restaurant-service`)

`Order.java` demonstrates aggregate discipline: it enforces valid state transitions via switch statements and returns domain events as output rather than firing side effects:

```java
public List<OrderDomainEvent> noteCancelled() {
    switch (state) {
        case CANCEL_PENDING:
            this.state = OrderState.CANCELLED;
            return singletonList(new OrderCancelled());
        default:
            throw new UnsupportedStateTransitionException(state);
    }
}
```

**2. Event Sourcing in the Accounting Service**

`Account.java` extends `ReflectiveMutableCommandProcessingAggregate` — the Eventuate Client's event-sourcing base class. The aggregate processes commands by returning events, and state is rebuilt by replaying those events:

```java
public class Account extends ReflectiveMutableCommandProcessingAggregate<Account, AccountCommand> {
    public List<Event> process(AuthorizeCommandInternal command) {
        return events(new AccountAuthorizedEvent());
    }
    public void apply(AccountAuthorizedEvent event) { }
}
```

This is the only event-sourced aggregate in the system; other aggregates use standard JPA persistence.

**3. Consistent Package Structure Across Services**

Each service follows the same DDD-aligned package structure:
- `domain` — aggregates, value objects, domain services
- `messaging` — event handlers and command handlers (anti-corruption adapters)
- `web` — REST controllers (driving adapters)
- `main` — Spring Boot application entry point

**4. Shared API Contracts as Bounded Context Interfaces**

Each service exposes its API through a dedicated `-api` Gradle module (e.g., `ftgo-order-service-api`) containing only event classes, command classes, and reply types. This enforces strict bounded context boundaries: consuming services depend only on the API contract, never on internal domain classes.

---

### Notable: CQRS Read Model (Order History Service)

The `ftgo-order-history-service` implements a CQRS read model. It consumes `OrderCreatedEvent`, `OrderAuthorized`, `OrderCancelled`, and `OrderRejected` events from Kafka and maintains a denormalized view in DynamoDB optimized for order history queries. The package name `net.chrisrichardson.ftgo.cqrs.orderhistory` makes this intent explicit.

This is not a system-wide CQRS classification — CQRS applies to this one service only. The pattern is a secondary concern within the broader microservices architecture.

---

### Notable: Lambda Variant

`ftgo-restaurant-service-aws-lambda` provides an AWS Lambda variant of the Restaurant Service (`serverless.yml` with `create-restaurant` and `find-restaurant` handlers). This is an illustrative alternative deployment — the primary system is container-based. It does not change the overall classification.

---

## Ruled Out

- **Modular Monolith**: Services are independently deployable containers with separate databases, not modules within a single deployment unit.
- **Service-Based**: Seven fine-grained services with strict database-per-service boundaries far exceeds the 2–5 coarse-grained services with shared databases typical of Service-Based architecture.
- **Layered**: Organization is vertical by business capability. Services are not organized horizontally by technical layer.
- **Hexagonal / Ports-and-Adapters**: While each service's `messaging` and `web` packages serve as adapters, the primary architectural driver is service decomposition by capability, not the ports-and-adapters pattern as the system's organizing principle.
- **Space-Based / Pipeline / Microkernel / Multi-Agent / Serverless**: No evidence of any of these patterns as primary organizing principles.

---

## Quality Attributes with Justification

| Attribute | Justification |
|---|---|
| **Scalability** | Each service is independently containerized and can be scaled horizontally without affecting siblings. Kubernetes manifests in `deployment/kubernetes/` support replica-based scaling per service. |
| **Deployability** | Eight independent `Dockerfile`s and Docker Compose/Kubernetes support enable fully independent CI/CD pipelines per service. The `build-and-restart-service.sh` script confirms per-service build-deploy lifecycle. |
| **Data Isolation** | Eight distinct MySQL schemas (one per service) plus DynamoDB for Order History enforce strict data sovereignty. No shared tables or direct cross-service DB joins are possible. |
| **Fault Tolerance** | Saga compensating transactions (`withCompensation(...)`) ensure rollback on failure. The transactional outbox pattern (Eventuate CDC) guarantees event delivery even if a service is temporarily unavailable. `onErrorReturn(Optional.empty())` in the API Gateway gracefully degrades non-critical service failures. |
| **Consistency (Eventual)** | The Saga pattern achieves eventual consistency across services without distributed transactions. Event-driven propagation through Kafka ensures all services converge to a consistent state over time. |
| **Testability** | Spring Cloud Contract stubs (`ftgo-*-contracts` modules) enable consumer-driven contract testing between services. `ftgo-end-to-end-tests` provides end-to-end test harness. `ftgo-test-util` provides shared test utilities. |
| **Observability** | Distributed tracing via Spring Sleuth and Zipkin configured on Order, Delivery, and API Gateway services. Swagger UI enabled on all business services for API exploration. |
| **Evolvability** | Bounded context isolation means each service's domain model can evolve independently. API contracts in dedicated `-api` modules decouple consumers from producer internals. Spring Cloud Contract tests catch contract regressions. |

---

## Classification Reasoning

The ftgo-application is a deliberately constructed reference implementation for the "Microservices Patterns" book by Chris Richardson. The README.adoc states explicitly: "Not surprisingly, this application has a microservice architecture." Every structural and behavioral signal in the codebase confirms this:

1. **Seven independently deployable services**, each with its own `Dockerfile`, Spring Boot application entry point, and port allocation.
2. **Database-per-service enforced at the infrastructure level** — eight isolated MySQL schemas plus DynamoDB for Order History. No shared database access across service boundaries.
3. **Apache Kafka as the async communication backbone** via Eventuate Tram, with the transactional outbox pattern (CDC service reading MySQL binary logs) providing reliable event delivery.
4. **Saga orchestration** for distributed transactions (CreateOrderSaga, CancelOrderSaga, ReviseOrderSaga) coordinating state changes across four services with full compensating transaction support.
5. **DDD aggregates** as the universal domain modeling pattern across all services, with event-sourcing applied selectively to the Account aggregate in the Accounting Service.
6. **CQRS read model** implemented in the Order History Service via event-driven DynamoDB projection — a bounded application of CQRS within the microservices system.
7. **API Gateway** (Spring WebFlux) as the single external entry point with reactive parallel composition of downstream service responses.

The Event-Driven secondary classification is warranted because Kafka and the transactional outbox pattern are load-bearing architectural components — the sagas depend on them, the CQRS view depends on them, and cross-service state propagation (e.g., `OrderEventConsumer` in the Order Service subscribing to `RestaurantCreated` events) depends on them. This is not incidental messaging; it is the primary integration fabric.

The DDD secondary classification is warranted because every service uses formal DDD tactical patterns (aggregates with state machine enforcement, domain events as output, value objects, bounded context isolation through API module contracts) rather than simple CRUD entities. The package structure (`domain`, `messaging`, `web`, `main`) is a DDD-informed convention applied uniformly.

Confidence is **0.97**. The microservices pattern is the explicit design intent of the project, documented in the README and confirmed by every structural and behavioral signal. The secondary styles (Event-Driven, DDD) are integral to the architecture rather than peripheral.
