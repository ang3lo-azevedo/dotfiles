{
  pkgs,
  inputs,
  ...
}: let
  wlxoverlayDir = inputs.self + "/home/ang3lo/.config/wayvr";
in {
  home.packages = with pkgs; [
    xr.wayvr
  ];

  xdg.configFile."wayvr" = {
    source = wlxoverlayDir;
  };
}
