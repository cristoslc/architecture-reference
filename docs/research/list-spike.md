# Research Spikes

## Complete

| ID | Title | Question | Gate | Last Updated | Commit |
|----|-------|----------|------|--------------|--------|
| SPIKE-001 | Ecosystem Statistical Modeling | How should the reference library weight production-grade vs. reference entries, and how should ecosystem-scope entries coexist with application-scope entries? | Pre-implementation gate for EPIC-010 — all gates pass | 2026-03-06 | 57edea4 |
| SPIKE-003 | Classification Method Comparison | Which tool produces better classifications — Claude Code subagents (Sonnet 4.6) or `llm` CLI (Minimax M2.5)? | Pre-execution gate for SPEC-024 | 2026-03-08 | — |
| SPIKE-004 | Extended Model Comparison | How do GLM-5, GLM-4.7, Kimi K2.5, Gemini 3 Flash Preview, and Opus 4.6 compare against the Sonnet 4.6 baseline? | Final model selection for SPEC-024 | 2026-03-08 | — |
| SPIKE-005 | Confidence Calibration Prompting | Can we elicit meaningful confidence scores from Gemini 3 Flash instead of uniform 0.95? | Pre-execution gate for SPEC-024 | 2026-03-08 | 02bffc03 |
| SPIKE-006 | LLM CLI Reliability Improvements | Can we improve YAML adherence and use llm's native tool-calling for more robust multi-turn? | Pre-execution gate for SPEC-024 | 2026-03-08 | 02bffc03 |
| SPIKE-007 | Final Model Validation | After SPIKE-005/006 improvements, do revised prompts maintain accuracy and which model is the final recommendation? | Final gate for SPEC-024 | 2026-03-08 | 150c9c6 |

## Active

*None*

## Planned

| ID | Title | Question | Gate | Last Updated | Commit |
|----|-------|----------|------|--------------|--------|
| SPIKE-002 | Classification Taxonomy Expansion | Do we need architectural classifications beyond the classic 12 styles, and if so, which ones have sufficient evidence? | Pre-implementation gate for EPIC-010 | 2026-03-06 | c526f34 |
| SPIKE-008 | Native Multi-Turn Classification with GLM-5 | Can an LLM with native tool-calling produce higher-quality architecture classifications than script-driven batch? | Pre-execution gate for SPEC-024 reclassification | 2026-03-08 | — |
