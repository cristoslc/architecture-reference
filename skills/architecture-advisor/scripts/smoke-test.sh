#!/usr/bin/env bash
# smoke-test.sh — End-to-end verification of the architecture-advisor sync workflow
#
# Tests:
#   1. Default sync populates expected directories
#   2. .sync-state.yml is valid and contains required fields
#   3. Status command works
#   4. Idempotent re-sync updates timestamp
#   5. Path mappings produce expected structure
#
# Usage:
#   bash scripts/smoke-test.sh
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more checks failed

set -uo pipefail
# Note: no -e; the check() function handles pass/fail explicitly.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SYNC_SCRIPT="$SCRIPT_DIR/sync-references.sh"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- Test workspace ---
# Work in a temp copy so we don't pollute the real skill directory
WORK_DIR="$(mktemp -d)"
cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

# Copy the skill (without any existing references/) to the temp directory
mkdir -p "$WORK_DIR/architecture-advisor/scripts"
cp "$SKILL_DIR/SKILL.md" "$WORK_DIR/architecture-advisor/"
cp "$SYNC_SCRIPT" "$WORK_DIR/architecture-advisor/scripts/"

TEST_SYNC="$WORK_DIR/architecture-advisor/scripts/sync-references.sh"
REFS_DIR="$WORK_DIR/architecture-advisor/references"

PASS=0
FAIL=0

check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    echo "  PASS: $label"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $label"
    FAIL=$((FAIL + 1))
  fi
}

# --- Portable YAML field extractor ---
yaml_field() {
  local file="$1" field="$2"
  grep "  *${field}:" "$file" | head -1 | sed 's/.*: *"\{0,1\}\([^"]*\)"\{0,1\}/\1/' | tr -d ' '
}

echo "=== Architecture Advisor Smoke Test ==="
echo "Working directory: $WORK_DIR"
echo ""

# ============================================================
# Test 1: Default sync populates expected directories
# ============================================================
echo "--- Test 1: Default sync ---"

bash "$TEST_SYNC" >/dev/null 2>&1
SYNC_EXIT=$?

check "sync script exits 0" test "$SYNC_EXIT" -eq 0
check "references/ created" test -d "$REFS_DIR"
check "reference-library/ present" test -d "$REFS_DIR/reference-library"
check "templates/ present" test -d "$REFS_DIR/templates"
check "catalogs/ present" test -d "$REFS_DIR/catalogs"
check "analysis/ present" test -d "$REFS_DIR/analysis"

# ============================================================
# Test 2: Expected catalog sources present
# ============================================================
echo ""
echo "--- Test 2: Catalog sources ---"

check "catalogs/TheKataLog/ present" test -d "$REFS_DIR/catalogs/TheKataLog"
check "catalogs/AOSA/ present" test -d "$REFS_DIR/catalogs/AOSA"
check "catalogs/RealWorldASPNET/ present" test -d "$REFS_DIR/catalogs/RealWorldASPNET"
check "catalogs/ReferenceArchitectures/ present" test -d "$REFS_DIR/catalogs/ReferenceArchitectures"
check "analysis/TheKataLog/ present" test -d "$REFS_DIR/analysis/TheKataLog"

# Spot-check key files
check "solution-spaces.md exists" test -f "$REFS_DIR/reference-library/solution-spaces.md"
check "problem-solution-matrix.md exists" test -f "$REFS_DIR/reference-library/problem-solution-matrix.md"
check "decision-navigator.md exists" test -f "$REFS_DIR/reference-library/decision-navigator.md"
check "TheKataLog _index.yaml exists" test -f "$REFS_DIR/catalogs/TheKataLog/_index.yaml"

# ============================================================
# Test 3: .sync-state.yml is valid
# ============================================================
echo ""
echo "--- Test 3: .sync-state.yml validation ---"

SYNC_STATE="$REFS_DIR/.sync-state.yml"

check ".sync-state.yml exists" test -f "$SYNC_STATE"
check "contains source: key" grep -q "^source:" "$SYNC_STATE"
check "contains sync: key" grep -q "^sync:" "$SYNC_STATE"
check "contains contents: key" grep -q "^contents:" "$SYNC_STATE"

commit_val="$(yaml_field "$SYNC_STATE" "commit" || true)"
check "commit is 40 hex chars ($commit_val)" bash -c "[[ '$commit_val' =~ ^[0-9a-f]{40}$ ]]"

mode_val="$(yaml_field "$SYNC_STATE" "mode" || true)"
check "mode is default ($mode_val)" test "$mode_val" = "default"

at_val="$(yaml_field "$SYNC_STATE" "at" || true)"
check "at is non-empty" test -n "$at_val"

# ============================================================
# Test 4: Status command works
# ============================================================
echo ""
echo "--- Test 4: Status command ---"

STATUS_OUTPUT="$(bash "$TEST_SYNC" --status 2>&1)"
STATUS_EXIT=$?

check "status exits 0" test "$STATUS_EXIT" -eq 0
check "status shows sync state header" bash -c "[[ '$STATUS_OUTPUT' == *'Sync State'* ]]"
check "status shows commit" bash -c "[[ '$STATUS_OUTPUT' == *'commit:'* ]]"

# ============================================================
# Test 5: Idempotent re-sync
# ============================================================
echo ""
echo "--- Test 5: Idempotent re-sync ---"

FIRST_AT="$at_val"

sleep 2

bash "$TEST_SYNC" >/dev/null 2>&1
RESYNC_EXIT=$?

SECOND_AT="$(yaml_field "$SYNC_STATE" "at" || true)"

check "re-sync exits 0" test "$RESYNC_EXIT" -eq 0
check "timestamp updated after re-sync" test "$FIRST_AT" != "$SECOND_AT"
check "reference-library still present" test -d "$REFS_DIR/reference-library"
check "catalogs still present" test -d "$REFS_DIR/catalogs"

# ============================================================
# Test 6: No evidence pool in default mode
# ============================================================
echo ""
echo "--- Test 6: Evidence pool absent in default mode ---"

if [ ! -d "$REFS_DIR/evidence-pool" ]; then
  echo "  PASS: evidence-pool/ not present (correct for default mode)"
  PASS=$((PASS + 1))
else
  echo "  FAIL: evidence-pool/ should not exist in default mode"
  FAIL=$((FAIL + 1))
fi

# ============================================================
# Summary
# ============================================================
echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="

if [ "$FAIL" -gt 0 ]; then
  echo "SMOKE TEST FAILED"
  exit 1
else
  echo "SMOKE TEST PASSED"
  exit 0
fi
