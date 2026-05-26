{ pkgs, ... }:
{
  imports = [
    ./python
    ./android
    ./git.nix
    ./intellij-idea.nix
    ./code-editors
    ./adb.nix
    ./latex.nix
    ./game-dev
  ];

  home.packages = with pkgs; [
    nixfmt
    nil
    cargo
    tmux
  ];
}