{pkgs, ...}: let
  egpu-disconnect = pkgs.writeShellApplication {
    name = "egpu-disconnect";
    text = ''
      echo "Safely disconnecting eGPU..."

      # Look for AMD devices (Vendor 1002)
      for dev in /sys/bus/pci/devices/*; do
          if [ -f "$dev/vendor" ]; then
              vendor=$(cat "$dev/vendor")
              if [ "$vendor" = "0x1002" ]; then
                  driver_dir="$dev/driver"
                  if [ -d "$driver_dir" ]; then
                      echo "Unbinding device $(basename "$dev") from driver $(basename "$(readlink -f "$driver_dir")")..."
                      basename "$dev" > "$driver_dir/unbind" 2>/dev/null || true
                  fi
                  echo "Removing device $(basename "$dev") from PCI bus..."
                  echo 1 > "$dev/remove" 2>/dev/null || true
              fi
          fi
      done

      echo "Done. It is now safe to unplug the Thunderbolt cable."
    '';
  };
in {
  environment.systemPackages = [egpu-disconnect];
}
