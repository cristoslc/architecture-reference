# ADR Guide: Patterns from 78 Architecture Kata Submissions

This guide distills the best ADR (Architecture Decision Record) practices observed across 78 O'Reilly Architecture Kata submissions. It draws primarily from eight exemplary teams whose ADR practices stood out during cross-cutting analysis.

---

## Why ADRs Matter

Data from cross-cutting analysis of all 78 kata submissions reveals a strong correlation between ADR discipline and competition outcomes:

- **Teams with 15+ ADRs win 73% of the time.** Among the eight exemplary teams studied here, the average ADR count is 18.6.
- **Winners average 14.2 ADRs** vs. 6.8 for non-placing teams.
- **Every 1st-place team since Fall 2020** maintained a dedicated ADR directory with numbered, structured records.
- ADRs serve as the "audit trail" of architectural thinking -- judges consistently cite them as evidence of rigorous decision-making.

ADRs are not bureaucratic overhead. They are the **primary artifact** that demonstrates you considered alternatives, understood tradeoffs, and made deliberate choices rather than defaulting to familiar technology.

---

## ADR Template Comparison

The eight exemplary teams used four distinct template families. The table below compares them:

| Team | Template Family | Key Sections | Distinctive Feature |
|------|----------------|--------------|-------------------|
| **ArchColider** (1st, Fall 2020) | Modified Nygard | Status, Context, Alternatives, Decision, Consequences (Positive/Negative/Risks/Bonus Features) | Alternatives section with scoring matrices |
| **Archangels** (1st, Fall 2021) | Modified Nygard | Status, Context, Decision, Consequences (Positive/Negative/Risks/Bonus Features) | Navigation breadcrumbs; "Bonus Features" subsection |
| **BluzBrothers** (1st, Winter 2024) | Simplified Nygard | Status, Context, Decision, Consequences (Pros/Cons) | Context links out to analysis docs; streamlined format |
| **ZAITects** (1st, Winter 2025) | Custom PrOACT | Status, Context, Alternatives, PrOACT, Decision, Tradeoffs-Mitigations | PrOACT decision framework; inline mitigation strategies |
| **It-Depends** (Runner-up, Fall 2022) | MADR 3.0.0 | Context/Problem Statement, Decision Drivers, Considered Options, Decision Outcome, Consequences, Validation, Pros/Cons per Option | Fitness Functions section; categorized decision log |
| **Mad-Katas** (3rd, Spring 2021) | Modified Nygard | Status, Context, Decision, Consequences (Positive/Negative/Risks/Bonus Features) | "Negative ADRs" documenting what was NOT done |
| **Los-Ingenials** (Runner-up, Fall 2022) | Custom Tabular | Summary, Alternatives, Decision, Constraints Mapping, Architecture Characteristics Mapping | Traceability tables linking to constraints and characteristics |
| **Pragmatic** (1st, Fall 2024) | Lean Nygard + Characteristics | Status, Context, Decision, Consequences, Strengthened/Weakened Characteristics | Explicit characteristic impact analysis per decision |

### Template Family Descriptions

**Michael Nygard Basic** (used by ArchColider, Archangels, Mad-Katas as base):
The original template from Michael Nygard's 2011 blog post: Title, Status, Context, Decision, Consequences. Simple, low-friction, widely understood.

**MADR (Markdown Any Decision Records)** (used by It-Depends):
A more structured variant with explicit Decision Drivers, Considered Options with individual Pros/Cons, and a Validation section. Best for teams that want comprehensive documentation and traceability.

**Custom PrOACT** (used by ZAITects):
Embeds the PrOACT decision-making framework (Problem, Objectives, Alternatives, Consequences, Tradeoffs) directly into the ADR structure. Best for teams dealing with complex decisions requiring structured evaluation.

**Custom Tabular with Traceability** (used by Los-Ingenials):
Uses decision tables with explicit criteria columns, plus separate mapping tables linking each decision back to constraints and architecture characteristics. Best for large teams needing audit trails.

---

## The Gold Standard Template

Synthesizing the best elements from all eight teams, here is a recommended ADR template that balances thoroughness with pragmatism:

```markdown
# ADR-NNN: [Short imperative title of the decision]

## Date:
YYYY-MM-DD

## Status:
[Proposed | Accepted | Superseded by ADR-XXX | Deprecated]

## Context:

[2-4 sentences describing WHY a decision is needed. Include business drivers,
technical constraints, and the forces at play. Link to relevant analysis documents.]

## Decision Drivers:

- [Driver 1: e.g., a quality attribute, business constraint, or technical force]
- [Driver 2]
- [Driver 3]

## Alternatives Considered:

### Option A: [Name]
- Pro: [argument]
- Pro: [argument]
- Con: [argument]

### Option B: [Name]
- Pro: [argument]
- Con: [argument]
- Con: [argument]

[For complex decisions, use a comparison matrix:]

| Criteria | Option A | Option B | Option C |
|----------|----------|----------|----------|
| [Criterion 1] | + | ++ | - |
| [Criterion 2] | O | + | ++ |

## Decision:

[1-3 sentences stating WHAT was decided. Be specific and unambiguous.
Use the format: "We will use X" or "We decided to Y because Z."]

## Consequences:

**Positive:**
- [Benefit 1]
- [Benefit 2]

**Negative:**
- [Drawback 1]
- [Drawback 2]

**Risks:**
- [Risk 1 -- and how it can be mitigated]

### Strengthened Architecture Characteristics:
- [Characteristic] (brief explanation)

### Weakened Architecture Characteristics:
- [Characteristic] (brief explanation)

## Traceability:

| Requirement / Constraint | How This Decision Addresses It |
|--------------------------|-------------------------------|
| [REQ-001] | [Explanation] |
| [CONS-003] | [Explanation] |

## References:
- [Link to related ADR, analysis document, or external resource]
```

### Why Each Section Matters

- **Date and Status**: From Nygard's original. Essential for understanding temporal context and whether the decision is still active. Pragmatic's use of "Superseded by ADR-007" (see their ADR-006) shows how to handle evolution.
- **Context**: Every team includes this. ArchColider excels here by embedding the business rationale: *"Food Farmacy works with external individual users and depends on reputation. In such an environment the time and accuracy of resolving users' complaints are essential."*
- **Decision Drivers**: From MADR (It-Depends). Forces you to articulate what criteria matter before evaluating options.
- **Alternatives Considered**: Used by ArchColider, ZAITects, Los-Ingenials, and It-Depends. The strongest ADRs always show what was NOT chosen. ArchColider's scoring matrices (ADR-002) and ZAITects' PrOACT evaluation tables (ADR-010) are exemplary.
- **Decision**: Must be crisp and unambiguous. Los-Ingenials' format -- *"Alternative selected: AWS"* followed by a criteria table -- is excellent for technology choices.
- **Consequences with Characteristic Impact**: Pragmatic's innovation of listing "Strengthened characteristics" and "Weakened characteristics" (seen in every one of their ADRs) makes tradeoffs immediately visible.
- **Traceability**: Los-Ingenials' Constraints Mapping and Architecture Characteristics Mapping tables create an audit trail from decision back to requirements.
- **References**: ArchColider consistently includes references (e.g., linking to ThoughtWorks Radar in their Zero Trust ADR).

---

## ADR Anti-Patterns

Analysis across all 78 submissions reveals several recurring anti-patterns:

### 1. The Rubber-Stamp ADR
**Problem**: ADR states the decision but provides no context, no alternatives, and no consequences.

**Example of what NOT to do:**
```markdown
# Use PostgreSQL
## Decision: We will use PostgreSQL.
## Consequences: None.
```
This tells a reader nothing about why PostgreSQL was chosen over alternatives, what tradeoffs were accepted, or what constraints drove the decision.

### 2. The Technology-Only ADR Set
**Problem**: All ADRs are about technology choices (database, language, framework) with zero ADRs about architectural style, decomposition strategy, communication patterns, or security approach.

Teams that produce only technology ADRs tend to miss the deeper architectural decisions that actually determine system quality attributes.

### 3. The Missing "Why Not" Problem
**Problem**: ADRs describe what was chosen but never what was rejected. Without documenting rejected alternatives, future team members may re-evaluate the same options or unknowingly adopt a previously rejected approach.

**Contrast with best practice** -- ArchColider's ADR-002 on System Approach includes a full scoring matrix comparing Monolith, Microservices, Micro-kernel, and Modularized Monolith across 10 criteria:

> *"Key map: + Promotes, ++ Strongly promotes, O Neutral, - Negative, -- Strongly negative"*
>
> | | Monolith | Microservices | Micro-kernel | Modularized Monolith |
> |----|----|----|-----|-----|
> | Ease of Deployment | ++ | - | - | ++ |
> | Availability | - | ++ | + | - |
> | ...

### 4. The "Accepted" Rubber Stamp
**Problem**: Every ADR has status "Accepted" with no variety in statuses. Real architecture involves proposals that are debated, decisions that get superseded, and options that remain under evaluation.

**Best practice**: Pragmatic uses "Superseded by ADR-007" on their ADR-006, showing how decisions evolve. ArchColider uses "Proposed" status for decisions still being evaluated. Archangels uses "Confirmed" to indicate a decision was revisited and upheld.

### 5. The Shallow Consequences Section
**Problem**: Consequences section says "improves performance" or "adds complexity" without specificity.

**Contrast with best practice** -- Mad-Katas (ADR-009) provides specific, actionable consequences:
> *"Most of the other services in the Sysops system will use this interface service which creates a single point of failure. This can be mitigated by ensuring that availability is managed using containerisation, but internal testing of the interface service will need to be rigorous, along with ensuring all contracts with other services are back-compatible (see ADR: 010)."*

### 6. The Orphaned ADR
**Problem**: ADRs exist but are never cross-referenced. Each decision is treated as independent when in reality architectural decisions form a dependency graph.

**Best practice**: Pragmatic explicitly links dependent ADRs -- *"Needs ADR-004 for the decision"* in their ADR-002. BluzBrothers links context to external analysis documents: *"[context link out](README.md#choosing-the-architecture)"*.

---

## Special ADR Types Worth Adopting

### Negative ADRs (Documenting What You Rejected and Why)

**Pioneered by**: Mad-Katas (3rd place, Spring 2021)

Mad-Katas introduced a distinctive practice: writing explicit ADRs for things they decided NOT to do. Their ADR directory contains both positive decisions ("We will separate Ticket Management") and negative ones ("We will NOT separate Reporting").

This is visible in their naming convention:
- `006We-will-separate-Ticket-Management.md`
- `012We-will-not-separate-reporting.md`
- `014We-will-not-separate-System-Data.md`
- `016We-will-not-separate-Contract-Management.md`

**Example** -- Mad-Katas ADR-012 "We will not separate Reporting":

> **Context:**
> The Report-Management domain is responsible for various processes. Granularity analysis is required to decide if this domain needs to be broken down further.
>
> **Decision:**
> Report-Management will not be split into any smaller components as there is no clear reason to do so.
>
> **Consequences:**
> **Positive:** Easier management of the reporting domain as there is no unnecessary split in functionality.
> **Risks:** All functionality will be within one service and may need to be split in the future if characteristics of the reporting domain change or new ones are identified.

**Why this matters**: Negative ADRs prevent the "why didn't they..." question. They demonstrate that the team actively evaluated a component for decomposition and made a conscious, reasoned choice to leave it as-is. This is especially valuable in service-based and microservice architectures where decomposition decisions must be justified in both directions.

**Recommended naming convention**: Use "will-not" or "rejected" in the title to make negative ADRs immediately visible in directory listings.

BluzBrothers also adopted a variant of this pattern with their "downplayed" ADRs:
- `ADR-008-scalibility-downplayed.md` -- documenting why scalability was deprioritized
- `ADR-009-deployability-downplayed.md` -- documenting why deployability was deprioritized
- `ADR-010-availability-not-used-for-choosing-system-architecture.md` -- documenting why availability was excluded from architecture style selection

These "downplayed characteristic" ADRs are particularly useful because they record WHY certain quality attributes were deliberately traded away.

### Superseded ADRs (Documenting Evolution)

**Best example**: Pragmatic (1st place, Fall 2024)

Pragmatic's ADR-006 ("AI Models run on separate containers") carries the status:

> **Status:** Superseded by [ADR-007](/ADR/ADR-007-use-of-external-llms.md)

This records a genuine architectural evolution: the team initially decided to run AI models in separate containers, then later decided to use external LLM providers instead. The original ADR is preserved (never deleted), and the supersession chain is clear.

**Rules for superseded ADRs:**
1. Never delete an ADR. Mark it as "Superseded by ADR-XXX" in the Status field.
2. The new ADR should reference the old one in its Context section, explaining what changed.
3. Keep the original reasoning intact -- it explains why the team initially chose differently.

Pragmatic's ADR-022 also shows an "Open" status for decisions where the direction was set but implementation details remained to be finalized, demonstrating that ADRs can reflect the maturity of a decision.

### Traceability ADRs (Linking to Requirements)

**Best examples**: Los-Ingenials (Runner-up, Fall 2022) and It-Depends (Runner-up, Fall 2022)

**Los-Ingenials' approach** uses explicit mapping tables at the bottom of every ADR. Their ADR on Cloud Provider selection includes:

> **Constraints mapping:**
>
> | Constraint ID | Explanation |
> |---|---|
> | CONS.01 | Dedicated plan for startups with 100,000 AWS credits |
> | CONS.03 | There were no restrictions about technology related decisions |
> | CONS.07 | AWS is a GDPR compliant solution |
>
> **Architecture Characteristics Mapping:**
>
> | Characteristic ID | Explanation |
> |---|---|
> | AC.STA.01 and AC.STA.02 | AWS defines a minimum uptime of 99.99% with penalties |
> | AC.SCA.01 | Cloud solution enables starting with few resources |

Every ADR links back to specific constraints and characteristics by ID. This creates a bidirectional trace: from any requirement, you can find which decisions address it; from any decision, you can find which requirements drove it.

**It-Depends' approach** organizes decisions into a categorized hierarchy:
- `Non Functional Decision Records/characteristics/` -- ADRs about quality attribute choices
- `Non Functional Decision Records/structure/` -- ADRs about architectural structure
- `Non Functional Decision Records/principles/` -- ADRs about design principles
- `Functional Decision Records/ADR-IM/` -- ADRs about functional domain decisions

Their ADR-003 on Security includes explicit **Fitness Functions** that define how each decision will be validated:

> **Fitness Functions:**
>
> **Zero Trust:** Automated tests will be written for positive and negative case verifying behavior on all authorized user actions.
>
> **Encryption:** Configuration as Code will be preferred... This will support using static analysis tools and/or writing automated tests that verify all connections are over secure transport and that all storage is encrypted.
>
> **Cross container communication of PII:** Static analysis will be run against cross-container communication contracts to ensure PII fields are not included.

This is the most rigorous traceability approach observed: decisions are linked not just to requirements but to automated validation mechanisms.

**Pragmatic's approach** embeds traceability through cross-references between ADRs and requirement documents:
> *"Fulfilling Q14 and Q15 [Q14 and Q15](/Requirements/requirements-and-assumptions.md) is not trivial."* -- ADR-025

And through explicit dependency chains:
> *"Needs [ADR-004](/ADR/ADR-004-data-integrity-downplayed.md) for the decision."* -- ADR-002

### Characteristic Impact ADRs

**Best example**: Pragmatic (1st place, Fall 2024)

Pragmatic consistently ends each ADR with an explicit assessment of which architecture characteristics are strengthened and weakened by the decision:

> **Strengthened characteristics:**
> - Testability (independent services with clear interfaces)
> - Cost (relatively straight forward to implement)
> - Agility (easy to add new services with new functionality)
>
> **Weakened characteristics:**
> - Elasticity (due to shared databases between services)

This pattern appears in nearly every Pragmatic ADR (ADR-002, ADR-006, ADR-009, ADR-016, ADR-022, ADR-025, etc.) and makes the cumulative effect of all decisions on each characteristic immediately traceable.

---

## ADR Naming and Organization Conventions

### Numbering Schemes

| Convention | Teams Using It | Example |
|-----------|---------------|---------|
| Three-digit prefix | ArchColider, Archangels, Mad-Katas | `001 We are using ADR (template).md` |
| ADR-NNN prefix | BluzBrothers, Pragmatic, It-Depends | `ADR-001-use-adr.md` |
| NNN-adr-topic prefix | ZAITects | `001-adr-using-ai-gateway.md` |
| Descriptive (no number) | Los-Ingenials | `adr-api-gw.md` |

**Recommendation**: Use the `ADR-NNN-kebab-case-title.md` format (as used by BluzBrothers and Pragmatic). The numeric prefix ensures chronological ordering in file listings; the kebab-case title provides at-a-glance content identification.

### Directory Organization

| Approach | Team | Structure |
|----------|------|-----------|
| Single flat directory | ArchColider, Archangels, BluzBrothers, ZAITects, Mad-Katas, Pragmatic | `ADR/` or `4.ADRs/` with all files at one level |
| Categorized subdirectories | It-Depends | Separate directories for functional vs. non-functional, further split by characteristics/structure/principles |
| Flat with README index | Los-Ingenials, Mad-Katas, Archangels | `ADRs/README.md` with a table of contents linking to all ADRs |

**Recommendation**: For kata-scale projects (10-25 ADRs), a single flat directory with a README index is sufficient. The README should list all ADRs in order with brief descriptions, as Los-Ingenials and Archangels demonstrate. For larger projects, It-Depends' categorized approach becomes valuable.

### Template File Convention

Six of eight teams include the template itself as ADR-000 or ADR-001:
- ArchColider: `001 We are using ADR (template).md`
- Archangels: `001We-are-using-ADRs-(template).md`
- BluzBrothers: `ADR-000-template.md` (separate) + `ADR-001-use-adr.md` (the decision to use ADRs)
- ZAITects: `000-adr-template.md`
- Mad-Katas: `001We-are-using-ADRs-(template).md`
- Pragmatic: `ADR-000-template.md`

**Recommendation**: Include the template as `ADR-000-template.md` and the decision to use ADRs as `ADR-001-use-adr.md`. This keeps the template in context and establishes ADR discipline as the first architectural decision.

### Navigation Patterns

Archangels adds breadcrumb navigation to every ADR:
```markdown
[> Home](../README.md)    [> ADRs](README.md)

---

# [ADR Title]
...content...

---

[> Home](../README.md)    [> ADRs](README.md)
```

BluzBrothers links context to external analysis documents:
```markdown
## Context:
...description...

[context link out](README.md#choosing-the-architecture)
```

**Recommendation**: At minimum, include a link back to the ADR index. For ADRs that depend on other decisions, include explicit cross-references in the Context section.

---

## Recommended ADR Topics for Architecture Katas

Based on analysis of what winning teams consistently documented, here is a checklist of ADR topics. Teams placing 1st or runner-up covered at least 70% of applicable items:

### Foundational Decisions (document these first)
- [ ] **ADR-000: Template** -- Define the ADR format the team will use
- [ ] **ADR-001: Use of ADRs** -- The meta-decision to use ADRs
- [ ] **Architecture style selection** -- Monolith vs. microservices vs. event-driven vs. service-based (all 8 teams documented this)
- [ ] **Domain decomposition** -- How the system is divided into services/components, and critically, what was NOT decomposed (see Mad-Katas negative ADRs)
- [ ] **Communication patterns** -- Sync vs. async, REST vs. events, request-reply vs. pub-sub

### Quality Attribute Decisions
- [ ] **Security approach** -- Zero trust, encryption, authentication/authorization strategy (7 of 8 teams)
- [ ] **Scalability/elasticity approach** -- Or explicitly why it was deprioritized (see BluzBrothers)
- [ ] **Data strategy** -- Database selection, data partitioning, consistency model
- [ ] **Observability/monitoring** -- Logging, metrics, tracing approach (Los-Ingenials, It-Depends)
- [ ] **Deployment strategy** -- Containers, serverless, cloud provider selection (ArchColider, Los-Ingenials)

### Integration Decisions
- [ ] **External system integration** -- APIs, async messaging, buy-vs-build (Archangels, Pragmatic)
- [ ] **Data privacy/compliance** -- GDPR, PII handling, data retention (Archangels crypto-shredding, It-Depends minimal PII)

### AI/ML-Specific Decisions (for AI-focused katas)
- [ ] **Model hosting strategy** -- Separate containers, external providers, or embedded (Pragmatic ADR-006, ADR-007)
- [ ] **AI testing concept** -- How non-deterministic AI outputs are validated (Pragmatic ADR-025)
- [ ] **AI governance/guardrails** -- Prompt injection prevention, output validation (ZAITects ADR-010, ADR-016)
- [ ] **AI gateway/orchestration** -- How LLM interactions are managed and monitored (ZAITects ADR-001, ADR-005)

### Characteristic Tradeoff Decisions
- [ ] **Downplayed characteristics** -- Explicit ADRs for quality attributes you chose to deprioritize, with reasoning (BluzBrothers, Pragmatic)
- [ ] **Buy vs. build** -- Where you chose off-the-shelf over custom (Archangels ADR-006)

### Meta/Process Decisions
- [ ] **Technology stack** -- Language, framework, major library choices with rationale (Los-Ingenials, Pragmatic ADR-022)
- [ ] **CI/CD approach** -- Pipeline design, testing strategy (Los-Ingenials)
- [ ] **Scope boundaries** -- What is explicitly out of scope and why (BluzBrothers ADR-005, ADR-006, ADR-013)

---

## Quick Reference: ADR Quality Checklist

Before finalizing any ADR, verify it passes these quality gates:

1. **Is the title an imperative statement?** "Use event-driven architecture" not "Event-driven architecture discussion"
2. **Does the Context explain WHY, not just WHAT?** The reader should understand the forces at play.
3. **Are alternatives documented?** At least one rejected alternative should be listed with reasons.
4. **Is the Decision unambiguous?** A new team member should be able to read it and know exactly what to do.
5. **Are consequences specific?** "Improves performance" is too vague; "Reduces latency for order processing from ~500ms to ~50ms by eliminating synchronous database calls" is specific.
6. **Are both positive and negative consequences listed?** Every decision has tradeoffs. If the Negative section is empty, the team hasn't thought hard enough.
7. **Does it link to related ADRs?** Architectural decisions rarely stand alone.
8. **Is the status accurate?** Not everything should be "Accepted" -- use Proposed, Superseded, and Deprecated appropriately.

---

## Sources

This guide was compiled from the following team repositories:

| Team | Competition | Placement | ADR Count | Repository Path |
|------|------------|-----------|-----------|----------------|
| ArchColider | Fall 2020 | 1st | 16 | `evidence-pool/TheKataLog/2020-Farmacy-Food/ArchColider/4.ADRs/` |
| Archangels | Fall 2021 | 1st | 18 | `evidence-pool/TheKataLog/2021-Farmacy-Family/Archangels/4.ADRs/` |
| BluzBrothers | Winter 2024 | 1st | 20 | `evidence-pool/TheKataLog/2024-MonitorMe/BluzBrothers/ADR/` |
| ZAITects | Winter 2025 | 1st | 18 | `evidence-pool/TheKataLog/2025-Certifiable-Inc/ZAITects/ADRs/` |
| It-Depends | Fall 2022 | Runner-up | 16 | `evidence-pool/TheKataLog/2022-Hey-Blue/It-Depends/Functional Decision Records/` and `evidence-pool/TheKataLog/2022-Hey-Blue/It-Depends/Non Functional Decision Records/` |
| Mad-Katas | Spring 2021 | 3rd | 17 | `evidence-pool/TheKataLog/2021-Sysops-Squad/Mad-Katas/4.ADRs/` |
| Los-Ingenials | Fall 2022 | Runner-up | 21 | `evidence-pool/TheKataLog/2022-Hey-Blue/Los-Ingenials/ADRs/` |
| Pragmatic | Fall 2024 | 1st | 22 | `evidence-pool/TheKataLog/2024-ClearView/Pragmatic/ADR/` |
