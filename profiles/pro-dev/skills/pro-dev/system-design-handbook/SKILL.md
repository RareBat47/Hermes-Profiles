---
name: system-design-handbook
description: Use when architecting distributed systems, designing database schemas, and planning scale/concurrency.
---

# System Design Handbook: Distributed Scalability

Distilled from Martin Kleppmann (*Designing Data-Intensive Applications*) and Alex Xu (*System Design Interview*).

## Core Models
- **Back-of-the-Envelope Math:** Automatic sizing of QPS, storage throughput, and RAM before choosing storage.
- **Idempotency by Default:** Survives network retries using client idempotency keys and unique schema constraints.
- **Caching Topologies:** Cache-aside vs. write-back queues to isolate burst writes from database disks.

## Linked Reference Playbooks
- `references/back-of-the-envelope.md` — Quick capacity estimation calculations.
- `references/idempotency-protocol.md` — Safe retry and deduplication specification.
- `references/caching-topologies.md` — Cache patterns and write-buffer decision tree.
