---
title: "Ecosystem Validation and Reporting"
artifact: SPEC-027
status: Implemented
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-010
linked-research:
  - SPIKE-001
linked-adrs:
  - ADR-001
  - ADR-005
  - ADR-006
depends-on:
  - SPEC-025
addresses: []
evidence-pool: ""
swain-do: required
---

# Ecosystem Validation and Reporting

## Problem Statement

The catalog validation, quality reporting, and frequency analysis tools were built for single-repo entries. Ecosystem entries introduce `scope: ecosystem`, member-repo references, qualifier annotations, and the `style-taxonomy.yaml` controlled vocabulary. These tools must validate and report on ecosystem entries alongside single-repo entries. Classification pipeline mechanics (manifest generation, batch invocation, model orchestration) are out of scope — ADR-005 will address the pipeline rewrite separately.

## External Behavior

**Inputs:**
- SPEC-025 ecosystem schema (entry format, qualifiers, style-taxonomy.yaml)
- Existing validation scripts: normalize-styles.py, normalize-qualifiers.py
- Existing quality-report.md and _index.yaml generation
- Curated ecosystem entries from SPEC-026

**Outputs:**
1. Updated validation that checks ecosystem-specific fields (member_repos resolution, emergent architecture presence)
2. Updated quality-report.md generation that reports ecosystem coverage alongside single-repo coverage
3. Updated _index.yaml format that distinguishes ecosystem entries from single-repo entries
4. Frequency analysis that can report by scope (all, platform-only, application-only, ecosystem-only) and by kind (topology-only vs including patterns)

**Preconditions:**
- SPEC-025 is Implemented (ecosystem schema exists and validates)

**Postconditions:**
- Validation scripts handle ecosystem entries without errors
- Quality report includes ecosystem coverage metrics
- Frequency tables can be filtered by scope and by `style-taxonomy.yaml` kind

## Acceptance Criteria

1. **Given** an ecosystem entry with a `member_repos` field, **when** running validation, **then** the validator checks that each member repo exists as a single-repo entry and reports missing members.

2. **Given** the quality report generation, **when** ecosystem entries exist in the catalog, **then** the report includes an "Ecosystem Coverage" section showing count, domain distribution, and emergent style distribution.

3. **Given** the frequency analysis, **when** run with `--scope ecosystem`, **then** only ecosystem entries are counted. **When** run with `--kind topology`, **then** only `kind: topology` styles from `style-taxonomy.yaml` are counted.

4. **Given** the _index.yaml, **when** ecosystem entries are added, **then** they appear in a separate section or with a distinguishing field from single-repo entries.

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|
| AC1: member_repos resolution | normalize-qualifiers.py checks each member resolves to a catalog YAML file; 0 ECOSYSTEM-MEMBER findings on 11 ecosystems | Pass |
| AC2: Ecosystem Coverage in quality report | quality-report.py generates "Ecosystem Coverage" section with domain and emergent style distribution tables | Pass |
| AC3: --scope and --kind filters | recompute_frequencies.py --scope ecosystem shows 11 entries; --kind topology excludes CQRS/DDD/Hexagonal correctly | Pass |
| AC4: _index.yaml ecosystem distinction | generate-index.py adds scope field, member_repos, composition_pattern for ecosystems; separate single_repo_count and ecosystem_count | Pass |

## Scope & Constraints

- **Out of scope:** Classification pipeline mechanics (manifest generation, batch model invocation, system prompt assembly) — those are governed by ADR-005 and will be addressed when that ADR is adopted and implemented
- Frequency tables should report ecosystem entries separately from single-repo entries (per SPIKE-001: scope axis drives table structure)
- The `kind` filter from `style-taxonomy.yaml` enables "topology-only" frequency tables that exclude CQRS/DDD/Hexagonal
- Must not break existing validation/reporting on the current single-repo catalog

## Implementation Approach

1. **Validation update** — extend normalize-qualifiers.py with member_repos resolution check; ensure ecosystem-specific field validation covers all curated entries
2. **Quality report** — add ecosystem coverage section to quality-report.md generation
3. **Frequency analysis** — add `--scope` and `--kind` filter flags to frequency computation
4. **Index update** — extend _index.yaml format for ecosystem entries
5. **Regression test** — run validation and reporting on current catalog to confirm no breakage

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | 46ab06b | Initial creation from EPIC-010 decomposition |
