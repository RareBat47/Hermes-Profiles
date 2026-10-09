---
name: orch-build-mvp
description: Use when building a new hackathon project, rapid MVP, or greenfield vertical slice.
---

# Orch Build MVP: The Hackathon Engine

Transform an approved specification into a verified, working MVP in structured, timeboxed execution waves.

## The 4-Wave Pipeline
1. **Wave 1: Tracer Bullet (Thin Vertical Slice)**
   - Wire a single path through all layers: UI -> API Route -> Controller -> Database/Service -> Live Output.
   - Purpose: prove structural connectivity before building feature breadth.
2. **Wave 2: Happy Path Engine**
   - Implement the core differentiator end-to-end.
   - Focus 80% of energy on the unique value proposition.
   - Mock or bypass peripheral features (multi-role RBAC, billing, settings).
3. **Wave 3: Real Browser & CLI Verification**
   - Launch app locally. Execute automated verification via `agentic-browser-qa` and `test-driven-development`.
   - Log visual and state proofs in `VERIFICATION.md`.
4. **Wave 4: Live Demo Fallback & Demo Script**
   - Seed deterministic mock data.
   - Add timeout circuit breakers to all external APIs.
   - Generate `RELEASE.md` and demo click-through runbook.
