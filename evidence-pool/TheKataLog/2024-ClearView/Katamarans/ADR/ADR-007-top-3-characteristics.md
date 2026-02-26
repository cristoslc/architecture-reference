# ADR-007: Selecting Top 3 Characteristics: Abstraction, Cost, and Integration

## Date:
2024-09-26

## Status:
Accepted

## Context:
In previous ADRs team has identieifed multiple characteristics that will drive the overall design and development process. Out of those we had to pick Top 3 characteristics that will be crucial in picking architecture style.

## Decision:
The team has decided to select [cost](ADR-002-cost-as-selected-characteristic.md), [abstraction and integration](ADR-004-abstraction-and-integration-as-additional-characteristics.md) as the Top 3 characteristics for the system’s architecture moving forward. This decision will guide all future design choices to ensure that the system remains flexible enough to integrate with new technologies, affordable for the client, and efficient in its operations across different platforms.

<img src="images/ADR-007-characteristics-sheet.JPG">

## Consequences:
### Pros:
- **Modular and Reusable Design:** By focusing on abstraction, the system will have a modular structure, making it easier to integrate not only multiple HR systems but also future AI components. New AI models or connectors can be added or swapped with minimal disruption.
- **Future-Proofing:** The combination of abstraction and integration ensures that the system is future-proof, allowing for easy expansion without major rewrites or refactoring. This also reduces the potential for technical debt over time.

### Cons:
- **Initial Complexity:** Designing for abstraction and integration may introduce additional complexity in the early stages, as it requires thoughtful planning to ensure the system is modular and flexible. This could potentially slow down the initial development process.
- **Potential Trade-offs Between Cost and Scalability:** Focusing heavily on cost might limit some scalability options, especially if cheaper, less scalable solutions are chosen in the short term. The team will need to balance cost considerations with the need for future scalability.
- **Risk of Overengineering:** Designing for evolvability and abstraction might result in overengineering if the system is built to handle future integrations that never materialize. The team will need to ensure they don’t overcomplicate the architecture unnecessarily.