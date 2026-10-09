---
name: mt5-genetic-backtesting
description: "Use when performing genetic algorithm parameter optimization, walk-forward analysis, and out-of-sample robustness testing in MT5."
version: 1.0.0
category: trading
---

# MetaTrader 5 Genetic Backtesting & Optimization

Guide for executing fast, multi-parameter Genetic Algorithm (GA) optimizations and robustness validation in MetaTrader 5 without curve-fitting.

## Optimization Configuration in `tester.ini`

To run Genetic Algorithm optimization in MT5 Strategy Tester:

```ini
[Tester]
Expert=Experts\MyStrategy.ex5
Symbol=GBPUSD
Period=H1
Deposit=10000
Currency=USD
Leverage=1:100
Model=1
Optimization=2
OptimizationCriterion=6
ForwardMode=1
ForwardDate=2024.06.01
FromDate=2023.01.01
ToDate=2024.12.31
Report=reports\ga_optimization.htm
ReplaceReport=1
ShutdownTerminal=1
Visual=0

[TesterInputs]
FastMA=10||5||50||20||Y
SlowMA=50||10||200||100||Y
RSI_Period=14||2||28||14||N
RiskPercent=1.0||0.5||2.5||1.0||Y
```

### Parameter Format:
`ParamName = Start || Step || Stop || DefaultValue || EnabledFlag`
- EnabledFlag: `Y` to include in genetic optimization, `N` to freeze.

### Optimization Criterion:
- `0`: Balance max
- `1`: Profit Factor max
- `2`: Expected Payoff max
- `3`: Minimal Drawdown
- `4`: Maximal Sharpe Ratio
- `6`: Complex Criterion (Balance * Trades * Sharpe / Drawdown)

## Anti-Overfitting & Robustness Protocol

1. **In-Sample (IS) / Out-of-Sample (OOS) Split**:
   - Optimize parameters strictly on IS (e.g. 70% of historical timeframe).
   - Validate top parameter sets on OOS without re-tuning.
2. **Walk-Forward Analysis (WFA)**:
   - Roll forward windows (e.g. 6-month train, 2-month test).
   - Calculate Walk-Forward Efficiency (WFE = Annualized Return OOS / Annualized Return IS). Strategies with WFE < 50% are rejected.
3. **Parameter Plateau vs Spike**:
   - Reject high-fitness parameters that sit on narrow isolated spikes in parameter space.
   - Accept only parameter clusters where neighboring step values also yield robust positive expectancy.
