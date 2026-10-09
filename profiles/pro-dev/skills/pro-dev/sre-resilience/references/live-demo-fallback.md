# Live Demo Fallback Protocol (Michael Nygard Doctrine)

During judging, conference Wi-Fi is congested and external LLM APIs experience rate limits. Your demo must be uncrashable.

## The 3-Tier Fallback Architecture
1. **Tier 1 (Live Primary):** Attempt real external API call with a strict **2.5-second timeout**.
2. **Tier 2 (Cached Pre-computation):** If Tier 1 exceeds 2.5s or returns HTTP 429/500, immediately return pre-seeded deterministic response.
3. **Tier 3 (Local Offline Mode):** Toggle flag `DEMO_OFFLINE_MODE=true` allowing the entire demo to run locally without internet connectivity.

## Fallback Rules
- NEVER let a UI display a raw stack trace or unhandled network exception.
- Add an error boundary around every interactive widget.
- Pre-seed test data in local SQLite or mock JSON files before demo rehearsal.
