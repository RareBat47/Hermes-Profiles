---
name: antigravity-status
description: Checks the high-level status of the Antigravity Multi-Account Gateway, including system health, active account count, and recent traffic.
---

# Antigravity Status Skill

## Purpose
Enables Hermes Agent to check the operational status of the Antigravity Gateway, verify whether the gateway is online and responding, and view how many accounts are actively serving requests.

## When to Use It
- At the start of an agent session or workflow to ensure model backend connectivity.
- When experiencing unexpected model timeouts or errors to confirm if the gateway is running.
- To verify traffic stats and active account capacity.

## Commands and API Calls

### HTTP API Check
```bash
curl -s -H "Authorization: Bearer $GATEWAY_API_KEY" http://127.0.0.1:8999/health
```

### CLI Check
```bash
agw health
```

## Expected Output

```json
{
  "status": "ok",
  "active_accounts": 3,
  "total_accounts": 3,
  "total_requests": 1420
}
```

## Failure Handling
- **Connection Refused (`curl: (7) Failed to connect`)**:
  - The gateway process is not running. Check service status via `sudo systemctl status antigravity-gateway` or start it manually with `uvicorn agw.main:app`.
- **HTTP 401 Unauthorized**:
  - Verify that `GATEWAY_API_KEY` matches the key configured in the gateway's `.env` or `config.yaml`.
- **active_accounts == 0**:
  - All accounts may be disabled or cooling down. Inspect with `agw accounts list` and `agw health`.

## Security Considerations
- The public `/health` endpoint exposes no sensitive account identifiers, credentials, or project IDs.
- Never log raw API keys or tokens.
