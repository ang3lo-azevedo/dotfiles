{ pkgs, mpv-config, ... }:
{
  # MPV player configuration from a submodule
  home.file.".config/mpv" = {
    source = mpv-config;
    recursive = true;
  };

  # ...existing code...
}