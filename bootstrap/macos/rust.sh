#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "[rust] Homebrew not found. Please run bootstrap/macos/brew.sh first." >&2
  exit 1
fi

if ! brew list --formula rustup >/dev/null 2>&1; then
  echo "[rust] Installing rustup"
  HOMEBREW_NO_ASK=1 brew install rustup
else
  echo "[rust] rustup is already installed"
fi

RUSTUP_BIN="$(brew --prefix rustup)/bin"
export PATH="$RUSTUP_BIN:$PATH"

if ! rustup show active-toolchain >/dev/null 2>&1; then
  echo "[rust] Installing the stable toolchain"
  rustup default stable
fi

echo "[rust] Done. Version info: $(rustc --version) / $(cargo --version)"
