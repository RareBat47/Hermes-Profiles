---
name: antigravity-routing
description: Explains how the Antigravity Gateway routes models, performs weighted health/quota selection, and isolates rate-limit cooldowns.
---

# Antigravity Routing Skill

## Purpose
Enables Hermes Agent to understand model mapping, model family distinctions, and the gateway's automatic account scheduler.

## Operating Principle
Hermes does **not** choose which Antigravity account to call. Hermes only requests a model:
```json
{"model": "gemini-3.5-flash", "messages": [...]}
```
The gateway dynamically selects the highest-scoring eligible account using the hybrid formula:
$$\text{Score} = (\text{Health} \times 2) + (\text{Tokens} \times 5) + (\text{Quota} \times 3) + (\text{LRU} \times 0.1)$$

## Supported Models

| OpenAI Model Alias | Upstream Antigravity Model | Family | Capabilities | Max Output Tokens |
| :--- | :--- | :--- | :--- | :--- |
| `gemini-3.5-flash` | `gemini-3.5-flash-low` | Gemini | Streaming, Tools, Vision, Thinking | 65,536 |
| `gemini-3.1-pro` | `gemini-3.1-pro-low` | Gemini | Streaming, Tools, Vision, Thinking | 65,536 |
| `gemini-3-flash` | `gemini-3-flash` | Gemini | Streaming, Tools, Vision | 32,768 |
| `claude-sonnet-4-6` | `claude-sonnet-4-6` | Claude | Streaming, Tools, Vision | 16,384 |
| `claude-opus-4-6` | `claude-opus-4-6-thinking` | Claude | Streaming, Tools, Vision, Thinking | 16,384 |

## Isolated Cooldown Behavior
- When an account receives HTTP 429 on `claude-sonnet-4-6`, only its `claude` family is placed on cooldown.
- The same account remains 100% active and healthy for `gemini-3.5-flash` and `gemini-3.1-pro`.
- Cooldown backoff follows progressive tiers: 60s -> 300s -> 1800s -> 7200s.

## Commands to Inspect Active Cooldowns
```bash
curl -s -H "Authorization: Bearer $ADMIN_API_KEY" http://127.0.0.1:8999/admin/cooldowns
```
Or via CLI:
```bash
agw health
```
