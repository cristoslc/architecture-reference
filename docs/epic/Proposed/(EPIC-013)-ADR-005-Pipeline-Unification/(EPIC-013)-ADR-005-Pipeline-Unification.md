---
title: "ADR-005 Pipeline Unification"
artifact: EPIC-013
status: Proposed
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-vision: VISION-001
success-criteria:
  - All pipeline classification paths (Claude subagent, non-Anthropic via llm CLI) derive their instructions from the discover skill's SKILL.md and references/ — no standalone system prompts
  - catalog-entry.template.j2 exists in the discover skill and defines the canonical YAML schema for all catalog entries
  - All 184+ catalog entries are reclassified via the discover skill, producing both markdown reports and YAML catalog entries conforming to the unified schema
  - Legacy prompt files (system-prompt-tooluse.md, system-prompt.md, response-schema.json) and bespoke parsing scripts (apply-review.py, apply-tooluse-result.py) are retired
  - SPEC-003 (Comparative Analysis Engine) can proceed — its precondition of uniform catalog schema fields is satisfied
depends-on:
  - ADR-005
addresses: []
evidence-pool: ""
---

# ADR-005 Pipeline Unification

## Goal / Objective

Implement the decision captured in ADR-005: make the discover skill the single specification governing all pipeline architecture classification. Today the decision is adopted but not yet implemented — the pipeline still maintains separate system prompts, separate output parsers, and catalog entries produced by pre-ADR-005 mechanisms. This epic closes the gap between the architectural decision and the running system.

The end state: one specification (the discover skill), one output schema (catalog-entry.template.j2), one methodology shared by Claude subagents and non-Anthropic models alike. Every catalog entry conforms to the unified schema, enabling SPEC-003's comparative analysis to proceed on uniform data.

## Scope Boundaries

### In scope

- **Template creation** — design and implement `references/catalog-entry.template.j2` in the discover skill, defining the canonical YAML catalog entry schema (`architecture_styles`, `domain`, `scope`, `use_type`, `quality_attributes`, `classification_confidence`, `classification_method`, `classification_model`, `classification_date`, `classification_reasoning`, `classification_status`)
- **Runtime prompt assembly** — update pipeline scripts (`classify-tooluse.sh` or successors) to read the discover skill's `SKILL.md` + `references/styles.md` + `references/catalog-entry.template.j2` at invocation time, instead of maintaining separate prompt files
- **Full catalog reclassification** — reclassify all 184+ catalog entries using the discover skill as the governing specification, producing dual output (markdown report + YAML catalog entry) per ADR-005
- **Legacy retirement** — remove or archive `prompts/system-prompt-tooluse.md`, `prompts/system-prompt.md`, `prompts/response-schema.json`, `apply-review.py`, `apply-tooluse-result.py`
- **Schema validation** — verify all reclassified catalog entries parse against the template schema and contain the fields SPEC-003 requires
- **Discover skill updates** — any light adaptations to the skill's `SKILL.md` needed for batch/pipeline contexts (without creating a fork)

### Out of scope

- Changes to the discover skill's classification methodology (styles, evidence criteria, analysis steps) — that's SPEC-001 territory
- Scaling to new repos beyond the current 184 — that's SPEC-002 / future scaling work
- Building the comparative analysis engine itself — that's SPEC-003, which this epic unblocks
- Model selection or evaluation (GLM-5 vs. alternatives) — ADR-005 is model-agnostic by design
- Changes to the architecture-advisor skill — that's EPIC-011

## Child Specs

_To be created as this epic is decomposed. Expected specs:_

1. **Catalog entry template** — design `catalog-entry.template.j2`, define the YAML schema, ensure the discover skill can produce dual output
2. **Runtime prompt assembly** — refactor pipeline scripts to derive instructions from the discover skill at invocation time
3. **Catalog reclassification campaign** — batch-reclassify all 184+ entries, validate output, replace existing catalog entries
4. **Legacy retirement** — remove deprecated prompts and parsers, update any references

## Key Dependencies

| Dependency | Type | Status | Impact |
|-----------|------|--------|--------|
| ADR-005 | Decision | Adopted | Provides the architectural mandate — this epic implements it |
| SPEC-001 (Discovery Skill) | Implementation | Implemented | The discover skill must exist and be functional — it does |
| SPEC-024 (GLM-5 Classification) | Implementation | Implemented | Current catalog entries were produced by this — they'll be reclassified |

### What this epic blocks

| Artifact | Why blocked |
|----------|-------------|
| SPEC-003 (Comparative Analysis Engine) | Requires uniform catalog schema per ADR-005 — catalog-entry.template.j2 fields are a precondition |

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-10 | — | Implement ADR-005 decision across the pipeline |
