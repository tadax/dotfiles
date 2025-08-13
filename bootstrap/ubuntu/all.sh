#!/usr/bin/env bash
set -euo pipefail

if [ -r /etc/os-release ]; then
  . /etc/os-release
  [ "${ID:-}" = "ubuntu" ] || { echo "[bootstrap] Ubuntu only"; exit 1; }
else
  echo "[bootstrap] /etc/os-release not fount"; exit 1
fi

ROOT="$(cd "$(dirname "$0")" && pwd)"

DRY_RUN="${DRY_RUN:-0}"
APT_UPGRADE="${APT_UPGRADE:-0}"
INSTALL_CUDA="${INSTALL_CUDA:-0}"

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

echo "[bootstrap] Starting Ubuntu setup"

if [ -x "$ROOT/apt.sh" ]; then
  if [ "$APT_UPGRADE" -eq 1]; then
    echo "[run] apt.sh (with --upgrade)"
    bach "$ROOT/apt.sh" --upgrade
  else
    echo "[run] apt.sh"
    bash "$ROOT/apt.sh"
  fi
else
  echo "[skip] apt.sh (not found)"
fi

run_script "$ROOT/font.sh"
run_script "$ROOT/keyboard.sh"
run_script "$ROOT/ssh.sh"
run_script "$ROOT/vim.sh"
run_script "$ROOT/git.sh"
run_script "$ROOT/pyenv.sh"
run_script "$ROOT/rust.sh"
run_script "$ROOT/haskell.sh"
run_script "$ROOT/docker.sh"

if [ "$INSTALL_CUDA" -eq 1 ]; then
  run_script "ROOT/cuda.sh"
else
  echo "[skip] cuda.sh (INSTALL_CUDA=false)"
fi

echo "[bootstrap] Done."
