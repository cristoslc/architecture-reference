---
title: "The Practicing Architect"
artifact: PERSONA-002
status: Draft
author: cristos
created: 2026-03-03
last-updated: 2026-03-03
linked-journeys:
  - JOURNEY-002
linked-stories: []
depends-on: []
---

# The Practicing Architect

## Archetype Label

Production Decision-Maker

## Demographic Summary

Senior developer, tech lead, or software architect with 5-15+ years of experience. Responsible for architecture decisions on production systems at work. Works in organizations ranging from startups to enterprises. Has shipped systems in at least 2-3 architecture styles but wants empirical grounding for future decisions.

## Goals and Motivations

- Choose architectures that will actually succeed in production, not just look good on a whiteboard
- Justify decisions to stakeholders with evidence rather than personal opinion or appeal to authority
- Avoid costly architectural mistakes that take years to manifest and are expensive to reverse
- Learn from the real-world experience of hundreds of other teams rather than relying solely on personal experience
- Stay current on architecture patterns without falling for hype cycles

## Frustrations and Pain Points

- **Hype-driven decision-making.** Vendor marketing and conference talks push the latest patterns without evidence of where they actually work.
- **No empirical basis for comparison.** Architecture books describe patterns in theory but rarely provide data on which approaches succeed in which contexts.
- **Survivorship bias in case studies.** Published case studies are almost always success stories — failures are rarely documented.
- **Stakeholder pressure.** Leadership wants "microservices" or "serverless" because they read an article, not because it fits the problem.
- **Delayed feedback loops.** The consequences of architecture decisions take months or years to appear, making it hard to learn from mistakes.

## Behavioral Patterns

- Reads architecture books, conference talks, and engineering blogs — but craves empirical data over opinion
- Evaluates reference architectures and open-source projects to understand how patterns work in practice
- Writes ADRs and maintains architecture documentation, but wants to anchor decisions in evidence
- Cross-references multiple sources before committing to an approach
- Values patterns that demonstrate evolution (MVP to target state) over big-bang designs

## Context of Use

Accesses the reference library when starting a new project, evaluating a major architectural pivot, or preparing a tech strategy presentation. Needs depth: cross-source comparisons, per-style evidence tables, production case studies. Likely to explore the evidence base directly (by-architecture-style, by-quality-attribute) rather than using the quick-start tools. May use the architecture-advisor skill for contextual recommendations within their development environment.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Draft | 2026-03-03 | 6883447 | Initial creation — hypothesized from reference library usage patterns, not yet validated via user research |
