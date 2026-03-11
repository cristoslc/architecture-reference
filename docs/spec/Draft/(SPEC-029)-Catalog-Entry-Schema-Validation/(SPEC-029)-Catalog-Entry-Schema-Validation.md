---
title: "Catalog Entry Schema Validation"
artifact: SPEC-029
status: Draft
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-013
linked-research: []
linked-adrs:
  - ADR-005
depends-on: []
addresses: []
evidence-pool: ""
swain-do: required
---

# Catalog Entry Schema Validation

## Problem Statement

ADR-005 requires the discover skill to produce dual output: a markdown report AND a structured YAML catalog entry. The `catalog-entry.template.j2` template already exists in the skill, but it has never been validated against the fields SPEC-003 (Comparative Analysis Engine) requires for similarity matching. We need to confirm the schema is complete, test that the discover skill can produce both outputs in a single classification pass, and establish a machine-readable schema definition for downstream validation.

## External Behavior

### Input

- The existing `skills/discover-architecture/references/catalog-entry.template.j2`
- SPEC-003's required fields: `architecture_styles`, `domain`, `scope`, `use_type`, `quality_attributes`, `classification_confidence`
- A sample repo classification (to test dual output end-to-end)

### Output

- A validated `catalog-entry.template.j2` with all fields SPEC-003 needs (add any missing fields)
- A `catalog-schema.yaml` JSON Schema or YAML schema definition in the discover skill's `references/` directory for programmatic validation
- Updated discover skill `SKILL.md` with instructions to produce both report and catalog entry output
- One end-to-end test classification demonstrating dual output

### Preconditions

- The discover skill exists and is functional (SPEC-001 Implemented)
- `catalog-entry.template.j2` exists (confirmed)

### Postconditions

- The catalog entry template contains all fields required by SPEC-003
- A machine-readable schema exists for pipeline validation of catalog entries
- The discover skill instructions include dual-output production

## Acceptance Criteria

- **Given** the catalog entry template, **when** compared against SPEC-003's required fields (`architecture_styles`, `domain`, `scope`, `use_type`, `quality_attributes`, `classification_confidence`), **then** all fields are present
- **Given** a repo classification via the discover skill, **when** the classification completes, **then** both a markdown report and a YAML catalog entry are produced
- **Given** a produced catalog entry, **when** validated against `catalog-schema.yaml`, **then** validation passes with no missing required fields

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

### In scope

- Validating and extending the existing template
- Creating a schema definition file
- Updating the discover skill's SKILL.md for dual output
- One test classification to prove end-to-end flow

### Out of scope

- Reclassifying the full catalog (that's SPEC-031)
- Pipeline script changes (that's SPEC-030)
- Removing legacy files (that's SPEC-032)

## Implementation Approach

1. Compare `catalog-entry.template.j2` fields against SPEC-003 requirements — identify gaps
2. Add any missing fields to the template
3. Create `references/catalog-schema.yaml` as a validation schema
4. Update the discover skill's SKILL.md output section to instruct dual output (report + catalog entry)
5. Run one test classification and validate the output against the schema

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | — | Initial creation under EPIC-013 |
