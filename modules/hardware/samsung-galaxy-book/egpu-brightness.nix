{ pkgs, ... }:
let
  egpu-brightness = pkgs.writeShellApplication {
    name = "egpu-brightness";
    runtimeInputs = [ pkgs.brightnessctl ];
    text = ''
      # Increase laptop brightness to maximum
      brightnessctl set 100%
    '';
  };
in
{
  services.udev.extraRules = ''
    # Trigger brightness increase when AMD eGPU (vendor 0x1002) is connected
    ACTION=="add", SUBSYSTEM=="pci", ATTRS{vendor}=="0x1002", RUN+="${egpu-brightness}/bin/egpu-brightness"
  '';

  # Optional: Also add the script to system packages so it can be run manually
  environment.systemPackages = [ egpu-brightness ];
}
