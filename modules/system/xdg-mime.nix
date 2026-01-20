{ lib, ... }:

{
  xdg = {
    mime = {
      enable = true;
      addedAssociations = {
        "x-scheme-handler/mpv-handler" = [ "mpv-handler.desktop" ];
        "x-scheme-handler/mpv-handler-debug" = [ "mpv-handler-debug.desktop" ];
      };
    };
  };
}
