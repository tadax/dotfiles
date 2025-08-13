#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$ROOT/packages"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if [ -f /etc/os-release ] && grep -qi ubuntu /etc/os-release; then
        echo "ubuntu"
      else
        echo "unknown"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

OS_NAME="$(detect_os)"
if [ "$OS_NAME" = "unknown" ]; then
  echo "Unsupported OS" >&2
  exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "[ERROR] GNU stow is not installed." >&2
  echo "        macOS: brew install stow / Ubuntu: sudo apt-get install stow" >&2
  exit 1
fi

mkdir -p "$HOME/.config"

ORDER=("common" "$OS_NAME")
for name in "${ORDER[@]}"; do
  pkg="$PKG_ROOT/$name"
  [ -d "$pkg" ] || { echo "[INFO] Skip (not found): $name"; continue; }

  echo "[INFO] Linking package:  $name -> $TARGET_DIR"
  stow -d "$PKG_ROOT" -t "$TARGET_DIR" "$name"
done

echo "[packages] Done."
