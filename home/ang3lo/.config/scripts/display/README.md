# Display Automation Scripts

## Purpose
This directory contains scripts and configurations for automated screen brightness and color temperature management. The system provides dynamic brightness based on ambient light during the day, and synchronized brightness dimming alongside color temperature warming during the evening. It includes manual overrides via SwayNC.

## Architecture

The system coordinates three primary services:

1. **`wluma` (Auto-Brightness Daemon)**
   - Adjusts screen brightness dynamically based on ambient lighting and screen content.
   - Learns user preferences dynamically when manual brightness adjustments are made.

2. **`wlsunset` (Color Temperature)**
   - Manages display color temperature.
   - Uses `sunwait` and system geolocation data to determine local sunrise and sunset times.

3. **`night-ramp.sh` (Evening Transition Controller)**
   - Custom script triggered by a 5-minute systemd timer.
   - Synchronizes the gradual reduction of screen brightness with the color temperature shifts from `wlsunset`.

## Automation Lifecycle

### Daytime Operation
`wluma` actively manages brightness adjustments based on environmental factors. `wlsunset` maintains standard daylight color temperatures.

### Evening Transition
A 90-minute transition phase centered on the local sunset time (starting 45 minutes before and concluding 45 minutes after).

Sequence of operations:
1. `night-ramp.sh` detects the start of the sunset window.
2. `wluma` is temporarily paused. This prevents the daemon from logging the automated dimming steps as user-defined manual preferences.
3. `night-ramp.sh` reduces screen brightness across 12 distinct steps over the 90-minute window.
4. `wlsunset` shifts the display color temperature to a warmer profile simultaneously.

### Morning Transition
Triggered at local sunrise:
1. Display brightness is restored to standard daytime levels.
2. The `wluma` daemon is restarted (if previously active) to resume ambient monitoring.
3. `wlsunset` restores standard daylight color temperatures.

## Screens That Lose Their Brightness

The MSI G27C4 does not keep a brightness set over DDC: about two seconds after waking from a power-off it jumps back to the value from its own menu.

- `monitor-brightness.sh` records the last brightness of every DDC screen, whether it came from the slider, the brightness keys or `night-ramp.sh`.
- The screens are powered off through `monitor-brightness.sh off` (idle timeout in swayidle and `Mod+Shift+P`), which records the current values, then puts them back once the screens are on again.
- swayidle does the same around a suspend with `save` and `restore`.

## Screens Plugged In Late

`wluma` only looks for screens when it starts, and at login it starts before the eGPU is up. `output-watch.sh` (the `output-watch` service) restarts it when a screen it has not seen appears. While `wluma` is off, the screen gets its recorded brightness back instead.

## SwayNC Controls

Manual overrides are accessible via the SwayNC control center:

### Auto-Brightness (wluma)
Toggles the `wluma` daemon. Disabling this grants full manual control over screen brightness without dynamic adjustments or preference learning.

### All Monitors (DDC)
Toggles multi-monitor brightness synchronization. Determines if manual brightness adjustments apply to all connected displays or strictly the primary display.

### Auto-Dim Brightness at Sunset
Toggles the `night-ramp.sh` schedule. Disabling this prevents the automated brightness reduction during the evening transition.

### Auto-Dim Colors (Night Light)
Toggles the `wlsunset` dynamic tracking mode. Disabling this locks the screen color temperature to a static value and prevents automated daytime/evening shifts.
