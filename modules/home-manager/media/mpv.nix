{ pkgs, mpv-config, ... }:
{
  home.packages = [
    pkgs.mpv
    pkgs.mpv-handler
  ];

  # MPV player configuration from external git repository
  xdg.configFile."mpv" = {
    source = mpv-config;
    recursive = true;
  };
}