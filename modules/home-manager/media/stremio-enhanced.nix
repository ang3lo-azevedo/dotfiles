{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stremio-enhanced
  ];

  xdg.desktopEntries.stremio-enhanced = {
    name = "Stremio Enhanced";
    exec = "${pkgs.stremio-enhanced}/bin/stremio-enhanced";
    icon = "video-x-generic";
    categories = [ "AudioVideo" "Video" ];
    comment = "Electron-based Stremio desktop client with plugins and themes support";
  };
}