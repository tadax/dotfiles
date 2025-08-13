#!/usr/bin/env bash
set -euo pipefail

command -v apt-get >/dev/null || { echo "This script is for Debian/Ubuntu (apt)."; exit 1; }

# Prompt for the sudo password upfront to avoid interruptions later in the script.
sudo -v

export DEBIAN_FRONTEND=noninteractive

DO_UPGRADE=false
for arg in "$@"; do
  case "$arg" in
    --upgrade)
      DO_UPGRADE=true
      ;;
    -h|--help)
      echo "Usage: $0 [--upgrade]"
      echo "  --upgrade   Run 'apt upgrade -y' after apt update"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
  esac
done

pkgs=(
  stow
  vim
  git
  tree
  curl
  wget
  pwgen
  net-tools
  tmux
  unzip
  ffmpeg
  xsel
  build-essential
  ca-certificates
  ibus-mozc  # 日本語入力
)

sudo apt-get update -y

if [ "$DO_UPGRADE" = true ]; then
  sudo apt-get upgrade -y
fi

sudo apt-get install -y --no-install-recommends "${pkgs[@]}"

echo "[apt] Done."
