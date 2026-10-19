{pkgs, ...}: let
  egpu-disconnect = pkgs.writeShellApplication {
    name = "egpu-disconnect";
    runtimeInputs = [pkgs.psmisc];
    text = ''
      # AMD devices (vendor 1002): on this laptop only the eGPU has any.
      # Deepest first, so the card goes before the bridges it sits behind
      gpu_devices() {
        local dev
        for dev in /sys/bus/pci/devices/*; do
          if [ "$(cat "$dev/vendor" 2>/dev/null)" = "0x1002" ]; then echo "$dev"; fi
        done | sort -r
      }

      mapfile -t devices < <(gpu_devices)
      if [ "''${#devices[@]}" -eq 0 ]; then
        echo "No eGPU found." >&2
        exit 1
      fi

      if [ "$(id -u)" -ne 0 ]; then
        # The card must not be driving a screen when it is detached, and only
        # the session can tell the compositor to let go of its outputs
        if [ -n "''${NIRI_SOCKET:-}" ]; then
          for dev in "''${devices[@]}"; do
            for connector in "$dev"/drm/card*/card*-*; do
              [ "$(cat "$connector/status" 2>/dev/null)" = connected ] || continue
              output=$(basename "$connector")
              output=''${output#card*-}
              echo "Turning off $output..."
              niri msg output "$output" off
            done
          done
          sleep 2
        fi

        # wluma keeps the monitors' DDC buses open, and the driver unbind
        # waits in i2c_del_adapter until every handle on them is closed
        wluma_was_active=false
        if systemctl --user is-active --quiet wluma.service; then
          wluma_was_active=true
          echo "Stopping wluma..."
          systemctl --user stop wluma.service
        fi

        status=0
        sudo "$0" || status=$?

        # Restarted even on failure: it only finds the screens still connected
        if $wluma_was_active; then
          systemctl --user start wluma.service
        fi
        exit "$status"
      fi

      echo "Safely disconnecting eGPU..."

      # Unbinding with a DDC bus still open blocks forever, and the cable then
      # gets pulled from a half-removed device
      held=false
      for dev in "''${devices[@]}"; do
        for bus in "$dev"/i2c-* "$dev"/drm/card*/card*-*/i2c-*; do
          [ -e "$bus" ] || continue
          node="/dev/$(basename "$bus")"
          if holders=$(fuser "$node" 2>/dev/null) && [ -n "$holders" ]; then
            for pid in $holders; do
              echo "$node is held by $pid: $(tr '\0' ' ' < "/proc/$pid/cmdline" | cut -c1-100)" >&2
            done
            held=true
          fi
        done
      done
      if $held; then
        echo "Close those programs first: do NOT unplug the cable." >&2
        exit 1
      fi

      for dev in "''${devices[@]}"; do
        # Already gone along with a device removed before it
        [ -e "$dev" ] || continue
        name=$(basename "$dev")
        if [ -e "$dev/driver" ]; then
          echo "Unbinding device $name from driver $(basename "$(readlink -f "$dev/driver")")..."
          echo "$name" > "$dev/driver/unbind"
          if [ -e "$dev/driver" ]; then
            echo "Device $name is still bound: do NOT unplug the cable." >&2
            exit 1
          fi
        fi
        echo "Removing device $name from PCI bus..."
        echo 1 > "$dev/remove"
        if [ -e "$dev" ]; then
          echo "Device $name is still on the PCI bus: do NOT unplug the cable." >&2
          exit 1
        fi
      done

      echo "Done. It is now safe to unplug the Thunderbolt cable."
    '';
  };
in {
  environment.systemPackages = [egpu-disconnect];
}
