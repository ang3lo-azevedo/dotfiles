{ pkgs, ... }:
{
  imports = [
    ./mangowc.nix
    ./waybar.nix
    ./fuzzel.nix
    ./swaybg.nix
    ./swaync.nix
    ./wlsunset.nix
    ./iwmenu.nix
    ./pwmenu.nix
    ./bzmenu.nix
  ];
}