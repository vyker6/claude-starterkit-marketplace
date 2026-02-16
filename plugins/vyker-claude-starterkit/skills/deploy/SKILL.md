---
name: deploy
description: Fully automated deployment pipeline. Use when the user wants to deploy, ship, or push their work. Runs tests, debugs failures, audits frontend design, creates a PR, and triggers builds.
---

# Deploy Pipeline

## Overview

Fully automated deployment pipeline that runs sequentially without confirmation prompts. Orchestrates multiple skills to validate, commit, push, and build.

## Pipeline Steps

Execute these steps in order. Do NOT ask for confirmation between steps — run fully automated.

### Step 1: Test Suite

1. Detect the project's test framework by examining config files:
   - `package.json` → look for `jest`, `vitest`, `mocha`, `cypress` in devDependencies
   - `pytest.ini` / `pyproject.toml` → pytest
   - `pubspec.yaml` → flutter test
   - `build.gradle` → gradle test
   - If no test framework found, skip to Step 2

2. Run the full test suite using the detected framework

3. If any tests fail:
   - Invoke the `vyker-claude-starterkit:systematic-debugging` skill
   - Find and fix the root cause
   - Re-run tests
   - Loop until all tests pass (max 3 attempts)
   - If still failing after 3 attempts, report the failures and stop the pipeline

### Step 2: Frontend Design Audit

1. Check if any frontend files were modified (look at `git diff --name-only` for `.tsx`, `.jsx`, `.vue`, `.svelte`, `.html`, `.css`, `.scss` files)

2. If frontend files changed:
   - Invoke the `vyker-claude-starterkit:frontend-design` skill
   - Validate components against the project's design system (look for design tokens, theme files, style guides in the repo)
   - Fix any inconsistencies automatically

3. If no frontend files changed, skip this step

### Step 3: Diff Review & Commit

1. Run `git status` and `git diff` to identify all changes since last commit
2. Review the diffs for completeness — ensure no debug code, no console.logs left behind, no commented-out code
3. Clean up any issues found
4. Stage all relevant changes: `git add` (specific files, not -A)
5. Create a descriptive commit message summarizing the changes
6. Commit

### Step 4: PR & Push

1. Check if a remote branch exists for the current branch
2. If not, push with `-u` to set upstream: `git push -u origin <branch>`
3. If yes, push: `git push`
4. Create a PR using `gh pr create` with:
   - A concise title (under 70 characters)
   - A body with summary bullets and test plan
5. Report the PR URL

### Step 5: Build

1. Detect the project's tech stack by examining config files:
   - `package.json` → check for build script, framework (next, react, vue, expo, react-native)
   - `pubspec.yaml` → Flutter
   - `Podfile` / `*.xcodeproj` → iOS (xcodebuild)
   - `build.gradle` / `settings.gradle` → Android (gradle)
   - `capacitor.config.*` → Capacitor
   - `next.config.*` → Next.js

2. Determine which platforms need builds based on what files changed:
   - Changes to `ios/` → iOS build needed
   - Changes to `android/` → Android build needed
   - Changes to `web/`, `src/`, `pages/`, `app/` → Web build needed
   - If unsure, build all detected platforms

3. Run the appropriate build commands:
   - **Web:** `npm run build` / `yarn build` / `pnpm build`
   - **iOS:** `cd ios && xcodebuild -workspace *.xcworkspace -scheme <scheme> -sdk iphonesimulator build`
   - **Android:** `cd android && ./gradlew assembleRelease`
   - **Flutter:** `flutter build apk && flutter build ios --no-codesign && flutter build web`
   - **Expo:** `npx expo export`
   - **Next.js:** `next build`

4. Report build results (success/failure for each platform)

## Error Handling

- If any step fails critically (tests won't pass after 3 debug attempts, build fails), stop the pipeline and report what happened
- Do NOT silently skip failures
- Always provide a summary at the end of what was done

## Summary Output

At the end, output a deployment summary:

```
## Deploy Summary
- Tests: PASS (X tests)
- Design Audit: PASS / SKIPPED (no frontend changes)
- Commit: <sha> - "<message>"
- PR: <url>
- Build: Web ✓ | iOS ✓ | Android ✓
```
