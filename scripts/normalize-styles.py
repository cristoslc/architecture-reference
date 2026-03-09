#!/usr/bin/env python3
"""Normalize architecture style names in catalog YAML files.

Applies a canonical mapping table so all catalog entries use Ford's
chapter titles from Fundamentals of Software Architecture. Does not
modify any other fields — only `architecture_styles` list entries.

Usage:
    python3 scripts/normalize-styles.py                    # dry-run (default)
    python3 scripts/normalize-styles.py --apply            # modify files in place
    python3 scripts/normalize-styles.py --catalog-dir path # custom catalog path
"""

import argparse
import os

# Canonical mapping: variant name → Ford's chapter title.
# Add new entries here when deep-analysis or other classifiers
# introduce variant spellings of known styles.
STYLE_ALIASES = {
    # Microkernel Architecture (Ch. 12) — also known as plug-in architecture
    "Microkernel (Plugin)": "Microkernel",
    "Plugin/Microkernel": "Microkernel",
    "Plugin Architecture": "Microkernel",
    "Plug-in": "Microkernel",
    # Pipeline Architecture (Ch. 11) — also known as pipe-and-filter
    "Pipeline (Pipe-and-Filter)": "Pipeline",
    "Pipe-and-Filter": "Pipeline",
    "Pipes and Filters": "Pipeline",
}


def normalize_file(path, apply=False):
    """Normalize style names in a single YAML file. Returns list of changes."""
    with open(path) as f:
        raw = f.read()

    modified = raw
    changes = []
    for old, new in STYLE_ALIASES.items():
        target = f"- {old}"
        replacement = f"- {new}"
        if target in modified:
            changes.append((old, new))
            modified = modified.replace(target, replacement)

    if changes and apply:
        with open(path, "w") as f:
            f.write(modified)

    return changes


def main():
    default_catalog = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "..", "evidence-analysis", "Discovered", "docs", "catalog",
    )

    parser = argparse.ArgumentParser(
        description="Normalize architecture style names in catalog YAML files",
    )
    parser.add_argument("--catalog-dir", default=default_catalog,
                        help="Path to catalog directory")
    parser.add_argument("--apply", action="store_true",
                        help="Modify files in place (default is dry-run)")
    args = parser.parse_args()

    total_changes = 0
    for fname in sorted(os.listdir(args.catalog_dir)):
        if not fname.endswith(".yaml") or fname.startswith("_"):
            continue
        path = os.path.join(args.catalog_dir, fname)
        changes = normalize_file(path, apply=args.apply)
        if changes:
            total_changes += 1
            for old, new in changes:
                print(f"  {fname}: {old} → {new}")

    mode = "updated" if args.apply else "would update (dry-run)"
    print(f"\n{total_changes} files {mode}")
    if not args.apply and total_changes > 0:
        print("Run with --apply to modify files.")


if __name__ == "__main__":
    main()
