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
    jq
    nixfmt
    nil
    cargo
    tmux
  ];
}
