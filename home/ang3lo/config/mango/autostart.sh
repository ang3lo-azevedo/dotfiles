# obs
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1

# Polkit authentication agent
#/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# wallpaper
swaybg -c "#000000" &

# top bar
waybar >/dev/null 2>&1 &

# Notification daemon
#swaync &

# Idle management
#swayidle -w \
#	timeout 601 'wlr-dpms off' \
#	timeout 600 'swaylock -f' \
#	before-sleep 'swaylock -f' &

# Clipboard history
#wl-paste --watch cliphist store &

# Night light
#wlsunset -T 3501 -t 3500 &
