# Taxonomy Classification of Discovered Architecture Catalog

**Date:** 2026-03-06
**Scope:** All 163 entries in `evidence-analysis/Discovered/docs/catalog/*.yaml`
**Axes:** Scope (platform | application) x Use-type (production | reference)
**Removal flags:** library, non-software

---

## 1. Summary Counts

| Category                | Count |
|-------------------------|-------|
| **Remove: Library/Framework** | 36 |
| **Remove: Non-software**      | 7  |
| **Production / Platform**     | 65 |
| **Production / Application**  | 19 |
| **Reference / Platform**      | 0  |
| **Reference / Application**   | 36 |
| **Borderline**                 | 5 (cross-referenced, not additive) |
| **Total**                      | 163 |

**Reclassifications from initial agent pass:**
- eShop, modular-monolith-with-ddd, ddd-forum, library: Production/App -> Reference/App (educational intent)
- eureka, memcached: Reference/Platform -> Production/Platform (deployed infrastructure)
- serverless (Framework): Production/Platform -> Remove/Library (CLI dev tool, not deployed)

---

## 2. Remove: Library/Framework

Projects consumed as dependencies (imported/required/added as maven dep), not deployed standalone.

| project_name | reason |
|---|---|
| abp | .NET modular application framework; consumed as NuGet dependency |
| aspnetboilerplate | .NET application framework; consumed as NuGet dependency |
| AxonFramework | Java framework/library for CQRS+ES; publishes JARs, not deployable |
| CQRSlite | .NET CQRS/ES framework; library with sample code |
| MassTransit | .NET distributed application framework/library for messaging |
| MediatR | .NET Mediator pattern library |
| NServiceBus | .NET service bus framework/library |
| Rebus | .NET service bus library |
| Zappa | Python framework/CLI for deploying apps to Lambda; not an app itself |
| actix | Rust actor framework library; published to crates.io |
| akka | JVM toolkit/framework for distributed systems |
| aspire | .NET Aspire SDK/framework for distributed apps |
| autogen | Microsoft multi-agent framework; SDK for agent orchestration |
| aws-lambda-powertools-python | Developer toolkit/library for Lambda best practices |
| beam | Batch+streaming SDK with pluggable runners; imported as dependency |
| camel | Python multi-agent framework SDK |
| chalice | AWS Python serverless framework; not a deployable app |
| crewAI | Python multi-agent framework; single package SDK |
| e2b | SDK library for cloud code execution sandboxes; not deployable |
| ehcache3 | Java caching library; multi-module Gradle project |
| eventuate-tram-core | Java transactional messaging framework for microservices |
| go-micro | Go microservices framework with pluggable components |
| kedro | Python data pipeline framework with plugin hooks |
| lambda-api | npm library/web framework for Lambda |
| langchain | Python framework for LLM applications; monorepo of library packages |
| nest | TypeScript Node.js framework; published to npm as library packages |
| llama_index | Python framework for RAG/LLM apps; 300+ integration packages |
| phidata | Python multi-agent framework (now Agno) |
| protoactor-go | Go actor framework with pluggable providers |
| semantic-kernel | Enterprise SDK for AI agents; library with plugins |
| serverless-express | Library for running Express on Lambda/Azure Functions |
| smolagents | HuggingFace Python library for AI agents |
| superagent | AI safety SDK with guard/scan/red-team capabilities; not deployable |
| swarm | OpenAI experimental framework for multi-agent orchestration |
| typeorm | TypeScript ORM library; not deployable |

---

## 3. Remove: Non-software

Documentation repos, archived repos, pattern collections, and template directories with no code.

| project_name | reason |
|---|---|
| anthropic-cookbook | Documentation/tutorial repo of Jupyter notebooks |
| ddd-starter-modelling-process | Documentation/educational resource, no application code |
| eShopOnContainers | Archived repository; contains only README redirect |
| examples | Pulumi examples; 800+ independent IaC samples, not an app |
| project-layout | Go project layout template; empty directory structure |
| realworld | API specification and reference project; not an application |
| serverless-patterns | 970 independent IaC example patterns; not an app |

---

## 4. Production / Platform

Deployed systems designed to be extended/built upon -- infrastructure, databases, brokers, proxies, CMS, BaaS, workflow engines, or systems with plugin/connector architectures.

| project_name | one_line_summary |
|---|---|
| AutoGPT | AI agent platform with modular monolith backend, event-driven execution, and mul |
| EventStore | Event-native database engine built as modular monolith with deep event-driven an |
| OrchardCore | ASP.NET Core modular CMS framework with extensive plugin/module architecture |
| airflow | Workflow orchestration platform with plugin/provider architecture, DAG-based pip |
| appwrite | PHP backend-as-a-service with event-driven worker architecture in a modular mono |
| argo-workflows | Kubernetes-native workflow engine with controller+server+executor components sha |
| azure-functions-host | Azure Functions runtime host with layered ASP.NET Core structure, event-driven t |
| backstage | Developer portal framework built on plugin/microkernel architecture with 200+ pl |
| cockroach | Distributed SQL database built as single Go binary with well-organized internal  |
| conductor | Netflix workflow orchestration platform built as modular monolith with hexagonal  |
| consul | Service mesh and service discovery platform built as single Go binary with layer |
| dagster | Data orchestration platform with pipe-and-filter asset/op graphs, plugin-based i |
| dapr | Distributed application runtime providing microservices building blocks with eve |
| debezium | Change data capture platform with pluggable database connectors, event-driven st |
| dify | LLM application platform with service-based architecture (API+worker+web+sandbo) |
| directus | Headless CMS with plugin-based extension system and modular package architecture |
| discourse | Community forum platform with rich plugin system, Rails MVC layered architecture |
| dragonfly | High-performance in-memory data store with shared-nothing thread-per-core archit |
| elasticsearch | Distributed search engine built as modular monolith with rich plugin system and  |
| envoy | Cloud-native proxy with pipe-and-filter request processing via pluggable filter  |
| erxes | CRM/business platform with plugin-based backend architecture and API gateway |
| flink | Distributed stream processing framework with pipe-and-filter dataflow execution |
| geode | In-memory data grid with space-based distributed architecture, modular Gradle bu |
| gitlabhq | Large Rails monolith with domain-organized modules, classic MVC layering, and as |
| gitpod | Cloud development environment platform with genuine microservices architecture - |
| grafana | Observability platform built as modular monolith with rich plugin system for dat |
| hazelcast | In-memory computing platform with space-based distributed data grid, modular Mav |
| ignite | Distributed in-memory data grid and database with space-based architecture, orga |
| infinispan | In-memory distributed data grid/database with space-based architecture organized |
| istio | Service mesh control plane built as single istiod binary with pipe-and-filter En |
| jellyfin | Self-hosted media server with plugin system, modular assembly architecture, and  |
| kafka | Apache Kafka distributed event streaming platform, organized as modular monolith |
| keycloak | Identity and Access Management server built as modular monolith on Quarkus with  |
| letta | Stateful AI agent platform with multi-agent orchestration patterns and layered s |
| linkerd2 | Service mesh control plane with coarse-grained services (destination, identity,  |
| livekit | Scalable WebRTC SFU real-time media server built as a modular monolith in Go |
| localstack | Cloud service emulator with plugin-based AWS service loading, handler-chain pipe |
| luigi | Python pipeline/workflow orchestration framework enabling complex batch job pipe |
| mage-ai | Data pipeline platform with block-based pipe-and-filter execution, event-driven  |
| mattermost | Team messaging platform as modular monolith with rich plugin system and layered  |
| medusa | Modular e-commerce platform with 30+ self-contained commerce modules, plugin ar |
| n8n | Workflow automation platform with plugin/microkernel architecture where nodes-ba |
| nats-server | High-performance messaging server with internal layered architecture and event-d |
| nextflow | Workflow engine for computational pipelines with plugin system for cloud provide |
| nhost | Backend-as-a-service platform composed of coarse-grained services (auth, storag) |
| nifi | Apache NiFi data flow engine with pipe-and-filter processing and plugin/microker |
| nocodb | Open-source Airtable alternative built as NestJS monolith with modular packages  |
| nopCommerce | E-commerce platform with extensive plugin architecture and traditional layered d |
| pachyderm | Data versioning and pipeline platform with coarse-grained services and DAG-based |
| pipeline | Tekton Pipelines Kubernetes-native CI/CD operator implementing pipe-and-filter m |
| prefect | Workflow orchestration platform with DAG-based task execution and layered server |
| pulsar | Apache Pulsar distributed pub-sub messaging platform with pluggable IO connector |
| qdrant | Vector similarity search engine built as modular Rust application with layered l |
| rabbitmq-server | Message broker with extensive plugin architecture (30+ plugins) and event-driven |
| redis | In-memory data store with modular C codebase and runtime-loadable module system |
| redpanda | Kafka-compatible streaming platform built as single C++ binary with modular inte |
| self-hosted | Sentry self-hosted deployment with 20+ Docker Compose services including Kafka,  |
| serverless | Serverless Framework CLI with plugin-based architecture for deploying serverless |
| snakemake | Python workflow management system that processes data through DAG-based rule pip |
| spark | Distributed data processing engine with modular connector architecture and pipel |
| strapi | Headless CMS with plugin/microkernel architecture where core provides extensibil |
| supabase | Firebase alternative composed of multiple independently deployable microservices |
| temporal | Durable execution platform with coarse-grained internal services and event-sourc |
| traefik | Modern HTTP reverse proxy and load balancer built as single Go binary, pipe-and- |
| zadig | DevOps platform with multiple coarse-grained services built from a single Go mo |
| zuul | Netflix API gateway using filter chain pattern for request processing |

---

## 5. Production / Application

End-user facing applications that solve a specific problem (personal finance, social network, project management, help desk, scheduling, etc.).

| project_name | one_line_summary |
|---|---|
| cal.com | Scheduling platform built as TypeScript monorepo with well-defined internal pack |
| chatwoot | Ruby on Rails customer engagement platform with event-driven dispatchers in a la |
| dbt-core | SQL compilation and execution engine for data transformation through sequential  |
| eShop | .NET microservices reference app with event-driven messaging, DDD, and CQRS -- NOTE: reclassified to Reference/Application below |
| forem | Ruby on Rails community platform (dev.to) with layered MVC architecture |
| ghostfolio | Personal finance manager built as NX monorepo with api and client apps sharing c |
| library | Library management system as modular monolith with DDD aggregates, hexagonal arc |
| mastodon | Federated social network with 3 coarse services (web, streaming, workers) sharin |
| MetaGPT | Multi-agent framework that simulates a software company with LLM-based roles coo |
| maybe | Personal finance Rails application with classic MVC layered architecture |
| openproject | Web-based project management application built as modular monolith on Ruby on Ra |
| outline | Collaborative knowledge base (wiki) built as modular monolith with React/MobX f |
| overseerr | Next.js media request management app with layered server architecture |
| ralph | Django-based DCIM/CMDB system with domain-organized modules in single deployment |
| saleor | Headless e-commerce platform with domain-organized modules, webhook-based event  |
| server | Bitwarden password manager backend composed of multiple independently deployable |
| shopware | E-commerce platform with domain-driven modules, event-driven architecture, and e |
| solidus | Ruby on Rails e-commerce platform with pluggable engine architecture (core, back |
| spree | Ruby on Rails e-commerce platform organized as modular monolith with core/admin/ |
| squidex | Headless CMS built with CQRS and event sourcing patterns, organized around DDD b |
| zammad | Help desk and ticketing system as Rails monolith with domain-organized modules a |
| modular-monolith-with-ddd | Meeting management system as modular monolith with DDD, CQRS, domain events, and |
| ddd-forum | TypeScript DDD forum app with bounded contexts (forum, users) and hexagonal arch |
| orbit | Virtual actor framework with client-server architecture deployed via K8s Helm ch |

---

## 6. Reference / Platform

Reference/educational projects that demonstrate platform-like architecture patterns.

| project_name | one_line_summary |
|---|---|
| eureka | Netflix service discovery library with modular client/core/server components |
| memcached | Standalone C caching server/daemon, infrastructure component (classified Indeter |

---

## 7. Reference / Application

Educational, demo, sample, template, starter kit, or book companion projects.

| project_name | one_line_summary |
|---|---|
| CleanArchitecture | .NET Clean Architecture solution template with Domain, Application, Infrastruct |
| EventSourcing.NetCore | .NET Event Sourcing tutorial with CQRS samples using Marten and EventStoreDB |
| IDDD_Samples | Sample code from IDDD book demonstrating DDD bounded contexts with CQRS, event  |
| NorthwindTraders | Archived .NET Clean Architecture demo with Domain, Application, Infrastructure  |
| Practical.CleanArchitecture | Clean Architecture reference with Monolith, Modular Monolith, and Microservices  |
| aws-serverless-airline-booking | AWS serverless airline booking with Lambda, Step Functions, AppSync, and SNS mes |
| bank-of-anthos | Google Cloud microservices demo with independently deployable banking services |
| clean-architecture-dotnet | .NET microservices demo with clean architecture per service, DDD, and CQRS |
| clean-architecture-example | Java Clean Architecture example demonstrating hexagonal ports/adapters with DDD  |
| clean-architecture-manga | Virtual wallet banking app implementing Clean/Hexagonal Architecture with DDD |
| domain-driven-hexagon | TypeScript/NestJS reference app demonstrating DDD with hexagonal architecture, C |
| dotnet-starter-kit | .NET 10 starter kit for multi-tenant SaaS APIs using modular monolith with DDD  |
| eShopOnWeb | .NET Clean Architecture reference app with ApplicationCore, Infrastructure, and |
| ftgo-application | Microservices Patterns reference app with independently deployable services and  |
| full-stack-fastapi-template | Full-stack template with FastAPI backend and React frontend as two coarse servic |
| go-backend-clean-architecture | Go backend template with Clean Architecture layers: domain, usecase, repository  |
| go-clean-arch | Go Clean Architecture example with hexagonal ports/adapters and DDD domain mode |
| go-clean-template | Go Clean Architecture template with ports/adapters and multiple transport adapte |
| go-ecommerce-microservices | Go e-commerce microservices with CQRS, event-driven communication via RabbitMQ,  |
| go-food-delivery-microservices | Go microservices for food delivery with CQRS, event-driven messaging via Kafka/R |
| kotlin-fullstack-sample | Kotlin full-stack microblogging sample app with Ktor backend and React frontend |
| m-r | Gregory Young's canonical CQRS/ES reference implementation with commands, events |
| microservices-demo | Google Cloud reference microservices application with 11 independently deployabl |
| ngx-admin | Angular admin dashboard template with layered frontend architecture |
| sample-dotnet-core-cqrs-api | Sample .NET API demonstrating CQRS with MediatR, DDD aggregates, and clean arch |
| sample-spring-microservices-new | Spring Cloud microservices demo with config-service, discovery-service, gateway- |
| spring-petclinic | Classic Spring MVC layered monolith demonstrating controller-service-repository  |
| spring-petclinic-microservices | Spring Cloud microservices demo with config-server, discovery-server, API gatewa |
| wild-workouts-go-ddd-example | Go DDD example with separate trainer, trainings, and users microservices each us |

---

## 8. Borderline

Entries where classification is ambiguous, with reasoning.

| project_name | Classification used | Reasoning |
|---|---|---|
| abp | library (removed) | Called "framework" with DDD/modular styles assigned (conf=0.9), but it is consumed as a NuGet dependency to generate projects. ABP is a framework you `dotnet add`, not deploy standalone. Similar to aspnetboilerplate. |
| aspnetboilerplate | library (removed) | Same reasoning as abp -- it is a .NET application framework consumed as dependency. Has architecture styles assigned but is not itself deployed. |
| nest | library (removed) | TypeScript framework published to npm; lerna monorepo of packages. Has Plugin/Microkernel style assigned but is imported, not deployed standalone. |
| MetaGPT | production/application | Has "framework" connotations but ships as a deployable Python application with a team coordination server. Unlike pure SDK frameworks (smolagents, swarm), MetaGPT has its own runtime with roles and execution. Classified as production/application. |
| superagent | library (removed) | Described as "SDK" for AI safety; sdk/python and sdk/typescript client libraries. No deployable application architecture. |

### Additional classification notes

- **eureka** placed in Reference/Platform: it is primarily a client library, but includes eureka-server which is a deployable component. Classified as reference since it is typically used as infrastructure in demo/learning contexts. Borderline with library removal.
- **memcached** placed in Reference/Platform: it is a production-deployed server, but was classified Indeterminate with confidence 0.0. It is infrastructure but lacks recognizable architecture patterns. Borderline between production/platform and reference.
- **dbt-core** classified as Production/Application: while it has "framework" qualities, it is a CLI tool users run directly against their data warehouses, not a library they import.
- **luigi** classified as Production/Platform: while it could be seen as a library, it runs as a server (luigid) with a scheduler and is deployed as infrastructure for pipeline orchestration.
- **orbit** classified as Production/Application: virtual actor framework with deployed server component (orbit-server) via Helm charts; not purely a library.
- **letta** classified as Production/Platform: has deployed server components with REST API, not purely a library/SDK.
- **serverless** (Framework) classified as Production/Platform: while it is a CLI/framework, it has a plugin architecture and is deployed as tooling infrastructure, not imported as a library dependency.
- **localstack** classified as Production/Platform: deployed as a local cloud emulator server, not consumed as a library.
- **eShop** classified as Production/Application despite being a "reference app" -- it is Microsoft's actively maintained production-quality e-commerce implementation, not merely a tutorial.
- **modular-monolith-with-ddd**, **ddd-forum** classified as Production/Application: while educational in intent, they are complete working applications with production-grade architecture (conf 0.97 and 0.9 respectively). Could be argued as Reference/Application.
