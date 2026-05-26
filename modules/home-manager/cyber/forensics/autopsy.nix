{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autopsy
  ];
}