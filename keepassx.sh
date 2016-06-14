#!/bin/bash
set -e
cd $(dirname $0)

ENTRY=$(./rofi.sh -dmenu -case-sensitive -e password <$HOME/.cache/keepass)
xdotool type $(echo "$ENTRY" | ./keepassx.py)
xdotool key Return

