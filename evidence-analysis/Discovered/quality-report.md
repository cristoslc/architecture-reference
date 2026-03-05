# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-05
Total entries: 122
Classified: 122
Indeterminate (needs LLM review): 0

## Confidence Distribution (classified entries only)

- Median: 0.88
- IQR (25th-75th): 0.85 - 0.92
- 90% interval (5th-95th): 0.85 - 0.95
- Range: 0.82 - 1.00
- Mean: 0.89 (n=122)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  |  (0)
  0.6-0.7  |  (0)
  0.7-0.8  |  (0)
  0.8-0.9  | ################################################################# (65)
  0.9-1.0  | ######################################################### (57)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Modular Monolith | 64 | Yes |
| Event-Driven | 63 | Yes |
| Layered | 29 | Yes |
| Domain-Driven Design | 27 | Yes |
| Microservices | 26 | Yes |
| Pipe-and-Filter | 19 | Yes |
| CQRS | 18 | Yes |
| Hexagonal Architecture | 16 | Yes |
| Serverless | 6 | No |
| Multi-Agent | 5 | No |
| Space-Based | 5 | No |
| Service-Based | 4 | No |

**8/12 styles meet target coverage.** Four styles fall short after pruning unclassifiable entries: Serverless (6), Multi-Agent (5), Space-Based (5), and Service-Based (4).

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 6

These 6 entries have confidence scores between 0.82 and 0.84, above the hard threshold for exclusion but below the high-confidence tier (0.85+). All passed multi-turn validation.

## Coverage Gaps

Four canonical styles fall below the n >= 10 target after pruning 51 unclassifiable entries (libraries, frameworks, and SDKs that lacked identifiable architecture patterns). The pruned catalog retains only entries with clear architectural signal, improving classification quality at the cost of breadth in these four styles.
