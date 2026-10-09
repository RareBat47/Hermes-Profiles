---
name: csharp-ctrader
 description: Scaffold and verify C# cTrader Automate projects.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows]
metadata:
  hermes:
    tags: [csharp, dotnet, ctrader, trading]
    related_skills: [reflexion-self-review, systematic-debugging]
---

# C# and cTrader Automate

Scaffold .NET solutions and cTrader cBots with explicit risk controls, then build and inspect compiler output. Keep order execution in C#; use a local IPC bridge only for signal or ML inference.

## Procedure

1. Confirm `dotnet --version` and locate the target workspace.
2. Generate or inspect the solution and `.csproj`.
3. For cBots, include `OnStart`, `OnTick`, `OnBar`, and `OnStop`, plus explicit max-slippage, ATR stop-loss, take-profit, and equity-protection parameters.
4. Add a Python bridge only after defining a versioned message schema, timeout, and fail-closed behavior.
5. Run `dotnet restore` and `dotnet build --configuration Release`.
6. Triage missing cTrader API references from the actual compiler log; do not invent a NuGet package.

## Pitfalls

- cTrader API assemblies and `.algo` packaging depend on the installed cTrader environment and may not be available to ordinary `dotnet` builds.
- Trading code needs backtests and paper validation; a successful compile is not a safe deployment.
- Never put account credentials in a project file.

## Verification

Record the exact build output, confirm generated artifacts, and run tests or a deterministic simulator before deployment.
