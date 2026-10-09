---
name: autonomous-cloud-ai-proxy-project
description: Use for authorized cloud AI gateway SRE work.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [linux, windows]
metadata:
  hermes:
    tags: [azure, ai-gateway, sre, fastify, telegram, nginx, privoxy]
    related_skills: [github, systematic-debugging, test-driven-development, verification-before-completion]
---

# Autonomous Cloud AI Proxy Project

Use this skill for the authorized, reproducible Azure deployment of the OpenAI-compatible gateway and its Hermes SRE operator. Keep GitHub as the source of truth; keep credentials and runtime state outside Git. Telegram is the only messaging integration unless the user explicitly changes that decision.

## Scope and safety

- Operate only accounts, tokens, proxies, and infrastructure the user is authorized to control.
- Do not design features intended to evade provider limits, bans, identity checks, or terms of service.
- Never print or commit API keys, bearer tokens, Puter credentials, SSH keys, Telegram tokens, or full secret-bearing environment files.
- Preserve a fixed inbound address or DNS name. Treat outbound proxy rotation as a separate, explicit egress concern.
- Do not schedule autonomous implementation until the architecture, repository boundary, secrets workflow, and acceptance tests are approved.

## Architecture decisions

- Edge: Nginx terminates TLS and authenticates the master bearer key; internal gateway and Privoxy bind to loopback or a private interface.
- Gateway: TypeScript/Fastify OpenAI-compatible API with strict schemas, structured errors, streaming, request IDs, and bounded upstream timeouts.
- Credential pool: explicit state machine with atomic reload, redacted metrics, cooldown timers, and persistence only if required by the approved design.
- Egress: use an explicit Undici dispatcher/ProxyAgent or equivalent; do not assume Node honors `HTTP_PROXY` automatically. Fail closed when a required proxy is unavailable.
- Reliability: let systemd handle process restart and resource limits; make the watchdog least-privilege and avoid `sudo` loops from application code.
- Messaging: Telegram-only operator alerts and commands, restricted to approved user IDs.

## Required design corrections

1. Do not promise transparent mid-stream failover after bytes reach the client. Failover is possible only before the first committed response bytes; after commitment, return a correct stream error and record the upstream failure.
2. Do not call a rotating VM public IP a DNS solution. Prefer a static inbound IP plus DNS, or a Cloudflare Tunnel where its operational trade-offs are accepted.
3. Verify the actual upstream Puter RPC contract before implementing an adapter. Add contract fixtures and integration tests without storing live credentials.
4. Define token schema, identity fields, status transitions, cooldowns, atomic file replacement, and redacted observability before coding.
5. Treat the admin reload route as a separate secret and enforce constant-time authentication, body limits, audit logging, and rate limits.
6. Add systemd hardening, non-root service users, `NoNewPrivileges`, filesystem protections, resource limits, and explicit log rotation.
7. Test streaming, tools, malformed requests, upstream 401/402/429/5xx, timeout, proxy failure, reload races, and graceful shutdown.

## Delivery workflow

1. Inspect the repository and VM without changing state; record versions, services, ports, and existing files.
2. Brainstorm and approve the architecture; decompose into independently verifiable gateway, provisioning, watchdog, Telegram, and client-configuration phases.
3. Write a committed design/spec and implementation plan before coding.
4. Implement in a branch with tests first. Keep each commit focused and reproducible.
5. Run focused tests, build, static checks, secret scanning, and a clean-install smoke test before deployment.
6. Deploy from a pinned Git revision. Render secrets at deployment time; never pull `.env`, tokens, or private keys from Git.
7. Verify locally, through Nginx, and from an external client. Capture rollback commands and service logs.
8. Schedule overnight automation only after the plan is approved and the job has bounded scope, timeout, logging, and a stop/rollback path.

## Acceptance checks

- A clean VM can be rebuilt from the repository and documented commands.
- Internal ports 3800 and 8050 are not publicly reachable.
- Nginx TLS/authentication and streaming behavior work from an external client.
- `/v1/models` and chat completions return schema-valid responses.
- Reload is authenticated, atomic, observable, and does not interrupt in-flight requests.
- Upstream failures map to correct client errors without leaking secrets.
- Privoxy or the approved egress mechanism is verified independently and fails closed.
- The watchdog produces redacted Telegram alerts and does not create restart storms.
- `git grep`/secret scanning finds no credentials, and the deployment uses a pinned revision.

## Operational commands

Use Hermes `terminal`, `read_file`, `search_files`, `patch`, and `write_file` tools for repository work. Use `hermes config set` for Hermes settings. Use `systemctl`, `journalctl`, `curl`, and project scripts through `terminal` on the VM. Verify every claimed change with fresh command output before reporting it complete.
