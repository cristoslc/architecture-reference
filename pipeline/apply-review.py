#!/usr/bin/env python3
"""Apply an LLM review result to an existing catalog YAML entry.

Updates architecture_styles, confidence, classification_method, one_line_summary,
review_notes, and review_required — preserving all other fields (signal_breakdown,
heuristic_candidates, etc.).

Usage:
    python3 pipeline/apply-review.py \
      --entry evidence-analysis/Discovered/docs/catalog/redis.yaml \
      --styles "Space-Based,Event-Driven" \
      --confidence 0.92 \
      --summary "C in-memory data store using Space-Based architecture" \
      --notes "README.md describes distributed in-memory key-value store."

    # Mark as still indeterminate after review (no --styles):
    python3 pipeline/apply-review.py \
      --entry evidence-analysis/Discovered/docs/catalog/some-repo.yaml \
      --confidence 0.40 \
      --notes "README is sparse. No clear architectural patterns beyond basic layering."
"""

import argparse
import os
import sys

try:
    import yaml

    def load_yaml(path):
        with open(path) as f:
            return yaml.safe_load(f)

    def dump_yaml(data):
        return yaml.dump(
            data, default_flow_style=False, sort_keys=False, allow_unicode=True
        )

except ImportError:
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from classify import parse_yaml, dump_yaml as _dump

    def load_yaml(path):
        with open(path) as f:
            return parse_yaml(f.read())

    def dump_yaml(data):
        return _dump(data)


def apply_review(entry_path, styles, confidence, summary, notes):
    """Apply review results to a catalog entry, preserving existing fields."""
    entry = load_yaml(entry_path)
    if not entry or not isinstance(entry, dict):
        print(f"Error: could not parse {entry_path}", file=sys.stderr)
        sys.exit(1)

    # Update architecture_styles
    if styles:
        entry["architecture_styles"] = styles
    # If no styles provided and confidence is still low, keep Indeterminate
    elif confidence < 0.85:
        entry["architecture_styles"] = ["Indeterminate"]

    # Update one_line_summary if provided
    if summary:
        entry["one_line_summary"] = summary

    # Update review_notes
    if notes:
        entry["review_notes"] = notes

    # Update review_required
    entry["review_required"] = False

    # Update discovery_metadata
    meta = entry.get("discovery_metadata", {})
    if not isinstance(meta, dict):
        meta = {}

    meta["confidence"] = confidence
    meta["classification_method"] = "llm-review"
    # primary_style_confidence tracks the top style's confidence
    meta["primary_style_confidence"] = confidence
    entry["discovery_metadata"] = meta

    # Write back
    output = dump_yaml(entry)
    with open(entry_path, "w") as f:
        f.write(output)

    project = entry.get("project_name", os.path.basename(entry_path))
    style_str = ", ".join(entry["architecture_styles"])
    print(f"Updated {project}: {style_str} (confidence={confidence})")


def main():
    parser = argparse.ArgumentParser(
        description="Apply LLM review results to a catalog YAML entry"
    )
    parser.add_argument(
        "--entry", required=True,
        help="Path to the catalog YAML file to update"
    )
    parser.add_argument(
        "--styles",
        help="Comma-separated architecture styles (e.g. 'Space-Based,Event-Driven'). "
             "Omit to keep Indeterminate."
    )
    parser.add_argument(
        "--confidence", type=float, required=True,
        help="Overall confidence score (0.0-1.0)"
    )
    parser.add_argument(
        "--summary",
        help="One-line summary to replace the existing one"
    )
    parser.add_argument(
        "--notes", required=True,
        help="Review notes citing specific files/directories as evidence"
    )
    args = parser.parse_args()

    if not os.path.exists(args.entry):
        print(f"Error: file not found: {args.entry}", file=sys.stderr)
        sys.exit(1)

    styles = None
    if args.styles:
        styles = [s.strip() for s in args.styles.split(",") if s.strip()]

    confidence = max(0.0, min(1.0, args.confidence))

    apply_review(args.entry, styles, confidence, args.summary, args.notes)


if __name__ == "__main__":
    main()
