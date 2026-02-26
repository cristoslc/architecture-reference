# ADR-004: Selecting abstraction and integration as primary characteristics

## Date:
2024-09-25

## Status:
Accepted

## Context:
Client's business model includes pushing candidate resumes to employer's HR system for a fee. Because of that team will need to build multiple HR system integrations with option of adding more.

## Decision:
To have the system that is easily extended with new HR system connectors we picked abstraction and integration as additional the characteristics to be considered in the selection system architecture.

<img src="images/ADR-004-integration-components.png" />

## Consequences:
### Pros:
- **Modularity and Reusability:** An abstraction layer allows to create a generic connector interface that can be reused for different HR systems. Once built, new connectors can be added easily by implementing the specific interface.
- **Ease of Maintenance:** Any changes or updates to an individual HR system connector can be isolated, as the abstracted layer separates the system-specific logic from the core application. This reduces the risk of breaking other parts of the system.
- **Customizability for Specific HR Systems:** With a focus on integration, each HR system can have custom logic that maximizes the effectiveness of the connection. This allows to take advantage of specific features and capabilities of each system, ensuring optimal performance.

### Cons:
- **Initial Complexity:** Designing and implementing a robust abstraction layer requires upfront planning and development, which can add complexity and slow down the initial release of the system.
- **Higher Maintenance Burden:** Directly integrating with multiple HR systems can increase the maintenance overhead, as each connector may need to be updated when the HR system’s API or data structure changes. This makes the system harder to manage over time.
