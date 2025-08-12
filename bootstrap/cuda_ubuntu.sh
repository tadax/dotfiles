#!/usr/bin/env bash
set -euo pipefail

. /etc/os-release
[ "${ID:-}" = "ubuntu" ] || { echo "This script is for Ubuntu."; exit 1; }

echo "[cuda] Installing NVIDIA driver and CUDA toolkit..."

# cf. https://www.liberiangeek.net/2024/04/install-cuda-on-ubuntu-24-04/
sudo apt update -y
sudo apt install -y nvidia-driver-535
sudo apt upgrade -y
sudo apt install -y nvidia-cuda-toolkit

echo "[cuda] Install complete. Please reboot your system for changes to take effect."
