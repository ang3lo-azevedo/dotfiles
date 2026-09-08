{pkgs, ...}: {
  imports = [
    ./python
    ./java
    ./android
    ./git.nix
    ./code-editors
    ./adb.nix
    ./latex.nix
    ./typst.nix
    ./game-dev
  ];

  home.packages = with pkgs; [
    nixfmt
    nil
    cargo
    tmux
  ];
}
