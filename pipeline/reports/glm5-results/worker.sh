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

# Apply result
if python3 "$APPLY_SCRIPT" --result "$result_file" --entry "$yaml_path" --model "$MODEL" 2>/dev/null; then
  echo "$name" >> "${RESULTS_DIR}/succeeded.txt"
  log "  OK: $name"
else
  log "  FAIL: $name (apply error)"
  echo "$name" >> "${RESULTS_DIR}/failed.txt"
fi
