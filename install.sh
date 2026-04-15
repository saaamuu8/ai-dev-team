#!/bin/bash
set -e

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"
SKILLS_DIR="$SCRIPT_DIR/skills"

if [ ! -d "$TARGET" ]; then
  echo "Error: Target directory '$TARGET' does not exist."
  exit 1
fi

if [ ! -d "$AGENTS_DIR" ]; then
  echo "Error: Agents directory not found at '$AGENTS_DIR'."
  exit 1
fi

# ─── Agents ───────────────────────────────────────────────
mkdir -p "$TARGET/.claude/agents"

count=0
while IFS= read -r -d '' agent; do
  [ -f "$agent" ] || continue
  cp "$agent" "$TARGET/.claude/agents/"
  name=$(basename "$agent" .md)
  rel="${agent#$AGENTS_DIR/}"
  domain=$(dirname "$rel")
  if [ "$domain" = "." ]; then
    echo "  ✓ $name"
  else
    echo "  ✓ [$domain] $name"
  fi
  count=$((count + 1))
done < <(find "$AGENTS_DIR" -name "*.md" -print0 | sort -z)

echo ""
if [ "$count" -eq 0 ]; then
  echo "⚠ No agents found in $AGENTS_DIR"
else
  echo "✓ Installed $count agents into $TARGET/.claude/agents/"
fi

# ─── Skills ───────────────────────────────────────────────
skill_count=0
if [ -d "$SKILLS_DIR" ]; then
  while IFS= read -r -d '' skill; do
    [ -f "$skill" ] || continue
    rel="${skill#$SKILLS_DIR/}"
    skill_folder=$(dirname "$rel")
    mkdir -p "$TARGET/.claude/skills/$skill_folder"
    cp "$skill" "$TARGET/.claude/skills/$skill_folder/"
    echo "  ✓ $skill_folder"
    skill_count=$((skill_count + 1))
  done < <(find "$SKILLS_DIR" -name "*.md" -print0 | sort -z)
  echo ""
  echo "✓ Installed $skill_count skill(s) into $TARGET/.claude/skills/"
fi

# ─── MCP Servers (project-scoped) ─────────────────────────
echo ""
echo "Configuring project-scoped MCP servers..."

if ! command -v claude &> /dev/null; then
  echo "  ⚠ 'claude' CLI not found, skipping MCP setup."
  echo "    Install Claude Code, then run the MCP commands manually."
else
  pushd "$TARGET" > /dev/null

  # Stripe (each project = its own Stripe account)
  if claude mcp get stripe &> /dev/null; then
    echo "  • stripe already configured, skipping"
  else
    if claude mcp add --transport http --scope project stripe https://mcp.stripe.com 2>/dev/null; then
      echo "  ✓ stripe (authenticate with /mcp inside Claude Code)"
    else
      echo "  ✗ stripe failed to add — run manually:"
      echo "    claude mcp add --transport http --scope project stripe https://mcp.stripe.com"
    fi
  fi

  # Postgres — only if DATABASE_URL is in .env
  if [ -f .env ] && grep -q "^DATABASE_URL=" .env; then
    if claude mcp get postgres &> /dev/null; then
      echo "  • postgres already configured, skipping"
    else
      if claude mcp add --scope project postgres -- npx -y @bytebase/dbhub --dsn "\${DATABASE_URL}" 2>/dev/null; then
        echo "  ✓ postgres (uses \${DATABASE_URL} from .env)"
      else
        echo "  ✗ postgres failed to add — run manually:"
        echo "    claude mcp add --scope project postgres -- npx -y @bytebase/dbhub --dsn \"\\\${DATABASE_URL}\""
      fi
    fi
  else
    echo "  ⚠ DATABASE_URL not found in .env, skipping postgres MCP"
    echo "    Add it later with:"
    echo "    claude mcp add --scope project postgres -- npx -y @bytebase/dbhub --dsn \"\\\${DATABASE_URL}\""
  fi

  popd > /dev/null
fi

# ─── Final hint ───────────────────────────────────────────
echo ""
echo "Done. Next steps:"
echo "  cd $TARGET"
echo "  claude        # then run /mcp to authenticate Stripe (and any pending OAuth)"
echo ""
echo "Available agent configurations:"
echo "  fullstack-architect   — architecture, code review, API contracts, type safety, docs, migrations"
echo "  frontend-quality      — a11y, design system, performance, SEO, E2E"
echo "  backend-platform      — DB, integrations, events, infra, observability, integration tests"
echo "  critical-systems      — security, auth, billing"
