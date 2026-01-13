#!/usr/bin/env bash
set -euo pipefail

DEVICE='samsung-galaxybook::kbd_backlight'
CURRENT=$(brightnessctl --device="$DEVICE" g | tr -d '[:space:]')
MAX=$(brightnessctl --device="$DEVICE" m | tr -d '[:space:]')

# Compute next level with wrap: 0 -> 1 -> ... -> MAX -> 0
NEXT=$(( (CURRENT + 1) % (MAX + 1) ))

# Set absolute level to ensure wrap behavior
brightnessctl --device="$DEVICE" set "$NEXT"