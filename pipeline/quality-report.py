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

    # --- Confidence stats ---
    confidences = []
    for e in entries:
        meta = e.get("discovery_metadata", {})
        conf = meta.get("confidence", 0) if isinstance(meta, dict) else 0
        confidences.append(conf)

    avg_conf = sum(confidences) / len(confidences)
    min_conf = min(confidences)
    max_conf = max(confidences)

    # --- Style coverage ---
    style_counter = Counter()
    for e in entries:
        styles = e.get("architecture_styles", [])
        if isinstance(styles, list):
            for s in styles:
                style_counter[s] += 1

    # --- Review-required entries ---
    review_entries = []
    for e in entries:
        if e.get("review_required", False):
            meta = e.get("discovery_metadata", {})
            conf = meta.get("confidence", 0) if isinstance(meta, dict) else 0
            review_entries.append((e.get("project_name", "?"), conf,
                                   e.get("architecture_styles", [])))

    # --- Coverage gaps ---
    gaps = [s for s in CANONICAL_STYLES if style_counter.get(s, 0) < TARGET_PER_STYLE]

    # --- Build report ---
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    lines = [
        "# Dataset Scaling Pipeline - Quality Report",
        "",
        f"Generated: {now}",
        f"Total entries: {len(entries)}",
        "",
        "## Confidence Distribution",
        "",
        f"- Mean: {avg_conf:.2f}",
        f"- Min:  {min_conf:.2f}",
        f"- Max:  {max_conf:.2f}",
        "",
        "```",
        confidence_histogram(entries),
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

    # --- Flagged entries ---
    lines.extend([
        "## Entries Flagged for Human Review",
        "",
        f"Entries with confidence < 0.5: {len(review_entries)}",
        "",
    ])

    if review_entries:
        lines.append("| Project | Confidence | Styles |")
        lines.append("|---------|-----------|--------|")
        for name, conf, styles in sorted(review_entries, key=lambda x: x[1]):
            styles_str = ", ".join(styles) if isinstance(styles, list) else str(styles)
            lines.append(f"| {name} | {conf:.2f} | {styles_str} |")
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
