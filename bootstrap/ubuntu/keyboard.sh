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

echo "[keyboard] Done."
