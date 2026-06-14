{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickemu
    quickgui
  ];
}
