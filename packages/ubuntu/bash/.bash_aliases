gclean() {
  set -euo pipefail

  local current_branch default_branch
  current_branch="$(git symbolic-ref --short -q HEAD || echo '')"

  # デフォルトブランチは master を優先、なければ main
  default_branch="master"
  if ! git show-ref --verify --quiet "refs/heads/$default_branch"; then
    default_branch="main"
  fi

  git fetch --prune origin
  git switch "$default_branch"
  git pull --ff-only origin "$default_branch"

  if [ -n "$current_branch" ] && [ "$current_branch" != "$default_branch" ]; then
    git branch -D "$current_branch"
  else
    echo "[INFO] No branch to delete (current=$current_branch)"
  fi
}
