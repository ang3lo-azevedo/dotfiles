#!/usr/bin/env bash
# mpv-workspace.sh - Open mpv on the workspace right above the browser's in Niri
# A window rule cannot do this: open-on-workspace only takes a named workspace,
# and the browser sits on a numbered one that moves around with the monitors.

browser='.app_id // "" | test("^zen"; "i")'

place() {
	local id=$1 out idx ws
	read -r out idx < <(niri msg -j windows | jq -r --argjson ws "$(niri msg -j workspaces)" \
		"first(.[] | select($browser) | .workspace_id) as \$w
		| \$ws[] | select(.id == \$w) | \"\(.output) \(.idx)\"")
	[[ -n $out ]] || return

	# A workspace index is resolved on the window's own monitor, hence the two steps
	niri msg action move-window-to-monitor --id "$id" "$out"
	if ((idx > 1)); then
		niri msg action move-window-to-workspace --window-id "$id" $((idx - 1))
	else
		# Nothing above the browser yet: the empty workspace niri keeps at the end
		# is filled and brought up to take the browser's place
		niri msg action move-window-to-workspace --window-id "$id" 255
		ws=$(niri msg -j windows | jq -r --argjson id "$id" '.[] | select(.id == $id) | .workspace_id')
		# move-workspace-to-index takes no workspace id, only the focused one
		niri msg action focus-window --id "$id"
		[[ $(niri msg -j workspaces | jq -r '.[] | select(.is_focused) | .id') == "$ws" ]] &&
			niri msg action move-workspace-to-index "$idx"
	fi
	niri msg action focus-window --id "$id"
}

# Only the first event of a window places it: later ones are title changes,
# and a window moved away by hand should stay where it was put
declare -A seen
niri msg -j event-stream | while read -r line; do
	case $line in
	'{"WindowsChanged"'*)
		seen=()
		for id in $(jq -r '.WindowsChanged.windows[].id' <<<"$line"); do seen[$id]=1; done
		;;
	'{"WindowOpenedOrChanged"'*)
		read -r id app < <(jq -r '.WindowOpenedOrChanged.window | "\(.id) \(.app_id // "")"' <<<"$line")
		[[ -n ${seen[$id]} ]] && continue
		seen[$id]=1
		[[ $app == mpv ]] && place "$id"
		;;
	'{"WindowClosed"'*)
		unset "seen[$(jq -r '.WindowClosed.id' <<<"$line")]"
		;;
	esac
done
