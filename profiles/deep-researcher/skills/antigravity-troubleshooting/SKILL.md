---
name: antigravity-troubleshooting
description: Diagnostic procedures for resolving thought_signature errors, 429 rate limits, and model parameter issues.
---

# Antigravity Troubleshooting Skill

## Protocol & Runtime Fixes Implemented

### 1. Thought Signature Recovery (Multi-Turn Tool Calling)
- **Symptom**: `HTTP 400: Function call is missing a thought_signature in functionCall parts`.
- **Resolution**: AGW uses a 7-layer signature recovery cache. Signatures are attached to the `Part` object (`parts[j].thoughtSignature`), preserving Gemini's cryptographic tool state across turns.

### 2. Missing Tool ID Error in Claude & GPT Models
- **Symptom**: `messages.1.content.1.tool_use.id: Field required` or `Expected the 'id' of a(n) 'assistant' 'tool_calls' array element to be populated`.
- **Resolution**: AGW strictly populates `id` on both `functionCall` and `functionResponse` across all turns.

### 3. Gemini 3.1 Pro Output Token Bounds
- **Symptom**: `400: Request contains an invalid argument` on `gemini-3.1-pro-low`.
- **Resolution**: Google Pro models have an 8,192 token limit. Flash models allow 65,536. `config.yaml` is calibrated to `8192` for `gemini-3.1-pro-low`.

### 4. Upstream Endpoint Prioritization
- **Resolution**: Connected preview accounts utilize `https://daily-cloudcode-pa.googleapis.com` where full quota is allocated, with automatic fallback to `https://cloudcode-pa.googleapis.com`.
