---
name: antigravity-coder
description: Delegate bounded code changes to Antigravity CLI.
version: 1.0.0
author: User, Hermes Agent
license: MIT
platforms: [windows]
metadata:
  hermes:
    tags: [coding, agy, delegation, architecture]
    related_skills: [antigravity-cli, delegate-routing]
---

# Antigravity CLI (`agy`) delegation workflow

Use Antigravity as the implementation worker. The active Hermes profile remains responsible for planning, high-level decisions, and independent verification.

## Non-negotiable rules

1. Always run headlessly with `-p` and `--dangerously-skip-permissions`; never launch the interactive TUI for delegated work.
2. Name exact targets with `@path/to/file` in the prompt; avoid broad repository ingestion.
3. Dispatch one cohesive subtask per call.
4. End every dispatch prompt with an explicit test or build command.
5. After the worker returns, inspect `git diff --stat`, review modified files, and run the same verification independently.
6. If checks fail, pass the actual error output to a bounded follow-up `agy` call.

## Invocation

```text
terminal(command="agy -p "Focus on @path/to/target. Task: <imperative change>. Constraints: <boundaries>. Verification: run '<test/build command>'." --dangerously-skip-permissions", workdir="<target workspace>")
```

## Profile storage

This skill is profile-local. Keep project workspaces, generated artifacts, logs, skills, sessions, memory, and credentials in the active profile's own directory. Do not use another profile's storage unless the master explicitly coordinates a handoff.

## Verification

```text
terminal(command="agy --version")
terminal(command="git diff --stat", workdir="<target workspace>")
terminal(command="git diff --check", workdir="<target workspace>")
terminal(command="<project test/build command>", workdir="<target workspace>")
```
