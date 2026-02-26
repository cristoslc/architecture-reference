# 1. Space based architecture style

Date: 2023-09-14

## Status

Rejected

## Context

We are evaluating preferred architecture style for the system. Space based has score one the prominent style. Microservices and Event driven are other candidates. For their evaulation, see [ADR-0002](/doc/adr/0002-arch-style-microservices-vs-event-driven.md). 

We have to evaluate space based architecture as preferred architecture style for the system.

Though space based architecture has outstanding elasticity capabilities and does euqally well at scalability and performance, our system warrants fault tolerance over elasticity. Also, as we see in [ADR-0002](/doc/adr/0002-arch-style-microservices-vs-event-driven.md), our system is event based, having space-based style does not align with basic nature and requirements of the system. 

## Decision

We will not use space-based architecture style for the system

## Consequences

### Positive

- Cost
- Fault tolerance

### Negative

- Elasticity

| [🏠 home](../../README.md#adr) | [<< **ADR** ADR Template ](./0000-adr-template.md) | [**ADR** Microservices vs Event driven architecture style >>](./0002-arch-style-microservices-vs-event-driven.md) |
