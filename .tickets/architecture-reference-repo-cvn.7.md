---
id: architecture-reference-repo-cvn.7
status: closed
deps: []
links: []
created: 2026-03-09T02:47:19Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 7: Main entry point and CLI with --dry-run

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing test for main orchestration**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
import tempfile
import shutil


class TestMainOrchestration:
    def test_dry_run_prints_to_stdout(self, capsys):
        from recompute_frequencies import run_recomputation
        run_recomputation(catalog_dir=FIXTURES_DIR, output_dir=None, dry_run=True)
        captured = capsys.readouterr()
        assert "Production entries:" in captured.out
        assert "Event-Driven" in captured.out

    def test_writes_source_analysis_file(self):
        from recompute_frequencies import run_recomputation
        with tempfile.TemporaryDirectory() as tmpdir:
            run_recomputation(catalog_dir=FIXTURES_DIR, output_dir=tmpdir, dry_run=False)
            sa_path = os.path.join(tmpdir, "source-analysis.md")
            assert os.path.exists(sa_path)
            content = open(sa_path).read()
            assert "Production Only" in content

    def test_writes_frequency_recomputation_file(self):
        from recompute_frequencies import run_recomputation
        with tempfile.TemporaryDirectory() as tmpdir:
            # Create a fake old source-analysis.md for before/after
            os.makedirs(os.path.join(tmpdir), exist_ok=True)
            with open(os.path.join(tmpdir, "source-analysis.md"), "w") as f:
                f.write("""\
## Architecture Style Distribution (Production Only)

Production entries only (10 entries):

| Architecture Style | Count | Percentage |
|-------------------|-------|------------|
| **Event-Driven** | 5 | 50% |
| **Modular Monolith** | 3 | 30% |
""")
            run_recomputation(catalog_dir=FIXTURES_DIR, output_dir=tmpdir, dry_run=False)
            fr_path = os.path.join(tmpdir, "frequency-recomputation.md")
            assert os.path.exists(fr_path)
            content = open(fr_path).read()
            assert "Before/After" in content or "Rank Changes" in content
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestMainOrchestration -v`
Expected: FAIL

**Step 3: Implement run_recomputation and CLI**

Add to `pipeline/recompute_frequencies.py`:
```python
import argparse


def generate_frequency_recomputation(old_freq, old_total, new_freq, new_total,
                                      n_plat, n_app):
    """Generate the frequency-recomputation.md comparison document."""
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    lines = [
        "# SPEC-022: Frequency Recomputation Results",
        "",
        f"Generated: {now}",
        f"Catalog: {old_total + (new_total - new_total)} → {new_total} production entries",
        f"Production split: {n_plat} platforms, {n_app} applications",
        "Method: Production-only entries, equal weighting per ADR-001",
        "Classification: Deep-analysis only per ADR-002 (zero Indeterminate)",
        "",
        "## Rank Changes",
        "",
        "### Before/After Comparison",
        "",
        f"| Style | Old ({old_total}) | Old % | New ({new_total} prod) | New % | Change |",
        "|-------|---------------|-------|----------------|-------|--------|",
    ]
    rows = build_comparison(old_freq, old_total, new_freq, new_total)
    for r in rows:
        arrow = "↑" if r["change_pp"] > 0 else "↓" if r["change_pp"] < 0 else "—"
        lines.append(
            f"| {r['style']} | {r['old_count']} | {r['old_pct']:.1f}% "
            f"| {r['new_count']} | {r['new_pct']:.1f}% "
            f"| {arrow} {abs(r['change_pp']):.1f}pp |"
        )
    lines.append("")
    return "\n".join(lines)


def run_recomputation(catalog_dir, output_dir, dry_run=False):
    """Main orchestration: load catalog, compute frequencies, write outputs."""
    entries = load_catalog(catalog_dir)
    prod = filter_production(entries)
    platforms, applications...


