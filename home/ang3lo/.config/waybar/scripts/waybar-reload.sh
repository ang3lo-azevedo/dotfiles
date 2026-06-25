#!/usr/bin/env sh
systemctl --user list-units 'waybar-output@*.service' --state=active --no-legend --plain |
	awk '{print $1}' |
	xargs -r systemctl --user restart
