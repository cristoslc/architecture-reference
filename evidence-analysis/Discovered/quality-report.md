# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 19:55 UTC
Total entries: 163
Classified: 137
Indeterminate (needs LLM review): 26

## Confidence Distribution (classified entries only)

- Median: 0.93
- IQR (25th-75th): 0.90 - 0.97
- 90% interval (5th-95th): 0.82 - 1.00
- Range: 0.82 - 1.00
- Mean: 0.93 (n=137)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  |  (0)
  0.6-0.7  |  (0)
  0.7-0.8  |  (0)
  0.8-0.9  | ###################### (22)
  0.9-1.0  | ################################################################################################################### (115)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 52 | Yes |
| Event-Driven | 86 | Yes |
| Modular Monolith | 35 | Yes |
| Service-Based | 2 | **No** (8 short) |
| Domain-Driven Design | 50 | Yes |
| CQRS | 29 | Yes |
| Space-Based | 6 | **No** (4 short) |
| Hexagonal Architecture | 15 | Yes |
| Serverless | 8 | **No** (2 short) |
| Layered | 36 | Yes |
| Pipe-and-Filter | 38 | Yes |
| Multi-Agent | 6 | **No** (4 short) |

**8/12 styles meet target coverage.**

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 26

| Project | Confidence | Heuristic Candidates |
|---------|-----------|---------------------|
| serverless-express | 0.80 | Serverless (0.7), Modular Monolith (0.4), Event-Driven (0.3) |
| shopware | 0.80 | Modular Monolith (0.7), Event-Driven (0.6), Service-Based (0.4), Domain-Driven Design (0.3) |
| strapi | 0.80 | Modular Monolith (0.7), Layered (0.4), CQRS (0.3), Pipe-and-Filter (0.3) |
| typeorm | 0.80 | Modular Monolith (0.7), Event-Driven (0.3), Domain-Driven Design (0.3) |
| redis | 0.70 | Modular Monolith (0.7) |
| semantic-kernel | 0.70 | Event-Driven (0.6), Microservices (0.5), Layered (0.3), Domain-Driven Design (0.3), Pipe-and-Filter (0.3) |
| serverless | 0.70 | Event-Driven (0.6), Serverless (0.6), Microservices (0.4), Domain-Driven Design (0.3) |
| zammad | 0.70 | Event-Driven (0.6), Microservices (0.5), Domain-Driven Design (0.3) |
| saleor | 0.60 | Microservices (0.5), CQRS (0.3), Pipe-and-Filter (0.3) |
| Rebus | 0.50 | Modular Monolith (0.4), Pipe-and-Filter (0.3) |
| sample-dotnet-core-cqrs-api | 0.50 | Modular Monolith (0.4), CQRS (0.4), Event-Driven (0.3), Domain-Driven Design (0.3) |
| sdk-go | 0.50 | Modular Monolith (0.4), Event-Driven (0.3) |
| spree | 0.50 | Microservices (0.4), Layered (0.3), Pipe-and-Filter (0.3) |
| spring-petclinic-microservices | 0.50 | Microservices (0.5) |
| spring-petclinic | 0.50 | Microservices (0.5) |
| traefik | 0.50 | Microservices (0.5) |
| zuul | 0.50 | Modular Monolith (0.4), Event-Driven (0.3), Domain-Driven Design (0.3), Pipe-and-Filter (0.3) |
| Zappa | 0.40 | Modular Monolith (0.4) |
| ddd-starter-modelling-process | 0.40 | Modular Monolith (0.4) |
| realworld | 0.40 | Modular Monolith (0.4) |
| sample-spring-microservices-new | 0.40 | Modular Monolith (0.4) |
| solidus | 0.40 | Microservices (0.4) |
| superagent | 0.40 | Modular Monolith (0.4) |
| swarm | 0.40 | Modular Monolith (0.4) |
| project-layout | 0.30 | Modular Monolith (0.4) |
| anthropic-cookbook | 0.20 | Modular Monolith (0.4) |

## Coverage Gaps

The following 4 styles have fewer than 10 samples:

- **Service-Based**: 2/10
- **Space-Based**: 6/10
- **Serverless**: 8/10
- **Multi-Agent**: 6/10
