#!/usr/bin/env sh
niri msg --json outputs | jq -r 'keys[]' | while IFS= read -r output; do
	systemctl --user start "waybar-output@${output}.service"
done
