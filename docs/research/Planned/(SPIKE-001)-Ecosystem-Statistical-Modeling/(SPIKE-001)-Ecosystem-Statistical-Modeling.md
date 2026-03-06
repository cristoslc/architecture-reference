---
title: "Ecosystem Statistical Modeling"
artifact: SPIKE-001
status: Planned
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
question: "How should the reference library's statistical model represent and weight ecosystem-level architectures (multi-repo platforms) vs. single-repo applications, and how do ecosystem entries affect style frequency rankings?"
gate: "Pre-implementation gate for EPIC-010 — must resolve before adding ecosystem entries to the catalog"
risks-addressed:
  - "Ecosystem entries may double-count styles already represented by member repos"
  - "Weighting ecosystems equally with single repos could skew frequency rankings"
  - "The distinction between 'ecosystem' and 'collection of related tools' is subjective"
depends-on:
  - EPIC-010
linked-research:
  - EPIC-010
---

# Ecosystem Statistical Modeling

## Question

How should the reference library's statistical model represent and weight ecosystem-level architectures (multi-repo platforms) vs. single-repo applications, and how do ecosystem entries affect style frequency rankings?

The current catalog treats every entry equally — elasticsearch counts the same as a small CQRS demo app. Adding ecosystem entries (ELK stack, *arr stack, Grafana LGTM) raises several modeling questions:

1. **Double-counting.** If elasticsearch is classified as Modular Monolith + Plugin and the ELK ecosystem is classified as Pipe-and-Filter, do we count both? The Pipe-and-Filter count goes up, but elasticsearch's individual styles still count too. Is this additive or should ecosystem membership suppress individual counting?

2. **Weighting.** Should an ecosystem entry carry more weight than a single-repo entry? The ELK stack represents far more real-world deployment than a sample CQRS app. Options:
   - Equal weight (simplest — 1 entry = 1 entry)
   - Star-weighted (sum of member repo stars)
   - Deployment-weighted (ecosystem = N where N is member count)
   - Tiered (ecosystem, production app, reference implementation, library)

3. **Entry taxonomy.** What *kinds* of entries should the catalog distinguish?
   - **Application**: single deployable with classifiable architecture (backstage, grafana, saleor)
   - **Ecosystem/Platform**: multi-repo composition with emergent architecture (ELK, *arr, Grafana LGTM)
   - **Library/Framework**: no application architecture, Indeterminate (AxonFramework, MediatR, typeorm)
   - **Reference Implementation**: educational, demonstrates a pattern (clean-architecture-example, ddd-forum)

4. **Frequency reporting.** How do the reference library documents present ecosystem data?
   - Separate "Ecosystem Frequency" table alongside "Repo Frequency"?
   - Combined table with a source column?
   - Ecosystem entries flagged in existing tables?

5. **Cross-source interaction.** KataLog teams propose architectures for challenges — these are "designed ecosystems." How do we compare designed ecosystems (KataLog) with observed ecosystems (Discovered)?

## Go / No-Go Criteria

| Criterion | Threshold | Measurement |
|-----------|-----------|-------------|
| Taxonomy is well-defined | Entry types have clear, non-overlapping definitions with >=90% agreement on test set | Classify 20 sample entries using proposed taxonomy; measure inter-rater agreement |
| Double-counting impact quantified | Understand how many style counts change and by how much under each weighting scheme | Run 3 weighting schemes against current catalog + 10 candidate ecosystems; compare frequency tables |
| Frequency table format validated | Proposed format is readable and non-misleading | Review with user; format must be unambiguous about what is being counted |

## Pivot Recommendation

If no clean taxonomy emerges, fall back to a simpler approach: add ecosystem entries as a separate "Ecosystems" evidence source (like KataLog, AOSA, etc.) with its own column in the Combined Weighted Scoreboard. This avoids contaminating the Discovered repo-level statistics while still capturing ecosystem evidence.

## Investigation Threads

### Thread 1: Taxonomy Definition

Classify all 163 current catalog entries into proposed categories (Application, Library/Framework, Reference Implementation). This establishes the baseline before adding ecosystems.

Current data:
- 24 repos already classified as Indeterminate — most are libraries/frameworks
- Unknown number of "reference implementations" (clean-architecture-example, ddd-forum, etc.) currently counted equally with production applications

### Thread 2: Weighting Simulation

Take 10 candidate ecosystems from EPIC-010's audit. For each weighting scheme, compute the resulting frequency table and compare with the current table. Key metrics:
- Which styles move more than 2 rank positions?
- Does any style's percentage change by more than 5 points?
- Does the ranking become more or less consistent with other evidence sources (KataLog, AOSA)?

### Thread 3: Presentation Format

Draft 2-3 candidate formats for how ecosystem data appears in reference library documents. Test each for:
- Clarity (can a reader understand what's being counted?)
- Comparability (can you compare Discovered ecosystems with KataLog designed architectures?)
- Actionability (does the data help an architect make decisions?)

## Findings

*(Populated during Active phase.)*

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-06 | c526f34 | Initial creation; pre-implementation gate for EPIC-010 |
