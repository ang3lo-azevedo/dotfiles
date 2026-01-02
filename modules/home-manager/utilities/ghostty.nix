{ lib, ... }:
let
  ghosttyDir = ../../../home/ang3lo/.config/ghostty;
in
{
  programs.ghostty.enable = true;
  #xdg.configFile."ghostty/config".source = lib.mkForce (ghosttyDir + "/config");
}
