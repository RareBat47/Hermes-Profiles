# Telegram-Only Hermes Deployment

Use this reference only when the remote deployment must expose Telegram and no other messaging connector.

## Checklist

1. Confirm a viable Hermes model/provider before debugging messaging.
2. Run the version-appropriate Telegram gateway setup from the remote VM.
3. Store `TELEGRAM_BOT_TOKEN` and the allowed operator user ID in the VM's secure configuration path, never in chat or a committed skill.
4. Review the generated configuration for enabled platforms by names only; redact values.
5. Install the gateway service using the installed Hermes CLI.
6. Check gateway status and service logs.
7. Send a real operator test message only after the service is active.

## Decision Table

| Observation | Meaning | Next action |
|---|---|---|
| Telegram credentials absent | Not configured | Obtain them through secure setup; do not ask for them in chat |
| Telegram configured, service inactive | Configuration exists but is not running | Inspect status/logs, then start once |
| Service active, no response | Connector, network, allowlist, or model issue | Separate gateway logs from model/provider health |
| Telegram works, proxy fails | Messaging layer is healthy; application layer is not | Inspect the proxy independently |
| Other connector appears enabled | Allowlist violation | Disable it and re-check effective configuration |

## Safety

- Never print or copy the bot token.
- Never broaden allowed users as a debugging shortcut.
- Never infer Telegram health from Hermes installation success alone.
- Keep provider/model failures separate from transport and authorization failures.
