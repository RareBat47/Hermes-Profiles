# RESEARCH REPORT: FRONTIER AI API PROVIDERS WITH RENEWABLE FREE ALLOWANCES

## EXECUTIVE SUMMARY

Excelnt.ai operates as a multi-model aggregator proxy providing unified OpenAI-compatible routing across frontier architectures (Anthropic Claude, OpenAI GPT, Google Gemini, DeepSeek) through developer promotional balances and unified API keys. For developers seeking sustainable, renewable zero-cost alternatives without credit card requirements or trial expiration traps, the current AI infrastructure landscape divides into three categories:

1. Flagship Prototyping Hubs (GitHub Models): Direct access to OpenAI o1/o3/GPT-4o and DeepSeek R1/V3 under permanent 24-hour renewable request allowances backed by Microsoft/Azure.
2. First-Party Native Free Tiers (Google AI Studio, Mistral AI): Ongoing daily/monthly token allotments (e.g., up to 1,000 requests/day on Gemini Flash, 1 Billion tokens/month on Mistral) refreshed permanently without entering billing info.
3. Aggregators & Unified Gateways (Puter.js, OpenRouter): Multi-model routing spanning Claude 3.7/Sonnet, GPT-4o, and DeepSeek with dedicated free tiers (:free model pools or user-pays serverless models).

Note on Decommissioned / Deprecated Free Tiers: Several widely cited free tiers (most notably SambaNova Cloud, which shut down its free tier in late 2025/2026 and now returns HTTP 402, and Cerebras/SiliconFlow, which shifted to one-time starter credits) are no longer permanently renewable. Those are documented in the Caveats and Warnings section below.

---

## 1. DETAILED PROVIDER PROFILES

### 1. GitHub Models (Microsoft / Azure AI Foundry)

* Canonical URLs:
  - Marketplace Catalog: https://github.com/marketplace/models
  - Documentation: https://docs.github.com/en/enterprise-cloud@latest/github-models/use-github-models/prototyping-with-ai-models
* Available Frontier & Flagship Models:
  - OpenAI: GPT-4o, GPT-4o mini, o1, o3-mini
  - DeepSeek: DeepSeek-R1, DeepSeek-V3
  - Meta & Mistral: Llama 3.3 70B Instruct, Mistral Large 2411, Cohere Command R+
* Exact Free Tier Credit Mechanics:
  - Quota: Hard rate-limited request counts based on model compute class.
    * High-Tier Models (OpenAI o1, GPT-4o, DeepSeek-R1): 10 requests per minute (RPM), 50 requests per day (RPD), 8,000 tokens input / 4,000 tokens output max per request.
    * Low-Tier Models (GPT-4o mini, Llama 3.1 8B): 15 RPM, 150 RPD, 8,000 tokens input / 4,000 tokens output.
    * Reasoning / Preview Models (Azure OpenAI o1-preview): 1 RPM, 8-12 RPD.
  - Cadence: Daily reset. Requests-per-day counter rolls over every 24 hours (UTC midnight).
  - Rollover Rules: Hard daily expiration; unused quota does not carry over.
* Friction Requirements:
  - Credit Card: Not required.
  - Verification: Standard GitHub account login. No phone verification required.
  - Authentication: GitHub Personal Access Token (PAT) with no special scopes needed.
* Protocol Compatibility:
  - Base URL: `https://models.inference.ai.azure.com`
  - Wire Format: OpenAI Chat Completions REST schema (`/chat/completions`). Drop-in compatible with standard `openai` Python/Node SDKs, LiteLLM, LangChain, Cline, and Roo Code.
  - Anthropic Wire Format: Requires client-side translation or LiteLLM proxy; native Anthropic wire format is not accepted directly.
* Rate Limits & Caveats:
  - 50 RPD on GPT-4o and DeepSeek-R1 restricts usage to agent testing, low-volume automation, or developer evaluations.
  - Concurrent requests capped at 2 (High tier) and 5 (Low tier). Exceeding triggers HTTP 429.

---

### 2. Google AI Studio (Gemini API)

* Canonical URLs:
  - Developer Console: https://aistudio.google.com
  - API Documentation: https://ai.google.dev/gemini-api/docs/rate-limits
* Available Frontier & Flagship Models:
  - Google: Gemini 2.5 Pro, Gemini 2.5 Flash, Gemini 2.5 Flash-Lite, Gemini 2.0 Flash, Gemini 1.5 Pro, Gemini Embedding 2
* Exact Free Tier Credit Mechanics:
  - Quota: Permanent recurring per-minute and per-day quotas without any balance burn.
    * Gemini 2.5 Flash-Lite: 15 RPM, 1,000 RPD, 250,000 Tokens Per Minute (TPM).
    * Gemini 2.5 Flash: 10 RPM, 250-500 RPD, 250,000 TPM.
    * Gemini 2.5 Pro: 5 RPM, 50-100 RPD, 250,000 TPM.
    * Gemini Embedding: 100 RPM, 1,000 RPD.
  - Cadence: Daily reset. RPD counters reset every night at midnight Pacific Time (00:00 PT).
  - Rollover Rules: Daily allocation expires; no balance rollover.
* Friction Requirements:
  - Credit Card: Not required. No billing account needed for the free tier.
  - Verification: Standard Google account.
  - Authentication: Standard API key generated in Google AI Studio.
* Protocol Compatibility:
  - Base URL: Native Google GenAI SDK (`generativelanguage.googleapis.com`) AND official OpenAI-compatible endpoint:
    `https://generativelanguage.googleapis.com/v1beta/openai/`
  - Wire Format: Native Google REST/gRPC and full OpenAI Chat Completions compatibility (`v1beta/openai/chat/completions`). Supports model mapping directly.
* Rate Limits & Caveats:
  - Data Privacy Tradeoff: Google's developer terms stipulate that prompts and responses submitted on the Free Tier may be logged and reviewed by human reviewers to train and improve Google models. If handling private, sensitive, or customer data, developers must link a card and switch to Tier 1 (pay-as-you-go).
  - Rate limits are enforced at the Google Cloud Project level, not per API key.

---

### 3. Puter (Puter.js / Puter API Gateway)

* Canonical URLs:
  - Console & Dashboard: https://puter.com
  - Developer Portal: https://developer.puter.com
  - Model Catalog: https://developer.puter.com/ai/models/
* Available Frontier & Flagship Models:
  - Anthropic: Claude 3.7 Sonnet, Claude 3.5 Sonnet, Claude Opus
  - OpenAI: GPT-4o, o1, o3-mini, GPT-4.1
  - Google: Gemini 2.5 Pro, Gemini 2.5 Flash
  - DeepSeek & Open Models: DeepSeek-R1, DeepSeek-V3, Grok 2/3, Llama 3.3 70B
* Exact Free Tier Credit Mechanics:
  - Quota Mechanics:
    * Architecture 1 (OpenAI REST Gateway): Direct API execution using Puter Auth Token via `https://api.puter.com/puterai/openai/v1/`. Free accounts receive a recurring allowance of ~100,000 to 5,000,000 tokens/month (metered usage).
    * Architecture 2 (User-Pays SDK): Client-side applications using `puter.js` (`puter.ai.chat(...)`) allow developers to make unlimited frontier model calls at $0 cost to the developer; end-users authenticate via their own free Puter accounts.
  - Cadence: Monthly and daily token replenishment windows.
  - Rollover Rules: Unused monthly/daily token ceilings do not roll over.
* Friction Requirements:
  - Credit Card: Not required.
  - Verification: Simple email/username sign-up. No credit card, no phone number required.
* Protocol Compatibility:
  - Base URL: `https://api.puter.com/puterai/openai/v1/`
  - Wire Format: OpenAI Chat Completions REST compatible. Model naming convention: `openai/gpt-4o`, `openai/claude-sonnet-4-5` or `claude-sonnet-5`, `openai/deepseek-r1`. Works natively with LiteLLM, LangChain, and OpenAI SDKs.
  - Anthropic Wire Format: Direct Anthropic SDK requires passing through LiteLLM or setting Puter's OpenAI baseURL.
* Rate Limits & Caveats:
  - Account rate limits sit at approximately 30 requests per minute on free tiers.
  - Token availability across proprietary frontier tiers (Claude Opus, GPT-4o) can encounter backend queuing or per-user dynamic monthly caps during peak times.

---

### 4. OpenRouter

* Canonical URLs:
  - Platform Website: https://openrouter.ai
  - Model Catalog: https://openrouter.ai/models
  - Rate Limit Documentation: https://openrouter.ai/docs/limits
* Available Frontier & Flagship Models (Free Tier `:free` tagged):
  - DeepSeek: `deepseek/deepseek-r1:free`, `deepseek/deepseek-chat:free` (DeepSeek-V3)
  - Google: `google/gemini-2.0-flash-exp:free`, `google/gemma-4-31b-it:free`
  - Meta & Qwen: `meta-llama/llama-3.3-70b-instruct:free`, `qwen/qwen-2.5-72b-instruct:free`, `openrouter/free` (auto-router)
  - Note: Proprietary frontier models (Claude 3.7 Sonnet, GPT-4o) require prepaid balance, but open-weight frontier equivalents (DeepSeek R1/V3) are hosted permanently free under `:free`.
* Exact Free Tier Credit Mechanics:
  - Quota:
    * 20 requests per minute (RPM) across all `:free` models.
    * 50 requests per day (RPD) account-wide for accounts with under $10 in lifetime purchased credits.
    * 1,000 requests per day (RPD) account-wide permanently if the account has ever purchased at least $10 in lifetime credits (even after the balance is spent).
  - Cadence: Daily rolling 24-hour reset for the RPD counter.
  - Rollover Rules: Daily request caps do not roll over.
* Friction Requirements:
  - Credit Card: Not required.
  - Verification: Email, GitHub OAuth, or Google sign-in.
* Protocol Compatibility:
  - Base URL: `https://openrouter.ai/api/v1`
  - Anthropic Skin Base URL: `https://openrouter.ai/api`
  - Wire Format: Full OpenAI Chat Completions format. In addition, OpenRouter offers a native "Anthropic Skin" allowing tools built specifically for Anthropic (such as Claude Code) to point directly at OpenRouter using `ANTHROPIC_BASE_URL=https://openrouter.ai/api`.
* Rate Limits & Caveats:
  - Free models rely on subsidized and donated compute from upstream partners; during periods of global traffic spikes, `:free` models may experience queuing, temporary latency spikes, or upstream HTTP 429/503 responses.
  - Creating multiple API keys under one OpenRouter account does not increase the daily limit (quota is account-wide).

---

### 5. Mistral AI (La Plateforme)

* Canonical URLs:
  - Developer Console: https://console.mistral.ai
  - Administrative Limits: https://admin.mistral.ai/plateforme/limits
* Available Frontier & Flagship Models:
  - Mistral Flagships: Mistral Large 3 (frontier model competing directly with GPT-4o/Claude 3.5 Sonnet), Codestral 256K (frontier code generation model), Pixtral Large (multimodal vision frontier), Mistral Small 4, Mixtral 8x22B
* Exact Free Tier Credit Mechanics:
  - Quota: "Experiment" free tier providing an extraordinarily generous 1,000,000,000 tokens per month (1 Billion tokens/month) across all supported models including Mistral Large and Codestral.
  - Concurrency & Speed: Capped at ~1 request per second (~2 to 60 RPM depending on model class) and 500,000 Tokens Per Minute (TPM).
  - Cadence: Monthly token reset.
  - Rollover Rules: Unused monthly tokens do not carry forward.
* Friction Requirements:
  - Credit Card: Not required for the Experiment plan.
  - Verification: Email verification PLUS mandatory SMS / Phone number verification (one phone number per workspace).
* Protocol Compatibility:
  - Base URL: `https://api.mistral.ai/v1`
  - Wire Format: Official OpenAI SDK compatible Chat Completions format (`https://api.mistral.ai/v1/chat/completions`).
* Rate Limits & Caveats:
  - Throughput ceiling: The 1 request/second and 2-5 RPM limits prevent heavy parallel multi-threaded batch operations.
  - SMS verification prevents automated disposable account creation.

---

### 6. BONUS / HIGH-SPEED ALTERNATIVE: GroqCloud (Groq)

* Canonical URLs:
  - Developer Console: https://console.groq.com
  - Rate Limits Guide: https://console.groq.com/docs/rate-limits
* Available Flagship Models:
  - Open Frontier & Large Models: OpenAI GPT-OSS-120B, GPT-OSS-20B, Qwen 2.5 32B / 27B, Whisper Large v3 (speech-to-text)
* Exact Free Tier Credit Mechanics:
  - Quota: Permanent recurring free limits:
    * 30 RPM, 1,000 RPD, 8,000 TPM, 200,000 Tokens Per Day (TPD) per chat model.
    * Whisper Large: 20 RPM, 2,000 RPD.
  - Cadence: Daily reset at 00:00 UTC.
* Friction Requirements:
  - Credit Card: Not required.
  - Verification: Email / GitHub / Google sign-in.
* Protocol Compatibility:
  - Base URL: `https://api.groq.com/openai/v1`
  - Wire Format: 100% OpenAI-compatible Chat Completions.
* Rate Limits & Caveats:
  - Note on Model Lineup: Groq phased out free-tier Llama 3.3 70B in late 2025/2026 to prioritize Enterprise capacity, shifting its free flagship focus to OpenAI GPT-OSS-120B and Qwen.

---

## 2. CRITICAL CAVEAT: RETIRED / DECOMMISSIONED FREE TIERS

When conducting automated research or consulting legacy guides, developers frequently encounter references to several providers whose free offerings have expired or fundamentally changed:

1. SambaNova Cloud:
   - Status: DELISTED / NO LONGER FREE.
   - Finding: Previously offered 20 RPD / 200k tokens/day for DeepSeek-R1 and Llama 3.3 70B without a card. As of late 2025/mid-2026, unfunded accounts return `HTTP 402 PAYMENT_METHOD_REQUIRED`. A valid credit card and prepaid balance are now mandatory before making calls.
2. SiliconFlow (siliconflow.cn / siliconflow.com):
   - Status: TRIAL ONLY (Non-Renewable) + Small Model Free Tier.
   - Finding: Provides a one-time starter grant of $1 (or ¥14-16) upon signup, which is spent down and does not recur. While small models (e.g., 7B-8B parameter variants) remain ¥0, flagship models (DeepSeek-R1 671B full) are strictly paid once the initial dollar is consumed.
3. Cerebras Cloud:
   - Status: Shifted from standing renewable free tier to time-bounded trial credits and developer paid tiers.

---

## 3. COMPARISON LEDGER

| Provider Name | Canonical Console URL | Frontier Models Included | Free Allowance & Renewal Cadence | Friction / Auth Gate | OpenAI BaseURL Compatibility | Primary Caveat |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| GitHub Models | https://github.com/marketplace/models | OpenAI o1, o3-mini, GPT-4o; DeepSeek-R1, DeepSeek-V3 | 10 RPM / 50 RPD (High tier); 15 RPM / 150 RPD (Low tier). Resets daily (24h UTC). | GitHub Account + Personal Access Token. No Card. | `https://models.inference.ai.azure.com` | Strict 50 RPD cap on o1/GPT-4o; 4K output token limit. |
| Google AI Studio | https://aistudio.google.com | Gemini 2.5 Pro, 2.5 Flash, 2.5 Flash-Lite, Gemini 2.0 Flash | 15 RPM / 1,000 RPD (Flash-Lite); 10 RPM / 250 RPD (Flash); 5 RPM / 50 RPD (Pro). Resets daily (00:00 PT). | Google Account. No Credit Card. | `https://generativelanguage.googleapis.com/v1beta/openai/` | Prompts/responses on free tier are logged for Google model training. |
| Puter.com | https://developer.puter.com | Claude 3.7 Sonnet, Claude Opus, GPT-4o, o1, Gemini 2.5, DeepSeek R1 | Recurring monthly/daily metered tokens (~100k-5M tokens/mo) or unlimited developer zero-cost via User-Pays model. | Puter Account (Email/Username). No Card. | `https://api.puter.com/puterai/openai/v1/` | Shared gateway queues during high congestion; token limits on heavy generation. |
| OpenRouter | https://openrouter.ai | DeepSeek R1 (`:free`), DeepSeek V3 (`:free`), Gemini Flash (`:free`), Llama 3.3 70B (`:free`) | 20 RPM; 50 RPD permanently free ($0 spent); 1,000 RPD if account has $10 lifetime recharge. Resets daily. | Email / OAuth. No Credit Card. | `https://openrouter.ai/api/v1` (OpenAI) / `https://openrouter.ai/api` (Anthropic) | Shared community compute pool; proprietary models (Claude/GPT-4o) require paid balance. |
| Mistral AI | https://console.mistral.ai | Mistral Large 3, Codestral 256K, Pixtral Large | 1,000,000,000 (1 Billion) tokens/month; ~1 RPS, 500k TPM. Resets monthly. | Email + SMS / Phone Verification. No Card. | `https://api.mistral.ai/v1` | ~1 req/sec concurrency restriction; requires valid mobile phone number. |
| GroqCloud | https://console.groq.com | OpenAI GPT-OSS-120B, Qwen 27B, Whisper Large v3 | 30 RPM, 1,000 RPD, 200k TPD per model. Resets daily (00:00 UTC). | Email / GitHub / Google. No Card. | `https://api.groq.com/openai/v1` | Ultra-fast LPU inference, but Llama 3.3 70B was removed from free tier; 8k TPM cap. |

---

## 4. INTEGRATION & PROTOCOL CONFIGURATION GUIDE

All listed providers support OpenAI wire format conventions, enabling zero-code changes when configuring tools such as LiteLLM, LangChain, Cline, Cursor, Roo Code, or custom Python scripts:

### A. Python (`openai` SDK) Configuration Examples

#### 1. GitHub Models (GPT-4o or DeepSeek-R1)
```python
from openai import OpenAI

client = OpenAI(
    base_url="https://models.inference.ai.azure.com",
    api_key="ghp_your_github_personal_access_token",
)

response = client.chat.completions.create(
    model="gpt-4o",  # or "DeepSeek-R1", "o3-mini"
    messages=[{"role": "user", "content": "Analyze system requirements."}],
)
print(response.choices[0].message.content)
```

#### 2. Google AI Studio (Gemini 2.5 Flash via OpenAI endpoint)
```python
from openai import OpenAI

client = OpenAI(
    base_url="https://generativelanguage.googleapis.com/v1beta/openai/",
    api_key="AIzaSy_your_google_ai_studio_key",
)

response = client.chat.completions.create(
    model="gemini-2.5-flash",  # or "gemini-2.5-pro"
    messages=[{"role": "user", "content": "Explain vector embeddings."}],
)
print(response.choices[0].message.content)
```

#### 3. Puter.com (Claude 3.7 / Sonnet or GPT-4o)
```python
from openai import OpenAI

client = OpenAI(
    base_url="https://api.puter.com/puterai/openai/v1/",
    api_key="your_puter_auth_token",
)

response = client.chat.completions.create(
    model="openai/claude-sonnet-4-5",  # or "openai/gpt-4o"
    messages=[{"role": "user", "content": "Draft an API architecture."}],
)
print(response.choices[0].message.content)
```

#### 4. OpenRouter (Free DeepSeek-R1 or Free Auto-Router)
```python
from openai import OpenAI

client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key="sk-or-v1-your_openrouter_key",
)

response = client.chat.completions.create(
    model="deepseek/deepseek-r1:free",  # or "openrouter/free"
    messages=[{"role": "user", "content": "Perform mathematical proof."}],
)
print(response.choices[0].message.content)
```

#### 5. OpenRouter Anthropic Skin (Direct Drop-in for Claude Tools)
For tools expecting the Anthropic wire format (like Claude Code CLI or Anthropic SDKs):
```bash
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_API_KEY="sk-or-v1-your_openrouter_key"
export ANTHROPIC_MODEL="openrouter/free"
```

---

## 5. ARCHITECTURAL RECOMMENDATION: DEVELOPER ZERO-COST ROTATION POOL

For continuous developer automation without paying for API quotas or hitting 429 barriers:

1. Primary Heavy Reasoning & Code Tasks:
   - Route through GitHub Models (`DeepSeek-R1` or `o3-mini`) for up to 50 daily deep-reasoning calls.
   - Overflow to Mistral AI (`Codestral 256K`) using its 1 Billion tokens/month allowance.
2. High-Volume Interactive & Data Extraction Tasks:
   - Route through Google AI Studio (`Gemini 2.5 Flash-Lite` and `2.5 Flash`) for 1,000+ daily calls and 1M context analysis.
3. Multi-Model Testing & Client-Side Applications:
   - Utilize Puter.js for zero developer backend costs via user-pays mechanics, or OpenRouter's `:free` lane for baseline CI/eval test passes.

---

## SOURCES & CITATIONS

[1] GitHub Enterprise Docs: Prototyping with AI models and rate limits: https://docs.github.com/en/enterprise-cloud@latest/github-models/use-github-models/prototyping-with-ai-models  
[2] GitHub Models Product Billing & Token Calculations: https://docs.github.com/en/enterprise-cloud@latest/billing/concepts/product-billing/github-models  
[3] Google AI for Developers: Gemini API Rate Limits and Quotas: https://ai.google.dev/gemini-api/docs/rate-limits  
[4] Google AI Studio Console: https://aistudio.google.com  
[5] Puter.js & Puter Developer Tutorials: Free LLM API & Model Integrations: https://developer.puter.com/tutorials/free-llm-api/  
[6] Puter AI Models Catalog: https://developer.puter.com/ai/models/  
[7] OpenRouter Documentation: Rate Limits, Model Quotas, and :free endpoints: https://openrouter.ai/docs/limits  
[8] Mistral AI La Plateforme Rate Limits & Console: https://console.mistral.ai and https://admin.mistral.ai/plateforme/limits  
[9] GroqCloud Documentation: API Rate Limits and OpenAI Compatibility: https://console.groq.com/docs/rate-limits  
[10] SambaNova Cloud Delisting & Status Verification: https://toolfreebie.com/sambanova-cloud-free-api/ and https://docs.sambanova.ai/docs/en/models/rate-limits
