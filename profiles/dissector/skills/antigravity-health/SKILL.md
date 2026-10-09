---
name: antigravity-health
description: Monitors latency, failure rates, consecutive errors, and overall reliability metrics of the gateway and account pool.
---

# Antigravity Health Skill

## Purpose
Provides deep diagnostics into gateway reliability, account latency trends, success/failure counts, and active cooldown states.

## When to Use It
- When diagnosing slow response times or sporadic errors.
- Before running critical agent jobs to verify system stability.
- To detect if an account is degraded or needs re-authentication.

## Commands and API Calls

### Admin Health Diagnostic
```bash
curl -s -H "Authorization: Bearer $ADMIN_API_KEY" http://127.0.0.1:8999/admin/health
```

### CLI Health Diagnostic
```bash
agw health
```

## Expected Response
```json
{
  "status": "healthy",
  "active_accounts": 2,
  "total_accounts": 3,
  "active_cooldowns_count": 1,
  "accounts": [
    {
      "account_id": "acc-a1b2c3d4",
      "display_name": "Personal Pro",
      "status": "active",
      "enabled": true,
      "health_score": 98.5,
      "avg_latency_ms": 1240.2,
      "total_requests": 840
    },
    {
      "account_id": "acc-e5f6g7h8",
      "display_name": "Backup Account",
      "status": "active",
      "enabled": true,
      "health_score": 60.0,
      "avg_latency_ms": 3410.0,
      "total_requests": 110
    }
  ]
}
```

## Interpreting Health Scores
- **90% - 100%**: Optimal health; account will be favored by scheduler.
- **70% - 89%**: Minor transient failures; will still receive traffic with lower weight.
- **Below 50%**: Degraded; scheduler will prefer other accounts unless all accounts are stressed.
