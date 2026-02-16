---
name: architecture-decision-records
description: Record and reference team architecture decisions (ADRs) so Claude sessions and developers respect established technical choices.
---

# Architecture Decision Records

## Overview

Teams make technical decisions constantly — "use Zod for validation", "JWT not sessions", "monorepo structure". Without recording them, every new Claude session or team member re-debates the same choices. This skill creates lightweight ADRs that become the team's technical memory.

## Recording a Decision

Execute these steps in order without confirmation prompts.

### Step 1: Understand the Decision

Ask the developer (or extract from the session context):

1. **What** decision was made?
2. **Why** was it made? What problem does it solve?
3. **What alternatives** were considered?
4. **What are the consequences** — tradeoffs, constraints this introduces?

### Step 2: Assign an ADR Number

1. Check if `docs/decisions/` directory exists — create it if not
2. List existing ADR files: look for files matching `NNN-*.md` pattern
3. Assign the next sequential number (e.g., if `001-use-typescript.md` exists, next is `002`)

### Step 3: Write the ADR

Create `docs/decisions/<NNN>-<slug>.md` using this format:

```markdown
# ADR-<NNN>: <Title>

**Date:** <current date>
**Status:** Accepted
**Deciders:** <who was involved>

## Context

<What is the issue? Why does this decision need to be made?
2-4 sentences of background.>

## Decision

<What is the change that we're proposing and/or doing?
State it clearly and directly.>

## Alternatives Considered

### <Alternative 1>
<Brief description and why it was rejected>

### <Alternative 2>
<Brief description and why it was rejected>

## Consequences

### Positive
- <benefit 1>
- <benefit 2>

### Negative
- <tradeoff 1>
- <tradeoff 2>

### Neutral
- <constraint or implication>
```

### Step 4: Update CLAUDE.md

1. Read the project's CLAUDE.md
2. Add a one-line reference to the decision in the appropriate section
3. Format: `- ADR-<NNN>: <brief summary>` (e.g., `- ADR-003: Use Zod for all runtime validation`)
4. If CLAUDE.md has no ADR section, add one under a `## Architecture Decisions` heading

### Step 5: Stage Files

1. `git add docs/decisions/<NNN>-<slug>.md`
2. `git add CLAUDE.md` (if modified)
3. Do NOT commit automatically — let the developer review

## Listing Decisions

When asked to list or review decisions:

1. Read all files in `docs/decisions/`
2. Output a summary table:

```
## Architecture Decisions

| # | Decision | Date | Status |
|---|----------|------|--------|
| 001 | Use TypeScript for all new code | 2025-01-15 | Accepted |
| 002 | JWT for authentication | 2025-01-20 | Accepted |
| 003 | Use Zod for runtime validation | 2025-02-01 | Superseded by 005 |
```

## Superseding a Decision

When a previous decision is being replaced:

1. Update the old ADR's status to `Superseded by ADR-<NNN>`
2. In the new ADR, add a line: `**Supersedes:** ADR-<old-NNN>`
3. Update the CLAUDE.md reference

## ADR Statuses

- **Proposed** — under discussion, not yet agreed
- **Accepted** — agreed and in effect
- **Deprecated** — no longer recommended but not replaced
- **Superseded** — replaced by a newer ADR (reference it)

## Red Flags

- Making significant technical choices without recording them
- ADRs that only say "what" without explaining "why"
- Ignoring existing ADRs and re-debating settled decisions
- Writing ADRs that are too long — keep them concise and scannable

## Common Mistakes

- Not updating CLAUDE.md — the ADR exists but Claude doesn't know about it
- Writing ADRs after the fact without capturing the alternatives that were considered
- Using ADR status "Accepted" for proposals that haven't been agreed on yet
