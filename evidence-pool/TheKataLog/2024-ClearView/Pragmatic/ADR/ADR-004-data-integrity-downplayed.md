# ADR-004: Data integrity downplayed

## Date:
2024-09-23

## Status:
Accepted

## Context:
We need to decide the architecture characteristic to make a decision on the architecture style.
Data integrity is an important part in an AI application, due to its non-deterministic behaviour.

## Decision:
We deprioritize the architecture characteristic of **data integrity** for the following reasons:

- **Quality assurance** of the AI models is already addressed by the characteristic **testability**.
- We believe that many **data integrity measures** are best implemented at the **code level** and do not significantly influence the overall architecture.
- **Data integrity** is not included as a characteristic in the **architecture style worksheet**, and therefore does not contribute to selecting the overall architecture style.


## Consequences:
The checking of the data integrity will not be considered on architecture level, but should be take account on code level.