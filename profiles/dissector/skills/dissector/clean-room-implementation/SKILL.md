---
name: clean-room-implementation
description: Use when synthesizing idiomatic open-source codebases based strictly on SIR contracts and conformance test harnesses.
---

# Clean-Room Implementation: Test-Driven FOSS Synthesis

Synthesize clean-room open-source implementations in modern, memory-safe languages (Rust, Go, TypeScript) strictly from declarative specifications.

## Operating Constraints
- The synthesizer operates in a clean workspace with ZERO access to target binaries or disassemblers.
- Synthesizer consumes ONLY `contracts/` (SIR) and `fixtures/` (test harness).

## Synthesis Pipeline
1. **Core Serialization:** Data models, serialization/deserialization logic, validations.
2. **Storage Layer:** Database migrations and persistence drivers.
3. **Transport Engine:** Client/Server networking handlers (HTTP, WebSocket, gRPC).
4. **State Machine Logic:** Business workflow handlers passing all conformance tests.
5. **Continuous Verification:** Run the conformance test suite until 100% of fixtures pass.
