#!/usr/bin/env bash
# SessionStart hook: warn if on main/master branch
set -euo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "WARNING: You are on the '${BRANCH}' branch. Team governance requires working on a feature branch or worktree. Create one before writing code. Run /teampush to check all gates."
  }
}
EOF
else
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Branch '${BRANCH}' — OK for development. Remember to run /teampush before pushing."
  }
}
EOF
fi

exit 0
