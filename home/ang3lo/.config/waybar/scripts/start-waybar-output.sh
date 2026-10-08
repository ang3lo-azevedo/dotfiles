#!/usr/bin/env bash
# Start a waybar instance for the given output, e.g. eDP-1 or DP-3.
# Usage: start-waybar-output.sh <OUTPUT_NAME>
OUTPUT="$1"
TEMP_CONFIG="/tmp/waybar-${OUTPUT}.jsonc"
# Matched by model: the connector name of the portable monitor changes
PORTABLE="MSI MP165 E6"

# External monitors start hidden: the trigger bar is used to reveal them.
# The portable monitor starts expanded, and so does the built-in laptop screen
# unless the portable one is the only other screen, which then holds the bar alone.
starts_hidden() {
	niri msg --json outputs | jq -r --arg out "$OUTPUT" --arg portable "$PORTABLE" '
		map(select(.logical != null)) as $on
		| ($on | any(.model == $portable)) as $has_portable
		| if $out | startswith("eDP") then $has_portable and ($on | length) == 2
		  else first($on[] | select(.name == $out) | .model) != $portable end'
}

sed "s/EXTERNAL_OUTPUT/${OUTPUT}/g" \
	~/.config/waybar/config.jsonc >"$TEMP_CONFIG"

HIDDEN=$(starts_hidden)

waybar -c "$TEMP_CONFIG" -s ~/.config/waybar/style.css &
WAYBAR_PID=$!

# Forward SIGTERM so systemd can stop the service cleanly.
trap 'kill $WAYBAR_PID' TERM INT

# The laptop bar depends on the other screens: when a hotplug changes its state
# waybar is stopped, and systemd restarts the service into the new one.
# niri has no output event: a hotplug shows up as the workspaces being reshuffled
case "$OUTPUT" in
eDP*)
	niri msg --json event-stream | while read -r line; do
		[[ $line == '{"WorkspacesChanged"'* ]] || continue
		[[ $(starts_hidden) == "$HIDDEN" ]] || kill $WAYBAR_PID
	done &
	;;
esac

if [[ $HIDDEN == true ]]; then
	sleep 5
	kill -SIGUSR1 $WAYBAR_PID
fi

wait $WAYBAR_PID
