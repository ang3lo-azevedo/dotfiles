{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kaon
  ];
}