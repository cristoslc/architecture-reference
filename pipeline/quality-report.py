#!/usr/bin/env python3
"""Generate a quality report from discovered catalog entries.

Produces a markdown report showing confidence distribution, per-style coverage,
entries flagged for human review, and coverage gaps.

Usage:
    python3 pipeline/quality-report.py
    python3 pipeline/quality-report.py --catalog-dir path/to/catalog --output path/to/report.md
"""

import argparse
import os
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


CANONICAL_STYLES = [
    "Microservices",
    "Event-Driven",
    "Modular Monolith",
    "Service-Based",
    "Domain-Driven Design",
    "CQRS",
    "Space-Based",
    "Hexagonal Architecture",
    "Serverless",
    "Layered",
    "Pipe-and-Filter",
    "Multi-Agent",
]

TARGET_PER_STYLE = 10


def load_catalog(catalog_dir):
    """Load all catalog entries from a directory."""
    entries = []
    for fname in sorted(os.listdir(catalog_dir)):
        if not fname.endswith(".yaml") or fname.startswith("_"):
            continue
        path = os.path.join(catalog_dir, fname)
        try:
            entry = load_yaml(path)
            if entry and isinstance(entry, dict):
                entries.append(entry)
        except Exception as e:
            print(f"Warning: failed to parse {fname}: {e}", file=sys.stderr)
    return entries


def confidence_histogram(entries):
    """Build a text histogram of confidence distribution."""
    buckets = Counter()
    for e in entries:
        meta = e.get("discovery_metadata", {})
        conf = meta.get("confidence", 0) if isinstance(meta, dict) else 0
        bucket = min(int(conf * 10), 9)  # 0-9 buckets for 0.0-1.0
        buckets[bucket] += 1

    lines = []
    for i in range(10):
        lo = i / 10
        hi = (i + 1) / 10
        count = buckets.get(i, 0)
        bar = "#" * count
        lines.append(f"  {lo:.1f}-{hi:.1f}  | {bar} ({count})")
    return "\n".join(lines)


def generate_report(catalog_dir, output_path):
    """Generate the quality report markdown."""
    entries = load_catalog(catalog_dir)

    if not entries:
        report = "# Quality Report\n\nNo catalog entries found.\n"
        with open(output_path, "w") as f:
            f.write(report)
        print(f"Generated {output_path}: 0 entries")
        return

    # --- Split confident vs indeterminate ---
    confident_entries = []
    indeterminate_entries = []
    for e in entries:
        styles = e.get("architecture_styles", [])
        if styles == ["Indeterminate"]:
            indeterminate_entries.append(e)
        else:
            confident_entries.append(e)

    # --- Confidence stats (confident entries only) ---
    confidences = []
    for e in confident_entries:
        meta = e.get("discovery_metadata", {})
        conf = meta.get("confidence", 0) if isinstance(meta, dict) else 0
        confidences.append(conf)

    def percentile(vals, p):
        """Linear interpolation percentile (sorted input)."""
        k = (len(vals) - 1) * p / 100
        f = int(k)
        c = f + 1 if f + 1 < len(vals) else f
        return vals[f] + (vals[c] - vals[f]) * (k - f)

    if confidences:
        n = len(confidences)
        avg_conf = sum(confidences) / n
        min_conf = min(confidences)
        max_conf = max(confidences)
        sorted_conf = sorted(confidences)
        median_conf = (sorted_conf[n // 2] + sorted_conf[(n - 1) // 2]) / 2
        p25 = percentile(sorted_conf, 25)
        p75 = percentile(sorted_conf, 75)
        p5 = percentile(sorted_conf, 5)
        p95 = percentile(sorted_conf, 95)
    else:
        n = avg_conf = min_conf = max_conf = median_conf = 0
        p25 = p75 = p5 = p95 = 0

    # --- Style coverage (confident entries only) ---
    style_counter = Counter()
    for e in confident_entries:
        styles = e.get("architecture_styles", [])
        if isinstance(styles, list):
            for s in styles:
                style_counter[s] += 1

    # --- Indeterminate entries (for LLM review) ---
    review_entries = []
    for e in indeterminate_entries:
        meta = e.get("discovery_metadata", {})
        conf = meta.get("confidence", 0) if isinstance(meta, dict) else 0
        candidates = meta.get("heuristic_candidates", []) if isinstance(meta, dict) else []
        # Normalize: fallback parser may return a single dict instead of a list
        if isinstance(candidates, dict):
            candidates = [candidates]
        if not isinstance(candidates, list):
            candidates = []
        cand_parts = []
        for c in candidates:
            if isinstance(c, dict):
                cand_parts.append(f"{c.get('style', '?')} ({c.get('score', '?')})")
            else:
                cand_parts.append(str(c))
        cand_str = ", ".join(cand_parts) if cand_parts else "none"
        review_entries.append((e.get("project_name", "?"), conf, cand_str))

    # --- Coverage gaps ---
    gaps = [s for s in CANONICAL_STYLES if style_counter.get(s, 0) < TARGET_PER_STYLE]

    # --- Build report ---
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    lines = [
        "# Dataset Scaling Pipeline - Quality Report",
        "",
        f"Generated: {now}",
        f"Total entries: {len(entries)}",
        f"Classified: {len(confident_entries)}",
        f"Indeterminate (needs LLM review): {len(indeterminate_entries)}",
        "",
        "## Confidence Distribution (classified entries only)",
        "",
        f"- Median: {median_conf:.2f}",
        f"- IQR (25th-75th): {p25:.2f} - {p75:.2f}",
        f"- 90% interval (5th-95th): {p5:.2f} - {p95:.2f}",
        f"- Range: {min_conf:.2f} - {max_conf:.2f}",
        f"- Mean: {avg_conf:.2f} (n={n})",
        "",
        "```",
        confidence_histogram(confident_entries),
        "```",
        "",
        "## Architecture Style Coverage",
        "",
        f"Target: n >= {TARGET_PER_STYLE} for each of the 12 canonical styles.",
        "",
        "| Style | Count | Target Met |",
        "|-------|-------|------------|",
    ]

    for style in CANONICAL_STYLES:
        count = style_counter.get(style, 0)
        met = "Yes" if count >= TARGET_PER_STYLE else f"**No** ({TARGET_PER_STYLE - count} short)"
        lines.append(f"| {style} | {count} | {met} |")

    styles_met = sum(1 for s in CANONICAL_STYLES if style_counter.get(s, 0) >= TARGET_PER_STYLE)
    lines.extend([
        "",
        f"**{styles_met}/12 styles meet target coverage.**",
        "",
    ])

    # --- Indeterminate entries ---
    lines.extend([
        "## Indeterminate Entries (needs LLM review)",
        "",
        f"Entries with confidence < 0.85: {len(review_entries)}",
        "",
    ])

    if review_entries:
        lines.append("| Project | Confidence | Heuristic Candidates |")
        lines.append("|---------|-----------|---------------------|")
        for name, conf, cand_str in sorted(review_entries, key=lambda x: -x[1]):
            lines.append(f"| {name} | {conf:.2f} | {cand_str} |")
    else:
        lines.append("None.")

    lines.append("")

    # --- Coverage gaps ---
    lines.extend([
        "## Coverage Gaps",
        "",
    ])

    if gaps:
        lines.append(f"The following {len(gaps)} styles have fewer than {TARGET_PER_STYLE} samples:")
        lines.append("")
        for g in gaps:
            count = style_counter.get(g, 0)
            lines.append(f"- **{g}**: {count}/{TARGET_PER_STYLE}")
    else:
        lines.append("All 12 canonical styles meet the target coverage.")

    lines.append("")

    report = "\n".join(lines)

    os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)
    with open(output_path, "w") as f:
        f.write(report)

    print(f"Generated {output_path}: {len(entries)} entries analyzed")


def main():
    default_catalog = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "catalog"
    )
    default_output = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "quality-report.md"
    )

    parser = argparse.ArgumentParser(description="Generate quality report from catalog entries")
    parser.add_argument("--catalog-dir", default=default_catalog,
                        help="Path to catalog directory with *.yaml entries")
    parser.add_argument("--output", default=default_output,
                        help="Output report path")
    args = parser.parse_args()

    generate_report(args.catalog_dir, args.output)


if __name__ == "__main__":
    main()
