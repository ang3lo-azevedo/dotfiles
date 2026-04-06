{ pkgs, ... }:
{
  imports = [
    ./python
    ./git.nix
    ./intellij-idea.nix
    ./code-editors
    ./adb.nix
    ./latex.nix
    ./processing.nix
  ];

  home.packages = with pkgs; [
    nixfmt
    nil
    cargo
    tmux
  ];
}