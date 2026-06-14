{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickgui
  ];
}
