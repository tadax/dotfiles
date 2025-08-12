#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME"

mkdir -p "$HOME/.config"

for pkg in "$DOTFILES_DIR/packages"/*; do
  [ -d "$pkg" ] || continue
  name="$(basename "$pkg")"

  echo "[INFO] Linking package: $name -> $TARGET_DIR"
  stow -d "$DOTFILES_DIR/packages" -t "$TARGET_DIR" "$name"
done

echo "Done."
