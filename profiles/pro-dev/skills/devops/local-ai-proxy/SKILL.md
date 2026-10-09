---
name: local-ai-proxy
description: Use when setting up or managing a local AI proxy gateway.
version: 1.0.0
category: devops
metadata:
  hermes:
    tags: [litellm, ai-gateway, proxy, local-development, model-routing, openai-compatible]
    related_skills: [hermes-profile-provider-config, autonomous-cloud-ai-proxy-project]
---

# Local AI Proxy Gateway

Use this skill when provisioning, configuring, operating, or troubleshooting a local OpenAI-compatible proxy server (such as LiteLLM Proxy) to centralize upstream model access across a workstation for IDEs, coding agents, and terminal CLIs.

## Core Rules

1. **Isolate the proxy environment:** Always install proxy packages in a dedicated virtual environment (using `uv venv` or standard `python -m venv`) within a dedicated project directory. Never install proxy dependencies into the agent's or global system Python environment.
2. **Decouple credentials from config:** Never hardcode upstream or master API keys inside `config.yaml`. Use environment variable interpolation (`os.environ/<VAR_NAME>`) backed by a local `.env` file and provide a clean `.env.example`.
3. **Guard against proprietary tool parameters:** Set `drop_params: true` in `litellm_settings` so IDE extensions (Cursor, Cline, Copilot) passing vendor-specific flags do not trigger upstream parameter validation failures.
4. **Verify through every layer before reporting:** Check binary version, process initialization log, `/v1/models` catalog reflection, and an end-to-end `/v1/chat/completions` probe.

---

## Procedure

### 1. Provision a Dedicated Working Directory & Environment

Create an isolated directory for the proxy instance and create a virtual environment using `uv` or Python:

```bash
mkdir -p "$HOME/litellm-proxy"
cd "$HOME/litellm-proxy"
uv venv --python 3.12
uv pip install "litellm[proxy]"
```

Verify the binary is available:
```bash
./.venv/bin/litellm --version   # Linux/macOS
.venv\Scripts\litellm.exe --version   # Windows
```

### 2. Configure Model Mapping and Secrets

Create `config.yaml` referencing environment variables:

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

Create a corresponding `.env` file for secrets (and `.env.example` as a template):

```env
UPSTREAM_API_KEY=your_actual_key_here
LITELLM_MASTER_KEY=sk-local-master-key-1234
```

### 3. Generate Platform Launch Scripts

Provide one-click start scripts so the proxy can easily be restarted outside the agent session:

- **Windows (`start-proxy.bat`):**
  ```bat
  @echo off
  cd /d "%~dp0"
  echo Starting LiteLLM Proxy on http://localhost:4000 ...
  .venv\Scripts\litellm.exe --config config.yaml --port 4000 --telemetry False
  pause
  ```

- **POSIX (`start-proxy.sh`):**
  ```bash
  #!/usr/bin/env bash
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd "$DIR"
  "$DIR/.venv/bin/litellm" --config config.yaml --port 4000 --telemetry False
  ```

### 4. Execute Multi-Stage Verification

Never assume the gateway is functioning based solely on exit code 0 or port binding:

1. **Verify Startup Logs:** Confirm model registration lines appear in stdout:
   ```text
   LiteLLM: Proxy initialized with Config, Set models:
       <model-1>
       <model-2>
   INFO: Application startup complete.
   ```
2. **Verify Local Model Catalog:** Ensure the master key authenticates and returns model definitions:
   ```bash
   curl -s http://localhost:4000/v1/models -H "Authorization: Bearer <master-key>"
   ```
3. **Verify Routing & Forwarding:** Dispatch a non-streaming test completion:
   ```bash
   curl -s http://localhost:4000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer <master-key>" \
     -d '{
       "model": "<local-alias>",
       "messages": [{"role": "user", "content": "Ping"}]
     }'
   ```
   *Note:* If upstream credentials are placeholders, an HTTP 401 from upstream confirms correct routing, header injection, and network egress.

### 5. Document Client Integration & Coding Agent Wiring

Provide clear connection settings for developer tools:
- **Base URL:** `http://localhost:4000/v1`
- **API Key:** `<LITELLM_MASTER_KEY>`
- **Model Name:** `<local-alias>`
- **Shell Environment:**
  ```bash
  export OPENAI_API_BASE="http://localhost:4000/v1"
  export OPENAI_API_KEY="<LITELLM_MASTER_KEY>"
  ```

#### Wiring OpenCode with Exclusive Provider Isolation
To configure OpenCode CLI (`opencode`) to only show and route to this local proxy without clutter from other providers, configure `~/.config/opencode/opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "local-proxy": {
      "name": "Local AI Proxy",
      "type": "openai",
      "baseURL": "http://127.0.0.1:4000/v1",
      "apiKey": "<LITELLM_MASTER_KEY>",
      "models": {
        "<local-alias>": { "name": "<Display Name>" }
      },
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://127.0.0.1:4000/v1",
        "apiKey": "<LITELLM_MASTER_KEY>"
      }
    }
  },
  "enabled_providers": ["local-proxy"],
  "disabled_providers": ["opencode", "arena", "openai", "anthropic", "openrouter"],
  "model": "local-proxy/<local-alias>",
  "small_model": "local-proxy/<fast-model-alias>"
}
```
Verify the restricted catalog with `opencode models`. If OpenCode throws SQLite migration errors (e.g. `Database is not empty and has no session table`), terminate any running background daemon (`taskkill /F /PID <pid>` or `killall opencode-cli`) and rename `~/.local/share/opencode/opencode.db` so it initializes fresh tables.

---

## Pitfalls

- **Do not install proxy packages in the agent's venv:** proxy dependencies (FastAPI, Granian, Polars, Prisma) can pin conflicting versions and destabilize the agent runtime.
- **Do not hardcode secrets into `config.yaml`:** configuration files are often committed or shared, exposing upstream credentials. Use `os.environ/KEY` so LiteLLM loads them from `.env`.
- **Do not omit `drop_params: true`:** modern AI coding tools send proprietary parameters (e.g. `context_window`, `reasoning_effort`) that cause unconfigured upstream endpoints to return 400 bad request errors.
- **Do not treat port listening as verification:** a running server process might fail to load the configuration or connect to upstream; always inspect the model list and execute a test completion probe.
- **Air-gap untrusted third-party upstream providers:** Never run proxy services with untrusted third-party credentials directly on the primary workstation. Host the proxy on an isolated remote Linux VPS bound strictly to `127.0.0.1:4000` (blocking cloud instance metadata `169.254.169.254` via iptables) and route traffic via an encrypted SSH tunnel (`-L 4000:127.0.0.1:4000`).
- **Detach Windows SSH tunnels completely:** Do not run persistent `ssh -L` tunnels inside interactive subshells or terminal backgrounds; Windows terminates them when the shell detaches. Launch detached via PowerShell `Start-Process ssh -ArgumentList '...' -WindowStyle Hidden` with `ServerAliveInterval=15` or via `.vbs` in the Startup folder.
- **Reasoning models emit null content during thinking:** Upstream reasoning models (DeepSeek-R1 style) stream tokens inside `delta.reasoning_content` while `delta.content` is null. Clients waiting for content tokens display "Waiting on provider..." and can hit connection timeouts (30s) triggering endless retries. Never use pure reasoning models as primary defaults without verifying client reasoning-stream support.
- **Restart Hermes Desktop backend processes after config edits:** Hermes Desktop runs persistent background `serve` processes per profile that keep configuration in memory. After editing `config.yaml`, kill running `hermes_cli.main --profile <name> serve` processes and start a fresh chat turn (`/new`) to clear in-memory retry loops.
- **Enforce exact case matching for Hermes custom providers:** `provider: custom:<Name>` must match `providers.<Name>` exactly in `config.yaml`. Mismatches cause Hermes to fall back to an unauthenticated generic endpoint, resulting in `APIConnectionError`.
