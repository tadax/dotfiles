#!/usr/bin/env bash
set -euo pipefail

PRIVATE_DIR="${DOTFILES_PRIVATE_DIR:-$HOME/.dotfiles-private}"
PRIVATE_URL="${DOTFILES_PRIVATE_URL:-}"
PRIVATE_BRANCH="${DOTFILES_PRIVATE_BRANCH:-master}"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

need() { command -v "$1" >/dev/null 2>&1 || { echo "need '$1'"; exit 1; }; }
need git
need stow

clone_or_update_private() {
  # No URL? -> only try to use local existing repo
  if [ -n "$PRIVATE_URL" ]; then
    if [ -d "$PRIVATE_DIR/.git" ]; then
      echo "[private] updating: $PRIVATE_DIR"
      git -C "$PRIVATE_DIR" fetch --prune
      git -C "$PRIVATE_DIR" checkout "$PRIVATE_BRANCH" || true
      git -C "$PRIVATE_DIR" pull --ff-only --no-rebase || true
    else
      echo "[private] cloning → $PRIVATE_DIR"
      git clone --branch "$PRIVATE_BRANCH" --depth 1 "$PRIVATE_URL" "$PRIVATE_DIR"
    fi
  else
    echo "[private] DOTFILES_PRIVATE_URL not set; will use existing dir if present."
  fi
}

stow_dir() {
  local base="$1"
  [ -d "$base/packages" ] || { echo "[private] no packages dir in $base; skipping."; return 0; }
  for pkg in "$base/packages"/*; do
    [ -d "$pkg" ] || continue
    echo "[private] stow $(basename "$pkg")"
    stow -d "$base/packages" -t "$HOME" "$(basename "$pkg")"
  done
}

echo "[private] start (root: $ROOT)"
clone_or_update_private

if [ -d "$PRIVATE_DIR/packages" ]; then
  stow_dir "$PRIVATE_DIR"
  echo "[private] done."
else
  echo "[private] $PRIVATE_DIR/packages not found; nothing to link."
fi
