#!/usr/bin/env bash
# Collect changelog evidence for a range. Output is ordered for the skill workflow.
# Usage: collect-changes.sh [<since> | --unreleased] [--stat-only]
set -euo pipefail

SINCE="${1:-}"
STAT_ONLY=false
if [[ "${2:-}" == "--stat-only" || "${1:-}" == "--stat-only" ]]; then
  STAT_ONLY=true
  if [[ "$SINCE" == "--stat-only" ]]; then SINCE=""; fi
fi

if [[ "$SINCE" == "--unreleased" ]]; then
  SINCE=""
fi

if [[ -z "$SINCE" ]]; then
  SINCE=$(git tag --sort=-v:refname 2>/dev/null | head -n 1 || true)
fi

echo "=== range ==="
if [[ -n "$SINCE" ]]; then
  echo "$SINCE..HEAD"
else
  echo "no prior tag — full history (Unreleased)"
  SINCE=$(git rev-list --max-parents=0 HEAD 2>/dev/null | head -n 1 || echo "HEAD")
fi

echo ""
echo "=== tags (recent 5) ==="
git tag --sort=-v:refname 2>/dev/null | head -n 5 || echo "(no tags)"

echo ""
echo "=== log $SINCE..HEAD ==="
git log "$SINCE..HEAD" --oneline --decorate 2>/dev/null || git log --oneline -20

echo ""
echo "=== stat $SINCE..HEAD ==="
git diff "$SINCE..HEAD" --stat 2>/dev/null || git show --stat HEAD

if [[ "$STAT_ONLY" == false ]]; then
  echo ""
  echo "=== diff $SINCE..HEAD ==="
  git diff "$SINCE..HEAD" 2>/dev/null || git show HEAD
fi
