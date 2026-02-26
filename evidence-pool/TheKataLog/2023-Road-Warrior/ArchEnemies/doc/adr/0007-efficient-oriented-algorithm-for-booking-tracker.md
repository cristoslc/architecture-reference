# 7. Efficiency oriented algorithm for booking tracker

Date: 2023-09-15

## Status

Accepted

## Context

Querying booking status for all active bookings of 15mn customers without taking some booking specific characteristic may have impact either cost/load or timeliness of updates. System needs a smart design to optimize booking tracking to balance cost/load and timeliness.

## Decision

We will create 2 separate approaches for the data update.


**Near Real-Time Update**: This is responsible for near real-time updates for events with expiring dates within a specified timespan.

**Batch Update**: This is a periodic full updates of all events and runs as a background job with relaxed time constraints.

## Consequences

### Positive

Cost-effective
Lower load on system
Dynamic system to adapt to changing situations

### Negative
Will have to maintain two tracking solutions

| [🏠 home](../../README.md#adr) | [<< **ADR** Analytics generator and Analytics exporter ](./0006-analytics-generator-and-analytics-exporter.md) | [**ADR** Deploying system in cloud or on premise >>](./0008-deploying-system-in-cloud-or-on-premise.md) |