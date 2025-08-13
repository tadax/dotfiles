#!/usr/bin/env bash
set -euo pipefail

if [ -z "${BASH_VERSION:-}" ]; then
  echo "This script must be run with bash, e.g.: bash $0" >&2
  exit 1
fi

PYTHON_VERSION="${PYTHON_VERSION:-3.11.5}"

if command -v brew >/dev/null 2>&1; then
  echo "[pyenv] Homebrew not found. Please run bootstrap/macos/brew.sh first."
  exit 1
fi

brew update
brew install \
  openssl \
  readline \
  sqlite3 \
  xz \
  zlib \
  tcl-tk \
  git

if [ -d "$HOME/.pyenv/.git" ]; then
  echo "[pyenv] found, updating..."
  git -C "$HOME/.pyenv" pull --ff-only
else
  echo "[pyenv] cloning to ~/.pyenv"
  git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

append_once() {
  local file="$1" line="$2"
  mkdir -p "$(dirname -- "$file")"
  [ -f "$file" ] || : > "$file"
  grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}
append_once "$HOME/.bash_profile" 'export PYENV_ROOT="$HOME/.pyenv"'
append_once "$HOME/.bash_profile" 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
append_once "$HOME/.bash_profile" 'eval "$(pyenv init -)"'

if ! pyenv versions --bare | grep -Fqx "$PYTHON_VERSION"; then
  echo "[pyenv] installing Python $PYTHON_VERSION"
  # Install python on Big Sur
  # cf. https://github.com/pyenv/pyenv/issues/1219#issuecomment-727951276
  LDFLAGS="-L$(xcrun --show-sdk-path)/usr/lib" pyenv install "$PYTHON_VERSION"
else
  echo "[pyenv] Python $PYTHON_VERSION already installed"
fi

if [ "$(pyenv global)" != "$PYTHON_VERSION" ]; then
  pyenv global "$PYTHON_VERSION"
fi
pyenv rehash

"$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python" -m pip install -U pip

echo "[pyenv] Done. Current python: $(python -V) (via pyenv)"
