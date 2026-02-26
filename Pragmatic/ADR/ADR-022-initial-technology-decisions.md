# ADR-022: Initial technology decisions

## Date:
2024-09-26

## Status:
Open

## Context:

- Event-Streaming or distributed queue is important for certain processes, but not
  a core part of our system. We do not require highly concurrent use and maximal
  throughput, neither do we them as interfaces to external systems.
Kafka is much more capable, but also more expensive than a lightweight solution like RabbitMQ.
- An identity and access management system is required including OAuth and a Login system.
- Database system is required.
- The runtime environment, such as a container platform or serverless.
- A vault or secret storage is required, especially for storing configurations for the different HR systems.

## Decision:

## Intended Consequences:

### Strengthened characteristics:
- Cost
- Simplicity

### Weakened characteristics:
- Configurability
- Performance