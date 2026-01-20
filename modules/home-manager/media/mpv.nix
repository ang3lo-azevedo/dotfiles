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
}
