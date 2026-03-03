#!/usr/bin/env bash
# run-pipeline.sh — Batch discovery pipeline for SPEC-002
#
# Reads pipeline/manifest.yaml, shallow-clones repos, runs signal extraction
# and heuristic classification, writes catalog entries.
#
# Usage:
#   bash pipeline/run-pipeline.sh [options]
#
# Options:
#   -j N         Concurrency (parallel clones). Default: 4
#   -m FILE      Manifest file. Default: pipeline/manifest.yaml
#   -o DIR       Output catalog directory. Default: evidence-analysis/Discovered/docs/catalog
#   -n N         Process only first N repos (for testing). Default: all
#   --dry-run    Show what would be done without cloning or classifying
#   --no-clean   Keep cloned repos in temp directory (for debugging)
#
# Requires: git, python3, bash, grep, sed

set -uo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EXTRACT_SCRIPT="$REPO_ROOT/skills/discover-architecture/scripts/extract-signals.sh"
CLASSIFY_SCRIPT="$SCRIPT_DIR/classify.py"

MANIFEST="$SCRIPT_DIR/manifest.yaml"
OUTPUT_DIR="$REPO_ROOT/evidence-analysis/Discovered/docs/catalog"
CONCURRENCY=4
LIMIT=0
DRY_RUN=false
NO_CLEAN=false

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -j) CONCURRENCY="$2"; shift 2 ;;
        -m) MANIFEST="$2"; shift 2 ;;
        -o) OUTPUT_DIR="$2"; shift 2 ;;
        -n) LIMIT="$2"; shift 2 ;;
        --dry-run) DRY_RUN=true; shift ;;
        --no-clean) NO_CLEAN=true; shift ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
done

# --- Validation ---
if [[ ! -f "$MANIFEST" ]]; then
    echo "Error: manifest not found: $MANIFEST" >&2
    exit 1
fi
if [[ ! -f "$EXTRACT_SCRIPT" ]]; then
    echo "Error: extract-signals.sh not found: $EXTRACT_SCRIPT" >&2
    exit 1
fi
if [[ ! -f "$CLASSIFY_SCRIPT" ]]; then
    echo "Error: classify.py not found: $CLASSIFY_SCRIPT" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# --- Temp directory for clones ---
CLONE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/pipeline-clones.XXXXXX")"
cleanup() {
    if [[ "$NO_CLEAN" == "false" ]]; then
        rm -rf "$CLONE_DIR"
    else
        echo "Cloned repos preserved at: $CLONE_DIR"
    fi
}
trap cleanup EXIT

# --- Parse manifest ---
# Minimal YAML extraction: pull url and domain fields from each repo entry.
# This avoids requiring PyYAML for the shell orchestrator.

parse_manifest() {
    local url="" domain="" priority=""
    while IFS= read -r line; do
        # Strip leading whitespace
        local stripped="${line#"${line%%[![:space:]]*}"}"

        # Skip comments and blank lines
        [[ -z "$stripped" || "$stripped" == \#* ]] && continue

        # New repo entry
        if [[ "$stripped" == "- url:"* ]]; then
            # Emit previous entry if complete
            if [[ -n "$url" ]]; then
                echo "${url}|${domain}|${priority}"
            fi
            url="${stripped#*: }"
            url="${url%\"}"
            url="${url#\"}"
            domain=""
            priority="2"
        elif [[ "$stripped" == "domain:"* ]]; then
            domain="${stripped#*: }"
            domain="${domain%\"}"
            domain="${domain#\"}"
        elif [[ "$stripped" == "priority:"* ]]; then
            priority="${stripped#*: }"
            priority="${priority%\"}"
            priority="${priority#\"}"
        fi
    done < "$MANIFEST"
    # Emit last entry
    if [[ -n "$url" ]]; then
        echo "${url}|${domain}|${priority}"
    fi
}

# --- Process a single repo ---
process_repo() {
    local url="$1" domain="$2" priority="$3"

    # Derive project name from URL
    local name
    name="$(basename "$url" .git)"

    # Idempotency: skip if catalog entry already exists
    local outfile="$OUTPUT_DIR/${name}.yaml"
    if [[ -f "$outfile" ]]; then
        echo "  SKIP $name (already cataloged)"
        return 0
    fi

    if [[ "$DRY_RUN" == "true" ]]; then
        echo "  WOULD process: $name ($url)"
        return 0
    fi

    # Shallow clone
    local clone_path="$CLONE_DIR/$name"
    if ! git clone --depth 1 --quiet "$url" "$clone_path" 2>/dev/null; then
        echo "  FAIL $name (clone failed)" >&2
        return 1
    fi

    # Extract signals
    local signals
    signals="$(bash "$EXTRACT_SCRIPT" "$clone_path" 2>/dev/null)"
    if [[ -z "$signals" ]]; then
        echo "  FAIL $name (no signals)" >&2
        rm -rf "$clone_path"
        return 1
    fi

    # Classify
    local catalog_entry
    if [[ -n "$domain" ]]; then
        catalog_entry="$(echo "$signals" | python3 "$CLASSIFY_SCRIPT" --domain "$domain" 2>/dev/null)"
    else
        catalog_entry="$(echo "$signals" | python3 "$CLASSIFY_SCRIPT" 2>/dev/null)"
    fi
    if [[ -z "$catalog_entry" ]]; then
        echo "  FAIL $name (classification failed)" >&2
        rm -rf "$clone_path"
        return 1
    fi

    # Write catalog entry
    echo "$catalog_entry" > "$outfile"
    echo "  OK   $name"

    # Clean up clone immediately to save disk space
    rm -rf "$clone_path"
    return 0
}

# --- Main ---
echo "Dataset Scaling Pipeline (SPEC-002)"
echo "===================================="
echo "Manifest: $MANIFEST"
echo "Output:   $OUTPUT_DIR"
echo "Concurrency: $CONCURRENCY"
echo ""

# Parse all repos from manifest
REPOS=()
while IFS= read -r entry; do
    REPOS+=("$entry")
done < <(parse_manifest)

TOTAL=${#REPOS[@]}
echo "Found $TOTAL repos in manifest"

if [[ "$LIMIT" -gt 0 && "$LIMIT" -lt "$TOTAL" ]]; then
    echo "Limiting to first $LIMIT repos"
    REPOS=("${REPOS[@]:0:$LIMIT}")
    TOTAL=$LIMIT
fi

echo ""

# Process repos with basic concurrency control
PROCESSED=0
SUCCEEDED=0
FAILED=0
SKIPPED=0
RUNNING=0

for entry in "${REPOS[@]}"; do
    IFS='|' read -r url domain priority <<< "$entry"
    PROCESSED=$((PROCESSED + 1))
    echo "[$PROCESSED/$TOTAL] $url"

    # Simple sequential processing (parallel support via xargs in future)
    # Check if already cataloged (for skip counting)
    local_outfile="$OUTPUT_DIR/$(basename "$url" .git).yaml"
    if [[ -f "$local_outfile" && "$DRY_RUN" == "false" ]]; then
        process_repo "$url" "$domain" "$priority"
        SKIPPED=$((SKIPPED + 1))
    elif process_repo "$url" "$domain" "$priority"; then
        SUCCEEDED=$((SUCCEEDED + 1))
    else
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "===================================="
echo "Pipeline complete"
echo "  Total:     $TOTAL"
echo "  Succeeded: $SUCCEEDED"
echo "  Skipped:   $SKIPPED"
echo "  Failed:    $FAILED"
