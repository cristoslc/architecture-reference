---
title: "Architecture Qualifier Annotation System"
artifact: ADR-006
status: Proposed
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
linked-epics:
  - EPIC-010
linked-specs:
  - SPEC-025
depends-on: []
evidence-pool: ""
---

# Architecture Qualifier Annotation System

## Context

SPIKE-002 investigated whether the catalog's architecture taxonomy needs expansion beyond the current 12+2 styles. Eight candidate styles were evaluated (Sidecar/Service Mesh, Federated, Data Mesh, Actor Model, Monorepo-as-Architecture, Cell-Based, Vertical Slice, Strangler Fig) against four go/no-go criteria. **No candidate met all criteria** — most critically, none reached the >=5 repo threshold for meaningful statistics.

However, the investigation identified genuine classification misfits:
- 3 federated repos (mastodon, lemmy, synapse) whose defining characteristic (federation protocol) is invisible in their current `architecture_styles`
- 2 sidecar/service-mesh repos (istio, linkerd2) whose product purpose (mesh infrastructure) isn't captured by their codebase classification
- 1 actor-model repo (orbit) classified as Pipeline despite being a virtual actor framework

Additionally, Richards & Ford's 2nd edition (*Fundamentals of Software Architecture*, March 2025) explicitly places CQRS in the "Architectural Patterns" chapter (Ch. 20), confirming that CQRS, DDD, and Hexagonal Architecture are *patterns* (design approaches applied within a style), not *styles* (topology-defining structures). Our catalog includes all three as top-level `architecture_styles` entries — a deliberate broadening that should be explicitly acknowledged.

The tension: these repos are not *incorrectly* classified — their `architecture_styles` accurately describe codebase structure. What's missing is a way to capture cross-cutting architectural concerns (distribution model, proxy topology, design approach) that coexist with the primary style but operate at a different abstraction level.

## Decision

Add two mechanisms to the catalog schema:

### 1. `architecture_qualifiers` field (per-entry, optional)

A list of typed qualifier objects that annotate architectural nuances without changing the top-level `architecture_styles` field:

```yaml
architecture_qualifiers:
  - type: distribution-model    # controlled vocabulary category
    value: federated            # controlled vocabulary value
    protocol: ActivityPub       # optional detail
    note: "Independent instances communicate via federation protocol"
```

Initial controlled vocabulary:

| `type` | Allowed `value`s | Purpose |
|--------|-----------------|---------|
| `distribution-model` | federated, cell-based, primary-secondary, peer-to-peer, sharded | How instances/nodes relate at runtime |
| `proxy-topology` | sidecar, ambient, gateway | Traffic interception/routing structure |
| `concurrency-model` | actor, csp, thread-per-request, coroutine | Primary concurrency paradigm |
| `data-pattern` | event-sourcing, cqrs, data-mesh, change-data-capture | Data management pattern within a style |
| `design-approach` | ddd, hexagonal, clean-architecture, vertical-slice | Structural design approach (pattern, not topology) |

New types require an ADR amendment or spike.

### 2. `style-taxonomy.yaml` reference file (catalog-level)

Classifies each allowed `architecture_styles` value as `kind: topology` (Richards & Ford style) or `kind: pattern` (design approach):

```yaml
styles:
  Layered:              { kind: topology, source: "Richards & Ford Ch.10" }
  Modular Monolith:     { kind: topology, source: "Richards & Ford Ch.10" }
  Pipeline:             { kind: topology, source: "Richards & Ford Ch.11" }
  Microkernel:          { kind: topology, source: "Richards & Ford Ch.12" }
  Service-Based:        { kind: topology, source: "Richards & Ford Ch.13" }
  Event-Driven:         { kind: topology, source: "Richards & Ford Ch.14" }
  Space-Based:          { kind: topology, source: "Richards & Ford Ch.15" }
  Microservices:        { kind: topology, source: "Richards & Ford Ch.17" }
  Serverless:           { kind: topology, source: "Richards & Ford (implied)" }
  Multi-Agent:          { kind: topology, source: "Catalog addition" }
  CQRS:                 { kind: pattern, source: "Richards & Ford 2e Ch.20" }
  Domain-Driven Design: { kind: pattern, source: "Evans 2003" }
  Hexagonal Architecture: { kind: pattern, source: "Cockburn 2005" }
```

## Alternatives Considered

### A. Add new top-level styles

Add Federated, Cell-Based, and/or Sidecar as first-class entries in `architecture_styles`. **Rejected** because:
- No candidate reaches >=5 repos (statistical significance threshold)
- Most candidates describe deployment/operational concerns, not codebase structure
- Fragments existing frequency tables without improving explanatory power

### B. Flat string annotation list

Use `variants: [federated, sidecar, actor]` as a flat string list. **Rejected** because:
- Ambiguous: "federated" could mean federated identity, federated data, or federated instances
- Cannot filter by category (distribution vs. concurrency vs. design approach)
- Conflates orthogonal dimensions in a single list

### C. Reclassify patterns out of `architecture_styles`

Remove CQRS, DDD, and Hexagonal from `architecture_styles` entirely and represent them only via qualifiers. **Rejected** because:
- Breaks backward compatibility for all entries using these styles
- Requires reclassifying ~50 entries (19 production + ~36 reference that use these patterns)
- The broadened definition is useful — these patterns genuinely describe architectural characteristics

## Consequences

**Positive:**
- Captures nuance without fragmenting frequency statistics
- Explicitly acknowledges the style-vs-pattern distinction per Richards & Ford 2e
- Supports ecosystem classification (EPIC-010) — `distribution-model` qualifiers naturally describe ecosystem patterns
- Backward-compatible: existing entries and queries remain valid; qualifiers are additive
- Queryable by category: `qualifiers[].type == 'distribution-model'` returns all distributed-system entries

**Negative:**
- Adds a second annotation layer to maintain alongside `architecture_styles`
- Qualifier vocabulary requires governance (controlled vocabulary, ADR amendment for new types)
- ~8-10 entries need qualifier annotations immediately; long tail requires ongoing curation

**Neutral:**
- Does not change any existing frequency table or ranking
- Does not remove CQRS/DDD/Hexagonal from `architecture_styles` — they remain for continuity but are machine-flagged as `kind: pattern`

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-10 | 46ab06b | From SPIKE-002 findings; taxonomy expansion gate evaluation |
