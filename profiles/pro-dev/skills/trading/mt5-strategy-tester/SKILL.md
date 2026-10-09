---
name: mt5-strategy-tester
description: "Use when running headless backtests in MetaTrader 5 Strategy Tester, generating test configs, and parsing performance metrics."
version: 1.0.0
category: trading
---

# MetaTrader 5 Strategy Tester Automation

Automate the MT5 headless strategy tester to execute reproducible backtests and extract quantitative audit reports.

## Tester Configuration (`tester.ini`)

Create a configuration file to launch the MT5 Strategy Tester non-interactively:

```ini
[Tester]
Expert=Experts\MyStrategy.ex5
Symbol=EURUSD
Period=M15
Deposit=10000
Currency=USD
Leverage=1:100
Model=4
ExecutionMode=0
Optimization=0
FromDate=2024.01.01
ToDate=2025.01.01
Report=reports\backtest_eurusd_2024.htm
ReplaceReport=1
ShutdownTerminal=1
Visual=0
```

* **Model Options**:
  * `0`: Every tick (algorithmic generation)
  * `1`: 1 minute OHLC
  * `2`: Open prices only
  * `3`: Mathematical calculations
  * `4`: Every tick based on real ticks (highest precision, required for scalping/intraday)

## CLI Launch Command

Execute the tester headlessly from terminal:

```bash
# Five Percent Online MT5:
"C:\Program Files\Five Percent Online MetaTrader 5\terminal64.exe" /config:"workspace\tester.ini"
```

## Parsing Report Metrics

Extract and parse the generated report:
- **Total Net Profit**: Raw capital return.
- **Profit Factor**: Gross Profit / Gross Loss (require >= 1.5).
- **Max Equity Drawdown %**: Peak-to-trough decline (must conform to prop firm limits, e.g. < 5-8%).
- **Expected Payoff**: Average win/loss per trade in currency.
- **Total Trades**: Statistical validity threshold (minimum 100+ trades).
- **Sharpe Ratio / Recovery Factor**: Risk-adjusted return consistency.
