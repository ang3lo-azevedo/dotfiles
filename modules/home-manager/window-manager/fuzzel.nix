{
  config,
  lib,
  ...
}: let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
in {
  programs.fuzzel.enable = true;
  stylix.targets.fuzzel.enable = false;

  xdg.configFile."fuzzel/fuzzel.ini" = lib.mkForce {source = mkSymlink "fuzzel/fuzzel.ini";};
  xdg.configFile."fuzzel/scripts" = lib.mkForce {source = mkSymlink "fuzzel/scripts";};
}
