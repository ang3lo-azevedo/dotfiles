{ pkgs, ... }:
let
  wlxoverlayDir = ../../../../home/ang3lo/.config/wayvr;
in
{
  home.packages = with pkgs; [
    wayvr
  ];

  xdg.configFile."wayvr" = {
    source = wlxoverlayDir;
  };
}
