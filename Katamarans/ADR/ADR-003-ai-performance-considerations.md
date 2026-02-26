# ADR-003: Performance and scalability of AI-based solutions

## Date:
2024-09-25

## Status:
Accepted

## Context:
Given system's high probablility to scale up as the time goes, and the decision made in [ADR-002 about cost characteristic](ADR-002-cost-as-selected-characteristic.md), team moved to performance considerations of running AI components. We started exploring how to run performant AI tasks while maintaining cost efficiency and how to scale them to support more users over time.

## Decision:
After researching various third-party AI solution vendors, infrastructure requirements and costs associated with running our own AI models, we decided to pick performance and scalability as the next characteristics to be included in architecture style selection. Decision to pick specific AI solution was deferred to the later time.

## Consequences:
### Pros:
- **Improved System Responsiveness:** By prioritizing performance, the system is more likely to deliver fast, efficient AI processing even under heavy loads. This ensures users have a smooth experience with minimal delays, which is crucial for high-traffic environments as the system scales.
- **Future-Proofing for Growth:** Scalability as a core characteristic means the system is designed to handle increasing user demand over time. As the user base expands, the architecture can be scaled seamlessly without degrading performance, preventing the need for costly rework later on.
- **Flexibility to Choose the Best AI Solution Later:** By deferring the specific AI vendor decision, the team can optimize performance and scalability first, ensuring the system is robust and adaptable. Later, we can select the best AI solution that fits the performance needs without being constrained by premature choices.

### Cons:
- **Risk of Performance Bottlenecks During Scaling:** While scalability is prioritized, there’s a chance that performance bottlenecks could still arise if certain components (like data handling or network infrastructure) aren’t fully optimized for scaling. This could lead to performance degradation as user traffic grows.
- **Increased Complexity for Maintaining High Performance:** Ensuring high performance as the system scales requires constant monitoring and adjustments to prevent degradation. Maintaining both scalability and top-tier performance adds operational complexity, especially when balancing resource allocation with growing demands.