You are validating an existing architecture classification. A previous pass classified this repository, and you now have **deep context** — actual source files from a cloned repo — to verify or correct that classification.

## Existing Classification

- **Styles:** {{EXISTING_STYLES}}
- **Confidence:** {{EXISTING_CONFIDENCE}}
- **Method:** {{EXISTING_METHOD}}
- **Notes:** {{EXISTING_NOTES}}

## Your Task

1. Review the deep context provided (directory tree, config files, source structure, architecture docs)
2. Compare against the existing classification above
3. Respond with one of the verdict types below

## Response Format

You MUST respond with ONLY valid JSON matching one of these verdict types. No markdown, no explanation outside JSON.

### Verdict: classified

Use when you can identify the architecture style(s) with confidence >= 0.70. Include a `validation_verdict` field indicating your assessment of the existing classification.

```json
{
  "verdict": "classified",
  "styles": ["StyleName"],
  "confidence": 0.90,
  "summary": "One-line description of what the system does and its architecture",
  "notes": "Evidence: specific files/directories that support this classification",
  "entry_type": "repo",
  "validation_verdict": "confirmed",
  "validation_notes": "Deep context confirms the existing classification because..."
}
```

The `validation_verdict` field MUST be one of:
- `confirmed` — your classification matches the existing one
- `reclassified` — you identified a different primary style
- `downgraded` — you found fewer styles than the existing classification
- `upgraded` — you found additional styles beyond the existing classification
- `promoted` — the entry was previously unclassifiable but you can now classify it

### Verdict: unclassifiable

Use when the repo is not a software architecture exemplar even with deep context.

```json
{
  "verdict": "unclassifiable",
  "reason": "Why this repo cannot be classified",
  "confidence": 0.95,
  "notes": "Supporting evidence",
  "validation_verdict": "downgraded",
  "validation_notes": "Previous classification was incorrect because..."
}
```

## Validation Guidance

1. **Deep context is authoritative.** You have actual source files — trust what you see over metadata-only signals.
2. **Be conservative with reclassification.** Only reclassify if the deep context clearly shows a different architecture. Minor style additions (e.g., adding DDD to an existing Hexagonal classification) are upgrades, not reclassifications.
3. **Cite specific files.** Reference exact paths from the deep context that support your assessment.
4. **Explain disagreements.** If you disagree with the existing classification, explain why the previous evidence was insufficient or misleading.
5. **Confidence calibration:** 0.85+ = clear structural signals confirmed by source code. 0.70-0.84 = moderate confidence even with deep context.
