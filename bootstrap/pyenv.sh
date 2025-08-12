#!/usr/bin/env bash
set -euo pipefail

PYTHON_VERSION="${PYTHON_VERSION:-3.11.5}"

if command -v apt-get >/dev/null 2>&1; then
  sudo -v
  export DEBIAN_FRONTEND=noninteractive
  sudo apt-get update -y
  # cf. https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  sudo apt-get install -y --no-install-recommends \
    make \
    build-essential \
    curl \
    git \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    liblzma-dev \
    tk-dev \
    uuid-dev \
    libncursesw5-dev \
    xz-utils
fi

if [ ! -d "$HOME/.pyenv/" ]; then
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
append_once "$HOME/.bashrc" 'export PYENV_ROOT="$HOME/.pyenv"'
append_once "$HOME/.bashrc" 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
append_once "$HOME/.bashrc" 'eval "$(pyenv init -)"'

if ! pyenv versions --bare | grep -Fqx "$PYTHON_VERSION"; then
  echo "[pyenv] installing Python $PYTHON_VERSION"
  pyenv install "$PYTHON_VERSION"
else
  echo "[pyenv] Python $PYTHON_VERSION already installed"
fi

if [ "$(pyenv global)" != "$PYTHON_VERSION" ]; then
  pyenv global "$PYTHON_VERSION"
fi
pyenv rehash

"$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python" -m pip install -U pip

echo "[pyenv] Done. Current python: $(python -V) (via pyenv)"
