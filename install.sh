#!/bin/bash
set -e

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/agents"

if [ ! -d "$TARGET" ]; then
  echo "Error: Target directory '$TARGET' does not exist."
  exit 1
fi

if [ ! -d "$AGENTS_DIR" ]; then
  echo "Error: Agents directory not found at '$AGENTS_DIR'."
  exit 1
fi

mkdir -p "$TARGET/.claude/agents"

count=0
for agent in "$AGENTS_DIR"/*.md; do
  [ -f "$agent" ] || continue
  cp "$agent" "$TARGET/.claude/agents/"
  name=$(basename "$agent" .md)
  echo "  ✓ $name"
  count=$((count + 1))
done

echo ""
echo "✓ Installed $count agents into $TARGET/.claude/agents/"
echo ""
echo "Usage:"
echo "  cd $TARGET"
echo "  claude \"Audit the repository\" --agent architect"
echo "  claude \"Review my changes\" --agent code-reviewer"
echo "  claude \"Find security vulnerabilities\" --agent security"