---
name: context-handoff
description: Document current work state for seamless handoff between team members' Claude sessions. Captures progress, decisions, blockers, and next steps.
---

# Context Handoff

## Overview

When a developer stops working on a branch, critical context lives only in their Claude session — and it dies when the session ends. This skill captures that context into a structured handoff note so the next developer (or the same developer in a new session) can pick up exactly where things left off.

## Creating a Handoff

Execute these steps in order without confirmation prompts.

### Step 1: Gather Context

1. Run `git log --oneline -20` to understand recent commit history on this branch
2. Run `git status` and `git diff --stat` to identify uncommitted work
3. Run `git branch --show-current` to identify the current branch
4. Read CLAUDE.md if it exists, to understand project conventions

### Step 2: Analyze Session State

Review the current session transcript to extract:

1. **What was accomplished** — completed features, fixes, refactors
2. **What's in progress** — partially implemented work, uncommitted changes
3. **Decisions made** — technical choices and their reasoning
4. **Blockers encountered** — errors, unknowns, dependencies on others
5. **Next steps** — what should happen next, in priority order

### Step 3: Check for Open Threads

1. Run `git stash list` to check for stashed work
2. Check for TODO/FIXME/HACK comments added in this session: search changed files for these markers
3. Check if any tests are currently failing: run the test suite if one is detected

### Step 4: Write the Handoff Note

Create or update the handoff file at `.claude/handoffs/<branch-name>.md` using this format:

```markdown
# Handoff: <branch-name>

**Author:** <developer or "Claude session">
**Date:** <current date and time>
**Status:** <In Progress | Blocked | Ready for Review | Ready to Merge>

## Summary
<1-3 sentences: what this branch is about and current state>

## Completed
- <bullet list of what's done>

## In Progress
- <bullet list of partially done work with details on current state>

## Uncommitted Changes
- <list of modified/untracked files and what they contain>

## Decisions Made
| Decision | Reasoning | Alternatives Considered |
|----------|-----------|------------------------|
| <choice> | <why> | <what else was considered> |

## Blockers
- <blocker description, who/what can unblock it>

## Next Steps
1. <highest priority next action>
2. <second priority>
3. <etc>

## Context for Claude
<Any context that would help a future Claude session be effective — file locations,
patterns to follow, gotchas discovered, commands that work>
```

### Step 5: Stage the Handoff

1. Ensure the `.claude/handoffs/` directory exists
2. Write the handoff file
3. Run `git add .claude/handoffs/<branch-name>.md`
4. Do NOT commit automatically — the developer may want to review first

## Reading a Handoff

When starting work on a branch, check for an existing handoff:

1. Check if `.claude/handoffs/<branch-name>.md` exists
2. If it does, read it and summarize the key points to the developer
3. Ask if anything has changed since the handoff was written
4. Proceed with the next steps listed in the handoff

## Red Flags

- Writing vague handoffs ("worked on stuff") — be specific
- Omitting blockers to make progress look better
- Skipping the "Decisions Made" section — this is the most valuable part
- Not mentioning uncommitted changes — the next person will be confused

## Common Mistakes

- Forgetting to check `git stash list` for stashed work
- Not running tests to verify current state
- Writing the handoff but forgetting to `git add` it
- Overwriting a previous handoff without reading it first
