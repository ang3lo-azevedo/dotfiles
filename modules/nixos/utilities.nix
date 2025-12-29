{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  environment.systemPackages = [
    fastfetch
    git
    gh
    pkgs.ghostty
  ];
}
