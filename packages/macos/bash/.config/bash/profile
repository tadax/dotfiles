export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH="$HOME/.orbstack/bin:$PATH"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/bin" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

if command -v brew >/dev/null 2>&1 && brew list --formula rustup >/dev/null 2>&1; then
  export PATH="$(brew --prefix rustup)/bin:$PATH"
fi

export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
