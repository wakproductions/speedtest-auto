#!/usr/bin/env bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
echo "Script directory is: $SCRIPT_DIR"

. ~/.bash_profile

TARGET_SCRIPT="$SCRIPT_DIR/speedtest.rb"

if [ -x "$TARGET_SCRIPT" ]; then
    "$TARGET_SCRIPT"
else
    echo "Error: '$TARGET_SCRIPT' does not exist or is not executable."
    exit 1
fi
