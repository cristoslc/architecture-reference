# ADR-024: HR Integration: caching of Resumes

## Date:
2024-09-26

## Status:
Denied

## Context:

With the dead-letter-queue from [(ADR-023)](./ADR-023-adapters-for-hr-systems.md), failing transmissions will be retried periodically.
For every transmission attempt, the resume is fetched anew from the job candidate service.
The contents of these resumes could be cached in the HR adapter service to reduce load in our system.

However, we can assume that when an external system is not reachable, the delivery is not time sensitive anymore.
In that case an alternative would be to tweak the exponential backoff algorithm to attempt retries more sparsely to also 
reduce internal load.

Caching would also lead to the need of cache invalidation (higher complexity), 
and require more (potentially expensive) memory.

## Decision:

Denied, we prefer the load over the memory cost.
Should the load on Job candidate service ever be a bottleneck, the ADR should be considered again.
