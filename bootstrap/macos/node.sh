#!/usr/bin/env bash
set -euo pipefail

if command -v brew >/dev/null 2>&1; then
  # https://github.com/tj/n
  brew install n
  n install latest
fi

echo "[node] Done. Current node: $(node -V) (via tj/n)"
