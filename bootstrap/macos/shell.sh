#!/usr/bin/env bash
set -euo pipefail

# use bash instead of zsh
if [[ "$SHELL" == "/bin/zsh" ]]; then
  echo "Changing default shell to /bin/bash"
  chsh -s /bin/bash
else
  echo "Default shell already bash"
fi
