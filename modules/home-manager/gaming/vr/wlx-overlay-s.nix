{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wlx-overlay-s
  ];
}