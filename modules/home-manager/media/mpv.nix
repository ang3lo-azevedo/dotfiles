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

  # Register mpv-handler for custom protocols
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mpv-handler" = "mpv-handler.desktop";
      "x-scheme-handler/mpv-handler-debug" = "mpv-handler-debug.desktop";
    };
  };
}