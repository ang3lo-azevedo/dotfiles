{ pkgs, ... }:
{
  imports = [
    ./mpv.nix
  ];

  home.packages = with pkgs; [
    grayjay
  ];
}