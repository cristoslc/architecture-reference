# ADR-003: Batch for analytics

## Date:
2024-09-23

## Status:
Proposed

## Context:
- Analytics and Reports are expensive (in terms of money & time) operations
- According to the requirements monthly reports and daily analytics is needed.

## Decision:
We choose to use batch jobs (daily, monthly) for analytics and reports. This reduces the complexity of the system, since realtime analytics and reports are not needed.

## Consequences:
- Reports and Analytics are not realtime
- Complexity and loads can be reduced due to scheduled batch job