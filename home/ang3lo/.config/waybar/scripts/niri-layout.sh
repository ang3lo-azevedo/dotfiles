#!/usr/bin/env bash
# Outputs JSON for the niri-layout Waybar module: how many columns the active
# workspace of the given output has, and how many windows are stacked in its
# active column. Empty output hides the module when the workspace has no
# tiled windows.
# Usage: niri-layout.sh <OUTPUT_NAME>
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

OUTPUT="$1"

render() {
	jq -c -n --arg output "$OUTPUT" \
		--argjson workspaces "$(niri msg -j workspaces)" \
		--argjson windows "$(niri msg -j windows)" '
    ($workspaces | map(select(.output == $output and .is_active)) | first) as $ws
    | [ $windows[]
        | select(.workspace_id == $ws.id and (.is_floating | not))
        | {id, col: .layout.pos_in_scrolling_layout[0], row: .layout.pos_in_scrolling_layout[1]}
      ] as $tiled
    | if ($tiled | length) == 0 then {text: ""}
      else
        ($tiled | map(.col) | unique | length) as $cols
        | ($tiled | map(select(.id == $ws.active_window_id)) | first) as $active
        # A floating window can hold focus: fall back to the tallest column.
        | (if $active then $active.col
           else ($tiled | group_by(.col) | max_by(length) | first | .col) end) as $col
        | ($tiled | map(select(.col == $col)) | length) as $rows
        | {
            text: "󰹳 \($cols) 󰹹 \($rows)",
            tooltip: (
              if $active then "Column \($active.col) of \($cols)\nWindow \($active.row) of \($rows) in this column"
              else "\($cols) columns\n\($rows) windows in the tallest column" end
            )
          }
      end'
}

last=""
emit() {
	local out
	out=$(render 2>/dev/null) || return
	[ "$out" = "$last" ] && return
	last="$out"
	printf '%s\n' "$out"
}

emit
niri msg -j event-stream | while read -r event; do
	case "$event" in
	'{"Window'* | '{"Workspace'*) emit ;;
	esac
done
