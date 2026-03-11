---
project: "kafka-streams-examples"
date: 2026-03-11
scope: platform
use-type: reference
primary-language: Java
confidence: 0.90
styles:
  - name: Event-Driven
    role: primary
    confidence: 0.92
  - name: Pipeline
    role: secondary
    confidence: 0.85
---

# Architecture Analysis: kafka-streams-examples

## Metadata

| Field | Value |
|---|---|
| Project | kafka-streams-examples |
| Repo | https://github.com/confluentinc/kafka-streams-examples |
| Date | 2026-03-11 |
| Scope | platform |
| Use-type | reference |
| Primary Language | Java |
| Other Languages | Scala |
| Method | deep-analysis |
| Model | claude-sonnet-4-6 |

## Style Rationales

**Event-Driven (primary, 0.92):** The entire repository is organized around event-driven interaction via Kafka topics. Every application — standalone examples and the flagship microservices ecosystem — treats Kafka topics as the sole inter-component communication channel. In the microservices package (`src/main/java/io/confluent/examples/streams/microservices/`), six independent services (`OrdersService`, `FraudService`, `InventoryService`, `OrderDetailsService`, `ValidationsAggregatorService`, `EmailService`) each implement the `Service` interface and interact exclusively through Kafka topics declared in `domain/Schemas.java`: `ORDERS`, `ORDER_VALIDATIONS`, `PAYMENTS`, `CUSTOMERS`, `WAREHOUSE_INVENTORY`. No service calls another service directly. The canonical event flow is: `OrdersService` produces to the `orders` topic → `FraudService`, `InventoryService`, and `OrderDetailsService` consume from `orders` in parallel and each produce a PASS/FAIL result to `order-validations` → `ValidationsAggregatorService` joins the validation stream with the orders stream and emits the final order state back to `orders`. The `microservices/README.md` states this explicitly: "business events that describe the order management workflow propagate through this ecosystem." The choreography pattern (no central orchestrator; services react to events) is the definitive event-driven topology signal. Even the broader standalone examples (WordCount, KafkaMusic, AnomalyDetection, SessionWindows, PageViewRegion, GlobalKTables) all follow the same pattern: consume events from a Kafka topic, react, produce results to another topic. `OrdersService.java` also documents a CQRS read pattern over the state store via its REST interface, using `KafkaStreams.queryMetadataForKey()` to route GET requests to the correct partition owner — but this is a secondary read mechanism layered over the event-driven backbone.

**Pipeline (secondary, 0.85):** The execution model of every Kafka Streams application in the repository is a directed dataflow topology — the defining structural trait of the Pipeline (Pipe-and-Filter) style. Each application constructs a `StreamsBuilder`, composes a chain of `KStream`/`KTable` operations (filter → map/flatMap → groupBy → aggregate/count → toStream → to), and submits the resulting `Topology` to `KafkaStreams`. In `WordCountLambdaExample.java`, the pipeline is explicit: `builder.stream(inputTopic)` → `.flatMapValues(...)` → `.groupBy(...)` → `.count()` → `.toStream().to(outputTopic)`. In `FraudService.java`, the pipeline fans out via `.split().branch()`: orders are filtered → grouped by customerId → windowed-aggregated into `OrderValue` → branched into above/below fraud limit streams → each branch maps to an `OrderValidation` and produces to `ORDER_VALIDATIONS`. In `KafkaMusicExample.java`, the topology is multi-stage: `play-events` stream is filtered and rekeyed → joined with `song-feed` KTable → grouped and counted into `song-play-count` state store → re-aggregated into `top-five-songs-by-genre` and `top-five-songs` stores. The key pipeline characteristic — data flows through a sequence of stateless and stateful operator stages, with intermediate results passed downstream via implicit in-process buffers (Kafka Streams topology internals) and materialized state stores — is present in every single example. Operators are pure transformations; the framework handles routing and buffering. This is Pipe-and-Filter instantiated via the Kafka Streams DSL.

## Evidence Table

| Evidence | File/Location | Style |
|---|---|---|
| `Service` interface: all microservices start/stop via Kafka bootstrap only | `microservices/Service.java` | Event-Driven |
| `Schemas.Topics`: 6 Kafka topics are the only inter-service contract | `microservices/domain/Schemas.java:62-82` | Event-Driven |
| `FraudService` consumes from `ORDERS`, produces to `ORDER_VALIDATIONS` — no direct service calls | `microservices/FraudService.java:84-120` | Event-Driven |
| `InventoryService` and `OrderDetailsService` consume `ORDERS`, emit `ORDER_VALIDATIONS` in parallel | `microservices/InventoryService.java`, `microservices/OrderDetailsService.java` | Event-Driven |
| `ValidationsAggregatorService` joins `ORDER_VALIDATIONS` + `ORDERS` streams, writes back to `ORDERS` | `microservices/ValidationsAggregatorService.java:99-139` | Event-Driven |
| `OrderDetailsService` uses raw Kafka Producer/Consumer with exactly-once transactions (not Streams DSL) to demonstrate event-driven without streams | `microservices/OrderDetailsService.java:48-60` | Event-Driven |
| README states "business events propagate through this ecosystem" and documents topic-only coupling | `microservices/README.md:6-16` | Event-Driven |
| Choreographed order workflow: no orchestrator, 3 validators fan out then aggregate | `microservices/README.md`, `microservices/ValidationsAggregatorService.java` | Event-Driven |
| `OrdersService` exposes REST + CQRS read via Interactive Queries; writes only via Kafka producer | `microservices/OrdersService.java:72-80` | Event-Driven |
| `KafkaMusicExample` exposes REST query over materialized state stores; all writes via topic | `interactivequeries/kafkamusic/KafkaMusicExample.java:150-158` | Event-Driven |
| `WordCountLambdaExample`: `stream → flatMapValues → groupBy → count → toStream → to` | `WordCountLambdaExample.java:185-207` | Pipeline |
| `FraudService` pipeline: filter → groupBy → windowedBy → aggregate → toStream → split/branch → map → to | `microservices/FraudService.java:84-129` | Pipeline |
| `KafkaMusicExample.buildTopology()`: play-events → filter → map → join KTable → groupBy → count → aggregate top-5 | `interactivequeries/kafkamusic/KafkaMusicExample.java:281-360` | Pipeline |
| `AnomalyDetectionLambdaExample`: click stream → groupBy → windowedBy(TimeWindows) → count → filter anomalies → to | `AnomalyDetectionLambdaExample.java` | Pipeline |
| `SessionWindowsExample`: events → groupBy → windowedBy(SessionWindows) → aggregate → to | `SessionWindowsExample.java` | Pipeline |
| `GlobalKTablesExample`: order stream → join GlobalKTable(customers) → join GlobalKTable(products) → map enrichedOrder → to | `GlobalKTablesExample.java` | Pipeline |
| `ValidationsAggregatorService` pipeline: validations stream → groupByKey → windowedBy → aggregate pass-count → join orders → to | `microservices/ValidationsAggregatorService.java:99-143` | Pipeline |
| Avro schemas enforce typed event contracts across all topic boundaries | `src/main/resources/avro/io/confluent/examples/streams/microservices/*.avsc` | Event-Driven |

## Quality Attributes

| QA | Evidence |
|---|---|
| **Fault Tolerance** | Kafka Streams provides at-least-once delivery by default; `OrderDetailsService` demonstrates exactly-once semantics via Kafka transactions (`eosEnabled` flag, `KafkaProducer` with transactional config). State stores are backed by Kafka changelog topics, enabling recovery after failure without data loss. `StreamsConfig.STATESTORE_CACHE_MAX_BYTES_CONFIG` is explicitly disabled in several examples (e.g., `FraudService.java:127`) to ensure complete changelog output for auditability. |
| **Scalability** | Every `KafkaStreams` application is horizontally scalable by running multiple instances with the same `APPLICATION_ID_CONFIG` — Kafka's consumer group protocol distributes partitions automatically. `KafkaMusicExample` documents two-instance deployment on ports 7070/7071 with automatic partition assignment. `MetadataService.java` uses `KafkaStreams.metadataForAllStreamsClients()` and `queryMetadataForKey()` to route REST queries to the instance holding the relevant partition's state store. |
| **Consistency** | `ValidationsAggregatorService` uses `SessionWindows` and a join with a 5-minute grace window to aggregate all three validator results before finalizing order state. `OrderDetailsService` uses Kafka transactions to ensure atomic produce+consume, preventing partial validation writes. |
| **Observability** | Each example logs lifecycle events (start, state change, stop) via SLF4J. `KafkaMusicExample` and `WordCountInteractiveQueriesExample` expose REST endpoints over embedded Jetty/Jersey servers, making state store contents queryable externally (`/kafka-music/charts/top-five`, `/state/keyvalue/{storeName}/{key}`). `MetadataService` exposes instance and store location metadata via `streams.streamsMetadataForStore()`. |
| **Evolvability** | Avro schemas with Confluent Schema Registry enforce a schema contract at topic boundaries, enabling independent schema evolution of producers and consumers. The `Service` interface (`start`, `stop`) provides a uniform lifecycle abstraction, making it straightforward to swap or add services without affecting others. The `Schemas.Topics` registry class centralizes topic definitions, so topic names and serdes are defined in one place. |
| **Testability** | 57 test files mirror the 57 source files. Integration tests use `EmbeddedSingleNodeKafkaCluster` to spin up a local Kafka cluster, feed input via `KafkaProducer`, run the topology, and verify output via `KafkaConsumer`. Unit tests use `TopologyTestDriver` for schema-free topology testing without a real Kafka cluster. `EndToEndTest.java` exercises the full microservices workflow end-to-end. |

## Domain

Reference implementation library for Apache Kafka Streams patterns. Core domains covered: stateful stream aggregation (WordCount, TopArticles, Sum), windowing (time windows, session windows), stream-table joins (KStream-KTable, KStream-GlobalKTable, GlobalStore), event-driven choreography microservices (order management workflow), interactive queries with REST exposure of materialized state stores (KafkaMusic, WordCountInteractiveQueries), anomaly detection via windowed counting, schema-registry-backed Avro serialization, and exactly-once transaction semantics.

## Production Context

- Single Maven module (`kafka-streams-examples` v8.3.0-0) packaging all examples into one standalone JAR; each example has its own `main()` method and can run independently
- Docker Compose orchestrates the full demo: Zookeeper, Kafka (Enterprise), Schema Registry, and two instances of `kafka-streams-examples` image
- Microservices package demonstrates that independently deployable services can coexist: each service has its own `main()` and `APPLICATION_ID_CONFIG`, enabling separate scaling
- Avro schemas stored in `src/main/resources/avro/` and compiled by `avro-maven-plugin`; Schema Registry required at runtime for Avro examples
- Semaphore CI pipeline (`.semaphore/semaphore.yml`) with Docker image promotion stages
- NOTE: Repository is officially deprecated in favor of `confluentinc/tutorials`; maintained in "keep the lights on" mode only
