---
name: changelog-writer
description: Write or update CHANGELOG.md entries, or release notes as an entry list, from a diff, commit range, git log, or merged PRs. Use whenever the user mentions "changelog", "CHANGELOG.md", or "what changed in this release", even without naming a file. Not for commit messages, PR descriptions, or announcement prose.
license: MIT
metadata:
  version: "1.0.0"
---

# Changelog Writer

Write for a user deciding whether to upgrade who hasn't seen the diff. They ask: does it break me, what must I do, is my bug fixed?

## Workflow

1. Determine range: explicit version/range from user wins. Else last tag via `git tag --sort=-v:refname | head -5`. Else `## [Unreleased]`.
2. Collect evidence, in order: `git log <since>..HEAD --oneline`, `git diff <since>..HEAD --stat`, then full `git diff <since>..HEAD` for touched areas only. Shortcut: `bash <skill-dir>/scripts/collect-changes.sh [<since>] [--stat-only]`, where `<skill-dir>` is the folder containing this SKILL.md. Manual bullets: use as leads, still verify against diff when available.
3. Filter through Scope, draft Entries, mark Breaking changes, then run Before output checks.

## Source

- The existing file wins: copy its categories, tense, dates, and link style from the last 2-3 entries. No file: Keep a Changelog (`## [1.2.0] - YYYY-MM-DD`), past tense.
- The diff is the evidence. Commit messages and PR titles are written mid-work: use them as leads.
- Put unshipped work under `## [Unreleased]`. Never invent a version or date.

## Scope

Include only what an upgrading user would notice: public signatures, CLI flags, output format, exit codes, response shapes, config keys, defaults, visible errors, supported platforms and runtimes.

Skip refactors, tests, CI, formatting, docs, typo fixes, and dependency bumps, unless the bump changes what users must install or closes a CVE.

A bug introduced and fixed within one release never shipped: fold the fix into its Added or Changed entry. Added then reverted: no entry.

## Entries

Default categories: Added, Changed, Deprecated, Removed, Fixed, Security. Omit empty ones.

- Changed: state old and new behavior.
- Deprecated: name the replacement and the removal version.
- Fixed: describe the symptom and its trigger, not the cause.
- Security: cite the CVE/GHSA ID and affected versions. Give no exploit detail.

One change per line, in its own category, verb first. Test: could a user tell what changed without reading the code?

> Reduced cold-start time from ~800ms to ~150ms by lazy-loading plugins.

An entry that reduces to a vague word (various, misc, several, some, minor, improved, updated, enhanced) fails the test. State the observable difference from the diff. If you can't tell, flag it for the maintainer.

Numbers only from the diff or PR. Name a symbol or file only if users touch it. Facts, no adjectives.

## Breaking changes

Any change that breaks existing usage, every Removed included, gets `**BREAKING:**` at the start of its own entry, never in a footnote. State the change and the migration; add the reason only if the migration looks arbitrary. An entry without a migration step is a support ticket.

> **BREAKING:** `--output` now defaults to `json` (was `text`). Pass `--output text` to keep the old behavior.

## Version

Any BREAKING entry: major. Added or Deprecated: minor. Fixed or Security only: patch. Pre-1.0, breaking bumps minor. If the requested version contradicts the entries, say so, then use it.

## Before output

Squash "start X", "fix X", "actually fix X" into one entry. Within a category: BREAKING first, then by users affected. Reread as a user who never saw the diff; fix or cut any line that needs it. Three real changes means three lines.

## Output

- CHANGELOG.md exists or user said "update": patch the file in place. Match its heading level, keep existing link refs at the bottom, add new ones only if the file uses them.
- No file, or user asked "release notes" / "what changed": print the entry list only, no file write.
- No file and user said "create/update changelog": create with this header, then the version section:
  ```md
  # Changelog
  All notable changes to this project will be documented in this file.
  ```
- Never mix modes: either edit the file or print the list, not both, unless asked.
