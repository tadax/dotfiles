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

# Keep ~/.bash_profile as a local, application-writable file.
#
# The managed Bash configuration lives at ~/.config/bash/profile and is
# sourced from ~/.bash_profile. This prevents installers that append to
# ~/.bash_profile from modifying this repository through a symlink.
#
# Migration behavior:
# - Replace the legacy symlink managed by this repository with a local file.
# - Refuse to modify symlinks owned by anything else.
# - Preserve existing local content and file permissions.
# - Do nothing when the managed profile is already sourced.
ensure_bash_profile_wrapper() {
  [ "$OS_NAME" = "macos" ] || return 0

  local profile="$HOME/.bash_profile"
  local legacy_suffix="packages/macos/bash/.bash_profile"
  local link_target=""
  local profile_mode=""
  local temp_profile=""

  if [ -L "$profile" ]; then
    link_target="$(readlink "$profile")"
    case "$link_target" in
      *"$legacy_suffix")
        # Migrate only the legacy symlink previously created by this repository.
        unlink "$profile"
        ;;
      *)
        echo "[ERROR] $profile is a symlink not managed by this repository: $link_target" >&2
        return 1
        ;;
    esac
  fi

  if [ ! -e "$profile" ]; then
    printf '%s\n' \
      '# >>> dotfiles managed profile >>>' \
      'if [ -r "$HOME/.config/bash/profile" ]; then' \
      '  . "$HOME/.config/bash/profile"' \
      'fi' \
      '# <<< dotfiles managed profile <<<' \
      '' \
      '# Application/local settings may be appended below.' > "$profile"
    chmod 0644 "$profile"
    return 0
  fi

  if ! grep -Fq '. "$HOME/.config/bash/profile"' "$profile"; then
    # Prepend the managed profile without discarding existing local settings.
    profile_mode="$(stat -f '%Lp' "$profile")"
    temp_profile="$(mktemp "${profile}.tmp.XXXXXX")"
    printf '%s\n' \
      '# >>> dotfiles managed profile >>>' \
      'if [ -r "$HOME/.config/bash/profile" ]; then' \
      '  . "$HOME/.config/bash/profile"' \
      'fi' \
      '# <<< dotfiles managed profile <<<' \
      '' > "$temp_profile"
    cat "$profile" >> "$temp_profile"
    chmod "$profile_mode" "$temp_profile"
    mv "$temp_profile" "$profile"
  fi
}

if ! command -v stow >/dev/null 2>&1; then
  echo "[ERROR] GNU stow is not installed." >&2
  echo "        macOS: brew install stow / Ubuntu: sudo apt-get install stow" >&2
  exit 1
fi

ensure_bash_profile_wrapper

mkdir -p "$HOME/.config"

ORDER=("common" "$OS_NAME")
for group in "${ORDER[@]}"; do
  group_dir="$PKG_DIR/$group"
  shopt -s nullglob dotglob
  subpkgs=("$group_dir"/*/)
  for sub in "${subpkgs[@]}"; do
    pkg_name="$(basename "$sub")"
    echo "[INFO] Linking package: $group/$pkg_name -> $TARGET_DIR"

    if ! output="$(stow --simulate -d "$group_dir" -t "$TARGET_DIR" "$pkg_name" 2>&1)"; then
      echo "[WARN] Skipping package due to conflicts: $group/$pkg_name" >&2
      echo "$output" >&2
      continue
    fi

    stow -d "$group_dir" -t "$TARGET_DIR" "$pkg_name"
  done
done
