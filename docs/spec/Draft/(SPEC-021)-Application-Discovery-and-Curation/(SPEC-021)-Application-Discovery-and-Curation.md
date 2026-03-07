---
title: "Catalog Expansion and Ecosystem Completion"
artifact: SPEC-021
status: Draft
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-epic: EPIC-012
depends-on:
  - SPEC-020
linked-adrs:
  - ADR-001
execution-tracking: required
---

# Catalog Expansion and Ecosystem Completion

## Problem Statement

After SPEC-020 cleanup, the catalog has three gaps:

1. **Application skew** — 67 production platforms vs 21 production applications (3.2:1 ratio). Frequency rankings disproportionately reflect platform architectures (Plugin/Microkernel, Pipe-and-Filter) rather than application architectures — but application architects are the primary audience.

2. **Incomplete ecosystems** — Several platforms are cataloged in isolation when they belong to multi-repo ecosystems. We have `elasticsearch` but not Kibana/Logstash/Beats. We have `consul` but not Vault/Nomad. We have `kafka` but not Connect/ksqlDB/Schema Registry. Incomplete ecosystem coverage understates Service-Based and Event-Driven patterns.

3. **Uncataloged manifest repos** — 20 repos in `manifest.yaml` were never successfully processed by the pipeline. Some are libraries (will be triaged out per ADR-001), but others are legitimate platforms or reference apps.

## External Behavior

**Three input streams:**

| Stream | Source | Expected yield |
|--------|--------|---------------|
| New applications | GitHub search, awesome-lists, domain-specific directories | 30+ production applications |
| Ecosystem completion | Companion repos for partially-cataloged ecosystems | 15–25 platform components |
| Uncataloged manifest repos | 20 entries in `manifest.yaml` with no catalog entry | 10–15 after triage |

**Known ecosystem gaps:**

| Ecosystem | Have | Missing |
|-----------|------|---------|
| Elastic Stack | elasticsearch | kibana, logstash, beats |
| Arr Stack | overseerr | sonarr, radarr, prowlarr, bazarr |
| Sentry | self-hosted | sentry (backend), snuba, relay |
| Kafka ecosystem | kafka | kafka-connect, ksqldb, schema-registry |
| HashiCorp | consul | vault, nomad, terraform |
| Supabase | supabase | gotrue, postgrest, realtime, storage-api |

**Outputs:**

| Output | Description |
|--------|-------------|
| 50+ new manifest entries | Added to `manifest.yaml` with repo URLs |
| 50+ new catalog entries | YAML files in `docs/catalog/` with taxonomy tags |
| 50+ signal files | Extracted via `extract-signals.sh` |
| 50+ classifications | Heuristic + LLM review + deep-validation |
| Discovery log | Rationale for inclusion/exclusion of candidate repos |

**Selection criteria (new applications):**
- >1k GitHub stars (ensures active community and enough code to classify)
- Active maintenance (commits within last 12 months)
- Classifiable architecture (not a CLI tool, browser extension, or static site)
- Scope = application (end-user facing, not infrastructure)
- Domain diversity (target underrepresented: healthcare, fintech, logistics, education, government, productivity)

**Selection criteria (ecosystem completion):**
- Companion repo to an already-cataloged platform
- Independently deployable (not a shared library consumed only by the parent)
- Has its own identifiable architecture (not a thin wrapper or config repo)

## Acceptance Criteria

1. At least 30 new production-grade application entries added to catalog
2. Platform-to-application ratio no worse than 2:1 after all additions
3. At least 5 domains represented among new application entries
4. All 6 identified ecosystem gaps addressed (companion repos added or documented as out-of-scope)
5. All 20 uncataloged manifest repos triaged (cataloged, removed, or documented as unprocessable)
6. All new entries have full pipeline classification (signals + heuristic + LLM review + deep-validation)
7. All new entries tagged with `scope` and `use_type` per ADR-001
8. Discovery log documents why each candidate was included or rejected

## Implementation Approach

1. **Ecosystem completion** — add companion repos for the 6 identified ecosystem gaps to manifest
2. **Uncataloged manifest triage** — attempt pipeline on 20 uncataloged repos; triage failures per ADR-001
3. **Application discovery** — search GitHub for production applications in underrepresented domains
4. Filter new application candidates by selection criteria
5. Add all new repos to manifest.yaml
6. Run full pipeline: clone → extract signals → heuristic classify → LLM review → deep-validate
7. Review classifications and tag taxonomy fields
8. Document discovery rationale

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-06 | 23bed6f | Initial creation |
