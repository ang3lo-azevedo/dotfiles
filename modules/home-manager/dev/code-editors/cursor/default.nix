{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  home.packages = with pkgs; [
    code-cursor
  ];

  home.shellAliases = {
    #code = "cursor";
  };
}
