#!/usr/bin/env bash
set -euo pipefail

export HOMEBREW_NO_ASK=1

ROOT="$(cd "$(dirname "$0")" && pwd)"

DRY_RUN="${DRY_RUN:-0}"

run_script() {
  local script="$1"
  [ -x "$script" ] || { echo "[skip] $script (not found or not executable)"; return; }

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $script"
  else
    echo "[run] $script"
    bash "$script"
  fi
}

echo "[bootstrap] Starting macos setup"
run_script "$ROOT/brew.sh"
run_script "$ROOT/shell.sh"
run_script "$ROOT/defaults.sh"
run_script "$ROOT/vim.sh"
run_script "$ROOT/ssh.sh"
run_script "$ROOT/pyenv.sh"
run_script "$ROOT/rust.sh"
run_script "$ROOT/haskell.sh"
run_script "$ROOT/node.sh"

echo "[bootstrap] Done."
