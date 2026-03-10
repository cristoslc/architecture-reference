---
title: "Ecosystem Curation"
artifact: SPEC-026
status: Draft
author: cristos
created: 2026-03-10
last-updated: 2026-03-10
parent-epic: EPIC-010
linked-research:
  - SPIKE-001
linked-adrs:
  - ADR-001
depends-on:
  - SPEC-025
addresses: []
evidence-pool: ""
swain-do: required
---

# Ecosystem Curation

## Problem Statement

EPIC-010's catalog audit identified 35 runtime ecosystems across the catalog, with 77 repos belonging to identifiable ecosystems and 99 missing companion repos. The catalog needs at least 10 fully curated ecosystem entries with member repos identified, individually classified, and emergent architecture documented. Missing member repos must also be added to the single-repo catalog.

## External Behavior

**Inputs:**
- EPIC-010 ecosystem audit tables (35 identified ecosystems across 10 domain categories)
- SPEC-025 ecosystem catalog schema (entry format, validation)
- Existing single-repo catalog entries for member repos already present

**Outputs:**
1. 10+ ecosystem catalog entries in the ecosystem schema format
2. Missing member repos added to the single-repo catalog (classified via deep-analysis)
3. Ecosystem entries deep-validated: emergent architecture confirmed by examining API contracts, integration docs, and shared schemas between members

**Preconditions:**
- SPEC-025 is Implemented (ecosystem schema exists and validates)

**Postconditions:**
- At least 10 ecosystem entries pass schema validation
- Each ecosystem entry's member repos all exist as single-repo catalog entries
- Emergent architecture classification for each ecosystem is supported by inter-repo evidence (not just assumed from the domain)

## Acceptance Criteria

1. **Given** the ecosystem catalog, **when** counting entries with `scope: ecosystem`, **then** there are at least 10 entries.

2. **Given** each ecosystem entry, **when** resolving its `member_repos` list, **then** every member has a corresponding single-repo catalog entry.

3. **Given** each ecosystem entry's emergent architecture classification, **when** reviewing the `classification_reasoning` field, **then** it references specific inter-repo evidence (API contracts, shared protocols, integration patterns) rather than generic domain assumptions.

4. **Given** the curated ecosystems, **when** counting distinct emergent architecture styles, **then** at least 3 different styles are represented (confirming diversity, not just one pattern repeated).

5. **Given** the ecosystems across the 10 domain categories in EPIC-010, **when** selecting which 10+ to curate, **then** at least 4 different domain categories are represented.

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

- Prioritize ecosystems that surface underrepresented styles (Service-Based, Pipe-and-Filter) per SPIKE-001 findings
- Missing member repos are classified using the existing deep-analysis pipeline (discover-architecture skill)
- Ecosystem emergent architecture requires examining actual inter-repo integration, not just assuming from the product category
- The "Agent Frameworks" group (10 independent AI agent libraries) may not qualify as an ecosystem — they don't compose into a single system. Evaluate on a case-by-case basis.
- Out of scope: creating new discovery pipeline features (that's SPEC-027)

## Implementation Approach

1. **Select ecosystems** — prioritize by underrepresented styles and available member repos. Target mix across domains.
2. **Add missing member repos** — for each selected ecosystem, add missing members to the single-repo catalog via deep-analysis
3. **Create ecosystem entries** — for each curated ecosystem, create a YAML entry using the SPEC-025 schema with member links and emergent architecture
4. **Deep-validate emergent architecture** — for each ecosystem, examine API contracts, shared schemas, and integration patterns between member repos to confirm the composition pattern
5. **Validate** — run schema validation, check all member refs resolve, review reasoning quality

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-10 | — | Initial creation from EPIC-010 decomposition |
