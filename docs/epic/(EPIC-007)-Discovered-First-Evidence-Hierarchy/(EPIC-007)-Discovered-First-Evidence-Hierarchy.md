---
title: "Discovered-First Evidence Hierarchy"
artifact: EPIC-007
status: Complete
author: cristos
created: 2026-03-05
last-updated: 2026-03-05
parent-vision: VISION-001
success-criteria:
  - All 6 reference library documents lead with statistical analysis derived from the 122-entry Discovered corpus as the primary evidence layer
  - KataLog evidence is repositioned as supplementary qualitative evidence valued for judge commentary, team reasoning, and ADR documentation -- not as the primary ranking system
  - Combined Weighted Scoreboard is replaced or demoted in favor of a Discovered-derived frequency scoreboard as the primary ranking
  - Each document's opening sections, ranking tables, and classification matrices present Discovered statistical distributions before any other source
  - KataLog-specific constructs (placement scores, win rates, average ADR counts) appear in clearly labeled secondary sections, not in primary rankings
  - No document section uses KataLog placement scores as the primary basis for architectural recommendations
depends-on: []
---

# Discovered-First Evidence Hierarchy

## Goal / Objective

Restructure all 6 reference library documents to lead with statistical analysis of the 122-entry Discovered corpus as the primary body of evidence, demoting KataLog competition data to a supplementary role.

The current documents -- despite the EPIC-004 rewrite adding all 5 sources -- still center their narrative and ranking structures on KataLog. The Combined Weighted Scoreboard gives production systems (AOSA, RealWorld) 20 points each and KataLog placements 1-4 points, but with 78 KataLog teams generating dense placement data vs. 17 production systems, KataLog dominates the scoring by volume. The Discovered corpus (122 repos) is treated as "breadth context" with zero weight in the combined score, despite being the largest evidence pool and the only one derived from actual production codebases at scale.

### The evidence hierarchy problem

The current hierarchy is:

1. **Combined Weighted Score** (KataLog + AOSA + RealWorld + RefArch) -- primary ranking
2. **KataLog placement data** -- drives narrative, decision paths, team tables
3. **AOSA/RealWorld** -- cited as production validation
4. **Discovered** -- footnoted as "breadth context, not weighted"

The correct hierarchy should be:

1. **Discovered statistical distributions** (122 repos) -- primary evidence for "what architectures do real codebases use?" This is the largest, most linguistically diverse, and most structurally representative corpus. It answers the question: "when practitioners build software, what patterns emerge?"
2. **AOSA/RealWorld production narratives** (17 systems) -- deep production evidence with architectural reasoning from system creators. Small sample but highest individual weight.
3. **KataLog qualitative evidence** (78 teams) -- valued specifically for: judge commentary on what worked/failed, team ADR documentation showing decision reasoning, "show your work" artifacts that explain *why* a style was chosen. These explanations are rarely available in production repos.
4. **RefArch/Discovered code signals** -- structural validation and pattern frequency

### Why KataLog should not lead

KataLog data has three structural biases that make it unsuitable as primary evidence:

1. **Competition bias**: Teams optimize for judges, not production. Judge criteria reward documentation quality, ADR count, and "show your work" -- valid pedagogical metrics but not evidence of production fitness.
2. **Never-built designs**: No KataLog submission was ever deployed. The architecture exists only as diagrams and documentation. Discovered repos contain actual running code.
3. **Selection bias**: Only 11 challenge domains across 78 teams. The Discovered corpus covers 35 domains across 122 repos with 9+ programming languages.

### Why KataLog still matters

KataLog's unique value is the qualitative dimension absent from code-level evidence:

- **Judge feedback**: Expert judges evaluated trade-off reasoning, not just style choice
- **ADR documentation**: Teams documented *why* they chose patterns, not just *what* patterns they used
- **Comparative reasoning**: Multiple teams solving the same problem with different styles enables controlled comparison
- **Cost analysis**: Teams like ArchColider ($12K-$23K/yr) and MonArch ($2,780/mo) provided cost projections unavailable in open-source repos

These qualitative insights should be presented as explanatory evidence ("here's why this pattern works") rather than primary rankings ("this pattern scored highest").

## Scope Boundaries

### In scope

**6 reference library documents to restructure:**

1. **`problem-spaces.md`** -- Lead Classification Matrix with Discovered domain clusters (35 domains, 122 repos) as the primary taxonomy. KataLog's 11 challenge profiles become a secondary section valued for the detailed team reasoning they provide.

2. **`solution-spaces.md`** -- Replace Combined Weighted Scoreboard with a Discovered Frequency Scoreboard as primary ranking. The current scoreboard weights KataLog heavily by volume despite per-entry weighting favoring production. New primary: "In 122 real codebases, Modular Monolith appears in 52%, Event-Driven in 52%, Layered in 24%..." KataLog placement analysis moves to a "Competition Validation" section.

3. **`evidence/by-architecture-style.md`** -- Each style section opens with Discovered frequency and co-occurrence statistics. KataLog team tables move below the statistical analysis, contextualized as "qualitative evidence: why teams chose this style."

4. **`evidence/by-quality-attribute.md`** -- QA rankings derive from Discovered signal detection (Deployability 89%, Modularity 34%, Scalability 27%) as primary, with KataLog team priorities as secondary. Detection bias is prominently noted (Deployability inflated by Docker signals; Performance undetectable from filesystem).

5. **`problem-solution-matrix.md`** -- Domain-to-style mapping leads with Discovered domain statistics ("In 11 e-commerce repos, DDD appears in 7, Event-Driven in 5, Microservices in 4"). KataLog team evidence supplements with qualitative reasoning.

6. **`decision-navigator.md`** -- Decision paths present Discovered pattern frequencies as the statistical basis, with KataLog team stories as illustrative case studies. "In the Discovered corpus, 52% of repos use Event-Driven" leads; "BluzBrothers proved 693ms with fitness functions" illustrates.

### Out of scope

- Changing the Discovered classification pipeline or catalog entries
- Adding new evidence sources
- Modifying the cross-source-reference.md or cross-source-analysis.md foundation docs (these are analytical methodology, not practitioner-facing)
- Changing KataLog catalog entries or team data
- Re-weighting the Combined Weighted Scoreboard formula (it can remain as a secondary analysis)

## Implementation Approach

### Phase 1: Define the Discovered-first information architecture

For each of the 6 documents, define:
- What Discovered statistical data leads each section
- Where KataLog evidence is repositioned (with section headers like "Qualitative Evidence: Competition Insights" or "Why This Works: Team Reasoning")
- What framing language replaces KataLog-centric framing

### Phase 2: Restructure each document

Layer ordering (same dependency chain as EPIC-004):
- **Layer 1** (parallel): problem-spaces.md + solution-spaces.md
- **Layer 2** (parallel): by-architecture-style.md + by-quality-attribute.md
- **Layer 3** (parallel): problem-solution-matrix.md + decision-navigator.md

### Phase 3: Verify and cross-reference

- Grep each document for KataLog-leading constructs (placement scores in primary rankings, team tables before statistical tables)
- Verify Discovered statistics are consistent across all 6 documents
- Run specwatch scan for stale references

### Key structural changes per document

**solution-spaces.md (highest priority):**
- Current: Combined Weighted Scoreboard (KataLog+AOSA+RealWorld+RefArch weighted sum) is the primary ranking
- Target: Discovered Frequency Scoreboard is the primary ranking

| Rank | Style | Discovered Repos | % of Corpus | Top Co-occurring Style | Production Systems |
|------|-------|-----------------|-------------|----------------------|-------------------|
| 1 | Modular Monolith | 64 | 52% | Event-Driven (co-occurs in 38) | Orchard Core |
| 2 | Event-Driven | 63 | 52% | Modular Monolith (co-occurs in 38) | NGINX, Twisted, ZeroMQ, Bitwarden, Squidex |
| 3 | Layered | 29 | 24% | Modular Monolith (co-occurs in 18) | SQLAlchemy, nopCommerce |
| ... | ... | ... | ... | ... | ... |

- Combined Weighted Scoreboard moves to "Alternative Ranking: Production-Weighted Score" section
- Per-style profiles open with Discovered frequency, then production narratives, then KataLog qualitative reasoning

**by-architecture-style.md:**
- Current: Evidence Summary leads with Combined rank
- Target: Evidence Summary leads with Discovered frequency rank and co-occurrence pattern
- Current: Cross-Source Evidence Table has production first (good) but KataLog team tables are prominent
- Target: Statistical summary paragraph from Discovered before any team tables

**decision-navigator.md:**
- Current: Each path says "Recommended: X. Evidence: KataLog teams..."
- Target: Each path says "Recommended: X. Statistical basis: In 122 codebases, X appears in N% of [domain] repos. Qualitative reasoning: KataLog teams explain why..."

## Child Specs

Work completed directly via commits c24d038, 3400331, 634f67a without child spec artifacts. Statistics refresh handled by SPEC-018 under EPIC-008.

## Key Dependencies

- **EPIC-004** (Complete) -- The 5-source rewrite is the foundation. This epic restructures the *hierarchy* of sources within the already-rewritten documents.
- Discovered catalog (122 entries) must remain stable during this work.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-05 | 690dfff | Initial creation |
| Complete | 2026-03-05 | — | All 6 reference library docs restructured with Discovered-first hierarchy |
