# Comprehensive Architecture Dissection & Clean-Room Build Plan: Antigravity Multi-Account Gateway

**Author:** Hermes Dissector (Reverse Engineering & Interoperability)  
**Target Profile:** Pro-Dev (Principal AI Systems Architect)  
**Status:** Ready for Clean-Room Implementation  
**Classification:** Clean-Room Interoperability Specification (SIR)  

---

## 1. Executive Summary & Objective

This specification provides the complete technical dissection of the **Antigravity Gateway (`agw` / `GeminiAPI.exe`)** system currently running on Windows (`PID 4168`, port `8999`). It defines the exact upstream RPC interfaces, authentication mechanics, hybrid account scheduling algorithms, schema sanitization rules, and protocol mappers required to build an autonomous, clean-room, multi-account proxy gateway capable of routing client requests (OpenAI/Anthropic APIs) across pools of authenticated upstream accounts with zero downtime, isolated cooldowns, and automatic failover.

---

## 2. Dynamic Reverse Engineering Findings (The "Dirty Room" Dissection)

### 2.1 Upstream Network Wire Protocol & Target Endpoints
The gateway does not communicate with public Gemini Developer APIs (`generativelanguage.googleapis.com`). Instead, it interfaces directly with **Google's internal Cloud Code Assist RPC service** (the backend for Google Cloud Code / Antigravity IDE):

* **Primary Endpoint (Daily Preview):** `https://daily-cloudcode-pa.googleapis.com`
* **Fallback Endpoint (Production):** `https://cloudcode-pa.googleapis.com`

#### Upstream Internal RPC Methods:
1. `POST /v1internal:loadCodeAssist`
   * **Purpose:** Discovers user subscription tier (`free`, `pro`, `ultra`) and companion project ID (`cloudaicompanionProject`).
   * **Body:** `{"metadata": {"ideType": 9, "platform": 5, "pluginType": 2}, "mode": 1}`
2. `POST /v1internal:onboardUser`
   * **Purpose:** Provisions a newly authenticated Google account with Cloud Code workspace rights if not already provisioned.
3. `POST /v1internal:fetchAvailableModels`
   * **Purpose:** Returns the active model catalog and real-time quota metrics (`remainingFraction`, reset timestamps).
   * **Body:** `{"project": "<cloudaicompanion_project_id>"}`
4. `POST /v1internal:streamGenerateContent`
   * **Purpose:** Streaming inference endpoint. Returns newline-delimited JSON arrays of candidate chunks containing text deltas and thought signatures.
5. `POST /v1internal:generateContent`
   * **Purpose:** Non-streaming inference endpoint.

### 2.2 Client Identity & Header Spoofing Contract
Upstream endpoints enforce client verification headers. The gateway identifies itself as the native Antigravity IDE:
* `User-Agent`: `antigravity/1.107.0 windows/amd64` (derived dynamically from OS/Arch)
* `Content-Type`: `application/json`
* `X-Client-Name`: `antigravity`
* `X-Client-Version`: `1.107.0`
* `x-goog-api-client`: `gl-python/3.12 fire/0.8.6 grpc/1.10.x`
* **Platform Constants:**
  * `ideType = 9` (Antigravity IDE)
  * `platform = 5` (Windows AMD64) / `1` (macOS x86_64) / `2` (macOS ARM64) / `3` (Linux x86_64)
  * `pluginType = 2` (Gemini Plugin)

### 2.3 Authentication Lifecycle & Token Vault
* **OAuth 2.0 PKCE Flow:**
  * Auth URL: `https://accounts.google.com/o/oauth2/v2/auth`
  * Token URL: `https://oauth2.googleapis.com/token`
  * Scopes:
    * `https://www.googleapis.com/auth/cloud-platform`
    * `https://www.googleapis.com/auth/userinfo.email`
    * `https://www.googleapis.com/auth/userinfo.profile`
    * `openid`
* **Storage Encryption:**
  * Tokens are encrypted at rest using **AES-256 Fernet** with a locally generated key (`data/vault.key`).
  * Account metadata and stats reside in SQLite (`data/gateway.db`).
  * Proactive refresh triggers 5 minutes prior to access token expiry.

### 2.4 The Multi-Account Hybrid Scheduling Algorithm
The scheduler selects candidate accounts using a 4-parameter weighted formula:

$$\text{Score} = (\text{Health} \times 2.0) + (\text{Tokens} \times 5.0) + (\text{Quota} \times 3.0) + (\text{LRU} \times 0.1) + \text{Priority}$$

1. **Health Score ($0 - 100$):** Success rate over the trailing 50 requests.
2. **Token Capacity ($0 - 100$):** $100.0 - (\text{consecutive\_failures} \times 30.0)$.
3. **Quota Availability ($0 - 100$):** $\text{remainingFraction} \times 100$. If remaining quota is $< 5\%$, applies a severe penalty $(-100.0)$ to deter selection while preserving relative ordering.
4. **LRU Freshness ($0 - 100$):** Idle seconds capped at 300s, favoring accounts that have rested.
5. **Priority Boost:** Configured manual priority offset ($+10.0$ per rank).

### 2.5 Isolated Cooldown Engine
* **Family Partitioning:** Accounts are categorized into model families: `gemini`, `claude`, `gpt`.
* When an account receives an HTTP 429 (`RESOURCE_EXHAUSTED`) on a Claude model, **only the Claude family is placed on cooldown** for that account. Its Gemini and GPT quotas remain 100% active.
* **Tiered Backoff:** Progressive cooldown durations:
  $$\text{Tiers: } 60\text{s} \longrightarrow 300\text{s} \longrightarrow 1800\text{s} \longrightarrow 7200\text{s}$$
* **Transparent Failover:** The gateway traps the 429 upstream, updates the account state, selects the next-highest scored account in the pool, and re-executes the request seamlessly.

### 2.6 Protocol Translation & Crucial Pitfalls Discovered
1. **Tool Schema Sanitizer:** Upstream Cloud Code rejects standard JSON Schema v7 and OpenAPI keywords. If present, it throws `400 INVALID_ARGUMENT`. The gateway must recursively strip:
   * Disallowed keys: `$schema`, `$id`, `$defs`, `definitions`, `additionalProperties`, `pattern`, `multipleOf`, `exclusiveMinimum`, `exclusiveMaximum`, `minProperties`, `maxProperties`, `uniqueItems`, `if`, `then`, `else`, `not`, `default`, `title`, `format`.
   * Inlines `$ref` references directly from `$defs` before stripping.
   * Converts `const` values into single-item `enum` arrays.
2. **Cryptographic Thought Signature Cache:**
   * Gemini thinking models emit a `thoughtSignature` byte sequence attached to tool calls.
   * Standard OpenAI clients (Hermes, LiteLLM) strip unknown fields when passing tool outputs back.
   * If a tool response is sent back without the matching `thoughtSignature`, the upstream API rejects the turn.
   * The gateway maintains a TTL LRU cache linking `call_id` and hashed `(function_name, arguments)` to their original upstream signatures, inlining them back into the upstream request envelope.

---

## 3. Clean-Room Target System Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│                          INBOUND INGRESS API                           │
│  - POST /v1/chat/completions (OpenAI Compatible)                       │
│  - POST /v1/messages         (Anthropic Compatible)                    │
│  - GET  /v1/models           (Dynamic Model Registry)                  │
│  - Local Bearer Auth & Role Key Dispatch                               │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                        CORE ROUTING & DISPATCH                         │
│  ┌───────────────────────┐  ┌─────────────────┐  ┌──────────────────┐  │
│  │   Account Scheduler   │  │ Cooldown Engine │  │ Quota Collector  │  │
│  │   (Hybrid Scoring)    │  │ (Family Tiers)  │  │ (Background Sync)│  │
│  └───────────────────────┘  └─────────────────┘  └──────────────────┘  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                     PROTOCOL & ENVELOPE TRANSLATOR                     │
│  - OpenAI / Anthropic -> Cloud Code Envelope                           │
│  - Deep JSON Schema Sanitizer (Strip OpenAPI v7 bloat)                 │
│  - Thought Signature TTL Cache (Thinking Model tool parity)            │
│  - SSE Chunk Streamer & Delta Demuxer                                  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                      UPSTREAM CLOUD CODE CLIENT                        │
│  - Endpoint Fallback (daily-cloudcode-pa -> cloudcode-pa)              │
│  - PKCE OAuth Auto-Refresher                                           │
│  - Antigravity IDE Header Emulation                                    │
│  - AES-256 Encrypted Credential Vault                                 │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Implementation Specifications for Pro-Dev

### Phase 1: Tracer Bullet Slice (Auth & Single Request Parity)
1. Implement `Vault` and `Crypto` module (Fernet AES-256) for token persistence.
2. Implement `CloudCodeClient` targeting `daily-cloudcode-pa.googleapis.com` with Antigravity headers.
3. Implement `SchemaSanitizer` to ensure function schemas do not trigger `400 INVALID_ARGUMENT`.
4. Expose `POST /v1/chat/completions` non-streaming and verify end-to-end response.

### Phase 2: Streaming & Thought Signature Integrity
1. Implement `SSEStreamer` converting upstream chunk arrays to OpenAI SSE `data: {"choices":[{"delta":{"content":...}}]}`.
2. Implement `ThoughtSignatureCache` to record and re-inject thinking signatures on function calls.

### Phase 3: Multi-Account Scheduler & Circuit Breakers
1. Create SQLite state database (`accounts`, `cooldowns`, `usage`, `quotas`).
2. Implement `AccountScheduler` with weighted scoring formula.
3. Implement `CooldownManager` with per-family isolation and backoff tiers (`60s, 300s, 1800s, 7200s`).
4. Implement automatic failover loop on HTTP 429/503.

### Phase 4: Administrative Surface & Parity Verification
1. CLI tool (`agw`) for adding accounts via browser OAuth PKCE flow.
2. Admin diagnostic endpoints (`/admin/accounts`, `/admin/health`, `/admin/cooldowns`).
3. Conformance test suite running 100% of fixtures against mock upstream.

---

## 5. Verification Checklist & Acceptance Criteria
- [ ] Account token storage is encrypted with zero plaintext leakage in logs or database.
- [ ] Upstream requests correctly include Antigravity metadata (`ideType=9`, `platform=5`).
- [ ] Schema sanitizer successfully cleans tools with `$ref`, `additionalProperties`, and `pattern`.
- [ ] 429 error on Claude model puts only `claude` on cooldown; `gemini` remains routeable.
- [ ] SSE streaming yields chunks with $< 50\text{ms}$ overhead.
- [ ] Tool calling turns pass thought signature roundtrip verification without upstream rejection.
