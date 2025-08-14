#!/usr/bin/env bash
set -euo pipefail

BASHRC="$HOME/.bashrc"
BASHRC_D="$HOME/.bashrc.d"

mkdir -p "$BASHRC_D"
touch "$BASHRC"

if ! grep -Fq '>>> dotfiles bashrc.d loader >>>' "$BASHRC"; then
  cat >> "$BASHRC" <<'EOF'

# >>> dotfiles bashrc.d loader >>>
# Load extra bashrc snippets
if [ -d "$HOME/.bashrc.d" ]; then
  for f in "$HOME"/.bashrc.d/*.sh; do
    [ -r "$f" ] && . "$f"
  done
fi
# <<< dotfiles bashrc.d loader <<<
EOF
  echo "[bash] Installed .bashrc.d loader into $BASHRC"
else
  echo "[bash] .bashrc.d loader already present"
fi
