---
name: frida-runtime-hooking
description: Use when deploying Frida instrumentation scripts to hook internal IPC, SQLite queries, and memory structures dynamically.
---

# Frida Runtime Hooking: Dynamic IPC & State Extraction

Extract internal data structures, IPC pipes, and storage operations at runtime using non-invasive memory instrumentation.

## Procedure
1. Attach to process by PID or application bundle name via `frida`.
2. Inject non-blocking JavaScript instrumentation on OS-level IPC functions (`WriteFile`, `send`, `recv`, Unix domain sockets).
3. Hook local database drivers (e.g. `sqlite3_step`, `sqlite3_prepare_v2`) to capture relational schemas and live SQL queries.
4. Intercept function arguments and serialize parameter schemas into structured JSON records.
5. Capture cryptographic tokens or ephemeral session keys in transit without modifying target executables.
