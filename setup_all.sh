#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
DO_BOOTSTRAP=false

usage(){ echo "Usage: $0 [--bootstrap] [--upgrade]"; }

while [ "${1:-}" != "" ]; do
  case "$1" in
    --bootstrap) DO_BOOTSTRAP=true ;;
    --upgrade)   BOOTSTRAP_UPGRADE=true ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

if $DO_BOOTSTRAP; then
  if command -v apt-get >/dev/null 2>&1; then
    args=()
    [ "${BOOTSTRAP_UPGRADE:-false}" = true ] && args+=(--upgrade)
    bash "$ROOT/bootstrap/apt.sh" "${args[@]}"
    bash "$ROOT/bootstrap/git.sh"
    bash "$ROOT/bootstrap/docker_ubuntu.sh"
    bash "$ROOT/bootstrap/pyenv.sh"
    bash "$ROOT/bootstrap/haskell_ubuntu.sh"
    bash "$ROOT/bootstrap/cuda_ubuntu.sh"
  elif command -v brew >/dev/null 2>&1 || [ "$(uname -s)" = "Darwin" ]; then
    bash "$ROOT/bootstrap/brew.sh"
  else
    echo "[bootstrap] Unsupported OS or no package manager found"; exit 1
  fi
fi

echo "[public] Linking public packages"
bash "$ROOT/install.sh"

echo "[private] Trying to clone/update private repo (optional)"
if [ -x "$ROOT/scripts/install_private.sh" ]; then
  DOTFILES_PRIVATE_URL="${DOTFILES_PRIVATE_URL:-}" \
  DOTFILES_PRIVATE_DIR="${DOTFILES_PRIVATE_DIR:-$HOME/.dotfiles-private}" \
  DOTFILES_PRIVATE_BRANCH="${DOTFILES_PRIVATE_BRANCH:-master}" \
  bash "$ROOT/scripts/install_private.sh"
fi
