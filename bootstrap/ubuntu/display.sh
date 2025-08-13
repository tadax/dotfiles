#!/usr/bin/env bash
set -euo pipefail

if command -v apt-get >/dev/null 2>&1; then
  sudo -v
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -y

  # Adjusts the brightness of the Apple Studio Display
  # cf. https://www.geeksforgeeks.org/how-to-control-screen-brightness-in-ubuntu-22-04/
  sudo apt-get install -y brightness-controller
fi

echo "[display] Done."
