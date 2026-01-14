{ pkgs, ... }:
{
  imports = [
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
< 