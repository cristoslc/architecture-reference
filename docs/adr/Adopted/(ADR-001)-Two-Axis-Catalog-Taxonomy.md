---
title: "Two-Axis Catalog Taxonomy"
artifact: ADR-001
status: Adopted
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
linked-epics:
  - EPIC-010
  - EPIC-012
linked-specs: []
linked-research:
  - SPIKE-001
---

# Two-Axis Catalog Taxonomy

## Context

The Discovered architecture catalog grew to 163 entries with no formal taxonomy. Every entry — production database, tutorial app, NuGet library — counted equally in frequency rankings. SPIKE-001 investigated how to represent ecosystem-level architectures alongside single-repo applications and discovered that the catalog's biggest statistical problem wasn't ecosystem weighting but the absence of any entry classification at all.

Three specific problems:

1. **Libraries and frameworks** (36 entries: MediatR, AxonFramework, langchain, etc.) have no deployable architecture but were counted in style frequencies, inflating styles like Plugin/Microkernel.
2. **Reference implementations** (33 entries: clean-architecture-example, spring-petclinic, etc.) are over-represented in DDD, Hexagonal, CQRS, and Microservices — the styles people write tutorials about — creating "tutorial bias" in the rankings.
3. **No distinction between platforms and applications** made it impossible to answer "what architectures do production applications use?" vs "what architectures do infrastructure platforms use?"

## Decision

Adopt a two-axis taxonomy for all catalog entries:

**Axis 1 — Scope:**
- **Platform/Ecosystem**: designed to be extended/built upon — has plugin system, API surface, connectors, or serves as infrastructure for other software (e.g., Kafka, Grafana, Strapi)
- **Application**: end-user facing, solves a specific problem (e.g., Ghostfolio, Mastodon, Zammad)

**Axis 2 — Use-type:**
- **Production-grade**: real system used in production or production-ready
- **Reference**: educational, demo, sample, template, starter kit, book companion code

**Removal category:**
- **Library/Framework**: consumed as a dependency (`import`/`require`/maven dep), not deployed standalone — remove from catalog entirely
- **Non-software**: documentation repos, archived redirects, pattern collections — remove from catalog

**Weighting rules:**
- Only production-grade entries count in frequency rankings
- Reference implementations appear as annotations (concrete examples of styles) but carry zero weight
- Equal weighting across production entries (star-based weighting tested in SPIKE-001; no scheme changes top-7 rankings)
- AOSA evidence source entries are production-grade (retrospective analyses of real systems)
- KataLog evidence source entries are reference (designed architectures)

## Alternatives Considered

1. **Flat 4-category taxonomy** (Application, Ecosystem, Library, Reference Implementation): rejected because overlapping categories created ambiguity — is ABP Framework a "Library" or an "Application"? Two orthogonal axes resolve this cleanly.

2. **Star-weighted rankings**: tested 4 schemes (equal, log10, sqrt, tier) in SPIKE-001. No style moved more than 2 rank positions under any scheme. Added complexity without changing conclusions. Equal weighting is simpler and equally accurate.

3. **Keep libraries with Indeterminate classification**: rejected because their presence inflates entry counts and some (like go-micro, protoactor-go) had non-Indeterminate styles assigned by heuristics, distorting frequency tables.

4. **Separate "Ecosystems" evidence source** (SPIKE-001 pivot recommendation): not needed since the 2-axis model handles ecosystems cleanly — ecosystem-scope entries are just another value on the scope axis, counted alongside application-scope entries without double-counting.

## Consequences

**Positive:**
- Catalog drops from 163 to ~120 architecture-relevant entries (43 removals: 36 library/framework + 7 non-software)
- Production-only rankings correct tutorial bias: DDD drops from #4 to #9, Hexagonal from #7 to #10, CQRS from #8 to #12 — these are styles people write about, not what production systems predominantly use
- Modular Monolith (59%), Event-Driven (39%), Plugin/Microkernel (31%) emerge as the dominant production patterns
- Scope axis enables separate analysis of "what platforms use" vs "what applications use"
- Clean foundation for EPIC-010 (ecosystem entries) and EPIC-012 (catalog rebalancing)

**Accepted downsides:**
- 43 entries removed — some borderline cases (5 flagged in SPIKE-001 taxonomy classification) may be debated
- Library/framework entries lose their catalog presence entirely; future scope expansion needed if library architectures become interesting
- Reference implementations lose ranking influence, which may be seen as dismissive of educational projects — mitigated by keeping them as annotation sources

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Adopted | 2026-03-06 | — | Skipped Draft/Proposed; decision fully developed in SPIKE-001 conversation |
