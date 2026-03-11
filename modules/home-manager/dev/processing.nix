{ pkgs, ... }:
{
  home.packages = with pkgs; [
    processing
  ]; 
}