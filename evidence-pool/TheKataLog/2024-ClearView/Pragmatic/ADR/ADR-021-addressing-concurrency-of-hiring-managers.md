# ADR-021: Concurrency of hiring managers

## Date:
2024-09-26

## Status:
Denied

## Context:
Actions of Hiring Managers have the potential for race conditions (Q2).
The architecture could account for concurrent work and
enable a reactive UI for example with websockets, to allow for
asynchronous updates from the backend.

The requirement is only assumed and not explicit.
A solution like websockets leads to an increased complexity.

## Decision:
We decide not to solve this problem for the moment, since it can 
also easily be solved by UX decisions (blocking of access due to open session)
or at a later point for example by using optimistic locking.

## Consequences:
UX is more limited in their design.
