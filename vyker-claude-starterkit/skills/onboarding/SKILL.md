---
name: onboarding
description: Generate a personalized project orientation for new team members by analyzing the codebase, conventions, recent history, and team decisions.
---

# Onboarding

## Overview

A new developer joins the team and spends days reading code, asking questions, and stepping on landmines. This skill generates a comprehensive project orientation by analyzing the actual codebase — not just what's documented, but what the code reveals about patterns, conventions, and gotchas.

## Generating an Onboarding Guide

Execute these steps in order without confirmation prompts.

### Step 1: Project Identity

1. Read the project's `README.md` for the stated purpose and setup instructions
2. Read `CLAUDE.md` for team conventions and rules
3. Read `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, or equivalent for:
   - Project name and description
   - Language and framework versions
   - Key dependencies
   - Available scripts/commands

### Step 2: Architecture Overview

1. List top-level directories and identify the project structure pattern:
   - Monorepo? Multi-package? Standard framework layout?
2. Identify the entry points (main files, index files, app routers)
3. Map the major modules/domains and how they connect
4. Check for infrastructure files: Docker, CI/CD configs, deployment manifests

### Step 3: Conventions & Patterns

1. Extract conventions from CLAUDE.md
2. Scan the codebase for recurring patterns:
   - How are API endpoints structured?
   - How is state managed?
   - How are errors handled?
   - What testing patterns are used (unit, integration, e2e)?
   - What's the import/module resolution style?
3. Check for linting/formatting configs (`.eslintrc`, `.prettierrc`, `ruff.toml`, etc.)
4. Check for git hooks (`.husky/`, `.git/hooks/`)

### Step 4: Team Decisions

1. Check for `docs/decisions/` and read any ADRs
2. Check for `.claude/handoffs/` and read recent handoffs
3. Read recent PR descriptions if `gh` is available: `gh pr list --state merged --limit 10 --json title,body`

### Step 5: Recent Activity

1. Run `git log --oneline -30` to understand recent development focus
2. Run `git shortlog -sn --since="30 days ago"` to see who's active
3. Check for open PRs: `gh pr list --state open --json number,title,headRefName,author`
4. Identify areas under active development vs stable areas

### Step 6: Gotchas & Landmines

1. Search for TODO, FIXME, HACK, WORKAROUND, XXX comments in the codebase
2. Check for known issues: `gh issue list --state open --limit 10` if available
3. Look for `.env.example` or environment setup requirements
4. Check if there are database migrations that need to run
5. Look for common pitfalls: hardcoded paths, platform-specific code, version pinning

### Step 7: Generate the Guide

Output the onboarding guide:

```markdown
# Project Onboarding: <project-name>

## What Is This?
<2-3 sentences: what the project does, who it's for>

## Quick Start
1. <clone and install step>
2. <environment setup step>
3. <run the project step>
4. <run tests step>

## Architecture

<ASCII diagram or description of the major components and how they connect>

### Key Directories
| Directory | Purpose |
|-----------|---------|
| `src/api/` | REST API endpoints |
| `src/components/` | React components |
| `src/db/` | Database models and migrations |

### Entry Points
- **App start:** `src/index.ts`
- **API routes:** `src/api/router.ts`
- **Frontend:** `src/App.tsx`

## Conventions

### Code Style
- <convention 1>
- <convention 2>

### Git Workflow
- <branching strategy>
- <commit message format>
- <PR process>

### Testing
- <how to run tests>
- <testing patterns used>
- <what needs tests>

## Architecture Decisions
| # | Decision | Summary |
|---|----------|---------|
| 001 | <title> | <one-line summary> |

## Key Dependencies
| Package | Purpose | Why this one? |
|---------|---------|---------------|
| <dep> | <what it does> | <why it was chosen over alternatives> |

## Active Work
| Branch/PR | What | Who |
|-----------|------|-----|
| feat/oauth | OAuth integration | sarah |
| fix/perf | Query optimization | mike |

## Gotchas
- <gotcha 1: thing that will trip you up>
- <gotcha 2: non-obvious requirement>
- <gotcha 3: environment-specific issue>

## Useful Commands
| Command | What it does |
|---------|-------------|
| `npm test` | Run test suite |
| `npm run dev` | Start dev server |

## Where to Start
<Suggestion for a good first task or area to explore based on current open issues>
```

### Step 8: Save the Guide

1. Write the guide to `.claude/onboarding.md`
2. Tell the developer they can re-run `/onboard` anytime as the project evolves

## Red Flags

- Onboarding guides that are outdated (check dates and verify against current code)
- Skipping the "Gotchas" section — this is what saves the most time
- Not mentioning environment setup requirements — the #1 new dev blocker

## Common Mistakes

- Generating the guide without reading CLAUDE.md first — misses team conventions
- Not checking for ADRs — the new dev will unknowingly re-debate settled decisions
- Writing a generic guide instead of analyzing the actual codebase
- Forgetting to check for required environment variables or secrets
