{ lib, ... }:
let
  ghosttyDir = ../../../home/ang3lo/.config/ghostty;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      theme = "catppuccin-mocha";
    };
  };
}
