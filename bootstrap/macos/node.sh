#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "[node] Homebrew not found. Please run bootstrap/macos/brew.sh first." >&2
  exit 1
fi

# Install Node.js under the user's home directory instead of /usr/local/n.
export N_PREFIX="${N_PREFIX:-$HOME/.n}"
export PATH="$N_PREFIX/bin:$PATH"

if ! brew list --formula n >/dev/null 2>&1; then
  HOMEBREW_NO_ASK=1 brew install n
fi

# https://github.com/tj/n
n install latest

echo "[node] Done. Current node: $(node -V) (via tj/n)"
