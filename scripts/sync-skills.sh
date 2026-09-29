#!/usr/bin/env bash
# Sync canonical SKILL.md + bundled scripts into all platform paths.
# Run from repo root after editing ./SKILL.md or ./scripts/.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGETS=(
  ".agents/skills/changelog-writer"
  ".claude/skills/changelog-writer"
  ".codex/skills/changelog-writer"
  ".opencode/skills/changelog-writer"
  ".cursor/skills/changelog-writer"
  ".github/skills/changelog-writer"
  ".gemini/skills/changelog-writer"
)
for t in "${TARGETS[@]}"; do
  mkdir -p "$ROOT/$t/scripts"
  cp "$ROOT/SKILL.md" "$ROOT/$t/SKILL.md"
  cp "$ROOT/scripts/collect-changes.sh" "$ROOT/$t/scripts/collect-changes.sh"
  echo "synced $t"
done
