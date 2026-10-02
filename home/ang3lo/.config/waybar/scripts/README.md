# Display and Night Mode Scripts

This directory contains scripts that control screen brightness, night light color temperature, and their automation schedules.

## Core Services

`wlsunset` controls the color temperature of the displays. It uses `sunwait` to fetch astronomical data based on geolocation.

`wluma` is a background daemon that automatically adjusts brightness based on ambient light and screen contents during the day. It learns user preferences when manual adjustments are made.

`night-ramp.sh` orchestrates the evening transition. It runs on a 5 minute timer via a systemd user service.

## The Evening Transition

The evening dimming process is a 90 minute transition centered exactly on the standard daylight sunset time. The transition begins 45 minutes before sunset and concludes 45 minutes after sunset.

When the transition begins:
1. `night-ramp.sh` detects the start of the evening window.
2. If `wluma` is running, it is temporarily paused. This prevents `wluma` from learning the automated dimming behavior as a user preference.
3. The screen brightness is gradually reduced across 12 steps.
4. `wlsunset` simultaneously fades the screen color temperature to a warmer profile.

When the sun rises:
1. The screens return to standard brightness.
2. `wluma` is automatically restarted if it was paused the night before.

## Manual Controls

These systems are controlled via the SwayNC control center buttons.

### Auto-Brightness (wluma)
Toggles the `wluma` daemon. Turning this off allows full manual control over screen brightness during the day without the system attempting to learn or override preferences.

### All Monitors (DDC)
Toggles whether manual brightness adjustments apply to all connected monitors simultaneously or only the primary screen.

### Auto-Dim Brightness at Sunset
Toggles the `night-ramp.sh` schedule. When disabled, screens will remain at their standard brightness levels through the night.

### Auto-Dim Colors (Night Light) at Sunset
Toggles the `wlsunset` sun tracking mode. When disabled, the color temperature stays locked at the static night time value.
