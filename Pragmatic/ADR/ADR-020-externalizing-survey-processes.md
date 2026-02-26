# ADR-020: Externalizing survey processes

## Date:
2024-09-26

## Status:
Accepted

## Context:
Survey process is externalized by the use of SurveyMonkey or similar.
Existing cheap solutions exist already.
Trigger is explained in [(ADR-018)](/ADR/ADR-018-location-of-survey-triggers.md).
Survey data if fetched from the external survey system
by the Analytics and Report system.

## Decision:
Survey process is externalized by the use of SurveyMonkey or similar.

## Consequences:

### Strengthened characteristics:
- Cost (no new services, use of existing cheap external solution)
- Simplicity
- Agility
- Interoperability

### Weakened characteristics:
- Fault-tolerance (another external service)
- Maintainability (external connection needs to be maintained twice
due to ADR-018)
