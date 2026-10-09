---
name: sir-synthesis
description: Use when compiling dynamic traces and static structural data into a neutral Specification Intermediate Representation (SIR).
---

# SIR Synthesis: The Clean-Room Contract Boundary

Act as the formal air gap between the Dirty Room (analysis) and Clean Room (synthesis).

## Output Deliverables
1. `contracts/api.openapi.yaml`: Full REST, WebSocket, or gRPC endpoint contracts.
2. `contracts/models.proto`: Binary serialization data definitions.
3. `contracts/state-machine.md`: Mermaid sequence diagrams mapping event responses.
4. `fixtures/golden-traces/`: Anonymized, sanitized request-response payload pairs.

## Air-Gap Verification Checklist
- [ ] ZERO decompiled proprietary code exists in the SIR.
- [ ] ZERO disassembler-generated internal variable names are present.
- [ ] All schemas represent functional interface contracts strictly for interoperability.
