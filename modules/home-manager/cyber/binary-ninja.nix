{ pkgs, ... }:
{
  programs.binary-ninja = {
    enable = true;
    # TODO: Remove this override once the upstream package is updated to work with the latest xorg server.
    package = pkgs.binary-ninja-free-wayland.override {
      # Upstream package still references deprecated xorg.* aliases.
      xorg = pkgs.xorg // {
        libXi = pkgs.libxi;
        libXrender = pkgs.libxrender;
        xcbutilimage = pkgs.libxcb-image;
        xcbutilrenderutil = pkgs.libxcb-render-util;
      };
    };
  };
}