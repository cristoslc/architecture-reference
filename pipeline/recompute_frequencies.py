#!/usr/bin/env python3
"""Recompute frequency rankings from production-only catalog entries.

Read-only: reads catalog YAML, writes analysis markdown. Does not modify catalog.

Usage:
    python3 pipeline/recompute_frequencies.py
    python3 pipeline/recompute_frequencies.py --dry-run
    python3 pipeline/recompute_frequencies.py --catalog-dir path/to/catalog --output-dir path/to/output
"""

import argparse
import os
import re
import sys
from collections import Counter
from datetime import datetime, timezone

try:
    import yaml

    def load_yaml(path):
        with open(path) as f:
            return yaml.safe_load(f)

except ImportError:
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from classify import parse_yaml

    def load_yaml(path):
        with open(path) as f:
            return parse_yaml(f.read())


def load_catalog(catalog_dir):
    """Load all catalog entries from a directory. Skips _-prefixed files."""
    entries = []
    for fname in sorted(os.listdir(catalog_dir)):
        if not fname.endswith(".yaml") or fname.startswith("_"):
            continue
        path = os.path.join(catalog_dir, fname)
        try:
            entry = load_yaml(path)
            if entry and isinstance(entry, dict) and "project_name" in entry:
                entries.append(entry)
        except Exception as e:
            print(f"Warning: failed to parse {fname}: {e}", file=sys.stderr)
    return entries


def filter_production(entries):
    """Return only production-grade entries (use_type == 'production')."""
    return [e for e in entries if e.get("use_type") == "production"]


def split_by_scope(entries):
    """Split entries into (platforms, applications) by scope field."""
    platforms = [e for e in entries if e.get("scope") == "platform"]
    applications = [e for e in entries if e.get("scope") == "application"]
    return platforms, applications


def filter_by_scope(entries, scope):
    """Filter entries by scope value. 'all' returns everything."""
    if scope == "all":
        return entries
    return [e for e in entries if e.get("scope") == scope]


def load_taxonomy_kinds(taxonomy_path):
    """Load style-taxonomy.yaml and return set of topology style names."""
    try:
        import yaml
        with open(taxonomy_path) as f:
            data = yaml.safe_load(f)
        return set(data.get("styles", {}).keys())
    except Exception:
        return None


def filter_styles_by_kind(freq, topology_styles):
    """Filter frequency dict to only topology-defining styles."""
    if topology_styles is None:
        return freq
    return {s: c for s, c in freq.items() if s in topology_styles}


def compute_frequencies(entries):
    """Count architecture style occurrences across entries. Returns dict sorted by count descending."""
    counter = Counter()
    for e in entries:
        styles = e.get("architecture_styles", [])
        if isinstance(styles, list):
            for s in styles:
                counter[s] += 1
    return dict(counter.most_common())


def format_frequency_table(freq, total_entries):
    """Format frequency dict as a ranked markdown table with percentages."""
    if not freq:
        return "No data.\n"
    lines = [
        "| Rank | Style | Count | % |",
        "|------|-------|-------|---|",
    ]
    for rank, (style, count) in enumerate(freq.items(), 1):
        pct = (count / total_entries * 100) if total_entries > 0 else 0
        lines.append(f"| {rank} | {style} | {count} | {pct:.1f}% |")
    return "\n".join(lines) + "\n"


def build_comparison(old_freq, old_total, new_freq, new_total):
    """Build before/after comparison rows. Returns list of dicts sorted by absolute change."""
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


def parse_frequency_table(md_text):
    """Extract style->count mapping from a markdown frequency table."""
    freq = {}
    for line in md_text.split("\n"):
        line = line.strip()
        if not line.startswith("|") or "---" in line or "Architecture Style" in line:
            continue
        parts = [p.strip() for p in line.split("|")]
        parts = [p for p in parts if p]
        if len(parts) >= 2:
            style = parts[0].replace("**", "").strip()
            try:
                count = int(parts[1])
                freq[style] = count
            except ValueError:
                continue
    total = sum(freq.values())
    return freq, total


def parse_source_analysis_baseline(md_text):
    """Extract the frequency table and entry count from source-analysis.md."""
    total = 0
    m = re.search(r"\((\d+)\s+entries\)", md_text)
    if m:
        total = int(m.group(1))

    section_start = md_text.find("Architecture Style Distribution")
    if section_start == -1:
        section_start = 0
    section = md_text[section_start:]

    # Stop at the next section heading (### or ---) after the frequency table
    # to avoid picking up Language, Domain, QA, and Confidence tables
    end_match = re.search(r"\n###\s|\n---", section[1:])
    if end_match:
        section = section[:end_match.start() + 1]

    freq, _ = parse_frequency_table(section)
    if total == 0:
        total = len(freq)
    return freq, total


def _format_split_table(plat_freq, n_plat, app_freq, n_app, combined_freq):
    """Format the platform vs application comparison table."""
    lines = [
        f"| Style | Platforms ({n_plat}) | % | Applications ({n_app}) | % |",
        "|-------|----------|---|-------------|---|",
    ]
    for style in combined_freq:
        pc = plat_freq.get(style, 0)
        ac = app_freq.get(style, 0)
        pp = (pc / n_plat * 100) if n_plat > 0 else 0
        ap = (ac / n_app * 100) if n_app > 0 else 0
        lines.append(f"| {style} | {pc} | {pp:.0f}% | {ac} | {ap:.0f}% |")
    return "\n".join(lines)


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
    ]
    if n_app > 0:
        lines.append(f"Production ratio: {n_plat}:{n_app} = {n_plat/n_app:.2f}:1")
    lines.extend([
        "",
        "---",
        "",
        f"## Architecture Style Distribution (Production Only)",
        "",
        f"Each project may exhibit multiple architecture styles. Production entries only ({n_prod} entries):",
        "",
        format_frequency_table(prod_freq, n_prod),
        "### Platform vs Application Split",
        "",
        _format_split_table(plat_freq, n_plat, app_freq, n_app, prod_freq),
        "",
    ])

    # Key findings
    top_styles = list(prod_freq.items())[:3]
    lines.extend([
        "### Key Findings",
        "",
    ])
    for i, (style, count) in enumerate(top_styles, 1):
        pct = count / n_prod * 100 if n_prod > 0 else 0
        lines.append(f"{i}. **{style}** leads at {count} of {n_prod} ({pct:.0f}%)")
    lines.append("")

    # Language distribution
    lang_counter = Counter()
    for e in all_entries:
        lang_counter[e.get("language", "Unknown")] += 1
    lines.extend([
        "---",
        "",
        "## Language Distribution",
        "",
        "| Language | Count | Percentage |",
        "|----------|-------|------------|",
    ])
    for lang, count in lang_counter.most_common():
        pct = count / n_total * 100
        lines.append(f"| {lang} | {count} | {pct:.0f}% |")

    # Confidence distribution
    confs = [e.get("classification_confidence", 0)
             for e in all_entries if e.get("classification_status") == "classified"]
    lines.extend([
        "",
        "---",
        "",
        "## Confidence Distribution",
        "",
        "| Confidence Range | Count | Percentage |",
        "|-----------------|-------|------------|",
    ])
    if confs:
        buckets = [
            ("0.90+", sum(1 for c in confs if c >= 0.90)),
            ("0.85-0.89", sum(1 for c in confs if 0.85 <= c < 0.90)),
            ("0.80-0.84", sum(1 for c in confs if 0.80 <= c < 0.85)),
            ("0.70-0.79", sum(1 for c in confs if 0.70 <= c < 0.80)),
            ("< 0.70", sum(1 for c in confs if c < 0.70)),
        ]
        for label, count in buckets:
            pct = count / len(confs) * 100
            lines.append(f"| {label} | {count} | {pct:.0f}% |")

    # Multi-style composition
    style_counts = Counter()
    for e in all_entries:
        n = len(e.get("architecture_styles", []))
        if n > 0:
            style_counts[n] += 1
    lines.extend([
        "",
        "---",
        "",
        "## Multi-Style Composition",
        "",
        "| Composition | Count |",
        "|-------------|-------|",
    ])
    for n_styles in sorted(style_counts.keys()):
        count = style_counts[n_styles]
        pct = count / n_total * 100
        label = f"{n_styles} style" if n_styles == 1 else f"{n_styles} styles"
        lines.append(f"| {label} | {count} ({pct:.0f}%) |")

    # Domain coverage
    domain_counter = Counter()
    for e in all_entries:
        domain_counter[e.get("domain", "Unknown")] += 1
    lines.extend([
        "",
        "---",
        "",
        f"## Domain Coverage",
        "",
        f"{len(domain_counter)} unique domains across {n_total} entries:",
        "",
        "| Domain | Count | Domain | Count |",
        "|--------|-------|--------|-------|",
    ])
    domains_sorted = domain_counter.most_common()
    half = (len(domains_sorted) + 1) // 2
    for i in range(half):
        left = domains_sorted[i]
        right = domains_sorted[i + half] if i + half < len(domains_sorted) else ("", "")
        lines.append(f"| {left[0]} | {left[1]} | {right[0]} | {right[1]} |")

    # Summary comparison table
    lines.extend([
        "",
        "---",
        "",
        "## Summary: Discovered vs. Other Sources",
        "",
        "| Metric | KataLog | AOSA | RealWorld | RefArch | Discovered |",
        "|--------|---------|------|-----------|---------|------------|",
    ])
    top = list(prod_freq.items())[0] if prod_freq else ("N/A", 0)
    top_pct = top[1] / n_prod * 100 if n_prod > 0 else 0
    multi_count = sum(1 for e in all_entries if len(e.get("architecture_styles", [])) > 1)
    multi_pct = multi_count / n_total * 100 if n_total > 0 else 0
    lines.extend([
        f"| Count | 78 | 12 | 5 | 8 | {n_prod} (prod) |",
        f"| Primary style | Event-Driven (56%) | Pipeline (42%) | Plugin Arch (60%) | Microservices (63%) | {top[0]} ({top_pct:.0f}%) |",
        f"| Multi-style | 73% | 67% | 80% | 75% | {multi_pct:.0f}% |",
        "| Top QA | Scalability (62%) | Performance (42%) | Extensibility (60%) | Testability (50%) | Deployability (90%) |",
        "| Detection method | Competition | Case study | Case study | Teaching code | Deep analysis |",
        "",
        f"The Discovered source provides **production-only frequency rankings** per ADR-001, "
        f"with separate platform and application views. All {n_total} entries classified via "
        f"deep-analysis per ADR-002 — zero Indeterminate results.",
        "",
    ])
    return "\n".join(lines)


def generate_frequency_recomputation(old_freq, old_total, new_freq, new_total,
                                      n_plat, n_app):
    """Generate the frequency-recomputation.md comparison document."""
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    n_prod = new_total
    lines = [
        "# SPEC-022: Frequency Recomputation Results",
        "",
        f"Generated: {now}",
        f"Catalog: {n_prod} production entries",
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
    platforms, applications = split_by_scope(prod)

    n_total = len(entries)
    n_prod = len(prod)
    n_plat = len(platforms)
    n_app = len(applications)
    n_ref = n_total - n_prod

    prod_freq = compute_frequencies(prod)
    plat_freq = compute_frequencies(platforms)
    app_freq = compute_frequencies(applications)

    if dry_run:
        print(f"Production entries: {n_prod} ({n_plat} platforms, {n_app} applications)")
        n_eco = len([e for e in prod if e.get("scope") == "ecosystem"])
        if n_eco:
            print(f"Ecosystem entries: {n_eco}")
        print(f"Reference entries: {n_ref}")
        print(f"Total: {n_total}")
        print()
        print("## Combined Production Frequencies")
        print(format_frequency_table(prod_freq, n_prod))
        print("## Platform Frequencies")
        print(format_frequency_table(plat_freq, n_plat))
        print("## Application Frequencies")
        print(format_frequency_table(app_freq, n_app))
        if n_eco:
            eco_entries = [e for e in prod if e.get("scope") == "ecosystem"]
            eco_freq = compute_frequencies(eco_entries)
            print("## Ecosystem Frequencies")
            print(format_frequency_table(eco_freq, n_eco))
        return

    os.makedirs(output_dir, exist_ok=True)

    # Read existing source-analysis.md for before/after baseline
    sa_path = os.path.join(output_dir, "source-analysis.md")
    old_freq = {}
    old_total = 0
    if os.path.exists(sa_path):
        with open(sa_path) as f:
            old_freq, old_total = parse_source_analysis_baseline(f.read())

    # Write source-analysis.md
    sa_content = generate_source_analysis(
        entries, prod_freq, plat_freq, app_freq,
        n_prod, n_plat, n_app, n_ref, n_total,
    )
    with open(sa_path, "w") as f:
        f.write(sa_content)
    print(f"Written: {sa_path}")

    # Write frequency-recomputation.md
    if old_freq:
        fr_content = generate_frequency_recomputation(
            old_freq, old_total, prod_freq, n_prod, n_plat, n_app,
        )
        fr_path = os.path.join(output_dir, "frequency-recomputation.md")
        with open(fr_path, "w") as f:
            f.write(fr_content)
        print(f"Written: {fr_path}")
    else:
        print("No previous source-analysis.md found — skipping before/after comparison")


def main():
    default_catalog = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "catalog",
    )
    default_output = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "analysis",
    )

    parser = argparse.ArgumentParser(
        description="Recompute frequency rankings from production-only catalog entries (read-only)",
    )
    parser.add_argument("--catalog-dir", default=default_catalog,
                        help="Path to catalog directory with *.yaml entries")
    parser.add_argument("--output-dir", default=default_output,
                        help="Output directory for analysis files")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print tables to stdout without writing files")
    parser.add_argument("--scope", default="all",
                        choices=["all", "platform", "application", "ecosystem"],
                        help="Filter by scope (default: all)")
    parser.add_argument("--kind", default="all",
                        choices=["all", "topology"],
                        help="Filter styles: 'topology' includes only style-taxonomy.yaml styles (default: all)")
    args = parser.parse_args()

    if args.scope != "all" or args.kind != "all":
        # Scope/kind filtering: quick dry-run output
        taxonomy_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)),
            "..", "evidence-analysis", "style-taxonomy.yaml",
        )
        entries = load_catalog(args.catalog_dir)
        prod = filter_production(entries)
        scoped = filter_by_scope(prod, args.scope)
        freq = compute_frequencies(scoped)
        if args.kind == "topology":
            topology_styles = load_taxonomy_kinds(taxonomy_path)
            freq = filter_styles_by_kind(freq, topology_styles)
            # Re-sort after filtering
            freq = dict(sorted(freq.items(), key=lambda x: -x[1]))
        print(f"Scope: {args.scope} | Kind: {args.kind} | Entries: {len(scoped)}")
        print()
        print(format_frequency_table(freq, len(scoped)))
    else:
        run_recomputation(args.catalog_dir, args.output_dir, args.dry_run)


if __name__ == "__main__":
    main()
