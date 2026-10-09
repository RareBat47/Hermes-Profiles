---
name: vps-ssh-deployment
description: "Use when managing Linux Ubuntu VPS over SSH via .pem key. Bootstrap dotnet runtime, sync code, run builds, and supervise remote services."
version: 1.0.0
category: operations
metadata:
  hermes:
    tags: [ssh, pem, vps, ubuntu, deployment, dotnet, automation]
---

# VPS SSH Deployment via .PEM Key

Use this skill to securely connect to, bootstrap, deploy, and operate a remote Linux Ubuntu VPS hosting a .NET cTrader bot using an SSH `.pem` private key.

## SSH Key Security & Permissions

OpenSSH refuses private keys with overly broad permissions.

### Windows (Git-Bash / PowerShell)
If Windows or SSH reports `Permissions 0644 for 'key.pem' are too open`:
```bash
# In Git-Bash:
chmod 400 /path/to/key.pem
```
If Windows ACLs prevent chmod from working:
```powershell
# In PowerShell:
icacls.exe "C:\path\to\key.pem" /reset
icacls.exe "C:\path\to\key.pem" /grant:r "$($env:USERNAME):(R)"
icacls.exe "C:\path\to\key.pem" /inheritance:r
```

## Standard Non-Interactive SSH Command Pattern

Always use bounded timeouts and explicit batch options to prevent hanging prompts:

```bash
KEY="C:/path/to/key.pem"
USER="ubuntu"
HOST="<VPS_IP_OR_DNS>"

SSH_CMD="ssh -i \"$KEY\" -o StrictHostKeyChecking=accept-new -o BatchMode=yes -o ConnectTimeout=10 -p 22 ${USER}@${HOST}"
```

To run a remote command:
```bash
$SSH_CMD "uname -a && uptime"
```

## Remote Ubuntu Environment Bootstrap (.NET 8 SDK)

Run the following one-liner over SSH to bootstrap the Ubuntu VPS for .NET bot execution:

```bash
$SSH_CMD 'bash -s' << 'EOF'
set -euo pipefail

# 1. Update packages
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg git unzip htop jq

# 2. Install Microsoft package repository and .NET 8 SDK / Runtime
# Ubuntu 22.04 / 24.04 includes dotnet in official or Microsoft feeds:
sudo apt-get install -y dotnet-sdk-8.0

# 3. Verify .NET installation
dotnet --info

# 4. Create dedicated non-root bot application directory
sudo mkdir -p /opt/ctrader-bot
sudo chown -R $USER:$USER /opt/ctrader-bot
EOF
```

## Code Sync & Remote Build

### Deploying Source Code
Use `scp` or `rsync` over SSH:
```bash
scp -i "$KEY" -o StrictHostKeyChecking=accept-new -r ./CTraderBot "${USER}@${HOST}:/opt/ctrader-bot/src"
```

### Remote Compilation
Compile directly on the remote Linux target to generate native Linux binaries:
```bash
$SSH_CMD "cd /opt/ctrader-bot/src && dotnet publish -c Release -r linux-x64 --self-contained false -o /opt/ctrader-bot/bin"
```

## Secret Injection (The .env Pattern)

Never commit or log API secrets. Write secrets directly to the remote server into a protected file:
```bash
$SSH_CMD "cat << 'EOF' > /opt/ctrader-bot/.env
CTRADER_CLIENT_ID=your_client_id
CTRADER_CLIENT_SECRET=your_client_secret
CTRADER_ACCESS_TOKEN=your_access_token
CTRADER_ACCOUNT_ID=your_account_id
CTRADER_ENV=demo
EOF
chmod 600 /opt/ctrader-bot/.env"
```

## Verification Checklist

- [ ] `.pem` key permissions restricted to read-only for owner.
- [ ] SSH connectivity verified with non-interactive flags.
- [ ] `dotnet-sdk-8.0` installed and verified via `dotnet --info`.
- [ ] Project built cleanly on the remote host without warnings/errors.
- [ ] Environment file permissions set to `chmod 600`.
