# ADR-014: Multiple services on the same database

## Date:
2024-09-26

## Status:
Accepted

## Context:

Several services need the same objects, for example the object story is used by the services
Job candidate, Story, Matching and Employer.
Since we opted for a service-based architecture and not microservices, we have the possibility to allow several services
to access the same DBs.

## Decision:

Services may access the same DB

## Consequences:
May lead to chaotic coupling. Therefore, we added ADR-015




### Strengthened characteristics:
- Cost (fewer DBs)
- Simplicity

### Weakened characteristics:
- Maintainability
- Testability
- Data integrity
- Fault tolerance



