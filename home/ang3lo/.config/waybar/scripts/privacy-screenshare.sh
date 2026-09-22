#!/usr/bin/env bash
# Outputs JSON for the screenshare-privacy Waybar module.
# Shows the screenshare icon when any app has an active video capture stream.
# Empty output hides the module entirely.
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

dump=$(pw-dump 2>/dev/null)

camera_apps=$(echo "$dump" | jq -r '
  [ .[]
    | select((.info.props["media.class"] // "") | test("Stream/Input/Video"))
    | select((.info.props["media.role"] == "Camera") or ((.info.props["node.name"] // "") | test("v4l2"; "i")))
    | select(.info.state == "running")
    | (.info.props["application.name"] // .info.props["node.name"] // "Unknown")
  ] | unique | join(", ")')

screen_apps=$(echo "$dump" | jq -r '
  [ .[]
    | select((.info.props["media.class"] // "") | test("Stream/Input/Video"))
    | select((.info.props["media.role"] != "Camera") and (((.info.props["node.name"] // "") | test("v4l2"; "i")) | not))
    | select(.info.state == "running")
    | (.info.props["application.name"] // .info.props["node.name"] // "Unknown")
  ] | unique | join(", ")')

icon=""
tooltip=""

if [ -n "$camera_apps" ] && [ -n "$screen_apps" ]; then
	icon="󰕧 󰍹"
	tooltip="Camera: $camera_apps | Screen: $screen_apps"
elif [ -n "$camera_apps" ]; then
	icon="󰕧"
	tooltip="Camera in use - $camera_apps"
elif [ -n "$screen_apps" ]; then
	icon="󰍹"
	tooltip="Screenshare in use - $screen_apps"
else
	exit 0
fi

printf '{"text":"%s","class":"active","tooltip":"%s"}\n' "$icon" "$tooltip"
