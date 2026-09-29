# clws — changelog-writer skill

Write or update `CHANGELOG.md` entries (Keep a Changelog) or release notes from a diff, commit range, git log, or merged PRs. Works with Claude Code, OpenCode, Codex, Cursor, GitHub Copilot, and Gemini CLI.

## Install

```sh
npx skills add mukundzha/clws -g
# Gemini CLI alternative:
gemini skills install https://github.com/mukundzha/clws
```

Or copy the pre-wired folder for your runtime (`.agents/skills/` also works as a universal fallback — most runtimes read it):

| Runtime         | Copy to                                          |
| --------------- | ------------------------------------------------ |
| Claude Code     | `.claude/skills/` or `~/.claude/skills/`         |
| Codex           | `.agents/skills/` or `~/.agents/skills/`         |
| OpenCode        | `.opencode/skills/` or `~/.config/opencode/skills/` |
| Cursor          | `.cursor/skills/` or `~/.cursor/skills/`         |
| GitHub Copilot  | `.github/skills/` or `~/.copilot/skills/`        |
| Gemini CLI      | `.gemini/skills/` or `~/.gemini/skills/`         |

## Use

Mention "changelog", `CHANGELOG.md`, or "what changed in this release" and the skill triggers. It collects evidence (`git log` → `stat` → targeted `diff`, or `bash <skill-dir>/scripts/collect-changes.sh [<since>] [--stat-only]`), filters to user-visible changes, and either patches `CHANGELOG.md` in place or prints an entry list for release notes.

## Layout

- `SKILL.md` — canonical skill (single source of truth)
- `scripts/collect-changes.sh` — evidence collector
- `scripts/sync-skills.sh` — sync root into all runtime folders after edits
- `.agents/.claude/.codex/.opencode/.cursor/.github/.gemini/skills/changelog-writer/` — identical installed copies

## Dev

Edit root `SKILL.md` only, then `bash scripts/sync-skills.sh` before committing.
