{ pkgs, ... }:
{
  imports = [
    ./python
    ./git.nix
    ./code-editors
    ./adb.nix
  ];

  home.packages = with pkgs; [
    nixfmt
    nil
    cargo
  ];
}