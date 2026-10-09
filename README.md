# 🚀 Hermes-Profiles

> Production-grade, autonomous specialist profiles for **Hermes Agent** (by Nous Research):
> - 🔍 **Dissector**: Autonomous Clean-Room Interoperability, Dynamic Binary Tracing & Open-Source Reconstruction
> - 🔬 **Deep Researcher**: Evidence-First Deep Web, Academic Literature, GitHub & Intelligence Reconnaissance
> - ⚡ **Pro-Dev**: Autonomous Full-Stack Software Factory, Karpathy Surgical Guidelines & Hackathon MVP Champion

---

## 📋 Table of Contents
1. [Overview & Profile Matrix](#-overview--profile-matrix)
2. [Quickstart: Installation](#-quickstart-installation)
3. [Profile 1: Hermes Dissector](#1--hermes-dissector)
4. [Profile 2: Hermes Deep Researcher](#2--hermes-deep-researcher)
5. [Profile 3: Hermes Pro-Dev](#3--hermes-pro-dev)
6. [Tools & Native MCP Client Setup](#-tools--native-mcp-client-setup)
7. [Model Providers & Antigravity Gateway Setup](#-model-providers--antigravity-gateway-setup)
8. [Token Optimization & Lean Context](#-token-optimization--lean-context)
9. [Verification & Health Checks](#-verification--health-checks)

---

## 🌟 Overview & Profile Matrix

Each profile is an isolated, autonomous runtime with its own **Constitution (`SOUL.md`)**, **Metadata (`profile.yaml`)**, **Specialized Skill Suite (`skills/`)**, **Toolset / MCP Configuration (`config.yaml`)**, and **Starter Scaffolding (`workspace/`)**.

| Profile | Core Doctrine | Key Specialist Mindsets | Native MCP Tools |
|---|---|---|---|
| **Dissector** | Strict Two-Room Clean-Room Isolation (Air Gap) | Protocol Lead, Frida Snoop, SIR Architect, FOSS Synthesizer | Filesystem, SQLite, Fetch |
| **Deep Researcher** | Evidence-First Provenance & Claim Verification | Open Web Investigator, Academic Reviewer, Citation Auditor | Brave Search, Fetch, Puppeteer, GitHub |
| **Pro-Dev** | Outcome Ownership & Karpathy Surgical Rules | Lead Architect, YC Strategist, Surgical Coder, Browser QA | GitHub, Filesystem, Postgres/DB |

---

## ⚡ Quickstart: Installation

Clone this repository and run the automated installer for your operating system.

```bash
git clone https://github.com/RareBat47/Hermes-Profiles.git
cd Hermes-Profiles
```

### Option A: Linux, macOS, or Git Bash (One-Liner)
```bash
./install.sh
```
*Or install a specific profile:*
```bash
./install.sh pro-dev
```

### Option B: Windows PowerShell
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\install.ps1
```

### Option C: Manual Copy
Copy the folders under `profiles/` directly into your Hermes profiles directory:
- **Linux/macOS:** `~/.hermes/profiles/<profile_name>`
- **Windows:** `%LOCALAPPDATA%\hermes\profiles\<profile_name>`

---

## 1. 🔍 Hermes Dissector

**Purpose:** Reverse engineering closed-source protocols and applications to build legal, maintainable, clean-room open-source implementations without IP contamination.

### Two-Room Strict Separation Principle
```
┌─────────────────────────────────┐       ┌─────────────────────────────────┐
│           DIRTY ROOM            │       │           CLEAN ROOM            │
│      (workspace/dirty_room)     │       │      (workspace/clean_room)     │
├─────────────────────────────────┤       ├─────────────────────────────────┤
│ • Binary reverse engineering    │       │ • Zero decompiled code          │
│ • mitmproxy / packet captures   │  SIR  │ • Pure FOSS synthesis           │
│ • Frida dynamic function hooks  │──────>│ • Behavioral TDD implementation │
│ • SQLite mutation analysis      │       │ • Golden test validation        │
└─────────────────────────────────┘       └─────────────────────────────────┘
```

### Key Specialized Skills
- `dissector/clean-room-implementation`: Pure implementation workflows adhering to copyright boundaries.
- `dissector/conformance-harness-builder`: Differential parity test suites matching golden traffic.
- `dissector/dynamic-traffic-intercept`: mitmproxy / Wireshark capture analysis.
- `dissector/frida-runtime-hooking`: Dynamic inspection of running processes and function parameters.
- `dissector/sir-synthesis`: Compiling observed behavior into Specification Intermediate Representation (OpenAPI/Protobuf).
- `dissector/static-contract-extractor`: Structural header and interface parsing.

---

## 2. 🔬 Hermes Deep Researcher

**Purpose:** Exhaustive, evidence-grounded research across open web, GitHub codebases, ArXiv scientific literature, and technical documentation.

### Core Research Rules
1. **Search snippets are NOT evidence:** Deep Researcher navigates directly to source pages, extracts exact text passages, and evaluates authenticity.
2. **Provenance Ledger:** Every material claim includes a source URL, publisher, date, and exact quote or timestamp.
3. **Contradiction Detection:** Surfaces conflicting data between sources rather than silently resolving differences.
4. **Inter-Profile Consultation:** Other Hermes profiles can delegate bounded research jobs to Deep Researcher via the `research-consultation` skill:
   ```bash
   hermes -p deep-researcher chat "Produce an evidence brief on distributed consensus benchmarks"
   ```

### Key Specialized Skills
- `research-consultation`: Structured cross-profile consultation protocol.
- `arxiv`: Academic literature exploration and PDF inspection.
- `competitor-news-monitor`: Material news scanning and business reconnaissance.
- `grounded-citations`: Verified citation generation with exact page references.
- `llm-wiki`: Personal and project knowledge base compilation.
- `youtube-content`: Video transcript retrieval, timestamped citations, and analysis.

---

## 3. ⚡ Hermes Pro-Dev

**Purpose:** Autonomous full-stack software factory for high-velocity hackathons, surgical TDD development, real browser QA, and resilient system engineering.

### The 4 Canonical Laws (Karpathy Guidelines)
1. **Think Before Coding:** Never make silent assumptions. Invoke the Ambiguity Protocol before modifying code.
2. **Simplicity First (Anti-Bloat):** Minimum code that completely solves the problem. Enforce Ousterhout's Deep Module principle (deep interfaces, simple surfaces).
3. **Surgical Changes:** Touch only what was asked. Zero drive-by refactoring. Clean up introduced orphans immediately.
4. **Goal-Driven Test Verification:** Automated check loops. Real verification requires exercise (live endpoints, CLI execution, or visual/DOM confirmation).

### Hackathon Velocity Rules
- **Hour 0–2 Tracer Bullet:** Fire an end-to-end thin vertical slice (UI -> API -> DB) before adding breadth.
- **Facade Prototyping:** 100% polished happy path with deterministic fallbacks for stage demos.
- **Real Browser QA:** Live DOM verification and automated console error capture.
- **AgentShield Audit:** Pre-commit scanning for secrets and vulnerabilities.

### Key Specialized Skills
- `pro-dev/orch-build-mvp`: End-to-end MVP architecture and execution orchestrator.
- `pro-dev/hackathon-mastery`: Rapid hackathon wedge selection, judging alignment, and demo protection.
- `pro-dev/karpathy-guidelines`: Surgical code modification and anti-bloat enforcement.
- `pro-dev/agentic-browser-qa`: Real browser testing and screenshot verification.
- `pro-dev/agentshield-audit`: Security auditing for credentials and vulnerabilities.
- `pro-dev/deslop-refactor`: Strip AI boilerplate, redundant wrappers, and decorative abstractions.
- `pro-dev/rapid-spike`: Throwaway spike experiments to validate high-risk assumptions.
- `pro-dev/sre-resilience`: Circuit breakers, rate limits, deterministic fallbacks.

---

## 🔌 Tools & Native MCP Client Setup

Hermes Agent has a built-in MCP client that connects to MCP servers on startup, discovers their tools, and injects them as first-class tools.

### Prerequisites
Install Python MCP support:
```bash
python -c "import pm; pm.sync_venv(['mcp'], explicit=True)"
# or: pip install mcp
```

### Pre-Configured MCP Presets

Each profile has a tailored `mcp_servers` configuration in its `config.yaml`:

- **Dissector:** `filesystem`, `sqlite`, `fetch`
- **Deep Researcher:** `brave_search`, `fetch`, `puppeteer`, `github`
- **Pro-Dev:** `github`, `filesystem`, `postgres`

See [`mcps/README.md`](mcps/README.md) for full configuration details and commands.

---

## 🤖 Model Providers & Antigravity Gateway Setup

All three profiles are pre-configured to work with either:
1. **Antigravity Gateway** (Local multi-account proxy at `http://127.0.0.1:8999/v1`):
   - `claude-opus-5-5-medium` (Opus / Planning / Architect)
   - `claude-sonnet-5-5-high` (Sonnet / Review / Debugging)
   - `gemini-3.8-flash-high` (Gemini 3.8 / Fast Coding)
   - `gemini-3.1-pro-low` (Gemini 3.1 Pro / Algorithm Validation)
2. **OpenRouter / Anthropic / OpenAI Direct APIs**:
   - Provide your API keys in `.env` (copied from `.env.example`).

To switch models dynamically during a conversation:
```
/model gemini-3.8
/model opus
/model sonnet
```

---

## 🧠 Token Optimization & Lean Context

Each profile includes token guardrails to keep agent context lean and responsive:
- **`strategic-compact`**: Intelligently summarizes earlier conversation turns without losing essential architectural state.
- **`context-budget`**: Monitors active prompt token footprint and alerts when approaching thresholds.
- **`lean-token-optimizer`**: Strips repetitive logs, stack traces, and verbose command output.

---

## 🩺 Verification & Health Checks

Verify your profiles after installation:

```bash
# Check profile health and tool discovery
hermes -p dissector doctor
hermes -p deep-researcher doctor
hermes -p pro-dev doctor

# List available skills for each profile
hermes -p dissector skills list
hermes -p deep-researcher skills list
hermes -p pro-dev skills list

# Launch an interactive chat session
hermes -p pro-dev
```

---

## 📄 License
MIT License. Created for collaborative AI engineering with Hermes Agent.
