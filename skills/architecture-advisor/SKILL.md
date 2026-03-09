---
name: architecture-advisor
description: Evidence-based architecture guidance grounded in 142 production codebases and 17 production system case studies. Reviews project goals, examines the user's codebase, and provides data-driven recommendations for architecture style selection, quality attribute trade-offs, and pattern validation. Use when the user asks "which architecture should I use", "is my architecture right for this", "architecture review", "help me choose between X and Y", "what patterns work for my domain", "architecture trade-offs", "validate my architecture", or any question about choosing, evaluating, or improving software architecture. Also triggers on "architecture patterns", "quality attributes", "ADR examples", "feasibility analysis", "fitness functions", or "kata preparation".
license: MIT
allowed-tools: Bash, Read, Grep, Glob, Agent
metadata:
  short-description: Production-evidence-based architecture guidance from 142 codebases
  version: 3.0.0
  author: cristos
  source-repo: https://github.com/cristoslc/architecture-reference
---

# Architecture Advisor

Evidence-based architecture guidance grounded in production reality. Every recommendation cites real systems, not opinion or convention.

The evidence hierarchy (ADR-004):

1. **Discovered production repos (142 entries)** — primary statistical baseline. What production codebases actually use.
2. **AOSA/RealWorld production systems (17 entries)** — deep case studies from system creators. Highest per-system authority.
3. **KataLog competition (78 teams)** — qualitative annotation. Never-built designs valued for ADR reasoning, judge commentary, and cost projections. Not primary evidence.
4. **Reference implementations (50 entries)** — teaching examples. Not counted in frequency rankings.

## Setup: Reference Data

This skill can work at three levels of data access:

### Level 1: Offline reference (always available)

The key findings at the bottom of this file provide enough data for most questions. No setup needed.

### Level 2: Synced references (recommended)

Run the sync script to fetch the full reference library, YAML catalogs, and analyses (<1 MB):

```bash
bash scripts/sync-references.sh
```

This populates `references/` with the complete reference library. The script is idempotent.

### Level 3: Full evidence pool

For deep dives into individual competition team submissions (ADRs, C4 diagrams, video transcripts):

```bash
bash scripts/sync-references.sh --evidence-pool
```

Adds ~2.2 GB. Only suggest when the user explicitly needs team submission details.

### Data Resolution

Check these locations in order, stop at first match:

1. `references/` relative to this SKILL.md (synced data)
2. `../../evidence-analysis/` and `../../docs/` (source repo checkout)
3. Current working directory (user inside source repo)
4. Offline reference below (always available)

## What This Skill Does

The user brings an architecture problem. You research the evidence base and provide data-driven guidance with citations.

### Step 1: Understand the problem

Ask enough to classify the situation:

- **Style selection**: "Which architecture fits my project?" → consult production frequency data and domain-style correlations
- **Architecture review**: "Is my current architecture sound?" → examine their codebase and compare to evidence
- **Pattern trade-offs**: "Microservices vs Service-Based?" → compare production evidence for both
- **Quality attributes**: "How do I get scalability AND simplicity?" → consult QA evidence and trade-off data
- **Domain mapping**: "What works for e-commerce/healthcare/etc?" → consult domain-style correlations
- **Kata preparation**: "Help me prepare for an architecture kata" → use templates and competition insights

### Step 2: Examine the codebase (if available)

If the user has a codebase to evaluate, examine it before giving advice. Read actual code — understand their current architecture before recommending changes. Use the discover-architecture skill's approach: read entrypoints, module boundaries, communication patterns, dependency direction, and deployment configs (compose files, proxy configs, k8s manifests) that may introduce components, boundaries, or contracts invisible in application code.

### Step 3: Research the evidence

**For style selection or trade-off questions**, consult in this order:

| Priority | Source | Path (references/) | What it answers |
|----------|--------|-------------------|----------------|
| 1 | Discovered frequency rankings | `reference-library/solution-spaces.md` | "How common is this style in production?" |
| 2 | Domain-style correlations | `reference-library/problem-solution-matrix.md` | "What styles work for my domain?" |
| 3 | Decision navigator | `reference-library/decision-navigator.md` | "Given my constraints, what's recommended?" |
| 4 | Production system narratives | `catalogs/AOSA/`, `catalogs/RealWorldASPNET/` | "How did real systems implement this?" |
| 5 | Style evidence details | `reference-library/evidence/by-architecture-style.md` | "What's the full evidence picture for this style?" |
| 6 | Competition team reasoning | `catalogs/TheKataLog/` | "Why did teams choose this? What trade-offs did they document?" |

**For quality attribute questions:**

| Priority | Source | Path |
|----------|--------|------|
| 1 | QA detection data | `reference-library/evidence/by-quality-attribute.md` |
| 2 | Cross-source QA analysis | `reference-library/evidence/cross-source-analysis.md` |

**For meta-practice questions** (ADRs, feasibility, fitness functions):

| Priority | Source | Path |
|----------|--------|------|
| 1 | Templates | `templates/adr-guide.md`, `templates/feasibility-guide.md`, `templates/fitness-functions-guide.md` |
| 2 | Competition evidence | KataLog team submissions (these are KataLog's genuine strength — meta-practices documented in team ADRs) |

### Step 4: Synthesize with citations

Every recommendation MUST cite specific evidence:

- **Production frequency**: "Microkernel appears in 83 of 142 production repos (58.5%)" — cite Discovered data
- **Production depth**: "NGINX uses event-driven architecture for non-blocking I/O (AOSA)" — cite specific systems
- **Domain correlation**: "In Developer Tools repos, Microkernel (61%) and Layered (47%) dominate" — cite domain data
- **Platform vs application**: "Microservices skews heavily toward platforms (13%) vs applications (2%)" — cite split data
- **Qualitative reasoning**: "KataLog teams explain that cost/feasibility analysis is the #1 predictor of placement (4.5x likelihood)" — cite as annotation, not primary evidence

**Do not make unsupported claims.** If evidence is thin (small sample, single source), say so.

### Step 5: Give actionable guidance

Don't just report data — help the user make a decision:

- Recommend specific styles with evidence-backed reasoning
- Flag risks and trade-offs with production evidence
- Suggest concrete next steps (ADRs to write, patterns to prototype, quality attributes to prioritize)
- If examining their codebase, identify gaps between current architecture and evidence-backed patterns

### Step 6: Save report (optional)

When the user asks to save the report ("save this", "write a report", "save to docs"), or when the analysis was a full architecture review (not just a quick question), offer to persist the output:

1. Create the output directory if needed: `mkdir -p docs/architecture-reports/`
2. Generate the report following the template in `references/report.template.j2` — the template defines the frontmatter fields, section order, and required content. You don't need a Jinja2 renderer; just fill in the structure by hand using the template as a guide.
3. Save as `docs/architecture-reports/<project-name>-<YYYY-MM-DD>.md`
4. If a report for the same project and date already exists, append a sequence suffix: `-2`, `-3`, etc.

The report template includes YAML frontmatter (project, date, scope, styles) so reports are machine-parseable for future cross-project analysis.

Don't save reports for casual Q&A ("what's the most common style?"). Save when there's a concrete analysis tied to a specific project or codebase.

## Glossary

For definitions of all 12 architecture styles, 13 quality attributes, evidence sources, and key terms, read `references/reference-library/glossary.md` (or the offline reference below).

## Offline Reference

When no synced data is available, use these findings. All data from SPEC-022 production-only frequency recomputation (142 entries, deep-analysis per ADR-002).

### Production frequency rankings (Discovered, 142 production repos)

| Rank | Style | Count | % | Platform | Application | Production Systems |
|------|-------|-------|---|----------|-------------|-------------------|
| 1 | Microkernel | 83 | 58.5% | 61% | 55% | LLVM, SQLAlchemy, GStreamer, Jellyfin, Orchard Core, nopCommerce |
| 2 | Layered | 78 | 54.9% | 47% | 67% | nopCommerce |
| 3 | Modular Monolith | 57 | 40.1% | 41% | 38% | Orchard Core |
| 4 | Event-Driven | 17 | 12.0% | 8% | 18% | NGINX, Twisted, ZeroMQ, Squidex, Bitwarden |
| 5 | Pipeline | 13 | 9.2% | 13% | 4% | NGINX, LLVM, ZeroMQ, Graphite, GStreamer, Jellyfin |
| 6 | Microservices | 12 | 8.5% | 13% | 2% | (none in evidence base) |
| 7 | Service-Based | 7 | 4.9% | 5% | 5% | Selenium, Graphite, Bitwarden |
| 8 | Hexagonal | 5 | 3.5% | 3% | 4% | (none) |
| 9 | DDD | 3 | 2.1% | 2% | 2% | (none) |
| 10 | Multi-Agent | 1 | 0.7% | 0% | 2% | (none) |
| 11 | Space-Based | 1 | 0.7% | 1% | 0% | Riak |
| 12 | CQRS | 1 | 0.7% | 0% | 2% | Squidex |

Dataset: 184 repos total (142 production + 42 reference). 87 platforms, 55 applications, 1.58:1 ratio. Zero Indeterminate (ADR-002 deep-analysis). 74% of repos exhibit exactly 2 styles.

### Key findings from production evidence

1. **Microkernel and Layered dominate.** The top 3 styles (Microkernel, Layered, Modular Monolith) appear in 40-59% of production repos. Everything else is below 12%.

2. **The proposal-production gap.** What competition teams propose diverges from what exists in production. Microservices: 50% of teams, 8.5% of repos. Pipeline: 0% of teams, 9.2% of repos. Layered: 0% of teams, 54.9% of repos.

3. **Tutorial bias inflated DDD, CQRS, Hexagonal.** Prior methodology counted reference implementations alongside production: DDD was 17.8% (now 2.1%), CQRS was 10.4% (now 0.7%). These patterns are well-documented in teaching materials but rare in production.

4. **Platform vs application architecture differs.** Microservices is almost exclusively a platform pattern (13% vs 2%). Layered skews toward applications (67% vs 47%). Event-Driven skews toward applications (18% vs 8%).

5. **Multi-style composition is normal.** 74% of repos exhibit 2 styles. The most common combinations: Microkernel + Layered, Microkernel + Modular Monolith, Layered + Modular Monolith.

### Quality attribute detection (142 production repos)

| QA | Detected | % | Reliability |
|----|----------|---|------------|
| Deployability | 126 | 88.7% | Inflated — Docker is universal |
| Modularity | 38 | 26.8% | Moderate |
| Scalability | 33 | 23.2% | Moderate |
| Fault Tolerance | 20 | 14.1% | Moderate |
| Observability | 5 | 3.5% | Underdetected |
| Evolvability | 3 | 2.1% | Severely underdetected |
| Performance, Security, Testability, etc. | 0 | 0% | Invisible in code |

> **Detection bias:** Code analysis reliably detects QAs with filesystem signals (Docker, CI configs, module boundaries) but cannot detect Performance, Security, Testability, or Cost concerns. Competition evidence (KataLog) fills this gap — teams documented these invisible concerns in ADRs and presentations.

### Competition insights (KataLog — qualitative annotation, not primary evidence)

Meta-architectural practices that predict competition success:
- **Feasibility analysis**: 4.5x more likely to place top-2 (75.6% of teams skip it)
- **ADR discipline**: Winners average 15.0 ADRs vs 8.5 for runners-up
- **Fitness functions**: 55% of winners include them vs ~17% overall
- **Multi-style composition**: 73% of winners use 2+ styles
- **The Scalability Trap**: Winners cite scalability LESS often (55%) than runners-up (68%)

These practices are KataLog's genuine contribution — meta-architectural reasoning unavailable in production code analysis.

### Domain coverage (47 unique domains in Discovered)

Top domains: Developer Tools (36), E-Commerce (15), Observability (11), Data Processing (11), Infrastructure (9), Data Grid (8), Messaging (6), Productivity (5), Media Automation (5), Workflow Orchestration (5).

### Evidence source summary

| Source | Entries | Role | Value |
|--------|---------|------|-------|
| Discovered (production) | 142 | Primary statistical baseline | Largest, most diverse corpus of real production code |
| AOSA | 12 | Production depth | Case studies written by system creators (NGINX, HDFS, Git, etc.) |
| RealWorldASPNET | 5 | Production depth | Modern .NET apps with real users |
| KataLog | 78 | Qualitative annotation | ADR reasoning, judge commentary, cost projections |
| RefArch + Discovered ref | 50 | Teaching examples | Concrete code examples; zero weight in rankings |
