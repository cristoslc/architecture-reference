# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-06 12:47 UTC
Total entries: 163
Classified: 139
Indeterminate (needs LLM review): 24

## Confidence Distribution (classified entries only)

- Median: 0.88
- IQR (25th-75th): 0.88 - 0.91
- 90% interval (5th-95th): 0.82 - 0.95
- Range: 0.75 - 0.97
- Mean: 0.89 (n=139)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  |  (0)
  0.6-0.7  |  (0)
  0.7-0.8  | # (1)
  0.8-0.9  | ##################################################################### (69)
  0.9-1.0  | ##################################################################### (69)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 16 | Yes |
| Event-Driven | 47 | Yes |
| Modular Monolith | 65 | Yes |
| Service-Based | 11 | Yes |
| Domain-Driven Design | 29 | Yes |
| CQRS | 17 | Yes |
| Space-Based | 5 | **No** (5 short) |
| Hexagonal Architecture | 20 | Yes |
| Serverless | 3 | **No** (7 short) |
| Layered | 35 | Yes |
| Pipe-and-Filter | 26 | Yes |
| Multi-Agent | 11 | Yes |

**10/12 styles meet target coverage.**

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 24

| Project | Confidence | Heuristic Candidates |
|---------|-----------|---------------------|
| AxonFramework | 0.00 | Modular Monolith (0.7), Event-Driven (0.6), Service-Based (0.5), CQRS (0.4), Domain-Driven Design (0.3) |
| MassTransit | 0.00 | Event-Driven (0.9), Service-Based (0.6), Domain-Driven Design (0.3), Pipe-and-Filter (0.3) |
| MediatR | 0.00 | Modular Monolith (0.4), Pipe-and-Filter (0.3) |
| NServiceBus | 0.00 | Modular Monolith (0.4), Event-Driven (0.3), Domain-Driven Design (0.3), Pipe-and-Filter (0.3) |
| Rebus | 0.00 | Modular Monolith (0.4), Pipe-and-Filter (0.3) |
| Zappa | 0.00 | Modular Monolith (0.4) |
| actix | 0.00 | Modular Monolith (0.4) |
| akka | 0.00 | Microservices (0.7), Event-Driven (0.6), Domain-Driven Design (0.3) |
| anthropic-cookbook | 0.00 | Modular Monolith (0.4) |
| aspire | 0.00 | Microservices (0.9), Event-Driven (0.6), Domain-Driven Design (0.3) |
| aws-lambda-powertools-python | 0.00 | Event-Driven (0.9), Microservices (0.7), Serverless (0.4), Domain-Driven Design (0.3) |
| chalice | 0.00 | Modular Monolith (0.4), Event-Driven (0.3) |
| ddd-starter-modelling-process | 0.00 | Modular Monolith (0.4) |
| e2b | 0.00 | Service-Based (0.6), Event-Driven (0.3) |
| eShopOnContainers | 0.00 | Modular Monolith (0.4) |
| ehcache3 | 0.00 | Event-Driven (0.3), Domain-Driven Design (0.3) |
| examples | 0.00 | Serverless (0.6), Microservices (0.5), Event-Driven (0.3) |
| lambda-api | 0.00 | Modular Monolith (0.4) |
| memcached | 0.00 | Microservices (0.4) |
| project-layout | 0.00 | Modular Monolith (0.4) |
| realworld | 0.00 | Service-Based (0.6), Modular Monolith (0.4) |
| serverless-patterns | 0.00 | Event-Driven (0.9), Serverless (0.7), Microservices (0.5), Domain-Driven Design (0.3), Pipe-and-Filter (0.3) |
| superagent | 0.00 | Modular Monolith (0.4) |
| typeorm | 0.00 | Modular Monolith (0.7), Service-Based (0.4), Event-Driven (0.3), Domain-Driven Design (0.3) |

## Coverage Gaps

The following 2 styles have fewer than 10 samples:

- **Space-Based**: 5/10
- **Serverless**: 3/10
