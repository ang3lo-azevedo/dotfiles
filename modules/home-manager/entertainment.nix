{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eqibop
    spicetify-cli
  ];
}
