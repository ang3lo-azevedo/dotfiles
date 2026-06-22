{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  home.packages = with pkgs; [
    code-cursor
    #cursor-id-modifier
  ];

  home.shellAliases = {
    #code = "cursor";
  };
}
