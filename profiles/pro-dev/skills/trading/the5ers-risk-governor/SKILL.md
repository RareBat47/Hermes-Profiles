---
name: the5ers-risk-governor
description: "Use when checking The5ers prop firm account health, enforcing daily pause limits, loss allowances, and consistency rules via MCP."
version: 1.0.0
category: trading
---

# The5ers Risk Governor & MCP Protocol

Operational guidelines for querying The5ers remote MCP (`https://mcp.the5ers.com/mcp`) to enforce risk budgets, drawdown limits, and consistency requirements on MT5 trading.

## Authoritative MCP Tools

The profile has access to 12 The5ers tools:
1. `the5ers_account`:
   - `list`: Get opaque `account_ref` for active accounts.
   - `balance`: Real-time balance and equity.
   - `health`: Consolidated status, remaining daily-loss and max-loss allowance.
   - `midnight_history`: Daily closed history and starting balance baseline.
2. `the5ers_program`:
   - `rules`: Max loss %, daily loss %, daily pause %, profit targets, and leverage.
3. `the5ers_consistency`:
   - `list`: Measured values for account consistency caps.
4. `the5ers_positions`:
   - Audit current fills and exposure on the funded account.

## Pre-Trade Risk Gating Sequence

Before executing any order on an MT5 account linked to The5ers:

1. **Query Account Health**:
   - Call `the5ers_account` with `operation: "health"`.
   - Read `dailyLossRemaining` and `maxLossRemaining`.
2. **Evaluate Daily Buffer**:
   - If `dailyLossRemaining <= 0` or account is in `dailyPause`, block all new order submissions immediately.
   - Limit individual trade risk (Stop Loss dollar amount) to maximum 25% of remaining daily allowance.
3. **Check Consistency Constraints**:
   - Call `the5ers_consistency` with `operation: "list"`.
   - Ensure lot size and profit contribution do not breach the program's single-day consistency threshold.
4. **Emergency Circuit Breaker**:
   - If equity drops to within 0.5% of the daily pause limit, close open intraday positions and cancel pending orders.
