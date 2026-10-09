---
name: rapid-spike
description: Use when evaluating unknown APIs, validating third-party SDKs, or measuring latency before building.
---

# Rapid Spike: Throwaway Validation

Never commit architectural plans to unverified third-party libraries or unknown APIs.

## Spike Rules
1. **Timeboxed:** Max 20 minutes per spike.
2. **Throwaway:** Write code in temporary scratch scripts, not project files.
3. **Specific Question:** Each spike must answer exactly ONE question:
   - Does this API return the payload we expect?
   - What is the p95 latency of this model endpoint?
   - Does this library run cleanly on Windows 11?
4. **Document Verdict:** Record pass/fail verdict and token/latency metrics before proceeding.
