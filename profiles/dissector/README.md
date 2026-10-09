# Hermes Dissector Profile

> **Autonomous Clean-Room Interoperability & Software Reconstruction System**

The **Hermes Dissector** profile analyzes closed-source binaries, network communications, and runtime APIs to synthesize idiomatic, legally sound, and 100% test-verified open-source software alternatives.

---

## Architecture & Operational Doctrine

### The Two-Room Strict Separation Principle
1. **DIRTY ROOM (`workspace/dirty_room/`):**
   - Inspects target binaries, sniffs network packets (mitmproxy/pcap), deploys Frida runtime hooks, and analyzes raw logs.
   - Outputs: Concrete data schemas, API contracts, golden payload captures.
   - **MANDATE:** Raw decompiled assembly or proprietary C/C++ code NEVER leaves this room.
2. **CLEAN ROOM (`workspace/clean_room/`):**
   - Synthesizes pure open-source code (Rust, Go, TypeScript, Python) strictly from Specification Intermediate Representation (SIR) contracts.
   - Finished only when passing 100% of golden behavioral fixtures.

### The 7 Coworker Personas
- **Dissector Lead (Orchestrator):** Scopes the project, controls room boundaries, gates data flow.
- **Protocol & Wire Engineer:** Intercepts REST, WebSockets, gRPC, Protobuf, and TLS traffic.
- **Dynamic Runtime SNOOP:** Hooks IPC pipes, SQLite state, and function parameters via Frida.
- **Static Structural Cartographer:** Extracts struct layouts, header offsets, and IDL schemas.
- **Specification Architect:** Compiles the Specification Intermediate Representation (SIR).
- **Clean-Room Synthesizer:** Writes pure FOSS implementations from SIR contracts.
- **Conformance & Fuzzing Lead:** Generates differential conformance tests and verifies parity.

---

## Included Skills

- `clean-room-implementation`: Pure implementation workflows without IP contamination.
- `conformance-harness-builder`: Synthesizes automated differential parity test suites.
- `dynamic-traffic-intercept`: Automated setup and parsing of mitmproxy / Wireshark streams.
- `frida-runtime-hooking`: Dynamic inspection of running processes and API arguments.
- `sir-synthesis`: Compiles observed protocols into formal OpenAPI / Protobuf specs.
- `static-contract-extractor`: Parses headers, schemas, and public signatures.
- `target-surface-recon`: Reconnaissance of endpoints, binaries, and IPC buses.
- `context-budget` & `lean-token-optimizer`: Minimizes orchestrator token consumption.

---

## Quick Start

```bash
# 1. Install or switch to dissector profile
hermes -p dissector

# 2. Check profile status & doctor
hermes -p dissector doctor

# 3. Start a dissection session
hermes -p dissector chat "Analyze target protocol in dirty_room and generate SIR contract"
```
