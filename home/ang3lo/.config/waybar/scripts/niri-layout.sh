#!/usr/bin/env bash
# Outputs JSON for the niri-layout Waybar module, for the given output only:
# how many columns its active workspace has (horizontal), and how many of its
# workspaces hold windows (vertical: each workspace is one row of columns).
# Empty output hides the module when the output has no tiled windows.
# Usage: niri-layout.sh <OUTPUT_NAME>
PATH="/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"

OUTPUT="$1"

render() {
	jq -c -n --arg output "$OUTPUT" \
		--argjson workspaces "$(niri msg -j workspaces)" \
		--argjson windows "$(niri msg -j windows)" '
    # Arrow for one axis: it points at where the other columns/workspaces are,
    # so it is one-sided at either end and a dot when there is nothing else.
    def arrow($before; $after; $back; $forward; $both):
      if $before > 0 and $after > 0 then $both
      elif $after > 0 then $forward
      elif $before > 0 then $back
      else "󰧟" end;
    [ $windows[] | select(.is_floating | not) ] as $tiled
    | ($workspaces | map(select(.output == $output)) | sort_by(.idx)) as $on_output
    | [ $on_output[] | select(.id as $id | any($tiled[]; .workspace_id == $id)) ] as $rows
    | ($on_output | map(select(.is_active)) | first) as $ws
    | if ($rows | length) == 0 then {text: ""}
      else
        ($tiled | map(select(.workspace_id == $ws.id) | .layout.pos_in_scrolling_layout[0]) | unique) as $cols
        | ($tiled | map(select(.id == $ws.active_window_id)) | first | .layout.pos_in_scrolling_layout[0]) as $col
        | ($rows | map(.id) | index($ws.id)) as $row
        # No focused tiled column (floating focus, empty workspace): both sides.
        | (if $col then arrow($cols | map(select(. < $col)) | length; $cols | map(select(. > $col)) | length; "󰁍"; "󰁔"; "󰹳")
           elif ($cols | length) > 0 then "󰹳" else "󰧟" end) as $h
        | arrow($rows | map(select(.idx < $ws.idx)) | length; $rows | map(select(.idx > $ws.idx)) | length; "󰁝"; "󰁅"; "󰹹") as $v
        | {
            text: "\($h) \($cols | length) \($v) \($rows | length)",
            tooltip: (
              (if $col then "Column \($col) of \($cols | length)" else "\($cols | length) columns" end)
              + "\n"
              + (if $row != null then "Workspace \($row + 1) of \($rows | length)" else "\($rows | length) workspaces with windows" end)
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
