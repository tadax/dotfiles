alias gclean='git fetch origin && git checkout master && git pull && git branch -D $(git rev-parse --abbrev-ref HEAD)'
