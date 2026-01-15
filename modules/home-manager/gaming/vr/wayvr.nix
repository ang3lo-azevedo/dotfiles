{ pkgs, ... }:
let
  wlxoverlayDir = "../../../../home/ang3lo/.config/wlxoverlay";
in
{
  home.packages = with pkgs; [
    wayvr
  ];

  xdg.config."wlxoverlay" = {
    source = wlxoverlayDir;
  };
}
