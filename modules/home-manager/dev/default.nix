{pkgs, ...}: {
  imports = [
    ./python
    ./java
    ./android
    ./git.nix
    ./lazygit.nix
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
    # nom renders the live build tree and points at the exact derivation that failed;
    # nvd prints the package version diff after a switch. Both drive the rebuild aliases
    nix-output-monitor
    nvd
    cargo
    tmux
  ];
}
