#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG_DIR="$ROOT/packages"
TARGET_DIR="$HOME"

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
for group in "${ORDER[@]}"; do
  group_dir="$PKG_DIR/$group"
  shopt -s nullglob dotglob
  subpkgs=("$group_dir"/*/)
  for sub in "${subpkgs[@]}"; do
    pkg_name="$(basename "$sub")"
    echo "[INFO] Linking package: $group/$pkg_name -> $TARGET_DIR"
    stow -d "$group_dir" -t "$TARGET_DIR" "$pkg_name"
  done
done
