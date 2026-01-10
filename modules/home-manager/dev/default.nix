{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./code-editors
  ];

  home.packages = with pkgs; [
    nixfmt
    nil
  ];
}
