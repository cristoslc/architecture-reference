# ADR-023: Dead-letter queue for HR systems

## Date:
2024-09-26

## Status:
Accepted

## Context:

For R21, the design of HR systems needs to be considered.
[ADR-008](/ADR/ADR-008-ui-reactivity.md) and [ADR-016](/ADR/ADR-016-matches-published-as-events.md) already implies a decoupling from the UI based processes,
but the potentially very large number of different HR systems require 
additional measured to ensure additional fault-tolerance.
Q16 indicates, that we need to cater for thousands of different configurations.
With that many different external systems interfacing, failures are expected to occur regularly.

## Decision:
- We use a separate service for handling the transmission to the external HR systems.
- We use a dead-letter queue that holds failed attempts of transmitting resumes to an external system.
The queue will be processed and retried periodically. To reduce resource usage, one could implement an
exponential backoff algorithm for example by tracking the backoff times in a DB.

## Consequences:

### Strengthened characteristics:
- Fault-tolerance
- Performance
- Observability
- Interoperability

### Weakened characteristics: