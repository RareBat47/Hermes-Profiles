# Caching Topologies & Write Buffers

Choose the simplest caching topology that satisfies the latency SLA.

## Topologies
1. **Cache-Aside (Lazy Loading):**
   - Read: check cache -> on miss, read DB -> write to cache -> return.
   - Write: write to DB -> invalidate cache key.
   - Use for: general read-heavy application data.
2. **Write-Through:**
   - Write to cache and DB simultaneously. High write latency, zero stale reads.
3. **Write-Behind (Write-Back Buffer):**
   - Write to in-memory queue/Redis -> acknowledge immediately -> batch flush to Postgres asynchronously.
   - Use for: high-frequency real-time events (ticks, analytics, telemetry).
