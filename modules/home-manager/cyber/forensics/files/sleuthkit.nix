{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sleuthkit
  ];
}