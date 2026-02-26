# ADR-002: Selecting cost as primary characteristic

## Date:
2024-09-25

## Status:
Accepted

## Context:
Customer is a non-profit organization with constrained budget and monetization model that will only cover system's resource costs and maintenance services.

## Decision:
Cost was selected as the primary architectural driver.

## Consequences:
### Pros:
- **Financial Feasibility:** The system will remain affordable, ensuring the non-profit can maintain it within their limited budget without requiring significant external funding.
- **Resource Optimization:** Focusing on cost encourages more efficient use of technology resources (e.g., using open-source software, serverless architectures, or cloud cost-optimization techniques), potentially maximizing the value of every dollar spent.
- **Scalability within Budget:** A cost-efficient architecture may allow the non-profit to gradually scale up the system as funds become available, preventing the need for large upfront investments.

### Cons:
- **Possible Vendor Lock-in:** To minimize costs, the organization might rely heavily on specific cloud providers or platforms that offer discounted or non-profit rates. However, this could lead to vendor lock-in, making future migrations expensive and challenging.
- **Technical Debt:** Prioritizing cost over more sustainable long-term architectural choices could lead to technical debt. While initially cheaper, these decisions may require costly rework, upgrades, or refactoring later, negating the short-term savings.
