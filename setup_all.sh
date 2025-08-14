#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

DO_BOOTSTRAP=0
BOOTSTRAP_UPGRADE=0
INSTALL_CUDA=0

usage(){ echo "Usage: $0 [--bootstrap] [--upgrade] [--cuda]"; }

while [ "${1:-}" != "" ]; do
  case "$1" in
    --bootstrap) DO_BOOTSTRAP=1 ;;
    --upgrade)   APT_UPGRADE=1 ;;
    --cuda)      INSTALL_CUDA=1 ;;
    -h|--help)   usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

if [ "$DO_BOOTSTRAP" -eq 1 ]; then
  if command -v apt-get >/dev/null 2>&1; then
    APT_UPGRADE="$APT_UPGRADE" \
    INSTALL_CUDA="$INSTALL_CUDA" \
      bash "$ROOT/bootstrap/ubuntu/all.sh"
  elif [ "$(uname -s)" = "Darwin" ] || command -v brew >/dev/null 2>&1; then
    bash "$ROOT/bootstrap/macos/all.sh"
  else
    echo "[bootstrap] Unsupported OS or no package manager found"; exit 1
  fi
fi

echo "[public] Linking public packages"
bash "$ROOT/install.sh"
