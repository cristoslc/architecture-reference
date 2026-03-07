# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-07
Total entries: 184
Production: 142 | Reference: 42
Platforms: 91 | Applications: 93
Classified: 132
Indeterminate (needs classification): 52

## Confidence Distribution

No confidence scores available.


## Taxonomy Composition (ADR-001)

| Category | Count | % |
|----------|-------|---|
| Production platforms | 87 | 47.3% |
| Production applications | 55 | 29.9% |
| Reference platforms | 4 | 2.2% |
| Reference applications | 38 | 20.7% |
| **Total** | **184** | |

Production ratio (platform:application): 87:55 = 1.58:1

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 20 | Yes |
| Event-Driven | 56 | Yes |
| Modular Monolith | 61 | Yes |
| Service-Based | 20 | Yes |
| Domain-Driven Design | 33 | Yes |
| CQRS | 23 | Yes |
| Space-Based | 5 | **No** (5 short) |
| Hexagonal Architecture | 21 | Yes |
| Serverless | 3 | **No** (7 short) |
| Layered | 34 | Yes |
| Pipe-and-Filter | 33 | Yes |
| Multi-Agent | 3 | **No** (7 short) |
| Plugin/Microkernel | 28 | (non-canonical) |

**9/12 styles meet target coverage.**

## Indeterminate Entries

52 entries classified as Indeterminate — these need LLM review and/or deep-context validation.
