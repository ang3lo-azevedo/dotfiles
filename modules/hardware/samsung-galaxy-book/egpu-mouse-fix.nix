{pkgs, ...}: let
  rebind-mouse = pkgs.writeShellApplication {
    name = "egpu-mouse-rebind";
    text = ''
      # Connecting the Thunderbolt eGPU knocks the Logitech receiver off the USB
      # bus until it is physically replugged. Toggling authorized off then on
      # drives the same remove/add uevents, which re-enumerates the receiver and
      # makes niri/libinput grab the mouse again.
      for d in /sys/bus/usb/devices/*; do
        [ "$(cat "$d/idVendor" 2>/dev/null)" = "046d" ] || continue
        [ "$(cat "$d/idProduct" 2>/dev/null)" = "c53f" ] || continue
        echo 0 > "$d/authorized"
        sleep 1
        echo 1 > "$d/authorized"
      done
    '';
  };
in {
  systemd.services.egpu-mouse-rebind = {
    description = "Re-enumerate the Logitech receiver after the eGPU connects";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${rebind-mouse}/bin/egpu-mouse-rebind";
    };
  };

  # amdgpu binds only once the eGPU is up, so the toggle lands after the glitch.
  # The eGPU is the laptop's only AMD device, so the driver match is unambiguous.
  services.udev.extraRules = ''
    ACTION=="bind", SUBSYSTEM=="pci", DRIVER=="amdgpu", RUN+="${pkgs.systemd}/bin/systemctl start --no-block egpu-mouse-rebind.service"
  '';
}
