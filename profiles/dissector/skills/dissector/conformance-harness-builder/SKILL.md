---
name: conformance-harness-builder
description: Use when generating an automated, executable conformance test suite and mock server from the SIR and recorded traffic.
---

# Conformance Harness Builder: Golden Test Vector Generation

Before writing any production code in the Clean Room, synthesize an executable test harness loaded with captured golden session fixtures.

## Procedure
1. Generate test suite in the target language (PyTest, Go `testing`, or Vitest).
2. Convert recorded network and IPC payload traces into parametrized test fixtures:
   - `Given Input Payload A -> Verify Output Payload matches Contract Schema B`
   - `Given Malformed Payload C -> Verify Error Code matches E4019`
3. Package an offline mock server emulator that replays golden responses for client testing.
4. Ensure the test harness is completely runnable in an isolated sandbox.
