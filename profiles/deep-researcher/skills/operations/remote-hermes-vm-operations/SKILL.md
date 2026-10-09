---
name: remote-hermes-vm-operations
description: Operate and reconfigure remote Hermes SRE VMs safely.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [linux, windows]
metadata:
  hermes:
    tags: [hermes, ssh, azure, vm, sre, reset, telegram]
    related_skills: []
---

# Remote Hermes VM Operations

Use this class-level workflow for SSH access, Hermes lifecycle changes, full resets, reconfiguration, and Telegram-only gateway deployments on remote Linux VMs. Keep the operator-facing result concise: report what changed, what was verified, and what remains; do not replay the command transcript.

## Standing Rules

- Confirm the target host, SSH user, key path, and destructive scope before connecting or deleting state.
- Treat a request to keep one integration as an allowlist: disable or omit every other connector.
- Inspect before changing: locate the Hermes launcher, version, state directories, services, and project units.
- Never assume the project described by a brief exists; verify paths, units, ports, and endpoints on the VM.
- Do not claim a service or proxy is installed unless a direct command verifies its files and runtime state.
- Keep secrets out of terminal output and reports. Never request bot tokens, API keys, or private keys in chat.
- After destructive work, reinstall or reconfigure only the components requested, then run an independent verification command.
- Create or update reusable operational skills only at class level; put optional domain depth in topical references, not incident files.

## Procedure

### 1. Establish the SSH baseline

Use the supplied private key without copying it into the VM. Connect with strict host-key handling appropriate to the first connection and a bounded timeout. Record only redacted facts: remote user, home directory, OS, Hermes launcher path/version, Hermes home, and relevant service states.

Completion criterion: the connection succeeds and the target identity is verified before any mutation.

### 2. Inventory before reset

Check Hermes state locations, user/system service units, project directories, and gateway status. Inspect help output for the installed version before selecting reset or setup commands; CLI flags differ across releases.

Completion criterion: the deletion boundary and the exact available lifecycle commands are known.

### 3. Apply a full reset safely

Use the product's supported full-uninstall command when available, with an explicit noninteractive confirmation only after the user has authorized full deletion. Verify Hermes home, launchers, gateway units, and installation directories are removed. Do not confuse an absent project service with a failed Hermes reset.

Completion criterion: every requested state category is gone or a remaining artifact is named explicitly.

### 4. Reinstall the minimum requested system

Use the official installer or documented package path. Let installation finish, then verify the executable, version, configuration skeleton, and skill directory. Avoid enabling optional connectors, services, browser components, or providers unless the deployment needs them.

Completion criterion: the new installation runs a health/doctor check and any warnings are separated from blockers.

### 5. Configure the connector as an allowlist

For a Telegram-only deployment, configure Telegram and no other messaging platform. Supply secrets through the VM's secure interactive setup or secret file; do not put them in prompts, skill files, shell history, or reports. Restrict allowed users and install the gateway only after the model/provider configuration is viable.

See `references/telegram-hermes.md` for the connector-specific checklist.

Completion criterion: gateway status reports Telegram as configured and active, with no unintended connectors enabled.

### 6. Install project-specific operational knowledge

If the user requests a skill for the deployment, create a reusable class-level skill with always-on safety rules and link topical references. Copy it to the remote profile only after validating its frontmatter and content locally. Verify the remote file exists and is nonempty; do not rely on a skill-list command that may omit user-local entries.

Completion criterion: the skill path, frontmatter, and remote file verification are confirmed.

### 7. Verify and report

Run independent checks for Hermes version, doctor/status, connector status, and any separately requested proxy/watchdog endpoints. Distinguish installed-but-unconfigured, configured-but-inactive, absent, and healthy. Report only verified results and remaining operator inputs.

Completion criterion: the final report has three parts—changed, verified, remaining—and contains no secret values.

## Pitfalls

- Inspect the installed CLI help before scripting setup because a command available in one Hermes release may not exist or may use different flags in another.
- Verify the project directory and systemd units independently because a clean Hermes install does not install an unrelated application gateway.
- Do not treat optional-package warnings as Telegram failure; confirm connector configuration and gateway status separately.
- Do not use a generic multi-platform project brief as permission to enable Discord, Slack, or other integrations when the operator requested Telegram only.
- Do not call a reset complete from the uninstall output alone; check the expected state paths and launchers after the command returns.
- Do not make an unresolved setup attempt into a skill recipe; capture only commands and paths that actually completed successfully.

## Verification Checklist

- [ ] SSH target and identity verified.
- [ ] Pre-reset state inventoried without exposing secrets.
- [ ] Authorized reset completed and post-reset paths checked.
- [ ] Official reinstall completed and version verified.
- [ ] Telegram-only configuration boundary preserved.
- [ ] Project-specific skill installed and file-checked remotely.
- [ ] Hermes health/status checked independently.
- [ ] Missing credentials or absent project services reported as remaining work.
