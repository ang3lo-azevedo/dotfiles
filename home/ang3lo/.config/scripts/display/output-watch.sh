#!/usr/bin/env bash
# Reacts to a screen being plugged in.
# wluma only looks for screens when it starts, and at login it starts before the eGPU is up:
# one that shows up later would be skipped until the next login, so wluma is restarted.
# While wluma is off, the screen gets back the brightness it had (monitor-brightness.sh restore).
# Run by the output-watch service (wluma.nix).
# Usage: output-watch.sh          watch for screens
#        output-watch.sh record   note the screens present, run as wluma starts

SCRIPTS=$(dirname "$(readlink -f "$0")")
RUNTIME="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
# Models wluma could see when it last started
KNOWN="$RUNTIME/wluma-outputs"

outputs() {
	niri msg --json outputs | jq -r 'to_entries[] | select(.key | startswith("eDP") | not) | [.key, .value.model] | @tsv'
}

if [ "$1" = record ]; then
	outputs | cut -f2 >"$KNOWN"
	exit
fi

declare -A before now
udevadm monitor --udev --subsystem-match=drm | while read -r _; do
	# One hotplug is a burst of events, and the screen takes a moment to show up in niri
	while read -r -t 5 _; do :; done

	now=()
	while IFS=$'\t' read -r output model; do
		now[$output]=$model
	done < <(outputs)

	restart=
	for output in "${!now[@]}"; do
		[ -z "${before[$output]}" ] || continue
		if ! systemctl --user is-active --quiet wluma; then
			"$SCRIPTS/monitor-brightness.sh" restore "$output" &
		elif ! grep -qxF "${now[$output]}" "$KNOWN" 2>/dev/null; then
			restart=1
		fi
	done
	[ -n "$restart" ] && systemctl --user restart wluma

	before=()
	for output in "${!now[@]}"; do before[$output]=${now[$output]}; done
done
