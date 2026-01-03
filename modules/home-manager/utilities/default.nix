{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./ghostty.nix
    ./nixcord.nix
    ./spicetify.nix
    ./wlr-randr.nix
    ./wlr-layout-ui.nix
    ./fastfetch.nix
    ./pavucontrol.nix
    ./nautilus.nix
    ./trakt-scrobbler.nix
  ];

  home.packages = with pkgs; [
    wgnord
  ];
}
