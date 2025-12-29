{ pkgs, ... }:
{
  imports = [
    ./python
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    #vscode
  ];
}
