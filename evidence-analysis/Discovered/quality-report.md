# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 16:00 UTC
Total entries: 163

## Confidence Distribution

- Median: 0.70
- IQR (25th-75th): 0.50 - 0.90
- 90% interval (5th-95th): 0.40 - 1.00
- Range: 0.30 - 1.00
- Mean: 0.70 (n=163)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  | # (1)
  0.4-0.5  | ######################## (24)
  0.5-0.6  | ################################## (34)
  0.6-0.7  | ######### (9)
  0.7-0.8  | ##################### (21)
  0.8-0.9  | ################################ (32)
  0.9-1.0  | ########################################## (42)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 96 | Yes |
| Event-Driven | 113 | Yes |
| Modular Monolith | 65 | Yes |
| Service-Based | 3 | **No** (7 short) |
| Domain-Driven Design | 83 | Yes |
| CQRS | 29 | Yes |
| Space-Based | 0 | **No** (10 short) |
| Hexagonal Architecture | 12 | Yes |
| Serverless | 9 | **No** (1 short) |
| Layered | 17 | Yes |
| Pipe-and-Filter | 60 | Yes |
| Multi-Agent | 0 | **No** (10 short) |

**8/12 styles meet target coverage.**

## Entries Flagged for Human Review

Entries with confidence < 0.5: 25

| Project | Confidence | Styles |
|---------|-----------|--------|
| snakemake | 0.30 | Indeterminate |
| MetaGPT | 0.40 | Modular Monolith |
| Zappa | 0.40 | Modular Monolith |
| anthropic-cookbook | 0.40 | Modular Monolith |
| aws-serverless-airline-booking | 0.40 | Modular Monolith |
| clean-architecture-example | 0.40 | Modular Monolith |
| dbt-core | 0.40 | Microservices |
| ddd-starter-modelling-process | 0.40 | Modular Monolith |
| eShopOnContainers | 0.40 | Modular Monolith |
| ehcache3 | 0.40 | Event-Driven, Domain-Driven Design |
| go-backend-clean-architecture | 0.40 | Modular Monolith |
| go-clean-arch | 0.40 | Modular Monolith |
| kotlin-fullstack-sample | 0.40 | Modular Monolith |
| lambda-api | 0.40 | Modular Monolith |
| langchain | 0.40 | Modular Monolith |
| luigi | 0.40 | Modular Monolith |
| m-r | 0.40 | Modular Monolith |
| memcached | 0.40 | Microservices |
| ngx-admin | 0.40 | Modular Monolith |
| project-layout | 0.40 | Modular Monolith |
| realworld | 0.40 | Modular Monolith |
| sample-spring-microservices-new | 0.40 | Modular Monolith |
| solidus | 0.40 | Microservices |
| superagent | 0.40 | Modular Monolith |
| swarm | 0.40 | Modular Monolith |

## Coverage Gaps

The following 4 styles have fewer than 10 samples:

- **Service-Based**: 3/10
- **Space-Based**: 0/10
- **Serverless**: 9/10
- **Multi-Agent**: 0/10
