#!/usr/bin/env bash
# classify-tooluse.sh — Classify a repo using native LLM tool-calling
#
# Clones a repo and gives the model tool access to explore it interactively.
# The model drives its own investigation — no script-mediated multi-turn.
#
# Usage:
#   pipeline/classify-tooluse.sh --repo <URL> --name <project> [OPTIONS]
#
# Options:
#   --repo <URL>       Repository URL to clone
#   --name <NAME>      Project name (for output)
#   --model <ID>       Model to use (default: openrouter/z-ai/glm-5)
#   --chain-limit <N>  Max tool-calling rounds (default: 30)
#   --clone-dir <DIR>  Clone cache directory (default: .clone-cache)
#   --verbose          Show tool debug output
#   --dry-run          Show what would be done without calling the model

set -uo pipefail

MODEL="openrouter/z-ai/glm-5"
CHAIN_LIMIT=15
CLONE_DIR=".clone-cache"
VERBOSE=false
DRY_RUN=false
REPO_URL=""
PROJECT_NAME=""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_FILE="${SCRIPT_DIR}/tools/repo_tools.py"
SYSTEM_PROMPT_FILE="${SCRIPT_DIR}/prompts/system-prompt-tooluse.md"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)         REPO_URL="$2"; shift 2 ;;
    --name)         PROJECT_NAME="$2"; shift 2 ;;
    --model)        MODEL="$2"; shift 2 ;;
    --chain-limit)  CHAIN_LIMIT="$2"; shift 2 ;;
    --clone-dir)    CLONE_DIR="$2"; shift 2 ;;
    --verbose)      VERBOSE=true; shift ;;
    --dry-run)      DRY_RUN=true; shift ;;
    -h|--help)      head -15 "$0" | grep '^#' | sed 's/^# \?//'; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$REPO_URL" || -z "$PROJECT_NAME" ]]; then
  echo "Error: --repo and --name are required" >&2
  exit 1
fi

if ! command -v llm &>/dev/null; then
  echo "Error: 'llm' CLI not found" >&2
  exit 1
fi

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }

# ── Clone repo ────────────────────────────────────────────────────────────────
clone_repo() {
  local url="$1" name="$2"
  local clone_path="${CLONE_DIR}/${name}"

  if [[ -d "$clone_path/.git" ]]; then
    log "Using cached clone: $clone_path"
  else
    log "Cloning $url → $clone_path"
    mkdir -p "$CLONE_DIR"
    git clone --depth 1 "$url" "$clone_path" 2>/dev/null
  fi

  echo "$clone_path"
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  local clone_path
  clone_path=$(clone_repo "$REPO_URL" "$PROJECT_NAME")

  if [[ ! -d "$clone_path" ]]; then
    echo "Error: clone failed for $REPO_URL" >&2
    exit 1
  fi

  local system_prompt
  system_prompt=$(cat "$SYSTEM_PROMPT_FILE")

  local user_prompt="Classify the architecture of the **${PROJECT_NAME}** repository.

The repository is cloned and available via your tools. Start exploring and classify when you have sufficient evidence.

Repository: ${REPO_URL}"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN — would classify $PROJECT_NAME"
    log "  Model: $MODEL"
    log "  Repo: $REPO_URL"
    log "  Clone: $clone_path"
    log "  Chain limit: $CHAIN_LIMIT"
    exit 0
  fi

  log "Classifying $PROJECT_NAME with $MODEL (chain-limit=$CHAIN_LIMIT)"

  local tool_debug_flag=""
  if [[ "$VERBOSE" == "true" ]]; then
    tool_debug_flag="--td"
  fi

  # Run classification with native tool-calling
  REPO_ROOT="$clone_path" llm prompt \
    -m "$MODEL" \
    -s "$system_prompt" \
    --functions "$TOOLS_FILE" \
    --chain-limit "$CHAIN_LIMIT" \
    $tool_debug_flag \
    "$user_prompt" 2>/dev/null

  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    log "Error: llm exited with code $exit_code"
    exit $exit_code
  fi
}

main "$@"
