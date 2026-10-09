---
name: linux-trading-daemon
description: "Use when configuring systemd services for Linux trading bots. Manage 24/7 background daemons, auto-restart, journalctl logs, and crash recovery."
version: 1.0.0
category: operations
metadata:
  hermes:
    tags: [systemd, daemon, ubuntu, linux, logging, journalctl, trading-bot]
---

# Linux Trading Daemon Management via Systemd

Use this skill when packaging, deploying, daemonizing, and monitoring a headless C# trading bot as a persistent system service on Ubuntu Linux.

## Systemd Service Unit Template

Place the unit file at `/etc/systemd/system/ctrader-bot.service`:

```ini
[Unit]
Description=cTrader C# Trading Bot Daemon
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/opt/ctrader-bot/bin
ExecStart=/usr/bin/dotnet /opt/ctrader-bot/bin/CTraderBot.dll
EnvironmentFile=/opt/ctrader-bot/.env

# Restart on crash with backoff
Restart=always
RestartSec=10s

# Graceful termination (allows bot to cancel orders/close TLS cleanly)
KillSignal=SIGTERM
TimeoutStopSec=30s

# Security hardening
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=true
NoNewPrivileges=true

# Standard I/O logging to journald
StandardOutput=journal
StandardError=journal
SyslogIdentifier=ctrader-bot

[Install]
WantedBy=multi-user.target
```

## Installing & Activating the Service

Run the following commands over SSH:

```bash
# 1. Copy unit file into place
sudo cp /path/to/ctrader-bot.service /etc/systemd/system/ctrader-bot.service

# 2. Reload systemd daemon
sudo systemctl daemon-reload

# 3. Enable service to start on boot
sudo systemctl enable ctrader-bot.service

# 4. Start the service
sudo systemctl start ctrader-bot.service

# 5. Check status
sudo systemctl status ctrader-bot.service --no-pager
```

## Telemetry & Log Monitoring

### Live Follow
```bash
journalctl -u ctrader-bot -f -o cat
```

### Recent Errors (Past 24 Hours)
```bash
journalctl -u ctrader-bot --since "24 hours ago" -p err..emerg --no-pager
```

### Checking Restarts / Failure Counts
```bash
systemctl show ctrader-bot --property=NRestarts,ActiveState,SubState
```

## Emergency Controls

### Immediate Stop (Triggers graceful SIGTERM)
```bash
sudo systemctl stop ctrader-bot
```

### Immediate Kill (If process hangs)
```bash
sudo systemctl kill -s SIGKILL ctrader-bot
```

### Log-Rotation & Disk Space Hygiene
Prevent logs from consuming excessive disk on the VPS:
```bash
# Verify journal disk usage
journalctl --disk-usage

# Retain maximum 500M of logs
sudo journalctl --vacuum-size=500M
```
