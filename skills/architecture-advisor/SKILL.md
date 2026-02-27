---
name: architecture-advisor
description: Research how real architecture teams solved problems using evidence from 103 projects across four sources — 34 placing O'Reilly Architecture Kata teams, 12 AOSA production systems, 5 production .NET apps, and 8 reference implementations. Use when the user asks about architecture style selection, pattern trade-offs, quality attributes, ADR examples, kata preparation, or feasibility analysis. Triggers on "architecture patterns", "which architecture style", "how did teams handle", "kata preparation", "architecture evidence", "ADR examples", "feasibility analysis", "fitness functions".
license: MIT
allowed-tools: Bash, Read, Grep, Glob, Task
metadata:
  short-description: Evidence-based architecture research from 103 real-world projects
  version: 2.0.0
  source-repo: https://github.com/cristoslc/architecture-reference-repo
---

# Architecture Advisor

Research how real architecture teams solved problems, using evidence from 103 projects across four complementary sources.

## What This Is

The **architecture-reference-repo** is an evidence-based reference library containing:

- **34 placing team submissions** from 11 seasons of O'Reilly Architecture Katas (Fall 2020 -- Winter 2025) with full documentation (ADRs, C4 diagrams, deployment views, sequence diagrams, feasibility analyses, video transcripts)
- **12 production open-source systems** from The Architecture of Open Source Applications (AOSA), described by their creators
- **5 production .NET applications** (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex)
- **8 curated reference implementations** with working, deployable code
- **66 structured YAML catalog files** with metadata per project (architecture styles, quality attributes, technology stacks, key patterns)
- **A reference library** with placement-weighted scores for 12 architecture styles, 10 problem dimensions, and a decision navigator
- **11 comparative analyses** (one per kata challenge) and cross-source triangulation

Kata scoring uses a placement-weighted system: 1st = 4 pts, 2nd = 3 pts, 3rd = 2 pts.

## Setup: Syncing Reference Data

This skill fetches its reference data from the source repository via sparse clone. The reference data lives in `references/` alongside this file.

### First-time setup

Before answering any question, check whether `references/` exists relative to this SKILL.md. If it does not exist, run the sync script:

```bash
bash scripts/sync-references.sh
```

This does a sparse clone of `https://github.com/cristoslc/architecture-reference-repo` and extracts the key reference library (~500 KB) into `references/reference-library/`.

### Upgrading to full data

If a question requires catalog search, per-challenge analyses, or templates, and the `references/catalogs/` directory does not exist, offer to run:

```bash
bash scripts/sync-references.sh --full
```

This adds YAML catalogs for all 4 evidence sources (~66 files), per-challenge analyses, cross-cutting analyses, and templates (~700 KB total).

### Complete evidence pool

For deep dives into individual team submissions (reading ADRs, C4 diagrams, video transcripts), if `references/evidence-pool/` does not exist, offer to run:

```bash
bash scripts/sync-references.sh --complete
```

This adds the full evidence pool (~2.2 GB). Only suggest this when the user explicitly needs to read individual team submissions.

### Updating

To pull the latest data from the source repository, re-run the sync script with the same mode:

```bash
bash scripts/sync-references.sh --status    # Check current state
bash scripts/sync-references.sh             # Update sparse references
bash scripts/sync-references.sh --full      # Update full references
```

The script is idempotent — it overwrites existing references with fresh data and updates `references/.sync-state.yml`.

## Locating the Data

Use this resolution order to find evidence data. Stop at the first match.

1. **Local references**: Check `references/` relative to this SKILL.md. This is the primary data source for remote installations. The directory structure is:
   - `references/reference-library/` — Core reference documents (always present after sync)
   - `references/catalogs/<source>/` — YAML catalogs per source (after `--full` sync)
   - `references/analysis/<source>/` — Per-source analyses (after `--full` sync)
   - `references/templates/` — Practitioner guides and templates (after `--full` sync)
   - `references/evidence-pool/` — Full team submissions (after `--complete` sync)

2. **Source repo (local development)**: Check `../../evidence-analysis/` and `../../docs/` relative to this SKILL.md (works when skill is at `skills/architecture-advisor/` within the source repo itself).

3. **Current working directory**: Check if `evidence-analysis/TheKataLog/docs/catalog/_index.yaml` exists in the working directory (user is working inside the source repo).

4. **Common checkout locations**: Check `~/src/architecture-reference-repo/`, `~/architecture-reference-repo/`.

5. **Ask the user**: If no data is found at any location, ask the user for the path to their local clone.

6. **Fall back to offline reference**: If no local data is available at all, use the key findings embedded in this file (see "Offline Reference" below).

### Path mapping

When data is found via `references/` (resolution path 1), use these path mappings:

| Source repo path | references/ path |
|-----------------|-----------------|
| `docs/reference-library/` | `references/reference-library/` |
| `docs/templates/` | `references/templates/` |
| `evidence-analysis/TheKataLog/docs/catalog/` | `references/catalogs/TheKataLog/` |
| `evidence-analysis/AOSA/docs/catalog/` | `references/catalogs/AOSA/` |
| `evidence-analysis/RealWorldASPNET/docs/catalog/` | `references/catalogs/RealWorldASPNET/` |
| `evidence-analysis/ReferenceArchitectures/docs/catalog/` | `references/catalogs/ReferenceArchitectures/` |
| `evidence-analysis/TheKataLog/docs/analysis/` | `references/analysis/TheKataLog/` |
| `evidence-analysis/AOSA/docs/analysis/` | `references/analysis/AOSA/` |
| `evidence-analysis/RealWorldASPNET/docs/analysis/` | `references/analysis/RealWorldASPNET/` |
| `evidence-analysis/ReferenceArchitectures/docs/analysis/` | `references/analysis/ReferenceArchitectures/` |
| `evidence-pool/TheKataLog/` | `references/evidence-pool/` |

## What To Do

The user gives you an architecture problem or question. Research the evidence base and return data-driven recommendations with citations.

### Step 1: Ensure data is available

Check the data resolution order above. If `references/` does not exist and no other data source is available, run `bash scripts/sync-references.sh` before proceeding.

### Step 2: Classify the question

Map the user's problem to one or more of these categories:

| Category | What to search | Key files (references/ path) |
|----------|---------------|------------------------------|
| **Style selection** | Which architecture style fits? | `references/reference-library/solution-spaces.md`, `references/reference-library/problem-solution-matrix.md` |
| **Pattern research** | How did teams implement a specific pattern? | `references/catalogs/*/*.yaml` (filter by style), then `references/evidence-pool/` |
| **Quality attributes** | Trade-offs between quality attributes | `references/reference-library/evidence/by-quality-attribute.md` |
| **ADR examples** | Real ADR examples for a decision type | `references/catalogs/TheKataLog/*.yaml` (filter by `adr_topics`), then team submissions |
| **Kata preparation** | Starting a new architecture kata | `references/templates/kata-checklist.md`, `references/reference-library/decision-navigator.md` |
| **Feasibility analysis** | What a feasibility analysis looks like | `references/templates/feasibility-guide.md`, teams with `has_feasibility_analysis: true` |
| **Fitness functions** | Defining quantitative architecture tests | `references/templates/fitness-functions-guide.md` |
| **Challenge comparison** | How teams approached a specific kata | `references/analysis/TheKataLog/challenges/<challenge-name>.md` |
| **Cross-source validation** | Does a pattern hold across competition and production? | `references/reference-library/evidence/cross-source-reference.md`, `references/reference-library/evidence/cross-source-analysis.md` |

If the question requires catalogs, analyses, or templates and they are not present, offer to run `bash scripts/sync-references.sh --full` before continuing.

### Step 3: Search structured data first

Start with the YAML catalogs — they are small, structured, and fast to scan.

**Key files to search:**

- `references/catalogs/TheKataLog/_index.yaml` — Master index of all 11 seasons, 34 placing teams, and style frequencies
- `references/catalogs/TheKataLog/<team-name>.yaml` — Per-team metadata including:
  - `architecture_styles` — List of styles used
  - `placement` / `placement_numeric` — Competition result (1st/2nd/3rd)
  - `quality_attributes_prioritized` — Quality attributes the team emphasized
  - `adr_count` / `adr_topics` — Number and topics of ADRs
  - `has_feasibility_analysis`, `has_c4_diagrams`, `has_deployment_view`, `has_sequence_diagrams` — Documentation artifacts present
  - `key_technologies` — Technology stack
  - `notable_strengths` / `notable_gaps` — Analyst assessments
  - `one_line_summary` — Quick team profile
- `references/catalogs/AOSA/_index.yaml` — 12 production open-source systems
- `references/catalogs/RealWorldASPNET/_index.yaml` — 5 production .NET apps
- `references/catalogs/ReferenceArchitectures/_index.yaml` — 8 reference implementations

### Step 4: Consult the reference library

| Document | Use When |
|----------|----------|
| `references/reference-library/solution-spaces.md` | Comparing architecture styles by placement-weighted scores |
| `references/reference-library/problem-spaces.md` | Classifying a problem across 10 dimensions |
| `references/reference-library/problem-solution-matrix.md` | Mapping problem dimensions to proven solutions |
| `references/reference-library/decision-navigator.md` | Walking through a step-by-step architecture decision |
| `references/reference-library/evidence/by-architecture-style.md` | Deep evidence for 7 ranked styles with per-team tables |
| `references/reference-library/evidence/by-quality-attribute.md` | 10 quality attributes ranked by correlation with placement |
| `references/reference-library/evidence/cross-source-reference.md` | Weighted scoreboard across all 4 sources |
| `references/reference-library/evidence/cross-source-analysis.md` | Triangulation framework and cross-source findings |
| `references/analysis/TheKataLog/cross-cutting.md` | Statistical patterns across all placing teams |

### Step 5: Dive into evidence

For deep research, read team submissions in `references/evidence-pool/` (requires `--complete` sync). Submissions are organized as `<year>-<kata-challenge>/<team>/` and may contain:

- `README.md` or `submission.md` — Main architecture document
- `ADRs/` or `adr/` — Architecture Decision Records
- `diagrams/` — C4, deployment, sequence diagrams (converted to markdown descriptions)
- `video-transcript.md` — LLM-readable transcript of the team's presentation

For per-source analysis, read:

- `references/analysis/AOSA/source-analysis.md` — Patterns across 12 AOSA projects
- `references/analysis/RealWorldASPNET/source-analysis.md` — Patterns across 5 .NET apps
- `references/analysis/ReferenceArchitectures/source-analysis.md` — Patterns across 8 reference implementations

Spin up parallel agents to search across multiple team submissions simultaneously for broad research queries.

### Step 6: Synthesize with citations

Every recommendation MUST cite specific evidence:

- **Team name and placement** (e.g., "ArchColider, 1st place Fall 2020")
- **Production system** (e.g., "NGINX (AOSA) uses event-driven architecture for...")
- **Data points** (e.g., "teams with feasibility analysis are 4.5x more likely to place top-2")
- **Sample sizes** (e.g., "Modular Monolith: n=6, avg placement score 3.00")
- **Cross-source confirmation** (e.g., "Event-driven dominance confirmed by both kata results (9/11 winners) and AOSA production systems (7/12)")

Do not make unsupported claims. If the evidence is inconclusive or the sample size is too small, say so.

## Offline Reference

When no local data is available at all (references/ not synced, no repo checkout), use these key findings to inform recommendations. All data points are derived from the evidence base.

### Architecture style rankings (by placement-weighted score, kata data)

| Rank | Style | Teams | Avg Score | Key Insight |
|------|-------|-------|-----------|-------------|
| 1 | Modular Monolith | 6 | 3.00 | Highest per-team success rate; 100% placed top-3 |
| 2 | Event-Driven | 47 | 2.02 | Most popular; 9 of 11 first-place wins use it |
| 3 | Microservices | 42 | 1.90 | Second most popular; works best when paired with Event-Driven |
| 4 | Service-Based | 17 | 1.76 | Solid middle ground between monolith and microservices |
| 5 | Domain-Driven Design | 16 | 2.13 | Strong when combined with other styles |
| 6 | CQRS | 11 | 2.09 | Effective for complex read/write separation |
| 7 | Space-Based | 5 | 1.80 | Niche but effective for high-throughput scenarios |

### Cross-source validation

Key kata findings confirmed by production systems:

- **Event-Driven dominance**: Kata winners (9/11) + AOSA production systems (7/12) + reference implementations (5/8) all confirm event-driven as the most successful pattern
- **Modular Monolith effectiveness**: Highest kata placement score (3.00) + AOSA production validation (Audacity, Eclipse) + working reference implementation (kgrzybek/modular-monolith-with-ddd)
- **Multi-style composition**: 73% of kata winners use 2+ styles; production systems average 2.3 styles; reference implementations average 2.5 styles

### Winning formula

Teams that place first typically exhibit:
- **2+ architecture styles** (73% of winners vs. 52% of runners-up)
- **15+ ADRs** (winner avg: 15.0 vs. runner-up avg: 8.5)
- **Feasibility analysis** (4.5x more likely to place top-2)
- **Fitness functions** (55% of winners vs. ~17% overall)
- **Phased evolution** (MVP → target state roadmap)

### Top quality attributes by placement correlation

1. **Workflow / Orchestration** — Highest avg placement score
2. **Cost Efficiency** — Strong positive signal (often paired with feasibility analysis)
3. **Data Integrity / Consistency** — Winners prioritize correctness
4. **Evolvability / Extensibility** — Judges reward evolutionary thinking
5. **Interoperability / Integration** — Important in complex ecosystems

### Common pitfall: The Scalability Trap

Scalability is the most commonly cited quality attribute (48 of 78 teams), but first-place winners cite it *less* often (55%) than runners-up (68%). Over-indexing on scalability at the expense of cost, data integrity, and simplicity is a negative signal.

## Version Note

Evidence spans 11 kata seasons (Fall 2020 through Winter 2025), 12 AOSA projects, 5 production .NET apps, and 8 reference implementations. Run `bash scripts/sync-references.sh --status` to check the current sync state and data freshness.
