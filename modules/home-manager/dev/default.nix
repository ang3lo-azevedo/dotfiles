{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    #vscode
  ];
}
