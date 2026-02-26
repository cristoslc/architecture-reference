# ADR-010: Create features from story, not resumes

## Date:
2024-09-26

## Status:
Accepted

## Context:

Reasoning can be seen in Q4. This a principle that can be enforced also 
through architecture by limiting the matching algorithms access to resumes.

## Decision:

- Resumes are only persisted in the Job candidate service, and access requires special privileges which
are not given to the matching service.
- The story service does



### Strengthened characteristics:
- Feasibility (important insight, one of the main selling points, enforced by architecture rule)
- Security (important privacy requirement)

### Weakened characteristics:
- Adaptability
