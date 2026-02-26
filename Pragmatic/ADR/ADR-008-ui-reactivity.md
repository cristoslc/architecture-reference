# ADR-008: UI reactivity

## Date:
2024-09-26

## Status:
Accepted

## Context:

For [Q26](/Requirements/requirements-and-assumptions.md), we need to ensure a responsive UI.
Some calls, especially external ones, may be long-running or costly and lead to a delay in the UI.

## Decision:
- Whenever the UI triggers long-running calls, they need to be decoupled from the long-running threads.
- We do this using queues, making them asynchronous calls.
- Costly operations like matching should run periodically in the background.

## Consequences:
The UI design to consider failures and failure messaging to the user more carefully.

### Strengthened characteristics:
- Responsiveness
- Failure-tolerance

### Weakened characteristics:
- Testability (more cases of message ordering are possible)
