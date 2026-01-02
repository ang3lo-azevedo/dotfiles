{ lib, ... }:
let
  ghosttyDir = ../../../home/ang3lo/.config/ghostty;
in
{
  programs.ghostty.enable = true;
  stylix.targets.ghostty.enable = false;
  xdg.configFile."ghostty/config".source = lib.mkForce (ghosttyDir + "/config");
}
