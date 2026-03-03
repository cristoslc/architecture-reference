# Proposal: Architecture Advisor Remote Skill

## Summary

Design a skill for `architecture-reference-repo` that exposes the evidence-based architecture reference library as an agent-consumable capability — installable remotely into other repositories via the [remote-skill-manager](https://github.com/cristoslc/LLM-personal-agent-patterns/tree/main/L3-agents-standalone/.agents/skills/remote-skill-manager) pattern. The skill uses a sparse clone to fetch its reference data from GitHub on first use, with on-demand full snapshots for deeper research, following the [Agent Skills specification](https://agentskills.io/specification) `references/` convention.

## Background

### What is a skill?

A skill is a directory containing a `SKILL.md` file with YAML frontmatter and natural-language instructions. When an agent reads the `SKILL.md`, it learns what the skill does, when to activate it, and how to execute it. The [Agent Skills spec](https://agentskills.io/specification) defines optional directories (`scripts/`, `references/`, `assets/`) that support the skill with executable code and additional data.

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

5. **The fetch script copies the entire skill directory.** `fetch-remote-skill.sh` copies everything in the skill directory — `SKILL.md`, `scripts/`, `references/`, and any other files. A skill with a `scripts/` directory gets those scripts installed alongside the SKILL.md, ready to run.

6. **Integrity hashing excludes provenance metadata.** The SHA-256 digest covers `tar cf - --exclude='.source.yml'` of the skill directory. This means the skill's code and content — not its installation metadata — is what gets verified. The `references/` directory, being populated after install, is not part of the initial integrity hash.

### What the Agent Skills spec says about `references/`

From the [specification](https://agentskills.io/specification#references%2F):

> Contains additional documentation that agents can read when needed [...] Keep individual reference files focused. Agents load these on demand, so smaller files mean less use of context.

The spec recommends progressive disclosure: metadata (~100 tokens) at startup, instructions (<5000 tokens) on activation, and reference files only when needed. Our `references/` directory follows this pattern — it's populated on demand and loaded file-by-file during research.

## Design

### Skill: `architecture-advisor`

**Purpose:** Given an architecture problem, question, or kata challenge, search the evidence library to provide data-driven recommendations grounded in what actually worked across 276 architecture projects from five complementary sources.

**Location:** `skills/architecture-advisor/`

### Evidence base

The skill draws on five evidence sources, each offering a different lens on architecture:

| Source | Projects | What it provides |
|--------|----------|------------------|
| O'Reilly Architecture Katas | 34 placing teams across 11 challenges | Competition submissions with ADRs, C4 diagrams, feasibility analyses, fitness functions |
| Architecture of Open Source Applications (AOSA) | 12 production systems | Detailed narratives from the architects who built NGINX, Git, Selenium, etc. |
| Real-World ASP.NET Core | 5 production .NET apps | Production codebases (Bitwarden, Jellyfin, nopCommerce, Orchard Core, Squidex) |
| Reference Architectures | 8 curated implementations | Working, deployable code for canonical patterns (eShop, modular monolith, clean arch, etc.) |
| Discovered | 173 open-source repos | Automated architecture classification from structural signals (Docker, APIs, message queues, directory structure) with LLM review. Covers all 12 canonical styles. |

### Directory structure

```
skills/
  architecture-advisor/
    SKILL.md                        # Skill definition + offline reference
    scripts/
      sync-references.sh           # Sparse-clone and snapshot script
    references/                    # NOT checked in; populated by sync script
      .sync-state.yml              # Provenance: commit, timestamp, mode
      reference-library/           # Core docs (always synced)
      catalogs/                    # YAML catalogs per source
        TheKataLog/
        AOSA/
        RealWorldASPNET/
        ReferenceArchitectures/
      analysis/                    # Per-source analyses
        TheKataLog/
        AOSA/
        RealWorldASPNET/
        ReferenceArchitectures/
      templates/                   # Practitioner guides
      evidence-pool/               # Full team submissions (--evidence-pool only)
```

The `references/` directory is `.gitignore`d in the source repo and absent from the fetched skill. It is populated at runtime by `scripts/sync-references.sh`.

### How the sparse clone works

The sync script (`scripts/sync-references.sh`) uses git's sparse-checkout feature to fetch only the needed paths from the source repository:

```bash
# 1. Treeless partial clone (downloads tree objects on demand, no blobs upfront)
git clone --depth 1 --filter=blob:none --sparse <repo-url> /tmp/clone

# 2. Configure sparse-checkout to materialize needed paths
git sparse-checkout set \
  docs/reference-library \
  docs/templates \
  evidence-analysis/TheKataLog/docs/catalog \
  evidence-analysis/TheKataLog/docs/analysis \
  evidence-analysis/AOSA/docs/catalog \
  evidence-analysis/AOSA/docs/analysis \
  evidence-analysis/RealWorldASPNET/docs/catalog \
  evidence-analysis/RealWorldASPNET/docs/analysis \
  evidence-analysis/ReferenceArchitectures/docs/catalog \
  evidence-analysis/ReferenceArchitectures/docs/analysis

# 3. For --evidence-pool mode, also add:
#    evidence-pool/TheKataLog

# 4. Copy materialized files into references/, flattening the catalog/analysis paths
# 5. Record the commit SHA and timestamp in references/.sync-state.yml
# 6. Clean up the temporary clone
```

### Two sync modes

| Mode | Command | What it fetches | Size |
|------|---------|----------------|------|
| **Default** | `bash scripts/sync-references.sh` | Reference library, all 66 YAML catalogs, per-challenge analyses, cross-cutting analysis, templates | <1 MB |
| **Evidence pool** | `bash scripts/sync-references.sh --evidence-pool` | Default + entire evidence pool (34 team submissions with ADRs, diagrams, transcripts) | ~2.2 GB |

Both modes are idempotent — re-running updates the references to the latest upstream commit and refreshes `.sync-state.yml`.

### Provenance tracking

The sync script writes `references/.sync-state.yml` to record what was fetched:

```yaml
# .sync-state.yml — Reference data provenance
# Machine-generated by sync-references.sh. Do not edit manually.

source:
  repository: https://github.com/cristoslc/architecture-reference-repo
  ref: main
  commit: abc123def456...  # 40-char SHA

sync:
  mode: default
  at: "2026-02-27T14:30:00Z"
  by: sync-references.sh

contents:
  - reference-library
  - templates
  - catalogs
  - analysis
```

This is analogous to `.source.yml` for the skill itself (generated by remote-skill-manager), but tracks the *data* provenance rather than the *skill* provenance.

### Data resolution order

The SKILL.md instructs the agent to find data using this precedence:

1. **`references/`** — The skill's own synced reference data (primary for remote installs)
2. **Source repo relative paths** — `../../evidence-analysis/` and `../../docs/` (when running inside the source repo)
3. **Current working directory** — Check if the user is working inside a clone of the source repo
4. **Common checkout locations** — `~/src/architecture-reference-repo/`, `~/architecture-reference-repo/`
5. **Ask the user** — Prompt for the path to their local clone
6. **Offline reference** — Key findings embedded directly in the SKILL.md

The agent checks `references/` first. If it doesn't exist, it runs `bash scripts/sync-references.sh` before continuing. This makes the skill self-bootstrapping.

### What happens at each stage

**After remote-skill-manager install (no sync yet):**

```
.agents/skills/architecture-advisor/
  SKILL.md              # Includes offline reference (style rankings, winning formula, etc.)
  scripts/
    sync-references.sh  # Ready to run
  .source.yml           # Provenance from remote-skill-manager
```

The agent can answer basic questions ("which architecture style should I use?") using the embedded offline reference data.

**After `bash scripts/sync-references.sh` (default sync):**

```
.agents/skills/architecture-advisor/
  SKILL.md
  scripts/sync-references.sh
  .source.yml
  references/
    .sync-state.yml
    reference-library/
      README.md
      solution-spaces.md
      problem-spaces.md
      problem-solution-matrix.md
      decision-navigator.md
      evidence/
        by-architecture-style.md
        by-quality-attribute.md
        cross-source-reference.md
        cross-source-analysis.md
    templates/
      adr-guide.md
      c4-guide.md
      feasibility-guide.md
      fitness-functions-guide.md
      kata-checklist.md
      architecture-selection-guide.md
    catalogs/
      TheKataLog/   (34 YAML files + _index.yaml)
      AOSA/         (12 YAML files + _index.yaml)
      RealWorldASPNET/   (5 YAML files + _index.yaml)
      ReferenceArchitectures/  (8 YAML files + _index.yaml)
    analysis/
      TheKataLog/
        challenges/   (11 per-challenge analyses)
        cross-cutting.md
      AOSA/source-analysis.md
      RealWorldASPNET/source-analysis.md
      ReferenceArchitectures/source-analysis.md
```

The agent can read the full reference library, search YAML catalogs, read per-challenge comparative analyses, and provide templates.

**After `bash scripts/sync-references.sh --evidence-pool`:**

```
  references/
    ...everything above...
    evidence-pool/
      2020-Farmacy-Food/ArchColider/   (1st place)
      2020-Farmacy-Food/Myagis-Forests/ (2nd place)
      ...34 team directories total...
```

The agent can deep-dive into individual team submissions.

## Remote installation workflow

### Step 1: Fetch the skill

```bash
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/architecture-advisor \
  main \
  .agents/skills
```

This installs `SKILL.md` + `scripts/` + `.source.yml`. No `references/` yet.

### Step 2: Agent auto-syncs on first use

When the agent activates the skill and sees no `references/` directory, the SKILL.md instructs it to run:

```bash
bash scripts/sync-references.sh
```

This sparse-clones the source repo and populates `references/reference-library/`.

### Step 3: Evidence pool on demand

When a question requires reading individual team submissions (ADRs, C4 diagrams, video transcripts), the agent offers to run:

```bash
bash scripts/sync-references.sh --evidence-pool
```

### Step 4: Update

To pull the latest data from the source repository:

```bash
bash scripts/sync-references.sh --status     # Check current state
bash scripts/sync-references.sh              # Re-sync references
```

### Integrity and drift

Two independent provenance systems coexist:

| Layer | File | Tracks | Who generates it |
|-------|------|--------|-----------------|
| **Skill provenance** | `.source.yml` | Where the SKILL.md + scripts came from | remote-skill-manager (at install time) |
| **Data provenance** | `references/.sync-state.yml` | Where the reference data came from | sync-references.sh (at sync time) |

The skill and its data can be at different commits. This is by design — the skill's instructions (SKILL.md) change less frequently than the evidence data. A consumer can update their reference data without re-fetching the skill, or vice versa.

Drift detection for the skill itself works exactly as before (SHA-256 of the skill directory, excluding `.source.yml`). Note that `references/` IS included in the hash if it exists at the time of the integrity check, so consumers should be aware that syncing references will change the skill's integrity digest.

## Compatibility with remote-skill-manager pattern

| Requirement | How This Skill Satisfies It |
|-------------|---------------------------|
| Skill lives at a well-known path | `skills/architecture-advisor/` in source repo |
| Contains a valid `SKILL.md` | Yes, with proper YAML frontmatter per Agent Skills spec |
| No `.source.yml` in source | Correct — `.source.yml` is consumer-generated at install time |
| Self-contained enough to be meaningful when fetched | Yes — SKILL.md embeds offline reference; scripts enable self-bootstrapping |
| Additional directories copied by fetch script | Yes — `scripts/` is copied alongside SKILL.md |
| `references/` not in source | Correct — populated by sync script after install, not shipped |
| `basename` of skill-path becomes install directory name | `skills/architecture-advisor` → installed as `architecture-advisor/` |

## Compatibility with Agent Skills spec

| Spec Requirement | How This Skill Satisfies It |
|-----------------|---------------------------|
| `SKILL.md` with YAML frontmatter | Yes — `name`, `description`, `license`, `allowed-tools`, `metadata` |
| `name` matches directory name | `architecture-advisor` matches `skills/architecture-advisor/` |
| `scripts/` for executable code | `scripts/sync-references.sh` — self-contained, documents dependencies, handles errors |
| `references/` for additional documentation | Populated by sync script with focused, file-per-topic reference documents |
| Progressive disclosure | Metadata → SKILL.md instructions → reference files → catalogs → evidence pool |
| SKILL.md under 500 lines | ~250 lines; detailed reference data in separate files |

## Trade-offs considered

### Why sparse-clone + references/ instead of a single SKILL.md?

The previous design (v1) embedded a static "Offline Reference" in the SKILL.md and relied on the user having a local clone of the repo for anything deeper. This works but limits remote installs to a small, hand-maintained subset of the evidence.

The sparse-clone approach:
- **Self-bootstrapping** — the skill can fetch its own data from GitHub without requiring the user to manually clone the repo
- **Progressive** — starts lightweight, scales up on demand
- **Updateable** — re-running the sync script pulls latest data
- **Spec-compliant** — follows the Agent Skills `references/` convention and progressive disclosure pattern
- **Decoupled** — skill code and skill data can be versioned independently

The trade-off is added complexity: the skill now has a script dependency (`git` must be available) and a network dependency (GitHub must be reachable for the initial sync). Both are acceptable — `git` is effectively universal in development environments, and the sync only runs once (then the data is local).

### Why keep the offline reference in the SKILL.md?

Even with the sync script, there are scenarios where the agent can't or shouldn't run it:
- No network access (air-gapped environments)
- The user declines the tool permission prompt for `bash`
- The sync script fails (GitHub rate limit, network issue)

The embedded offline reference ensures the skill always has some value, even in the worst case.

### Why not persist the sparse checkout instead of copy-and-clean?

Keeping the sparse checkout as a persistent git repo in `references/` would make updates trivial (`git pull`) but creates problems:
- A nested `.git` directory inside the consumer's repo causes confusion
- The consumer's git commands might accidentally operate on the wrong repo
- `.gitignore` handling becomes complex

The copy-and-clean approach is slightly slower for updates (re-clones instead of pulling) but cleaner and more predictable.

### Why not use GitHub API instead of sparse clone?

- Rate limits (60 requests/hour unauthenticated) make it unreliable for fetching dozens of files
- The sparse-checkout approach downloads only the blobs it needs, which is often faster than multiple API calls
- A local clone works offline after the initial sync

### Why `skills/` in source but `.agents/skills/` in consumer?

The source path (`skills/architecture-advisor/`) and the consumer's install path (`.agents/skills/architecture-advisor/`) don't need to match. The fetch script uses `basename` to derive the directory name — only `architecture-advisor` matters. The source repo uses `skills/` as a top-level directory because it's a simpler convention for a repo whose primary purpose includes publishing skills. Consumers use `.agents/skills/` because that's the convention for agent-local skill installations.

## Versioning strategy

The SKILL.md frontmatter includes a `version` field. The recommended approach:

| Scenario | Version bump | Example |
|----------|-------------|---------|
| Offline reference data updated (new kata season, new evidence source) | Minor | 2.0.0 → 2.1.0 |
| New research methodology or question categories added | Minor | 2.1.0 → 2.2.0 |
| Breaking changes to references/ structure or sync script interface | Major | 2.2.0 → 3.0.0 |
| Typo fixes, wording improvements | Patch | 2.0.0 → 2.0.1 |

The skill version tracks the SKILL.md + scripts. The data version is tracked separately in `references/.sync-state.yml` (by commit SHA). Consumers who pin to a ref (tag or commit) via the fetch script control their own update cadence.

## Testing strategy

### Local testing

Verify the skill works at each sync level:

1. **No sync** — Delete `references/`. Ask an architecture question. Verify the agent attempts to run `sync-references.sh` or falls back to the offline reference.
2. **Default sync** — Run `sync-references.sh`. Verify `references/reference-library/`, `references/catalogs/`, `references/analysis/`, and `references/templates/` are populated. Ask a question that requires searching YAML catalogs.
3. **Evidence pool sync** — Run `sync-references.sh --evidence-pool`. Verify evidence pool is present. Ask for a deep dive into a specific team's ADRs.
4. **Update** — Re-run sync. Verify `.sync-state.yml` is updated with a new timestamp.

### Remote fetch testing

```bash
# 1. Fetch the skill
bash .agents/skills/remote-skill-manager/scripts/fetch-remote-skill.sh \
  https://github.com/cristoslc/architecture-reference-repo \
  skills/architecture-advisor \
  main \
  /tmp/test-skills

# 2. Verify structure
test -f /tmp/test-skills/architecture-advisor/SKILL.md                    # Skill fetched
test -f /tmp/test-skills/architecture-advisor/scripts/sync-references.sh  # Script fetched
test -x /tmp/test-skills/architecture-advisor/scripts/sync-references.sh  # Script executable
test -f /tmp/test-skills/architecture-advisor/.source.yml                 # Provenance generated
test ! -d /tmp/test-skills/architecture-advisor/references                # No references yet

# 3. Verify sync works
cd /tmp/test-skills/architecture-advisor
bash scripts/sync-references.sh
test -d references/reference-library  # References populated
test -f references/.sync-state.yml    # Sync state recorded

# 4. Verify full sync
test -d references/catalogs/TheKataLog  # Catalogs populated
test -d references/analysis/TheKataLog  # Analyses populated
test -d references/templates            # Templates populated
```

## What's included in this proposal

| File | Purpose |
|------|---------|
| `docs/proposals/skill-design-proposal.md` | This document — design rationale, sparse-clone mechanics, and trade-off analysis |
| `skills/architecture-advisor/SKILL.md` | Skill definition with offline reference, sync instructions, and path mapping |
| `skills/architecture-advisor/scripts/sync-references.sh` | Sparse-clone script that fetches reference data into `references/` |
