#!/usr/bin/env bash
# batch-classify-tooluse.sh — Run GLM-5 native tool-calling classification on catalog entries
#
# Reads catalog YAML files, clones repos, classifies with GLM-5, and updates
# catalog entries in place. Uses xargs for reliable parallel execution.
#
# Usage:
#   pipeline/batch-classify-tooluse.sh [OPTIONS]
#
# Options:
#   --model <ID>       Model (default: openrouter/z-ai/glm-5)
#   --catalog <PATH>   Catalog directory
#   --parallel <N>     Max parallel classifications (default: 5)
#   --limit <N>        Process at most N entries
#   --offset <N>       Skip first N entries
#   --force            Reclassify even if already classified by this method
#   --dry-run          Show entries without processing

set -uo pipefail

MODEL="openrouter/z-ai/glm-5"
CATALOG_DIR="evidence-analysis/Discovered/docs/catalog"
PARALLEL=5
LIMIT=0
OFFSET=0
FORCE=false
DRY_RUN=false

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLASSIFY_SCRIPT="${SCRIPT_DIR}/classify-tooluse.sh"
RESULTS_DIR="${SCRIPT_DIR}/reports/glm5-results"
CLONE_DIR=".clone-cache"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --model)     MODEL="$2"; shift 2 ;;
    --catalog)   CATALOG_DIR="$2"; shift 2 ;;
    --parallel)  PARALLEL="$2"; shift 2 ;;
    --limit)     LIMIT="$2"; shift 2 ;;
    --offset)    OFFSET="$2"; shift 2 ;;
    --force)     FORCE=true; shift ;;
    --dry-run)   DRY_RUN=true; shift ;;
    -h|--help)   head -17 "$0" | grep '^#' | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

mkdir -p "$RESULTS_DIR"

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }

# ── Build entry list ─────────────────────────────────────────────────────────
build_entries() {
  python3 -c "
import yaml, os, sys

catalog_dir = '$CATALOG_DIR'
force = '$FORCE' == 'true'
offset = $OFFSET
limit = $LIMIT
entries = []
for f in sorted(os.listdir(catalog_dir)):
    if not f.endswith('.yaml'): continue
    path = os.path.join(catalog_dir, f)
    with open(path) as fh:
        d = yaml.safe_load(fh)
    if not d or not isinstance(d, dict): continue

    # Skip if already classified by GLM-5 tool-calling (unless --force)
    if not force:
        method = d.get('classification_method', '')
        model = d.get('classification_model', '')
        if method == 'deep-analysis-tooluse' and 'glm-5' in model:
            continue

    url = d.get('repo_url', d.get('github_url', d.get('source_url', '')))
    name = d.get('project_name', f.replace('.yaml',''))
    if not url:
        print(f'SKIP (no URL): {name}', file=sys.stderr)
        continue
    entries.append(f'{name}|{url}|{path}')

entries = entries[offset:]
if limit > 0:
    entries = entries[:limit]
print('\n'.join(entries))
"
}

# ── Process single entry (called by xargs) ───────────────────────────────────
# Exported as a standalone function via the worker script
export MODEL CLASSIFY_SCRIPT RESULTS_DIR CLONE_DIR

cat > "${RESULTS_DIR}/worker.sh" << 'WORKER_EOF'
#!/usr/bin/env bash
# Worker script — processes a single entry. Called by xargs.
set -u

line="$1"
IFS='|' read -r name url yaml_path <<< "$line"

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }

# Clone if needed
clone_path="${CLONE_DIR}/${name}"
if [[ ! -d "$clone_path/.git" ]]; then
  log "  Cloning $name..."
  git clone --depth 1 "$url" "$clone_path" 2>/dev/null
  if [[ $? -ne 0 ]]; then
    log "  FAIL: $name (clone error)"
    echo "$name" >> "${RESULTS_DIR}/failed.txt"
    exit 0
  fi
fi

result_file="${RESULTS_DIR}/${name}.txt"

# Classify
"$CLASSIFY_SCRIPT" \
  --repo "$url" \
  --name "$name" \
  --model "$MODEL" \
  --clone-dir "$CLONE_DIR" \
  --chain-limit 30 > "$result_file" 2>/dev/null

if [[ $? -ne 0 || ! -s "$result_file" ]]; then
  log "  FAIL: $name (classify error)"
  echo "$name" >> "${RESULTS_DIR}/failed.txt"
  exit 0
fi

# Extract YAML frontmatter from result and write to catalog entry (ADR-005).
# The model outputs YAML between --- delimiters followed by a markdown report.
# We extract the YAML, inject pipeline metadata, and overwrite the catalog entry.
if python3 -c "
import sys, yaml
from datetime import datetime, timezone

result_file = '$result_file'
yaml_path = '$yaml_path'
model = '$MODEL'

with open(result_file) as f:
    text = f.read()

# Extract YAML frontmatter (first --- ... --- block)
parts = text.split('---', 2)
if len(parts) < 3:
    print('No YAML frontmatter found', file=sys.stderr)
    sys.exit(1)

data = yaml.safe_load(parts[1])
if not data or not isinstance(data, dict):
    print('Invalid YAML frontmatter', file=sys.stderr)
    sys.exit(1)

# Inject pipeline metadata
data['classification_model'] = model
data['classification_method'] = 'deep-analysis'
data['classification_date'] = datetime.now(timezone.utc).strftime('%Y-%m-%d')

with open(yaml_path, 'w') as f:
    yaml.dump(data, f, default_flow_style=False, allow_unicode=True, sort_keys=False)

print(f'Updated: {yaml_path}', file=sys.stderr)
" 2>/dev/null; then
  echo "$name" >> "${RESULTS_DIR}/succeeded.txt"
  log "  OK: $name"
else
  log "  FAIL: $name (apply error)"
  echo "$name" >> "${RESULTS_DIR}/failed.txt"
fi
WORKER_EOF
chmod +x "${RESULTS_DIR}/worker.sh"

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  log "GLM-5 Native Tool-Calling Batch Classification"
  log "  Model: $MODEL"
  log "  Catalog: $CATALOG_DIR"
  log "  Parallel: $PARALLEL"

  local entry_list
  entry_list=$(build_entries)

  if [[ -z "$entry_list" ]]; then
    log "No entries to classify."
    exit 0
  fi

  local count
  count=$(echo "$entry_list" | wc -l | tr -d ' ')
  log "Found $count entries to classify"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN — entries that would be classified:"
    echo "$entry_list" | while IFS='|' read -r name url path; do
      echo "  $name — $url"
    done
    exit 0
  fi

  # Clear progress files
  > "${RESULTS_DIR}/succeeded.txt"
  > "${RESULTS_DIR}/failed.txt"

  # Pre-clone all repos serially to avoid conflicts
  log "Pre-cloning repositories..."
  local clone_count=0
  echo "$entry_list" | while IFS='|' read -r name url path; do
    local clone_path="${CLONE_DIR}/${name}"
    if [[ ! -d "$clone_path/.git" ]]; then
      clone_count=$((clone_count + 1))
      git clone --depth 1 "$url" "$clone_path" 2>/dev/null || {
        log "  Clone failed: $name"
      }
    fi
  done
  log "Clone phase complete"

  # Run classifications in parallel using xargs
  log "Starting parallel classification (max $PARALLEL concurrent)..."
  echo "$entry_list" | xargs -P "$PARALLEL" -I {} bash "${RESULTS_DIR}/worker.sh" "{}"

  # Summary
  local succeeded failed
  succeeded=$(wc -l < "${RESULTS_DIR}/succeeded.txt" 2>/dev/null | tr -d ' ')
  failed=$(wc -l < "${RESULTS_DIR}/failed.txt" 2>/dev/null | tr -d ' ')

  log ""
  log "════════════════════════════════════════"
  log "Batch classification complete"
  log "  Total: $count"
  log "  Succeeded: $succeeded"
  log "  Failed: $failed"
  log "  Results: $RESULTS_DIR"
  log "════════════════════════════════════════"

  if [[ "$failed" -gt 0 ]]; then
    log ""
    log "Failed entries:"
    cat "${RESULTS_DIR}/failed.txt" >&2
  fi
}

main "$@"
