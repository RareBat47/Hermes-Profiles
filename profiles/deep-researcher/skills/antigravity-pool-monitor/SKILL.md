---
name: antigravity-pool-monitor
description: Check live Antigravity Gateway health, account rotation pool, quotas, and cooldowns.
---

# Antigravity Pool Monitor Skill

## Purpose
Allows Hermes Agent to inspect the health of the 6-account Google pool, track token consumption, and monitor active rate-limit cooldowns.

## Health Check
```bash
curl -s http://127.0.0.1:8999/health
```
Expected response:
```json
{"status": "ok", "active_accounts": 6, "total_accounts": 6, "total_requests": 200}
```

## Pool Usage & Metrics (Admin Key)
```bash
curl -s -H "Authorization: Bearer agw-admin-super-secret-key-change-me" http://127.0.0.1:8999/admin/usage
```

## Account Status Inspection
```bash
curl -s -H "Authorization: Bearer agw-admin-super-secret-key-change-me" http://127.0.0.1:8999/admin/accounts
```

## Active Cooldowns
```bash
curl -s -H "Authorization: Bearer agw-admin-super-secret-key-change-me" http://127.0.0.1:8999/admin/cooldowns
```
