#!/usr/bin/env bash
# sync-references.sh — Fetch reference data from architecture-reference-repo
#
# Sparse-clones the source repository and extracts reference data into the
# skill's references/ directory, per the Agent Skills spec (agentskills.io).
#
# Usage:
#   bash scripts/sync-references.sh [options]
#
# Modes:
#   (default)          Reference library, catalogs, analyses, templates (<1 MB)
#   --evidence-pool    Also includes full team submissions (~2.2 GB)
#   --status           Show current sync state without fetching
#
# Options:
#   --ref REF     Branch, tag, or commit to fetch (default: main)
#   --repo URL    Override source repository URL
#
# Requires: git, date
# Outputs:  references/ directory alongside this script's parent SKILL.md

set -euo pipefail

# --- Resolve paths ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REFERENCES_DIR="$SKILL_DIR/references"

# --- Defaults ---
SOURCE_REPO="https://github.com/cristoslc/architecture-reference-repo"
REF="main"
INCLUDE_EVIDENCE_POOL=false
STATUS_ONLY=false

# --- Parse arguments ---
while [ $# -gt 0 ]; do
  case "$1" in
    --evidence-pool) INCLUDE_EVIDENCE_POOL=true; shift ;;
    --status)        STATUS_ONLY=true; shift ;;
    --ref)           REF="${2:?--ref requires a value}"; shift 2 ;;
    --repo)          SOURCE_REPO="${2:?--repo requires a value}"; shift 2 ;;
    -h|--help)
      head -20 "$0" | grep '^#' | sed 's/^# \?//'
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# --- Status check ---
SYNC_STATE="$REFERENCES_DIR/.sync-state.yml"

if $STATUS_ONLY; then
  if [ -f "$SYNC_STATE" ]; then
    echo "=== Sync State ==="
    cat "$SYNC_STATE"
  else
    echo "No references synced yet. Run: bash scripts/sync-references.sh"
  fi
  exit 0
fi

# --- Portable ISO 8601 UTC timestamp ---
iso_timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%SZ"
}

# --- Temp directory with cleanup ---
TMPDIR_WORK="$(mktemp -d)"
cleanup() { rm -rf "$TMPDIR_WORK"; }
trap cleanup EXIT

MODE="default"
$INCLUDE_EVIDENCE_POOL && MODE="evidence-pool"

echo "Syncing references (mode: $MODE) from $SOURCE_REPO (ref: $REF)..."

# --- Sparse clone ---
# Use --filter=blob:none for a treeless clone (downloads blobs on demand)
# then sparse-checkout to materialize only the paths we need.
git clone --depth 1 --filter=blob:none --sparse --quiet \
  "$SOURCE_REPO" "$TMPDIR_WORK/repo" 2>/dev/null || \
git clone --depth 1 --quiet "$SOURCE_REPO" "$TMPDIR_WORK/repo"

cd "$TMPDIR_WORK/repo"

# Checkout the requested ref if not default
if [ "$REF" != "main" ] && [ "$REF" != "HEAD" ]; then
  git fetch --depth 1 origin "$REF" --quiet 2>/dev/null || true
  git checkout --quiet "$REF" 2>/dev/null || true
fi

COMMIT_SHA="$(git rev-parse HEAD)"

# --- Configure sparse-checkout paths ---
# Default: reference library + catalogs + analyses + templates
SPARSE_PATHS="docs/reference-library
docs/templates
evidence-analysis/TheKataLog/docs/catalog
evidence-analysis/TheKataLog/docs/analysis
evidence-analysis/AOSA/docs/catalog
evidence-analysis/AOSA/docs/analysis
evidence-analysis/RealWorldASPNET/docs/catalog
evidence-analysis/RealWorldASPNET/docs/analysis
evidence-analysis/ReferenceArchitectures/docs/catalog
evidence-analysis/ReferenceArchitectures/docs/analysis"

if $INCLUDE_EVIDENCE_POOL; then
  SPARSE_PATHS="$SPARSE_PATHS
evidence-pool/TheKataLog"
fi

# Apply sparse-checkout
git sparse-checkout init --cone
echo "$SPARSE_PATHS" | while IFS= read -r p; do
  [ -n "$p" ] && echo "$p"
done | git sparse-checkout set --stdin

# --- Extract to references/ ---
# Clean previous references (preserve .sync-state.yml until we write the new one)
if [ -d "$REFERENCES_DIR" ]; then
  find "$REFERENCES_DIR" -mindepth 1 -not -name '.sync-state.yml' -delete 2>/dev/null || true
fi
mkdir -p "$REFERENCES_DIR"

# Reference library
if [ -d "docs/reference-library" ]; then
  cp -R docs/reference-library "$REFERENCES_DIR/reference-library"
  echo "  Synced: reference-library/"
fi

# Templates
if [ -d "docs/templates" ]; then
  cp -R docs/templates "$REFERENCES_DIR/templates"
  echo "  Synced: templates/"
fi

# Catalogs — flatten the 4 sources into references/catalogs/<source>/
mkdir -p "$REFERENCES_DIR/catalogs"
for source_dir in evidence-analysis/*/docs/catalog; do
  if [ -d "$source_dir" ]; then
    source_name="$(echo "$source_dir" | cut -d'/' -f2)"
    cp -R "$source_dir" "$REFERENCES_DIR/catalogs/$source_name"
    file_count=$(find "$REFERENCES_DIR/catalogs/$source_name" -name '*.yaml' | wc -l)
    echo "  Synced: catalogs/$source_name/ ($file_count YAML files)"
  fi
done

# Analyses — flatten similarly
mkdir -p "$REFERENCES_DIR/analysis"
for source_dir in evidence-analysis/*/docs/analysis; do
  if [ -d "$source_dir" ]; then
    source_name="$(echo "$source_dir" | cut -d'/' -f2)"
    cp -R "$source_dir" "$REFERENCES_DIR/analysis/$source_name"
    echo "  Synced: analysis/$source_name/"
  fi
done

# Evidence pool (optional)
if $INCLUDE_EVIDENCE_POOL; then
  if [ -d "evidence-pool/TheKataLog" ]; then
    cp -R evidence-pool/TheKataLog "$REFERENCES_DIR/evidence-pool"
    team_count=$(find "$REFERENCES_DIR/evidence-pool" -mindepth 2 -maxdepth 2 -type d | wc -l)
    echo "  Synced: evidence-pool/ ($team_count team directories)"
  fi
fi

# --- Write sync state ---
SYNCED_AT="$(iso_timestamp)"

cat > "$SYNC_STATE" <<YAML
# .sync-state.yml — Reference data provenance
# Machine-generated by sync-references.sh. Do not edit manually.

source:
  repository: ${SOURCE_REPO}
  ref: ${REF}
  commit: ${COMMIT_SHA}

sync:
  mode: ${MODE}
  at: "${SYNCED_AT}"
  by: sync-references.sh

contents:
  - reference-library
  - templates
  - catalogs
  - analysis
YAML

if [ -d "$REFERENCES_DIR/evidence-pool" ]; then
  echo "  - evidence-pool" >> "$SYNC_STATE"
fi

cd "$SKILL_DIR"

# --- Summary ---
REF_SIZE=$(du -sh "$REFERENCES_DIR" 2>/dev/null | cut -f1)
echo ""
echo "OK: References synced ($REF_SIZE)"
echo "  Commit: $COMMIT_SHA"
echo "  Mode:   $MODE"
echo "  Path:   $REFERENCES_DIR"
echo ""
echo "To update:  bash scripts/sync-references.sh"
echo "To check:   bash scripts/sync-references.sh --status"
