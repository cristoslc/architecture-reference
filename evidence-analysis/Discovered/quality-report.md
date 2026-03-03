# Dataset Scaling Pipeline - Quality Report

Generated: 2026-03-03 19:15 UTC
Total entries: 163
Classified: 83
Indeterminate (needs LLM review): 80

## Confidence Distribution (classified entries only)

- Median: 0.95
- IQR (25th-75th): 0.90 - 1.00
- 90% interval (5th-95th): 0.88 - 1.00
- Range: 0.82 - 1.00
- Mean: 0.95 (n=83)

```
  0.0-0.1  |  (0)
  0.1-0.2  |  (0)
  0.2-0.3  |  (0)
  0.3-0.4  |  (0)
  0.4-0.5  |  (0)
  0.5-0.6  |  (0)
  0.6-0.7  |  (0)
  0.7-0.8  |  (0)
  0.8-0.9  | ####### (7)
  0.9-1.0  | ############################################################################ (76)
```

## Architecture Style Coverage

Target: n >= 10 for each of the 12 canonical styles.

| Style | Count | Target Met |
|-------|-------|------------|
| Microservices | 48 | Yes |
| Event-Driven | 65 | Yes |
| Modular Monolith | 14 | Yes |
| Service-Based | 1 | **No** (9 short) |
| Domain-Driven Design | 44 | Yes |
| CQRS | 19 | Yes |
| Space-Based | 2 | **No** (8 short) |
| Hexagonal Architecture | 8 | **No** (2 short) |
| Serverless | 7 | **No** (3 short) |
| Layered | 14 | Yes |
| Pipe-and-Filter | 29 | Yes |
| Multi-Agent | 3 | **No** (7 short) |

**7/12 styles meet target coverage.**

## Indeterminate Entries (needs LLM review)

Entries with confidence < 0.85: 80

| Project | Confidence | Heuristic Candidates |
|---------|-----------|---------------------|
| EventStore | 0.80 | Pipe-and-Filter (0.3) |
| Inflow | 0.80 | Event-Driven (0.3) |
| OrchardCore | 0.80 | Pipe-and-Filter (0.3) |
| eventuous | 0.80 | Pipe-and-Filter (0.3) |
| go-clean-template | 0.80 | Event-Driven (0.3) |
| ignite | 0.80 | Pipe-and-Filter (0.3) |
| medusa | 0.80 | Pipe-and-Filter (0.3) |
| nest | 0.80 | Pipe-and-Filter (0.3) |
| nocodb | 0.80 | Pipe-and-Filter (0.3) |
| orbit | 0.80 | Pipe-and-Filter (0.3) |
| pipeline | 0.80 | Pipe-and-Filter (0.3) |
| qdrant | 0.80 | Microservices (0.8) |
| serverless-express | 0.80 | Event-Driven (0.3) |
| shopware | 0.80 | Domain-Driven Design (0.3) |
| strapi | 0.80 | Pipe-and-Filter (0.3) |
| typeorm | 0.80 | Domain-Driven Design (0.3) |
| EventSourcing.NetCore | 0.70 | Domain-Driven Design (0.3) |
| IDDD_Samples | 0.70 | Domain-Driven Design (0.4) |
| eventuate-tram-core | 0.70 | Domain-Driven Design (0.3) |
| gitlabhq | 0.70 | Pipe-and-Filter (0.3) |
| kafka-streams-examples | 0.70 | Modular Monolith (0.4) |
| kafka | 0.70 | Domain-Driven Design (0.3) |
| n8n | 0.70 | Domain-Driven Design (0.3) |
| nopCommerce | 0.70 | Pipe-and-Filter (0.3) |
| outline | 0.70 | Domain-Driven Design (0.3) |
| practical-dotnet-aspire | 0.70 | Domain-Driven Design (0.3) |
| redis | 0.70 | Modular Monolith (0.7) |
| semantic-kernel | 0.70 | Pipe-and-Filter (0.3) |
| serverless | 0.70 | Domain-Driven Design (0.3) |
| zammad | 0.70 | Domain-Driven Design (0.3) |
| geode | 0.60 | Domain-Driven Design (0.3) |
| go-micro | 0.60 | Event-Driven (0.3) |
| letta | 0.60 | Event-Driven (0.3) |
| mastodon | 0.60 | Pipe-and-Filter (0.3) |
| mattermost | 0.60 | Event-Driven (0.3) |
| rabbitmq-server | 0.60 | Event-Driven (0.3) |
| saleor | 0.60 | Pipe-and-Filter (0.3) |
| MediatR | 0.50 | Pipe-and-Filter (0.3) |
| NServiceBus | 0.50 | Pipe-and-Filter (0.3) |
| NorthwindTraders | 0.50 | CQRS (0.3) |
| Rebus | 0.50 | Pipe-and-Filter (0.3) |
| eureka | 0.50 | Domain-Driven Design (0.3) |
| forem | 0.50 | Event-Driven (0.3) |
| full-stack-fastapi-template | 0.50 | Microservices (0.5) |
| ghostfolio | 0.50 | Event-Driven (0.3) |
| infinispan | 0.50 | Pipe-and-Filter (0.3) |
| jellyfin | 0.50 | Pipe-and-Filter (0.3) |
| kedro | 0.50 | Pipe-and-Filter (0.3) |
| library | 0.50 | Domain-Driven Design (0.3) |
| llama_index | 0.50 | Domain-Driven Design (0.3) |
| maybe | 0.50 | Pipe-and-Filter (0.3) |
| modular-monolith-with-ddd | 0.50 | Hexagonal Architecture (0.3) |
| nats-server | 0.50 | Event-Driven (0.3) |
| nextflow | 0.50 | Domain-Driven Design (0.3) |
| openproject | 0.50 | Pipe-and-Filter (0.3) |
| phidata | 0.50 | Pipe-and-Filter (0.3) |
| ralph | 0.50 | Pipe-and-Filter (0.3) |
| sample-dotnet-core-cqrs-api | 0.50 | Domain-Driven Design (0.3) |
| sdk-go | 0.50 | Event-Driven (0.3) |
| spree | 0.50 | Pipe-and-Filter (0.3) |
| spring-petclinic-microservices | 0.50 | Microservices (0.5) |
| spring-petclinic | 0.50 | Microservices (0.5) |
| traefik | 0.50 | Microservices (0.5) |
| zuul | 0.50 | Pipe-and-Filter (0.3) |
| MetaGPT | 0.40 | Modular Monolith (0.4) |
| Zappa | 0.40 | Modular Monolith (0.4) |
| ddd-starter-modelling-process | 0.40 | Modular Monolith (0.4) |
| go-backend-clean-architecture | 0.40 | Modular Monolith (0.4) |
| go-clean-arch | 0.40 | Modular Monolith (0.4) |
| kotlin-fullstack-sample | 0.40 | Modular Monolith (0.4) |
| lambda-api | 0.40 | Modular Monolith (0.4) |
| luigi | 0.40 | Modular Monolith (0.4) |
| ngx-admin | 0.40 | Modular Monolith (0.4) |
| project-layout | 0.40 | Modular Monolith (0.4) |
| realworld | 0.40 | Modular Monolith (0.4) |
| sample-spring-microservices-new | 0.40 | Modular Monolith (0.4) |
| solidus | 0.40 | Microservices (0.4) |
| superagent | 0.40 | Modular Monolith (0.4) |
| swarm | 0.40 | Modular Monolith (0.4) |
| anthropic-cookbook | 0.20 | Modular Monolith (0.4) |

## Coverage Gaps

The following 5 styles have fewer than 10 samples:

- **Service-Based**: 1/10
- **Space-Based**: 2/10
- **Hexagonal Architecture**: 8/10
- **Serverless**: 7/10
- **Multi-Agent**: 3/10
