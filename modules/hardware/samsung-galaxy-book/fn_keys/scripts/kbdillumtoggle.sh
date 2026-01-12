#!/usr/bin/env bash
set -euo pipefail

DEVICE='samsung-galaxybook::kbd_backlight'
CURRENT=$(brightnessctl --device="$DEVICE" g)
MAX=$(brightnessctl --device="$DEVICE" m)

if [ "$CURRENT" -ge "$MAX" ]; then
    brightnessctl --device="$DEVICE" set 0
else
    brightnessctl --device="$DEVICE" set +1
fi