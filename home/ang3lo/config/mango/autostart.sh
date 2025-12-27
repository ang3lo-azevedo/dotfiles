#!/usr/bin/env bash

# Update DBus environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# X11 applications support
xwayland-satellite &

# Polkit authentication agent
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# Background
swaybg -c "#000000" &

# Top bar
waybar &

# Notification daemon
swaync &

# Idle management
swayidle -w \
	timeout 601 'wlr-dpms off' \
	timeout 600 'swaylock -f' \
	before-sleep 'swaylock -f' &

# Clipboard history
wl-paste --watch cliphist store &

# Night light
wlsunset -T 3501 -t 3500 &
