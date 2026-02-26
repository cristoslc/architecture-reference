# ADR-016: Matches published as events
## Date:
2024-09-26

## Status:
Accepted

## Context:
Matches status changes are key events that influence use-cases in many parts of the system.
With synchronous communication, the whole system is strongly coupled leading to bad fault-tolerance.
We mitigate this by creating an event-queue to allow for asynchronous communication between these use cases.

## Decision:
We use an event queue for matches and their status in order to asynchronously notify all downstream processes.

## Consequences:
- Technology decision: shared queues / event streaming

### Strengthened characteristics:
- Fault-tolerance
- Evolvability
- Performance
- Scalability

### Weakened characteristics: 
- Testability
- Simplicity