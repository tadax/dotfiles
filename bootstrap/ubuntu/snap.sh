#!/usr/bin/env bash
set -euo pipefail

# Ensure snap is available
if ! command -v snap >/dev/null 2>&1; then
  echo "[snap] snapd not found, installing..."
  sudo apt-get update -y
  sudo apt-get install -y snapd
fi

echo "[snap] Installing packages..."
sudo snap install vlc
sudo snap install aws-cli --classic
sudo snap install slack

echo "[snap] Done."
