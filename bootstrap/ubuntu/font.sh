#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC_FILE="$ROOT/bootstrap/files/fonts/Hermit-Regular.otf"
DEST_FILE="/usr/local/share/fonts/Hermit-Regular.otf"

if [ ! -f "$SRC_FILE" ]; then
  echo "[font] Source file not found: $SRC_FILE" >&2
  exit 1
fi

echo "[font] Copying $SRC_FILE to $DEST_FILE"
sudo cp "$SRC_FILE" "$DEST_FILE"

echo "[font] Done."
