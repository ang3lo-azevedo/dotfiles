{ pkgs, ... }:
{
  home.packages = with pkgs; [
    foot
    equibop
  ];
}
