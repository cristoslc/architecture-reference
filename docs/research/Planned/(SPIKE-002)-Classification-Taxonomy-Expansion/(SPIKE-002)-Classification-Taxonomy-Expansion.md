---
title: "Classification Taxonomy Expansion"
artifact: SPIKE-002
status: Planned
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
question: "Do we need architectural classifications beyond the classic 12 styles from Richards & Ford, and if so, which ones have sufficient evidence to justify addition?"
gate: "Pre-implementation gate for EPIC-010 — taxonomy changes affect deep-validation prompts and reference library structure"
risks-addressed:
  - "Current 12+2 taxonomy may force repos into ill-fitting categories"
  - "Missing classifications could mask real patterns in the evidence"
  - "Adding too many classifications fragments the data and reduces statistical power"
depends-on:
  - SPEC-019
linked-research:
  - EPIC-010
---

# Classification Taxonomy Expansion

## Question

Do we need architectural classifications beyond the classic 12 styles from Richards & Ford, and if so, which ones have sufficient evidence to justify addition?

### Current taxonomy (14 styles)

The catalog currently uses 12 styles from *Fundamentals of Software Architecture* (Richards & Ford 2020) plus 2 additions:

| Style | Source | Discovered Count |
|-------|--------|-----------------|
| Layered | Richards & Ford | 35 |
| Modular Monolith | Richards & Ford | 65 |
| Microservices | Richards & Ford | 16 |
| Service-Based | Richards & Ford | 11 |
| Event-Driven | Richards & Ford | 47 |
| Space-Based | Richards & Ford | 5 |
| Pipeline (Pipe-and-Filter) | Richards & Ford | 26 |
| Microkernel (Plugin) | Richards & Ford | 33 |
| Serverless | Richards & Ford (implied) | 3 |
| CQRS | Richards & Ford (pattern) | 17 |
| Domain-Driven Design | Evans 2003 / tactical patterns | 29 |
| Hexagonal Architecture | Cockburn 2005 / Clean Architecture | 20 |
| **Multi-Agent** | Added for AI/ML repos | 11 |
| **Indeterminate** | Meta-classification for libraries | 24 |

### Candidate additions observed in deep-validation

SPEC-019's deep-validation notes revealed patterns that don't cleanly map to existing styles:

| Candidate | Evidence | Currently classified as | Distinct because |
|-----------|----------|------------------------|-----------------|
| **Sidecar / Service Mesh** | istio+envoy, linkerd2, dapr | Modular Monolith or Microservices | The sidecar is the architecture — it's not just a deployment pattern. Control plane + data plane is a first-class architectural split. |
| **Federated** | mastodon (ActivityPub), discourse, forem | Service-Based or Modular Monolith | Independent instances communicating via federation protocol. Different from Service-Based (not centrally deployed). |
| **Data Mesh / Lakehouse** | pachyderm, dbt-core, iceberg (missing) | Service-Based or Pipe-and-Filter | Domain-oriented data ownership with self-serve infrastructure. Emerging architectural style with growing adoption. |
| **Actor Model** | akka, protoactor-go, orbit | Indeterminate or Space-Based | Message-passing concurrency as the primary architectural principle. Currently forced into Space-Based or Indeterminate. |
| **Monorepo-as-Architecture** | cal.com, n8n, supabase | Modular Monolith or Microservices | Turborepo/Nx workspace with shared packages — architecturally distinct from traditional monolith or microservices. |
| **Cell-Based** | cockroach, redpanda | Modular Monolith | Autonomous units that replicate the full stack. Emerging pattern for distributed systems. |
| **Vertical Slice** | some .NET repos | Hexagonal or Layered | Feature-based organization cutting across layers. Orthogonal to Hexagonal/Layered. |
| **Strangler Fig** | — | — | Migration pattern. Arguably not a steady-state architecture. |

### The tension

- **Too few styles** forces repos into ill-fitting categories (akka as "Indeterminate", istio as "Modular Monolith")
- **Too many styles** fragments the data — a style with 3 repos has no statistical power
- **Mixed abstraction levels** — some candidates are deployment patterns (Sidecar), some are data patterns (Data Mesh), some are organizational patterns (Vertical Slice)

## Go / No-Go Criteria

| Criterion | Threshold | Measurement |
|-----------|-----------|-------------|
| Candidate has >= 5 repos in current or expanded catalog | Minimum population for meaningful statistics | Count repos that would be reclassified to the new style |
| Candidate is distinguishable from existing styles | Clear definition that doesn't overlap with an existing style | Write a 2-sentence differentiator; test on 10 ambiguous repos |
| Candidate represents a *structural* architecture, not just a pattern or practice | Must describe how components are organized and communicate | Apply Richards & Ford's "architecture style vs. pattern" test |
| Adding the style doesn't reduce clarity of existing frequency tables | Existing style counts don't fragment below 3 repos | Re-run frequency analysis with candidate style added |

## Pivot Recommendation

If no candidate meets all criteria, keep the current 14-style taxonomy but:
1. Add a "sub-style" or "variant" annotation system (e.g., Microservices:Sidecar, Modular Monolith:Cell-Based) that captures nuance without fragmenting the top-level statistics
2. Document the rejected candidates and why in an ADR, so the decision is explicit and revisitable

## Investigation Threads

### Thread 1: Audit current misfit classifications

Review SPEC-019 deep-validation notes for all 163 repos. Flag entries where the reviewer expressed uncertainty or noted the classification was a poor fit. Cluster these into candidate styles.

### Thread 2: Literature survey

Check whether Richards & Ford's 2nd edition (if available), Gregor Hohpe's *Enterprise Integration Patterns*, Martin Fowler's architecture blog, and CNCF landscape docs define any styles we're missing. Particular focus on:
- Sidecar/Service Mesh (CNCF)
- Data Mesh (Dehghani 2022)
- Cell-Based (WSO2)
- Actor Model (Hewitt 1973, Akka docs)

### Thread 3: Reclassification simulation

Take the top 3 candidates. For each, define the style, identify which repos would reclassify, and re-run the frequency analysis. Compare the resulting frequency table with the current one. Key question: does adding the style improve or degrade the explanatory power of the taxonomy?

### Thread 4: Sub-style annotation alternative

Design a lightweight annotation system (e.g., `styles: [Microservices]` + `variants: [sidecar-proxy]`) that captures nuance without changing the top-level taxonomy. Evaluate whether this satisfies the same needs as adding a new style.

## Findings

*(Populated during Active phase.)*

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-06 | c526f34 | Initial creation; pre-implementation gate for EPIC-010 taxonomy decisions |
