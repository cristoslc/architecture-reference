# Deep-Context Validation Campaign Findings

**Date:** 2026-03-04
**Model:** GLM-5 (openrouter/z-ai/glm-5)
**Scope:** All priority tiers (P1-P4), 163 unique entries

## Summary

| Metric | Value |
|--------|-------|
| Total entries processed | 163 |
| Classification rate | 94% (153/163) |
| Auto-accept rate | 48% (78/163) |
| Flagged for review | 25% (40/163) |
| Deferred | 28% (45/163) |

| Verdict | Count | % |
|---------|-------|---|
| Confirmed | 81 | 50% |
| Reclassified | 30 | 18% |
| Promoted | 22 | 13% |
| Downgraded | 17 | 10% |
| Upgraded | 3 | 2% |
| Error | 10 | 6% |

## Issue 1: Non-Canonical Styles Assigned

The LLM assigned styles not in the canonical 12-style taxonomy defined in `system-prompt.md`:

| Entry | Non-Canonical Style | Suggested Fix |
|-------|-------------------|---------------|
| `supabase.yaml` | **Monorepo** | Monorepo is a code organization strategy, not an architecture style. Re-classify based on actual runtime architecture (likely Service-Based or Microservices). |
| `istio.yaml` | **Distributed System** | "Distributed System" is a deployment characteristic, not an architecture style. Istio is a service mesh — likely Service-Based or Pipe-and-Filter. |

**Root cause:** The validation prompt and system prompt define 12 canonical styles, but the LLM sometimes invents categories when the repo doesn't fit neatly. The prompt should explicitly instruct: "You MUST only use styles from the provided list."

**Action:** File as a prompt-quality issue for SPEC-014 (override rules) or as a standalone fix to `validation-prompt.md`.

## Issue 2: High Deferred Rate (28%)

45 entries were deferred — the override rules declined to auto-accept and didn't flag for review. Most of these are entries with **empty new_styles** (the LLM returned `unclassifiable` and the entry was already `unclassifiable`):

| Category | Count | Examples |
|----------|-------|---------|
| Confirmed unclassifiable (libraries/frameworks) | 30 | kafka, rabbitmq-server, nest, langchain, llama_index, typeorm |
| Downgraded to empty styles | 5 | MassTransit, aspire, aws-lambda-powertools-python, examples, spark |

The 30 "confirmed unclassifiable" entries are correctly deferred — these are libraries/frameworks/tools that don't exhibit application-level architecture styles. The pipeline is working as intended here.

The 5 "downgraded to empty" entries need attention — they had heuristic styles but deep context found nothing classifiable. These may genuinely be misclassified by the heuristic, or the LLM may have been too conservative.

## Issue 3: Persistent Errors (10 entries)

These entries returned `needs_info` or `error` from the LLM — deep context alone was insufficient:

| Entry | LLM Verdict | Notes |
|-------|-------------|-------|
| backstage.yaml | needs_info | Large monorepo, complex plugin architecture |
| eShopOnContainers.yaml | needs_info | Reference architecture with many projects |
| eureka.yaml | needs_info | Netflix service registry |
| gitpod.yaml | needs_info | Cloud IDE with complex deployment |
| jellyfin.yaml | error | Media server |
| letta.yaml | needs_info | AI agent framework |
| medusa.yaml | needs_info | E-commerce platform |
| nextflow.yaml | needs_info | Workflow engine |
| nocodb.yaml | needs_info | No-code database |
| serverless.yaml | needs_info | Serverless framework |

**Root cause:** Single-turn validation cannot fulfill `needs_info` requests. These repos require multi-turn exploration (as `llm-review.sh` supports) but `llm-validate.sh` is single-turn by design.

**Action:** Consider adding optional multi-turn support to `llm-validate.sh`, or run these through `llm-review.sh` with deep context assembly as a hybrid approach.

## Issue 4: High Flag-for-Review Rate in P2/P3

40 entries (25%) were flagged for review. Most are **promoted** entries (previously unclassifiable, now classified) where the override rules correctly flag the change as significant:

- P2: 29 flagged (36% of P2) — many promoted from Indeterminate
- P3: 9 flagged (23% of P3) — mostly promoted

This is the override rules working as designed — promoted entries represent new classifications where a human should verify the LLM's judgment. Not a bug.

## Issue 5: P1 Heuristic Validation Rate

Only 21% of P1 (heuristic-only) entries were confirmed. The heuristic classifier tends to:

1. **Over-assign styles** — average 3.5 styles per entry vs. deep-context average of 1.8
2. **Default to Microservices + Event-Driven** — these appeared in nearly every heuristic classification regardless of actual architecture
3. **Confuse infrastructure signals with architecture** — presence of Docker/K8s configs triggers Microservices classification even for monoliths

This validates the need for the deep-context validation pipeline.

## Recommendations

1. **Fix non-canonical styles** — Patch `validation-prompt.md` to explicitly constrain output to the 12 canonical styles. Re-run supabase and istio.
2. **Review the 5 downgraded-to-empty entries** — Manual check whether these are genuinely unclassifiable or if the LLM was too conservative.
3. **Process 10 error entries** — Either add multi-turn to `llm-validate.sh` or run through `llm-review.sh` with enhanced context.
4. **Triage 40 flagged entries** — Human review of promoted/reclassified entries, especially the promoted ones which represent net-new classifications.
5. **Update heuristic classifier** — The 21% P1 confirmation rate suggests the heuristic needs recalibration, particularly around Microservices/Event-Driven over-classification.
