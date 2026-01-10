{ pkgs, ... }:
{
  imports = [
    ./protonup.nix
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
  ];

  home.packages = with pkgs; [
    owmods-gui
  ];
}
