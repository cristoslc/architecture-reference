#!/usr/bin/env bash
# smoke-test.sh — End-to-end verification of the remote skill fetch-and-stamp workflow
#
# Fetches the architecture-advisor skill from this repository as a self-referential
# test (no external dependency required). Validates provenance manifest generation,
# integrity hashing, and idempotent re-fetch.
#
# Usage:
#   bash scripts/smoke-test.sh [repo-url]
#
# Arguments:
#   repo-url — Git remote URL to fetch from (default: this repo's origin)
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more checks failed

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FETCH_SCRIPT="$SCRIPT_DIR/fetch-remote-skill.sh"

# --- Configuration ---
REPO_URL="${1:-$(git remote get-url origin 2>/dev/null || echo "https://github.com/cristoslc/architecture-reference-repo")}"
SKILL_PATH="skills/architecture-advisor"
SKILL_NAME="architecture-advisor"

# --- Test workspace ---
WORK_DIR="$(mktemp -d)"
TARGET_DIR="$WORK_DIR/skills"
mkdir -p "$TARGET_DIR"
cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

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

# --- Portable sha256 (matches fetch script) ---
sha256_hash() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 | cut -d' ' -f1
  else
    echo "ERROR: Neither sha256sum nor shasum found" >&2
    exit 1
  fi
}

# --- Portable YAML field extractor (no yq dependency) ---
yaml_field() {
  local file="$1" field="$2"
  grep "  *${field}:" "$file" | head -1 | sed 's/.*: *"\{0,1\}\([^"]*\)"\{0,1\}/\1/' | tr -d ' '
}

echo "=== Remote Skill Manager Smoke Test ==="
echo "Repo:       $REPO_URL"
echo "Skill path: $SKILL_PATH"
echo "Target:     $TARGET_DIR"
echo ""

# ============================================================
# AC-1: Fetch clones a public repo, extracts a skill directory,
#        and writes it to the target skills path.
# ============================================================
echo "--- AC-1: Fetch and extract ---"

bash "$FETCH_SCRIPT" "$REPO_URL" "$SKILL_PATH" HEAD "$TARGET_DIR"
FETCH_EXIT=$?

check "fetch script exits 0" test "$FETCH_EXIT" -eq 0
check "skill directory created" test -d "$TARGET_DIR/$SKILL_NAME"
check "SKILL.md present" test -f "$TARGET_DIR/$SKILL_NAME/SKILL.md"
check "scripts/ directory present" test -d "$TARGET_DIR/$SKILL_NAME/scripts"
check "sync-references.sh present" test -f "$TARGET_DIR/$SKILL_NAME/scripts/sync-references.sh"

# ============================================================
# AC-2: A valid .source.yml is generated alongside the skill.
# ============================================================
echo ""
echo "--- AC-2: .source.yml exists and is valid ---"

SOURCE_YML="$TARGET_DIR/$SKILL_NAME/.source.yml"

check ".source.yml exists" test -f "$SOURCE_YML"
check ".source.yml contains source: key" grep -q "^source:" "$SOURCE_YML"
check ".source.yml contains skill: key" grep -q "^skill:" "$SOURCE_YML"
check ".source.yml contains fetched: key" grep -q "^fetched:" "$SOURCE_YML"
check ".source.yml contains integrity: key" grep -q "^integrity:" "$SOURCE_YML"

# ============================================================
# AC-3: All required fields are populated and non-empty.
# ============================================================
echo ""
echo "--- AC-3: Required fields populated ---"

for field in repository ref commit path; do
  val="$(yaml_field "$SOURCE_YML" "$field" || true)"
  check "source.$field is non-empty ($val)" test -n "$val"
done

name_val="$(yaml_field "$SOURCE_YML" "name" || true)"
check "skill.name is non-empty ($name_val)" test -n "$name_val"
check "skill.name matches directory ($name_val)" test "$name_val" = "$SKILL_NAME"

at_val="$(yaml_field "$SOURCE_YML" "at" || true)"
check "fetched.at is non-empty ($at_val)" test -n "$at_val"

by_val="$(yaml_field "$SOURCE_YML" "by" || true)"
check "fetched.by is non-empty ($by_val)" test -n "$by_val"

algo_val="$(yaml_field "$SOURCE_YML" "algorithm" || true)"
check "integrity.algorithm is sha256 ($algo_val)" test "$algo_val" = "sha256"

digest_val="$(yaml_field "$SOURCE_YML" "digest" || true)"
check "integrity.digest is non-empty" test -n "$digest_val"
check "integrity.digest is 64 hex chars" bash -c "[[ '$digest_val' =~ ^[0-9a-f]{64}$ ]]"

# ============================================================
# AC-4: Integrity digest matches a fresh computation.
# ============================================================
echo ""
echo "--- AC-4: Integrity digest verification ---"

FRESH_DIGEST="$(cd "$TARGET_DIR" && find "$SKILL_NAME" -type f ! -name '.source.yml' -print0 | sort -z | while IFS= read -r -d '' f; do printf '%s\n' "$f"; cat "$f"; done | sha256_hash)"
check "fresh digest matches recorded" test "$FRESH_DIGEST" = "$digest_val"

# ============================================================
# AC-5: Re-running updates fetched.at and source.commit.
# ============================================================
echo ""
echo "--- AC-5: Idempotent re-fetch ---"

FIRST_AT="$at_val"
FIRST_COMMIT="$(yaml_field "$SOURCE_YML" "commit" || true)"

sleep 2

bash "$FETCH_SCRIPT" "$REPO_URL" "$SKILL_PATH" HEAD "$TARGET_DIR" >/dev/null 2>&1

SECOND_AT="$(yaml_field "$SOURCE_YML" "at" || true)"
SECOND_COMMIT="$(yaml_field "$SOURCE_YML" "commit" || true)"

check "fetched.at changed after re-fetch" test "$FIRST_AT" != "$SECOND_AT"
check "source.commit is a valid SHA ($SECOND_COMMIT)" bash -c "[[ '$SECOND_COMMIT' =~ ^[0-9a-f]{40}$ ]]"
check "SKILL.md still present after re-fetch" test -f "$TARGET_DIR/$SKILL_NAME/SKILL.md"

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
