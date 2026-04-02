---
name: memory-manager
description: >
  Manages persistent memory across Claude sessions using a structured file system under `.claude/memory/`.
  Use this skill at the START and END of every task — always, without exception. Also triggers when the
  user mentions "continuity", "remember from last time", "where were we", "context", "previous session",
  or anything implying cross-session memory. Even if no memory files exist yet, run the startup check and
  create them at the end. This skill is the foundation for long-running projects with Claude.
---

# Memory Manager

Persistent memory across sessions via structured files in `.claude/memory/`.

**Run at the START and END of every task. No exceptions.**

---

## Directory Layout

```
.claude/memory/
  stable/
    CONTEXT.md      ← Clean snapshot of current state (stack, architecture, conventions)
    DECISIONS.md    ← Append-only log of important technical decisions
    INDEX.md        ← Repo map: files, purpose, owner agent (replaces manual exploration)
  working/
    CURRENT.md      ← What's happening RIGHT NOW (task, status, blockers, next steps)
    TODO.md         ← Live task list
    AGENTS.md       ← Shared coordination map across all agents (monorepo only)
  logs/
    CONVERSATIONS.md ← Selective log: only sessions with decisions, bugs, or critical context
```

---

## AT SESSION START

Run these steps in order before doing anything else:

```bash
ls .claude/memory/ 2>/dev/null || echo "No memory found"
```

**Priority reading order** (stop early if you have enough context):

1. `stable/CONTEXT.md` — always read
2. `stable/INDEX.md` — always read if it exists (replaces exploring the repo manually)
3. `working/CURRENT.md` — always read
4. `working/TODO.md` — always read
5. `working/AGENTS.md` — always read if it exists (check for file conflicts before starting)
6. `stable/DECISIONS.md` — only if working on something where past decisions matter
7. `logs/CONVERSATIONS.md` — only if user explicitly mentions continuing previous work

If no memory exists, proceed normally and create it at the end.

**If AGENTS.md exists:** before doing any work, check if another agent is actively touching the same files you plan to touch. If there's a conflict, warn the user immediately: `⚠️ Conflict: agent-X is working on [file]. Proceed anyway?`

---

## AT SESSION END

Always run these steps when finishing a task:

```bash
mkdir -p .claude/memory/stable .claude/memory/working .claude/memory/logs
```

Then update files in this order:

### 1. `stable/CONTEXT.md` — Clean snapshot (not a history)

**Rules:**
- Represents current state only — delete anything obsolete
- Fixed format (see below)
- Rewrite the whole file if architecture changed; patch otherwise

```markdown
## Stack
- [list tech]

## Architecture
- [key structural decisions, e.g. "backend stores meters, frontend converts"]

## Conventions
- [naming, patterns, constraints the LLM needs to know]
```

### 2. `working/CURRENT.md` — What's happening now

Rewrite completely each session:

```markdown
## Current task
[one line description]

## Status
[Not started | In progress | Blocked | Done]

## Next steps
- [ordered list]

## Blockers
[None, or describe]
```

### 3. `working/TODO.md` — Live task list

- Mark completed items with `[x]`
- Add new items discovered this session
- Move old completed items to a `## Completed` section at the bottom (don't delete)

### 4. `stable/DECISIONS.md` — Append-only decision log

**Only write an entry if a real technical decision was made.** Do not write entries for routine work.

Each entry follows this exact format:

```markdown
## [YYYY-MM-DD] Short title of decision

### Decision
What was decided.

### Reason
Why this option was chosen over alternatives.

### Impact
What changes or depends on this decision.

### Scope
Which module, feature, or area this affects.
```

### 5. `logs/CONVERSATIONS.md` — Selective session log

**Only append if this session contains at least one of:**
- A decision logged in DECISIONS.md
- A significant bug found or fixed
- Critical context that future sessions need

**If none of the above: skip this file entirely.**

**Rotation rule — max 5 entries.** Use this exact script to append and rotate:

```python
import re

new_entry = """## [YYYY-MM-DD] Session summary

**Objective:** [what the user wanted]
**Done:** [what was actually accomplished]
**Problems:** [issues encountered, if any]
**State at exit:** [where things stand]
**Next steps:** [recommended follow-up]
"""

try:
    with open('.claude/memory/logs/CONVERSATIONS.md', 'r') as f:
        content = f.read()
    entries = [e for e in re.split(r'(?=^## \[)', content, flags=re.MULTILINE) if e.strip()]
except FileNotFoundError:
    entries = []

entries.append(new_entry)
entries = entries[-5:]  # keep only the last 5

with open('.claude/memory/logs/CONVERSATIONS.md', 'w') as f:
    f.write('\n'.join(entries))
```

Run it with `python3 -c "..."` or write to a temp file and execute. Never append manually — always use this script to enforce the limit.

---

## Writing Rules

**Before writing any file:**
- Read what's already there
- Update and patch, don't blindly append or overwrite
- Remove duplicates and obsolete content

**What to write:**
- Concise, reusable information only
- Facts, decisions, state — not internal reasoning or narration
- Write for a future LLM that has zero context beyond these files

**What NOT to write:**
- Stream of consciousness or thinking-out-loud
- Redundant summaries of things already in CONTEXT.md
- Every small step taken (only meaningful outcomes)

---

## Quick Reference

| File | Frequency | Content type |
|---|---|---|
| `CONTEXT.md` | Every session | Current state snapshot |
| `INDEX.md` | When files change | Repo map by module |
| `CURRENT.md` | Every session | Active task + status |
| `TODO.md` | Every session | Live task list |
| `AGENTS.md` | Every session (monorepo) | Active agent coordination |
| `DECISIONS.md` | When decisions made | Append-only log |
| `CONVERSATIONS.md` | Only when significant | Last 5 sessions max |

---

## Repo index (stable/INDEX.md)

INDEX.md is a **living map of the codebase** — generated once, updated incrementally. Its purpose is to eliminate repo exploration: an agent reads the index and knows exactly which files exist, what they do, and who owns them. Zero `find`, zero `cat`, zero wasted tokens.

### When to generate

- **First time:** If INDEX.md doesn't exist, generate it before starting any work. Run this script:

```python
import os

index = []
skip_dirs = {'.git', 'node_modules', '__pycache__', '.next', 'dist', 'build', '.claude'}

for root, dirs, files in os.walk('.'):
    dirs[:] = [d for d in sorted(dirs) if d not in skip_dirs]
    rel_root = os.path.relpath(root, '.')
    if rel_root == '.':
        continue
    src_files = [f for f in sorted(files) if not f.startswith('.')]
    if not src_files:
        continue
    index.append(f'## {rel_root}/')
    for fname in src_files:
        index.append(f'- {fname}')
    index.append('')

os.makedirs('.claude/memory/stable', exist_ok=True)
with open('.claude/memory/stable/INDEX.md', 'w') as f:
    f.write('# Repo Index\n\n')
    f.write('\n'.join(index))

print(f"Indexed {sum(1 for l in index if l.startswith('- '))} files")
```

- **Incrementally:** At session end, if you created, moved, or deleted files — update only the affected sections. Do not regenerate the full index unless the structure changed significantly.

### Format

```markdown
# Repo Index

## src/auth/
- auth.service.ts — JWT issue/verify, refresh logic | owner: agent-auth
- middleware/auth.js — Express Bearer token validator | owner: agent-auth

## src/billing/
- checkout.service.ts — Stripe checkout, emits billing.completed | owner: agent-billing
- webhook.handler.ts — Stripe webhook receiver, idempotency via Redis | owner: agent-billing

## src/api/
- routes/users.js — CRUD /users, requires auth middleware | owner: agent-api
- routes/health.js — Health check endpoint, no auth | owner: agent-api
```

### Rules

- **One line per file** — filename + what it does + owner agent (if assigned)
- **Owner** is the agent that last significantly modified the file. Update it when you make substantial changes.
- **Do not describe every line** — only what another agent needs to know to decide whether to read it
- **Keep it flat** — no nesting beyond directory level
- **Update incrementally** — add new files, update descriptions for files you touched, remove deleted files

### How agents use it

At session start, read INDEX.md instead of running `find`, `ls -R`, or reading files to understand the structure. If a file's one-line description isn't enough, then open it. But most of the time it will be.


---

## Multi-agent coordination (monorepo)

If multiple agents work in the same repo, they share `.claude/memory/` automatically. `AGENTS.md` is the coordination file — every agent reads it at start and updates it at end.

### Format of `working/AGENTS.md`

```markdown
## agent-auth
Status: In progress
Task: JWT refresh logic
Files: src/auth/*, src/middleware/auth.js
Started: 2026-04-02

## agent-api
Status: Done
Task: REST endpoints for /users
Files: src/routes/users.js
Started: 2026-04-01
```

### Rules

**At session start:** Read AGENTS.md, scan `Files:` of all `In progress` agents. If any overlap with files you plan to touch → warn the user before proceeding.

**At session end:** Update your agent's entry using this script to avoid overwriting other agents' entries:

```python
import re, datetime

AGENT_NAME = "agent-name"  # replace with this agent's name
TASK = "Short task description"
FILES = "src/path/to/files"
STATUS = "In progress"  # or "Done"

new_entry = f"""## {AGENT_NAME}
Status: {STATUS}
Task: {TASK}
Files: {FILES}
Started: {datetime.date.today()}
"""

try:
    with open('.claude/memory/working/AGENTS.md', 'r') as f:
        content = f.read()
    # Replace this agent's existing entry, or append if not found
    pattern = rf'(## {re.escape(AGENT_NAME)}\n.*?)(?=\n## |\Z)'
    if re.search(pattern, content, re.DOTALL):
        content = re.sub(pattern, new_entry.strip(), content, flags=re.DOTALL)
    else:
        content = content.rstrip() + '\n\n' + new_entry
except FileNotFoundError:
    content = new_entry

with open('.claude/memory/working/AGENTS.md', 'w') as f:
    f.write(content)
```

**When status is Done:** set `Status: Done` so other agents know the files are free. Don't delete the entry — leave it as a record.

**Naming convention:** Each agent should have a consistent name tied to its domain, e.g. `agent-auth`, `agent-api`, `agent-frontend`. Set it once and keep it across sessions.
