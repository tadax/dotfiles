#!/usr/bin/env bash
set -euo pipefail

if ! command -v orbctl >/dev/null 2>&1; then
  echo "[orbstack] Not installed; skipping"
  exit 0
fi

ORBSTACK_CLI_DIR="/Applications/OrbStack.app/Contents/MacOS/xbin"
ORBSTACK_USER_BIN="$HOME/.orbstack/bin"

if [ ! -d "$ORBSTACK_CLI_DIR" ]; then
  echo "[orbstack] CLI tools not found at $ORBSTACK_CLI_DIR" >&2
  exit 1
fi

if [ ! -e "$ORBSTACK_USER_BIN" ]; then
  echo "[orbstack] Linking CLI tools"
  mkdir -p "$(dirname "$ORBSTACK_USER_BIN")"
  ln -s "$ORBSTACK_CLI_DIR" "$ORBSTACK_USER_BIN"
fi

export PATH="$ORBSTACK_USER_BIN:$PATH"

DOCKER_PLUGIN_DIR="$HOME/.docker/cli-plugins"
mkdir -p "$DOCKER_PLUGIN_DIR"

link_docker_plugin() {
  local name="$1"
  local source="$ORBSTACK_USER_BIN/$name"
  local target="$DOCKER_PLUGIN_DIR/$name"

  if [ -e "$target" ] || [ -L "$target" ]; then
    return
  fi

  echo "[orbstack] Linking Docker CLI plugin: $name"
  ln -s "$source" "$target"
}

link_docker_plugin docker-compose
link_docker_plugin docker-buildx

if [ "$(orbctl status 2>/dev/null || true)" != "Running" ]; then
  echo "[orbstack] Starting"
  if ! orbctl start; then
    echo "[orbstack] Start command did not complete; waiting for the first startup"

    running=0
    for attempt in {1..15}; do
      if [ "$(orbctl status 2>/dev/null || true)" = "Running" ]; then
        running=1
        break
      fi

      echo "[orbstack] Waiting for VM ($attempt/15)"
      sleep 2
    done

    if [ "$running" -ne 1 ]; then
      echo "[orbstack] Failed to start within the expected time" >&2
      exit 1
    fi
  fi
else
  echo "[orbstack] Already running"
fi

if [ "$(orbctl config get app.start_at_login)" != "true" ]; then
  echo "[orbstack] Enabling start at login"
  orbctl config set app.start_at_login true
else
  echo "[orbstack] Start at login is already enabled"
fi

echo "[orbstack] Done."
