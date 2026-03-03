# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 20:02 UTC
Total entries: 163
Classified: 152
Indeterminate (needs LLM review): 11

## Confidence Distribution (classified entries only)

- Median: 0.92
- IQR (25th-75th): 0.90 - 0.95
- 90% interval (5th-95th): 0.82 - 1.00
- Range: 0.75 - 1.00
- Mean: 0.93 (n=152)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  |  (0)
  0.6-0.7  |  (0)
  0.7-0.8  | # (1)
  0.8-0.9  | ######################## (24)
  0.9-1.0  | ############################################################################################################################### (127)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 54 | Yes |
| Event-Driven | 90 | Yes |
| Modular Monolith | 40 | Yes |
| Service-Based | 2 | **No** (8 short) |
| Domain-Driven Design | 51 | Yes |
| CQRS | 30 | Yes |
| Space-Based | 7 | **No** (3 short) |
| Hexagonal Architecture | 15 | Yes |
| Serverless | 9 | **No** (1 short) |
| Layered | 40 | Yes |
| Pipe-and-Filter | 42 | Yes |
| Multi-Agent | 7 | **No** (3 short) |

**8/12 styles meet target coverage.**

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 11

| Project | Confidence | Heuristic Candidates |
|---------|-----------|---------------------|
| strapi | 0.80 | Modular Monolith (0.7), Layered (0.4), CQRS (0.3), Pipe-and-Filter (0.3) |
| typeorm | 0.80 | Modular Monolith (0.7), Event-Driven (0.3), Domain-Driven Design (0.3) |
| zammad | 0.70 | Event-Driven (0.6), Microservices (0.5), Domain-Driven Design (0.3) |
| traefik | 0.50 | Microservices (0.5) |
| zuul | 0.50 | Modular Monolith (0.4), Event-Driven (0.3), Domain-Driven Design (0.3), Pipe-and-Filter (0.3) |
| Zappa | 0.40 | Modular Monolith (0.4) |
| ddd-starter-modelling-process | 0.40 | Modular Monolith (0.4) |
| superagent | 0.40 | Modular Monolith (0.4) |
| swarm | 0.40 | Modular Monolith (0.4) |
| project-layout | 0.30 | Modular Monolith (0.4) |
| anthropic-cookbook | 0.20 | Modular Monolith (0.4) |

## Coverage Gaps

The following 4 styles have fewer than 10 samples:

- **Service-Based**: 2/10
- **Space-Based**: 7/10
- **Serverless**: 9/10
- **Multi-Agent**: 7/10
