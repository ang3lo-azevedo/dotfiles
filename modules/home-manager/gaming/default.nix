{ pkgs, ... }:
{
  imports = [
    ./protonup.nix
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
    ./vr
    ./emulators
  ];

  home.packages = with pkgs; [
    owmods-gui
  ];
}
