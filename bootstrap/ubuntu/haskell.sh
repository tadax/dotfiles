#!/usr/bin/env bash
set -euo pipefail

. /etc/os-release
[ "${ID:-}" = "ubuntu" ] || { echo "This script is for Ubuntu."; exit 1; }

if [ ! -d "$HOME/.ghcup" ]; then
  echo "[haskell] Installing GHCup and dependencies..."

  sudo apt update -y
  sudo apt install -y \
    build-essential \
    curl \
    libffi-dev \
    libffi8 \
    libgmp-dev \
    libgmp10 \
    libncurses-dev \
    pkg-config

  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org \
  | env BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_YES=1 BOOTSTRAP_HASKELL_NO_UPGRADE=1 sh -s -- -y

  if ! grep -q 'ghcup/env' "$HOME/.bashrc"; then
    {
      echo ''
      echo '# ghcup'
      echo '[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"'
    } >> "$HOME/.bashrc"
  fi

  echo "[haskell] Install complete. Please restart your shell."
else
  echo "[haskell] GHCup already installed."
fi
