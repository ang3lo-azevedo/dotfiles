{ lib, ... }:
let
  # Keep swaync config in-repo, but feed it via service options to avoid
  # xdg.configFile path collisions with the upstream Home Manager module.
  swayncConfigDir = ../../../../home/ang3lo/.config/swaync;
in
{
  services.swaync.enable = true;
  stylix.targets.swaync.enable = false;

  services.swaync.settings = lib.mkForce (builtins.fromJSON (builtins.readFile "${swayncConfigDir}/config.json"));
  services.swaync.style = lib.mkForce "${swayncConfigDir}/style.css";
}
