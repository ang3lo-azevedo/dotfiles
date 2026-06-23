{ lib, config, ... }:
let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
in
{
  services.swaync.enable = true;
  stylix.targets.swaync.enable = false;

  xdg.configFile."swaync/config.json" = lib.mkForce { source = mkSymlink "swaync/config.json"; };
  xdg.configFile."swaync/style.css" = lib.mkForce { source = mkSymlink "swaync/style.css"; };
}
