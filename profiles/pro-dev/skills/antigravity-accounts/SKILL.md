---
name: antigravity-accounts
description: Inspects, registers, enables, disables, and refreshes Google Antigravity accounts in the gateway registry.
---

# Antigravity Accounts Skill

## Purpose
Provides Hermes Agent with operational commands to query registered accounts, inspect account health, add new accounts, disable degraded/failing accounts, and force credential refresh.

## When to Use It
- "Which accounts exist in the pool?"
- "Which accounts are healthy?"
- "How do I add a new Google account?"
- "How do I disable a broken or rate-limited account?"
- When credentials need re-authentication or proactive token refresh.

## Commands and API Calls

### List All Accounts
```bash
curl -s -H "Authorization: Bearer $ADMIN_API_KEY" http://127.0.0.1:8999/admin/accounts
```
Or via CLI:
```bash
agw accounts list
```

### Add New Account (OAuth Browser Flow)
```bash
agw accounts login
```

### Add New Account (Via Refresh Token)
```bash
curl -s -X POST -H "Authorization: Bearer $ADMIN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"refresh_token": "1//04...", "label": "Account-3", "display_name": "Pro Tier 3"}' \
  http://127.0.0.1:8999/admin/accounts
```

### Disable a Failing Account
```bash
curl -s -X POST -H "Authorization: Bearer $ADMIN_API_KEY" \
  http://127.0.0.1:8999/admin/accounts/{account_id}/disable
```
Or CLI:
```bash
agw accounts disable {account_id}
```

### Enable an Account
```bash
curl -s -X POST -H "Authorization: Bearer $ADMIN_API_KEY" \
  http://127.0.0.1:8999/admin/accounts/{account_id}/enable
```
Or CLI:
```bash
agw accounts enable {account_id}
```

### Force Token Refresh
```bash
agw accounts refresh {account_id}
```

## Expected Output
```json
[
  {
    "id": "acc-a1b2c3d4",
    "email_safe": "use***@gmail.com",
    "display_name": "Personal Pro",
    "tier": "pro",
    "status": "active",
    "enabled": true,
    "has_credentials": true,
    "total_requests": 342,
    "total_tokens": 1289400
  }
]
```

## Security Considerations
- Refresh tokens are stored strictly encrypted inside `data/vault.enc` using AES-256 Fernet.
- Never display or pipe raw refresh tokens to unauthenticated surfaces or public chat channels.
