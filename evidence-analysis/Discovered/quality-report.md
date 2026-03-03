# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 21:07 UTC
Total entries: 173
Classified: 173
Indeterminate (needs LLM review): 0

## Confidence Distribution (classified entries only)

- Median: 0.92
- IQR (25th-75th): 0.90 - 0.95
- 90% interval (5th-95th): 0.82 - 1.00
- Range: 0.75 - 1.00
- Mean: 0.93 (n=173)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  |  (0)
  0.6-0.7  |  (0)
  0.7-0.8  | # (1)
  0.8-0.9  | ########################## (26)
  0.9-1.0  | ################################################################################################################################################## (146)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 54 | Yes |
| Event-Driven | 100 | Yes |
| Modular Monolith | 42 | Yes |
| Service-Based | 10 | Yes |
| Domain-Driven Design | 51 | Yes |
| CQRS | 30 | Yes |
| Space-Based | 10 | Yes |
| Hexagonal Architecture | 15 | Yes |
| Serverless | 10 | Yes |
| Layered | 44 | Yes |
| Pipe-and-Filter | 47 | Yes |
| Multi-Agent | 10 | Yes |

**12/12 styles meet target coverage.**

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 0

None.

## Coverage Gaps

All 12 canonical styles meet the target coverage.
