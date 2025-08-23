#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
bash "$ROOT/ssh_agent.sh"
bash "$ROOT/vim.sh"
