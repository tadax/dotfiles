#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

SRC_FILE="$ROOT/bootstrap/ubuntu/files/etc-default-keyboard"
DEST_FILE="/etc/default/keyboard"

if [ ! -f "$SRC_FILE" ]; then
  echo "[keyboard] Source file not found: $SRC_FILE" >&2
  exit 1
fi

echo "[keyboard] Copying $SRC_FILE to $DEST_FILE"
sudo cp "$SRC_FILE" "$DEST_FILE"

if command -v gsettings >/dev/null 2>&1; then
  echo "[keyboard] Loading GNOME keybindings..."

  CONF_DIR="$ROOT/bootstrap/ubuntu/files/gnome"
  [ -f "$CONF_DIR/gnome-wm-keybindings.dconf" ] && \
    dconf load /org/gnome/desktop/wm/keybindings/ < "$CONF_DIR/gnome-wm-keybindings.dconf"

  [ -f "$CONF_DIR/gnome-mutter-keybindings.dconf" ] && \
    dconf load /org/gnome/mutter/keybindings/ < "$CONF_DIR/gnome-mutter-keybindings.dconf"

  [ -f "$CONF_DIR/gnome-shell-keybindings.dconf" ] && \
    dconf load /org/gnome/shell/keybindings/ < "$CONF_DIR/gnome-shell-keybindings.dconf"

  [ -f "$CONF_DIR/gnome-media-keys.dconf" ] && \
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$CONF_DIR/gnome-media-keys.dconf"
fi

echo "[keyboard] Done."
