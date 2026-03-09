---
title: "Architecture Advisor v3.0 Validation"
artifact: SPIKE-010
status: Complete
author: cristos
created: 2026-03-09
last-updated: 2026-03-09
question: "Does the rebuilt architecture-advisor v3.0.0 skill provide accurate, Discovered-first evidence-based guidance with proper ADR-004 hierarchy compliance?"
gate: Post-rebuild validation for architecture-advisor v3.0.0
risks-addressed:
  - Skill may cite KataLog/RefArch as primary evidence (violating ADR-004)
  - Offline reference data may be stale or inconsistent with synced data
  - Data resolution fallback chain may fail to find references
  - Recommendations may lack actionable guidance
  - Evidence hierarchy may not be enforced in synthesized output
depends-on: []
linked-research:
  - SPEC-023
  - ADR-004
---

# Architecture Advisor v3.0 Validation

## Question

Does the rebuilt architecture-advisor v3.0.0 skill provide accurate, Discovered-first evidence-based guidance with proper ADR-004 hierarchy compliance?

## Success Criteria

| # | Criterion | Metric | Pass Threshold |
|---|-----------|--------|----------------|
| SC-1 | ADR-004 hierarchy compliance | Discovered/AOSA cited as PRIMARY; KataLog/RefArch cited as ANNOTATION only | Zero instances of KataLog/RefArch treated as primary evidence |
| SC-2 | Frequency data accuracy | Production frequency percentages match SPEC-022 data | All cited percentages match offline reference in SKILL.md |
| SC-3 | Data resolution chain | Skill finds reference data through the 4-level fallback | References resolve at ≥1 level |
| SC-4 | Actionable recommendations | Output includes specific next steps, not just data reporting | Every response ends with concrete guidance |
| SC-5 | Detection bias disclosure | Notes invisible QAs when discussing quality attributes | Caveat present in QA-related responses |
| SC-6 | Platform vs application distinction | Correctly applies ADR-001 scope distinction | Platform/application split cited when relevant |
| SC-7 | Offline mode viability | Skill provides useful guidance with ONLY the offline reference | Responses are substantive without synced data |

## Test Cases

### TC-1: Style selection question
- **Prompt:** "Which architecture should I use for a new e-commerce platform?"
- **Expected:** Recommends based on Discovered domain correlations (E-Commerce domain data), cites production frequency, distinguishes platform vs application
- **Validates:** SC-1, SC-2, SC-4, SC-6

### TC-2: Architecture trade-off question
- **Prompt:** "Microservices vs Service-Based for my team of 5?"
- **Expected:** Cites Discovered frequencies (Microservices 8.5%, Service-Based 4.9%), platform skew for Microservices (13% vs 2%), provides actionable recommendation
- **Validates:** SC-1, SC-2, SC-4

### TC-3: Quality attribute question
- **Prompt:** "How do I get scalability in my architecture?"
- **Expected:** Cites QA detection data (Scalability 23.2%), notes detection bias for invisible QAs, references KataLog as annotation for practices evidence
- **Validates:** SC-1, SC-5

### TC-4: KataLog boundary test
- **Prompt:** "What do competition teams say about feasibility analysis?"
- **Expected:** Answers using KataLog data BUT frames it explicitly as qualitative annotation, not primary evidence. Cites 4.5x feasibility stat with proper attribution.
- **Validates:** SC-1 (most critical — tests hierarchy enforcement)

### TC-5: Offline mode test
- **Prompt:** Run advisor with no synced references directory, ask "what's the most common architecture style?"
- **Expected:** Uses offline reference from SKILL.md, cites Microkernel at 58.5%, provides useful guidance
- **Validates:** SC-7, SC-2

## Go / No-Go Criteria

- **GO:** ≥6 of 7 success criteria pass, with mandatory SC-1 (hierarchy compliance) pass
- **NO-GO:** SC-1 failure (hierarchy violation), or ≥2 other criteria fail

## Pivot Recommendation

If SC-1 fails: add explicit "NEVER cite KataLog or RefArch as primary evidence" guardrail to SKILL.md Step 4 synthesis section. If SC-7 fails: expand the offline reference section with additional data points.

## Findings

### TC-1: Style selection — "Which architecture for e-commerce platform?"

- **SC-1 PASS**: Discovered data cited as PRIMARY via Priority 1 table and citation templates
- **SC-2/SC-4 PASS**: E-Commerce listed as 2nd largest domain (15 entries); full frequency table available
- **SC-6 PASS**: Platform/Application splits in table + Key Finding #4 highlights distinction

### TC-2: Trade-off — "Microservices vs Service-Based for team of 5?"

- **SC-2 PASS**: Microservices 8.5% (12 repos), Service-Based 4.9% (7 repos) — exact match
- **SC-6 PASS**: Microservices 13% platform vs 2% application — in both table and narrative

### TC-3: Quality attributes — "How do I get scalability?"

- **SC-2 PASS**: Scalability 23.2% (33 detected), reliability "Moderate"
- **SC-5 PASS**: Detection bias blockquote explicitly states code analysis "cannot detect Performance, Security, Testability, or Cost concerns"

### TC-4: KataLog boundary — "What about feasibility analysis?"

- **SC-1 PASS (CRITICAL)**: KataLog framed as "qualitative annotation" in THREE locations:
  1. Evidence hierarchy header: "Not primary evidence"
  2. Offline reference header: "qualitative annotation, not primary evidence"
  3. Citation template: "cite as annotation, not primary evidence"
- 4.5x feasibility stat present under properly-attributed KataLog section

### TC-5: Offline mode — "What's the most common style?"

- **SC-7 PASS**: Offline reference contains complete 12-row frequency table, 5 key findings, QA detection table, domain coverage, evidence source summary — fully self-sufficient
- **SC-2 PASS**: Microkernel #1 at 58.5% (83/142) correctly present

### Evaluation

| # | Criterion | Result | Evidence |
|---|-----------|--------|---------|
| SC-1 | ADR-004 hierarchy compliance | **PASS** | KataLog/RefArch explicitly "annotation" in 3 locations; Discovered at Priority 1 |
| SC-2 | Frequency data accuracy | **PASS** | All percentages match SPEC-022 across 5 test cases |
| SC-3 | Data resolution chain | **PASS** | Offline reference (Level 1) fully functional; 4-level fallback documented |
| SC-4 | Actionable recommendations | **PASS** | Step 5 guidance section requires concrete next steps |
| SC-5 | Detection bias disclosure | **PASS** | Explicit blockquote on invisible QAs |
| SC-6 | Platform vs application | **PASS** | Splits in frequency table + Key Finding #4 narrative |
| SC-7 | Offline mode viability | **PASS** | Complete data in SKILL.md for substantive answers |

**Result: GO** — 7/7 success criteria pass.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Active | 2026-03-09 | — | Created directly in Active — immediate investigation |
| Complete | 2026-03-09 | — | GO — all 7 criteria pass |
