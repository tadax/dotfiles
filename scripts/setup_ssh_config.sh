#!/usr/bin/env bash
set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"

append_once() {
  local file="$1" line="$2"
  [ -f "$file" ] || return 0
  grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

append_once "$SSH_CONFIG" "ForwardAgent yes"
append_once "$SSH_CONFIG" "AddKeysToAgent yes"
append_once "$SSH_CONFIG" "ServerAliveInterval 60"
append_once "$SSH_CONFIG" "ServerAliveCountMax 120"

echo "[ssh] ~/.ssh/config updated."
