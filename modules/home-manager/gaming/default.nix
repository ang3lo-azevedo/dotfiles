{ pkgs, ... }:
{
  imports = [
    ./protonup.nix
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
    ./vr
  ];

  home.packages = with pkgs; [
    owmods-gui
  ];
}
