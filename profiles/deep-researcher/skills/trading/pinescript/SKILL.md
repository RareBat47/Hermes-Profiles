---
name: pinescript
 description: Validate Pine Script strategies with Python fixtures.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows, linux, macos]
metadata:
  hermes:
    tags: [pinescript, trading, backtesting, ohlcv]
    related_skills: [csharp-ctrader, systematic-debugging]
---

# Pine Script

Generate Pine Script with an explicit `//@version=5` header and test signal assumptions against deterministic OHLCV fixtures before publishing to TradingView.

## Procedure

1. Check that the first non-empty line is exactly `//@version=5`.
2. Review series indexing, lookahead, session behavior, and order timing.
3. Build a small Python fixture or use the project's backtester to feed simulated OHLCV data.
4. Assert expected entries, exits, and array bounds.
5. Compare the Python model with TradingView behavior on representative edge cases.

## Pitfalls

- A Python approximation is not TradingView's execution engine.
- Avoid lookahead bias and document commission, slippage, and bar-close assumptions.
- Never treat backtest profit as evidence of future performance.

## Verification

The version guard passes, fixtures exercise both signals and no-signal paths, and the strategy's assumptions are documented.
