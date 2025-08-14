#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "$HOME/.ghcup" ]; then
  echo "[haskell] Installing GHC..."
  brew install ghc cabal-install
  echo "[haskell] Install complete. Please restart your shell."
else
  echo "[haskell] GHC already installed."
fi
