# Deep-Validation Verification Report

**Date:** 2026-03-06 | **Spec:** SPEC-019 | **Method:** Claude Code subagents (Opus)

## Executive Summary

Deep-context validation read the actual source code, config files, and architecture documentation of all 163 repos in the catalog. It reclassified **139 of 163 repos** (85.3%), exposing fundamental gaps in the heuristic pipeline.

The heuristic scorer operates on extracted signals (file counts, directory patterns, dependency names) without reading source code. It produces only 5 of the 14 architecture styles and relies heavily on Docker/k8s presence as a proxy for Microservices. Deep-validation, by contrast, reads Dockerfiles, module structures, plugin directories, and actual source files to understand how a system is organized -- not just what tools it uses.

| Metric | Value |
|--------|-------|
| Total repos | 163 |
| Reclassified by deep-validation | 139 (85.3%) |
| Confirmed by deep-validation | 24 (14.7%) |
| Repos with multiple styles (deep) | 111 (68.1%) |
| Avg styles per repo (deep) | 2.1 |
| Avg heuristic confidence | 0.70 |
| Avg deep-validation confidence | 0.89 |

---

## Why Did Deep-Validation Reclassify So Many Repos?

Three structural problems in the heuristic pipeline explain nearly all reclassifications:

### 1. The heuristic can only see 5 styles (but 14 exist)

The heuristic scorer has detection rules for **Microservices, Service-Based, Event-Driven, Plugin/Microkernel, and Modular Monolith** (the latter two added in SPEC-017). It has no rules at all for:

| Undetectable Style | Repos (deep) | What the heuristic called them |
|-------------------|-------------|-------------------------------|
| Pipe-and-Filter | 14 | Microservices (6), Modular Monolith (3), Service-Based (3), Event-Driven (1), Indeterminate (1) |
| Hexagonal Architecture | 10 | Modular Monolith (5), Microservices (2), Service-Based (2), Domain-Driven Design (1) |
| Multi-Agent | 10 | Modular Monolith (4), Service-Based (4), Microservices (1), Event-Driven (1) |
| Layered | 8 | Modular Monolith (3), Service-Based (2), Microservices (2), Indeterminate (1) |
| Space-Based | 5 | Event-Driven (2), Microservices (2), Modular Monolith (1) |
| CQRS | 4 | Modular Monolith (3), Microservices (1) |
| Serverless | 3 | Service-Based (1), Microservices (1), Indeterminate (1) |
| Domain-Driven Design | 2 | Modular Monolith (1), Event-Driven (1) |
| Indeterminate (libraries) | 24 | Modular Monolith (14), Event-Driven (4), Service-Based (3), Microservices (3) |

**Impact: 80 repos** are styles the heuristic structurally cannot detect. These are guaranteed misclassifications regardless of signal quality.

### 2. Docker/k8s signals are not architecture signals

The heuristic treats Dockerfiles, docker-compose services, Kubernetes manifests, and Helm charts as evidence of Microservices or Service-Based architecture. But containerization is a **deployment concern**, not an architectural one.

Deep-validation found that repos with heavy Docker/k8s signals are often:

| Actual Architecture | Example | What Docker/k8s actually means |
|--------------------|---------|---------------------------------|
| **Plugin/Microkernel** | backstage (200+ plugins), grafana, airflow | Single deployable with containerized dev environment |
| **Modular Monolith** | cockroach, consul, istio, dagster | Single binary with K8s Helm chart for deployment |
| **Pipe-and-Filter** | beam, flink, spark, prefect | Data pipeline framework with Docker for local testing |
| **Hexagonal Architecture** | Practical.CleanArchitecture | Clean-arch demo with Docker for convenience |

The heuristic scored all of these as Microservices (confidence 0.9-1.0). Deep-validation read the actual Dockerfiles and found single-binary builds, not service decomposition.

**Concrete example -- backstage:**
- Heuristic saw: 18 Dockerfiles, 7 docker-compose services, Kubernetes manifests -> Microservices (1.0)
- Deep-validation read: `plugins/` directory with 200+ in-process plugins sharing a single Node.js runtime, single `app-config.yaml`, backstage is literally a plugin platform -> **Plugin/Microkernel** (0.92)

**Concrete example -- cockroach:**
- Heuristic saw: Dockerfiles, K8s manifests, Helm charts, multiple package manifests -> Microservices (1.0)
- Deep-validation read: single `go.mod`, single binary output from `pkg/`, `kv/`, `sql/`, `storage/`, `server/` forming horizontal layers -> **Modular Monolith** (0.88)

### 3. Monorepo packages are not services

The heuristic maps the presence of `packages/` directories and multiple `package.json` files to Service-Based architecture. But most JavaScript/TypeScript monorepos use workspace packages as **shared libraries within a single deployment**, not independent services.

| Repo | Heuristic read | Deep-validation read | Actual style |
|------|---------------|---------------------|--------------|
| cal.com | 12 packages -> Service-Based (1.0) | Turborepo workspace, apps/web and apps/api share packages, single Vercel deployment | Modular Monolith |
| n8n | monorepo packages -> Service-Based (1.0) | Workflow engine with node extension system, packages/nodes-base has 300+ workflow nodes | Plugin/Microkernel |
| strapi | packages dir -> Service-Based (0.8) | Core with plugin system, packages/@strapi/plugin-*, createStrapi() kernel | Plugin/Microkernel |
| discourse | packages + plugins -> Service-Based (1.0) | Rails app with plugins/ (40+ official plugins), discourse-ai, discourse-calendar, etc. | Plugin/Microkernel |
| medusa | 15 packages -> Service-Based (0.8) | Turborepo monorepo, single medusa-core with module loader | Modular Monolith |
| directus | extensions dir -> Service-Based (0.9) | API core with extensions/, storage-driver-*, create-directus-extension tooling | Plugin/Microkernel |

Service-Based requires **independently deployable** components. Most of these repos deploy as a single unit.

---

## Style Distribution: Heuristic vs Deep-Validation

| Architecture Style | Heuristic | Deep (primary) | Deep (any position) | Delta (primary) |
|-------------------|-----------|---------------|---------------------|-----------------|
| Modular Monolith | 47 | 38 | 65 | -9 |
| Microservices | 45 | 15 | 16 | **-30** |
| Service-Based | 43 | 8 | 11 | **-35** |
| Event-Driven | 17 | 7 | 47 | -10 |
| Indeterminate | 3 | 24 | 24 | **+21** |
| Plugin/Microkernel | 2 | 15 | 33 | **+13** |
| Domain-Driven Design | 4 | 2 | 29 | -2 |
| Pipe-and-Filter | 0 | 14 | 26 | **+14** |
| Hexagonal Architecture | 0 | 10 | 20 | **+10** |
| Multi-Agent | 0 | 10 | 11 | **+10** |
| Layered | 0 | 8 | 35 | **+8** |
| Space-Based | 0 | 5 | 5 | **+5** |
| CQRS | 0 | 4 | 17 | **+4** |
| Serverless | 2 | 3 | 3 | +1 |

Key takeaways:
- **Microservices drops from 45 to 15** -- the heuristic over-classifies by 3x
- **Service-Based drops from 43 to 8** -- the heuristic over-classifies by 5.4x
- **Indeterminate rises from 3 to 24** -- many repos are libraries/frameworks/SDKs with no application architecture
- **Event-Driven appears in 47 repos** as a secondary style but only 7 as primary -- it's a pervasive cross-cutting concern, not usually the dominant pattern
- **Plugin/Microkernel, Pipe-and-Filter, Hexagonal, Multi-Agent** emerge as significant categories invisible to heuristics

---

## Top Reclassification Flows

### Microservices -> something else (30 repos reclassified away)

| New Style | Count | Example repos | Why |
|-----------|-------|---------------|-----|
| Modular Monolith | 10 | argo-workflows, cockroach, consul, istio | Single binary/deployment, K8s is for ops not arch |
| Pipe-and-Filter | 6 | beam, flink, spark, prefect, envoy | Pipeline/stream processing frameworks |
| Plugin/Microkernel | 5 | airflow, backstage, grafana, go-micro | Plugin ecosystem is the primary pattern |
| Service-Based | 4 | linkerd2, pachyderm, zadig, nhost | Distinct components but not full microservices |
| Indeterminate | 3 | aspire, eShopOnContainers, protoactor-go | Framework/library, not an application |
| Hexagonal Architecture | 1 | Practical.CleanArchitecture | Clean architecture demo |
| CQRS | 1 | squidex | CQRS is the dominant pattern |

### Service-Based -> something else (35 repos reclassified away)

| New Style | Count | Example repos | Why |
|-----------|-------|---------------|-----|
| Modular Monolith | 14 | cal.com, conductor, elasticsearch, keycloak | Shared deployment, internal modules |
| Plugin/Microkernel | 7 | directus, discourse, erxes, n8n, nest, strapi | Extension/plugin system is primary |
| Multi-Agent | 4 | AutoGPT, camel, letta, phidata | Agent coordination frameworks |
| Pipe-and-Filter | 3 | kedro, nextflow, pipeline | Workflow/pipeline orchestration |
| Layered | 2 | full-stack-fastapi-template, sample-spring-microservices-new | Traditional layered architecture |
| Microservices | 1 | supabase | Actually independently deployed |
| Hexagonal Architecture | 2 | go-clean-arch, clean-architecture-dotnet | Ports-and-adapters pattern |
| Event-Driven | 1 | livekit | Real-time media server |
| Space-Based | 1 | orbit | Virtual actor model |

### Modular Monolith -> something else (23 repos reclassified away)

| New Style | Count | Why |
|-----------|-------|-----|
| Indeterminate | 14 | Libraries/SDKs/frameworks (AxonFramework, MediatR, NServiceBus, Rebus, etc.) |
| Hexagonal Architecture | 5 | Clean architecture implementations (NorthwindTraders, domain-driven-hexagon) |
| Multi-Agent | 4 | Agent frameworks (MetaGPT, crewAI, smolagents, semantic-kernel) |
| CQRS | 3 | CQRS-first implementations (CQRSlite, m-r, EventSourcing.NetCore) |
| Pipe-and-Filter | 3 | Pipeline tools (luigi, snakemake, zuul) |
| Layered | 3 | Layered apps (spring-petclinic, maybe, outline) |

The common thread: the heuristic detected "modular structure" but couldn't distinguish between Hexagonal, CQRS, Multi-Agent, and Pipe-and-Filter -- all of which have modules.

---

## What Deep-Validation Could See That Heuristics Cannot

| Deep signal | Example | Heuristic equivalent |
|-------------|---------|---------------------|
| Plugin loader code (`PluginsService`, `registerPlugin()`) | backstage, grafana, discourse | None -- heuristic counts plugin dirs but doesn't read code |
| Single vs multiple deployment units (reading Dockerfiles) | cockroach: single binary build | Heuristic counts Dockerfiles but doesn't read them |
| Import/dependency structure (ports, adapters, use cases) | domain-driven-hexagon, go-clean-arch | Heuristic checks for `ports_and_adapters: true` directory but doesn't verify |
| Agent class hierarchies and coordination | crewAI, MetaGPT, smolagents | No heuristic signal for agent patterns |
| Pipeline stage definitions and DAG structures | airflow DAGs, flink operators, beam transforms | `pipeline_stages: true` exists but isn't weighted |
| README/docs stating the architecture | Many repos self-describe their architecture | Heuristic reads no documentation |
| Bounded context analysis in source | saleor, ddd-forum, IDDD_Samples | No heuristic signal for DDD tactical patterns in source |
| Library vs application distinction | AxonFramework, MediatR, typeorm | Heuristic can't distinguish libraries from applications |

---

## Libraries and Frameworks (Indeterminate)

Deep-validation classified 24 repos as Indeterminate. These are consistently **libraries, SDKs, or framework toolkits** that don't implement an application architecture:

| Category | Repos |
|----------|-------|
| Messaging/event frameworks | AxonFramework, MassTransit, MediatR, NServiceBus, Rebus, akka, protoactor-go |
| AI/ML SDKs | anthropic-cookbook, superagent, e2b |
| Web/API frameworks | actix, chalice, lambda-api |
| ORMs/data tools | typeorm, ehcache3, memcached |
| Templates/examples | project-layout, realworld, examples, ddd-starter-modelling-process |
| Cloud tooling | Zappa, aws-lambda-powertools-python, eShopOnContainers, aspire |
| Reference collections | serverless-patterns, kotlin-fullstack-sample |

The heuristic misclassified 21 of these 24 as having an architecture style (mostly Modular Monolith or Event-Driven). Deep-validation correctly identified them as having no classifiable application architecture.

---

## Confidence Calibration

| Confidence Range | Heuristic Count | Deep-Validation Count |
|-----------------|----------------|----------------------|
| 0.0 (Indeterminate) | 3 | 24 |
| 0.1 - 0.5 | 30 | 0 |
| 0.5 - 0.7 | 30 | 0 |
| 0.7 - 0.8 | 20 | 0 |
| 0.8 - 0.9 | 51 | 80 |
| 0.9 - 1.0 | 29 | 59 |

Deep-validation is bimodal: either 0.0 (can't classify) or 0.82-0.95 (confident classification). The heuristic spreads confidence across 0.3-1.0 with many false-high scores (backstage at 1.0 Microservices, cockroach at 1.0 Microservices).

---

## Signal File Coverage

All 163 signal files now contain both blocks for comparison:

- `classification:` -- heuristic pipeline result (styles, confidence, method)
- `deep_validation:` -- deep-context result (styles, confidence, method, summary, notes)

This enables future heuristic improvement by training against deep-validation ground truth.

---

## Recommendations by Impact

| Priority | Improvement | Repos fixed | Effort |
|----------|------------|-------------|--------|
| 1 | Add Modular Monolith scorer (single deployment + internal modules) | ~9 currently wrong | Low -- signals exist |
| 2 | Fix Microservices false positives (require multiple independent deployables) | 30 repos | Medium -- rule rewrite |
| 3 | Fix Service-Based false positives (require independent deployability) | 35 repos | Medium -- rule rewrite |
| 4 | Add Plugin/Microkernel scorer (plugin dirs + loader patterns) | 13 repos | Low -- signals exist |
| 5 | Add Pipe-and-Filter scorer (pipeline stages + DAG patterns) | 14 repos | Low -- signals exist |
| 6 | Add library/framework detector (no app architecture = Indeterminate) | 21 repos | Medium -- new heuristic |
| 7 | Add Hexagonal Architecture scorer (ports + adapters + clean layers) | 10 repos | Low -- signals exist |
| 8 | Add Multi-Agent scorer (agent dirs + framework deps) | 10 repos | Low -- new signals needed |
| 9 | Add Layered scorer (layers directory pattern) | 8 repos | Low -- signals exist |
| 10 | Add Space-Based scorer (in-memory grid deps) | 5 repos | Low -- new signals needed |
