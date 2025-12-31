{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    git
    gh
  ];
}
