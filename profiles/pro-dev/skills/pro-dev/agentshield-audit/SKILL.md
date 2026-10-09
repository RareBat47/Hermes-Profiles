---
name: agentshield-audit
description: Use when auditing codebases, hooks, MCP configs, and agent files for security vulnerabilities.
---

# AgentShield Security Audit

Static analysis and guardrails based on the AgentShield 268-rule specification.

## Audit Checklist
1. **Secrets Scanner:**
   - Check for hardcoded API keys (sk-ant, sk-proj, AIza, Stripe, AWS keys, JWTs).
   - Ensure environment variables are used for all secrets.
2. **Permission Guard:**
   - Block dangerous shell execution (destructive commands, unvalidated scripts).
   - Verify deny-lists are present in configuration.
3. **Hook & MCP Safety:**
   - Audit hook command interpolations for shell injection risks.
   - Verify MCP server transports and package pins.
4. **Execution:**
   - Run npx ecc-agentshield scan --path . or custom regex audit.
