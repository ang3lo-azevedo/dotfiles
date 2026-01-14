{ pkgs, ... }:
{
  imports = [
    ./lutris.nix
    ./mangohud.nix
    ./prismlauncher.nix
    ./vr
  ];

  home.packages = with pkgs; [
    owmods-gui
  ];
}
