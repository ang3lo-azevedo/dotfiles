{ pkgs, ... }:
{
  home.packages = with pkgs; [
    universal-android-debloater
  ];
}