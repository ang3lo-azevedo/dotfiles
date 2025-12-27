{ pkgs, ... }:
{
  # Gaming related configurations
  # VR support imported from a separate file
  imports = [
    ./vr.nix
  ];

  home.packages = with pkgs; [
    lutris
  ];
}
