# ADR-002: Architecture style

## Date:

2024-09-23

## Status:

Accepted

## Context:

The choice of architectural style is crucial to the success of a software project. It's important to select a style that fits the problem domain, as changing it later can be costly. Consistent implementation of the architecture also enhances the system’s clarity and understanding.

Depending on the style, additional decisions like databases, communication patterns, ... can be derived.

Needs [ADR-004](/ADR/ADR-004-data-integrity-downplayed.md) for the decision.

## Decision:

According to the requirements and the [Architecture Characteristics](../ArchitectureCharacteristics/Characteristics.md) we
decided to use the Service Based Architecture. Where needed for better inteoperability and deployability we want to use
Event Driven Architecture.

![Architecture Style](../ADR/images/ADR-002-architecture-style.png)

Although the microkernel architecture was considered, its limitations in scalability and fault-tolerance two of our
top [7 driving characteristics](../ArchitectureCharacteristics/Characteristics.md) led us to pursue a different option.

## Consequences:

- Service-Based Architecture is comparatively cheaper and faster to build and easier to maintain
- Event streaming adds complexity, but enables additional decoupling of capabilities

### Strengthened characteristics:
- Testability (independent services with clear interfaces)
- Cost (relatively straight forward to implement)
- Agility (easy to add new services with new functionality)

### Weakened characteristics
- Elasticity (due to shared databases between servuces)