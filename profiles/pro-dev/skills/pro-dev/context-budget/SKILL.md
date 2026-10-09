---
name: context-budget
description: Audits context window token consumption across tools, loaded skills, file contents, and history. Use when sessions feel sluggish or token usage needs to be reduced.
---

# Context Budget

Analyze and control token consumption across loaded components and conversation turns.

## Token Consumption Tiers
1. **Conversation History:** Grows linearly with every turn. Run `/compress` or `/new` between distinct milestones.
2. **Tool Output Payloads:** Large file reads (`cat`, full-file reads) and large terminal logs are the #1 source of sudden context exhaustion.
3. **Loaded Skills:** Keep descriptions concise. Hermes uses procedural loading so skills only load when triggered.

## Best Practices
- Keep turn outputs concise.
- Summarize findings rather than replaying raw tool output.
- Check token usage periodically with `/usage` or `/cost`.
