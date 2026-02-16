# vyker-claude-starterkit Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a unified Claude Code plugin that bundles superpowers, frontend-design, VibeSec, claude-md-management, explanatory-output-style, and a custom /deploy pipeline into a single installable package.

**Architecture:** A flat plugin directory with `.claude-plugin/plugin.json` as the manifest, all skills in `skills/`, commands in `commands/`, merged hooks from superpowers + explanatory-output-style, and a custom `/deploy` command that orchestrates test, debug, design audit, PR, and build steps.

**Tech Stack:** Bash (hooks), Markdown (skills/commands), JSON (config), JavaScript (lib utilities)

---

### Task 1: Scaffold Plugin Directory Structure

**Files:**
- Create: `vyker-claude-starterkit/.claude-plugin/plugin.json`

**Step 1: Create the directory skeleton**

```bash
mkdir -p vyker-claude-starterkit/.claude-plugin
mkdir -p vyker-claude-starterkit/skills
mkdir -p vyker-claude-starterkit/commands
mkdir -p vyker-claude-starterkit/agents
mkdir -p vyker-claude-starterkit/hooks
mkdir -p vyker-claude-starterkit/lib
```

**Step 2: Create plugin.json**

Write to `vyker-claude-starterkit/.claude-plugin/plugin.json`:

```json
{
  "name": "vyker-claude-starterkit",
  "description": "All-in-one Claude Code plugin: superpowers, frontend design, security, CLAUDE.md management, and custom skills",
  "version": "1.0.0",
  "author": { "name": "Vyker" },
  "license": "MIT",
  "keywords": ["skills", "tdd", "debugging", "security", "frontend", "deploy", "starter-kit"]
}
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/
git commit -m "feat: scaffold vyker-claude-starterkit plugin structure"
```

---

### Task 2: Copy Superpowers Skills (14 skills)

**Files:**
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/skills/` (all 14 skill directories)
- Copy to: `vyker-claude-starterkit/skills/`

**Step 1: Copy all superpowers skill directories**

```bash
cp -r ~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/skills/* vyker-claude-starterkit/skills/
```

This copies: brainstorming, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, receiving-code-review, requesting-code-review, subagent-driven-development, systematic-debugging, test-driven-development, using-git-worktrees, using-superpowers, verification-before-completion, writing-plans, writing-skills.

**Step 2: Verify all 14 skill directories are present**

```bash
ls vyker-claude-starterkit/skills/ | wc -l
# Expected: 14
ls vyker-claude-starterkit/skills/
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/skills/
git commit -m "feat: add 14 superpowers skills"
```

---

### Task 3: Copy Frontend Design Skill

**Files:**
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/frontend-design/2cd88e7947b7/skills/frontend-design/`
- Copy to: `vyker-claude-starterkit/skills/frontend-design/`

**Step 1: Copy the frontend-design skill**

```bash
cp -r ~/.claude/plugins/cache/claude-plugins-official/frontend-design/2cd88e7947b7/skills/frontend-design vyker-claude-starterkit/skills/
```

**Step 2: Verify the SKILL.md is present**

```bash
ls vyker-claude-starterkit/skills/frontend-design/SKILL.md
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/skills/frontend-design/
git commit -m "feat: add frontend-design skill"
```

---

### Task 4: Copy Claude MD Improver Skill

**Files:**
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/claude-md-management/1.0.0/skills/claude-md-improver/`
- Copy to: `vyker-claude-starterkit/skills/claude-md-improver/`

**Step 1: Copy the claude-md-improver skill with its references**

```bash
cp -r ~/.claude/plugins/cache/claude-plugins-official/claude-md-management/1.0.0/skills/claude-md-improver vyker-claude-starterkit/skills/
```

**Step 2: Verify the SKILL.md and references are present**

```bash
ls vyker-claude-starterkit/skills/claude-md-improver/SKILL.md
ls vyker-claude-starterkit/skills/claude-md-improver/references/
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/skills/claude-md-improver/
git commit -m "feat: add claude-md-improver skill"
```

---

### Task 5: Copy VibeSec Skill

**Files:**
- Copy from: `~/.claude/skills/VibeSec-Skill/SKILL.md`
- Create: `vyker-claude-starterkit/skills/vibe-security/SKILL.md`

**Step 1: Create the vibe-security skill directory and copy the SKILL.md**

```bash
mkdir -p vyker-claude-starterkit/skills/vibe-security
cp ~/.claude/skills/VibeSec-Skill/SKILL.md vyker-claude-starterkit/skills/vibe-security/SKILL.md
```

**Step 2: Verify the SKILL.md is present**

```bash
head -5 vyker-claude-starterkit/skills/vibe-security/SKILL.md
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/skills/vibe-security/
git commit -m "feat: add vibe-security skill"
```

---

### Task 6: Copy Superpowers Commands

**Files:**
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/commands/brainstorm.md`
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/commands/execute-plan.md`
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/commands/write-plan.md`
- Copy to: `vyker-claude-starterkit/commands/`

**Step 1: Copy the three superpowers commands**

```bash
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/commands/brainstorm.md vyker-claude-starterkit/commands/
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/commands/execute-plan.md vyker-claude-starterkit/commands/
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/commands/write-plan.md vyker-claude-starterkit/commands/
```

**Step 2: Update skill references in commands to use the new plugin namespace**

The commands reference `superpowers:brainstorming`, `superpowers:executing-plans`, and `superpowers:writing-plans`. These need to be updated to `vyker-claude-starterkit:brainstorming`, etc.

Edit `vyker-claude-starterkit/commands/brainstorm.md`:
```markdown
---
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores requirements and design before implementation."
disable-model-invocation: true
---

Invoke the vyker-claude-starterkit:brainstorming skill and follow it exactly as presented to you
```

Edit `vyker-claude-starterkit/commands/execute-plan.md`:
```markdown
---
description: Execute plan in batches with review checkpoints
disable-model-invocation: true
---

Invoke the vyker-claude-starterkit:executing-plans skill and follow it exactly as presented to you
```

Edit `vyker-claude-starterkit/commands/write-plan.md`:
```markdown
---
description: Create detailed implementation plan with bite-sized tasks
disable-model-invocation: true
---

Invoke the vyker-claude-starterkit:writing-plans skill and follow it exactly as presented to you
```

**Step 3: Copy the revise-claude-md command**

```bash
cp ~/.claude/plugins/cache/claude-plugins-official/claude-md-management/1.0.0/commands/revise-claude-md.md vyker-claude-starterkit/commands/
```

**Step 4: Verify all 4 commands**

```bash
ls vyker-claude-starterkit/commands/
# Expected: brainstorm.md, execute-plan.md, revise-claude-md.md, write-plan.md
```

**Step 5: Commit**

```bash
git add vyker-claude-starterkit/commands/
git commit -m "feat: add commands (brainstorm, execute-plan, write-plan, revise-claude-md)"
```

---

### Task 7: Copy Agent and Lib Files

**Files:**
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/agents/code-reviewer.md`
- Copy from: `~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/lib/skills-core.js`
- Copy to: `vyker-claude-starterkit/agents/` and `vyker-claude-starterkit/lib/`

**Step 1: Copy the code-reviewer agent**

```bash
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/agents/code-reviewer.md vyker-claude-starterkit/agents/
```

**Step 2: Copy skills-core.js**

```bash
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/4.3.0/lib/skills-core.js vyker-claude-starterkit/lib/
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/agents/ vyker-claude-starterkit/lib/
git commit -m "feat: add code-reviewer agent and skills-core lib"
```

---

### Task 8: Create Merged Session-Start Hook

**Files:**
- Create: `vyker-claude-starterkit/hooks/hooks.json`
- Create: `vyker-claude-starterkit/hooks/session-start.sh`

This merges the superpowers session-start (skill discovery) with the explanatory-output-style session-start (educational insights).

**Step 1: Create hooks.json**

Write to `vyker-claude-starterkit/hooks/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh",
            "async": false
          }
        ]
      }
    ]
  }
}
```

**Step 2: Create the merged session-start.sh**

Write to `vyker-claude-starterkit/hooks/session-start.sh`:

```bash
#!/usr/bin/env bash
# SessionStart hook for vyker-claude-starterkit
# Merges: superpowers skill discovery + explanatory output mode

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Read using-superpowers content
using_superpowers_content=$(cat "${PLUGIN_ROOT}/skills/using-superpowers/SKILL.md" 2>&1 || echo "Error reading using-superpowers skill")

# Escape string for JSON embedding
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_superpowers_escaped=$(escape_for_json "$using_superpowers_content")

# Explanatory output mode instructions
explanatory_mode="You are in 'explanatory' output style mode, where you should provide educational insights about the codebase as you help with the user's task.\n\nYou should be clear and educational, providing helpful explanations while remaining focused on the task. Balance educational content with task completion. When providing insights, you may exceed typical length constraints, but remain focused and relevant.\n\n## Insights\nIn order to encourage learning, before and after writing code, always provide brief educational explanations about implementation choices using (with backticks):\n\"\`★ Insight ─────────────────────────────────────\`\n[2-3 key educational points]\n\`─────────────────────────────────────────────────\`\"\n\nThese insights should be included in the conversation, not in the codebase. You should generally focus on interesting insights that are specific to the codebase or the code you just wrote, rather than general programming concepts. Do not wait until the end to provide insights. Provide them as you write code."

explanatory_escaped=$(escape_for_json "$explanatory_mode")

# Output combined context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have the vyker-claude-starterkit installed.\n\n**Below is the full content of your 'vyker-claude-starterkit:using-superpowers' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n${using_superpowers_escaped}\n\n---\n\n${explanatory_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
```

**Step 3: Make session-start.sh executable**

```bash
chmod +x vyker-claude-starterkit/hooks/session-start.sh
```

**Step 4: Commit**

```bash
git add vyker-claude-starterkit/hooks/
git commit -m "feat: add merged session-start hook (superpowers + explanatory mode)"
```

---

### Task 9: Create GitHub MCP Server Config

**Files:**
- Create: `vyker-claude-starterkit/.mcp.json`

**Step 1: Create .mcp.json**

Write to `vyker-claude-starterkit/.mcp.json`:

```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/",
    "headers": {
      "Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}"
    }
  }
}
```

**Step 2: Commit**

```bash
git add vyker-claude-starterkit/.mcp.json
git commit -m "feat: add GitHub MCP server config"
```

---

### Task 10: Create /deploy Command

**Files:**
- Create: `vyker-claude-starterkit/commands/deploy.md`
- Create: `vyker-claude-starterkit/skills/deploy/SKILL.md`

**Step 1: Create the deploy skill**

Write to `vyker-claude-starterkit/skills/deploy/SKILL.md`:

```markdown
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
```

**Step 2: Create the deploy command**

Write to `vyker-claude-starterkit/commands/deploy.md`:

```markdown
---
description: Run the full deploy pipeline - test, debug, design audit, PR, and build
disable-model-invocation: true
---

Invoke the vyker-claude-starterkit:deploy skill and follow it exactly as presented to you
```

**Step 3: Commit**

```bash
git add vyker-claude-starterkit/skills/deploy/ vyker-claude-starterkit/commands/deploy.md
git commit -m "feat: add /deploy command and deploy pipeline skill"
```

---

### Task 11: Update Skill Cross-References

**Files:**
- Modify: Various SKILL.md files in `vyker-claude-starterkit/skills/`

The superpowers skills reference each other using `superpowers:` namespace prefix. These need to be updated to `vyker-claude-starterkit:` throughout all skill files.

**Step 1: Find all superpowers: references**

```bash
grep -r "superpowers:" vyker-claude-starterkit/skills/ --include="*.md" -l
```

**Step 2: Replace all namespace references**

For each file found, replace `superpowers:` with `vyker-claude-starterkit:` in skill invocation references. Be careful not to replace references in attribution/credit sections — only replace skill invocation patterns like "Invoke the superpowers:skill-name" or "Use superpowers:skill-name".

**Step 3: Verify no stale references remain**

```bash
grep -r "superpowers:" vyker-claude-starterkit/skills/ --include="*.md" | grep -v "github.com/obra/superpowers"
# Expected: no results (only URL references to the original repo should remain)
```

**Step 4: Commit**

```bash
git add vyker-claude-starterkit/skills/
git commit -m "refactor: update skill namespace from superpowers to vyker-claude-starterkit"
```

---

### Task 12: Create README.md

**Files:**
- Create: `vyker-claude-starterkit/README.md`

**Step 1: Write the README**

Write to `vyker-claude-starterkit/README.md`:

```markdown
# vyker-claude-starterkit

All-in-one Claude Code plugin that bundles essential skills, commands, and tools for productive development.

## Installation

```bash
# Add as a marketplace
/plugin marketplace add <username>/vyker-claude-starterkit

# Install
/plugin install vyker-claude-starterkit
```

Or clone directly:
```bash
git clone https://github.com/<username>/vyker-claude-starterkit ~/.claude/skills/vyker-claude-starterkit
```

## What's Included

### Skills (18)

| Skill | Description |
|-------|-------------|
| brainstorming | Explore requirements and design before implementation |
| dispatching-parallel-agents | Handle 2+ independent tasks concurrently |
| executing-plans | Execute implementation plans with review checkpoints |
| finishing-a-development-branch | Guide completion of development work |
| receiving-code-review | Handle code review feedback with rigor |
| requesting-code-review | Verify work meets requirements |
| subagent-driven-development | Execute plans with subagents |
| systematic-debugging | Diagnose bugs methodically |
| test-driven-development | Write tests before implementation |
| using-git-worktrees | Isolate feature work |
| using-superpowers | Skill discovery and bootstrapping |
| verification-before-completion | Verify before claiming done |
| writing-plans | Create implementation plans |
| writing-skills | Create and verify new skills |
| frontend-design | Production-grade frontend interfaces |
| claude-md-improver | Audit and improve CLAUDE.md files |
| vibe-security | Secure coding practices (OWASP) |
| deploy | Automated deploy pipeline |

### Commands

| Command | Description |
|---------|-------------|
| /brainstorm | Explore requirements before building |
| /execute-plan | Execute a saved implementation plan |
| /write-plan | Create a detailed implementation plan |
| /revise-claude-md | Update CLAUDE.md with session learnings |
| /deploy | Full deploy pipeline: test, debug, audit, PR, build |

### Other Features

- **Code Reviewer Agent** — Automated code review against plans and standards
- **GitHub MCP Server** — Repository management via MCP
- **Explanatory Mode** — Educational insights during coding
- **Session Bootstrap** — Automatic skill discovery on startup

## Credits

This plugin bundles content from:
- [superpowers](https://github.com/obra/superpowers) (MIT) by Jesse Vincent
- [frontend-design](https://github.com/anthropics/claude-plugins-official) by Anthropic
- [claude-md-management](https://github.com/anthropics/claude-plugins-official) by Anthropic
- [explanatory-output-style](https://github.com/anthropics/claude-plugins-official) by Anthropic
- [github](https://github.com/anthropics/claude-plugins-official) by GitHub
- [VibeSec-Skill](https://github.com/BehiSecc/VibeSec-Skill) by BehiSec

## License

MIT
```

**Step 2: Commit**

```bash
git add vyker-claude-starterkit/README.md
git commit -m "docs: add README"
```

---

### Task 13: Create LICENSE File

**Files:**
- Create: `vyker-claude-starterkit/LICENSE`

**Step 1: Create MIT LICENSE**

Write a standard MIT license to `vyker-claude-starterkit/LICENSE` with the current year (2026) and "Vyker" as copyright holder.

**Step 2: Commit**

```bash
git add vyker-claude-starterkit/LICENSE
git commit -m "docs: add MIT license"
```

---

### Task 14: Validate Plugin Structure

**Step 1: Verify complete directory tree**

```bash
find vyker-claude-starterkit -type f | sort
```

Expected files:
- `.claude-plugin/plugin.json`
- `.mcp.json`
- `LICENSE`
- `README.md`
- `agents/code-reviewer.md`
- `commands/brainstorm.md`
- `commands/deploy.md`
- `commands/execute-plan.md`
- `commands/revise-claude-md.md`
- `commands/write-plan.md`
- `hooks/hooks.json`
- `hooks/session-start.sh`
- `lib/skills-core.js`
- `skills/` (18 skill directories, each with at least SKILL.md)

**Step 2: Verify all SKILL.md files have valid frontmatter**

```bash
for skill_dir in vyker-claude-starterkit/skills/*/; do
    if [ -f "${skill_dir}SKILL.md" ]; then
        echo "OK: ${skill_dir}SKILL.md"
        head -3 "${skill_dir}SKILL.md"
        echo "---"
    else
        echo "MISSING: ${skill_dir}SKILL.md"
    fi
done
```

**Step 3: Verify hooks.json is valid JSON**

```bash
python3 -c "import json; json.load(open('vyker-claude-starterkit/hooks/hooks.json')); print('hooks.json: valid')"
python3 -c "import json; json.load(open('vyker-claude-starterkit/.claude-plugin/plugin.json')); print('plugin.json: valid')"
python3 -c "import json; json.load(open('vyker-claude-starterkit/.mcp.json')); print('.mcp.json: valid')"
```

**Step 4: Verify session-start.sh is executable**

```bash
test -x vyker-claude-starterkit/hooks/session-start.sh && echo "session-start.sh: executable" || echo "PROBLEM: not executable"
```

**Step 5: Verify no stale namespace references**

```bash
grep -r "superpowers:" vyker-claude-starterkit/ --include="*.md" --include="*.sh" | grep -v "github.com" | grep -v "README.md" | grep -v "credits" || echo "No stale references"
```

**Step 6: Final commit if any fixes were needed**

```bash
git status vyker-claude-starterkit/
# If changes: git add and commit with "fix: address validation issues"
```
