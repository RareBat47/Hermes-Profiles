---
name: strategic-compact
description: Suggests manual context compaction at logical task boundaries to preserve critical context and reduce token waste. Use when a session approaches context limits or transitions between phases.
---

# Strategic Compact Skill

Suggests manual `/compress` or `/compact` at strategic breakpoints in your workflow rather than waiting for emergency auto-compaction.

## When to Compact
- **Research → Planning:** Compact research exploration; keep the distilled plan.
- **Planning → Implementation:** Plan is saved to a file (`SPEC.md`); free up context for writing code.
- **Milestone Complete:** After completing and verifying a feature, compact before starting the next.
- **After Debugging:** Debugging logs and stack traces pollute context for unrelated work.

## When NOT to Compact
- **Mid-Implementation:** Losing variable names, file paths, and partial state mid-edit is costly.

## What Survives Compaction
- Always save key decisions to a markdown file (`CONTEXT.md` or `SPEC.md`) before running `/compress`.
- Code and tests on disk survive 100%.
