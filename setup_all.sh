#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
DO_BOOTSTRAP=false
INSTALL_CUDA=false

usage(){ echo "Usage: $0 [--bootstrap] [--upgrade]"; }

while [ "${1:-}" != "" ]; do
  case "$1" in
    --bootstrap) DO_BOOTSTRAP=true ;;
    --upgrade)   BOOTSTRAP_UPGRADE=true ;;
    --cuda)      INSTALL_CUDA=true ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

if $DO_BOOTSTRAP; then
  if command -v apt-get >/dev/null 2>&1; then
    args=()
    [ "${BOOTSTRAP_UPGRADE:-false}" = true ] && args+=(--upgrade)
    bash "$ROOT/bootstrap/ubuntu/apt.sh" "${args[@]}"
    bash "$ROOT/bootstrap/ubuntu/ssh.sh"
    bash "$ROOT/bootstrap/ubuntu/git.sh"
    bash "$ROOT/bootstrap/ubuntu/docker.sh"
    bash "$ROOT/bootstrap/ubuntu/pyenv.sh"
    bash "$ROOT/bootstrap/ubuntu/haskell.sh"
    if [ "${INSTALL_CUDA:-false}" = true ]; then
      bash "$ROOT/bootstrap/ubuntu/cuda.sh"
    fi
  elif command -v brew >/dev/null 2>&1 || [ "$(uname -s)" = "Darwin" ]; then
    bash "$ROOT/bootstrap/macos/brew.sh"
  else
    echo "[bootstrap] Unsupported OS or no package manager found"; exit 1
  fi
fi

echo "[public] Linking public packages"
bash "$ROOT/install.sh"
