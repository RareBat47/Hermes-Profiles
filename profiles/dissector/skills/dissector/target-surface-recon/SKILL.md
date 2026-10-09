---
name: target-surface-recon
description: Use when analyzing closed-source binaries to determine runtime architecture, packing, language, and attack surface.
---

# Target Surface Recon: Analysis Surface Discovery

Analyze binary targets to identify compiler, runtime platform, packing status, and external interface boundaries before executing dynamic tracing.

## Procedure
1. Run binary identification: `file`, `strings`, `die` (Detect It Easy).
2. Check for packing or obfuscation (UPX, VMProtect, custom protectors).
3. Determine runtime platform: Native (C/C++/Rust/Go), Managed (.NET/JVM), or Hybrid (Electron/Node, React Native).
4. Map entry points, exported symbols, named pipes, network domains, and local storage files.
5. Generate initial assessment report detailing the recommended dynamic interception strategy.
