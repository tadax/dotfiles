#!/usr/bin/env bash
set -euo pipefail

NVIDIA_DRIVER_VERSION="${NVIDIA_DRIVER_VERSION:-535}"

export DEBIAN_FRONTEND=noninteractive

. /etc/os-release
[ "${ID:-}" = "ubuntu" ] || { echo "This script is for Ubuntu."; exit 1; }

# Prompt for the sudo password upfront to avoid interruptions later in the script.
sudo -v

# cf. https://www.liberiangeek.net/2024/04/install-cuda-on-ubuntu-24-04/
echo "[cuda] Installing NVIDIA driver and CUDA toolkit..."

sudo apt update -y

echo "[cuda] Installing pinned NVIDIA driver ${NVIDIA_DRIVER_VERSION}..."
sudo apt-get install -y "nvidia-driver-${NVIDIA_DRIVER_VERSION}"

echo "[cuda] Installing CUDA toolkit from Ubuntu repository (nvidia-cuda-toolkit)..."
sudo apt install -y nvidia-cuda-toolkit

echo "[cuda] Install complete. Please reboot your system for changes to take effect."
