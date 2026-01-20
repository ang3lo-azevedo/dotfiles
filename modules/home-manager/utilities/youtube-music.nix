{ inputs, ... }:
{
  imports = [
    inputs.youtube-music.homeManagerModules.default
  ];
  programs.youtube-music = {
    enable = true;
    options = {
      tray = true;
    };
  };
}
