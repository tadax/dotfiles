#!/usr/bin/env bash
set -euo pipefail

if command -v apt-get >/dev/null 2>&1; then
  sudo -v
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -y

  # https://github.com/tj/n
  sudo apt-get install -y --no-install-recommends nodejs npm
  sudo npm install -g n
  sudo n latest
fi

echo "[node] Done. Current node: $(node -V) (via tj/n)"
