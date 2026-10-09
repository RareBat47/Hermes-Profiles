---
name: ctrader-csharp-net
description: "Use when building C# .NET cTrader Open API 2.0 bots. Implement Open API Protobuf connections, reactive streams, orders, and market feeds."
version: 1.0.0
category: trading
metadata:
  hermes:
    tags: [ctrader, csharp, dotnet, openapi, trading-bot, protobuf, rx]
---

# cTrader C# .NET Open API Bot Development

Use this skill when developing, compiling, and running headless cTrader trading bots in C# (.NET 8+) on Linux Ubuntu using cTrader Open API 2.0.

## Overview & Architecture

cTrader Open API 2.0 communicates via Google Protocol Buffers (Protobuf) over an encrypted TLS TCP socket. It runs natively on Linux without requiring Wine or cTrader Desktop.

- **Demo Host:** `demo.ctraderapi.com` (Port `5035`)
- **Live Host:** `live.ctraderapi.com` (Port `5035`)
- **Library:** `OpenAPI.Net` (NuGet) or custom `TcpClient` + `SslStream` + compiled Google.Protobuf contracts (`openapi-proto-messages`).

## Project Setup (.NET 8 on Linux)

Create a worker daemon project:
```bash
dotnet new worker -n CTraderBot
cd CTraderBot
dotnet add package OpenAPI.Net
# Or if using raw Protobuf:
dotnet add package Google.Protobuf
dotnet add package System.Reactive
```

## Authentication & Connection Lifecycle

Connecting and trading requires a strict 3-step sequence:

```text
[TCP + TLS Handshake (Port 5035)]
               │
               ▼
[1. Application Auth] ───► ProtoOAApplicationAuthReq (ClientId, ClientSecret)
               │          ◄─── ProtoOAApplicationAuthRes
               ▼
[2. Account Auth]     ───► ProtoOAAccountAuthReq (AccessToken, AccountId)
               │          ◄─── ProtoOAAccountAuthRes
               ▼
[3. Heartbeat Loop]   ───► Send ProtoHeartbeatEvent every 20-25 seconds
               │
   ┌───────────┴───────────┐
   ▼                       ▼
[Market Data]       [Order Execution]
```

### 1. Application Authentication
```csharp
var appAuthReq = new ProtoOAApplicationAuthReq
{
    ClientId = clientId,
    ClientSecret = clientSecret
};
await client.SendMessage(appAuthReq, ProtoOAPayloadType.ProtoOaApplicationAuthReq);
```

### 2. Account Authorization
```csharp
var accountAuthReq = new ProtoOAAccountAuthReq
{
    AccessToken = accessToken,
    CtidTraderAccountId = accountId
};
await client.SendMessage(accountAuthReq, ProtoOAPayloadType.ProtoOaAccountAuthReq);
```

### 3. Heartbeat & Keepalive
The server disconnects silent clients after 30 seconds of inactivity. Send a heartbeat every 20 seconds:
```csharp
Observable.Interval(TimeSpan.FromSeconds(20))
    .Subscribe(_ => client.SendMessage(new ProtoHeartbeatEvent(), ProtoPayloadType.HeartbeatEvent));
```

## Market Data & Subscriptions

### Subscribing to Spot Ticks (Quotes)
```csharp
var subscribeReq = new ProtoOASubscribeSpotsReq
{
    CtidTraderAccountId = accountId,
};
subscribeReq.SymbolId.Add(symbolId); // Symbol IDs are numeric in cTrader Open API
await client.SendMessage(subscribeReq, ProtoOAPayloadType.ProtoOaSubscribeSpotsReq);
```

When prices update, `ProtoOASpotEvent` delivers tick data:
```csharp
// Bid/Ask in Open API are often relative or scaled integer units
// E.g. Price = rawValue / 100,000 (depending on symbol digits)
```

## Order Execution & Volume Calculation

### Unit Scale & Volume Rules
- cTrader Open API represents volume in **cents/units * 100**.
- 1 standard Forex lot = 100,000 units = `10,000,000` in Open API volume field.
- 0.01 micro lot = 1,000 units = `100,000` in Open API volume field.
- Always verify symbol minimum volume and step volume via `ProtoOASymbolsListReq`.

### Market Order Example
```csharp
var orderReq = new ProtoOANewOrderReq
{
    CtidTraderAccountId = accountId,
    SymbolId = symbolId,
    OrderType = ProtoOAOrderType.Market,
    TradeSide = ProtoOATradeSide.Buy,
    Volume = 100_000, // 0.01 Lot
    Comment = "Bot-Entry",
    Label = "csharp-vps-bot"
};
await client.SendMessage(orderReq, ProtoOAPayloadType.ProtoOaNewOrderReq);
```

## Production Reliability Rules

1. **Reconnect Backoff with Jitter:** On connection drop, wait 2s, 4s, 8s up to 60s with random jitter to avoid IP ban.
2. **Order Reconciliation:** On reconnect, query open positions via `ProtoOAReconcileReq` before emitting new signals.
3. **Daily Loss Circuit Breaker:** Maintain local balance tracking; trigger automatic emergency stop if equity drops beyond max threshold.
4. **Clean SIGTERM Handling:** Catch `AppDomain.CurrentDomain.ProcessExit` or `CancellationToken` to cancel outstanding pending orders before exiting.
