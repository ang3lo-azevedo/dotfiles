#!/usr/bin/env bash
# external-monitor.sh - Rebuild the multi-monitor layout in Niri when the outputs change
# Main monitor: the browser on one workspace, each group of code editors on its own.
# Portable monitor, with all three connected: Discord and Spotify, one workspace each.
# Fewer than three screens: Discord and ZapFast side by side on the social workspace.
# Laptop screen alone: Spotify joins them there, and that workspace is kept last.
# Run with "now" to arrange the windows once instead of watching for a hotplug.

browser='.app_id // "" | test("^zen"; "i")'
# The nix-config editor keeps its named workspace on the laptop screen
editor='(.app_id // "" | test("^(dev\\.zed\\.Zed|antigravity-ide|(vs)?codium)$"; "i")) and (.title // "" | test("^nix-config( |$)") | not)'

outputs() {
	niri msg -j outputs | jq -r '[.[] | select(.logical != null) | .name] | sort | join(" ")'
}

# The main monitor is the physically biggest one; empty while that is the laptop panel
main_output() {
	niri msg -j outputs | jq -r \
		'[.[] | select(.logical != null)] | max_by((.physical_size // [0, 0]) | .[0] * .[1]) | .name // empty
		| select(startswith("eDP") | not)'
}

# Ids of the windows matching a jq filter that are not on the output yet,
# one line per workspace they come from
off_output() {
	niri msg -j windows | jq -r --arg out "$1" --argjson ws "$(niri msg -j workspaces)" \
		"(\$ws | map(select(.output == \$out) | .id)) as \$there
		| map(select($2) | select(.workspace_id as \$w | \$there | index(\$w) | not))
		| group_by(.workspace_id)[] | sort_by(.layout.pos_in_scrolling_layout) | map(.id) | join(\" \")"
}

# Index of the first workspace on the output holding a window that matches a jq filter
ws_with() {
	niri msg -j windows | jq -r --arg out "$1" --argjson ws "$(niri msg -j workspaces)" \
		"map(select($2) | .workspace_id) as \$ids
		| first(\$ws | sort_by(.idx)[] | select(.output == \$out and (.id as \$i | \$ids | index(\$i))) | .idx) // empty"
}

# First empty workspace of an output: the one in view when it was just plugged in,
# otherwise the one niri keeps at the end
empty_ws() {
	niri msg -j workspaces | jq -r --arg out "$1" --argjson wins "$(niri msg -j windows)" \
		'($wins | map(.workspace_id)) as $used
		| first(sort_by(.idx)[] | select(.output == $out and .name == null and (.id as $i | $used | index($i) | not)) | .idx)'
}

# A workspace index is resolved on the window's own monitor, hence the two steps
send() {
	local out=$1 idx=$2 id
	shift 2
	for id; do
		niri msg action move-window-to-monitor --id "$id" "$out"
		niri msg action move-window-to-workspace --window-id "$id" --focus false "$idx"
	done
}

arrange() {
	local main portable focused idx ids chat music zap app id count width
	# First and on its own: the portable monitor drops out within seconds when set too bright
	~/.config/scripts/display/monitor-brightness.sh cap &

	# niri ignores every action while the session is locked
	# Matched on the command line: the process itself is named after its Nix wrapper
	while pgrep -f '^swaylock( |$)' >/dev/null; do sleep 1; done
	# One at a time: a dock brings up two screens as two hotplugs
	exec 9>"${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/external-monitor.lock"
	flock 9

	focused=$(niri msg -j focused-window | jq -r '.id // empty')

	main=$(main_output)
	if [[ -n $main ]]; then
		read -ra ids < <(off_output "$main" "$browser" | tr '\n' ' ')
		if ((${#ids[@]})); then
			idx=$(ws_with "$main" "$browser")
			send "$main" "${idx:-$(empty_ws "$main")}" "${ids[@]}"
		fi
		# Editors that shared a workspace keep sharing one
		while read -ra ids; do
			send "$main" "$(empty_ws "$main")" "${ids[@]}"
		done < <(off_output "$main" "$editor")
	fi

	# With all three monitors connected Discord gets the portable one to itself,
	# which leaves ZapFast alone on the social workspace
	portable=$(niri msg -j outputs | jq -r 'first(.[] | select(.logical != null and .model == "MSI MP165 E6") | .name) // empty')
	if [[ -n $portable && $(outputs | wc -w) -ge 3 ]]; then
		read -ra chat < <(off_output "$portable" '.app_id == "equibop"' | tr '\n' ' ')
		if ((${#chat[@]})); then
			send "$portable" "$(empty_ws "$portable")" "${chat[@]}"
			niri msg action set-window-width --id "${chat[0]}" 100%
			zap=$(niri msg -j windows | jq -r 'first(.[] | select(.app_id == "zapfast") | .id) // empty')
			[[ -n $zap ]] && niri msg action set-window-width --id "$zap" 100%
		fi
		read -ra music < <(off_output "$portable" '.app_id // "" | test("spotify"; "i")' | tr '\n' ' ')
		((${#music[@]})) && send "$portable" "$(empty_ws "$portable")" "${music[@]}"
	fi

	# With fewer than three screens the chat apps share the social workspace again, at the
	# widths of their window rules in config.kdl. On the laptop screen alone Spotify joins
	# them and the workspace goes below the ones that came over from the other monitors
	count=$(outputs | wc -w)
	if ((count < 3)); then
		for app in '.app_id == "equibop"' '.app_id == "zapfast"' '.app_id // "" | test("spotify"; "i")'; do
			case $app in
			*equibop*) width=1534 ;;
			*zapfast*) width=1407 ;;
			*)
				((count == 1)) || continue
				width=100%
				;;
			esac
			for id in $(niri msg -j windows | jq -r ".[] | select($app) | .id"); do
				niri msg action move-window-to-workspace --window-id "$id" --focus false social
				# Columns can only be reordered through the focus
				niri msg action focus-window --id "$id"
				niri msg action move-column-to-last
				niri msg action set-window-width --id "$id" "$width"
			done
		done
		idx=$(niri msg -j workspaces | jq -r --argjson wins "$(niri msg -j windows)" \
			'($wins | map(.workspace_id)) as $used | [.[] | select(.output | startswith("eDP")) | select(.id as $i | $used | index($i)) | .idx] | max // empty')
		((count == 1)) && [[ -n $idx ]] && niri msg action move-workspace-to-index --reference social "$idx"
	fi

	# A focused window loses the focus when it is sent to another workspace
	[[ -n $focused ]] && niri msg action focus-window --id "$focused"
}

if [[ $1 == now ]]; then
	arrange
	exit
fi

# niri has no output event: a hotplug shows up as the workspaces being reshuffled
~/.config/scripts/display/monitor-brightness.sh cap &
prev=$(outputs)
niri msg -j event-stream | while read -r line; do
	[[ $line == '{"WorkspacesChanged"'* ]] || continue
	now=$(outputs)
	# In the background: waiting here for the session to unlock would stall the event stream
	[[ $now != "$prev" ]] && (arrange) &
	prev=$now
done
