{ pkgs, spicetify-nix, ... }:
{
  imports = [ spicetify-nix.homeManagerModules.default ];

  programs.spicetify.enable = true;

  home.packages = with pkgs; [
    eqibop
  ];
}
