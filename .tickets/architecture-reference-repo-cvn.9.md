---
id: architecture-reference-repo-cvn.9
status: closed
deps: []
links: []
created: 2026-03-09T02:47:19Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 9: Verify acceptance criteria and run full test suite

**Files:** None — verification only

**Step 1: Run full test suite**

```bash
python3 -m pytest pipeline/tests/ -v
```

Expected: All tests PASS

**Step 2: Verify acceptance criteria**

Check each criterion against the generated output:

1. **Frequency tables computed from production-grade entries only (reference excluded)** — Open `source-analysis.md`, confirm it says "Production entries only (142 entries)" and no reference entries counted.

2. **Separate frequency tables for platform-scope and application-scope entries** — Confirm "Platform vs Application Split" table exists in `source-analysis.md`.

3. **Combined production frequency table for overall rankings** — Confirm "Architecture Style Distribution (Production Only)" table exists.

4. **Before/after comparison document showing rank changes** — Open `frequency-recomputation.md`, confirm it has the comparison table with old vs new columns and pp change arrows.

5. **All analysis artifacts regenerated from new catalog** — Confirm `quality-report.md`, `source-analysis.md`, `_index.yaml` all have fresh generation dates.

6. **No reference or removed entries appear in frequency counts** — Grep for "reference" in the frequency tables. Reference entries should only appear in the taxonomy composition count, not in style frequencies.

**Step 3: Commit (if any verification fixes needed)**

If all checks pass, no commit needed. If minor fixes are required, fix and commit.


