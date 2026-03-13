---
id: architecture-reference-repo-cvn.4
status: closed
deps: []
links: []
created: 2026-03-09T02:47:18Z
type: task
priority: 1
---
# Task 4: Before/after comparison generation with tests

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for comparison**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestBuildComparison:
    def test_computes_percentage_point_change(self):
        from recompute_frequencies import build_comparison
        old_freq = {"Event-Driven": 78, "Modular Monolith": 60}
        old_total = 163
        new_freq = {"Modular Monolith": 55, "Event-Driven": 47}
        new_total = 142
        rows = build_comparison(old_freq, old_total, new_freq, new_total)
        # Modular Monolith: old 36.8%, new 38.7% → +1.9pp
        mm = next(r for r in rows if r["style"] == "Modular Monolith")
        assert abs(mm["old_pct"] - 36.8) < 0.1
        assert abs(mm["new_pct"] - 38.7) < 0.1
        assert abs(mm["change_pp"] - 1.9) < 0.2

    def test_includes_styles_only_in_old(self):
        from recompute_frequencies import build_comparison
        old_freq = {"A": 10, "B": 5}
        new_freq = {"A": 8}
        rows = build_comparison(old_freq, 100, new_freq, 80)
        styles = [r["style"] for r in rows]
        assert "B" in styles
        b = next(r for r in rows if r["style"] == "B")
        assert b["new_count"] == 0

    def test_includes_styles_only_in_new(self):
        from recompute_frequencies import build_comparison
        old_freq = {"A": 10}
        new_freq = {"A": 8, "C": 3}
        rows = build_comparison(old_freq, 100, new_freq, 80)
        styles = [r["style"] for r in rows]
        assert "C" in styles
        c = next(r for r in rows if r["style"] == "C")
        assert c["old_count"] == 0
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestBuildComparison -v`
Expected: FAIL

**Step 3: Implement build_comparison**

Add to `pipeline/recompute_frequencies.py`:
```python
def build_comparison(old_freq, old_total, new_freq, new_total):
    """Build before/after comparison rows. Returns list of dicts with style, old/new counts/pcts, change."""
    all_styles = set(old_freq.keys()) | set(new_freq.keys())
    rows = []
    for style in all_styles:
        old_count = old_freq.get(style, 0)
        new_count = new_freq.get(style, 0)
        old_pct = (old_count / old_total * 100) if old_total > 0 else 0
        new_pct = (new_count / new_total * 100) if new_total > 0 else 0
        rows.append({
            "style": style,
            "old_count": old_count,
            "old_pct": old_pct,
            "new_count": new_count,
            "new_pct": new_pct,
            "change_pp": new_pct - old_pct,
        })
    rows.sort(key=lambda r: abs(r["change_pp"]), reverse=True)
    return rows
```

**Step 4: Run tests to verify they pass**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py -v`
Expected: All 17 tests PASS

**Step 5: Commit**

```bash
git add pipeline/tests/test_recompute_frequencies.py pipeline/recompute_frequencies.py
git commit -m "feat(SPEC-022): add before/after frequency comparison builder"
```

---


