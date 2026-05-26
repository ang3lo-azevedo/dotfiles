{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ida-pro
  ];
}