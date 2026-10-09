# Circuit Breaker States & Telemetry

Prevent cascading failures across microservices or external APIs.

## States
1. **Closed (Normal):** Requests pass through. Track failure count over 10-second rolling window.
2. **Open (Tripped):** If failures exceed threshold (e.g. 3 consecutive errors), open circuit immediately. Requests fast-fail to fallback without hitting network.
3. **Half-Open (Probe):** After cooldown (e.g. 15 seconds), allow single probe request. If successful, reset to Closed; if fails, return to Open.
