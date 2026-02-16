#!/usr/bin/env bash
# SessionStart hook: warn if branch hasn't been rebased on main recently
set -euo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# Skip main/master/unknown
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ] || [ "$BRANCH" = "unknown" ]; then
  exit 0
fi

# Find the merge base with main and check its age
MERGE_BASE=$(git merge-base HEAD main 2>/dev/null || echo "")
if [ -z "$MERGE_BASE" ]; then
  exit 0
fi

MERGE_BASE_DATE=$(git log -1 --format=%ct "$MERGE_BASE" 2>/dev/null || echo "0")
NOW=$(date +%s)
DAYS_OLD=$(( (NOW - MERGE_BASE_DATE) / 86400 ))

if [ "$DAYS_OLD" -ge 3 ]; then
  COMMITS_BEHIND=$(git rev-list --count HEAD..main 2>/dev/null || echo "unknown")
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "WARNING: Branch '${BRANCH}' last synced with main ${DAYS_OLD} days ago (${COMMITS_BEHIND} commits behind). Consider rebasing: git rebase main"
  }
}
EOF
  exit 0
fi

exit 0
