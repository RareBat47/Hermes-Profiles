---
name: antigravity-quota
description: Inspects live quota and reset times for Gemini and Claude models across all registered Antigravity accounts.
---

# Antigravity Quota Skill

## Purpose
Allows Hermes Agent to inspect real-time remaining quota percentages, quota windows, and reset timestamps for both Gemini and Claude model families across all connected Google accounts.

## When to Use It
- "Which models have usable quota?"
- Before launching intensive reasoning or batch workflows that consume high token counts.
- When selecting between `gemini-3.5-flash` vs `claude-sonnet-4-6` based on quota headroom.
- When an account receives a rate-limit warning to find out when quota resets.

## Commands and API Calls

### Read Generated Status Markdown
```bash
cat docs/account-status.md
```

### Read JSON Quota State
```bash
cat data/quota-state.json
```

### Query Live Account Quota via Admin API
```bash
curl -s -H "Authorization: Bearer $ADMIN_API_KEY" http://127.0.0.1:8999/admin/accounts/{account_id}/quota
```

### CLI Command
```bash
agw quota
agw quota --account acc-a1b2c3d4
```

## Expected Output

From `docs/account-status.md`:
```markdown
# Antigravity Account Status

Updated: 2026-09-20 01:20 UTC

| Account | Gemini | Claude | Status | Cooldown |
| :--- | :---: | :---: | :--- | :--- |
| Personal Pro | 85% | 72% | healthy | none |
| Work Primary | 42% | 91% | healthy | none |
| Backup Account | 98% | 15% | healthy | none |
```

## Failure Handling
- **Quota status shows `unknown`**:
  - The upstream provider did not return quota fields for this model, or the account is brand-new. The gateway automatically uses token buckets and LRU scheduling when quota fraction is unknown.
- **Quota is 0%**:
  - Check `reset_time` in the quota JSON. The gateway will automatically avoid routing requests to this account for this model family until reset.

## Security Considerations
- Quota reports never expose raw OAuth refresh tokens or full plaintext Google email addresses.
- Accessing `/admin/accounts/{id}/quota` requires `ADMIN_API_KEY`.
