#!/usr/bin/env bash
set -euo pipefail

echo "Showing all file extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
