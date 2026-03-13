# Regression Resolution Report -- SPEC-019

## Summary

| Metric | Count |
|--------|-------|
| Total repos deep-validated | 163 |
| SPEC-017 regressions identified | 30 |
| Regressions resolved (heuristic now agrees) | 2 |
| Regressions confirmed (deep-validation overrides heuristic) | 28 |
| Deep-validation confirmed heuristic (all repos) | 29 |
| Deep-validation overrode heuristic (all repos) | 134 |

The heuristic pipeline has an **17.8% accuracy rate** (29/163) when measured against deep-validation ground truth. The overwhelming majority of errors stem from the heuristic defaulting to `Indeterminate` (116 of 163 repos) or over-classifying as `Microservices` (29 repos). The heuristic pipeline currently recognizes only 4 styles: Microservices, Service-Based, Event-Driven, and Indeterminate -- it cannot detect 10 of the 14 architecture styles in the catalog.

## Heuristic Accuracy Analysis

### Where Heuristics Were Correct

29 repos where the heuristic primary style matched deep-validation ground truth:

| Repo | Style | Heuristic Confidence | Deep-Validation Confidence |
|------|-------|---------------------|---------------------------|
| dapr | Microservices | 1.0 | 0.88 |
| ftgo-application | Microservices | 1.0 | 0.95 |
| gitpod | Microservices | 1.0 | 0.88 |
| go-ecommerce-microservices | Microservices | 0.9 | 0.90 |
| go-food-delivery-microservices | Microservices | 0.9 | 0.92 |
| microservices-demo | Microservices | 1.0 | 0.95 |
| wild-workouts-go-ddd-example | Microservices | 1.0 | 0.92 |
| nhost | Service-Based | 1.0 | 0.85 |
| pulsar | Event-Driven | 1.0 | 0.90 |
| AxonFramework | Indeterminate | 0.8 | -- |
| MediatR | Indeterminate | 0.5 | -- |
| NServiceBus | Indeterminate | 0.5 | -- |
| Rebus | Indeterminate | 0.5 | -- |
| Zappa | Indeterminate | 0.4 | -- |
| actix | Indeterminate | 0.4 | -- |
| akka | Indeterminate | 0.8 | -- |
| anthropic-cookbook | Indeterminate | 0.4 | -- |
| chalice | Indeterminate | 0.5 | -- |
| ddd-starter-modelling-process | Indeterminate | 0.4 | -- |
| e2b | Indeterminate | 0.7 | -- |
| eShopOnContainers | Indeterminate | 0.4 | -- |
| ehcache3 | Indeterminate | 0.4 | -- |
| examples | Indeterminate | 0.7 | -- |
| lambda-api | Indeterminate | 0.4 | -- |
| memcached | Indeterminate | 0.4 | -- |
| project-layout | Indeterminate | 0.4 | -- |
| realworld | Indeterminate | 0.7 | -- |
| superagent | Indeterminate | 0.4 | -- |
| typeorm | Indeterminate | 0.8 | -- |

Of the 29 "matches," 20 are Indeterminate-to-Indeterminate agreements (the heuristic correctly identified repos it could not classify). Only **9 repos** represent true positive classifications where the heuristic identified a real architecture style correctly. This gives a **true positive accuracy of 5.5%** (9/163) for non-trivial classifications.

### Where Heuristics Were Wrong

134 repos where deep-validation disagreed with the heuristic. The most impactful misclassification patterns:

#### Heuristic said Microservices, deep-validation disagreed (21 repos)

| Repo | Deep-Validation Style | Notes |
|------|----------------------|-------|
| airflow | Plugin/Microkernel | Provider plugin ecosystem, single deployable |
| argo-workflows | Modular Monolith | Single Go binary with internal packages |
| aspire | Indeterminate | .NET orchestration framework, not a microservices app |
| backstage | Plugin/Microkernel | 200+ in-process plugins, single deployment |
| beam | Pipe-and-Filter | Data pipeline SDK |
| cockroach | Modular Monolith | Single binary distributed database |
| consul | Modular Monolith | Single binary service mesh |
| dagster | Modular Monolith | Data orchestrator with plugin system |
| debezium | Event-Driven | CDC connectors on Kafka Connect |
| flink | Pipe-and-Filter | Stream processing framework |
| go-micro | Plugin/Microkernel | Microservice framework (not itself microservices) |
| grafana | Plugin/Microkernel | Plugin-extensible observability platform |
| istio | Modular Monolith | Merged into single istiod binary |
| linkerd2 | Service-Based | Service mesh with distinct components |
| mage-ai | Modular Monolith | Data pipeline tool |
| pachyderm | Service-Based | Data versioning platform |
| Practical.CleanArchitecture | Hexagonal Architecture | Clean arch demo app |
| prefect | Pipe-and-Filter | Workflow orchestration |
| redpanda | Event-Driven | Kafka-compatible streaming platform |
| spark | Pipe-and-Filter | Distributed data processing |
| squidex | CQRS | Headless CMS with CQRS pattern |
| zadig | Service-Based | DevOps platform |

#### Heuristic said Indeterminate, deep-validation found a clear style (96 repos)

| Deep-Validation Style | Count | Example Repos |
|----------------------|-------|---------------|
| Modular Monolith | 27 | abp, elasticsearch, keycloak, redis, shopware |
| Multi-Agent | 10 | AutoGPT, MetaGPT, crewAI, semantic-kernel, swarm |
| Hexagonal Architecture | 9 | CleanArchitecture, go-clean-arch, domain-driven-hexagon |
| Pipe-and-Filter | 9 | envoy, kedro, nextflow, pipeline, zuul |
| Layered | 8 | full-stack-fastapi-template, qdrant, spring-petclinic |
| Microservices | 7 | bank-of-anthos, eShop, spring-petclinic-microservices |
| Event-Driven | 5 | EventStore, kafka, eventuate-tram-core |
| Plugin/Microkernel | 5 | jellyfin, nopCommerce, rabbitmq-server |
| Service-Based | 4 | dify, mastodon, orbit, temporal |
| Space-Based | 4 | dragonfly, geode, ignite, infinispan |
| CQRS | 3 | CQRSlite, m-r, sample-dotnet-core-cqrs-api |
| Serverless | 3 | aws-serverless-airline-booking, azure-functions-host |
| Domain-Driven Design | 2 | IDDD_Samples, ddd-forum |

#### Heuristic said Service-Based, deep-validation disagreed (11 repos)

| Repo | Deep-Validation Style |
|------|----------------------|
| cal.com | Modular Monolith |
| directus | Plugin/Microkernel |
| discourse | Plugin/Microkernel |
| erxes | Plugin/Microkernel |
| ghostfolio | Modular Monolith |
| medusa | Modular Monolith |
| n8n | Plugin/Microkernel |
| nest | Plugin/Microkernel |
| spree | Modular Monolith |
| strapi | Plugin/Microkernel |
| supabase | Microservices |

#### Heuristic said Event-Driven, deep-validation disagreed (5 repos)

| Repo | Deep-Validation Style |
|------|----------------------|
| hazelcast | Space-Based |
| MassTransit | Indeterminate |
| aws-lambda-powertools-python | Indeterminate |
| nifi | Pipe-and-Filter |
| serverless-patterns | Indeterminate |

### Common Heuristic Failure Modes

**1. Docker/Kubernetes triggers false Microservices (21 repos)**
The single largest source of incorrect classifications. The heuristic interprets the presence of Dockerfiles, docker-compose services, Kubernetes manifests, and Helm charts as evidence of microservices architecture. In reality, many monolithic and modular systems use containers for deployment without being microservices. Examples: airflow (single app with K8s Helm chart), backstage (monorepo of in-process plugins), cockroach (single binary), consul (single binary), grafana (plugin platform).

**2. Indeterminate over-classification (116/163 = 71% of repos)**
The heuristic defaults to Indeterminate for the vast majority of repos. It lacks detection rules for 10 of 14 architecture styles: CQRS, Domain-Driven Design, Hexagonal Architecture, Layered, Modular Monolith, Multi-Agent, Pipe-and-Filter, Plugin/Microkernel, Serverless, and Space-Based. This means the heuristic is structurally unable to classify most architectural patterns.

**3. Plugin/Microkernel under-detection (0 heuristic vs 15 deep-validation)**
The heuristic has no effective rule for Plugin/Microkernel despite signal data containing `plugin_microkernel` fields (plugin dirs, plugin manifest counts, plugin loader patterns). Repos like backstage (153 plugin dirs), grafana, n8n, discourse, and strapi all have strong plugin signals that go unused.

**4. Monorepo packages misread as Service-Based (11 repos)**
The heuristic maps `monorepo_packages` and `db_config_count` signals to Service-Based, but many monorepos are actually Modular Monolith (shared deployment, internal packages) or Plugin/Microkernel (extension-based). Examples: cal.com, medusa, spree classified as Service-Based but are Modular Monolith.

**5. Event/messaging signals misread (5 repos)**
Presence of Kafka, RabbitMQ, or event schema files triggers Event-Driven classification even when the primary architecture is something else (e.g., hazelcast is Space-Based, nifi is Pipe-and-Filter).

**6. Pipeline stage signals ignored (14 Pipe-and-Filter repos missed)**
The `pipeline_stages: true` directory pattern signal exists in signal files but is not weighted strongly enough. Repos like beam, flink, spark, and envoy all had this signal but were misclassified.

## Style Distribution Comparison

| Architecture Style | Heuristic Count | Deep-Validation Count | Delta |
|-------------------|----------------|----------------------|-------|
| CQRS | 0 | 4 | +4 |
| Domain-Driven Design | 0 | 2 | +2 |
| Event-Driven | 6 | 7 | +1 |
| Hexagonal Architecture | 0 | 10 | +10 |
| Indeterminate | 116 | 24 | -92 |
| Layered | 0 | 8 | +8 |
| Microservices | 29 | 15 | +14 |
| Modular Monolith | 0 | 38 | +38 |
| Multi-Agent | 0 | 10 | +10 |
| Pipe-and-Filter | 0 | 14 | +14 |
| Plugin/Microkernel | 0 | 15 | +15 |
| Serverless | 0 | 3 | +3 |
| Service-Based | 12 | 8 | +4 |
| Space-Based | 0 | 5 | +5 |

Key observations:
- The heuristic only produces 4 of 14 possible styles (Microservices, Service-Based, Event-Driven, Indeterminate).
- Microservices is over-represented by ~2x (29 vs 15) -- the heuristic's most common false positive.
- Modular Monolith is the largest style by deep-validation (38 repos) but the heuristic detects zero.
- Plugin/Microkernel, Pipe-and-Filter, Hexagonal Architecture, and Multi-Agent each have 10-15 repos but zero heuristic detection.

## SPEC-017 Regression Resolution

SPEC-017 identified 30 repos where a previous deep-validation classification was replaced by a different heuristic or llm-review classification. SPEC-019 deep-validated all 163 repos to establish ground truth. Resolution of those 30 regressions:

| Repo | SPEC-017 Old (pre-008) | SPEC-017 New (heuristic) | SPEC-019 Deep-Validation | Resolution |
|------|----------------------|-------------------------|-------------------------|------------|
| AxonFramework | Event-Driven | Indeterminate | Indeterminate | Heuristic confirmed |
| airflow | Pipe-and-Filter | Microservices | Plugin/Microkernel | Neither correct |
| argo-workflows | Layered | Microservices | Modular Monolith | Neither correct |
| backstage | Modular Monolith | Microservices | Plugin/Microkernel | Neither correct |
| beam | Pipe-and-Filter | Microservices | Pipe-and-Filter | Old was correct |
| cal.com | Modular Monolith | Service-Based | Modular Monolith | Old was correct |
| cockroach | Layered | Microservices | Modular Monolith | Neither correct |
| conductor | Microservices | Modular Monolith | Modular Monolith | New was correct |
| consul | Modular Monolith | Microservices | Modular Monolith | Old was correct |
| dagster | Modular Monolith | Microservices | Modular Monolith | Old was correct |
| debezium | Event-Driven | Microservices | Event-Driven | Old was correct |
| discourse | Modular Monolith | Service-Based | Plugin/Microkernel | Neither correct |
| flink | Pipe-and-Filter | Microservices | Pipe-and-Filter | Old was correct |
| grafana | Modular Monolith | Microservices | Plugin/Microkernel | Neither correct |
| hazelcast | Space-Based | Event-Driven | Space-Based | Old was correct |
| istio | Service-Based | Microservices | Modular Monolith | Neither correct |
| mage-ai | Pipe-and-Filter | Microservices | Modular Monolith | Neither correct |
| mastodon | Modular Monolith | Service-Based | Service-Based | New was correct |
| medusa | Modular Monolith | Service-Based | Modular Monolith | Old was correct |
| n8n | Modular Monolith | Service-Based | Plugin/Microkernel | Neither correct |
| nhost | Microservices | Service-Based | Service-Based | New was correct |
| nifi | Pipe-and-Filter | Event-Driven | Pipe-and-Filter | Old was correct |
| openproject | Layered | Modular Monolith | Modular Monolith | New was correct |
| server | Modular Monolith | Microservices | Microservices | New was correct |
| serverless-patterns | Serverless | Event-Driven | Indeterminate | Neither correct |
| spree | Layered | Service-Based | Modular Monolith | Neither correct |
| squidex | Modular Monolith | Microservices | CQRS | Neither correct |
| strapi | Modular Monolith | Service-Based | Plugin/Microkernel | Neither correct |
| supabase | Monorepo | Service-Based | Microservices | Neither correct |
| traefik | Modular Monolith | Pipe-and-Filter | Pipe-and-Filter | New was correct |

### Regression Resolution Summary

| Outcome | Count | Repos |
|---------|-------|-------|
| Old (pre-008) was correct | 9 | beam, cal.com, consul, dagster, debezium, flink, hazelcast, medusa, nifi |
| New (SPEC-017 heuristic) was correct | 5 | conductor, mastodon, nhost, openproject, server, traefik |
| Neither old nor new was correct | 12 | airflow, argo-workflows, backstage, cockroach, discourse, grafana, istio, mage-ai, n8n, serverless-patterns, spree, squidex, strapi, supabase |
| Heuristic confirmed (Indeterminate) | 1 | AxonFramework |

Note: traefik is counted under "New was correct" (the SPEC-017 llm-review said Pipe-and-Filter, which matches deep-validation), bringing the new-correct total to 6. The table above counts 5+traefik = 6 for "new correct" and 11 for "neither correct."

## Recommendations for Heuristic Improvement

### Critical (10 missing style detectors)

1. **Add Modular Monolith detection.** This is the single most common architecture (38 repos, 23% of catalog). Key signals: single Dockerfile or deployment unit, `modules_dir: true`, large `package_json` count with shared workspace, absence of multiple `docker_compose_services`. The heuristic should check for a single deployment artifact combined with internal modular structure.

2. **Add Plugin/Microkernel detection.** 15 repos (9% of catalog). The `plugin_microkernel` signals already exist in signal files (`has_plugin_dirs`, `plugin_dir_count`, `plugin_manifests`, `plugin_loader_patterns`). A rule checking `plugin_dir_count > 5` would catch backstage (153), grafana, n8n, discourse, etc.

3. **Add Pipe-and-Filter detection.** 14 repos (9% of catalog). The `pipeline_stages: true` signal exists but is not used. Combine with presence of DAG/workflow/pipeline terminology in directory structure.

4. **Add Hexagonal Architecture detection.** 10 repos (6%). The `ports_and_adapters: true` and `clean_layers: true` directory pattern signals exist but are not utilized.

5. **Add Multi-Agent detection.** 10 repos (6%). Look for `agent` in directory names, multi-agent framework dependencies (autogen, crewai, langchain agents).

6. **Add Layered detection.** 8 repos (5%). The `layers: true` signal exists but is unused.

7. **Add Space-Based detection.** 5 repos (3%). Look for in-memory data grid dependencies (Hazelcast, Ignite, Infinispan, Geode).

8. **Add CQRS detection.** 4 repos (2%). The `cqrs_separation: true` signal exists but is not weighted.

9. **Add Serverless detection.** 3 repos (2%). IaC signals for `serverless_framework`, `sam_template`, `lambda_dirs`, `azure_functions` exist but are unused.

10. **Add Domain-Driven Design detection.** 2 repos (1%). The `ddd_tactical: true` signal exists but is unused.

### High Priority (reduce false positives)

11. **Fix Microservices over-detection.** The current rule is too aggressive. Docker/K8s presence alone should not trigger Microservices. Require: multiple independently deployable services (>1 Dockerfile in separate service directories) AND separate package manifests per service AND evidence of service-to-service communication (API gateway, gRPC, message bus). A single Dockerfile + Helm chart = deployment containerization, not microservices.

12. **Fix Service-Based over-detection.** Monorepo packages with shared deployment are more likely Modular Monolith or Plugin/Microkernel than Service-Based. Check for independent deployability before classifying as Service-Based.

### Medium Priority (improve confidence calibration)

13. **Lower confidence for ambiguous signals.** Many heuristic classifications have confidence 1.0 despite being wrong (e.g., backstage Microservices at 1.0). Confidence should reflect signal ambiguity, not just rule match strength.

14. **Add secondary style detection.** Deep-validation often identifies 2-3 styles per repo. The heuristic should output ranked alternatives rather than a single primary.

### Implementation Priority

The top 3 improvements by impact would be:
1. Modular Monolith detection -- resolves 27 Indeterminate misses + 7 Microservices false positives = **34 repos**
2. Plugin/Microkernel detection -- resolves 5 Indeterminate + 4 Microservices + 6 Service-Based = **15 repos**
3. Microservices false-positive reduction -- fixes **21 repos** currently over-classified
