{ pkgs, ... }:
{
  imports = [
    #./mpv.nix
  ];

  home.packages = with pkgs; [
    #grayjay
    #spotify
    #spicetify-cli
  ];
}