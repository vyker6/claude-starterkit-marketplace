#!/usr/bin/env bash
# SessionStart hook: warn if branch name doesn't follow team convention
set -euo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# main/master are handled by check-branch.sh, skip here
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ] || [ "$BRANCH" = "unknown" ]; then
  exit 0
fi

# Check for conventional branch naming: type/description
if echo "$BRANCH" | grep -qP '^(feat|fix|docs|refactor|test|chore|hotfix|release)/[a-z0-9][a-z0-9._-]*$'; then
  exit 0
fi

# Branch name doesn't match convention
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "WARNING: Branch '${BRANCH}' doesn't follow naming convention. Use: feat/, fix/, docs/, refactor/, test/, chore/, hotfix/, or release/ prefix with a lowercase kebab-case description (e.g., feat/user-auth)."
  }
}
EOF
exit 0
