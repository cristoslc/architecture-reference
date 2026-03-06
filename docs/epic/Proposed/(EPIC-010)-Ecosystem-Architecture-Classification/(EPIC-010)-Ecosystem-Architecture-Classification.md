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

### Known ecosystem gaps

| Ecosystem | Member Repos | Individual Classifications | Emergent Architecture |
|-----------|-------------|--------------------------|----------------------|
| **\*arr media stack** | Sonarr, Radarr, Bazarr, Prowlarr, Lidarr, Readarr, Overseerr | Each: Layered/Modular Monolith | Service-Based with shared API contracts + event flows |
| **ELK stack** | Elasticsearch, Logstash, Kibana, Beats, APM Server | Each: Modular Monolith/Plugin | Pipe-and-Filter data pipeline |
| **Grafana LGTM** | Grafana, Loki, Tempo, Mimir, Prometheus | Each: Plugin/Modular Monolith | Service-Based observability stack |
| **HashiCorp stack** | Consul, Vault, Nomad, Terraform, Waypoint | Each: Modular Monolith | Service-Based infrastructure platform |
| **Kubernetes ecosystem** | kubernetes, etcd, CoreDNS, containerd, kube-proxy | Each: various | Microservices with sidecar pattern |
| **Spring Cloud** | spring-cloud-gateway, eureka, spring-cloud-config | Each: various | Microservices infrastructure |
| **Apache data stack** | Kafka, Flink, Spark, Airflow, Beam | Each: various | Pipe-and-Filter / Event-Driven data mesh |
| **Home automation** | Home Assistant, ESPHome, Zigbee2MQTT, Node-RED | Each: Plugin/Event-Driven | Event-Driven + Plugin/Microkernel IoT platform |

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
