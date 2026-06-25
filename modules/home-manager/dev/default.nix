{pkgs, ...}: {
  imports = [
    ./python
    ./android
    ./git.nix
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
