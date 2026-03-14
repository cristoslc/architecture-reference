---
title: "Constraint Baseline Schema"
artifact: SPEC-037
status: Draft
author: cristos
created: 2026-03-14
last-updated: 2026-03-14
type: feature
parent-epic: EPIC-014
linked-research: []
linked-adrs: []
depends-on: []
addresses: []
evidence-pool: ""
source-issue: ""
swain-do: required
---

# Constraint Baseline Schema

## Problem Statement

The drift detection engine (EPIC-015) needs a machine-readable format to consume per-style structural constraints and statistical norms. Without a defined contract, the constraint baselines and the drift engine would be coupled by implicit assumptions about data shape, making both harder to build and validate independently.

## External Behavior

**Input:** Architecture style name (one of the 10 canonical styles from the taxonomy).

**Output:** A YAML constraint baseline document containing:

1. **Structural rules** — the architectural invariants the style implies (e.g., Layered: no upward dependency between layers; Microkernel: plugins communicate only through the kernel API). Each rule has:
   - A human-readable description
   - A severity level (violation vs. warning)
   - The structural signal that evidences the rule (dependency direction, module boundary, communication pattern)

2. **Statistical norms** — per-style distributions derived from the evidence base. Each norm has:
   - The metric name (e.g., "layer_count", "plugin_count", "service_count")
   - Central tendency (median, mode) and spread (IQR or percentiles)
   - Sample size (number of repos this norm is computed from)
   - A threshold beyond which a value is flagged as anomalous

3. **Co-occurrence expectations** — which style combinations are common vs. unusual, derived from the evidence base's multi-style classifications.

**Preconditions:** The 10 canonical styles from the style taxonomy (defined in `style-taxonomy.yaml`) are the complete enumeration.

**Postconditions:** The schema is versioned and validated by a JSON Schema or equivalent, so the drift engine can validate inputs at load time.

## Acceptance Criteria

1. **Given** a YAML constraint baseline file, **when** it is validated against the schema, **then** all required fields are present and correctly typed.
2. **Given** any of the 10 canonical architecture styles, **when** a baseline file is requested, **then** the schema accommodates that style's structural rules without style-specific schema extensions.
3. **Given** a structural rule entry, **when** read by the drift engine, **then** the rule specifies: description, severity (violation|warning), and the structural signal type it targets.
4. **Given** a statistical norm entry, **when** read by the drift engine, **then** it includes: metric name, central tendency, spread measure, sample size, and anomaly threshold.
5. **Given** the schema definition, **when** a new architecture style is added to the taxonomy, **then** a baseline file can be created for it using only the existing schema — no schema changes required.

## Verification

| Criterion | Evidence | Result |
|-----------|----------|--------|

## Scope & Constraints

- Schema only — this spec does not populate baselines for any style (that's SPEC-038).
- The schema must be style-agnostic: the same structure works for all 10 styles.
- Format is YAML (consistent with the existing catalog and taxonomy files).
- A JSON Schema validation file should accompany the YAML schema definition.
- Design patterns (Hexagonal, DDD, CQRS) tracked as `architecture_qualifiers` are out of scope — baselines cover the 10 topology-defining styles only.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-14 | — | Initial creation |
