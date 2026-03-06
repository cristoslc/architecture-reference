#!/usr/bin/env python3
"""Stamp deep-validation results into signal files for heuristic comparison.

Reads the catalog entry (post apply-review.py) and appends a deep_validation:
block to the corresponding signal file, preserving the existing heuristic
classification: block for side-by-side comparison.

Usage:
    python3 pipeline/stamp-deep-validation.py [--all | --entry name1 name2 ...]
    python3 pipeline/stamp-deep-validation.py --all
    python3 pipeline/stamp-deep-validation.py --entry backstage grafana airflow
"""

import argparse
import os
import sys

try:
    import yaml
except ImportError:
    print("Error: PyYAML required", file=sys.stderr)
    sys.exit(1)

CATALOG_DIR = "evidence-analysis/Discovered/docs/catalog"
SIGNALS_DIR = "evidence-analysis/Discovered/signals"


def stamp_signal_file(name):
    catalog_path = os.path.join(CATALOG_DIR, f"{name}.yaml")
    signal_path = os.path.join(SIGNALS_DIR, f"{name}.signals.yaml")

    if not os.path.exists(catalog_path):
        print(f"  SKIP {name}: no catalog entry", file=sys.stderr)
        return False
    if not os.path.exists(signal_path):
        print(f"  SKIP {name}: no signal file", file=sys.stderr)
        return False

    with open(catalog_path) as f:
        catalog = yaml.safe_load(f)

    if not catalog:
        return False

    method = catalog.get("discovery_metadata", {}).get("classification_method", "")
    if method != "deep-validation":
        print(f"  SKIP {name}: method is '{method}', not deep-validation", file=sys.stderr)
        return False

    styles = catalog.get("architecture_styles", [])
    confidence = catalog.get("discovery_metadata", {}).get("confidence", 0)
    summary = catalog.get("one_line_summary", "")
    notes = catalog.get("review_notes", "")

    # Read existing signal file
    with open(signal_path) as f:
        content = f.read()

    # Remove existing deep_validation block if present (idempotent)
    if "\ndeep_validation:" in content:
        lines = content.split("\n")
        new_lines = []
        skip = False
        for line in lines:
            if line.startswith("deep_validation:"):
                skip = True
                continue
            if skip and (line.startswith("  ") or line == ""):
                continue
            skip = False
            new_lines.append(line)
        content = "\n".join(new_lines)

    # Ensure trailing newline
    if not content.endswith("\n"):
        content += "\n"

    # Append deep_validation block
    content += "\ndeep_validation:\n"
    content += f'  styles: {yaml.dump(styles, default_flow_style=True).strip()}\n'
    content += f"  confidence: {confidence}\n"
    content += f"  classification_method: \"deep-validation\"\n"
    if summary:
        content += f'  summary: "{summary}"\n'
    if notes:
        # Escape quotes in notes for YAML safety
        safe_notes = notes.replace('"', '\\"').replace("\n", " ")
        content += f'  notes: "{safe_notes}"\n'

    with open(signal_path, "w") as f:
        f.write(content)

    print(f"  OK {name}: {', '.join(styles)} (conf={confidence})")
    return True


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--all", action="store_true", help="Stamp all deep-validated entries")
    parser.add_argument("--entry", nargs="*", help="Specific entry names to stamp")
    args = parser.parse_args()

    if args.all:
        names = [f.replace(".yaml", "") for f in sorted(os.listdir(CATALOG_DIR)) if f.endswith(".yaml")]
    elif args.entry:
        names = args.entry
    else:
        parser.print_help()
        sys.exit(1)

    stamped = 0
    for name in names:
        if stamp_signal_file(name):
            stamped += 1

    print(f"\nStamped {stamped}/{len(names)} signal files with deep_validation block")


if __name__ == "__main__":
    main()
