{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pdftotext
  ];
}