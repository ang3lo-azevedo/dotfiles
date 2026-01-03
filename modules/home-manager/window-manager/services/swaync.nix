{ lib, ... }:
let
  # Path (relative to this file) to the repo directory containing swaync configs
  swayncDir = ../../../../home/ang3lo/.config/swaync;
in
{
  services.swaync.enable = true;
  stylix.targets.swaync.enable = false;

  # Use lib.mkForce so these home-manager `xdg.configFile` entries have
  # priority over other module definitions and avoid conflicting values.
  xdg.configFile."swaync" = lib.mkForce {
    source = swayncDir;
    recursive = true;
  };
}
