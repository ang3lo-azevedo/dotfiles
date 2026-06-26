#!/usr/bin/env sh
# Restart all currently active per-output Waybar instances: each display runs a
# separate waybar-output@<name>.service so a simple "pkill waybar" would race with
# the systemd units trying to respawn them
systemctl --user list-units 'waybar-output@*.service' --state=active --no-legend --plain |
	awk '{print $1}' |
	xargs -r systemctl --user restart
