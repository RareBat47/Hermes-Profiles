---
name: project-tracker
description: "Use when developing or tracking hobby projects, managing STATE.md ledgers, and packaging curated table updates."
version: 1.0.0
category: software-development
---

# Project Tracker & Development Curator

Systematic methodology for adapting to diverse hobby codebases, maintaining lightweight project state ledgers, and delivering curated "table updates" that highlight new capabilities, verification steps, and future options.

## When to Use

- Starting or continuing development on any personal/hobby repository.
- Scaffolding new features or refactoring existing modules.
- Updating or reconstructing the project's living development ledger (`STATE.md`, `CHANGELOG.md`).
- Packaging an updated version of a project for presentation to the user.

---

## Phase 1 — Auto-Adaptation & Stack Discovery

Before modifying code or proposing features, inspect the project environment without assumptions:

1. **Manifest Inspection:**
   - Node/Web: `package.json`, `tsconfig.json`, `vite.config.*`, lockfiles.
   - Python: `pyproject.toml`, `requirements.txt`, `Pipfile`, virtual environments.
   - Rust: `Cargo.toml`.
   - Go: `go.mod`.
   - Other: `Makefile`, `docker-compose.yml`, scripts directory.
2. **Execution Context:** Identify how the project builds, runs, tests, and lints.
3. **Existing State:** Check for existing `STATE.md`, `README.md`, or architecture notes. If none exist, initialize `STATE.md` using the template below.

---

## Phase 2 — The Living Development Ledger (`STATE.md`)

Maintain a lightweight, high-signal `STATE.md` at the project root. This ensures continuity across sessions and enables rapid context reload.

### `STATE.md` Structure:
```markdown
# Project State & Evolution Ledger

**Project:** <Name>
**Current Version:** v<X.Y.Z> (or milestone tag)
**Status:** <Active Prototyping | Stabilizing | Feature Complete>
**Last Updated:** <Date / Commit>

## Current Working Capabilities
- Feature 1: <Brief description of what works right now>
- Feature 2: <Brief description>

## Active Milestone / In Progress
- [ ] Subtask A
- [x] Subtask B (Completed)

## Architecture & Tech Stack Notes
- **Runtime / Framework:** <e.g., FastHTML / Tailwind / SQLite>
- **Key Decisions:** <Brief list of lightweight ADRs / choices made>

## Verification Baseline
- Run Command: `<command>`
- Test Command: `<command>`
```

---

## Phase 3 — Iterative Development & Verification Gate

1. **Micro-Milestones:** Work in focused, cohesive increments rather than large unverified rewrites.
2. **Verify Before Declaring Complete:**
   - Execute the project's build, linter, or tests.
   - If UI or web-based, verify page generation or server startup on a local port.
   - Capture real command output — never fabricate verification results.

---

## Phase 4 — Curated "Table Update" Delivery

When presenting an updated version or milestone back to the user, package the delivery using the **Table Update Format**:

```markdown
### 🚀 Project Update: <Project Name> [vX.Y.Z / Milestone Name]

#### 1. What's Landed
- **<Key Feature / Change>**: <What was added or improved and why it matters.>
- **<Key Feature / Change>**: <Details.>

#### 2. Verification & How to Try It
- **Run Locally:**
  ```bash
  <exact command to launch or test>
  ```
- **Verification Evidence:**
  - Build/Tests: `<Command passed: e.g. 12/12 tests passing>`
  - Output / Behavior: `<What to expect when running>`

#### 3. Updated Ledger
- `STATE.md` updated with latest milestone progress.
- `CHANGELOG.md` entry appended under `[Unreleased]` or current release.

#### 4. The Road Ahead (Pick Your Next Step)
1. **Option A:** <Immediate next logical capability or enhancement>
2. **Option B:** <Alternative UX/styling or architecture polish>
3. **Option C:** <Deployment / packaging / standalone distribution>
```

This format gives the user immediate visibility into what was accomplished, how to inspect it on their machine, and clear agency over the next iteration.
