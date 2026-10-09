---
name: antigravity-gateway
description: Complete guide for Hermes Agent and worker profiles to utilize the Antigravity Gateway multi-model routing, role keys, and automated account scheduler.
---

# Antigravity Gateway Master Integration Skill

## Purpose
Enables Hermes Agent, sub-agents, and worker profiles to intelligently select, switch, and utilize the 7 dedicated models provided by the local Antigravity Gateway (`http://127.0.0.1:8999/v1`).

## Available Models & Dedicated Roles

| Provider / Role Key | Target Model | Family | Ideal Usage & Intent | Max Output Tokens |
| :--- | :--- | :--- | :--- | :--- |
| `custom:Planning` | `claude-opus-4-6-thinking` | Claude | Deep architectural reasoning, multi-file design, project roadmaps | 16,384 |
| `custom:Coding-1` | `gemini-3.6-flash-medium` | Gemini | High-velocity implementation, general code tasks, primary default | 65,536 |
| `custom:Coding-2` | `gemini-3.7-flash-medium` | Gemini | General coding, fast thinking, secondary fallback | 65,536 |
| `custom:Coding-3` | `gemini-3.8-flash-high` | Gemini | Deep refactoring, complex logic, tertiary fallback | 65,536 |
| `custom:Hybrid-1` | `gemini-3.1-pro-low` | Gemini | Google Pro deep reasoning, algorithmic validation | 8,192 |
| `custom:Hybrid-2` | `claude-sonnet-4-6` | Claude | Code review, independent validation, frontend styling | 16,384 |
| `custom:Debugging` | `gpt-oss-120b-medium` | GPT | Root-cause analysis, complex bug diagnosis, log inspection | 16,384 |

## Switching Models Inside Hermes

### In Interactive REPL / TUI:
```text
/model planning
/model coding-1
/model coding-2
/model coding-3
/model hybrid-1
/model hybrid-2
/model debugging
```

### In CLI Invocations (`hermes -z`):
```bash
# Architecture & Planning
hermes -z "Analyze architecture" --provider Planning --model claude-opus-4-6-thinking

# Deep Refactoring
hermes -z "Refactor database queries" --provider Coding-3 --model gemini-3.8-flash-high

# Root-Cause Debugging
hermes -z "Diagnose bug in logs" --provider Debugging --model gpt-oss-120b-medium
```

## Built-In Fallback Architecture
If the primary model (`Coding-1` / `gemini-3.6-flash-medium`) encounters an upstream rate limit (429) or transient outage (503):
1. Hermes automatically fails over to `Coding-2` (`gemini-3.7-flash-medium`).
2. If still constrained, Hermes fails over to `Coding-3` (`gemini-3.8-flash-high`).
Hermes continues autonomous tool execution without interrupting the session.
