#!/usr/bin/env bash
set -euo pipefail

command -v curl >/dev/null 2>&1 || { echo "curl is required"; exit 1; }

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &&
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update --verbose

! type stow >/dev/null 2>&1 && brew install stow
! type wget >/dev/null 2>&1 && brew install wget
! type jq >/dev/null 2>&1 && brew install jq
! type mas >/dev/null 2>&1 && brew install mas
! type ffmpeg >/dev/null 2>&1 && brew install ffmpeg
! type tree >/dev/null 2>&1 && brew install tree
! type tmux >/dev/null 2>&1 && brew install tmux
! brew list --cask orbstack >/dev/null 2>&1 && brew install --cask orbstack

echo "[brew] Done."
