{ mpv-config, ... }:
{
  programs.mpv = {
    enable = true;
  };

  # MPV player configuration from a submodule
  home.file.".config/mpv" = {
    source = mpv-config;
    recursive = true;
  };

  # Ensure mpv cache directory exists
  home.file.".cache/mpv/.keep".text = "";

  # Create screenshots directory
  home.file."Pictures/mpv-screenshots/.keep".text = "";
}