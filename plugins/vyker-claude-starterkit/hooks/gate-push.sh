#!/usr/bin/env bash
# PreToolUse hook: block git push and gh pr create unless /teampush has passed
# Reads the Bash command from stdin and checks if it's a push/PR command
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Check if the command is a git push or gh pr create
IS_PUSH=false
if echo "$COMMAND" | grep -qE '^\s*git\s+push\b'; then
  IS_PUSH=true
fi
if echo "$COMMAND" | grep -qE '^\s*gh\s+pr\s+create\b'; then
  IS_PUSH=true
fi

if [ "$IS_PUSH" = "true" ]; then
  # Check for governance marker file
  MARKER="/tmp/.govern-passed-$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
  if [ -f "$MARKER" ]; then
    # Governance passed for this commit, allow push
    exit 0
  else
    # Block the push
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Team governance gate: run /teampush before pushing or creating a PR. All 7 gates must pass first."
  }
}
EOF
    exit 0
  fi
fi

# Not a push/PR command, allow it
exit 0
