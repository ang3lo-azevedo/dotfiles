{ pkgs, mpv-config, ... }:
{
  # MPV player configuration from a submodule
  home.file.".config/mpv" = {
    source = mpv-config;
    recursive = true;
  };

  home.packages = with pkgs; [
    grayjay
  ];

  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [ mpris sponsorblock ];
    };
  };

  # Ensure mpv cache directory exists
  home.file.".cache/mpv/.keep".text = "";

  # Create screenshots directory
  home.file."Pictures/mpv-screenshots/.keep".text = "";
}