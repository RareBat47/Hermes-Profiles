---
name: local-ai-proxy
description: Use when setting up or managing a local AI proxy gateway.
version: 1.1.0
category: devops
metadata:
  hermes:
    tags: [litellm, omniroute, ai-gateway, proxy, local-development, model-routing, openai-compatible]
    related_skills: [hermes-profile-provider-config, autonomous-cloud-ai-proxy-project]
---

# Local AI Proxy Gateway

Use this skill when provisioning, configuring, operating, or troubleshooting a local OpenAI-compatible proxy server (LiteLLM Proxy or OmniRoute) to centralize upstream model access across a workstation for IDEs, coding agents, and terminal CLIs.

## Core Rules

1. **Isolate the proxy environment:** Always install proxy packages in a dedicated environment (`uv venv` for LiteLLM, or isolated node tools directory for OmniRoute). Never install proxy dependencies into the agent's or global system Python environment.
2. **Decouple credentials from config:** Never hardcode upstream or master API keys inside repo configs. Use environment variable interpolation (`os.environ/<VAR_NAME>`) or encrypted storage (`STORAGE_ENCRYPTION_KEY`).
3. **Guard against proprietary tool parameters:** Drop vendor-specific parameters so IDE extensions (Cursor, Cline, Copilot) passing vendor flags do not trigger upstream validation failures.
4. **Verify through every layer before reporting:** Check process initialization log, database registration, `/v1/models` catalog reflection, and an end-to-end routing/completion probe.

---

## OmniRoute Local Gateway Operations

OmniRoute runs locally as a Node.js/Next.js gateway (default port `20128`), serving both a management dashboard and an OpenAI-compatible `/v1/*` inference endpoint backed by SQLite (`~/.omniroute/storage.sqlite`).

### 1. Web-Cookie Session Providers (e.g., Gemini Web)
- **Required Credentials:** `__Secure-1PSID` (main session cookie) and optional timestamped `__Secure-1PSIDTS`.
- **Extraction:** From browser DevTools → Application → Storage → Cookies → `gemini.google.com`.
- **Format:** `__Secure-1PSID=<psid_value>; __Secure-1PSIDTS=<psidts_value>`.
- **CLI Auth Bypasses:** When the OmniRoute dashboard requires login, loopback CLI commands (`omniroute providers add`) fail with HTTP 401 if internal peer-stamp headers are missing. Perform programmatic admin operations using Node.js with tsx:
  ```bash
  node --input-type=module --import "file:///<node_modules>/tsx/dist/esm/index.mjs" -e '...'
  ```
  Ensure `process.env.DATA_DIR = "C:/Users/<user>/.omniroute"` and `STORAGE_ENCRYPTION_KEY` are passed so encrypted fields (`api_key`) decode correctly.

### 2. Handling Account Deduplication
- OmniRoute's `findExistingCookieConnection` runs credential deduplication (`webSessionCredentialKey`). If identical cookies are submitted under different connection names, OmniRoute updates the existing connection row rather than creating a duplicate slot.
- To maintain distinct slots or force multiple entries for equivalent accounts, insert records directly into `provider_connections` using `encryptConnectionFields(conn)` from `@/lib/db/encryption` and bust cache with `invalidateDbCache("connections")`.

### 3. Unifying Multiple Accounts into a Single Model API (Combos)
To present multiple account connections as a single unified OpenAI-compatible model with load-balancing:
1. Create a **Combo** (`@/lib/db/combos` `createCombo` or `omniroute combo create <name> --strategy round-robin`):
   - Map each account as a step:
     ```json
     {
       "kind": "model",
       "model": "<provider>/<model-id>",
       "providerId": "<provider>",
       "connectionId": "<connection-uuid>",
       "accountPinned": true
     }
     ```
   - Strategies available: `"round-robin"`, `"priority"`, `"least-used"`.
2. Activate the combo: `omniroute combo switch <name>`.
3. The combo name appears directly as an available model in `/v1/models` and `/v1/chat/completions`.

### 4. Client API Key Provisioning
- When inference access requires an API key, create client keys in `api_keys` table using `createApiKey(name, machineId, scopes)` from `@/lib/db/apiKeys` with `API_KEY_SECRET`.
- Point IDEs/clients (Cursor, Cline, OpenAI SDK) to:
  - Base URL: `http://localhost:20128/v1`
  - API Key: `sk-local-...`
  - Model: `<combo-name>` (e.g. `gemini-web`)

---

## LiteLLM Proxy Gateway Operations

### 1. Provision a Dedicated Working Directory & Environment

```bash
mkdir -p "$HOME/litellm-proxy"
cd "$HOME/litellm-proxy"
uv venv --python 3.12
uv pip install "litellm[proxy]"
```

### 2. Configure Model Mapping and Secrets

Create `config.yaml`:
```yaml
model_list:
  - model_name: <local-alias>
    litellm_params:
      model: openai/<upstream-model-id>
      api_base: https://<upstream-host>/v1
      api_key: os.environ/UPSTREAM_API_KEY

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY

litellm_settings:
  drop_params: true
```

Create `.env`:
```env
UPSTREAM_API_KEY=your_actual_key_here
LITELLM_MASTER_KEY=sk-local-master-key-1234
```

### 3. Multi-Stage Verification
1. **Startup Logs:** Confirm model registration lines appear in stdout.
2. **Model Catalog:** `curl -s http://localhost:4000/v1/models -H "Authorization: Bearer <master-key>"`
3. **Routing Probe:** Dispatch a non-streaming test completion:
   ```bash
   curl -s http://localhost:4000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer <master-key>" \
     -d '{"model": "<local-alias>", "messages": [{"role": "user", "content": "Ping"}]}'
   ```

---

## Pitfalls

- **OmniRoute credential deduplication:** Adding duplicate session cookies updates existing connection rows; check row identity when setting up multi-account pools.
- **Peer locality stamp requirement in OmniRoute:** Direct CLI commands fail with 401 when management authentication is required because loopback checks look for internal server peer stamps. Use database scripts with `tsx/esm` and `STORAGE_ENCRYPTION_KEY` for headless administration.
- **Do not install proxy packages in the agent's venv:** Proxy dependencies pin conflicting versions and destabilize the agent runtime.
- **Do not hardcode secrets into `config.yaml`:** Always decouple credentials into `.env`.
- **Do not omit `drop_params: true`:** Modern coding tools send proprietary flags that cause unconfigured upstream endpoints to reject requests with 400 Bad Request.
- **Air-gap untrusted third-party upstream providers:** Run proxies with untrusted third-party credentials on an isolated remote Linux VPS bound to `127.0.0.1:4000` and tunnel via SSH (`-L 4000:127.0.0.1:4000`).
