{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    devenv
    git
    gh
    #vscode
  ];
}
