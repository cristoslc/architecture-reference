# ADR-025: AI test concept

## Date:
2024-09-30

## Status:
Accepted

## Context:

Fulfilling Q14 and Q15 [Q14 and Q15](/Requirements/requirements-and-assumptions.md) is not trivial.
Based on the design of [ADR-011](/ADR/ADR-011-deterministic-matching.md) we decide to use a dedicated testing
concept to ensure stability of the matching algorithm, as well as other AI functionality.

## Decision:

- Large Test-sets with important business cases needs to be carefully created:
  - Testset of Resumes and their expected Story and expected Human-Readable Features.
  - Testset of Resumes and their expected Resume Tips.
  - Testset of Open Roles and their corresponding Human-Readable Features
  - Testset of Employers and their expected publicly available information
  - Expected Matches
- Test-scopes
  - From Resume to Story (focus on anonymization)
  - From Resume to Resume-Tip [R3](/Requirements/requirements-and-assumptions.md)
  - From Resume to Human-Readable Feature
  - From Story to Human-Readable Feature
  - From Open Role to Human-Readable Feature
  - From Employer to Automatically filled Information [R9](/Requirements/requirements-and-assumptions.md)


## Consequences:

- Not all testcases are easy to automate as for example, anonymization can only be verified by humans or by leveraging 
other LLMs (which adds complexity)

### Strengthened characteristics:
- Testability
- Data integrity
- Feasibility
- Maintainability
- Adaptability
- Deployability

### Weakened characteristics:
- Cost (tests require LLM prompts, which drive cost)
