# Architectural Dissection & Implementation Plan: Excelnt Multi-Account Gateway (EGW)

**Author:** Hermes Dissector (Reverse Engineering & Clean-Room Specification)  
**Target Profile:** Pro-Dev (Principal AI Systems Architect)  
**Upstream Target:** `https://excelnt.ai/v1` & `https://excelnt.ai/dashboard/api-keys`  
**Status:** Ready for Clean-Room Implementation  

---

## 1. Upstream Reverse-Engineering Findings (The Dissection)

### 1.1 Wire Protocol & Service Topology
The reverse-engineering of the Excelnt client extension (`excelnt-1.0.21.vsix`) and live probing of `https://excelnt.ai` reveals:

1. **Inference Ingress (Public & Standardized):**
   * **Endpoint:** `POST https://excelnt.ai/v1/chat/completions`
   * **Protocol:** Standard OpenAI-compatible Chat Completions API.
   * **Authentication:** `Authorization: Bearer <excelnt_api_key>` (Format: `sk-...` generated from `https://excelnt.ai/dashboard/api-keys`).
   * **Streaming:** Standard Server-Sent Events (`text/event-stream`).
   * **Supported Modalities:** Multi-turn chat, system prompts, function calling / tool use, streaming reasoning deltas (`reasoning_content` / `thought`).

2. **Model Catalog:**
   * **Endpoint:** `GET https://excelnt.ai/v1/models` (Public, no auth required).
   * **Discovered Model Lineup (Verified Live):**
     * `gpt-6-astra` — 1,050,000 token context window, 128k max output tokens (OpenAI flagship).
     * `gpt-6.1-sol`, `gpt-6-sol`, `gpt-6-luna`
     * `gpt-5.6-sol`, `gpt-5.6-terra`, `gpt-5.6-luna`, `gpt-5.5`
     * `claude-fable-5-1`, `claude-fable-5` (Anthropic Glasswing models)
     * `claude-opus-5-5`, `claude-opus-5`, `claude-opus-4-8`, `claude-opus-4-7`, `claude-opus-4-6`
     * `claude-sonnet-5`, `claude-sonnet-4-6`, `claude-haiku-4-5`
     * `glm-5.3`, `glm-5.3-flash`, `glm-5-turbo`, `glm-5.2`
     * `qwen3.8-flash`, `qwen3.8-max`
     * `kimi-k3`, `kimi-k2.7-code`
     * `deepseek-v4-pro`, `deepseek-v4.1-flash`, `deepseek-v4-flash`
     * `gemini-3.1-pro`, `gemini-3.6-flash`, `gemini-3.7-flash`, `gemini-3.8-flash`
     * `grok-4.7`, `grok-4.6`, `grok-4.5`, `composer-2.5-fast`

3. **Client Identification Headers:**
   * In addition to standard OpenAI headers, requests can include:
     * `User-Agent: Excelnt` (or `excelnt/1.0.21`)
     * `X-Excelnt-Task-ID: <uuid>` (Optional task correlation ID)

4. **Internal Platform API (VS Code Client Bridge):**
   * Base URL: `https://excelnt.ai/api/vscode/`
   * Headers: `x-excelnt-client: vscode`, `Authorization: Bearer <client_token>`
   * Routes:
     * `GET /api/vscode/me` — User profile & plan state.
     * `GET /api/vscode/keys` — Listing active API keys and revealed tokens.
     * `POST /api/vscode/keys` — Generating new API keys.
     * `GET /api/vscode/billing` — Live balance (`balanceUsd`, `creditedUsd`, `feesUsd`).
     * `GET /api/vscode/usage` — Consumption metrics.
     * `GET /api/vscode/logs` — Query history and per-request credit deduction logs.

---

## 2. Clean-Room Target System Architecture

```
   [ Client Agents: Hermes / Claude Code / Cursor / OpenCode / Codex ]
                                  │
         POST http://127.0.0.1:8998/v1/chat/completions
         Authorization: Bearer sk-excelnt-pool-master
                                  ▼
   ┌───────────────────────────────────────────────────────────────┐
   │             Excelnt Gateway (EGW Multi-Key Proxy)             │
   │                                                               │
   │  ┌─────────────────────────┐     ┌─────────────────────────┐  │
   │  │   Virtual Ingress Auth  │     │   Encrypted Key Vault   │  │
   │  │   - Single Master Key   │     │   - 10-20 Excelnt Keys  │  │
   │  │   - OpenAI /v1 Protocol │     │   - AES-256 Encryption  │  │
   │  └────────────┬────────────┘     └────────────┬────────────┘  │
   │               │                               │               │
   │               ▼                               ▼               │
   │  ┌─────────────────────────────────────────────────────────┐  │
   │  │              Key Pool Scheduler & Balancer              │  │
   │  │  - Selection: LRU / Credit-Weighted / Round-Robin       │  │
   │  │  - Health Scoring & Consecutive Failure Tracking        │  │
   │  │  - Automatic Failover Loop (Traps 429 & Quota Errors)   │  │
   │  └────────────────────────────┬────────────────────────────┘  │
   │                               │                               │
   │                               ▼                               │
   │  ┌─────────────────────────────────────────────────────────┐  │
   │  │            High-Speed SSE Stream Forwarder              │  │
   │  │  - Passes through raw streaming tokens in real-time     │  │
   │  │  - Sub-millisecond latency overhead                     │  │
   │  └────────────────────────────┬────────────────────────────┘  │
   └───────────────────────────────┼───────────────────────────────┘
                                   │
               Upstream HTTPS: https://excelnt.ai/v1
                                   ▼
                   [ Upstream Excelnt Infrastructure ]
                  (Pool of 10-20 Accounts with Credits)
```

---

## 3. Core Engine Mechanics & Algorithms

### 3.1 Encrypted Key Vault & Persistence
* Upstream keys are stored encrypted at rest using AES-256 (Fernet) in SQLite (`data/gateway.db`).
* Local configuration file (`config.yaml`) allows declaring initial keys:
  ```yaml
  server:
    host: 127.0.0.1
    port: 8998
  security:
    master_api_key: sk-excelnt-pool-master
  upstream:
    base_url: https://excelnt.ai/v1
  accounts:
    - id: acc-01
      key: sk-excelnt-xxx1
      label: "Account 1"
    - id: acc-02
      key: sk-excelnt-xxx2
      label: "Account 2"
  ```

### 3.2 Dynamic Pool Scheduling Algorithm
When a request comes in for any model (e.g. `gpt-6-astra` or `claude-opus-5`), the scheduler selects the candidate key using the scoring formula:

$$\text{Score} = (\text{Health} \times 3.0) + (\text{LRU Idle Time} \times 1.0) - (\text{Consecutive Failures} \times 25.0)$$

* **Active Cooldowns:** Any key that encounters HTTP `429 Too Many Requests` or `insufficient_quota` is placed on progressive cooldown:
  $$\text{Cooldown: } 60\text{s} \longrightarrow 300\text{s} \longrightarrow 1800\text{s}$$
* **Transparent Failover:** If Key $A$ returns an error (429 or quota limit) before tokens have been streamed to the client, the gateway instantly swaps to Key $B$ in the pool and replays the request. The client never sees an error.

### 3.3 Streaming Proxy Pipeline
* When `stream: true`, the gateway connects to upstream with `httpx.AsyncClient` streaming response.
* Buffers the initial chunk to verify HTTP 200 status.
* If 200 OK, streams chunks verbatim to client using Server-Sent Events (`StreamingResponse(stream_generator, media_type="text/event-stream")`).

---

## 4. Implementation Steps for Pro-Dev

1. **Scaffold Project at `D:\PROJECTS_1\excelnt-gateway`:**
   * Package structure: `egw.core`, `egw.vault`, `egw.scheduler`, `egw.api`.
2. **Implement Key Vault & SQLite Database:**
   * Tables: `keys` (id, encrypted_key, label, status, health_score, cooldown_until, last_used, failure_count).
3. **Implement Pool Scheduler:**
   * Weighted candidate selection, cooldown manager, retry dispatcher.
4. **Implement FastAPI Ingress API:**
   * `POST /v1/chat/completions` (OpenAI proxy with transparent retry loop).
   * `GET /v1/models` (Proxies and caches `https://excelnt.ai/v1/models`).
   * `GET /health` (Gateway pool status, active/cooldown key counts).
   * `POST /admin/keys` & `GET /admin/keys` (CLI and runtime key management).
5. **Implement Conformance & Parity Test Suite:**
   * Mock upstream simulating 429 rate limits, credit exhaustion, and streaming chunks.
   * Verify 100% test pass rate.
