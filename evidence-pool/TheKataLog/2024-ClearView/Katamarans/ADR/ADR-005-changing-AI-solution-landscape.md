# ADR-005: Changing AI solution landscape

## Date:
2024-09-25

## Status:
Accepted

## Context:
Building on the decisions in [ADR-002 (cost considerations)](ADR-002-cost-as-selected-characteristic.md) and [ADR-004 (abstraction and integration)](ADR-004-abstraction-and-integration-as-additional-characteristics.md), the team anticipated the need for long-term flexibility and adaptability in the system. As the AI market continues to evolve and new models or solutions emerge, we need a system capable of adapting without major rework. Additionally, integrating with multiple HR systems, requires an architecture that can evolve to incorporate new connectors, and account for AI service changes.

## Decision:
To address this the team has chosen to prioritize evolvability as a core characteristic of the system architecture.

## Consequences:
### Pros:
- **Future-Proofing Against AI Market Changes:** Evolvability ensures the system is flexible enough to accommodate future advancements in AI technologies, including the ability to easily switch AI vendors or integrate new models as they become available, without requiring significant architectural changes.
- **Improved System Lifespan:** Evolvability allows the system to remain relevant and effective over a longer period, adapting to business needs, client demands, and technological changes without requiring major overhauls.

### Cons:
- **Potential for Overengineering:** Designing for too much future flexibility can result in overengineering, where complexity is added to accommodate hypothetical future scenarios that may never materialize, impacting system performance or simplicity.
- **Increased Initial Development Complexity:** Implementing evolvability requires careful planning, which increases the complexity of the initial system design. This may slow down early development efforts as the system is built to be flexible and adaptable.