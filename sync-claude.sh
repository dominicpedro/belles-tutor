#!/usr/bin/env bash
# sync-claude.sh
#
# Syncs tutor agents, commands, and rules from the agentic-tutor submodule
# into this student instance's .claude/ directory via symlinks.
#
# Safe to re-run: skips existing local files, refreshes stale symlinks.
#
# Usage:
#   ./sync-claude.sh          # Create/refresh symlinks
#   ./sync-claude.sh --clean  # Remove all symlinks (keep local files)

set -euo pipefail

SHARED=".claude/.shared/.claude"

if [ ! -d "$SHARED" ]; then
  echo "ERROR: Submodule not found at .claude/.shared"
  echo "Run:   git submodule update --init --recursive"
  exit 1
fi

CLEAN=false
if [[ "${1:-}" == "--clean" ]]; then
  CLEAN=true
fi

link_items() {
  local src_dir="$1" dst_dir="$2" pattern="${3:-*}"
  mkdir -p "$dst_dir"

  # Remove stale symlinks
  for dst in "$dst_dir"/$pattern; do
    [ -L "$dst" ] || continue
    if [ ! -e "$dst" ]; then
      rm "$dst"
      echo "  STALE: $dst (removed)"
    fi
  done

  if $CLEAN; then
    for dst in "$dst_dir"/$pattern; do
      if [ -L "$dst" ]; then
        rm "$dst"
        echo "  REMOVED: $dst"
      fi
    done
    return
  fi

  for src in "$src_dir"/$pattern; do
    [ -e "$src" ] || continue
    local name
    name=$(basename "$src")

    [[ "$name" == .* ]] && continue
    [[ "$name" == "README.md" ]] && continue

    local dst="$dst_dir/$name"
    local rel
    rel=$(python3 -c "import os.path; print(os.path.relpath('$src', '$dst_dir'))")

    if [ -L "$dst" ]; then
      rm "$dst"
      ln -s "$rel" "$dst"
    elif [ -e "$dst" ]; then
      echo "  SKIP (local): $dst"
      continue
    else
      ln -s "$rel" "$dst"
      echo "  LINK: $dst -> $rel"
    fi
  done
}

echo ""
echo "=== Agentic Tutor Sync ==="
echo "Source: $SHARED"
echo ""

if $CLEAN; then
  echo "Mode: CLEAN (removing symlinks)"
else
  echo "Mode: SYNC (creating symlinks)"
fi

echo ""
echo "Agents..."
link_items "$SHARED/agents" ".claude/agents" "*.md"

echo "Commands..."
link_items "$SHARED/commands" ".claude/commands" "*.md"

echo "Rules..."
link_items "$SHARED/rules" ".claude/rules" "*.md"

echo ""
echo "Done."
echo ""

if ! $CLEAN; then
  local_count=$(find .claude/rules .claude/commands .claude/agents -maxdepth 1 ! -type l -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  link_count=$(find .claude/rules .claude/commands .claude/agents -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')
  echo "  Symlinks: $link_count"
  echo "  Local files: $local_count"
fi
