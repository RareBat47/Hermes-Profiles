---
name: rapid-mvp-development
description: "Use when building MVPs or hackathon apps under deadlines."
version: 1.0.0
category: software-development
---

# Rapid MVP Development

Execute high-velocity software builds for hackathons, competitive sprints, and proof-of-concept deliverables. Synthesizes principles from YC office hours forcing questions, Karpathy simplicity guidelines, and multi-agent wave orchestration.

## When to use

- Building a new product, app, or major feature from scratch under tight deadlines (< 24-48 hours).
- Hackathon projects where working software and demonstrable UI beat speculative architecture.
- Scoping and executing the "narrowest working wedge" of a complex vision.

## Phase 1 — Problem Reframing & Scope Forcing (Pre-Code)

Before writing any code or scaffolds, run the 5 forcing questions:

1. **What is the single core user flow?** (One sentence: Actor -> Action -> Value).
2. **What is the narrowest working wedge?** Strip all secondary features (e.g. social auth, multi-tenancy, complex settings, billing). Ship the core transaction first.
3. **What can be mocked or bypassed safely?** Hardcode non-critical constants, use local SQLite/PGLite instead of hosted cloud DBs, use mock auth if auth is not the core product.
4. **What is the demo moment?** Identify the exact 30-second interaction that proves the product works. Optimize the entire sprint towards this interaction.
5. **Simplicity check (Karpathy principle):** Does this architecture require more than 3-5 core files to prove the point? If yes, simplify.

## Phase 2 — Architectural Blueprint & File Boundary Lock

Map the stack to battle-tested primitives:

1. **Stack selection:** Pick familiar, zero-boilerplate frameworks (Next.js / Vite + React / FastAPI / Express).
2. **File boundary definition:** Explicitly declare which files own which domain (e.g., `server.ts`, `client.tsx`, `db.ts`).
3. **Pessimistic concurrency rule:** If delegating tasks to subagents, ensure no two subagents are assigned the same file simultaneously. Assign one cohesive module per subagent.

## Phase 3 — Wave Execution Cycle

Execute in disciplined sequential waves:

### Wave 1: The Spike & Data Core
- Stand up the data schema and mock data generators.
- Implement the core algorithmic or API logic.
- Run a 1-minute sanity test in terminal to verify input -> output correctness.

### Wave 2: The Functional Backbone
- Wire endpoints or service handlers to the data core.
- Verify through automated curl/fetch tests or minimal unit tests.
- **Karpathy Surgical Rule:** Touch only what was planned. Zero drive-by refactoring or unused generic abstractions.

### Wave 3: The Interactive Surface & UI
- Build the client interface. Prioritize layout readability, responsive flow, and instant visual feedback over intricate design tokens.
- Hook client inputs directly to Wave 2 endpoints.

## Phase 4 — Browser Verification & Smoke Test

Never declare an MVP complete based solely on compilation:

1. Launch local dev server in background with health check verification.
2. Use browser execution (`browser_exec`) to open `http://localhost:<port>`.
3. Inspect the DOM, verify that no uncaught JavaScript console errors or 500 API responses fired.
4. Click through the primary user path to confirm the demo moment works end-to-end.

## Phase 5 — Pre-Flight Security & Delivery Gate

Before committing or presenting:

1. **Secret scan:** Confirm zero API keys, personal access tokens, or private endpoints are hardcoded in source files (run `agentshield scan` or ripgrep regex check).
2. **Clean run:** Ensure `.env.example` documents required environment variables.
3. **Demo script:** Produce a 3-bullet manual walk-through so any judge or user can test the app immediately.

## Pitfalls & Anti-Patterns

- **Building auth first:** Spending 4 hours configuring OAuth/Supabase/Clerk when the product is an AI analysis engine. Use mock user sessions until the core engine works.
- **Over-abstracting single-use logic:** Creating generic interfaces, factory functions, and polymorphic classes for code that is only called once. Write direct, procedural code first.
- **Unverified success claims:** Claiming the frontend works without testing it in a real headless browser session.
- **Silent subagent collision:** Allowing parallel worker subagents to edit `package.json` or shared routers at the same time, resulting in merge conflicts or overwritten code.
