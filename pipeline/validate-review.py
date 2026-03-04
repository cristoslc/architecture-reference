#!/usr/bin/env python3
"""Validate LLM classification accuracy against gold standard.

Compares catalog entries (post-LLM-review) against manually verified
classifications. Produces accuracy metrics, per-style precision/recall,
confusion matrix, and confidence calibration report.
"""

import argparse
import json
import os
import random
import sys
from collections import defaultdict

try:
    import yaml

    def load_yaml(path):
        with open(path) as f:
            return yaml.safe_load(f)
except ImportError:
    # Minimal YAML parser for simple list-of-dict structures
    def load_yaml(path):
        with open(path) as f:
            content = f.read()

        # Gold standard: list of entries
        if "- repo:" in content:
            entries = []
            current = {}
            for line in content.split("\n"):
                line = line.rstrip()
                if not line or line.startswith("#"):
                    continue
                if line.startswith("- repo:"):
                    if current:
                        entries.append(current)
                    current = {"repo": line.split(":", 1)[1].strip()}
                elif line.startswith("  ") and ":" in line and current:
                    key, val = line.strip().split(":", 1)
                    val = val.strip()
                    if val.startswith("[") and val.endswith("]"):
                        val = [
                            v.strip().strip('"').strip("'")
                            for v in val[1:-1].split(",")
                            if v.strip()
                        ]
                    elif val.startswith('"') and val.endswith('"'):
                        val = val[1:-1]
                    elif val.startswith("'") and val.endswith("'"):
                        val = val[1:-1]
                    current[key] = val
            if current:
                entries.append(current)
            return entries

        # Catalog entry: flat dict with nested discovery_metadata
        result = {}
        in_styles = False
        styles = []
        in_meta = False
        meta = {}
        for line in content.split("\n"):
            if line.startswith("#"):
                continue
            if line == "architecture_styles:":
                in_styles = True
                in_meta = False
                continue
            if line == "discovery_metadata:":
                in_meta = True
                in_styles = False
                continue
            if in_styles and line.startswith("  - "):
                styles.append(line.strip("- ").strip())
                continue
            if in_styles and not line.startswith("  "):
                in_styles = False
                result["architecture_styles"] = styles
            if in_meta and line.startswith("  ") and ":" in line:
                k, v = line.strip().split(":", 1)
                v = v.strip()
                try:
                    v = float(v)
                except (ValueError, TypeError):
                    pass
                meta[k] = v
                continue
            if in_meta and not line.startswith("  "):
                in_meta = False
                result["discovery_metadata"] = meta

            if ":" in line and not line.startswith(" "):
                key, val = line.split(":", 1)
                val = val.strip()
                if val in ("true", "True"):
                    val = True
                elif val in ("false", "False"):
                    val = False
                result[key] = val

        if styles and "architecture_styles" not in result:
            result["architecture_styles"] = styles
        if meta and "discovery_metadata" not in result:
            result["discovery_metadata"] = meta
        return result


def spot_check(run_report_path, n):
    """Randomly sample N classified entries for manual review."""
    with open(run_report_path) as f:
        report = json.load(f)

    classified = [r for r in report["results"] if r["verdict"] == "classified"]
    if not classified:
        print("No classified entries in report.")
        return

    sample = random.sample(classified, min(n, len(classified)))
    print(f"Spot-check sample ({len(sample)} entries):")
    print()
    for entry in sample:
        print(f"  {entry['entry']}")
        print(f"    Styles: {', '.join(entry['styles'])}")
        print(f"    Confidence: {entry['confidence']}")
        print(f"    Turns: {entry['turns']}")
        print()
    print("Review these entries manually and update gold-standard.yaml if needed.")


def validate(gold_standard_path, catalog_dir, output_path, verbose=False):
    """Compare gold standard against catalog entries."""
    gold_entries = load_yaml(gold_standard_path)
    if not gold_entries:
        print("Error: gold standard is empty")
        sys.exit(1)

    print(f"Loaded {len(gold_entries)} gold standard entries")

    results = []
    correct = 0
    total = 0
    style_tp = defaultdict(int)
    style_fp = defaultdict(int)
    style_fn = defaultdict(int)
    confusion = defaultdict(lambda: defaultdict(int))
    confidence_buckets = defaultdict(lambda: {"correct": 0, "total": 0})
    all_styles = set()

    for entry in gold_entries:
        repo = entry["repo"]
        entry_path = entry.get("entry", f"{catalog_dir}/{repo}.yaml")
        correct_styles = set(entry["correct_styles"])
        all_styles.update(correct_styles)
        tier = entry.get("tier", "?")

        if not os.path.exists(entry_path):
            print(f"  WARNING: catalog entry not found: {entry_path}")
            results.append({"repo": repo, "status": "missing", "tier": tier})
            continue

        catalog = load_yaml(entry_path)
        if not catalog:
            print(f"  WARNING: could not parse: {entry_path}")
            continue

        catalog_styles = set(catalog.get("architecture_styles", ["Indeterminate"]))
        review_required = catalog.get("review_required", True)

        if review_required or catalog_styles == {"Indeterminate"}:
            results.append({
                "repo": repo,
                "status": "not_classified",
                "tier": tier,
                "correct_styles": list(correct_styles),
            })
            continue

        total += 1
        all_styles.update(catalog_styles)

        # Match: LLM styles include at least one correct style
        matched = bool(correct_styles & catalog_styles)
        exact_match = correct_styles == catalog_styles

        if matched:
            correct += 1

        # Confidence calibration
        meta = catalog.get("discovery_metadata", {})
        conf = meta.get("confidence", 0) if isinstance(meta, dict) else 0

        bucket = f"{int(conf * 10) / 10:.1f}"
        confidence_buckets[bucket]["total"] += 1
        if matched:
            confidence_buckets[bucket]["correct"] += 1

        # Per-style metrics
        for style in correct_styles:
            if style in catalog_styles:
                style_tp[style] += 1
            else:
                style_fn[style] += 1
        for style in catalog_styles:
            if style not in correct_styles:
                style_fp[style] += 1

        # Confusion matrix
        for actual in correct_styles:
            for predicted in catalog_styles:
                confusion[actual][predicted] += 1

        result = {
            "repo": repo,
            "status": "match" if matched else "mismatch",
            "exact_match": exact_match,
            "tier": tier,
            "correct_styles": list(correct_styles),
            "llm_styles": list(catalog_styles),
            "confidence": conf,
        }
        results.append(result)

        status = "MATCH" if matched else "MISMATCH"
        if verbose or not matched:
            extra = " (exact)" if exact_match else ""
            print(
                f"  {status}{extra}: {repo} — "
                f"correct={list(correct_styles)}, llm={list(catalog_styles)}"
            )

    # Compute metrics
    accuracy = correct / total if total > 0 else 0
    not_classified = sum(1 for r in results if r["status"] == "not_classified")
    mismatches = [r for r in results if r["status"] == "mismatch"]

    style_metrics = {}
    for style in sorted(all_styles):
        tp = style_tp[style]
        fp = style_fp[style]
        fn = style_fn[style]
        precision = tp / (tp + fp) if (tp + fp) > 0 else 0
        recall = tp / (tp + fn) if (tp + fn) > 0 else 0
        f1 = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
        style_metrics[style] = {
            "precision": round(precision, 3),
            "recall": round(recall, 3),
            "f1": round(f1, 3),
            "true_positives": tp,
            "false_positives": fp,
            "false_negatives": fn,
        }

    calibration = {}
    for bucket in sorted(confidence_buckets.keys()):
        data = confidence_buckets[bucket]
        calibration[bucket] = {
            "accuracy": round(data["correct"] / data["total"], 3) if data["total"] > 0 else 0,
            "count": data["total"],
        }

    report = {
        "gold_standard_entries": len(gold_entries),
        "classified_entries": total,
        "not_yet_classified": not_classified,
        "accuracy": round(accuracy, 3),
        "correct": correct,
        "mismatches": len(mismatches),
        "passes_threshold": accuracy >= 0.85,
        "style_metrics": style_metrics,
        "confidence_calibration": calibration,
        "confusion_matrix": {k: dict(v) for k, v in confusion.items()},
        "results": results,
    }

    with open(output_path, "w") as f:
        json.dump(report, f, indent=2)

    # Print summary
    print()
    print("=" * 60)
    print("VALIDATION REPORT")
    print("=" * 60)
    print(f"Gold standard entries:  {len(gold_entries)}")
    print(f"Classified (testable):  {total}")
    print(f"Not yet classified:     {not_classified}")
    print()

    if total > 0:
        print(f"Accuracy:               {accuracy:.1%} ({correct}/{total})")
        print(f"Passes 85% threshold:   {'YES' if accuracy >= 0.85 else 'NO'}")
        print()

        if mismatches:
            print("Mismatches:")
            for m in mismatches:
                print(f"  {m['repo']}: correct={m['correct_styles']}, llm={m['llm_styles']}")
            print()

        print("Per-style metrics:")
        print(f"  {'Style':<25} {'Prec':>6} {'Rec':>6} {'F1':>6}")
        print(f"  {'-' * 25} {'-' * 6} {'-' * 6} {'-' * 6}")
        for style in sorted(style_metrics.keys()):
            m = style_metrics[style]
            print(f"  {style:<25} {m['precision']:>6.3f} {m['recall']:>6.3f} {m['f1']:>6.3f}")
    else:
        print("No classified entries to validate. Run llm-review.sh first.")

    print()
    print(f"Report saved to: {output_path}")

    if total > 0 and accuracy < 0.85:
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Validate LLM review accuracy")
    parser.add_argument("--gold-standard", default="pipeline/gold-standard/gold-standard.yaml")
    parser.add_argument("--catalog", default="evidence-analysis/Discovered/docs/catalog")
    parser.add_argument("--output", default="")
    parser.add_argument("--verbose", action="store_true")
    parser.add_argument("--run-report", default="")
    parser.add_argument("--spot-check", type=int, default=0)
    args = parser.parse_args()

    if args.spot_check > 0:
        if not args.run_report:
            print("Error: --spot-check requires --run-report", file=sys.stderr)
            sys.exit(1)
        spot_check(args.run_report, args.spot_check)
        return

    if not args.output:
        os.makedirs("pipeline/reports", exist_ok=True)
        args.output = f"pipeline/reports/validation-{os.popen('date +%Y%m%d-%H%M%S').read().strip()}.json"

    validate(args.gold_standard, args.catalog, args.output, args.verbose)


if __name__ == "__main__":
    main()
