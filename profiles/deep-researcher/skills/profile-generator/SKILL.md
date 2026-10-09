---
name: profile-generator
description: "Use when building Hermes profiles from reference repos."
version: 1.0.0
category: autonomous-ai-agents
---

# Profile Generator

Design and install Hermes profiles purpose-built for a project. Combines official
Hermes profile/distribution mechanics with proven patterns from community agent
repos (see references/sources.md) and the distinctness rules proven on this
machine's own worker fleet (architect-worker, code-runner, qa-devops).

## When to use

- "Create a profile for <project/need>" (new worker, specialist, research bot, etc.)
- Adding a worker to the multi-profile roster
- Converting an existing profile into a shareable distribution

## Phase 1 — Intake (before any tool call)

Answer these from the user or project files; ask only what changes the design:

1. **Purpose**: what tasks will this profile own, end to end?
2. **Deliverables**: what artifacts does it produce (reports, code, configs, alerts)?
3. **Model + provider**: which of the user's available models (default is their
   `z-ai/glm-5.3` via custom provider — same as existing workers — unless told otherwise).
4. **Toolsets**: which tools does it actually need? Start from the role's verbs
   (research → search+extract; coding → terminal+file; monitoring → cron+webhooks).
5. **Cadence**: interactive on demand, or cron/heartbeat-driven?
6. **Name**: 2-3 word kebab-case that states the ROLE, not the project
   (e.g. `market-researcher`, not `myproject-helper`).

## Phase 2 — Collision check (mandatory)

Before designing, run:

```bash
hermes profile list
for each existing worker: hermes profile describe <p> (or read
  $LOCALAPPDATA/hermes/profiles/<p>/profile.yaml and SOUL.md)
```

Then verify the new profile is distinct on ALL axes:

| Axis | Rule |
|---|---|
| Name | No prefix/substring collision with existing profile names |
| Ownership domain | Its SOUL "Owns …" list shares no verb+object pair with another profile's list |
| Description | Kanban-router-readable, starts with a role word no other profile uses |
| Workspace | `terminal.cwd` points INSIDE its own profile dir; never a shared path |
| Skills | Only what the role needs; note overlaps explicitly as accepted or resolved |
| Gateway/bot tokens | New profile gets its own; never copy tokens between profiles |

The fleet pattern that keeps this machine's workers distinct (from
architect-worker / code-runner / qa-devops):

1. **Shared discipline preamble** — every worker SOUL.md opens with the same
   operating discipline, THEN a role-specific ownership sentence: "You are X.
   Follow the shared Hermes operating discipline. Own <A>, <B>, <C>."
2. **Single-owner rule** — every responsibility is owned by exactly one profile.
   If two profiles both mention a task, split it by phase (design vs implement
   vs verify) and rewrite both SOULs so each owns its phase only.
3. **No cross-talk clause** — "do not communicate with other profiles unless the
   master explicitly orchestrates it" appears in every worker SOUL.
4. **Isolation by construction** — own workspace/, skills/, sessions/, memory/;
   the only coordination channel is the master profile via `hermes -p <name>`.
5. **Routing description** — `--description` is a routing key, one or two
   sentences, written so the kanban decomposer can pick this worker by role.

## Phase 3 — Mine reference patterns

Consult references/sources.md. Quick map:

| Need | Source to mine |
|---|---|
| Research/investigation roles | JamesFincher/hermes-agents research-bot (SOUL: evidence discipline, anti-hallucination, primary sources) |
| Focused/minimal toolset profile | teknium1/hermes-starter-profile (`disabled_toolsets` + `platform_toolsets` pinning) |
| Domain-specialist SOPs (214 personas, 34 categories) | TravisLeeeeee/awesome-openclaw-personas (SOUL=identity/values, AGENTS=process/boundaries, SKILL=deliverable templates) |
| Composable personality attributes | shiro-0x/hersona |
| cTrader platform specialist | spotware/ctrader-skills (official CLI + MCP skills and precision helper scripts) |
| Quant research loop | alexmihalache/cursor_domain_agent (CLI-first harness, data/leakage gates, experiment registry) |
| Official format spec | NousResearch/hermes-agent docs: profile-distributions, profiles | 

For platform-specific profiles, inspect the official vendor repository first. Copy
or adapt its documented skills and helper scripts only after checking license,
prerequisites, version/build stamps, and destructive-operation boundaries. Keep
third-party skills profile-local unless the user explicitly requests global
installation. Separate platform access from research execution: e.g. cTrader CLI
for builds/backtests/optimization, local MCP for charts/UI, and Open API only when
those are insufficient.

Write the SOUL.md from the role's *evidence rules and boundaries*, not generic
personality prose. Best structure (stolen from research-bot + OpenClaw):

```markdown
# <Role Name>

You are <one-sentence identity>. <Shared discipline preamble if worker fleet.>

## Ownership
Own <verbs + objects>. <What this profile explicitly does NOT do — the
neighboring profile's job.>

## Method
<3-6 process steps as rules — how it approaches any task.>

## Boundaries
- <Hard exclusions, anti-hallucination rules, escalation triggers.>
- Do not communicate with other profiles unless the master orchestrates it.

## Defaults
<Output formats, citation rules, verification commands.>
```

## Phase 4 — Create and configure

```bash
hermes profile create <name> --description "<routing description>"
# Then write files (never hand-edit config.yaml wholesale — use hermes config set
# for single keys; file writes via write_file are fine for SOUL.md):
#   $LOCALAPPDATA/hermes/profiles/<name>/SOUL.md
#   $LOCALAPPDATA/hermes/profiles/<name>/profile.yaml  (description fields)
# config.yaml: set model (usually z-ai/glm-5.3 / provider custom / base_url
#   https://api.xkiro.com/v1 / api_key ${HERMES_CUSTOM_API_XKIRO_COM_API_KEY})
#   and terminal.cwd to the profile's own workspace. Copy an existing worker's
#   config.yaml as the base when the role is similar, then change cwd + toolsets.
# Toolset tuning: hermes -p <name> tools list / config set agent.disabled_toolsets
```

### Skill provisioning (mandatory — user requirement)

Every new profile MUST carry the default (home) profile's full skills set. After
`profile create`, mirror the home skills into the new profile:

```bash
# Copy any home skill dirs missing from the new profile
for s in "$LOCALAPPDATA/hermes/skills"/*/; do
  name=$(basename "$s")
  cp -r "$s" "$LOCALAPPDATA/hermes/profiles/<name>/skills/$name"
done
# Verify: skill dir names match $LOCALAPPDATA/hermes/skills exactly
```

Do the same for EXISTING profiles whenever a new custom skill lands in the home
profile — the fleet must not drift. Roles differ by SOUL ownership and toolsets,
NOT by skill availability. (Bundled skills re-seed on `hermes update` anyway;
this step covers the custom additions like profile-generator.)

Optional extras per role: cron jobs (`hermes -p <name> cron create …`), MCP
servers (`mcp.json`), profile-local skills under its `skills/` directory.

## Phase 5 — Verify (never skip)

```bash
hermes profile list                  # name, model, alias present, no dup
hermes profile show <name>           # SOUL.md exists, model correct
hermes -p <name> config get terminal.cwd  # must be profile-local
hermes -p <name> chat -q '<smoke test matching its role>'   # responds in-role
```

If the profile depends on external tools, perform a read-only environment audit
before claiming readiness. Report installed, missing, and unverified components
separately. A created profile is not a ready profile when its required CLI/MCP
runtime is missing. If an implementation delegate (such as `agy`) is unavailable
or unauthenticated, record the blocker and use a bounded fallback only for
profile text/configuration; never claim delegated implementation was executed.
A "✓ enabled" line in `mcp list` is configuration, not connectivity — always
re-probe the actual endpoint (`curl --max-time 3`) before claiming the runtime
is connected.

Re-run the Phase-2 collision table against the FULL fleet including the new
profile; fix any overlap before reporting done.

## Phase 6 — Optional: publish as distribution

If the profile should be shareable/versioned, add `distribution.yaml` + the
standard `.gitignore` (secrets/user-data exclusions — see references/sources.md
for the exact list), git init, tag v1.0.0, push; install elsewhere with
`hermes profile install <url> --alias`. Keep `distribution_owned` explicit.

## Rules

- Never put credentials in config.yaml — API keys resolve via `${ENV_VAR}` from `.env`.
- Never copy bot tokens between profiles; never run two agents on one profile home.
- A new profile's memory starts EMPTY by design — do not clone memories unless
  the user explicitly asks (`--clone`).
- `profile.yaml` description = routing key; SOUL.md = identity + rules; config.yaml = machine.
- Hermes normalizes profile names to lowercase on disk (`puter-LOOP` → `profiles/puter-loop/`, alias `puter-loop`). Design names and collision checks in lowercase; mixed-case names survive creation but resolve lowercase everywhere.
