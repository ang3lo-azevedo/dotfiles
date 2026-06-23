{ config, ... }:
let
  fuzzelDir = config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/fuzzel";
in
{
  programs.fuzzel.enable = true;
  stylix.targets.fuzzel.enable = false;
  
  xdg.configFile."fuzzel" = {
    source = fuzzelDir;
  };
}