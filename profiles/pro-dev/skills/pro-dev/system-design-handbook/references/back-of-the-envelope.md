# Back-of-the-Envelope Estimation (Alex Xu Framework)

Before choosing databases, caches, or queues, calculate scale constraints.

## Estimation Constants
- 1 day = 86,400 seconds (~100,000 for quick calculation).
- 1 million requests/day ≈ 12 requests/second (QPS).
- Peak QPS ≈ 2x to 5x average QPS.
- Read/Write Ratios: typical web app is 10:1 (read-heavy).

## Calculation Template
1. **Throughput:**
   - Daily Active Users (DAU) * actions per user / 86,400 = Average QPS.
   - Peak QPS = Average QPS * 2.
2. **Storage:**
   - QPS * write ratio * payload size * 86,400 * 365 = 1-Year Storage Need.
3. **Memory / Cache:**
   - 80/20 Rule: 20% of data generates 80% of reads. Cache 20% of daily active read data in RAM.
