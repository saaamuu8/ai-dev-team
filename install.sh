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

mkdir -p "$TARGET/.claude/agents"

count=0
while IFS= read -r -d '' agent; do
  [ -f "$agent" ] || continue
  cp "$agent" "$TARGET/.claude/agents/"
  name=$(basename "$agent" .md)
  # Show domain/agent-name
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
echo "✓ Installed $count agents into $TARGET/.claude/agents/"

# Install skills
skill_count=0
if [ -d "$SKILLS_DIR" ]; then
  while IFS= read -r -d '' skill; do
    [ -f "$skill" ] || continue
    # Each skill lives in its own folder; preserve that folder under .claude/skills/
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

echo ""
echo "Usage:"
echo "  cd $TARGET"
echo "  claude \"Audit the repository\" --agent architect"
echo "  claude \"Review my changes\" --agent code-reviewer"
echo "  claude \"Find security vulnerabilities\" --agent security"