# vyker-claude-starterkit

All-in-one Claude Code plugin that bundles essential skills, commands, and tools for productive development.

## Installation

```bash
/plugin marketplace add Vyker6/vyker-claude-starterkit-marketplace
/plugin install vyker-claude-starterkit
```

## What's Included

### Skills (24)

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
| team-governance | Enforce CLAUDE.md rules as hard gates across 7 sequential checks |
| context-handoff | Document work state for seamless handoff between team members |
| conflict-radar | Scan open branches and PRs for file overlaps before you start |
| architecture-decision-records | Record and reference team architecture decisions (ADRs) |
| pr-prep | Generate comprehensive PR descriptions with walkthrough and review guidance |
| onboarding | Personalized project orientation for new team members |

### Commands

| Command | Description |
|---------|-------------|
| /brainstorm | Explore requirements before building |
| /execute-plan | Execute a saved implementation plan |
| /write-plan | Create a detailed implementation plan |
| /revise-claude-md | Update CLAUDE.md with session learnings |
| /deploy | Full deploy pipeline: test, debug, audit, PR, build |
| /teampush | Run team governance pipeline: enforce CLAUDE.md rules, TDD, security, and verification gates |
| /handoff | Document current work state for team handoff |
| /conflicts | Scan for file overlaps with open branches and PRs |
| /decide | Record an architecture decision (ADR) |
| /pr-prep | Generate a review-ready PR description |
| /onboard | Generate project orientation for new team members |

### Governance Hooks (automatic)

| Hook | Event | What it does |
|------|-------|-------------|
| Branch check | Session start | Warns if on main/master branch |
| Branch naming | Session start | Warns if branch doesn't follow convention (feat/, fix/, etc.) |
| Stale branch | Session start | Warns if branch hasn't rebased on main in 3+ days |
| TDD nudge | After file edit/write | Reminds to write tests for implementation files |
| Commit message lint | Before `git commit` | Enforces conventional commit format (feat:, fix:, etc.) |
| Large diff warning | Before `git push` | Warns if diff exceeds 500 lines, suggests splitting |
| Push gate | Before `git push` / `gh pr create` | Blocks push until `/teampush` passes |

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
