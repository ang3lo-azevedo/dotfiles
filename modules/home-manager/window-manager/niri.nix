{ pkgs, ... }:
let
  niriConfig = ../../../home/ang3lo/.config/niri;
in
{
  xdg.configFile."niri" = {
    source = niriConfig;
  };

  home.packages = with pkgs; [
    xwayland-satellite
  ];
}