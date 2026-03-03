# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 20:09 UTC
Total entries: 160
Classified: 160
Indeterminate (needs LLM review): 0

## Confidence Distribution (classified entries only)

- Median: 0.92
- IQR (25th-75th): 0.90 - 0.95
- 90% interval (5th-95th): 0.82 - 1.00
- Range: 0.75 - 1.00
- Mean: 0.93 (n=160)

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
  0.9-1.0  | ##################################################################################################################################### (133)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 54 | Yes |
| Event-Driven | 90 | Yes |
| Modular Monolith | 42 | Yes |
| Service-Based | 2 | **No** (8 short) |
| Domain-Driven Design | 51 | Yes |
| CQRS | 30 | Yes |
| Space-Based | 7 | **No** (3 short) |
| Hexagonal Architecture | 15 | Yes |
| Serverless | 10 | Yes |
| Layered | 44 | Yes |
| Pipe-and-Filter | 45 | Yes |
| Multi-Agent | 8 | **No** (2 short) |

**9/12 styles meet target coverage.**

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 0

None.

## Coverage Gaps

The following 3 styles have fewer than 10 samples:

- **Service-Based**: 2/10
- **Space-Based**: 7/10
- **Multi-Agent**: 8/10
