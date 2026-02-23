{ pkgs, ... }:
{
  programs.binary-ninja = {
    enable = true;
    package = pkgs.binary-ninja-free-wayland;
  };
}