#!/usr/bin/env bash
# Hermes-Profiles Automated Installer for Linux, macOS & Git Bash
set -e

echo "============================================================"
echo "         Hermes Profiles Automated Installer               "
echo "============================================================"

# Detect Hermes Profiles Directory
if [ -n "$HERMES_HOME" ]; then
    HERMES_DIR="$HERMES_HOME"
elif [ -d "$HOME/.hermes" ]; then
    HERMES_DIR="$HOME/.hermes"
elif [ -d "$LOCALAPPDATA/hermes" ]; then
    HERMES_DIR="$LOCALAPPDATA/hermes"
else
    HERMES_DIR="$HOME/.hermes"
fi

PROFILES_DEST="$HERMES_DIR/profiles"
mkdir -p "$PROFILES_DEST"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PROFILES="$SCRIPT_DIR/profiles"

PROFILES=("dissector" "deep-researcher" "pro-dev")

echo "Hermes destination directory: $PROFILES_DEST"
echo "Available profiles to install:"
echo "  1) All profiles (dissector, deep-researcher, pro-dev) [Default]"
echo "  2) dissector (Clean-room reverse engineering & protocols)"
echo "  3) deep-researcher (Evidence-first web & tech intelligence)"
echo "  4) pro-dev (Surgical software factory & hackathon champion)"
echo ""

TARGETS=("${PROFILES[@]}")

# If argument provided, use it
if [ "$1" = "all" ] || [ "$1" = "" ]; then
    TARGETS=("${PROFILES[@]}")
elif [ "$1" = "dissector" ]; then
    TARGETS=("dissector")
elif [ "$1" = "deep-researcher" ]; then
    TARGETS=("deep-researcher")
elif [ "$1" = "pro-dev" ]; then
    TARGETS=("pro-dev")
fi

for p in "${TARGETS[@]}"; do
    echo "--> Installing profile: $p..."
    SRC="$SOURCE_PROFILES/$p"
    DST="$PROFILES_DEST/$p"
    
    mkdir -p "$DST"
    
    # Copy files
    cp -r "$SRC/"* "$DST/"
    
    # Setup .env if not exists
    if [ ! -f "$DST/.env" ] && [ -f "$DST/.env.example" ]; then
        cp "$DST/.env.example" "$DST/.env"
        echo "    Created $DST/.env from template"
    fi
    
    echo "    Successfully installed $p into $DST"
done

echo ""
echo "============================================================"
echo " Installation Complete! "
echo "============================================================"
echo "To test and launch your profiles:"
echo "  hermes -p dissector doctor"
echo "  hermes -p deep-researcher doctor"
echo "  hermes -p pro-dev doctor"
echo ""
echo "Start chatting:"
echo "  hermes -p pro-dev"
echo "============================================================"
