---
title: "Catalog Rebalancing and Application Expansion"
artifact: EPIC-012
status: Active
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
parent-vision: VISION-001
success-criteria:
  - 43 library/framework and non-software entries removed from catalog
  - All remaining entries tagged with scope (platform | application) and use-type (production | reference)
  - At least 30 new production-grade application entries added (bringing applications from 19 to 49+)
  - Platform-to-application ratio moves from 3.4:1 to no worse than 2:1
  - Frequency rankings recomputed using production-only entries with equal weighting
  - Reference library documents updated to reflect production-only rankings
depends-on:
  - SPIKE-001
linked-adrs:
  - ADR-001
---

# Catalog Rebalancing and Application Expansion

## Goal / Objective

The SPIKE-001 taxonomy classification revealed a severely skewed catalog: 65 production platforms vs 19 production applications (3.4:1 ratio), plus 43 entries that don't belong (libraries, frameworks, non-software). This epic executes the ADR-001 taxonomy decision by cleaning the catalog, adding taxonomy tags, and expanding the application corpus to produce statistically meaningful production-only frequency rankings.

### The problem

The current frequency rankings reflect what's *in the catalog*, not what production systems *actually look like*. The catalog over-represents platforms (databases, brokers, CMS, workflow engines) because they're architecturally interesting and well-documented on GitHub. Applications — the systems architects are actually building — are underrepresented.

This means:
- Plugin/Microkernel at 31% is inflated by platforms (Kafka, RabbitMQ, Grafana all have plugin systems)
- Pipe-and-Filter at 26% is inflated by data processing platforms (Flink, NiFi, Airflow)
- Styles common in applications (Layered, Hexagonal, DDD) may be underrepresented

Until the catalog has a balanced mix of platforms and applications, style frequency claims are unreliable for application architects — the primary audience.

## Scope Boundaries

### In scope

1. **Catalog cleanup** — remove 43 library/framework and non-software entries identified in SPIKE-001
2. **Taxonomy tagging** — add `scope:` and `use_type:` fields to all remaining catalog YAML entries
3. **Application discovery** — find and add 30+ production-grade applications across diverse domains:
   - Underrepresented domains: healthcare, fintech, logistics, education, government
   - Application types: SaaS products, internal tools, mobile backends, API-first services
   - Selection criteria: >1k GitHub stars, active maintenance, classifiable architecture
4. **Signal extraction and classification** — run the full pipeline (extract signals, heuristic classify, LLM review, deep-validate) on new entries
5. **Frequency recomputation** — rebuild rankings using production-only entries with equal weighting per ADR-001
6. **Reference library update** — propagate corrected rankings into all reference library documents

### Out of scope

- Adding ecosystem-level entries (EPIC-010 territory)
- Changes to the classification pipeline itself (EPIC-009)
- Adding non-Discovered evidence sources
- Library/framework architecture analysis (potential future vision expansion)

## Child Specs

| ID | Title | Status | Focus |
|----|-------|--------|-------|
| [SPEC-020](../../../spec/Implemented/(SPEC-020)-Catalog-Cleanup-and-Taxonomy-Tagging/(SPEC-020)-Catalog-Cleanup-and-Taxonomy-Tagging.md) | Catalog Cleanup and Taxonomy Tagging | Implemented | Remove 43 entries, add scope/use_type fields to remaining |
| [SPEC-021](../../../spec/Draft/(SPEC-021)-Application-Discovery-and-Curation/(SPEC-021)-Application-Discovery-and-Curation.md) | Application Discovery and Curation | Draft | Find, vet, and add 30+ production applications (depends on SPEC-020) |
| [SPEC-022](../../../spec/Draft/(SPEC-022)-Pipeline-Run-and-Frequency-Recomputation/(SPEC-022)-Pipeline-Run-and-Frequency-Recomputation.md) | Pipeline Run and Frequency Recomputation | Draft | Recompute production-only rankings (depends on SPEC-020, SPEC-021) |
| [SPEC-023](../../../spec/Draft/(SPEC-023)-Reference-Library-Rebalancing-Update/(SPEC-023)-Reference-Library-Rebalancing-Update.md) | Reference Library Rebalancing Update | Draft | Update all reference docs with corrected rankings (depends on SPEC-022) |

## Key Dependencies

- **SPIKE-001** (Complete) — taxonomy decision and removal list
- **ADR-001** (Adopted) — two-axis taxonomy model, production-only weighting rule
- **EPIC-010** (Proposed) — ecosystem entries are additive on top of this epic's rebalanced catalog

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-06 | 054dab0 | Catalog skew identified in SPIKE-001; 65 platforms vs 19 applications |
| Active | 2026-03-06 | 23bed6f | SPIKE-001 dependency satisfied; child specs SPEC-020 through SPEC-023 created |
