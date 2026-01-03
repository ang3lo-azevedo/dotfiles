{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nautilus
    adwaita-icon-theme
  ];
}