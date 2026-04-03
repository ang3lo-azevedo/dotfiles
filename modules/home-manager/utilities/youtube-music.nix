{ inputs, ... }:
{
  imports = [
    inputs.pear-desktop.homeManagerModules.default
  ];

  programs.youtube-music = {
    enable = true;
    options = {
      tray = true;
    };
  };
}
