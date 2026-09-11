#!/usr/bin/env bash
set -euo pipefail

echo "Showing all file extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Preventing .DS_Store creation on network and removable volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "Restarting Finder to apply settings"
killall Finder
