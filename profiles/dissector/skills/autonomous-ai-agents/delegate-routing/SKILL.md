---
name: delegate-routing
description: Route bounded work to the right coding agent.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [delegation, orchestration, coding-agents]
    related_skills: [hermes-agent, antigravity-cli, claude-code, codex]
---

# Delegate routing

Choose an execution harness by task shape, keep each workspace isolated when agents edit code, and verify all delegated claims in the parent session.

## Routing rules

- Use `delegate_task` for short independent reasoning or review subtasks.
- Use Antigravity CLI for an explicitly requested `agy` headless coding run.
- Use Claude Code print mode for bounded coding tasks with explicit tool limits.
- Use Codex with a git repository and `workspace-write` sandbox for OpenAI CLI work.
- Use Hermes Kanban for durable multi-profile queues and handoffs.

## Procedure

1. State the task, workspace, allowed files, acceptance criteria, and verification command.
2. Choose one harness and set its explicit `workdir`.
3. Avoid concurrent edits to the same files unless using isolated worktrees.
4. Inspect the diff and rerun tests after the harness returns.
5. Report the harness result separately from verified facts.

## Verification

Every delegated coding task needs a diff review, `git diff --check`, and the most relevant focused tests before completion.
