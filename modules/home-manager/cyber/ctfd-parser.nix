{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ctfd-parser
  ];
}
