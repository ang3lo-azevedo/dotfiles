{ pkgs, ... }:
{
  home.packages = with pkgs; [
    spotify
    equibop
    spicetify-cli
  ];
}
