#!/usr/bin/env bash
set -euo pipefail

command -v git >/dev/null || { echo "git is required"; exit 1; }
command -v vim >/dev/null || { echo "vim is required"; exit 1; }

VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"

if [ ! -d "$VUNDLE_DIR/.git" ]; then
  echo "[vim] Cloning Vundle into $VUNDLE_DIR"
  mkdir -p "$(dirname "$VUNDLE_DIR")"
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
else
  echo "[vim] Vundle already exists; pulling latest"
  git -C "$VUNDLE_DIR" pull --ff-only
fi

echo "[vim] Installing plugins via :PluginInstall"
vim -E -s +PluginInstall +qall

echo "[vim] Done."
