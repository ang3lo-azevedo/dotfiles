{ pkgs, config, ... }:
let
  mpvConfigPath = "${config.home.homeDirectory}/.config/dotfiles/home/ang3lo/config/mpv";
in
{
  home.packages = with pkgs; [
    mpv
    grayjay
  ];

  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [ mpris sponsorblock ];
    };
  };

  # Link the entire mpv config directory from the submodule
  home.file.".config/mpv" = {
    source = ../home/ang3lo/config/mpv;
    recursive = true;
  };

  # Ensure mpv cache directory exists
  home.file.".cache/mpv/.keep".text = "";
  
  # Create screenshots directory
  xdg.userDirs.pictures = "${config.home.homeDirectory}/Pictures";
  home.file."Pictures/mpv-screenshots/.keep".text = "";
}