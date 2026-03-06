---
title: "Ecosystem-Level Architecture Classification"
artifact: EPIC-010
status: Proposed
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-vision: VISION-001
success-criteria:
  - Catalog includes ecosystem-level entries that capture cross-repo architectural patterns invisible at the single-repo level
  - At least 10 multi-repo ecosystems curated with member repos identified and individually classified
  - Ecosystem entries document the emergent architecture (the composition pattern) distinct from individual member classifications
  - Reference library documents reflect ecosystem evidence alongside single-repo evidence
  - Pipeline tooling supports ecosystem entries (manifest format, validation, quality report)
depends-on:
  - SPEC-019
---

# Ecosystem-Level Architecture Classification

## Goal / Objective

Extend the evidence catalog to capture architectural patterns that emerge from the composition of multiple independently-developed repositories into a coherent system. The current pipeline analyzes repos in isolation — each gets its own classification. But some of the most important architectural patterns (Service-Based, Pipe-and-Filter, Event-Driven choreography) only become visible when you examine how multiple repos interact.

## The Problem

Our catalog classifies elasticsearch as "Modular Monolith + Plugin/Microkernel" — correct for the single repo. But the ELK *stack* (Elasticsearch + Logstash + Kibana + Beats) is a Pipe-and-Filter architecture where each component is a stage in a data processing pipeline. That emergent pattern is invisible to single-repo analysis.

### Catalog ecosystem audit

Of our 163 repos, **77 belong to identifiable ecosystems** with 99 missing companion repos. 35 runtime ecosystems identified across the catalog.

#### Data & Messaging (6 repos in catalog, 7 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **Apache Data Ecosystem** | kafka, flink, spark, beam, airflow, nifi | hive, cassandra, zookeeper, storm, druid, superset, iceberg | Pipe-and-Filter / Event-Driven data mesh |
| **Apache Data Grid** | geode, ignite | — | Space-Based in-memory compute grid |
| **ELK / Elastic Stack** | elasticsearch | kibana, logstash, beats, apm-server | Pipe-and-Filter (ingest -> store -> visualize) |
| **Messaging Platforms** | kafka, pulsar, rabbitmq-server, nats-server, redpanda | — | Event-Driven backbone (each independently deployable) |

#### Observability (2 repos, 9 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **Grafana LGTM Stack** | grafana | loki, tempo, mimir, prometheus, alloy, pyroscope | Service-Based observability platform |
| **Sentry Self-Hosted** | self-hosted | sentry, snuba, relay | Microservices error tracking |

#### Infrastructure & Service Mesh (5 repos, 11 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **HashiCorp Stack** | consul | vault, nomad, terraform, waypoint, packer, boundary | Service-Based infrastructure platform |
| **Istio / Envoy** | istio, envoy | — | Sidecar proxy (envoy=data plane, istio=control plane) |
| **Linkerd** | linkerd2 | linkerd2-proxy | Sidecar proxy pattern |
| **Kubernetes** | — | kubernetes, etcd, coredns, containerd, kube-proxy, cri-o | Microservices container orchestration |

#### CI/CD & DevOps (4 repos, 8 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **Argo** | argo-workflows | argo-cd, argo-rollouts, argo-events | Event-Driven GitOps platform |
| **Tekton** | pipeline | triggers, dashboard, results | Pipe-and-Filter CI/CD |
| **GitLab** | gitlabhq | gitlab-runner, gitlab-pages, gitaly | Modular Monolith + Service-Based satellites |
| **Backstage** | backstage | — | Plugin/Microkernel developer portal |

#### E-Commerce (5 repos, 10 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **Saleor** | saleor | saleor-dashboard, saleor-storefront, saleor-apps | Service-Based headless commerce |
| **Medusa** | medusa | medusa-admin, nextjs-starter-medusa | Plugin/Microkernel headless commerce |
| **Shopware** | shopware | shopware-pwa, shopware-frontends | Plugin/Microkernel commerce platform |
| **Spree** | spree | spree_auth_devise, spree_gateway, spree_frontend | Modular Monolith with plugin extensions |

#### AI/ML (12 repos, 3 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **LangChain** | langchain, llama_index | langserve, langsmith, langgraph | Multi-Agent / Pipe-and-Filter LLM orchestration |
| **Agent Frameworks** | AutoGPT, crewAI, autogen, MetaGPT, smolagents, swarm, semantic-kernel, camel, letta, phidata | — | Multi-Agent framework ecosystem |

#### Media & Communication (6 repos, 14 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **\*arr Media Stack** | overseerr | sonarr, radarr, bazarr, prowlarr, lidarr, readarr | Service-Based media automation |
| **Jellyfin** | jellyfin | jellyfin-web, jellyfin-vue, jellyfin-sdk-typescript | Plugin/Microkernel media server |
| **Fediverse** | mastodon, discourse, forem | pleroma, misskey, lemmy | Federated Service-Based (ActivityPub) |
| **Mattermost** | mattermost | mattermost-webapp, mattermost-mobile | Plugin/Microkernel team messaging |

#### BaaS & Platforms (4 repos, 5 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **Supabase** | supabase, nhost | supabase-auth, supabase-storage, supabase-realtime, postgrest, gotrue | Microservices BaaS |
| **Low-Code CMS** | nocodb, directus, strapi, appwrite | baserow, budibase, tooljet | Plugin/Microkernel platforms |

#### Workflow & Runtime (3 repos, 12 missing)

| Ecosystem | Have | Missing | Emergent Architecture |
|-----------|------|---------|----------------------|
| **Dapr** | dapr | dapr-components-contrib, dapr-workflows, dapr-cli | Sidecar pattern with pluggable components |
| **Temporal** | temporal | temporal-sdk-go, temporal-sdk-java, temporal-sdk-typescript, temporal-ui | Service-Based workflow runtime |
| **Home Automation** | n8n | home-assistant, esphome, zigbee2mqtt, node-red, mosquitto | Event-Driven + Plugin IoT platform |
| **Spring Cloud** | spring-petclinic, spring-petclinic-microservices, sample-spring-microservices-new | spring-cloud-gateway, spring-cloud-config, spring-cloud-netflix | Microservices infrastructure |

### Why this matters for the reference library

1. **Service-Based is underrepresented.** Only 11 repos (6.7%) classified as Service-Based — but many real-world Service-Based systems are ecosystems of independent repos (the \*arr stack, HashiCorp, Grafana LGTM). Adding ecosystem entries would give Service-Based much stronger evidence.

2. **Pipe-and-Filter at scale is invisible.** We classify individual data processing tools (Flink, Spark, Airflow) but miss the pipeline compositions they participate in (ELK, Apache data stack).

3. **The "independently deployable" question.** Our Microservices false-positive problem (EPIC-009) partly stems from Docker/k8s signals. Ecosystem entries would provide positive evidence of what real multi-service systems look like — because ecosystem members ARE independently deployed by definition.

## Scope Boundaries

### In scope

- Curating a list of multi-repo ecosystems with member repos and composition patterns
- Defining an ecosystem catalog entry format (links member repos, describes emergent architecture)
- Adding missing member repos to the single-repo catalog (e.g., Kibana, Logstash, Prometheus, Sonarr)
- Deep-validating ecosystem entries (reading API contracts, integration docs, shared schemas between members)
- Updating pipeline tooling to support ecosystem entries in manifests, quality reports, and index
- Propagating ecosystem evidence into reference library documents

### Out of scope

- Changing how single-repo classification works (that's EPIC-009)
- Proprietary/closed-source ecosystems (we can only analyze open-source repos)
- Runtime topology analysis (we analyze source code, not deployed systems)

## Child Specs

| ID | Title | Status | Focus |
|----|-------|--------|-------|
| — | TBD: Ecosystem Catalog Format | — | ADR + schema for ecosystem entries linking member repos to emergent architecture |
| — | TBD: Ecosystem Curation | — | Curate 10+ ecosystems, add missing member repos, deep-validate |
| — | TBD: Pipeline Ecosystem Support | — | Manifest format, validation, quality report updates |
| — | TBD: Reference Library Ecosystem Integration | — | Update reference docs with ecosystem evidence |

## Key Dependencies

- **SPEC-019** (Implemented): Provides the single-repo deep-validated catalog as baseline
- **EPIC-009** (Proposed): Heuristic improvements may benefit from ecosystem evidence (positive examples of Service-Based, Pipe-and-Filter)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-06 | 78f8e36 | Initial creation; identified ecosystem gap in SPEC-019 analysis |
