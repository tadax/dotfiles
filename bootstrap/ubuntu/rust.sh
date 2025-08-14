#!/usr/bin/env bash
set -euo pipefail

# cf. https://doc.rust-jp.rs/book-ja/ch01-01-installation.html
RUSTUP_URL="https://sh.rustup.rs"

if [ ! -d "$HOME/.cargo" ]; then
  echo "[rust] Installing rustup (will prompt)"
  curl --proto '=https' --tlsv1.2 "$RUSTUP_URL" -sSf | sh -s -- -y
else
  echo "[rust] Already installed at $HOME/.cargo"
fi

if command -v cargo >/dev/null 2>&1; then
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
fi

echo "[rust] Done. Version info: $(rustc --version) / $(cargo --version)"
