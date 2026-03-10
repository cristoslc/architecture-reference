---
title: "Architecture Qualifier Annotation System"
artifact: ADR-006
status: Adopted
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

Additionally, Richards & Ford's 2nd edition (*Fundamentals of Software Architecture*, March 2025) explicitly places CQRS in the "Architectural Patterns" chapter (Ch. 20), confirming that CQRS, DDD, and Hexagonal Architecture are *patterns* (design approaches applied within a style), not *styles* (topology-defining structures). Our catalog includes all three as top-level `architecture_styles` entries — a conflation that muddies frequency analysis. SPIKE-001 showed that reference implementations massively inflate DDD (+17 pts), Hexagonal (+13.4 pts), and CQRS (+11.2 pts) — and even among production entries, mixing patterns with topologies makes the frequency tables harder to interpret.

The tension: these repos are not *incorrectly* classified — their `architecture_styles` accurately describe codebase structure. What's missing is a way to capture cross-cutting architectural concerns (distribution model, proxy topology, design approach) that coexist with the primary style but operate at a different abstraction level. A planned full re-analysis of the catalog (via the discover-architecture skill in subagents) provides a natural break point to make this correction without backward-compatibility cost.

## Decision

Add three changes to the catalog schema:

### 1. `architecture_qualifiers` field (per-entry, optional)

A list of typed qualifier objects that annotate architectural nuances orthogonal to the top-level style taxonomy:

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

Defines the canonical `architecture_styles` vocabulary — **topology-defining styles only**:

```yaml
styles:
  Layered:          { source: "Richards & Ford Ch.10" }
  Modular Monolith: { source: "Richards & Ford Ch.10" }
  Pipeline:         { source: "Richards & Ford Ch.11" }
  Microkernel:      { source: "Richards & Ford Ch.12" }
  Service-Based:    { source: "Richards & Ford Ch.13" }
  Event-Driven:     { source: "Richards & Ford Ch.14" }
  Space-Based:      { source: "Richards & Ford Ch.15" }
  Microservices:    { source: "Richards & Ford Ch.17" }
  Serverless:       { source: "Richards & Ford (implied)" }
  Multi-Agent:      { source: "Catalog addition" }
```

CQRS, DDD, and Hexagonal Architecture are **not** in this file — they are not topology-defining styles. They move to the qualifier system (see below).

### 3. Reclassify CQRS, DDD, and Hexagonal as qualifiers

Remove CQRS, Domain-Driven Design, and Hexagonal Architecture from the `architecture_styles` vocabulary. Entries currently using these values are reclassified during the next full analysis run:

- **CQRS** → `architecture_qualifiers: [{ type: data-pattern, value: cqrs }]`
- **Domain-Driven Design** → `architecture_qualifiers: [{ type: design-approach, value: ddd }]`
- **Hexagonal Architecture** → `architecture_qualifiers: [{ type: design-approach, value: hexagonal }]`

Entries that currently list only a pattern (e.g., `architecture_styles: [CQRS]`) will gain a topology-defining primary style during re-analysis. The discover-architecture skill already identifies structural topology; the current pattern-only entries exist because earlier classification methods conflated patterns with styles.

**Timing:** This reclassification happens as part of the planned full re-analysis via the discover-architecture skill (subagent/llm CLI pipeline). It is not a retroactive bulk-edit of existing entries — it is a schema change that takes effect when entries are next classified.

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

### C. Keep patterns in `architecture_styles` for backward compatibility

Retain CQRS, DDD, and Hexagonal in `architecture_styles` and flag them via `style-taxonomy.yaml` as `kind: pattern`. **Rejected** because:
- A full re-analysis is already planned — backward compatibility is not a constraint
- Keeping patterns alongside topologies muddies frequency tables (the core analytical product of the catalog)
- The `kind` flag approach adds complexity without fixing the root problem — downstream tooling would need to filter patterns out of every frequency computation

## Consequences

**Positive:**
- `architecture_styles` becomes a clean, topology-only vocabulary — frequency tables no longer conflate structural styles with design patterns
- Captures cross-cutting nuance (federation, sidecar, actor model) without fragmenting style statistics
- Queryable by category: `qualifiers[].type == 'distribution-model'` returns all distributed-system entries
- Supports ecosystem classification (EPIC-010) — `distribution-model` qualifiers naturally describe ecosystem patterns
- Aligns with Richards & Ford 2e's authoritative distinction between styles and patterns

**Negative:**
- Entries currently classified only as CQRS, DDD, or Hexagonal will need a topology-defining primary style assigned during re-analysis — some may be genuinely ambiguous
- Adds a second annotation layer to maintain alongside `architecture_styles`
- Qualifier vocabulary requires governance (controlled vocabulary, ADR amendment for new types)
- ~8-10 entries need qualifier annotations immediately; long tail requires ongoing curation

**Neutral:**
- The reclassification is absorbed into the already-planned full re-analysis — no additional bulk-edit pass required
- discover-architecture skill prompts will need updating to emit qualifiers alongside styles (one-time prompt change)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-10 | 46ab06b | From SPIKE-002 findings; taxonomy expansion gate evaluation |
