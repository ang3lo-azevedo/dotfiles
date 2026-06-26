#!/usr/bin/env sh
# samsung-galaxybook::kbd_backlight is the sysfs LED device exposed by the
# samsung-galaxybook kernel driver; the name differs from generic kbd_backlight
max_brightness=$(brightnessctl -d samsung-galaxybook::kbd_backlight m | cut -d '%' -f 1)
current_brightness=$(brightnessctl -d samsung-galaxybook::kbd_backlight g | cut -d '%' -f 1)

if [ "$current_brightness" -eq "$max_brightness" ]; then
	brightnessctl -d samsung-galaxybook::kbd_backlight set 0
else
	brightnessctl -d samsung-galaxybook::kbd_backlight set +1
fi
