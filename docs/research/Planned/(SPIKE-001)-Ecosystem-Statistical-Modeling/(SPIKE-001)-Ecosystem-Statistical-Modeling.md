---
title: "Ecosystem Statistical Modeling"
artifact: SPIKE-001
status: Planned
author: cristos
created: 2026-03-06
last-updated: 2026-03-06
question: "How should the reference library's statistical model weight production-grade vs. reference entries, and how should ecosystem-scope entries coexist with application-scope entries in frequency rankings?"
gate: "Pre-implementation gate for EPIC-010 — must resolve weighting model and validate taxonomy before adding ecosystem entries to the catalog"
risks-addressed:
  - "Ecosystem entries may double-count styles already represented by member repos"
  - "Star-based weighting may over-represent popular ecosystems at the expense of architectural diversity"
  - "Library/Framework entries currently in catalog have no deployable architecture and must be removed"
depends-on:
  - EPIC-010
linked-research:
  - EPIC-010
---

# Ecosystem Statistical Modeling

## Question

How should the reference library's statistical model weight production-grade vs. reference entries, and how should ecosystem-scope entries coexist with application-scope entries in frequency rankings?

The catalog needs a 2-axis taxonomy:

| | Production-grade | Reference |
|---|---|---|
| **Platform/Ecosystem** | ELK stack, Grafana LGTM, *arr stack | KataLog ecosystem proposals |
| **Application** | Backstage, Grafana, Saleor | clean-architecture-example, ddd-forum |

This taxonomy resolves several previously-open questions:

1. **Double-counting (resolved).** Ecosystem-scope entries (ELK) and their application-scope members (Elasticsearch) are at different scopes. Both count — no double-counting within a scope.

2. **Weighting (partially resolved).** Only production-grade entries carry weight in frequency rankings. Reference implementations are annotation-only — they provide explanatory examples but don't count toward style frequencies. The remaining question: should production-grade weighting be a function of GitHub stars? And if so, what function?

3. **Entry taxonomy (resolved).** Two orthogonal axes — scope (platform/ecosystem | application) and use-type (production-grade | reference). Library/Framework entries have no deployable architecture and should be removed from the catalog entirely.

4. **Frequency reporting (deferred).** Scope axis drives table structure (platform vs application rows), use-type drives emphasis (lead with production-grade). Exact format is out of scope — belongs to the epic doing the actual reference library rewrite.

5. **Cross-source interaction (partially resolved).** AOSA entries describe production systems → production-grade. KataLog entries are designed architectures → reference. Each evidence source maps naturally onto the use-type axis.

## Go / No-Go Criteria

| Criterion | Threshold | Measurement |
|-----------|-----------|-------------|
| Taxonomy validated | 2-axis classification (scope × use-type) produces unambiguous assignment for >=95% of catalog entries | Classify all 163 entries; flag ambiguous cases |
| Star-weighting model defined | A weighting function of GitHub stars is proposed and tested | Compare unweighted vs star-weighted frequency tables; validate that weighting improves consistency with cross-source evidence |
| Library/Framework entries identified | Complete list of entries to remove from catalog | Classify current Indeterminate entries + scan for misclassified libraries |

## Pivot Recommendation

If star-based weighting proves distortive (e.g., a single mega-repo dominates rankings), fall back to equal weighting within the production-grade tier. The taxonomy and scope decisions stand regardless of weighting outcome.

## Investigation Threads

### Thread 1: 2-Axis Catalog Classification

Classify all 163 current catalog entries on both axes:
- **Scope:** platform/ecosystem | application
- **Use-type:** production-grade | reference

Identify Library/Framework entries (no deployable architecture) for removal. Current data:
- 24 repos already classified as Indeterminate — most are likely libraries/frameworks
- Unknown number of "reference implementations" (clean-architecture-example, ddd-forum, etc.) currently counted equally with production applications

Output: complete classification spreadsheet with per-entry rationale, plus a removal list for library/framework entries.

### Thread 2: Star-Weighted Production Ranking

Design and test a weighting function based on GitHub stars for production-grade entries. Key questions:
- What function? Linear stars, log(stars), star tiers, or normalized percentiles?
- Does star-weighting improve or degrade consistency with KataLog/AOSA rankings?
- Does any single mega-repo (e.g., tensorflow, kubernetes) distort the rankings?

Reference entries carry zero weight in frequency rankings — they appear as annotations only.

Compare: unweighted (1 entry = 1 entry) vs star-weighted frequency tables. Key metrics:
- Which styles move more than 2 rank positions?
- Does any style's percentage change by more than 5 points?

## Findings

### Resolved (pre-Active)

**Taxonomy model decided (2026-03-06).** Two orthogonal axes replace the original flat 4-category proposal:
- **Scope axis:** platform/ecosystem | application
- **Use-type axis:** production-grade | reference

Key decisions:
- **Production-grade entries carry all weight** in frequency rankings. Reference implementations are annotation-only — they explain patterns but don't count toward frequencies.
- **Library/Framework entries are out of scope** for the architecture catalog (no deployable architecture). They should be removed from the catalog. This may warrant a VISION-001 non-goal clarification.
- **Double-counting is a non-issue** under this model. Ecosystem-scope and application-scope entries are at different scopes; both count without overlap.
- **AOSA entries are production-grade** (they describe real production systems) and may additionally serve as annotation sources.
- **KataLog entries are reference** (designed architectures, not production deployments).
- **Presentation format** for reference library documents is deferred — belongs to the epic doing the actual rewrite, not to this spike.

### Open (for Active phase)

- Star-based weighting function for production-grade entries (Thread 2)
- Complete 2-axis classification of all 163 entries (Thread 1)

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Planned | 2026-03-06 | c526f34 | Initial creation; pre-implementation gate for EPIC-010 |
