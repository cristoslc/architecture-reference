---
id: architecture-reference-repo-cvn.6
status: closed
deps: []
links: []
created: 2026-03-09T02:47:18Z
type: task
priority: 1
assignee: Cristos L-C
---
# Task 6: Source analysis markdown generation with tests

**Files:**
- Modify: `pipeline/tests/test_recompute_frequencies.py`
- Modify: `pipeline/recompute_frequencies.py`

**Step 1: Write failing tests for source-analysis output**

Append to `pipeline/tests/test_recompute_frequencies.py`:
```python
class TestGenerateSourceAnalysis:
    def test_includes_production_only_header(self):
        from recompute_frequencies import generate_source_analysis
        md = generate_source_analysis(
            all_entries=[{"use_type": "production", "scope": "platform",
                          "architecture_styles": ["A"], "language": "Go",
                          "domain": "Infra", "classification_confidence": 0.9,
                          "classification_status": "classified"}],
            prod_freq={"A": 1}, plat_freq={"A": 1}, app_freq={},
            n_prod=1, n_plat=1, n_app=0, n_ref=0, n_total=1,
        )
        assert "production" in md.lower()
        assert "ADR-001" in md

    def test_includes_platform_application_split_table(self):
        from recompute_frequencies import generate_source_analysis
        md = generate_source_analysis(
            all_entries=[
                {"use_type": "production", "scope": "platform",
                 "architecture_styles": ["A"], "language": "Go",
                 "domain": "Infra", "classification_confidence": 0.9,
                 "classification_status": "classified"},
                {"use_type": "production", "scope": "application",
                 "architecture_styles": ["B"], "language": "Python",
                 "domain": "Web", "classification_confidence": 0.85,
                 "classification_status": "classified"},
            ],
            prod_freq={"A": 1, "B": 1}, plat_freq={"A": 1}, app_freq={"B": 1},
            n_prod=2, n_plat=1, n_app=1, n_ref=0, n_total=2,
        )
        assert "Platform" in md
        assert "Application" in md
```

**Step 2: Run tests to verify they fail**

Run: `python3 -m pytest pipeline/tests/test_recompute_frequencies.py::TestGenerateSourceAnalysis -v`
Expected: FAIL

**Step 3: Implement generate_source_analysis**

This function generates the full `source-analysis.md` document. Model it on the existing file structure but with updated data. Add to `pipeline/recompute_frequencies.py`:

```python
from datetime import datetime, timezone


def generate_source_analysis(all_entries, prod_freq, plat_freq, app_freq,
                              n_prod, n_plat, n_app, n_ref, n_total):
    """Generate the source-analysis.md markdown document."""
    lines = [
        f"# Discovered Source Analysis: Patterns Across {n_total} Open-Source Repositories",
        "",
        "## Dataset Overview",
        "",
        f"This analysis covers **{n_total} open-source repositories** classified using deep-analysis "
        f"(LLM source code inspection per ADR-002). All entries have deep-analysis classifications "
        f"with zero Indeterminate results.",
        "",
        "Per ADR-001, entries are tagged with `scope` (platform | application) and `use_type` "
        f"(production | reference). **Frequency rankings below use production-only entries** "
        f"({n_prod} entries) unless noted.",
        "",
        "| Discovery Method | Year | Repositories |",
        "|-----------------|------|--------------|",
        f"| GitHub search + signal extraction | 2026 | {n_total} |",
        f"| Deep-analysis classification (ADR-002) | 2026 | {n_total} |",
        "",
        "### Taxonomy Composition",
        "",
        "| Category | Count |",
        "|----------|-------|",
        f"| Production platforms | {n_plat} |",
        f"| Production applications | {n_app} |",
        f"| Reference (all) | {n_ref} |",
        f"| **Total** | **{n_total}** |",
        "",
        f"Production ratio: {n_plat}:{n_app} = {n_plat/n_app:.2f}:1" if n_app > 0 else "",
        "",
        "---",
        "",
        f"## Architecture Style Distribution (Production Only)",
        "",
        f"Each project may ...


