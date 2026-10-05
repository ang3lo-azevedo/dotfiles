#!/usr/bin/env bash
# right-screen.sh - Build the fixed laptop screen layout in Niri
# Workspaces and widths come from the window rules in config.kdl; this only
# launches the apps in the order their columns should appear.

win_id() {
	niri msg -j windows | jq -r --arg a "$1" --arg t "${2:-}" \
		'first(.[] | select(.app_id == $a and (.title // "" | startswith($t))) | .id) // empty'
}

wait_for() {
	local id
	for _ in {1..240}; do
		id=$(win_id "$@")
		[[ -n $id ]] && echo "$id" && return
		sleep 0.25
	done
}

# Waits for each window so the next one in the same workspace opens to its right
launch() {
	local app_id=$1
	shift
	[[ -n $(win_id "$app_id") ]] && return
	niri msg action spawn -- "$@"
	wait_for "$app_id" >/dev/null
}

# A config reload inserts new named workspaces on top in reverse order
idx=1
for ws in monitor nix-config social; do
	niri msg action move-workspace-to-index --reference "$ws" "$idx"
	((idx++))
done

launch app.btop ghostty --class=app.btop -e btop
launch equibop equibop
launch zapfast zapfast

# With all three monitors connected Discord gets the portable one to itself,
# which leaves ZapFast alone on the social workspace
portable=$(niri msg -j outputs | jq -r 'first(.[] | select(.model == "MSI MP165 E6") | .name) // empty')
if [[ -n $portable && $(niri msg -j outputs | jq length) -ge 3 ]]; then
	chat=$(win_id equibop)
	zap=$(win_id zapfast)
	if [[ -n $chat ]]; then
		niri msg action move-window-to-monitor --id "$chat" "$portable"
		niri msg action set-window-width --id "$chat" 100%
	fi
	[[ -n $zap ]] && niri msg action set-window-width --id "$zap" 100%
fi

# nirinit reopens Antigravity and moves its windows around by index, so the
# nix-config window is only placed after that restore is over. Its title only
# becomes "nix-config - ..." once the folder loads, too late for open-on-workspace.
inv=$(systemctl --user show -p InvocationID --value nirinit.service)
if [[ -n $inv ]]; then
	for _ in {1..120}; do
		journalctl --user -o cat _SYSTEMD_INVOCATION_ID="$inv" | grep -q 'restored session' && break
		sleep 1
	done
fi

ide=$(win_id antigravity-ide "nix-config - ")
if [[ -z $ide ]]; then
	niri msg action spawn -- antigravity-ide "$HOME/nix-config"
	ide=$(wait_for antigravity-ide "nix-config - ")
fi
if [[ -n $ide ]]; then
	niri msg action move-window-to-workspace --window-id "$ide" --focus false nix-config
	niri msg action set-window-width --id "$ide" 100%
fi

# nirinit moves whichever Antigravity window it finds first, so other projects
# can land here; they belong on the external monitor
ws=$(niri msg -j workspaces | jq -r '.[] | select(.name == "nix-config") | .id')
niri msg -j windows | jq -r --argjson ws "$ws" --arg ide "${ide:-}" \
	'.[] | select(.workspace_id == $ws and .app_id == "antigravity-ide" and (.id | tostring) != $ide) | .id' |
	while read -r id; do
		niri msg action move-window-to-monitor --id "$id" DP-3
	done

launch app.nix-config-term ghostty --class=app.nix-config-term
