{ pkgs, ... }:
{
  home.packages = with pkgs; [
    evtx
  ];
}
