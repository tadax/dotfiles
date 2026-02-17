#!/usr/bin/env bash
set -euo pipefail

# safety checks
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  echo "[ssh-agent] ERROR: Run as a normal user (not root). 'systemd --user' won't work under sudo."
  exit 1
fi
command -v systemctl >/dev/null 2>&1 || { echo "[ssh-agent] ERROR: systemctl not found"; exit 1; }
command -v ssh-add   >/dev/null 2>&1 || { echo "[ssh-agent] ERROR: ssh-add not found (install openssh-client)"; exit 1; }

# Warn if the autostart stub (stowed) is missing. It's only a safeguard, so don't fail hard.
if [ ! -e "$HOME/.config/autostart/gnome-keyring-ssh.desktop" ]; then
  echo "[ssh-agent] WARN: ~/.config/autostart/gnome-keyring-ssh.desktop not found. Did you run stow (install.sh)?"
fi

# Ensure the custom unit exists (stowed)
UNIT_PATH="$HOME/.config/systemd/user/ssh-agent.service"
if [ ! -e "$UNIT_PATH" ]; then
  echo "[ssh-agent] ERROR: $UNIT_PATH must be a symlink (stowed)."
  exit 1
fi

# Disable GNOME Keyring's SSH agent
systemctl --user disable --now gcr-ssh-agent.socket gcr-ssh-agent.service 2>/dev/null || true

# Disable gpg-agent's SSH support
if [ -f ~/.gnupg/gpg-agent.conf ]; then
  sed -i -E 's/^[[:space:]]*enable-ssh-support[[:space:]]*$/# enable-ssh-support (disabled)/' ~/.gnupg/gpg-agent.conf || true
  command -v gpgconf >/dev/null 2>&1 && gpgconf --kill gpg-agent || true
fi

# Enable custom ssh-agent
systemctl --user daemon-reload
systemctl --user enable --now ssh-agent

# sanity output
if systemctl --user --quiet is-active ssh-agent; then
  echo "[ssh-agent] active"
else
  echo "[ssh-agent] ERROR: service failed to start"
  systemctl --user status ssh-agent --no-pager || true
  exit 1
fi

echo "[ssh-agent] ssh-agent fixed at ${XDG_RUNTIME_DIR}/ssh-agent.socket"

# quick check
if [ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]; then
  echo "[ssh-agent] socket exists."
else
  echo "[ssh-agent] WARN: socket not found yet. New shells will export it via your shell snippet."
fi
