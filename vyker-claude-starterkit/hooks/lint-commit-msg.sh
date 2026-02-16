#!/usr/bin/env bash
# PreToolUse hook: enforce conventional commit message format
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only check git commit commands
if ! echo "$COMMAND" | grep -qE '^\s*git\s+commit\b'; then
  exit 0
fi

# Extract the commit message from -m flag
# Handles: git commit -m "message", git commit -m 'message', git commit -m "$(cat <<'EOF'...)"
MSG=$(echo "$COMMAND" | grep -oP '(?<=-m\s)(["'"'"'])(.+?)\1' | sed "s/^[\"']//;s/[\"']$//" 2>/dev/null || echo "")

# Also handle heredoc style: -m "$(cat <<'EOF'
if [ -z "$MSG" ] && echo "$COMMAND" | grep -q 'cat <<'; then
  MSG=$(echo "$COMMAND" | grep -oP '(?<=EOF\n).*(?=\nEOF)' 2>/dev/null || echo "")
  # If heredoc extraction fails, try to get first line after EOF
  if [ -z "$MSG" ]; then
    MSG=$(echo "$COMMAND" | sed -n '/<<.*EOF/,/EOF/p' | head -3 | tail -1 | sed 's/^[[:space:]]*//' 2>/dev/null || echo "")
  fi
fi

# If we couldn't extract the message, allow it (don't block on parse failures)
if [ -z "$MSG" ]; then
  exit 0
fi

# Check for conventional commit format: type(optional-scope): description
# Allowed types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert
if echo "$MSG" | grep -qP '^\s*(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?:\s+.+'; then
  exit 0
fi

# Message doesn't match conventional commits format
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "Commit message must follow Conventional Commits format: type(scope): description. Allowed types: feat, fix, docs, style, refactor, perf, test, chore, ci, build, revert. Example: feat(auth): add login endpoint"
  }
}
EOF
exit 0
