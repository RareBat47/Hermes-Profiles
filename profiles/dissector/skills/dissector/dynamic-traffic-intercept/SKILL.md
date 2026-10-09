---
name: dynamic-traffic-intercept
description: Use when intercepting and reconstructing network wire protocols, WebSocket frames, and RPC channels into declarative schemas.
---

# Dynamic Traffic Intercept: Wire & RPC Protocol Extraction

Capture, decrypt, and decode network transit without relying on static code decompilation.

## Procedure
1. Deploy local interceptor via `mitmproxy` on 127.0.0.1:8080 with TLS CA injection.
2. Intercept target application traffic across HTTP/1.1, HTTP/2, WebSocket, and gRPC channels.
3. Parse binary wire protocols (Protobuf, MessagePack, FlatBuffers, custom TLV formats).
4. Record request/response bodies into sanitized golden traces (`fixtures/golden-traces/`).
5. Extract JSON schemas, parameter constraints, and authentication token workflows into OpenAPI 3.1 definitions.
