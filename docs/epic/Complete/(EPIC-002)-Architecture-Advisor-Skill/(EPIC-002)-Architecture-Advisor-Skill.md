---
title: "Architecture Advisor Skill"
artifact: EPIC-002
status: Complete
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
parent-vision: VISION-001
success-criteria:
  - Skill passes Agent Skills spec compliance (valid SKILL.md with frontmatter, scripts/, references/ convention)
  - Sparse-clone sync script works for both default and evidence-pool modes
  - Skill installable via remote-skill-manager fetch workflow
  - Dual provenance tracking works (skill provenance via .source.yml, data provenance via .sync-state.yml)
  - Skill provides useful architecture guidance at all three sync levels (offline, default, evidence-pool)
depends-on: []
---

# Architecture Advisor Skill

## Goal / Objective

Build a remote-installable agent skill that exposes the evidence-based architecture reference library as an AI-consumable capability. The skill follows the [Agent Skills specification](https://agentskills.io/specification) and is installable into external repos via the remote-skill-manager pattern. It uses sparse-clone data fetching for progressive disclosure — from an embedded offline reference (zero network) to full evidence-pool access (2.2 GB).

## Scope Boundaries

### In scope

- **SKILL.md definition:** Frontmatter, activation triggers, research methodology instructions, offline reference data, path resolution logic
- **Sync script:** `scripts/sync-references.sh` implementing sparse-clone with two modes (default ~1 MB, evidence-pool ~2.2 GB)
- **Data resolution:** Multi-step path resolution (references/ -> source repo relative paths -> common checkout locations -> ask user -> offline fallback)
- **Provenance tracking:** `.sync-state.yml` for data provenance (separate from `.source.yml` skill provenance)
- **Remote installation workflow:** Compatibility with `fetch-remote-skill.sh` from remote-skill-manager
- **Progressive disclosure:** Metadata at startup, instructions on activation, reference files on demand

### Out of scope

- The `/discover-architecture` classification skill (see EPIC-003)
- ML-based architecture classification
- Community contribution pipeline
- Custom UI or web interface

## Prior Art

This epic is adapted from the Architecture Advisor Remote Skill proposal, which provides the full design including directory structure, sparse-clone mechanics, sync modes, provenance tracking, versioning strategy, and testing approach.

### Reference implementations studied

| Skill | Key Pattern |
|-------|-------------|
| real-world-aspnetcore | Research skill that searches 28 curated apps, spins up parallel agents, reads actual code. Data location resolved at runtime. |
| remote-skill-manager | Meta-skill for fetching skills from remote Git repos with provenance tracking, integrity hashing, drift detection. |

### Evidence base served

| Source | Projects | What it provides |
|--------|----------|------------------|
| O'Reilly Architecture Katas | 34 placing teams | Competition submissions with ADRs, C4 diagrams, feasibility analyses |
| AOSA | 12 production systems | Detailed narratives from system creators |
| Real-World ASP.NET Core | 5 production apps | Production codebases (Bitwarden, Jellyfin, nopCommerce, etc.) |
| Reference Architectures | 8 curated implementations | Working, deployable code for canonical patterns |

## Child Specs

_Updated as Agent Specs are created under this epic._

None yet.

## Key Dependencies

None. EPIC-001 (Dataset Expansion) provided the 4-source evidence base this skill serves.

## Outcome

The skill is fully implemented at `skills/architecture-advisor/`:

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition with frontmatter, research methodology, offline reference, path resolution |
| `scripts/sync-references.sh` | Sparse-clone script with default (<1 MB) and evidence-pool (~2.2 GB) modes |
| `scripts/smoke-test.sh` | End-to-end verification of sync workflow (6 test suites, 25+ checks) |
| `.gitignore` | Excludes `references/` (populated at runtime) |

The companion `skills/remote-skill-manager/` provides `fetch-remote-skill.sh` for remote installation with provenance tracking and integrity hashing.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-03 | 6883447 | Adapted from skill-design-proposal.md proposal |
| Complete | 2026-03-03 | 3bc4437 | All success criteria met; skill fully implemented with SKILL.md, sync script, and smoke tests |
