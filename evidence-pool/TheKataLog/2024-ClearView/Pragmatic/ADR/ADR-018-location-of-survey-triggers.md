# ADR-018: Location of survey triggers

## Date:
2024-09-26

## Status:
Accepted

## Context:

Surveys for the Hiring Manager or Job candidate need to be triggered.
We plan to use emails to notify the respective users.
The persistence of survey results is needed for reporting purposes.

However, the trigger for sending out surveys would fit inside a survey domain.

Triggering of surveys could also be included in the Analytics & Reporting service, 
but [ADR-017](/ADR/ADR-017-analytics-and-reporting-as-own-service.md) decided to keep operational processes out of this service.

Options:
- A: A new service 'Surveys' for triggering surveys. The communication data for users would need to be gathered or stored.
- B: The creation of emails, trigger of survey system moved to employer and job candidate service.
 From the perspective of DDD this is still a good choice, since the communication data (email addresses)
of the users do not need to leave their services. Survey data if then fetched from the external survey system
by the Analytics and Report system. (Added with [(ADR-020)](/ADR/ADR-020-externalizing-survey-processes.md))

## Decision:

- Option B, the triggers will be included inside Job candidate, resp. Employer services.
- Notification will occur via email.

## Consequences:

### Strengthened characteristics:
- Cost (no new services)
- Simplicity
- Maintainability (one less service to maintain)

### Weakened characteristics:
