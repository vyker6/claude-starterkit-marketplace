---
name: pr-prep
description: Prepare a comprehensive PR description with walkthrough, review guidance, and test plan for human reviewers.
---

# PR Prep

## Overview

Automated PR descriptions are usually a list of changed files. Human reviewers need more: why the change was made, where to focus attention, what to test, and what the risks are. This skill generates a review-ready PR description that respects your teammates' time.

## Preparing a PR

Execute these steps in order without confirmation prompts.

### Step 1: Analyze Changes

1. Run `git branch --show-current` to get the branch name
2. Run `git log --oneline main..HEAD` to get all commits on this branch
3. Run `git diff --stat main..HEAD` to get a file change summary
4. Run `git diff main..HEAD` to read the full diff
5. Read CLAUDE.md for project conventions and context

### Step 2: Categorize Changes

Group the changes into categories:

- **Core logic** — business logic, algorithms, data flow
- **API changes** — new/modified endpoints, request/response shapes
- **UI changes** — components, styling, layout
- **Infrastructure** — config, CI/CD, dependencies, migrations
- **Tests** — new or modified tests
- **Docs** — documentation changes

### Step 3: Identify Review Focus Areas

For each changed file, assess:

1. **Complexity** — is this a simple rename or a complex algorithm?
2. **Risk** — could this break existing functionality?
3. **Subtlety** — are there non-obvious implications?

Mark the top 3-5 files that need the most careful review.

### Step 4: Check for Handoff Context

1. Check if `.claude/handoffs/<branch-name>.md` exists
2. If it does, incorporate relevant context (decisions made, blockers resolved)

### Step 5: Generate PR Description

Output the PR description in this format:

```markdown
## Summary

<2-3 sentences explaining what this PR does and why>

## Changes

### Core Logic
- <description of change> (`path/to/file.ts`)

### UI
- <description of change> (`path/to/component.tsx`)

### Tests
- <description of change> (`path/to/test.ts`)

## Review Walkthrough

Start here and follow this order for the clearest understanding:

1. **`path/to/main-file.ts`** — <what to look for, why this file matters>
2. **`path/to/second-file.ts`** — <what to look for>
3. **`path/to/third-file.ts`** — <what to look for>

## Files to Review Carefully

| File | Risk | Why |
|------|------|-----|
| `src/auth/login.ts` | High | New auth flow, security-sensitive |
| `src/db/migrations/003.sql` | High | Schema change, irreversible |
| `src/components/Form.tsx` | Medium | Complex state management |

## Test Plan

- [ ] <specific thing to test manually>
- [ ] <specific thing to test manually>
- [ ] <edge case to verify>
- [ ] Run `<test command>` — all tests should pass

## Screenshots

<If frontend changes: note where screenshots should be added>

## Risks & Rollback

- **Risk:** <what could go wrong>
- **Rollback:** <how to revert if needed>

## Related

- Closes #<issue> (if applicable)
- ADR-<NNN>: <if a decision record is relevant>
- Depends on: #<PR> (if applicable)
```

### Step 6: Apply to PR

1. If a PR already exists for this branch, update its description using `gh pr edit <number> --body "..."`
2. If no PR exists, save the description to `.claude/pr-prep/<branch-name>.md` for use when creating the PR
3. Report what was done

## Red Flags

- PR descriptions that just list file names without explaining why
- Marking everything as "low risk" to avoid scrutiny
- Omitting the test plan — reviewers need to know what to verify
- Not mentioning breaking changes or migration steps

## Common Mistakes

- Running PR prep before all changes are committed — the diff will be incomplete
- Forgetting to check for related issues or ADRs
- Writing the walkthrough in alphabetical order instead of logical order
- Not updating the PR description after addressing review feedback
