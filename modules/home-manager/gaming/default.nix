{ pkgs, ... }:
{
  imports = [
    ./protonup.nix
    ./lutris.nix
    ./mangohud.nix
    ./vr.nix
  ];

  home.packages = with pkgs; [
    owmods-gui
  ];
}
