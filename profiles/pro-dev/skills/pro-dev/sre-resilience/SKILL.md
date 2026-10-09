---
name: sre-resilience
description: Use when implementing circuit breakers, failover fallbacks, telemetry, and zero-downtime demo guards.
---

# SRE & Resilience: Zero-Downtime Live Demos

Distilled from Google SRE and Michael Nygard (*Release It!*).

## Core Models
- **Live Demo Fallback Protocol:** 2.5s timeouts with deterministic cached fallbacks so live demos never hang.
- **Circuit Breakers:** Fast-fail failing external services to protect UI responsiveness.
- **Bulkheads:** Isolate failure domains to prevent whole-system crashes.

## Linked Reference Playbooks
- `references/live-demo-fallback.md` — Zero-crash live demo architecture.
- `references/circuit-breaker-states.md` — Resilience state machine and failure thresholds.
