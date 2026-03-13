# Discovered-First Information Architecture

Supporting document for EPIC-007. Defines the exact structural changes for each of the 6 reference library documents.

## Evidence hierarchy (applies to all 6 documents)

Every major section follows this ordering:

1. **Discovered statistical distributions** — leads with frequency counts, percentages, co-occurrence patterns from the 122-repo corpus. This answers "what do real codebases actually use?"
2. **AOSA/RealWorld production narratives** — deep production evidence from system creators. Small sample (17 systems) but highest individual authority.
3. **KataLog qualitative evidence** — valued specifically for judge commentary, team ADR reasoning, and "show your work" artifacts. Presented under headers like "Why This Works: Team Reasoning" or "Qualitative Evidence: Competition Insights."
4. **RefArch structural validation** — reference implementations confirming recommended patterns.

## Discovered key statistics (reference data for all documents)

### Style distribution (122 repos)

| Rank | Style | Repos | % of Corpus |
|------|-------|-------|-------------|
| 1 | Modular Monolith | 64 | 52% |
| 2 | Event-Driven | 63 | 52% |
| 3 | Layered | 29 | 24% |
| 4 | Domain-Driven Design | 27 | 22% |
| 5 | Microservices | 26 | 21% |
| 6 | Pipe-and-Filter | 19 | 16% |
| 7 | CQRS | 18 | 15% |
| 8 | Hexagonal | 16 | 13% |
| 9 | Serverless | 6 | 5% |
| 10 | Multi-Agent | 5 | 4% |
| 11 | Space-Based | 5 | 4% |
| 12 | Service-Based | 4 | 3% |

### Quality attribute detection (122 repos)

| QA | Repos | % of Corpus | Detection notes |
|----|-------|-------------|-----------------|
| Deployability | 108 | 89% | Inflated by Docker/CI signal prevalence |
| Modularity | 41 | 34% | |
| Scalability | 33 | 27% | |
| Fault Tolerance | 18 | 15% | |
| Observability | 4 | 3% | Underdetected — hard to infer from filesystem |
| Evolvability | 2 | 2% | Underdetected — hard to infer from filesystem |

### Domain coverage (top 10 of 35 domains)

| Domain | Repos |
|--------|-------|
| Developer Tools | 36 |
| E-Commerce | 11 |
| Infrastructure | 7 |
| AI/ML | 6 |
| Data Grid | 6 |
| Workflow Orchestration | 5 |
| Data Processing | 5 |
| Messaging | 5 |
| CMS | 4 |
| Social Media | 4 |

---

## Per-document restructuring spec

### 1. solution-spaces.md

**Current problem:** Combined Weighted Scoreboard (line 74) is the primary ranking. Discovered is explicitly excluded from scoring ("not included in combined scores"). KataLog dominates the combined score by volume (78 teams generating dense placement data vs. 17 production systems).

**Target structure:**

```
## How to Use This Document
  (unchanged)

## Discovered Frequency Scoreboard (PRIMARY RANKING)
  Table: Rank | Style | Discovered Repos | % of Corpus | Top Co-occurring Style | Production Systems
  - Ranks styles by frequency in 122 real codebases
  - Co-occurrence column shows which styles pair together in practice
  - Production Systems column links to AOSA/RealWorld validation

## Production Evidence Highlights
  - AOSA/RealWorld systems grouped by style
  - "These production systems confirm the patterns seen at scale in the Discovered corpus"

## Qualitative Evidence: Competition Insights
  ### KataLog Competition Scoreboard (SECONDARY)
  - Placement scores, team tables, season rankings
  - Framed as: "Competition teams explain *why* these patterns work"
  - Judge commentary and ADR excerpts highlighted

## Alternative Ranking: Production-Weighted Score
  - The old Combined Weighted Scoreboard, preserved for reference
  - Clearly labeled as an alternative weighting methodology

## Detailed Style Profiles
  Each profile follows:
  1. **Statistical basis** — "In 122 codebases, [Style] appears in N% of repos, co-occurring with [X] in M repos"
  2. **Production evidence** — AOSA/RealWorld narratives
  3. **Why this works** — KataLog team reasoning, judge feedback, ADR excerpts
  4. **Reference implementations** — RefArch repos
```

**Framing language changes:**
- "The most commonly adopted architecture style in production" replaces "The highest-scoring style"
- "Appears in N% of real codebases" replaces "Combined score of X"
- "Competition teams explain why" replaces "KataLog teams demonstrate"

---

### 2. problem-spaces.md

**Current problem:** Classification Matrix leads with KataLog Problem Profiles (11 challenges, 78 teams), then AOSA, then RealWorld, then RefArch, then Discovered last. The entire framing treats kata challenges as the primary problem taxonomy.

**Target structure:**

```
## How to Use This Document
  (unchanged)

## Dimension Definitions
  (unchanged)

## Classification Matrix

  ### Discovered Domain Distribution (122 repos, 35 domains)
  - Primary taxonomy: domains derived from actual production codebases
  - Table: Domain Cluster | Repo Count | Top Styles | Top QAs | Representative Repos
  - Groups the 35 Discovered domains into ~8-10 clusters
  - This is the primary evidence for "what problems do real systems solve?"

  ### Production-Validated Profiles (AOSA + RealWorld, 17 systems)
  - Deep profiles from systems with published architectural reasoning
  - Table: System | Domain | Scale | Styles | Key Tension | Source

  ### Competition Problem Profiles (KataLog, 11 challenges)
  - "These competition challenges provide structured problem decomposition rarely available in production repos"
  - Valued for: explicit requirement enumeration, constraint documentation, judging criteria
  - Table: Challenge | Domain Type | Scale | Key Tension | Teams | Insight

  ### Reference Architecture Profiles (RefArch, 8 repos)
  - Vendor/community reference implementations

## Detailed Problem Profiles
  Each profile opens with:
  1. **Discovered prevalence** — "N repos in the Discovered corpus address [domain]. Most common styles: ..."
  2. **Production depth** — AOSA/RealWorld system narratives (if available)
  3. **Competition reasoning** — KataLog team ADRs explaining problem decomposition
```

**Framing language changes:**
- "35 domains observed in production codebases" replaces "11 competition challenges"
- "Problem taxonomy derived from 122 real systems" replaces "Problem classification from KataLog"
- "Competition challenges provide structured reasoning" replaces "KataLog challenges define the problem space"

---

### 3. evidence/by-architecture-style.md

**Current problem:** Style Performance Rankings table (line 11) ranks by Combined Score. Cross-Source Evidence Tables list Discovered last. Opening narrative centers on production-weighted scoring.

**Target structure:**

```
## Discovered Frequency Rankings (PRIMARY)
  Table: Rank | Style | Discovered Repos | % of Corpus | Top Co-occurring Styles | Domains Where Most Common
  ### Key Statistical Findings
  - "Modular Monolith and Event-Driven are equally prevalent (52% each) and co-occur in 38 repos"
  - "Layered, DDD, and Microservices form a second tier (21-24%)"
  - Detection bias caveat for filesystem-invisible styles

## Production-Weighted Rankings (SECONDARY)
  - The old Combined Score table, labeled as secondary
  - "Production weighting validates that Discovered frequency aligns with production adoption"

## Style Sections (1-13)
  Each style section:
  ### Evidence Summary
  - Opens with: "Appears in N of 122 Discovered repos (M%). Co-occurs most frequently with [X]."
  - Then: "Validated by N AOSA/RealWorld production systems: [list]"
  - Then: "N KataLog teams chose this style; judges noted [key insight]"

  ### Cross-Source Evidence Table
  Source ordering: Discovered examples → AOSA/RealWorld → KataLog → RefArch

  ### Why Teams Choose This Style
  - KataLog judge commentary and team ADR excerpts
  - "These qualitative insights explain the reasoning behind the statistical pattern"

  ### When to Use / Avoid
  - Grounded in Discovered domain correlations, validated by production + competition evidence
```

---

### 4. evidence/by-quality-attribute.md

**Current problem:** QA Rankings table leads with KataLog Teams count as first data column. Each QA section presents Production Evidence first (good) but treats Discovered as "Code-Level Evidence" at the end.

**Target structure:**

```
## Discovered QA Detection Rankings (PRIMARY)
  Table: Rank | Quality Attribute | Discovered Repos | % of Corpus | Detection Method | Detection Bias Notes
  ### Detection Bias Caveat
  - "Deployability (89%) is inflated by Docker/CI signal prevalence"
  - "Performance, Testability, Interoperability are underdetected — filesystem signals are weak"
  - "These rankings reflect what's *detectable* in code, not what's *important* to architects"

## Cross-Source QA Validation
  Table showing same QAs across all 5 sources — demonstrates convergence/divergence

## QA Sections (1-13)
  Each QA section:
  ### Statistical Basis
  - "Detected in N of 122 Discovered repos (M%). Most common in [domain] repos."
  - Detection methodology and confidence level

  ### Production Evidence
  - AOSA/RealWorld systems demonstrating this QA
  - "Production systems confirm that [QA] is critical for [context]"

  ### Qualitative Evidence: Why This QA Matters
  - KataLog team priorities and judge feedback
  - "Teams explain *why* they prioritized this QA — reasoning unavailable in code analysis"

  ### Architecture Styles That Best Support It
  - Grounded in Discovered style-QA correlations
```

**Framing language changes:**
- "Detected in N% of production codebases" replaces "Prioritized by N KataLog teams"
- "Detection bias caveat" prominently noted (Discovered's automated detection has known blind spots)
- "Teams explain why this QA matters" replaces "KataLog teams prioritized this QA"

---

### 5. problem-solution-matrix.md

**Current problem:** Master Mapping tables use [COMPETITION], [PRODUCTION], [REFERENCE], [DISCOVERED] tags but KataLog placement scores appear first in many cells. Evidence basis is mixed with no clear hierarchy.

**Target structure:**

```
## How to Read This Matrix
  - "Mappings are grounded in Discovered corpus statistics (122 repos) as the primary evidence layer"
  - "Production systems (AOSA/RealWorld) provide depth validation"
  - "Competition evidence (KataLog) provides qualitative reasoning"

## Discovered Domain-Style Matrix (PRIMARY)
  Table: Domain | Repos | Top Style 1 (N%) | Top Style 2 (N%) | Top Style 3 (N%) | Production Confirmed
  - Pure statistical mapping: "In 11 e-commerce repos, DDD appears in 7, Event-Driven in 5, Microservices in 4"
  - "Production Confirmed" column flags where AOSA/RealWorld validates the pattern

## Production-Validated Mappings
  - Subset of matrix where AOSA/RealWorld systems confirm the Discovered pattern
  - "These mappings have the highest confidence — statistical frequency AND production validation"

## Qualitative Reasoning: Competition Evidence
  - KataLog team evidence organized by domain
  - "Teams explain *why* they chose these styles for these domains"
  - ADR excerpts, judge commentary, cost projections

## Compound Problem Mappings
  (restructured to lead with Discovered multi-style co-occurrence data)

## QA-to-Style Mappings
  (restructured to lead with Discovered QA-style correlations)
```

---

### 6. decision-navigator.md

**Current problem:** Each decision path leads with KataLog team recommendations ("Recommended: X. Evidence: KataLog teams..."). Discovered appears last as "Code-Level Evidence."

**Target structure:**

```
## How to Use This Guide
  (unchanged)

## Step 1: Classify Your Problem
  ### Q1-Q8 classification questions
  (unchanged — these are problem dimensions, source-independent)

## Step 2: Follow Your Path

  Each path restructured to:
  ### Path [X]: [Description]

  **Statistical basis:** "In the Discovered corpus, [Style] appears in N% of [domain/constraint] repos.
  Co-occurs with [Y] in M% of cases."

  **Production validation:** "Confirmed by [AOSA/RealWorld system]: [brief narrative]"

  **Why this works — team reasoning:**
  "KataLog teams [TeamName] explain: [ADR excerpt or judge commentary]"
  - Cost projections (where available from competition teams)
  - Trade-off documentation from team ADRs

  **Reference implementation:** [RefArch repo if applicable]

## Step 3: Validate with Quality Attributes
  - QA validation grounded in Discovered detection data
  - "In repos using [Style], [QA] was detected in N% — suggesting strong [QA] correlation"

## Quick Reference Card
  - Rankings from Discovered Frequency Scoreboard (not Combined Weighted Score)
```

**Framing language changes:**
- "Statistical basis: In 122 codebases..." replaces "Evidence: KataLog teams..."
- "Why this works — team reasoning" replaces "KataLog team evidence"
- "Confirmed by production systems" replaces "Production evidence"

---

## Global framing language replacements

| Current phrasing | Replacement |
|-----------------|-------------|
| "Combined Weighted Score" as primary | "Discovered Frequency" as primary |
| "KataLog teams demonstrate..." | "In 122 production codebases..." |
| "Placement score of X" | "Appears in N% of repos" |
| "Competition evidence shows..." | "Statistical analysis shows... Competition teams explain why..." |
| "Breadth context (Discovered)" | Remove — Discovered is no longer "breadth context," it IS the primary evidence |
| "Not included in combined scores" | Remove — Discovered drives the primary scoreboard |
| "Production-weighted scoring" as primary methodology | "Frequency-based ranking from 122 repos" as primary methodology |

## Detection bias disclosure (required in every document)

Every document must include a prominent note:

> **Detection bias:** Discovered statistics are derived from automated filesystem analysis. Styles and QAs that leave strong filesystem signals (Docker → Deployability, module boundaries → Modularity) are overrepresented. Styles and QAs that are architectural decisions invisible in code (Performance tuning, Testability strategies, Interoperability contracts) are underdetected. KataLog competition evidence fills this gap — teams documented these invisible decisions in ADRs and presentations.

This disclosure is critical. It honestly acknowledges Discovered's limitations while explaining why KataLog qualitative evidence remains valuable as a complementary source.
