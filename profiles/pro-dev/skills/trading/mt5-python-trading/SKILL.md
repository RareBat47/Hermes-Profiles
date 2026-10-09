---
name: mt5-python-trading
description: "Use when executing live or demo trades, streaming market data, or managing orders via MetaTrader 5 Python API."
version: 1.0.0
category: trading
---

# MetaTrader 5 Python Trading

Operational guide for connecting to MetaTrader 5 (MT5), retrieving live market data, placing and managing orders, and auditing trade positions via the official `MetaTrader5` Python library.

## Terminal Initialization & Connection

Always initialize the terminal and check connectivity before executing trading actions:

```python
import MetaTrader5 as mt5

# Initialize connection (can optionally specify path, login, server, password)
if not mt5.initialize():
    print("MT5 initialization failed:", mt5.last_error())
    quit()

# Verify terminal and account info
term_info = mt5.terminal_info()
account_info = mt5.account_info()

if not term_info.connected:
    print("Terminal is not connected to broker server.")
```

## Market Data & Symbol Inspection

Never send orders without verifying symbol properties (contract size, tick size, min/max volume, volume step, margin requirements):

```python
symbol = "EURUSD"
if not mt5.symbol_select(symbol, True):
    print(f"Failed to enable {symbol}")

info = mt5.symbol_info(symbol)
tick = mt5.symbol_info_tick(symbol)

# Retrieve historical bars
rates = mt5.copy_rates_from_pos(symbol, mt5.TIMEFRAME_M15, 0, 500)
```

## Order Execution Discipline

All orders must specify a magic number, explicit SL/TP, and respect broker filling modes:

```python
lot = 0.10
point = mt5.symbol_info(symbol).point
price = mt5.symbol_info_tick(symbol).ask
deviation = 20
magic_number = 100101

request = {
    "action": mt5.TRADE_ACTION_DEAL,
    "symbol": symbol,
    "volume": lot,
    "type": mt5.ORDER_TYPE_BUY,
    "price": price,
    "sl": price - 150 * point,
    "tp": price + 300 * point,
    "deviation": deviation,
    "magic": magic_number,
    "comment": "mt5-trader entry",
    "type_time": mt5.ORDER_TIME_GTC,
    "type_filling": mt5.ORDER_FILLING_IOC,
}

# Pre-flight check
check_result = mt5.order_check(request)
if check_result.retcode != 0:
    print(f"Order check failed: {check_result.comment}")
else:
    result = mt5.order_send(request)
    print(f"Order sent. Retcode: {result.retcode}, Order Ticket: {result.order}")
```

## Position Audit & Cleanup

Query active positions filtered by magic number or symbol:

```python
positions = mt5.positions_get(symbol=symbol)
for pos in positions:
    if pos.magic == magic_number:
        print(f"Ticket: {pos.ticket}, Profit: {pos.profit}, Volume: {pos.volume}")
```
