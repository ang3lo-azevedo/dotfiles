{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  home.packages = with pkgs; [
    antigravity-fhs
  ];
}