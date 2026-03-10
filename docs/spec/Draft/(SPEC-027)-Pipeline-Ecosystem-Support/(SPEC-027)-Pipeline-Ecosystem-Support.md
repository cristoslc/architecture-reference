---
title: "Pipeline Ecosystem Support"
artifact: SPEC-027
status: Draft
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-010
linked-research:
  - SPIKE-001
linked-adrs:
  - ADR-001
  - ADR-006
depends-on:
  - SPEC-025
addresses: []
evidence-pool: ""
swain-do: required
---

# Pipeline Ecosystem Support

## Problem Statement

The pipeline tooling (manifest format, validation scripts, quality reports, index generation) was built for single-repo entries. Ecosystem entries introduce a new `scope: ecosystem` value, member-repo references, qualifier annotations, and the `style-taxonomy.yaml` reference file. Pipeline tooling must support these without breaking existing single-repo workflows.

## External Behavior

**Inputs:**
- SPEC-025 ecosystem schema (entry format, qualifiers, style-taxonomy.yaml)
- Existing pipeline scripts: manifest generation, validation, quality-report.md, _index.yaml
- Existing normalize-styles.py and the new normalize-qualifiers.py from SPEC-025

**Outputs:**
1. Updated manifest generation that includes ecosystem entries
2. Updated validation that checks ecosystem-specific fields (member_repos resolution, emergent architecture)
3. Updated quality-report.md generation that reports ecosystem coverage alongside single-repo coverage
4. Updated _index.yaml format that distinguishes ecosystem entries from single-repo entries
5. Frequency analysis that can report by scope (all, platform-only, application-only, ecosystem-only) and by kind (topology-only vs including patterns)

**Preconditions:**
- SPEC-025 is Implemented (schema and validation exist)

**Postconditions:**
- `pipeline/` scripts handle ecosystem entries without errors
- Quality report includes ecosystem coverage metrics
- Frequency tables can be filtered by the `style-taxonomy.yaml` kind field

## Acceptance Criteria

1. **Given** a catalog with both single-repo and ecosystem entries, **when** running the manifest generation script, **then** both types appear in the output manifest with correct fields.

2. **Given** an ecosystem entry with a `member_repos` field, **when** running validation, **then** the validator checks that each member repo exists as a single-repo entry and reports missing members.

3. **Given** the quality report generation, **when** ecosystem entries exist in the catalog, **then** the report includes an "Ecosystem Coverage" section showing count, domain distribution, and emergent style distribution.

4. **Given** the frequency analysis, **when** run with `--scope ecosystem`, **then** only ecosystem entries are counted. **When** run with `--kind topology`, **then** only `kind: topology` styles from `style-taxonomy.yaml` are counted.

5. **Given** the _index.yaml, **when** ecosystem entries are added, **then** they appear in a separate section or with a distinguishing field from single-repo entries.

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

- Must not break existing pipeline runs on the current single-repo catalog
- Frequency tables should report ecosystem entries separately from single-repo entries (per SPIKE-001: scope axis drives table structure)
- The `kind` filter from `style-taxonomy.yaml` enables "topology-only" frequency tables that exclude CQRS/DDD/Hexagonal
- Pipeline changes should be incremental — extend existing scripts rather than rewriting from scratch

## Implementation Approach

1. **Manifest update** — extend manifest generation to handle `scope: ecosystem` entries
2. **Validation update** — add member_repos resolution check, qualifier vocabulary validation
3. **Quality report** — add ecosystem coverage section to quality-report.md generation
4. **Frequency analysis** — add `--scope` and `--kind` filter flags
5. **Index update** — extend _index.yaml format for ecosystem entries
6. **Regression test** — run full pipeline on current catalog to confirm no breakage

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | — | Initial creation from EPIC-010 decomposition |
