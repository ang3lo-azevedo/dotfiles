{ pkgs, ... }:
{
  home.packages = with pkgs; [
    inform7
  ];
}