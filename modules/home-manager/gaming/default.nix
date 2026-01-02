{ pkgs, ... }:
{
  imports = [
    ./vr.nix
  ];

  home.packages = with pkgs; [
    lutris
  ];
}
