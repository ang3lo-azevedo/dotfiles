{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    git
    gh
    #vscode
  ];
}
