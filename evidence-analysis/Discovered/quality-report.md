# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 15:24 UTC
Total entries: 10

## Confidence Distribution

- Median: 1.00
- IQR (25th-75th): 0.65 - 1.00
- 90% interval (5th-95th): 0.50 - 1.00
- Range: 0.50 - 1.00
- Mean: 0.84 (n=10)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  | ## (2)
  0.6-0.7  | # (1)
  0.7-0.8  |  (0)
  0.8-0.9  | # (1)
  0.9-1.0  | ###### (6)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 10 | Yes |
| Event-Driven | 6 | **No** (4 short) |
| Modular Monolith | 0 | **No** (10 short) |
| Service-Based | 0 | **No** (10 short) |
| Domain-Driven Design | 2 | **No** (8 short) |
| CQRS | 0 | **No** (10 short) |
| Space-Based | 0 | **No** (10 short) |
| Hexagonal Architecture | 1 | **No** (9 short) |
| Serverless | 1 | **No** (9 short) |
| Layered | 0 | **No** (10 short) |
| Pipe-and-Filter | 1 | **No** (9 short) |
| Multi-Agent | 0 | **No** (10 short) |

**1/12 styles meet target coverage.**

## Entries Flagged for Human Review

Entries with confidence < 0.5: 0

None.

## Coverage Gaps

The following 11 styles have fewer than 10 samples:

- **Event-Driven**: 6/10
- **Modular Monolith**: 0/10
- **Service-Based**: 0/10
- **Domain-Driven Design**: 2/10
- **CQRS**: 0/10
- **Space-Based**: 0/10
- **Hexagonal Architecture**: 1/10
- **Serverless**: 1/10
- **Layered**: 0/10
- **Pipe-and-Filter**: 1/10
- **Multi-Agent**: 0/10
