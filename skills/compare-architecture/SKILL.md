---
name: compare-architecture
description: Compare a codebase's architecture against the evidence catalog of 200+ real-world projects. Finds similar projects by style, domain, scope, and quality attributes; generates a markdown comparison report with statistical context, strengths/gaps analysis, and evidence-grounded recommendations. Use when the user says "compare my architecture", "how does this compare", "find similar projects", "architecture comparison", "benchmark my architecture", or "what projects look like mine".
license: MIT
allowed-tools: Bash, Read, Grep, Glob, Agent, Skill
metadata:
  short-description: Compare architecture against 200+ cataloged projects
  version: 1.0.0
  author: cristos
  source-repo: https://github.com/cristoslc/architecture-reference
---

# Compare Architecture

Compare a codebase's architecture against the evidence catalog of 200+ real-world projects. Produces a markdown report showing similar projects, statistical context, strengths & gaps, and actionable recommendations — all grounded in specific catalog entries.

## Workflow

### Step 1: Get the target repo

Ask the user for the target repo path, or use the current working directory if they've already indicated it.

Accept optional filters:
- `--domain` — restrict comparison to a specific domain (e.g., "E-Commerce", "Developer Tools")
- `--style` — restrict to entries with a specific architecture style
- `--scope` — restrict to "platform" or "application" scope

### Step 2: Classify the target repo

Invoke the **discover-architecture** skill to classify the target repo. Read and follow the instructions in `skills/discover-architecture/SKILL.md` (relative to the architecture-reference repo root).

The discover skill will produce a classification with:
- `architecture_styles` — list of styles (primary first)
- `domain` — project domain
- `scope` — platform or application
- `use_type` — production or reference
- `quality_attributes` — observed quality attributes
- `classification_confidence` — confidence score (0.0-1.0)

Extract these fields from the discover skill's output. You need them for the comparison.

### Step 3: Run the comparison engine

The comparison engine is implemented in Python modules in this skill's directory. Run them with `uv run` from the architecture-reference repo root.

```bash
# Determine the repo root (where this skill lives)
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Or if running from the skill directory:
REPO_ROOT="/path/to/architecture-reference"
```

The engine has three modules:

1. **`catalog_loader.py`** — loads and normalizes all catalog entries from evidence sources
2. **`similarity.py`** — multi-axis similarity scoring (style, domain, scope, quality attributes)
3. **`report.py`** — generates the markdown comparison report

To run the full comparison pipeline, create a small Python script or run inline:

```bash
cd /path/to/architecture-reference

uv run python3 -c "
import sys
sys.path.insert(0, 'skills/compare-architecture')

from catalog_loader import CatalogEntry, load_catalog
from similarity import rank_similar
from report import generate_report

# Create user entry from discover skill output
user = CatalogEntry(
    project_name='PROJECT_NAME',
    architecture_styles=['Style1', 'Style2'],
    domain='Domain',
    scope='application',  # or 'platform'
    use_type='production',  # or 'reference'
    quality_attributes=['QA1', 'QA2'],
    classification_confidence=0.85,
)

# Load catalog, score, generate report
catalog = load_catalog('.')
ranked = rank_similar(user, catalog, top_n=10)
report = generate_report(user, ranked, catalog)
print(report)
"
```

Replace the placeholder values with the actual classification output from Step 2.

If the user provided filters (--domain, --style, --scope), filter the catalog before scoring:

```python
# Apply filters
if domain_filter:
    catalog = [e for e in catalog if domain_filter.lower() in e.domain.lower()]
if style_filter:
    catalog = [e for e in catalog if any(style_filter.lower() == s.lower() for s in e.architecture_styles)]
if scope_filter:
    catalog = [e for e in catalog if e.scope.lower() == scope_filter.lower()]
```

### Step 4: Present the report

Output the generated markdown report to the user. The report includes:

1. **Your Architecture** — summary of the user's repo classification
2. **Similar Projects** — top 10 matches with scores and summaries
3. **Statistical Context** — how the user's primary style ranks in the dataset
4. **Strengths & Gaps** — QA comparison against similar projects
5. **Recommendations** — 3-5 actionable items citing specific catalog entries

## Similarity Scoring

The engine uses multi-axis similarity with these weights:

| Axis | Weight | Method |
|------|--------|--------|
| Architecture style overlap | 40% | Weighted Jaccard (primary style 2x) |
| Domain match | 25% | Exact=1.0, categorical=0.7, none=0.0 |
| Scope alignment | 15% | Same=1.0, different=0.3 |
| Quality attribute overlap | 20% | Jaccard (both empty=0.5 neutral) |

Final score is multiplied by `sqrt(classification_confidence)` to gently penalize low-confidence entries.

## Dependencies

The Python modules require:
- Python 3.11+
- PyYAML (for catalog loading)
- Jinja2 (for report generation)

Install with: `uv pip install pyyaml jinja2`

## Evidence Sources

The engine loads catalog entries from four evidence sources (TheKataLog excluded):

| Source | Path | Approx. Entries |
|--------|------|-----------------|
| Discovered | `evidence-analysis/Discovered/docs/catalog/` | ~195 |
| AOSA | `evidence-analysis/AOSA/docs/catalog/` | ~12 |
| ReferenceArchitectures | `evidence-analysis/ReferenceArchitectures/docs/catalog/` | ~8 |
| RealWorldASPNET | `evidence-analysis/RealWorldASPNET/docs/catalog/` | ~5 |
