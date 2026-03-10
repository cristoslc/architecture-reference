---
title: "Classification Taxonomy Expansion"
artifact: SPIKE-002
status: Complete
author: cristos
created: 2026-03-06
last-updated: 2026-03-10
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

### Thread 1: Misfit Classification Audit (2026-03-10)

Audited all 8 candidate styles against the current 184-entry catalog. For each candidate, examined the YAML catalog entries of repos identified as potential misfits, reviewed classification reasoning and review notes, and assessed whether the current classification is genuinely poor or acceptable.

| Candidate | Repos Examined | Genuine Misfits | Reclassification Count | Meets >=5? |
|-----------|---------------|-----------------|----------------------|-----------|
| Sidecar / Service Mesh | 4 (istio, envoy, linkerd2, dapr) | 2 (istio, linkerd2) | 2 | NO |
| Federated | 5 (mastodon, discourse, forem, lemmy, synapse) | 3 (mastodon, lemmy, synapse) | 3 | NO |
| Data Mesh / Lakehouse | 2 (pachyderm, dbt-core) | 0 | 0 | NO |
| Actor Model | 1 in catalog (orbit); akka, protoactor-go absent | 1 (orbit) | 1 | NO |
| Monorepo-as-Architecture | 3 (cal.com, n8n, supabase) | 0 | 0 | NO |
| Cell-Based | 2 (cockroach, redpanda) | 0 (borderline) | 0 | NO |
| Vertical Slice | 1 (vertical-slice-api-template) | 1 | 1 | NO |
| Strangler Fig | 0 | 0 | 0 | NO |

**Key corrections to the spike's original candidate lists:**
- Discourse and forem are **not** federated systems — they lack ActivityPub or any federation protocol. Removed from Federated candidate list.
- Lemmy and synapse (not in the original spike list) **are** genuinely federated and genuinely misfit. Added to Federated candidate list.
- Envoy and dapr have **acceptable** classifications — their codebases genuinely are Microkernel. The sidecar deployment model doesn't change how the code is structured.

**Three candidates show real signal but insufficient count:** Federated (3), Sidecar (2), Actor Model (1 + 2 absent from catalog). These are the strongest candidates for the sub-style annotation pivot.

**Three candidates are not architectural styles:** Data Mesh (organizational paradigm), Monorepo-as-Architecture (tooling choice), Strangler Fig (migration pattern). Rejected outright.

**Cell-Based and Vertical Slice are orthogonal dimensions** — deployment topology and feature organization respectively, not component communication topology.

### Thread 2: Literature Survey (2026-03-10)

Surveyed Richards & Ford 2nd edition (March 2025), Microsoft Azure Architecture Center, CNCF Cloud Native Architecture, Zhamak Dehghani's *Data Mesh* (2022), WSO2 cell-based reference architecture, Hewitt's Actor Model (1973), Jimmy Bogard's Vertical Slice Architecture, and federated architecture literature.

| Candidate | Classification per Literature | Add as Style? | Key Source |
|-----------|------------------------------|--------------|------------|
| Sidecar / Service Mesh | Deployment pattern | No | Microsoft Azure: "Sidecar Pattern" (design pattern catalog) |
| Federated | Enterprise architecture pattern | Borderline | Wikipedia: "pattern in enterprise architecture"; overlaps Service-Based |
| Data Mesh | Sociotechnical paradigm | No | Dehghani: "decentralized sociotechnical approach" |
| Cell-Based | Emerging architecture style | Strongest candidate | WSO2, CNCF, Adobe case study; distinct cell+gateway topology |
| Actor Model | Concurrency/computation model | No | Hewitt 1973; Akka docs call it "abstraction layer" |
| Vertical Slice | Code organization pattern | No | Bogard: internal folder structure, not deployment topology |

**Critical finding: Richards & Ford 2nd edition (March 2025)**
- Only new architecture **style** chapter added: Modular Monolith (already in our taxonomy).
- **CQRS is explicitly placed in Chapter 20 ("Architectural Patterns")**, not in Part II ("Architecture Styles"). This confirms CQRS is a *pattern* in the authoritative taxonomy.
- By extension, DDD (Evans 2003) and Hexagonal Architecture (Cockburn 2005) are also design approaches/patterns, not topology-defining styles.
- Our catalog intentionally broadens the "style" definition to include these — which is fine as long as it's explicitly acknowledged. The sub-style annotation system addresses this by distinguishing `kind: topology` from `kind: pattern` in a style taxonomy reference file.

### Thread 3: Reclassification Simulation (2026-03-10)

Simulated reclassification for the top 3 candidates (Cell-Based, Federated, Sidecar) against the 184-entry catalog.

| Candidate | Repos that would reclassify | Gate: >=5 repos | Gate: Distinguishable | Gate: Structural | Gate: No fragmentation | Verdict |
|-----------|----------------------------|----------------|----------------------|-----------------|----------------------|---------|
| Cell-Based | 0 | FAIL | PASS | PASS | PASS | **NO-GO** |
| Federated | 3 (mastodon, lemmy, synapse) | FAIL (3/5) | PASS | BORDERLINE | PASS | **NO-GO** |
| Sidecar / Service Mesh | 0-1 (only istio is arguable) | FAIL | PASS | FAIL | PASS | **NO-GO** |

**Key insight across all three:** These candidates describe **what the system does or how it is deployed**, not **how its codebase is structurally organized**. The catalog classifies codebase architecture — and the existing taxonomy accurately captures the internal code organization of these repos:
- Istio's codebase IS a Modular Monolith (single Istiod binary)
- Linkerd2's codebase IS Microservices (independent Go services)
- Mastodon's codebase IS Layered (Rails MVC)
- CockroachDB's codebase IS Layered + Modular Monolith (SQL -> KV -> Storage layers)

The misfits are not wrong classifications — they're incomplete descriptions. The existing style captures the code structure; what's missing is the cross-cutting concern (federation protocol, sidecar topology, cell replication). This is precisely what annotations are designed for.

### Thread 4: Sub-Style Annotation Design (2026-03-10)

Designed a two-part annotation system that captures architectural nuance without changing the top-level taxonomy:

**Part A: `architecture_qualifiers` field** (per-entry, optional)

```yaml
architecture_qualifiers:           # optional list of typed qualifier objects
  - type: distribution-model       # controlled vocabulary category
    value: federated               # controlled vocabulary value
    protocol: ActivityPub          # optional protocol/implementation detail
    note: "Independent instances communicate via federation"  # optional
```

Five qualifier types (initial controlled vocabulary):

| `type` | Allowed `value`s | What it captures |
|--------|-----------------|------------------|
| `distribution-model` | federated, cell-based, primary-secondary, peer-to-peer, sharded | How instances/nodes relate at runtime |
| `proxy-topology` | sidecar, ambient, gateway | Traffic interception/routing structure |
| `concurrency-model` | actor, csp, thread-per-request, coroutine | Primary concurrency paradigm |
| `data-pattern` | event-sourcing, cqrs, data-mesh, change-data-capture | Data management pattern within a style |
| `design-approach` | ddd, hexagonal, clean-architecture, vertical-slice | Structural design approach (pattern, not topology) |

**Part B: `style-taxonomy.yaml` reference file** (catalog-level, not per-entry)

Classifies each allowed `architecture_styles` value as `kind: topology` (Richards & Ford style) or `kind: pattern` (design approach within a style):

```yaml
styles:
  Layered:              { kind: topology, source: "Richards & Ford Ch.10" }
  Modular Monolith:     { kind: topology, source: "Richards & Ford Ch.10" }
  Microservices:        { kind: topology, source: "Richards & Ford Ch.17" }
  # ... (9 topology-defining styles)
  CQRS:                 { kind: pattern, source: "Richards & Ford 2e Ch.20" }
  Domain-Driven Design: { kind: pattern, source: "Evans 2003" }
  Hexagonal Architecture: { kind: pattern, source: "Cockburn 2005" }
```

**Evaluation:** The annotation system satisfies the same analytical needs as new top-level styles:
- Captures Federated (mastodon, lemmy, synapse) via `distribution-model: federated`
- Captures Sidecar (istio, linkerd2) via `proxy-topology: sidecar`
- Distinguishes style vs pattern for CQRS/DDD/Hexagonal via `style-taxonomy.yaml`
- Preserves all existing frequency tables — `architecture_styles` field is unchanged
- Fully backward-compatible — new field is optional

### Gate Evaluation (2026-03-10)

| Criterion | Threshold | Result | Verdict |
|-----------|-----------|--------|---------|
| Candidate has >= 5 repos | Minimum population | No candidate reaches 5: Federated (3), Sidecar (2), Cell-Based (0), Actor (1), others (0) | **FAIL — no new top-level style justified** |
| Candidate is distinguishable | 2-sentence differentiator | Cell-Based and Federated pass; Sidecar borderline; others fail (patterns, not styles) | PARTIAL |
| Candidate is structural | Architecture style vs pattern test | Only Cell-Based fully passes; Federated borderline; all others are patterns/deployment/organizational | PARTIAL |
| No fragmentation | Existing counts stay >= 3 | All candidates pass — no existing style would drop below 3 | PASS |

**Spike outcome: PIVOT.** No candidate meets all four gate criteria. Per the pre-defined pivot recommendation:

1. **Keep the current taxonomy** — 10 topology-defining styles + 3 design-approach patterns (CQRS, DDD, Hexagonal) + Multi-Agent
2. **Add `architecture_qualifiers` field** to the catalog schema — typed annotations capturing distribution model, proxy topology, concurrency model, data patterns, and design approaches
3. **Add `style-taxonomy.yaml` reference file** — distinguishes topology-defining styles from design-approach patterns per Richards & Ford 2nd edition
4. **Document the decision in an ADR** — rejected candidates, rationale, and the annotation system design

### Implications for EPIC-010

EPIC-010 can proceed with the **existing taxonomy unchanged**. The annotation system is additive and can be implemented alongside ecosystem catalog entries. Specifically:

- Ecosystem entries (ELK stack, *arr stack, Grafana LGTM) will use existing `architecture_styles` for their emergent architecture classification
- `architecture_qualifiers` provides a natural place to annotate ecosystem-specific patterns (e.g., `distribution-model: federated` for fediverse ecosystems, `proxy-topology: sidecar` for service mesh ecosystems)
- No taxonomy expansion is needed before ecosystem curation begins

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-06 | c526f34 | Initial creation; pre-implementation gate for EPIC-010 taxonomy decisions |
