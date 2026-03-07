---
title: "Override Rules & Disagreement Report"
artifact: SPEC-014
status: Abandoned
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-epic: EPIC-006
depends-on:
  - SPEC-013
---

# Override Rules & Disagreement Report

## Problem Statement

When the deep-context validation pass (SPEC-013) produces a different classification than the existing one, we need deterministic rules for when to accept the new result, when to flag for manual review, and when to defer. Without these rules, the validation pass cannot automatically update catalog entries.

## External Behavior

### Inputs

- **New classification** — styles, confidence, and evidence from the deep-context LLM pass
- **Existing classification** — styles, confidence, method, and evidence from catalog YAML
- **Override rules** — decision matrix encoded in the validation script

### Outputs

- **Override decision** — one of: `auto-accept`, `flag-for-review`, `defer`
- **Disagreement report** — markdown file with side-by-side evidence for flagged entries
- **Updated catalog entries** — entries where override decision is `auto-accept`

### Postconditions

- Auto-accepted entries have `classification_method: deep-validation` in their YAML
- Flagged entries are listed in a disagreement report for manual review
- Deferred entries remain unchanged

## Acceptance Criteria

- **Given** a heuristic-only entry where deep-validation confidence >= 0.85, **when** the new classification disagrees, **then** the override decision is `auto-accept`
- **Given** matching new and existing classifications, **when** the override rules are applied, **then** the decision is `auto-accept` (confirmation)
- **Given** an LLM-reviewed entry where both old and new have confidence >= 0.70, **when** the classifications disagree, **then** the decision is `flag-for-review`
- **Given** a new classification with confidence < 0.70, **when** the override rules are applied, **then** the decision is `defer`

## Override Rules

| Condition | Decision | Rationale |
|-----------|----------|-----------|
| New and existing agree | `auto-accept` | Confirmation — deep context validates existing classification |
| New confidence >= 0.85 AND existing method = `heuristic` | `auto-accept` | High-confidence LLM overrides signal-counting heuristic |
| New confidence >= 0.85 AND existing method = `llm-review` AND existing confidence < 0.70 | `auto-accept` | High-confidence deep review overrides low-confidence shallow review |
| New disagrees AND both confidence >= 0.70 AND existing method = `llm-review` | `flag-for-review` | Genuine disagreement between two LLM passes needs human judgment |
| New confidence < 0.70 | `defer` | Insufficient confidence to override anything |
| New verdict = `unclassifiable` AND existing is classified | `flag-for-review` | Potential false positive in existing classification |

## apply-review.py Extension

Add `--method` flag to `apply-review.py`:

```bash
python3 pipeline/apply-review.py \
  --entry some-repo.yaml \
  --styles "Microservices,Event-Driven" \
  --confidence 0.92 \
  --notes "Deep validation evidence..." \
  --method deep-validation
```

The `--method` flag sets `classification_method` in `discovery_metadata`. Defaults to `llm-review` for backward compatibility.

## Disagreement Report Format

```markdown
# Deep-Context Validation Disagreements

Generated: 2026-03-04T15:00:00Z
Entries flagged: 5

## repo-name

| | Existing | Deep-Validation |
|---|----------|----------------|
| Styles | Microservices | Service-Based |
| Confidence | 0.82 | 0.88 |
| Method | llm-review | deep-validation |
| Evidence | "docker-compose with 3 services" | "Only 3 services, shared DB, no service discovery" |

**Recommendation:** Reclassify to Service-Based (fewer services + shared DB pattern)
```

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | — | Initial creation under EPIC-006 |
| Abandoned | 2026-03-07 | — | Obsolete per ADR-002: heuristic classification dropped |
