## 6. Analytics generator and Analytics exporter

Date: 2023-09-14

## Status

Accepted

## Context

We have analytics use cases in our system which require us to share analytics data with third parties. We have to make a decision if we will have one component for both analytics execution and analytics export or we will like to split them into two components. 

## Decision

We will have two components.
- **Analytics generator** : Perform analytics and stores results in analytics storage. This includes yearly report for users, system reports and analytics requested by third parties which we can perform in our system and share the result with them. 
- **Analytics exporter** : Gives system the capability to share analytics data with external users.

## Consequences

### Positive

- All benefits of having modularity; namely, scalability, isolation, testability, maintainability etc
- Enabling the capability to set up analytics factory. It enables system to perfoem some analytics once and share via different mediums with ease due to decamping of processing and export.

### Negative
- Losing simplicity to some extent.
- Maintenance overhead in case of limited resources.

| [🏠 home](../../README.md#adr) | [<< **ADR** One Analytics Generator for yearly user report and other analytics ](./0005-data-reporter-and-analytics-generator.md) | [**ADR** Efficient erythemal for booking tracker >>](./0007-efficient-oriented-algorithm-for-booking-tracker.md) |