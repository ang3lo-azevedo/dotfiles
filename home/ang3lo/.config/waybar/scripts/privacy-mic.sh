#!/usr/bin/env bash
# Outputs JSON for the mic-privacy Waybar module.
# Shows the mic icon (with active apps in tooltip) when any app is recording.
# Empty output hides the module entirely.
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

apps=$(pw-dump 2>/dev/null | jq -r '
  [ .[]
    | select((.info.props["media.class"] // "") == "Stream/Input/Audio")
    | select(.info.state == "running")
    | (.info.props["application.name"] // "Unknown")
  ] | unique | join(", ")')

[ -z "$apps" ] && exit 0

muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -c "MUTED" || echo 0)

if [ "$muted" -gt 0 ]; then
	printf '{"text":"󰍭","class":"muted","tooltip":"Mic muted — %s"}\n' "$apps"
else
	printf '{"text":"","class":"active","tooltip":"Mic in use — %s"}\n' "$apps"
fi
