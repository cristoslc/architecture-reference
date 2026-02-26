# ADR-005: Async APIs with external systems

## Date:
2024-09-24

## Status:
Accepted

## Context:
We need to know how we want to integrate with external systems, e.g. HR system(s) and billing system.

## Decision:
We want to send data to external systems through asynchronous operations. Unavailable HR systems should not lead to blocking processes.

## Consequences:
- 3rd Party system need to have asynchronous interfaces or:
- A retry mechanism is needed
- Improved interoperability
