{ pkgs, ... }:
{
  imports = [
    ./zen-browser
  ];
  home.packages = with pkgs; [
    ungoogled-chromium
  ];
}
