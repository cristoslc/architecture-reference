---
title: "Service-Based Architecture Detection"
artifact: EPIC-008
status: Complete
author: cristos
created: 2026-03-05
last-updated: 2026-03-05
parent-vision: VISION-001
success-criteria:
  - Service-Based Architecture detected in 15+ of the 23 repos that manifest.yaml expects to be SBA (up from 4-6 currently)
  - Plugin/Microkernel detected in 5+ repos (up from 0 currently)
  - No regression in Microservices detection accuracy (currently 26 repos)
  - No regression in Modular Monolith detection accuracy (currently 29 repos)
  - SBA/MS conflict resolution produces correct winner in 80%+ of dual-signal repos
  - Updated Discovered statistics flow through to all 6 reference library documents
depends-on:
  - EPIC-005
---

# Service-Based Architecture Detection

## Goal / Objective

Fix the two largest detection blind spots in the Discovered classification pipeline: Service-Based Architecture (4 detected vs. 23 expected) and Plugin/Microkernel (0 detected vs. 6+ production-validated systems). These blind spots directly undermine the Discovered-first evidence hierarchy established by EPIC-007 — when the primary evidence layer systematically misses entire architecture styles, the statistical rankings are misleading.

### The detection gap

The classification pipeline (`pipeline/classify.py`) scores architecture styles using filesystem signals extracted by `extract-signals.sh`. The current state:

| Style | Detected | Expected | Gap | Root cause |
|-------|----------|----------|-----|------------|
| **Service-Based** | 4-6 | 23 | 17-19 missing | Weak scorer (0.4 max), 2 signals only |
| **Plugin/Microkernel** | 0 | 6+ | 6+ missing | No scorer exists |
| Microservices | 26 | ~26 | ~0 | Strong scorer (1.0+ possible), 8 signals |
| Event-Driven | 63 | ~63 | ~0 | Strong scorer (1.0+ possible), 5 signals |
| Modular Monolith | 29 | ~29 | ~0 | Adequate scorer (0.7 max), 4 signals |

### Why SBA detection fails

The SBA scorer in `classify.py` (lines 322-330) has only two signals:

```python
def score_service_based(s):
    c = 0.0
    service_projects = sig(s, "directory_patterns", "service_projects")
    if 2 <= service_projects <= 5:  # Too restrictive!
        c += 0.2
    if sig_bool(s, "directory_patterns", "services_dir"):
        c += 0.2
    return c  # Max possible: 0.4
```

**Problems:**

1. **Only 2 signals vs. 8 for Microservices.** SBA max score is 0.4; MS max is 1.0+. In any dual-signal repo (Backstage, Gitpod, Temporal), MS wins by volume.

2. **`service_projects` range too narrow.** The `2 <= x <= 5` window misses repos where `extract-signals.sh` counts 0 projects (Medusa, Strapi) or 6+ (repos with many coarse services).

3. **Missing SBA-specific signals.** No detection for:
   - Shared database patterns (1-2 databases shared across services — the SBA hallmark)
   - Coarse-grained service boundaries (fewer, larger services than MS)
   - Monorepo `packages/` structure with service-like modules
   - SOA-style service registration or locator patterns
   - Single deployment unit with multiple logical services

4. **No conflict resolution for SBA vs. MS.** When both score above threshold, MS always wins because it has more signals. The pipeline should consider that repos with 2-5 services, a shared database, and fewer than 8 Dockerfiles are more likely SBA than MS.

### Why Plugin/Microkernel detection fails

No scorer exists. The pipeline has zero signals for:
- `plugins/` or `extensions/` directories
- Plugin loader/registry patterns in code
- Core + extension module separation
- Runtime extension point contracts

Yet 6 production systems in the evidence base use Plugin architecture: LLVM, GStreamer, SQLAlchemy, Jellyfin, nopCommerce, Orchard Core. Several Discovered repos (Shopware, Keycloak, WordPress-adjacent tools) likely use plugin patterns but are classified as Modular Monolith.

### Concrete misclassifications

| Repo | Expected | Classified as | Why |
|------|----------|---------------|-----|
| Backstage | Service-Based | Microservices | MS=0.9 (8 dockerfiles, 7 k8s, 5 openapi) vs. SBA=0.4 |
| Gitpod | Service-Based | Microservices | MS=1.0 (5 dockerfiles, k8s, 65 gRPC) vs. SBA=0.4 |
| Shopware | Service-Based | Modular Monolith | MM=0.7 (modules_dir, single deploy) vs. SBA=0.4 |
| Medusa | Service-Based | Indeterminate | SBA=0.2 (services_dir but 0 service_projects — fails threshold) |
| Temporal | Service-Based | Microservices | MS=0.5 (67 gRPC) vs. SBA=0.2 (services_dir=false) |

## Scope Boundaries

### In scope

1. **New SBA signals in `extract-signals.sh`:**
   - Shared database detection (connection string count, database config files)
   - Coarse-grained service boundary detection (service directory count + average size)
   - Monorepo package detection (`packages/`, `apps/`, `services/` with 2-8 entries)
   - Deployment unit count (Docker Compose service count vs. Dockerfile count ratio)

2. **New SBA scorer in `classify.py`:**
   - Increase max possible score to 0.8+ (parity with MS)
   - Add signals for shared database, coarse services, monorepo packages
   - Improve the `service_projects` range to handle 0 (with other signals) and 6+

3. **SBA vs. MS conflict resolution:**
   - When both SBA and MS score above threshold, apply discriminating heuristics:
     - Dockerfile count < 8 + shared database → favor SBA
     - Fewer than 3 separate CI deploy targets → favor SBA
     - Service directory count 2-5 → favor SBA; 6+ → favor MS
   - Add a "service granularity" signal: average lines per service directory

4. **New Plugin/Microkernel scorer:**
   - Detect `plugins/`, `extensions/`, `addons/`, `modules/` directories with loader patterns
   - Detect plugin manifest files (plugin.json, extension.json, etc.)
   - Detect core/shell separation patterns
   - Score up to 0.6 (lower than MS/EDA but enough to register)

5. **Re-run pipeline on all 122 repos** with updated scorers and signals.

6. **Update Discovered statistics** in all 6 reference library documents to reflect corrected classification.

### Out of scope

- Changes to LLM review prompts (EPIC-005 territory)
- Changes to the multi-turn validation pipeline
- Adding new repos to the Discovered corpus
- Changes to non-SBA/Plugin scorers (unless conflict resolution requires it)
- Deep-context validation (EPIC-006 territory)

## Implementation Approach

### Phase 1: Signal extraction improvements

Add new signals to `extract-signals.sh`:
- `shared_database_configs`: count of database connection configs (1-2 = SBA signal)
- `service_avg_size`: average lines of code per service directory
- `deployment_units`: Docker Compose service count
- `monorepo_packages`: count of top-level package/app/service directories
- `plugin_dirs`: count of plugin/extension/addon directories
- `plugin_manifests`: count of plugin.json/extension.json files
- `plugin_loader_patterns`: grep for plugin registration/loading code

### Phase 2: Scorer improvements

Update `classify.py`:
- Rewrite `score_service_based()` with 5+ signals and 0.8 max score
- Add `score_plugin_microkernel()` with 3+ signals and 0.6 max score
- Add SBA vs. MS conflict resolution logic
- Add Plugin vs. MM conflict resolution logic

### Phase 3: Re-classify and validate

- Re-run pipeline on all 122 repos
- Compare before/after classifications
- Validate against manifest.yaml expected styles
- Flag any regressions in MS/MM/EDA detection

### Phase 4: Update reference library

- Recompute Discovered statistics from corrected classifications
- Update all 6 reference library documents with new SBA and Plugin numbers
- Update cross-source-reference.md and cross-source-analysis.md

## Child Specs

- **SPEC-017**: Pipeline Re-extraction and Re-classification (re-run pipeline with new signals, selective merge, comparison report)
- **SPEC-018**: Reference Library Statistics Update (propagate corrected SBA/Plugin counts into all 8 reference library documents; depends on SPEC-017)

## Key Dependencies

- **EPIC-005** (Complete) — LLM Classification Pipeline provides the multi-turn review framework. SBA detection improvements feed new heuristic scores into the same pipeline.
- **EPIC-007** (Complete) — Discovered-first evidence hierarchy established. Corrected SBA/Plugin detection directly improves the primary evidence layer.
- **EPIC-006** (Proposed) — Deep-context validation could further improve SBA classification by reading source code, but this epic targets heuristic-level improvements that don't require deep context.

## Lifecycle

| Phase | Date | Commit | Notes |
|-------|------|--------|-------|
| Proposed | 2026-03-05 | — | Initial creation |
| Active | 2026-03-05 | a0bcc15 | Dependencies satisfied; ready for child spec creation |
| Complete | 2026-03-06 | 2dee9a7 | All child specs (SPEC-017, SPEC-018) implemented; success criteria met with deep-validation methodology evolution |
