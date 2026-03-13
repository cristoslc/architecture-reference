# SPEC-017 Reclassification Comparison Report

Comparison of the pre-SPEC-008 catalog archive against the current catalog.

- **Old catalog**: `evidence-analysis/Discovered/docs/catalog-archive-pre-008/`
- **New catalog**: `evidence-analysis/Discovered/docs/catalog/`
- **Generated**: 2026-03-06

## 1. Executive Summary

| Metric | Old Catalog | New Catalog |
|--------|-------------|-------------|
| Total repos | 122 | 163 |
| Unique styles (as primary) | 13 | 13 |

**Change Summary:**

- Repos with **changed** primary classification: **45**
- Repos **unchanged**: **77**
- Repos **added** (new catalog only): **41**
- Repos **removed** (old catalog only): **0**

### Classification Method Breakdown

| Method | Old Count | New Count | Delta |
|--------|-----------|-----------|-------|
| deep-validation | 80 | 0 | -80 |
| heuristic | 0 | 47 | +47 |
| heuristic-inconclusive | 0 | 2 | +2 |
| llm-review | 42 | 114 | +72 |

## 2. Architecture Style Distribution (Primary)

| Architecture Style | Old Count | New Count | Delta |
|-------------------|-----------|-----------|-------|
| CQRS | 3 | 3 | 0 |
| Domain-Driven Design | 1 | 1 | 0 |
| Event-Driven | 8 | 10 | +2 |
| Hexagonal Architecture | 8 | 9 | +1 |
| Indeterminate | 0 | 20 | +20 |
| Layered | 8 | 5 | -3 |
| Microservices | 24 | 39 | +15 |
| Modular Monolith | 42 | 33 | -9 |
| Monorepo | 1 | 0 | -1 |
| Multi-Agent | 5 | 10 | +5 |
| Pipe-and-Filter | 11 | 10 | -1 |
| Serverless | 5 | 5 | 0 |
| Service-Based | 1 | 14 | +13 |
| Space-Based | 5 | 4 | -1 |

## 3. Full Repository Comparison

| Repo | Old Primary | New Primary | Old Method | New Method | Changed? |
|------|-------------|-------------|------------|------------|----------|
| AutoGPT | Multi-Agent | Multi-Agent | deep-validation | llm-review | No |
| AxonFramework | Event-Driven | Indeterminate | deep-validation | llm-review | Yes |
| CQRSlite | CQRS | CQRS | deep-validation | llm-review | No |
| CleanArchitecture | Hexagonal Architecture | Hexagonal Architecture | deep-validation | llm-review | No |
| EventSourcing.NetCore | Event-Driven | Event-Driven | llm-review | llm-review | No |
| EventStore | Event-Driven | Event-Driven | deep-validation | llm-review | No |
| IDDD_Samples | Domain-Driven Design | Domain-Driven Design | deep-validation | llm-review | No |
| MassTransit | -- | Event-Driven | -- | heuristic | NEW |
| MediatR | -- | Indeterminate | -- | llm-review | NEW |
| MetaGPT | -- | Multi-Agent | -- | llm-review | NEW |
| NServiceBus | -- | Pipe-and-Filter | -- | llm-review | NEW |
| NorthwindTraders | Hexagonal Architecture | Hexagonal Architecture | llm-review | llm-review | No |
| OrchardCore | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| Practical.CleanArchitecture | Microservices | Microservices | deep-validation | heuristic | No |
| Rebus | -- | Pipe-and-Filter | -- | llm-review | NEW |
| Zappa | -- | Serverless | -- | llm-review | NEW |
| abp | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| actix | -- | Indeterminate | -- | llm-review | NEW |
| airflow | Pipe-and-Filter | Microservices | deep-validation | heuristic | Yes |
| akka | -- | Indeterminate | -- | llm-review | NEW |
| anthropic-cookbook | -- | Indeterminate | -- | llm-review | NEW |
| appwrite | Microservices | Microservices | llm-review | llm-review | No |
| argo-workflows | Layered | Microservices | deep-validation | heuristic | Yes |
| aspire | -- | Microservices | -- | heuristic | NEW |
| aspnetboilerplate | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| autogen | Multi-Agent | Multi-Agent | llm-review | llm-review | No |
| aws-lambda-powertools-python | -- | Event-Driven | -- | heuristic | NEW |
| aws-serverless-airline-booking | Serverless | Serverless | llm-review | llm-review | No |
| azure-functions-host | Serverless | Serverless | deep-validation | llm-review | No |
| backstage | Modular Monolith | Microservices | deep-validation | heuristic | Yes |
| bank-of-anthos | Microservices | Microservices | llm-review | llm-review | No |
| beam | Pipe-and-Filter | Microservices | deep-validation | heuristic | Yes |
| cal.com | Modular Monolith | Service-Based | deep-validation | heuristic | Yes |
| camel | Multi-Agent | Multi-Agent | deep-validation | llm-review | No |
| chalice | -- | Serverless | -- | llm-review | NEW |
| chatwoot | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| clean-architecture-dotnet | Microservices | Microservices | llm-review | llm-review | No |
| clean-architecture-example | Hexagonal Architecture | Hexagonal Architecture | deep-validation | llm-review | No |
| clean-architecture-manga | Hexagonal Architecture | Hexagonal Architecture | deep-validation | llm-review | No |
| cockroach | Layered | Microservices | deep-validation | heuristic | Yes |
| conductor | Microservices | Modular Monolith | deep-validation | llm-review | Yes |
| consul | Modular Monolith | Microservices | deep-validation | heuristic | Yes |
| crewAI | Multi-Agent | Multi-Agent | deep-validation | llm-review | No |
| dagster | Modular Monolith | Microservices | deep-validation | heuristic | Yes |
| dapr | Microservices | Microservices | deep-validation | heuristic | No |
| dbt-core | -- | Pipe-and-Filter | -- | llm-review | NEW |
| ddd-forum | Modular Monolith | Hexagonal Architecture | llm-review | llm-review | Yes |
| ddd-starter-modelling-process | -- | Indeterminate | -- | llm-review | NEW |
| debezium | Event-Driven | Microservices | deep-validation | heuristic | Yes |
| dify | Microservices | Microservices | deep-validation | llm-review | No |
| directus | Modular Monolith | Service-Based | llm-review | heuristic | Yes |
| discourse | Modular Monolith | Service-Based | deep-validation | heuristic | Yes |
| domain-driven-hexagon | Hexagonal Architecture | Hexagonal Architecture | deep-validation | llm-review | No |
| dotnet-starter-kit | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| dragonfly | Space-Based | Space-Based | deep-validation | llm-review | No |
| e2b | -- | Indeterminate | -- | llm-review | NEW |
| eShop | Microservices | Microservices | deep-validation | llm-review | No |
| eShopOnContainers | Microservices | Indeterminate | llm-review | llm-review | Yes |
| eShopOnWeb | Layered | Modular Monolith | llm-review | llm-review | Yes |
| ehcache3 | -- | Modular Monolith | -- | llm-review | NEW |
| elasticsearch | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| envoy | Pipe-and-Filter | Pipe-and-Filter | deep-validation | llm-review | No |
| erxes | Microservices | Service-Based | llm-review | heuristic | Yes |
| eureka | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| eventuate-tram-core | Event-Driven | Event-Driven | deep-validation | llm-review | No |
| examples | -- | Indeterminate | -- | llm-review | NEW |
| flink | Pipe-and-Filter | Microservices | deep-validation | heuristic | Yes |
| forem | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| ftgo-application | Microservices | Microservices | deep-validation | heuristic | No |
| full-stack-fastapi-template | Layered | Layered | deep-validation | llm-review | No |
| geode | Space-Based | Space-Based | deep-validation | llm-review | No |
| ghostfolio | Modular Monolith | Service-Based | llm-review | heuristic | Yes |
| gitlabhq | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| gitpod | Microservices | Microservices | deep-validation | heuristic | No |
| go-backend-clean-architecture | Hexagonal Architecture | Hexagonal Architecture | llm-review | llm-review | No |
| go-clean-arch | Hexagonal Architecture | Hexagonal Architecture | deep-validation | llm-review | No |
| go-clean-template | Hexagonal Architecture | Hexagonal Architecture | llm-review | llm-review | No |
| go-ecommerce-microservices | Microservices | Microservices | deep-validation | heuristic | No |
| go-food-delivery-microservices | Microservices | Microservices | deep-validation | heuristic | No |
| go-micro | Microservices | Microservices | deep-validation | heuristic | No |
| grafana | Modular Monolith | Microservices | deep-validation | heuristic | Yes |
| hazelcast | Space-Based | Event-Driven | deep-validation | heuristic | Yes |
| ignite | Space-Based | Space-Based | deep-validation | llm-review | No |
| infinispan | Space-Based | Space-Based | deep-validation | llm-review | No |
| istio | Service-Based | Microservices | deep-validation | heuristic | Yes |
| jellyfin | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| kafka | -- | Event-Driven | -- | llm-review | NEW |
| kedro | Pipe-and-Filter | Pipe-and-Filter | deep-validation | llm-review | No |
| keycloak | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| kotlin-fullstack-sample | -- | Service-Based | -- | llm-review | NEW |
| lambda-api | -- | Indeterminate | -- | llm-review | NEW |
| langchain | -- | Modular Monolith | -- | llm-review | NEW |
| letta | Layered | Multi-Agent | llm-review | llm-review | Yes |
| library | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| linkerd2 | Microservices | Microservices | deep-validation | heuristic | No |
| livekit | -- | Modular Monolith | -- | llm-review | NEW |
| llama_index | -- | Modular Monolith | -- | llm-review | NEW |
| localstack | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| luigi | -- | Pipe-and-Filter | -- | llm-review | NEW |
| m-r | CQRS | CQRS | deep-validation | llm-review | No |
| mage-ai | Pipe-and-Filter | Microservices | deep-validation | heuristic | Yes |
| mastodon | Modular Monolith | Service-Based | deep-validation | llm-review | Yes |
| mattermost | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| maybe | Modular Monolith | Layered | llm-review | llm-review | Yes |
| medusa | Modular Monolith | Service-Based | deep-validation | heuristic | Yes |
| memcached | -- | Indeterminate | -- | llm-review | NEW |
| microservices-demo | Microservices | Microservices | deep-validation | heuristic | No |
| modular-monolith-with-ddd | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| n8n | Modular Monolith | Service-Based | deep-validation | heuristic | Yes |
| nats-server | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| nest | -- | Service-Based | -- | heuristic | NEW |
| nextflow | Pipe-and-Filter | Pipe-and-Filter | llm-review | llm-review | No |
| ngx-admin | -- | Modular Monolith | -- | llm-review | NEW |
| nhost | Microservices | Service-Based | deep-validation | heuristic | Yes |
| nifi | Pipe-and-Filter | Event-Driven | deep-validation | heuristic | Yes |
| nocodb | Modular Monolith | Indeterminate | llm-review | heuristic-inconclusive | Yes |
| nopCommerce | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| openproject | Layered | Modular Monolith | deep-validation | llm-review | Yes |
| orbit | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| outline | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| overseerr | -- | Layered | -- | llm-review | NEW |
| pachyderm | Microservices | Microservices | deep-validation | heuristic | No |
| phidata | -- | Multi-Agent | -- | llm-review | NEW |
| pipeline | Pipe-and-Filter | Pipe-and-Filter | deep-validation | llm-review | No |
| prefect | Pipe-and-Filter | Microservices | llm-review | heuristic | Yes |
| project-layout | -- | Indeterminate | -- | llm-review | NEW |
| protoactor-go | Multi-Agent | Indeterminate | llm-review | llm-review | Yes |
| pulsar | Event-Driven | Event-Driven | deep-validation | heuristic | No |
| qdrant | Layered | Layered | llm-review | llm-review | No |
| rabbitmq-server | Modular Monolith | Indeterminate | llm-review | llm-review | Yes |
| ralph | -- | Modular Monolith | -- | llm-review | NEW |
| realworld | -- | Indeterminate | -- | llm-review | NEW |
| redis | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| redpanda | Event-Driven | Microservices | llm-review | heuristic | Yes |
| saleor | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| sample-dotnet-core-cqrs-api | CQRS | CQRS | llm-review | llm-review | No |
| sample-spring-microservices-new | Microservices | Microservices | deep-validation | llm-review | No |
| self-hosted | Microservices | Microservices | deep-validation | llm-review | No |
| semantic-kernel | -- | Multi-Agent | -- | llm-review | NEW |
| server | Modular Monolith | Microservices | deep-validation | llm-review | Yes |
| serverless | Serverless | Indeterminate | llm-review | llm-review | Yes |
| serverless-express | Serverless | Serverless | llm-review | llm-review | No |
| serverless-patterns | Serverless | Event-Driven | deep-validation | heuristic | Yes |
| shopware | Modular Monolith | Modular Monolith | deep-validation | llm-review | No |
| smolagents | -- | Multi-Agent | -- | llm-review | NEW |
| snakemake | -- | Indeterminate | -- | heuristic-inconclusive | NEW |
| solidus | -- | Modular Monolith | -- | llm-review | NEW |
| spark | -- | Microservices | -- | heuristic | NEW |
| spree | Layered | Service-Based | deep-validation | heuristic | Yes |
| spring-petclinic | -- | Layered | -- | llm-review | NEW |
| spring-petclinic-microservices | Microservices | Microservices | deep-validation | llm-review | No |
| squidex | Modular Monolith | Microservices | deep-validation | heuristic | Yes |
| strapi | Modular Monolith | Service-Based | deep-validation | heuristic | Yes |
| supabase | Monorepo | Service-Based | deep-validation | heuristic | Yes |
| superagent | -- | Indeterminate | -- | llm-review | NEW |
| swarm | -- | Multi-Agent | -- | llm-review | NEW |
| temporal | Event-Driven | Microservices | llm-review | llm-review | Yes |
| traefik | Modular Monolith | Pipe-and-Filter | deep-validation | llm-review | Yes |
| typeorm | -- | Indeterminate | -- | llm-review | NEW |
| wild-workouts-go-ddd-example | Microservices | Microservices | deep-validation | heuristic | No |
| zadig | Microservices | Microservices | deep-validation | heuristic | No |
| zammad | Modular Monolith | Modular Monolith | llm-review | llm-review | No |
| zuul | Pipe-and-Filter | Pipe-and-Filter | llm-review | llm-review | No |

## 4. Space-Based Architecture (SBA) Detection Improvements

| Metric | Old | New | Delta |
|--------|-----|-----|-------|
| Repos with SBA (any position) | 5 | 4 | -1 |
| Repos with SBA as primary | 5 | 4 | -1 |

**Repos with SBA classification:**

| Repo | In Old? | In New? | Change |
|------|---------|---------|--------|
| dragonfly | Yes | Yes | Retained |
| geode | Yes | Yes | Retained |
| hazelcast | Yes | No | Lost |
| ignite | Yes | Yes | Retained |
| infinispan | Yes | Yes | Retained |

## 5. Plugin/Microkernel Detection Improvements

| Metric | Old | New | Delta |
|--------|-----|-----|-------|
| Repos with Plugin/Microkernel (any position) | 0 | 5 | +5 |
| Repos with Plugin/Microkernel as primary | 0 | 0 | 0 |

**Repos with Plugin/Microkernel classification:**

| Repo | In Old? | In New? | Change |
|------|---------|---------|--------|
| backstage | No | Yes | Added |
| beam | No | Yes | Added |
| discourse | No | Yes | Added |
| grafana | No | Yes | Added |
| hazelcast | No | Yes | Added |

## 6. Regressions

| Repo | Old State | New State |
|------|-----------|-----------|
| AxonFramework | Event-Driven (deep-validation) | Indeterminate (llm-review) |
| airflow | Pipe-and-Filter (deep-validation) | Microservices (heuristic) |
| argo-workflows | Layered (deep-validation) | Microservices (heuristic) |
| backstage | Modular Monolith (deep-validation) | Microservices (heuristic) |
| beam | Pipe-and-Filter (deep-validation) | Microservices (heuristic) |
| cal.com | Modular Monolith (deep-validation) | Service-Based (heuristic) |
| cockroach | Layered (deep-validation) | Microservices (heuristic) |
| conductor | Microservices (deep-validation) | Modular Monolith (llm-review) |
| consul | Modular Monolith (deep-validation) | Microservices (heuristic) |
| dagster | Modular Monolith (deep-validation) | Microservices (heuristic) |
| debezium | Event-Driven (deep-validation) | Microservices (heuristic) |
| discourse | Modular Monolith (deep-validation) | Service-Based (heuristic) |
| flink | Pipe-and-Filter (deep-validation) | Microservices (heuristic) |
| grafana | Modular Monolith (deep-validation) | Microservices (heuristic) |
| hazelcast | Space-Based (deep-validation) | Event-Driven (heuristic) |
| istio | Service-Based (deep-validation) | Microservices (heuristic) |
| mage-ai | Pipe-and-Filter (deep-validation) | Microservices (heuristic) |
| mastodon | Modular Monolith (deep-validation) | Service-Based (llm-review) |
| medusa | Modular Monolith (deep-validation) | Service-Based (heuristic) |
| n8n | Modular Monolith (deep-validation) | Service-Based (heuristic) |
| nhost | Microservices (deep-validation) | Service-Based (heuristic) |
| nifi | Pipe-and-Filter (deep-validation) | Event-Driven (heuristic) |
| openproject | Layered (deep-validation) | Modular Monolith (llm-review) |
| server | Modular Monolith (deep-validation) | Microservices (llm-review) |
| serverless-patterns | Serverless (deep-validation) | Event-Driven (heuristic) |
| spree | Layered (deep-validation) | Service-Based (heuristic) |
| squidex | Modular Monolith (deep-validation) | Microservices (heuristic) |
| strapi | Modular Monolith (deep-validation) | Service-Based (heuristic) |
| supabase | Monorepo (deep-validation) | Service-Based (heuristic) |
| traefik | Modular Monolith (deep-validation) | Pipe-and-Filter (llm-review) |

