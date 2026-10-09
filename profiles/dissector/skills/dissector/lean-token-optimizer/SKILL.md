---
name: lean-token-optimizer
description: Use when executing multi-step development tasks, reading large files, or running heavy searches to minimize token consumption by 70%+.
---

# Lean Token Optimizer (Hermes Native Token Conservation)

Master techniques to slash token usage during engineering sprints:

## 1. Paged File Reads over Full Dumps
- NEVER read a 2,000-line file in one shot if you only need a 50-line function.
- Use `read_file(path, offset=X, limit=Y)` to inspect only the targeted section.
- Use `search_files(pattern=...)` with output_mode='files_only' or bounded context first.

## 2. Execute Code Tool Consolidation
- Instead of making 5 separate tool calls (which cost 5 full LLM input/output round-trips), use `execute_code` to run Python scripts that inspect, filter, and process data locally.
- Intermediate results remain in the Python interpreter and consume ZERO LLM tokens.
- Return only the final filtered summary to stdout.

## 3. Subagent Context Offloading (`delegate_task`)
- If you need to search 50 files or analyze massive compiler logs, spawn a subagent via `delegate_task`.
- The subagent absorbs the thousands of tokens of raw code in its own isolated context.
- The subagent terminates and returns only a 10-line executive verdict to the Lead Architect, saving 90%+ of the master context window.

## 4. Truncate Terminal Noise
- Filter terminal commands before printing: use `head`, `tail`, or grep flags.
- Do not dump 10,000 lines of test runner logs into prompt context.
