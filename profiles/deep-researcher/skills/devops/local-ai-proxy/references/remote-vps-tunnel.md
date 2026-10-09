# Remote VPS Proxy with Local Encrypted SSH Tunnel

Use this architecture when handling untrusted third-party API providers or keys that must not reside on the primary workstation.

## Architecture

```text
[Local Machine: IDEs, Hermes, OpenCode]
               │ (http://127.0.0.1:4000)
               ▼
   [Local Port 4000 Forwarding]
               │ (Encrypted SSH Tunnel -L 4000:127.0.0.1:4000)
               ▼
[Remote Linux VPS (Ubuntu)]
               │
      [LiteLLM Proxy Daemon]
      - Bound to 127.0.0.1:4000 ONLY (Not 0.0.0.0)
      - Run by unprivileged user (azureuser)
      - Outbound to 169.254.169.254 (IMDS) BLOCKED via iptables
      - Secrets in /home/azureuser/gateway/.env (chmod 600)
               │
               ▼ (HTTPS outbound)
    [Third-Party Provider API]
```

## Remote VPS Setup Recipe

```bash
# 1. Directory and permissions
mkdir -p /home/$USER/gateway
chmod 700 /home/$USER/gateway

# 2. Block cloud metadata access (IMDS) for proxy user
sudo iptables -I OUTPUT 1 -d 169.254.169.254 -m owner --uid-owner $USER -j REJECT
sudo netfilter-persistent save

# 3. Systemd service (always bound strictly to 127.0.0.1)
sudo bash -c 'cat << "EOF" > /etc/systemd/system/litellm-gateway.service
[Unit]
Description=LiteLLM Gateway Bound to Localhost
After=network.target

[Service]
Type=simple
User=azureuser
WorkingDirectory=/home/azureuser/gateway
ExecStart=/usr/bin/python3 /home/azureuser/gateway/run.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable litellm-gateway.service
sudo systemctl restart litellm-gateway.service
```

## Windows Persistent SSH Tunnel Launcher

Do not run `ssh -L` inside interactive terminals or MSYS subshells; they terminate when the parent exits. Use a detached PowerShell command or VBS launcher:

### VBS Launcher (`start-ssh-tunnel.vbs`)
Place in `shell:startup` for automatic connection on Windows boot:
```vbscript
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "ssh -i C:\Users\<user>\.ssh\id_rsa -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -N -L 4000:127.0.0.1:4000 user@<vps-ip>", 0, False
```

### PowerShell Detached Launch
```powershell
Start-Process ssh -ArgumentList '-i C:\Users\<user>\.ssh\id_rsa -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -N -L 4000:127.0.0.1:4000 user@<vps-ip>' -WindowStyle Hidden
```
