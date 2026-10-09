---
name: antigravity-cli
description: Delegate headless coding work to Antigravity CLI.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows]
metadata:
  hermes:
    tags: [antigravity, agy, coding, automation]
    related_skills: [hermes-agent, claude-code, codex]
---

# Antigravity CLI

Use Google's Antigravity CLI (`agy`) for headless coding, refactoring, and multi-file changes. This skill documents the installed Windows executable and keeps each run scoped to an explicit workspace.

## When to Use

- A user explicitly asks to delegate implementation to Antigravity CLI.
- A bounded coding or refactoring task benefits from a separate coding agent.

Do not use it for authentication, destructive repository operations, or vague prompts without acceptance criteria.

## Prerequisites

- Antigravity CLI installed at `%LOCALAPPDATA%\\agy\\bin\\agy.exe`.
- The target workspace path.
- Antigravity authentication completed interactively if the first run requests it.

## How to Run

Use `terminal` with the target directory as `workdir`:

```text
terminal(command="agy -p \"<explicit task, files, tests, acceptance criteria>\" --dangerously-skip-permissions", workdir="C:\\path\\to\\workspace", timeout=600)
```

If `agy` is not on the current PATH, invoke the absolute executable path. Prefer a narrow prompt and a bounded timeout. Review the resulting diff and run verification independently.

## Procedure

1. Confirm the executable with `terminal(command="agy --version", workdir="<workspace>")`.
2. Inspect repository status and identify the exact files and verification commands.
3. Run `agy -p` with explicit scope, required tests, and a request not to touch unrelated files.
4. Inspect `git diff` and repository status after the run.
5. Run focused tests, then the full available verification suite.
6. Report the agent output separately from independently verified results.

Completion requires a cleanly scoped diff and recorded command output for the checks that were run.

## Pitfalls

- `--dangerously-skip-permissions` grants broad access. Use only with a trusted, explicit prompt and a disposable or clean worktree when practical.
- The installer may update the user PATH but not the current shell. Use the absolute path or restart the shell.
- Never claim success from the agent's narrative alone; verify files and tests yourself.

## Verification

```text
terminal(command="agy --version", workdir="<workspace>")
terminal(command="git diff --check", workdir="<workspace>")
terminal(command="<project test command>", workdir="<workspace>")
```
