# Idempotency Protocol (Kleppmann / DDIA Doctrine)

Any mutating operation over an unreliable network MUST be idempotent to survive retries.

## The Idempotency Checklist
1. **Idempotency Keys:** Every POST/PUT mutation accepts a client-generated UUID in headers (`Idempotency-Key`).
2. **Atomic Lock/Upsert:** 
   - Store incoming key with status `PROCESSING` in Redis or Postgres with a TTL.
   - If key exists and status is `COMPLETED`, immediately return cached response.
   - If key exists and status is `PROCESSING`, return HTTP 409 (Conflict) or wait.
3. **Unique Database Constraints:** Never rely on application-level checks to prevent duplicates. Enforce unique index at schema level.
