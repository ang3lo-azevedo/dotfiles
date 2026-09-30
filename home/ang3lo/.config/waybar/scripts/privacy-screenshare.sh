#!/usr/bin/env bash
# Outputs JSON for the screenshare-privacy Waybar module.
# Shows the camera and/or screenshare icon when any app is capturing video.
# Empty output hides the module entirely.
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

dump=$(pw-dump 2>/dev/null)

# Consumer streams rarely carry media.role or a v4l2 node.name, so a stream is
# classified by the source node it is linked to instead of by its own props.
read -r -d '' classify <<'EOF'
def is_camera: (.info.props["media.role"] == "Camera")
  or ((.info.props["device.api"] // "") | test("^(v4l2|libcamera)$"));
(map(select(.type == "PipeWire:Interface:Node")) | INDEX(.id)) as $nodes
| [ .[]
    | select(.type == "PipeWire:Interface:Link")
    | ($nodes[.info["output-node-id"] | tostring]) as $src
    | ($nodes[.info["input-node-id"] | tostring]) as $dst
    | select($src != null and $dst != null)
    | select(($src.info.props["media.class"] // "") == "Video/Source")
    | select($src.info.state == "running")
    | select(($src | is_camera) == $want_camera)
    | ($dst.info.props["application.name"] // $dst.info.props["node.name"] // "Unknown")
  ]
EOF

pw_apps() {
	echo "$dump" | jq -r --argjson want_camera "$1" "$classify | .[]" 2>/dev/null
}

# Apps reading /dev/video* directly (Chromium without PipeWire camera, OBS,
# ffmpeg) bypass PipeWire. PipeWire itself and the camera-relay writer hold the
# device permanently, so they are not evidence of use.
v4l2_apps() {
	find /proc/[0-9]*/fd -maxdepth 1 -lname '/dev/video*' 2>/dev/null |
		cut -d/ -f3 | sort -u |
		while read -r pid; do
			cat "/proc/$pid/comm" 2>/dev/null
		done |
		grep -v -E '^(pipewire|wireplumber|camera-relay|gst-launch|\.?gazed)'
}

join_unique() {
	sort -u | grep -v '^$' | paste -sd, - | sed 's/,/, /g'
}

camera_apps=$({
	pw_apps true
	v4l2_apps
} | join_unique)
screen_apps=$(pw_apps false | join_unique)

if [ -n "$camera_apps" ] && [ -n "$screen_apps" ]; then
	icon="󰖠 󰍹"
	tooltip="Camera: $camera_apps | Screen: $screen_apps"
elif [ -n "$camera_apps" ]; then
	icon="󰖠"
	tooltip="Camera in use - $camera_apps"
elif [ -n "$screen_apps" ]; then
	icon="󰍹"
	tooltip="Screenshare in use - $screen_apps"
else
	exit 0
fi

printf '{"text":"%s","class":"active","tooltip":"%s"}\n' "$icon" "$tooltip"
