#!/usr/bin/env bash
# Outputs JSON for the screenshare-privacy Waybar module.
# Shows the screenshare icon when any app has an active video capture stream.
# Empty output hides the module entirely.
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

apps=$(pw-dump 2>/dev/null | jq -r '
  [ .[]
    | select((.info.props["media.class"] // "") | test("Stream/Input/Video"))
    | select(.info.state == "running")
    | (.info.props["application.name"] // .info.props["node.name"] // "Unknown")
  ] | unique | join(", ")')

[ -z "$apps" ] && exit 0

printf '{"text":"󱛖","class":"active","tooltip":"Screen/camera in use - %s"}\n' "$apps"
