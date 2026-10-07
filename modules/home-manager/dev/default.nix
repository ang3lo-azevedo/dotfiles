{pkgs, ...}: {
  imports = [
    ./python
    ./java
    ./android
    ./git.nix
    ./code-editors
    ./adb.nix
    ./make.nix
    ./go.nix
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
