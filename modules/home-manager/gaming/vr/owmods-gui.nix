{ pkgs, ... }:
{
  home.packages = with pkgs; [
    owmods-gui
  ];
}