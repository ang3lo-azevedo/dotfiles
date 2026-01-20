{ pkgs, lib, mpv-config, ... }:
let
  # Filter out .vscode directory from mpv-config source
  filteredMpvConfig = lib.cleanSourceWith {
    src = mpv-config;
    filter = path: type:
      let
        name = baseNameOf (toString path);
      in
        name != ".vscode" && name != ".git" && name != ".gitignore";
  };
in
{
  home.packages = [
    pkgs.mpv
    pkgs.mpv-handler
  ];

  # MPV player configuration from external git repository
  # Exclude .vscode directory as it's not part of mpv config
  xdg.configFile."mpv" = {
    source = filteredMpvConfig;
    recursive = true;
  };

  # Register mpv-handler for custom protocols
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mpv-handler" = [ "mpv-handler.desktop" ];
      "x-scheme-handler/mpv-handler-debug" = [ "mpv-handler-debug.desktop" ];
    };
  };
}
