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

## Design

### Skill: `architecture-advisor`

**Purpose:** Given an architecture problem, question, or kata challenge, search the evidence pool and reference library to provide data-driven recommendations grounded in what actually worked across 78 O'Reilly Architecture Kata submissions.

**Location:** `skills/architecture-advisor/SKILL.md`

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
2. **Search structured data first** — Query the YAML catalog files (`docs/catalog/*.yaml`) for teams matching the problem profile. These are small, structured, and fast to scan.
3. **Consult the reference library** — Read `solution-spaces.md` for placement-weighted scores, `problem-solution-matrix.md` for dimension-to-style mappings, and `decision-navigator.md` for step-by-step guidance.
4. **Dive into evidence** — For specific questions, read `evidence/by-architecture-style.md` or `evidence/by-quality-attribute.md`. For deep dives, read individual team submissions in `evidence-pool/TheKataLog/`.
5. **Spin up parallel agents** — For broad research queries (like real-world-aspnetcore does), launch parallel agents to search across multiple team submissions simultaneously.
6. **Synthesize with citations** — Every recommendation must cite specific teams, placements, and data points. No unsupported claims.

### Data access strategy

The core design tension: the skill's value comes from the data (2.2 GB across 78 team submissions), but a remote skill installation should be lightweight.

**Resolution: tiered access.**

| Tier | Data | Size | Access Method |
|------|------|------|---------------|
| 1 — Catalog | `docs/catalog/*.yaml` + `_index.yaml` | ~200 KB | Bundled with skill OR resolved locally |
| 2 — Reference Library | `docs/reference-library/`, `docs/analysis/`, `docs/templates/` | ~500 KB | Resolved locally from repo checkout |
| 3 — Evidence Pool | `evidence-pool/TheKataLog/` (78 team folders) | ~2.2 GB | Resolved locally; optional for remote installs |

**How data is located at runtime:**

The SKILL.md instructs the agent to locate the architecture-reference-repo data directory using this resolution order:

1. **Relative paths** — Check `../../docs/` and `../../evidence-pool/` (works when skill is at `skills/architecture-advisor/` within the repo).
2. **Repository root** — Check if the current working directory IS the architecture-reference-repo (has `docs/catalog/_index.yaml`).
3. **Common checkout locations** — Check `~/src/architecture-reference-repo/`, `~/architecture-reference-repo/`.
4. **Ask the user** — If not found, ask the user for the path to their local clone.

For remote installations where the full repo is not cloned, the agent can still provide value from the SKILL.md's embedded summary of key findings and the decision navigator logic. The SKILL.md includes a condensed version of the most critical data points.

### Directory structure

```
skills/
  architecture-advisor/
    SKILL.md          # Skill definition with frontmatter + agent instructions
```

Deliberately minimal. The skill is a single file — matching the real-world-aspnetcore pattern. All data lives in the repository's existing `docs/` and `evidence-pool/` directories, accessed via runtime path resolution.

### Remote installation

A consumer repo with the remote-skill-manager installed would fetch this skill as:

```bash
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/architecture-advisor \
  main \
  .agents/skills
```

This would produce:

```
.agents/skills/
  architecture-advisor/
    SKILL.md              # Copied from source
    .source.yml           # Generated by fetch script (provenance manifest)
```

The `.source.yml` enables:
- **Provenance** — Where the skill came from, when, which commit
- **Drift detection** — Has the local copy been modified?
- **Updates** — Re-run the fetch script to pull the latest version

### Compatibility with remote-skill-manager pattern

| Requirement | How This Skill Satisfies It |
|-------------|---------------------------|
| Skill lives at a well-known path | `skills/architecture-advisor/` |
| Contains a valid `SKILL.md` | Yes, with proper YAML frontmatter |
| No `.source.yml` in source | Correct — `.source.yml` is consumer-generated |
| Self-contained enough to be meaningful when fetched | Yes — SKILL.md includes embedded key findings and decision logic |
| Integrity-hashable | Yes — single file, deterministic content |

## Trade-offs considered

### Why a single SKILL.md instead of bundling data files?

- The YAML catalog (~200 KB across 80 files) could be bundled, but it creates a maintenance burden: the skill directory would need to stay in sync with the catalog.
- The real-world-aspnetcore pattern proves that runtime path resolution works well.
- A single file is trivially fetchable, hashable, and diffable.

### Why not use GitHub API for remote data access?

- Rate limits make it unreliable for deep research (reading dozens of team submissions).
- Network dependency makes it fragile.
- A local clone of the repo (even sparse) is faster and more reliable.
- The SKILL.md can mention GitHub as a fallback, but shouldn't depend on it.

### Why not make the skill a Claude Code custom slash command?

- Slash commands are tied to a specific repository's `.claude/` configuration.
- A skill in `skills/` is portable — any tool that reads SKILL.md files can use it.
- The remote-skill-manager pattern is designed for skills, not slash commands.

## What's included in this proposal

| File | Purpose |
|------|---------|
| `docs/proposals/skill-design-proposal.md` | This document — design rationale and trade-off analysis |
| `skills/architecture-advisor/SKILL.md` | Draft skill definition, ready for testing and iteration |
