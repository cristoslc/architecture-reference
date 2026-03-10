---
title: "Ecosystem Catalog Schema"
artifact: SPEC-025
status: Approved
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-010
linked-research:
  - SPIKE-001
  - SPIKE-002
linked-adrs:
  - ADR-001
  - ADR-006
depends-on: []
addresses: []
evidence-pool: ""
swain-do: required
---

# Ecosystem Catalog Schema

## Problem Statement

The catalog classifies repos in isolation. Ecosystem-level architectural patterns (ELK as Pipe-and-Filter, *arr stack as Service-Based) are invisible because there is no schema for entries that represent compositions of multiple repos. Additionally, SPIKE-002 identified the need for an `architecture_qualifiers` annotation field and a `style-taxonomy.yaml` reference file to capture cross-cutting architectural nuances without expanding the top-level style taxonomy.

## External Behavior

**Inputs:**
- Existing catalog SCHEMA.yaml
- ADR-001 two-axis taxonomy (scope, use_type)
- ADR-006 qualifier annotation design
- SPIKE-001 findings (ecosystem-scope entries at the platform level)

**Outputs:**
1. Updated SCHEMA.yaml with ecosystem entry fields and `architecture_qualifiers` field
2. `style-taxonomy.yaml` reference file defining the canonical topology-only style vocabulary (10 styles; CQRS/DDD/Hexagonal excluded per ADR-006)
3. A `normalize-qualifiers.py` validation script (parallel to existing `normalize-styles.py`)
4. One exemplar ecosystem entry (ELK stack) demonstrating the schema

**Preconditions:**
- ADR-006 is Adopted (or at minimum Proposed with no objections)

**Postconditions:**
- All existing entries remain valid against the updated schema (backward-compatible)
- New ecosystem entries can link member repos and declare emergent architecture
- Qualifiers are validated against the controlled vocabulary

## Acceptance Criteria

1. **Given** the updated SCHEMA.yaml, **when** an ecosystem entry YAML is created with `scope: ecosystem`, member repo references, and emergent architecture styles, **then** it passes schema validation.

2. **Given** an existing single-repo entry without `architecture_qualifiers`, **when** validated against the updated schema, **then** it passes (field is optional, backward-compatible).

3. **Given** a catalog entry with `architecture_qualifiers`, **when** `normalize-qualifiers.py` runs, **then** it validates that every qualifier's `type` and `value` are in the controlled vocabulary and reports violations.

4. **Given** `style-taxonomy.yaml`, **when** validating any entry's `architecture_styles`, **then** every style value is present in the taxonomy file (CQRS, DDD, Hexagonal are rejected as style values; they belong in qualifiers per ADR-006).

5. **Given** the ELK ecosystem exemplar entry, **when** its `member_repos` field lists elasticsearch, kibana, logstash, beats, **then** each member resolves to an existing single-repo catalog entry (or is flagged as missing).

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

- Schema changes must be backward-compatible — no existing entry should require modification to pass validation
- The `scope` field gains a third value: `ecosystem` (alongside `platform` and `application`)
- Ecosystem entries use `scope: ecosystem` and `use_type: production` (all curated ecosystems are production systems)
- The `architecture_qualifiers` field is optional on all entry types (single-repo and ecosystem)
- Qualifier controlled vocabulary is defined in `style-taxonomy.yaml` or a sibling file — not hardcoded in the validation script

## Implementation Approach

1. **Schema design** — extend SCHEMA.yaml with ecosystem fields (`member_repos`, `emergent_architecture`, `composition_pattern`) and the `architecture_qualifiers` field
2. **style-taxonomy.yaml** — create the reference file with 10 topology-only styles (CQRS/DDD/Hexagonal excluded per ADR-006)
3. **normalize-qualifiers.py** — validation script that checks qualifier types/values against the controlled vocabulary
4. **ELK exemplar** — create one ecosystem entry demonstrating the full schema
5. **Schema validation** — run existing validation tooling against all entries to confirm backward compatibility

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | 46ab06b | Initial creation from EPIC-010 decomposition |
| Approved | 2026-03-10 | 2ad0ca5 | ADR-006 adopted; ready for implementation |
