---
name: team-governance
description: Meta-orchestrator that enforces CLAUDE.md rules as hard gates. Runs 7 sequential checks — compliance, worktree isolation, TDD, design system, security, verification, and regression — blocking progress until every gate passes.
---

# Team Governance Pipeline

## Overview

CLAUDE.md is law. Every rule in it is a gate. No exceptions.

This skill acts as a meta-orchestrator: it reads CLAUDE.md, extracts enforceable rules, and runs 7 sequential hard gates. Progress is blocked until every gate passes. Think of it as the development-phase equivalent of the `/deploy` pipeline.

Execute all gates in order. Do NOT ask for confirmation between gates — run fully automated. Stop immediately on any gate failure.

## Gate 1: CLAUDE.md Compliance

**Phase:** Setup

1. Invoke the `vyker-claude-starterkit:claude-md-improver` skill
2. Read the project's CLAUDE.md file(s) and extract all enforceable rules
3. Score the CLAUDE.md quality (completeness, clarity, actionability)
4. If the quality score is below 50/100:
   - Report the score and specific deficiencies
   - **FAIL** — stop the pipeline
   - Corrective action: improve CLAUDE.md using the claude-md-improver skill before re-running governance
5. If the score is 50 or above, record the extracted rules — they will be checked again in Gate 6

**Pass criteria:** CLAUDE.md exists and scores >= 50 on quality assessment.

## Gate 2: Worktree Isolation

**Phase:** Setup

1. Invoke the `vyker-claude-starterkit:using-git-worktrees` skill for guidance
2. Check the current branch name:
   - If on `main` or `master` → **FAIL** — stop the pipeline
   - Corrective action: create a feature branch or worktree before re-running governance
3. Check if the current working directory is inside a git worktree (run `git rev-parse --show-toplevel` and `git worktree list`)
4. Check for duplicate branches — ensure no other worktree is checked out on the same branch
5. If on a feature branch but NOT in a worktree, issue a **WARNING** (do not fail) and continue

**Pass criteria:** Not on main/master. No duplicate branch checkouts.

## Gate 3: TDD Enforcement

**Phase:** Development

1. Invoke the `vyker-claude-starterkit:test-driven-development` skill for guidance
2. Run `git diff --name-only` (staged and unstaged) to identify all changed implementation files
3. For each changed implementation file, verify a corresponding test file exists:
   - `src/foo.ts` → expect `src/foo.test.ts`, `src/foo.spec.ts`, `test/foo.test.ts`, or similar
   - `lib/bar.py` → expect `tests/test_bar.py`, `test_bar.py`, or similar
   - Skip non-implementation files (configs, docs, assets, type definitions)
4. If any implementation file lacks a corresponding test file:
   - List the untested files
   - **FAIL** — stop the pipeline
   - Corrective action: write tests for the listed files before re-running governance

**Pass criteria:** Every changed implementation file has a corresponding test file.

## Gate 4: Design System Compliance

**Phase:** Development

1. Run `git diff --name-only` and check for frontend file changes (`.tsx`, `.jsx`, `.vue`, `.svelte`, `.html`, `.css`, `.scss`)
2. If no frontend files changed → **SKIP** this gate (mark as SKIPPED in report)
3. If frontend files changed:
   - Invoke the `vyker-claude-starterkit:frontend-design` skill
   - Validate changed components against the design system defined in CLAUDE.md (look for design tokens, theme files, style guides)
   - Check for consistency in spacing, colors, typography, and component patterns
4. If violations are found:
   - List the violations with file paths and specifics
   - **FAIL** — stop the pipeline
   - Corrective action: fix design system violations before re-running governance

**Pass criteria:** All changed frontend files comply with the project's design system, or no frontend files were changed.

## Gate 5: Security Audit

**Phase:** Development

1. Invoke the `vyker-claude-starterkit:vibe-security` skill
2. Scan all changed files (from `git diff --name-only`) for security vulnerabilities:
   - OWASP Top 10 issues
   - Hardcoded secrets, API keys, credentials
   - SQL injection, XSS, command injection vectors
   - Insecure dependencies or configurations
3. If any vulnerabilities are found:
   - Report each vulnerability with severity, file path, line number, and description
   - **FAIL** — stop the pipeline
   - Corrective action: fix all identified vulnerabilities before re-running governance

**Pass criteria:** No security vulnerabilities found in changed files.

## Gate 6: Verification & Review

**Phase:** Completion

1. Invoke the `vyker-claude-starterkit:verification-before-completion` skill:
   - Verify all claims made during development with evidence
   - Check that stated changes actually exist in the code
   - Re-check all CLAUDE.md rules extracted in Gate 1 against the current state
2. Invoke the `vyker-claude-starterkit:requesting-code-review` skill:
   - Run a full code review on all changed files
   - Categorize issues as Critical, Important, or Suggestion
3. If any **Critical** or **Important** issues are found:
   - List all issues with severity, file path, and description
   - **FAIL** — stop the pipeline
   - Corrective action: address all Critical and Important issues before re-running governance
4. Suggestions are logged in the report but do not block the pipeline

**Pass criteria:** No Critical or Important issues from code review. All CLAUDE.md rules verified.

## Gate 7: Regression & Merge

**Phase:** Completion

1. Detect the project's test framework (same detection as the deploy pipeline):
   - `package.json` → jest, vitest, mocha, cypress
   - `pytest.ini` / `pyproject.toml` → pytest
   - `pubspec.yaml` → flutter test
   - `build.gradle` → gradle test
2. Run the full test suite
3. If any tests fail:
   - Report failing tests with names and error output
   - **FAIL** — stop the pipeline
   - Corrective action: fix failing tests before re-running governance
4. If all tests pass:
   - Invoke the `vyker-claude-starterkit:finishing-a-development-branch` skill
   - Hand off to the merge workflow (stage, commit, push, PR)

**Pass criteria:** Full test suite passes. Merge workflow initiated.

## Error Handling

- **Fail-stop**: If any gate fails, stop the pipeline immediately. Do NOT continue to subsequent gates.
- **Max retries**: Each gate may be retried up to 3 times within a single governance run. If a gate fails 3 times, the pipeline is permanently blocked until the issue is resolved manually.
- **Report on failure**: When a gate fails, always report:
  1. Which gate failed
  2. The specific evidence of failure
  3. The corrective action required
- Do NOT silently skip failures.

## Governance Report

At the end of every run (whether successful or blocked), output a governance report:

```
## Governance Report

| Gate | Phase | Status | Details |
|------|-------|--------|---------|
| 1. CLAUDE.md Compliance | Setup | PASS | Score: 82/100 |
| 2. Worktree Isolation | Setup | PASS | Branch: feat/new-feature (worktree) |
| 3. TDD Enforcement | Development | PASS | 5/5 files have tests |
| 4. Design System | Development | SKIPPED | No frontend changes |
| 5. Security Audit | Development | PASS | 0 vulnerabilities |
| 6. Verification & Review | Completion | PASS | 0 Critical, 0 Important, 2 Suggestions |
| 7. Regression & Merge | Completion | PASS | 47 tests passed, PR #123 created |

**Verdict: APPROVED**
```

When the verdict is **APPROVED**, run this command to unlock pushes:

```bash
touch /tmp/.govern-passed-$(git rev-parse --short HEAD)
```

This drops a marker file that the push gate hook checks. The marker is tied to the current commit SHA, so any new commits require re-running governance.

If any gate failed:

```
**Verdict: BLOCKED at Gate 3 — TDD Enforcement**
Corrective action: Write tests for src/utils/parser.ts and src/services/auth.ts
```

## Red Flags

- Skipping gates or running them out of order
- Ignoring CLAUDE.md rules because they seem outdated
- Treating warnings as informational and ignoring them
- Re-running governance without actually fixing the reported issues
- Committing directly to main/master to bypass Gate 2

## Common Mistakes

- Running governance before making any changes (gates 3-5 need diffs to check)
- Assuming Gate 4 will always run (it skips when no frontend files changed)
- Treating the governance report as optional — always output it
- Forgetting that Gate 6 re-checks CLAUDE.md rules from Gate 1

## Integration

- **Before development**: Run governance early to catch setup issues (Gates 1-2)
- **During development**: Run after implementing features to validate TDD, design, and security (Gates 3-5)
- **Before merge**: Run the full pipeline to get the APPROVED verdict (Gates 1-7)
- **With /deploy**: Run `/teampush` first, then `/deploy` — governance validates the work, deploy ships it
