#!/usr/bin/env bash
# PreToolUse hook: warn before pushing if the diff is very large
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only check git push commands
if ! echo "$COMMAND" | grep -qE '^\s*git\s+push\b'; then
  exit 0
fi

# Count lines changed vs main
LINES_CHANGED=$(git diff --stat main...HEAD 2>/dev/null | tail -1 | grep -oP '\d+(?= insertion)' || echo "0")
LINES_DELETED=$(git diff --stat main...HEAD 2>/dev/null | tail -1 | grep -oP '\d+(?= deletion)' || echo "0")
TOTAL=$(( ${LINES_CHANGED:-0} + ${LINES_DELETED:-0} ))

if [ "$TOTAL" -gt 500 ]; then
  FILES_CHANGED=$(git diff --name-only main...HEAD 2>/dev/null | wc -l || echo "0")
  cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "Large diff detected: ${TOTAL} lines changed across ${FILES_CHANGED} files. Consider splitting this into smaller PRs for easier review. Proceed with push?"
  }
}
EOF
  exit 0
fi

exit 0
