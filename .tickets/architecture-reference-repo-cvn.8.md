---
id: architecture-reference-repo-cvn.8
status: closed
deps: []
links: []
created: 2026-03-09T02:47:19Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 8: Run against real catalog (dry-run first, then full run)

**Files:**
- No new files — running existing scripts

**Step 1: Dry run the new script**

```bash
cd /Users/cristos/Documents/code/architecture-reference-repo
python3 pipeline/recompute_frequencies.py --dry-run
```

Expected: Printed frequency tables showing ~142 production entries, zero Indeterminate, Modular Monolith at top.

**Verify:** Confirm zero "Indeterminate" entries in the output. If Indeterminate appears, investigate which catalog entries still have it.

**Step 2: Full run — recompute frequencies**

```bash
python3 pipeline/recompute_frequencies.py
```

Expected output:
```
Written: evidence-analysis/Discovered/docs/analysis/source-analysis.md
Written: evidence-analysis/Discovered/docs/analysis/frequency-recomputation.md
```

**Step 3: Re-run existing quality report**

```bash
python3 pipeline/quality-report.py
```

Expected: `Generated evidence-analysis/Discovered/quality-report.md: 184 entries analyzed`

**Note:** `quality-report.py` reads `discovery_metadata.confidence` but current entries use flat `classification_confidence`. If the confidence section shows all zeros, that's a known mismatch from the schema migration — not a blocker for SPEC-022 (frequency data is correct regardless).

**Step 4: Re-run existing index generator**

```bash
python3 pipeline/generate-index.py
```

Expected: `Generated evidence-analysis/Discovered/_index.yaml: 184 projects`

**Step 5: Spot-check outputs**

Review the generated files:
- `source-analysis.md` — should show production-only frequencies with zero Indeterminate
- `frequency-recomputation.md` — should show before/after comparison with the old heuristic-contaminated data vs new clean data
- `quality-report.md` — should show 184 entries, 0 indeterminate
- `_index.yaml` — should list 184 projects with style frequencies

**Step 6: Commit**

```bash
git add evidence-analysis/Discovered/docs/analysis/source-analysis.md \
       evidence-analysis/Discovered/docs/analysis/frequency-recomputation.md \
       evidence-analysis/Discovered/quality-report.md \
       evidence-analysis/Discovered/_index.yaml
git commit -m "feat(SPEC-022): recompute frequency rankings with deep-analysis-only data"
```

---


