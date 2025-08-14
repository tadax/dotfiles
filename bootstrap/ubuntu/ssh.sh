#!/usr/bin/env bash
set -euo pipefail

echo "[ssh] Ensuring ~/.ssh exists with correct permissions"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ -f "$HOME/.ssh/config" ]; then
  chmod 600 "$HOME/.ssh/config"
fi

echo "[ssh] Done."
