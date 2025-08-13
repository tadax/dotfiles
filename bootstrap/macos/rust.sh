#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "$HOME/.cargo" ]; then
  echo "[rust] Installing rustup (will prompt)"
    # cf. https://zenn.dev/icck/articles/f2e8ecaf6bd8bf
    brew install rustup-init
    rustup-init -y
else
  echo "[rust] Already installed at $HOME/.cargo"
fi

if command -v cargo >/dev/null 2>&1; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

echo "[rust] Done. Version info: $(rustc --version) / $(cargo --version)"
