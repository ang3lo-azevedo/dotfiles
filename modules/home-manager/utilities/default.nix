{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./ghostty.nix
    ./nixcord.nix
    ./spicetify.nix
  ];

  home.packages = with pkgs; [
    wgnord
  ];
}
