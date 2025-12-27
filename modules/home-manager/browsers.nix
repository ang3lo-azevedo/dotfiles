{ pkgs, inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser.enable = true;

  home.packages = with pkgs; [
    ungoogled-chromium
  ];
}
