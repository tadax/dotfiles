#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

DO_BOOTSTRAP=0
DO_INSTALL=1
DO_POST=1
BOOTSTRAP_UPGRADE=0
INSTALL_CUDA=0

usage(){
  cat <<USAGE
Usage: $0 [--bootstrap] [--upgrade] [--cuda] [--no-install] [--no-post] [-h|--help]
  --bootstrap     Run package bootstrap (apt/brew etc.)
  --upgrade       (bootstrap) Upgrade packages where applicable
  --cuda          (bootstrap) Install CUDA toolchain (Ubuntu only)
  --no-install    Skip stow linking phase
  --no-post       Skip post/apply phase
USAGE
}

while [ "${1:-}" != "" ]; do
  case "$1" in
    --bootstrap)  DO_BOOTSTRAP=1 ;;
    --upgrade)    BOOTSTRAP_UPGRADE=1 ;;
    --cuda)       INSTALL_CUDA=1 ;;
    --no-install) DO_INSTALL=0 ;;
    --no-post)    DO_POST=0 ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

# Detect OS
OS="unknown"
if command -v apt-get >/dev/null 2>&1; then
  OS="ubuntu"
elif [ "$(uname -s)" = "Darwin" ] || command -v brew >/dev/null 2>&1; then
  OS="macos"
fi

if [ "$OS" = "unknown" ]; then
  echo "[detect] Unsupported OS"; exit 1
fi

# 1) bootstrap
if [ "$DO_BOOTSTRAP" -eq 1 ]; then
  echo "[bootstrap:$OS] start"
  if [ "$OS" = "ubuntu" ]; then
    BOOTSTRAP_UPGRADE="$BOOTSTRAP_UPGRADE" INSTALL_CUDA="$INSTALL_CUDA" \
      bash "$ROOT/bootstrap/ubuntu/all.sh"
  elif [ "$OS" = "macos" ]; then
    bash "$ROOT/bootstrap/macos/all.sh"
  else
    echo "[bootstrap] Unsupported OS"; exit 1
  fi
  echo "[bootstrap:$OS] done"
fi

# 2) install (stow)
if [ "$DO_INSTALL" -eq 1 ]; then
  echo "[install] Linking public packages"
  bash "$ROOT/install.sh"
  echo "[install] done"
fi

# 3) post/apply
if [ "$DO_POST" -eq 1 ]; then
  echo "[post:$OS] start"
  if [ "$OS" = "ubuntu" ]; then
    bash "$ROOT/scripts/ubuntu/all.sh"
  elif [ "$OS" = "macos" ]; then
    bash "$ROOT/scripts/macos/all.sh"
  else
    echo "[post] Unsupported OS"; exit 1
  fi
  echo "[post:$OS] done"
fi
