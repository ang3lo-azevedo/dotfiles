{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jadx
  ];
}