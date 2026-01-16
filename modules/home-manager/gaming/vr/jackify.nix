{ pkgs, ... }:
{
  home.packages = with pkgs;[
    jackify
  ];
}