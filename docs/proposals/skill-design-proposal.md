# Proposal: Architecture Advisor Remote Skill

## Summary

Design a skill for `architecture-reference-repo` that exposes the evidence-based architecture reference library as an agent-consumable capability — usable both locally within this repository and installable remotely into other repositories via the [remote-skill-manager](https://github.com/cristoslc/LLM-personal-agent-patterns/tree/main/L3-agents-standalone/.agents/skills/remote-skill-manager) pattern.

## Background

### What is a skill?

A skill is a directory containing a `SKILL.md` file with YAML frontmatter and natural-language instructions. When an agent reads the `SKILL.md`, it learns what the skill does, when to activate it, and how to execute it. Skills are the primary mechanism for giving agents domain-specific capabilities.

### Reference implementations studied

| Skill | Repo | Key Pattern |
|-------|------|-------------|
| [real-world-aspnetcore](https://github.com/nathancolgate/real-world-aspnetcore/blob/main/skills/real-world-aspnetcore/SKILL.md) | nathancolgate/real-world-aspnetcore | Research skill that searches 28 curated ASP.NET Core apps for patterns, spins up parallel agents, reads actual code, and synthesizes findings. Locates its data directory at runtime. |
| [remote-skill-manager](https://github.com/cristoslc/LLM-personal-agent-patterns/tree/main/L3-agents-standalone/.agents/skills/remote-skill-manager) | cristoslc/LLM-personal-agent-patterns | Meta-skill for fetching skills from remote Git repos with provenance tracking (`.source.yml`), integrity hashing (SHA-256), drift detection, and a smoke test. Follows ADR-002. |

### Key insights from the references

1. **A SKILL.md is the entire interface.** The real-world-aspnetcore skill is just a single `SKILL.md` with structured instructions — no code, no framework, no runtime dependencies. The agent reads it and follows the instructions.

2. **Data location is resolved at runtime.** The real-world-aspnetcore skill says "look for this directory here, then here, then ask the user." This makes the same skill work in the source repo (relative paths) and in a consumer repo (absolute or user-provided paths).

3. **Remote installation is a fetch-and-copy operation.** The remote-skill-manager's `fetch-remote-skill.sh` does a shallow clone, extracts the skill directory, computes an integrity hash, and writes a `.source.yml` provenance manifest. The fetched skill is a plain copy of the source — no transformation needed.

4. **Provenance is the consumer's concern.** The `.source.yml` manifest is generated at install time by the consuming repo's tooling, not shipped with the skill. The skill itself just needs to live at a well-known path and have a valid `SKILL.md`.

5. **The fetch script validates structure.** The `fetch-remote-skill.sh` script checks that the specified `skill-path` exists and contains a `SKILL.md` file before proceeding. Any skill intended for remote consumption must satisfy this structural contract.

6. **Integrity hashing excludes provenance metadata.** The SHA-256 digest covers `tar cf - --exclude='.source.yml'` of the skill directory. This means the skill's content — not its installation metadata — is what gets verified. A skill with supporting files (scripts, references, data) gets all of those hashed together.

## Design

### Skill: `architecture-advisor`

**Purpose:** Given an architecture problem, question, or kata challenge, search the evidence library to provide data-driven recommendations grounded in what actually worked across 103 real-world architecture projects from four complementary sources.

**Location:** `skills/architecture-advisor/SKILL.md`

### Evidence base

The skill draws on four evidence sources, each offering a different lens on architecture:

| Source | Projects | What it provides |
|--------|----------|------------------|
| O'Reilly Architecture Katas | 34 placing teams across 11 challenges | Competition submissions with ADRs, C4 diagrams, feasibility analyses, fitness functions |
| Architecture of Open Source Applications (AOSA) | 12 production systems | Detailed narratives from the architects who built NGINX, Git, Selenium, etc. |
| Real-World ASP.NET Core | 5 production .NET apps | Production codebases (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex) |
| Reference Architectures | 8 curated implementations | Working, deployable code for canonical patterns (eShop, modular monolith, clean arch, etc.) |

### Activation triggers

The skill activates when the user asks about:
- Architecture style selection ("which architecture style should I use?")
- Pattern research ("how do teams handle event-driven with microservices?")
- Quality attribute trade-offs ("scalability vs. simplicity evidence")
- ADR examples ("show me ADRs for CQRS decisions")
- Kata preparation ("I'm starting an architecture kata")
- Feasibility analysis ("what does a feasibility analysis look like?")

### Execution model

The SKILL.md instructs the agent to:

1. **Classify the question** — Map the user's problem to dimensions from `problem-spaces.md` (domain type, scale, compliance, real-time, etc.).
2. **Search structured data first** — Query the YAML catalog files for projects matching the problem profile. These are small, structured, and fast to scan.
3. **Consult the reference library** — Read `solution-spaces.md` for placement-weighted scores, `problem-solution-matrix.md` for dimension-to-style mappings, and `decision-navigator.md` for step-by-step guidance.
4. **Dive into evidence** — For specific questions, read the evidence analysis documents. For deep dives, read individual team submissions in `evidence-pool/TheKataLog/`.
5. **Spin up parallel agents** — For broad research queries (like real-world-aspnetcore does), launch parallel agents to search across multiple submissions simultaneously.
6. **Synthesize with citations** — Every recommendation must cite specific projects, placements, and data points. No unsupported claims.

### Data access strategy

The core design tension: the skill's value comes from the data (~2.2 GB across all evidence sources), but a remote skill installation should be lightweight.

**Resolution: three operating modes determined by what data is available.**

| Mode | When | Capabilities | Data Required |
|------|------|-------------|---------------|
| **Full** | Inside `architecture-reference-repo` checkout | All evidence search, deep dives into team submissions, parallel agent research | Full repo clone |
| **Library** | Repo cloned but without evidence-pool (sparse checkout or shallow clone) | Catalog search, reference library, cross-source analysis | `evidence-analysis/` + `docs/` (~700 KB) |
| **Standalone** | SKILL.md only (remote install without repo clone) | Key findings, decision logic, offline reference data | Just the SKILL.md (~8 KB) |

The SKILL.md is designed so that each mode degrades gracefully. The embedded "Offline Reference" section contains the most critical data points — architecture style rankings, the winning formula, quality attribute correlations, and the scalability trap — so even a standalone install provides actionable guidance.

**How data is located at runtime:**

The SKILL.md instructs the agent to locate data using this resolution order:

1. **Relative paths** — Check `../../evidence-analysis/` and `../../docs/` (works when skill is at `skills/architecture-advisor/` within the source repo).
2. **Repository root** — Check if the current working directory IS the architecture-reference-repo (has `evidence-analysis/TheKataLog/docs/catalog/_index.yaml`).
3. **Common checkout locations** — Check `~/src/architecture-reference-repo/`, `~/architecture-reference-repo/`.
4. **Ask the user** — If not found, ask the user for the path to their local clone.
5. **Fall back to offline reference** — If no local data is available, use the key findings embedded directly in the SKILL.md.

### Directory structure

```
skills/
  architecture-advisor/
    SKILL.md          # Skill definition with frontmatter + agent instructions
```

Deliberately minimal. The skill is a single file — matching the real-world-aspnetcore pattern. All data lives in the repository's existing `evidence-analysis/`, `docs/`, and `evidence-pool/` directories, accessed via runtime path resolution.

### Remote installation

#### How it works

A consumer repo with the remote-skill-manager installed would fetch this skill as:

```bash
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/architecture-advisor \
  main \
  .agents/skills
```

The `fetch-remote-skill.sh` script:
1. Shallow-clones the repository at the specified ref
2. Validates that `skills/architecture-advisor/SKILL.md` exists
3. Copies the `architecture-advisor/` directory to `.agents/skills/architecture-advisor/`
4. Removes any upstream `.source.yml` (we don't ship one)
5. Computes a SHA-256 integrity digest of the skill directory contents
6. Generates a `.source.yml` provenance manifest

This would produce:

```
.agents/skills/
  architecture-advisor/
    SKILL.md              # Copied from source
    .source.yml           # Generated by fetch script (provenance manifest)
```

#### Example `.source.yml` (generated at install time)

```yaml
# .source.yml — Remote skill provenance manifest
# Machine-generated by fetch-remote-skill.sh. Do not edit manually.
# Schema: ADR-002-Remote-Skills-Reference-Pattern

source:
  repository: https://github.com/cristoslc/architecture-reference-repo
  ref: main
  commit: abc123def456...  # actual 40-char SHA
  path: skills/architecture-advisor

skill:
  name: architecture-advisor

fetched:
  at: "2026-02-27T14:30:00Z"
  by: fetch-remote-skill.sh

integrity:
  algorithm: sha256
  digest: 9f86d08...  # actual 64-char hex
```

#### Lifecycle operations

| Operation | Command | What happens |
|-----------|---------|-------------|
| **Install** | `bash scripts/fetch-remote-skill.sh <repo> skills/architecture-advisor main .agents/skills` | Fetches skill, generates `.source.yml` |
| **Update** | Re-run the same fetch command | Overwrites files, regenerates `.source.yml` with new timestamp and commit |
| **Pin to version** | Use a tag or commit SHA as the `ref` argument | `fetch-remote-skill.sh <repo> skills/architecture-advisor v1.0.0` |
| **Check drift** | Compare integrity digest | `tar cf - --exclude='.source.yml' -C .agents/skills architecture-advisor \| sha256sum` vs `.source.yml` digest |
| **Customize locally** | Delete `.source.yml` | Skill becomes locally-owned; drift detection no longer applies |
| **Remove** | `rm -rf .agents/skills/architecture-advisor` | No other cleanup needed |

### Compatibility with remote-skill-manager pattern

| Requirement | How This Skill Satisfies It |
|-------------|---------------------------|
| Skill lives at a well-known path | `skills/architecture-advisor/` in source repo |
| Contains a valid `SKILL.md` | Yes, with proper YAML frontmatter (`name`, `description`, `license`, `allowed-tools`) |
| No `.source.yml` in source | Correct — `.source.yml` is consumer-generated at install time |
| Self-contained enough to be meaningful when fetched | Yes — SKILL.md embeds key findings, decision logic, and an offline reference section |
| Integrity-hashable | Yes — single file, deterministic content |
| `basename` of skill-path becomes install directory name | `skills/architecture-advisor` → installed as `architecture-advisor/` |

### What the consumer gets at each access level

**Standalone (just the fetched SKILL.md):**
- Architecture style rankings with placement-weighted scores for 7 styles
- The "winning formula" (2+ styles, 15+ ADRs, feasibility analysis, fitness functions, phased evolution)
- Quality attribute correlations with placement
- The "Scalability Trap" insight
- Cross-source validation summary (kata findings confirmed by AOSA and production systems)
- Enough to answer "which architecture style should I use?" with data-backed recommendations

**With a local clone of the repo (full or sparse):**
- Everything above, plus:
- Searchable YAML catalogs for 34 kata teams, 12 AOSA projects, 5 .NET apps, 8 reference implementations
- Per-challenge comparative analyses
- Step-by-step decision navigator
- Templates (ADR guide, C4 guide, feasibility guide, fitness functions, kata checklist)
- Deep evidence dives into individual team submissions (full clone only)

## Trade-offs considered

### Why a single SKILL.md instead of bundling data files?

- The YAML catalog (~200 KB across 66 files across 4 sources) could be bundled, but it creates a maintenance burden: the skill directory would need to stay in sync with the catalogs as new evidence is added.
- The real-world-aspnetcore pattern proves that runtime path resolution works well.
- A single file is trivially fetchable, hashable, and diffable.
- The embedded offline reference provides the 80/20 value without bundling anything.

### Why not use GitHub API for remote data access?

- Rate limits make it unreliable for deep research (reading dozens of team submissions).
- Network dependency makes it fragile.
- A local clone of the repo (even sparse) is faster and more reliable.
- The SKILL.md can mention GitHub as a fallback, but shouldn't depend on it.

### Why not make the skill a Claude Code custom slash command?

- Slash commands are tied to a specific repository's `.claude/` configuration.
- A skill in `skills/` is portable — any tool that reads SKILL.md files can use it.
- The remote-skill-manager pattern is designed for skills, not slash commands.

### Why `skills/` in source but `.agents/skills/` in consumer?

The source path (`skills/architecture-advisor/`) and the consumer's install path (`.agents/skills/architecture-advisor/`) don't need to match. The fetch script uses `basename` to derive the directory name — only `architecture-advisor` matters. The source repo uses `skills/` as a top-level directory because it's a simpler convention for a repo whose primary purpose includes publishing skills. Consumers use `.agents/skills/` because that's the convention for agent-local skill installations.

### Why embed an offline reference in the SKILL.md?

Most remote installs will not have the full repository cloned. Without the offline reference, the skill would be useless in standalone mode — just instructions pointing at data that isn't there. The embedded reference makes the skill immediately useful even without any local data, covering the most common questions about architecture style selection and quality attribute trade-offs. This is the key design choice that makes remote installation practical rather than just theoretically possible.

## Versioning strategy

The SKILL.md frontmatter includes a `version` field. The recommended approach:

| Scenario | Version bump | Example |
|----------|-------------|---------|
| Offline reference data updated (new kata season, new evidence source) | Minor | 1.0.0 → 1.1.0 |
| New research methodology or question categories added | Minor | 1.1.0 → 1.2.0 |
| Frontmatter schema change or breaking path changes | Major | 1.2.0 → 2.0.0 |
| Typo fixes, wording improvements | Patch | 1.0.0 → 1.0.1 |

Consumers who pin to a ref (tag or commit) via the fetch script control their own update cadence. Consumers who fetch `main` get the latest.

## Testing strategy

### Local testing

Verify the skill works in all three modes:

1. **Full mode** — Run from within the `architecture-reference-repo` checkout. Ask an architecture question and verify the agent finds and cites evidence from the catalogs and reference library.
2. **Library mode** — Clone the repo without `evidence-pool/` (sparse checkout). Verify the agent uses catalog data and reference library docs but gracefully handles missing team submissions.
3. **Standalone mode** — Copy just the `SKILL.md` to an empty directory. Verify the agent uses the offline reference and doesn't error when it can't find local data.

### Remote fetch testing

Verify compatibility with the remote-skill-manager:

```bash
# From any repo with remote-skill-manager installed:
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/architecture-advisor \
  main \
  /tmp/test-skills

# Verify:
test -f /tmp/test-skills/architecture-advisor/SKILL.md    # Skill fetched
test -f /tmp/test-skills/architecture-advisor/.source.yml  # Provenance generated
grep -q "architecture-advisor" /tmp/test-skills/architecture-advisor/.source.yml  # Name matches

# Verify integrity:
DIGEST=$(grep 'digest:' /tmp/test-skills/architecture-advisor/.source.yml | awk '{print $2}')
FRESH=$(tar cf - --exclude='.source.yml' -C /tmp/test-skills architecture-advisor | sha256sum | cut -d' ' -f1)
[ "$DIGEST" = "$FRESH" ] && echo "Integrity OK" || echo "Integrity FAIL"
```

## What's included in this proposal

| File | Purpose |
|------|---------|
| `docs/proposals/skill-design-proposal.md` | This document — design rationale, remote-install mechanics, and trade-off analysis |
| `skills/architecture-advisor/SKILL.md` | Skill definition implementing this design, ready for testing and iteration |
