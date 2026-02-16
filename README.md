# vyker-claude-starterkit marketplace

Claude Code plugin marketplace for [vyker-claude-starterkit](https://github.com/Vyker6/vyker-claude-starterkit).

## Installation

```bash
/plugin marketplace add Vyker6/vyker-claude-starterkit-marketplace
/plugin install vyker-claude-starterkit
```

## What's Included

**vyker-claude-starterkit** — 24 skills, 11 commands, 7 automatic hooks, a code reviewer agent, GitHub MCP server, and automated deploy pipeline bundled into one plugin.

See the [plugin repo](https://github.com/Vyker6/vyker-claude-starterkit) for full details.

## Troubleshooting

### Permission denied (publickey)

If you see `git@github.com: Permission denied (publickey)` during install, your environment is trying to clone via SSH. Fix by forcing HTTPS:

```bash
git config --global url."https://github.com/".insteadOf git@github.com:
```

Then retry `/plugin install vyker-claude-starterkit`.

## License

MIT
