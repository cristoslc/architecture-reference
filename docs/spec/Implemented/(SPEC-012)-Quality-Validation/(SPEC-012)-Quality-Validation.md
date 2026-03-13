---
title: "Quality Validation"
artifact: SPEC-012
status: Implemented
author: cristos
created: 2026-03-04
last-updated: 2026-03-04
parent-epic: EPIC-005
depends-on:
  - SPEC-010
  - SPEC-011
---

# Quality Validation

## Problem Statement

The LLM classification pipeline (SPEC-010 + SPEC-011) will reclassify up to 120 catalog entries. Before trusting these results for the reference library, we need to validate classification accuracy against a manually reviewed sample and establish regression testing to catch quality drift in future runs. EPIC-005 sets a success criterion of >= 85% classification accuracy — this spec defines how we measure and enforce that.

## External Behavior

### Inputs

- **Run report** from `llm-review.sh` (SPEC-010) — JSON with per-repo classifications
- **Gold standard sample** — a manually curated set of 15-20 repos with known-correct architecture classifications (hand-reviewed by a human)
- **Catalog entries** — the updated YAML files post-classification

### Outputs

- **Accuracy report** — JSON/markdown comparing LLM classifications against gold standard:
  - Overall accuracy (% matching gold standard)
  - Per-style precision/recall (which styles does the LLM get right vs. wrong?)
  - Confusion matrix (what does the LLM misclassify as what?)
  - Confidence calibration (are high-confidence results actually more accurate?)
- **Validation script** — `pipeline/validate-review.sh` that can be run after any `llm-review.sh` run
- **Regression baseline** — saved gold standard + expected results for CI-like revalidation

### Preconditions

- At least one `llm-review.sh` run has completed (SPEC-010)
- Gold standard sample has been manually curated

### Postconditions

- Accuracy metrics are computed and reported
- If accuracy < 85%, the report flags this as a failure with specific repos where classification disagreed
- Gold standard is version-controlled for regression testing

## Acceptance Criteria

- **Given** a completed LLM review run, **when** `validate-review.sh` is run against the gold standard, **then** an accuracy report is generated with overall accuracy, per-style breakdown, and confidence calibration
- **Given** the LLM classified a repo as "Microservices" but the gold standard says "Service-Based", **when** the report is generated, **then** this disagreement appears in the confusion matrix and the repo is listed in the misclassification details
- **Given** overall accuracy is below 85%, **when** the report completes, **then** it exits with a non-zero status code and prints a summary of the gap
- **Given** a gold standard sample of 15-20 repos, **when** selecting which repos to include, **then** the sample covers at least 8 different architecture styles
- **Given** a previous validation baseline exists, **when** a new run is validated, **then** regressions (repos that were correctly classified before but wrong now) are highlighted separately

## Scope & Constraints

### In scope

- Gold standard curation guidelines (which repos to select, how to document correct classifications)
- Validation script that compares run results against gold standard
- Accuracy metrics: overall accuracy, per-style precision/recall, confusion matrix, confidence calibration
- Regression detection (comparing against previous baselines)
- Spot-check workflow for manual review of a random sample from each run

### Out of scope

- Automated retraining or prompt tuning based on validation results (future work)
- Modifying the LLM pipeline based on validation findings (that's iterating on SPEC-010/011)
- Statistical significance testing (sample size too small for formal hypothesis testing)

### Constraints

- Gold standard must be manually curated — no bootstrapping from the LLM's own output
- Sample size of 15-20 repos (roughly 12-16% of 120 Indeterminate entries) balances effort with coverage
- Validation must be runnable offline (no LLM calls — purely comparing saved results)

## Implementation Approach

### Gold standard curation

1. Select 15-20 repos from the Indeterminate pool, stratified by:
   - Confidence band (5-7 from tier 1, 5-7 from tier 2, 3-5 from tier 3)
   - Expected architecture diversity (aim for 8+ styles represented)
2. For each repo, manually inspect the codebase and record:
   - Correct architecture style(s)
   - Confidence (high/medium/low)
   - Evidence notes (what convinced the reviewer)
3. Store as `pipeline/gold-standard/gold-standard.yaml`:
   ```yaml
   - repo: "some-repo"
     entry: "evidence-analysis/Discovered/docs/catalog/some-repo.yaml"
     correct_styles: ["Event-Driven", "Microservices"]
     confidence: high
     evidence: "docker-compose.yml has RabbitMQ + 4 service containers"
   ```

### Validation script

`pipeline/validate-review.sh`:
1. Load gold standard YAML
2. For each gold standard entry, load the corresponding catalog YAML
3. Compare `architecture_styles` — exact match or subset match
4. Compute metrics:
   - **Accuracy**: % of gold standard repos where LLM styles match
   - **Style precision**: for each style, what % of LLM assignments are correct?
   - **Style recall**: for each style, what % of gold standard instances were found?
   - **Confidence calibration**: group by LLM confidence bucket, compute accuracy per bucket
5. Generate report as JSON + markdown summary

### Spot-check workflow

After each production run, randomly sample 5 repos from the classified results and manually verify. This catches systematic issues that the fixed gold standard might miss.

```bash
# Spot-check 5 random classified repos
pipeline/validate-review.sh --spot-check 5 --run-report pipeline/reports/latest.json
```

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-04 | 334cf4a | Initial creation under EPIC-005, depends on SPEC-010 and SPEC-011 |
| Approved | 2026-03-04 | 0b6a5d7 | validate-review.py + gold standard (17 entries, 10 styles) |
| Implemented | 2026-03-04 | 707de32 | Validation passes: 86.7% accuracy (13/15), above 85% threshold |
