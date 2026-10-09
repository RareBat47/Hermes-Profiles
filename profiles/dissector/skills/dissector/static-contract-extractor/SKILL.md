---
name: static-contract-extractor
description: Use when extracting data models, struct layouts, and serialization definitions from compiled binaries without reading proprietary algorithms.
---

# Static Contract Extractor: Headless IDL & Schema Recovery

Extract interface contracts, struct field offsets, and serialization schemas while strictly discarding raw decompiled source code.

## Procedure
1. Execute headless extraction engines (`ghidra` headless scripts, `jadx`, `ILSpy`, `nornagon/asar`).
2. Extract exported header definitions, struct layouts, and database query strings.
3. Recover Protobuf descriptors, gRPC service stubs, or REST route decorators.
4. **Immediate Air-Gap Purge:** Convert extracted schemas into neutral IDL format (`.proto`, `.yaml`, `.json`) and discard raw decompiled assembly/code to preserve clean-room legal defensibility.
