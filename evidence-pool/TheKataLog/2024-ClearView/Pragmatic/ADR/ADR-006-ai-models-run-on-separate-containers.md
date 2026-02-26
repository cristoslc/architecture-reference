# ADR-006: AI Models run on separate containers

## Date:

2024-09-26

## Status:

Superseded by [ADR-007](/ADR/ADR-007-use-of-external-llms.md)

## Context:

The runtime of AI or machine learning models, such as LLMs, require a high amount of memory, CPU,
and potentially specialized CPU hardware, compared to caller services such as 'Employer' and 'Job candidate'.

We expect the traffic pattern of domain services such as 'Employer', 'Job candidate' to be very different from AI
functionality, since AI
is only used for a small subset of functionality. The scalability needs are therefore different.
If a Domain service would scale horizontally due to heavy traffic, and AI model were included in the runtime, 
another model would be started unnecessarily using additional resources.

Forward-looking: If domain services end up consolidating and sharing their AI resources, it would make sense for the AI service
to be separated from domain services anyway. Keeping the AI runtime in one domain would be confusing since there is no 
justification in terms of DDD.

## Decision:

Keep the runtime of AI models in its own set of containers (or possibly only 1).
Separation of AI containers is driven by the 

## Consequences:
- Separation of concerns between technical AI functionality and other domain functionality.
- Another API needs to be maintained.



### Strengthened characteristics:

- Elasticity (faster startup without model load)
- Cost (less memory use)
- Scalability (more feasible due to fewer hardware requirements)
- Maintainability (AI location clearly defined)
- Testability (mock AI centrally)
- Fault tolerance (failure in AI affects only few features)

### Weakened characteristics:


