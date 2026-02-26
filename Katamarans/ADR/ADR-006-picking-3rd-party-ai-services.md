# ADR-006: Picking 3rd party AI services to reduce costs and time-to-market

## Date:
2024-09-25

## Status:
Accepted

## Context:
Due to the client's non-profit business model and characteristics selected in previous ADRs, team had to decide between picking 3rd party AI services or deploying our own LLMs.

## Decision:
Team decided to pick third-party AI service vendors to speed up time-to-market and reduce upfront costs associated with training, deploying, maintaining and fine-tuning own LLMs. This decision should be reconsidered in future during scaling.

## Consequences:
### Pros:
- **Cost-Effectiveness:** 3rd-party AI services typically operate on a pay-as-you-go model, allowing to only pay for what was used, avoiding the high upfront costs of infrastructure and ongoing maintenance of deployed models.
- **Ease of Implementation:** Integrating with an established AI service is usually faster and easier, as the provider handles much of the complexity around infrastructure, scaling, and model management, reducing the technical burden on the development team.

### Cons:
- **Ongoing Costs:** While avoiding upfront infrastructure costs, using a 3rd-party service could result in higher operational costs over time, especially if the usage scales significantly. However, if this becomes an issue, implementing own LLMs should be reconsidered.
- **Data Privacy Concerns:** Sending data to a 3rd-party service may raise concerns about privacy and data sovereignty, especially when working with sensitive data like PII or diversity surveys.
- **Vendor Lock-In:** Relying on a single provider can result in vendor lock-in, making it more challenging to switch services or bring the model in-house later without significant migration costs. This can be somewhat mitigated by placing an abstraction layer between AI service implementation and the rest of the system.
