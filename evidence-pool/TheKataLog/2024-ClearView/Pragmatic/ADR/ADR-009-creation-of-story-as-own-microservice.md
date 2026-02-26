# ADR-009: Creation of story as own microservice

## Date:

2024-09-26

## Status:

Accepted

## Context:

We are to have another microservice just for the handling and creation of the 'Story' objects.

We consider the following options:

- A: Create story in Job candidate Service 
- B: Create story in Matching Service 
- C: Its own service

## Decision:
Option C is our choice since the use-case is independent in the domain model.
and the creation is not time-critical.
Matching Service does not require the resume, and Job candidate service does not require the story.
By choosing C, we avoid coupling via these models.

## Consequences:
- Another service needs to be implemented



### Strengthened characteristics:
- Maintainability (loose coupling & DDD consistency)
- Fault-tolerance (querying story does not affect Job candidate or Marching service)
- Security: stronger isolation of job candidate service, related to ADR-010

### Weakened characteristics:
- Simplicity
- Cost
