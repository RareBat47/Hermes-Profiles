# Hermes-Profiles Automated Installer for Windows PowerShell
$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "         Hermes Profiles Automated Installer (Windows)     " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Detect Hermes Profiles Directory
if ($env:HERMES_HOME) {
    $HermesDir = $env:HERMES_HOME
} elseif (Test-Path "$env:LOCALAPPDATA\hermes") {
    $HermesDir = "$env:LOCALAPPDATA\hermes"
} elseif (Test-Path "$env:USERPROFILE\.hermes") {
    $HermesDir = "$env:USERPROFILE\.hermes"
} else {
    $HermesDir = "$env:LOCALAPPDATA\hermes"
}

$ProfilesDest = Join-Path $HermesDir "profiles"
if (-not (Test-Path $ProfilesDest)) {
    New-Item -ItemType Directory -Path $ProfilesDest -Force | Out-Null
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceProfiles = Join-Path $ScriptDir "profiles"

$Profiles = @("dissector", "deep-researcher", "pro-dev")

Write-Host "Target Hermes Profiles directory: $ProfilesDest" -ForegroundColor Green

foreach ($p in $Profiles) {
    Write-Host "--> Installing profile: $p..." -ForegroundColor Yellow
    $Src = Join-Path $SourceProfiles $p
    $Dst = Join-Path $ProfilesDest $p

    if (-not (Test-Path $Dst)) {
        New-Item -ItemType Directory -Path $Dst -Force | Out-Null
    }

    Copy-Item -Path "$Src\*" -Destination $Dst -Recurse -Force

    $EnvExample = Join-Path $Dst ".env.example"
    $EnvFile = Join-Path $Dst ".env"
    if ((Test-Path $EnvExample) -and (-not (Test-Path $EnvFile))) {
        Copy-Item -Path $EnvExample -Destination $EnvFile
        Write-Host "    Created $EnvFile from template" -ForegroundColor DarkGray
    }

    Write-Host "    Successfully installed $p into $Dst" -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Installation Complete! " -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Verify installation:"
Write-Host "  hermes -p dissector doctor"
Write-Host "  hermes -p deep-researcher doctor"
Write-Host "  hermes -p pro-dev doctor"
Write-Host ""
Write-Host "Start chatting:"
Write-Host "  hermes -p pro-dev" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
