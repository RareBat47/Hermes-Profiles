---
name: github-migration-recovery
description: "Use when recovering Hermes projects from GitHub."
version: 1.0.0
category: autonomous-ai-agents
---

# GitHub Migration Recovery

Recover a Hermes project/profile from a user's authenticated GitHub account and build an isolated, verifiable local profile around the authoritative migration package.

## Always-on rules

- Treat GitHub as the source of truth when the user asks to find a backed-up project; do not substitute local disk guesses for an account-wide GitHub inventory.
- Use read-only discovery until the authoritative package is identified. Do not push, delete, rename, change visibility, or import state databases without explicit approval.
- Once the authoritative migration package is found, stop speculative searches elsewhere unless the user explicitly requests a broader sweep.
- Do not add cron, monitoring, or heartbeat jobs unless the user explicitly asks for them. Migration profiles are interactive by default.
- Keep the new profile distinct by role, ownership, workspace, model, and description. Never share a profile home, workspace, bot token, memory store, or state database with another active profile.
- Normalize a user-requested uppercase profile name to the lowercase canonical ID required by the live Hermes CLI; preserve the requested name as an alias or display label only when the CLI supports it.
- Never copy secrets, OAuth/browser state, `auth.json`, `.env`, private keys, Windows virtual environments, executables, caches, or `node_modules` into a reconstructed profile.
- Never call an MCP server ready because `mcp list` says enabled. Run `mcp test` and require successful tool discovery.
- Match dependency major versions to the imported project's code. If a project imports `mcp.server.fastmcp`, use a compatible MCP 1.x release rather than silently rewriting project code during profile setup.
- Report `restored`, `recreated`, `missing`, `blocked`, `unverified`, and `requires credentials` separately. Do not collapse those states into “ready.”

## Procedure

1. **Authenticate and inventory GitHub.** Run `gh auth status`. If `gh` is installed but missing from Windows PATH, use its absolute install path. Enumerate all owned repositories with pagination, then inspect gists, organizations, releases, Actions artifacts, branches, tags, forks, and LFS metadata. Mark Packages and Codespaces unverified until the token has the required scopes.
2. **Clone candidates exactly where requested.** Preserve history, tags, remote branches, and LFS objects. For large repositories, a checkout failure may occur after objects were successfully received; inspect the partial clone before retrying.
3. **Identify the authoritative package.** Prioritize roots containing restore prompts, manifests, secret requirements, Hermes memories/skills/state/sessions, project trees, LFS-backed databases, and MCP launchers. Read the package's own validation and sanitization reports.
4. **Classify recoverability.** Distinguish exact profile backup, reconstructable profile, project-only backup, documentation-only backup, and unrelated repository. State credentials and runtime components separately from portable files.
5. **Create the isolated profile.** Use `hermes profile create` with the role description. Set model, provider, and profile-local `terminal.cwd` using `hermes -p NAME config set`; do not hand-edit the active `config.yaml` wholesale.
6. **Provision skills and workspace.** Mirror the home profile's full skill set, add one profile-local migration skill, and create a profile-local workspace. Keep the immutable migration source outside the live profile and expose it through a junction or controlled copy.
7. **Recreate runtimes.** Build fresh profile-owned Python/Node environments from the package manifests. Never copy Windows environments or generated dependency directories.
8. **Wire MCPs.** On Windows, use a profile-owned Python launcher that sets the project root and runs each module. Add each logical server, then use `hermes -p NAME mcp test SERVER`. If the interactive tool-selection prompt cannot be completed reliably, enable the tested server with `hermes -p NAME config set mcp_servers.SERVER.enabled true` and re-test.
9. **Smoke-test the role.** Use a read-only profile chat asking it to identify project roots, MCP count, known damage markers, and credentials requiring re-entry. Keep the smoke test bounded so it does not consume its whole iteration budget exploring unrelated files.
10. **Report and stop at gates.** Do not import Hermes state/session databases or repair damaged indexes as part of profile creation. Those are separate compatibility/repair operations requiring rollback copies and explicit approval.

## Reference

- `references/recovery-matrix.md` contains the backup classification, large-repository recovery checks, and Windows MCP compatibility recipes.
