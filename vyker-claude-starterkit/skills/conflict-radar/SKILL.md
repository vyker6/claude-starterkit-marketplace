---
name: conflict-radar
description: Scan open branches and PRs for file overlap with your current work. Warns about potential merge conflicts before they happen.
---

# Conflict Radar

## Overview

Merge conflicts waste hours. This skill detects them before they happen by scanning all open branches and pull requests for files that overlap with what you're working on. Run it before starting work, or anytime during development, to know if you need to coordinate with a teammate.

## Scanning for Conflicts

Execute these steps in order without confirmation prompts.

### Step 1: Identify Your Files

1. Run `git branch --show-current` to get the current branch
2. Run `git diff --name-only main...HEAD` to get all files changed on this branch vs main
3. Run `git diff --name-only` and `git diff --name-only --cached` to include uncommitted changes
4. Combine into a deduplicated list of "your files"

### Step 2: Gather Open Branches

1. Run `git fetch --all --prune` to ensure branch info is current
2. Run `git branch -r --no-merged main` to list all unmerged remote branches
3. Also run `git worktree list` to check for local worktrees

### Step 3: Check for Open PRs

1. If `gh` CLI is available and authenticated, run `gh pr list --state open --json number,title,headRefName,files` to get open PRs with changed files
2. If `gh` is not available, fall back to branch-level diff comparison only

### Step 4: Detect Overlaps

For each open branch/PR (excluding the current branch):

1. Get its changed files: `git diff --name-only main...<branch>`
2. Compare against "your files" from Step 1
3. Record any overlapping files with the branch/PR they belong to

### Step 5: Report

Output a conflict radar report:

```
## Conflict Radar Report

**Your branch:** feat/user-auth
**Files you've touched:** 12

### Overlaps Found

| Your File | Conflicting Branch | PR | Owner |
|-----------|-------------------|-----|-------|
| src/auth/login.ts | feat/oauth-flow | #45 | sarah |
| src/middleware/session.ts | feat/oauth-flow | #45 | sarah |
| src/components/Header.tsx | fix/nav-styling | #48 | mike |

### Risk Assessment
- **HIGH RISK:** src/auth/login.ts — heavy modifications on both branches, likely merge conflict
- **LOW RISK:** src/components/Header.tsx — minor styling changes, likely auto-mergeable

### Recommended Actions
1. Coordinate with sarah on auth file changes before continuing
2. Consider rebasing on main to pick up any recently merged changes
```

If no overlaps are found:

```
## Conflict Radar Report

**Your branch:** feat/user-auth
**Files you've touched:** 12
**Overlaps found:** 0

All clear — no file overlaps detected with open branches or PRs.
```

### Step 6: Risk Classification

Classify each overlap:

- **HIGH RISK**: Both branches have significant changes to the same file (>10 lines each), or changes are in the same functions/sections
- **MEDIUM RISK**: Both branches modify the file but in likely different sections
- **LOW RISK**: One branch has minimal changes (config, imports only)

## Red Flags

- Ignoring HIGH RISK overlaps and hoping for the best
- Not running radar before starting a multi-day feature
- Forgetting to `git fetch` first — stale branch data gives false negatives

## Common Mistakes

- Running radar on main branch (it compares against main, so results are meaningless)
- Assuming "no overlaps" means "no conflicts" — semantic conflicts exist too
- Not re-running radar after rebasing, since the file list changes
