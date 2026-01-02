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
}