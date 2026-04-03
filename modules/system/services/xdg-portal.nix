{ lib, pkgs, ... }:
{
  # Enable XDG Desktop Portal for niri
  xdg.portal = {
    enable = true;
    config = {
      common.default = [
        "gtk"
      ];

      # Niri screen sharing needs a backend that actually exposes ScreenCast.
      niri = {
        default = lib.mkForce [
          "wlr"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "wlr"
        ];
        "org.freedesktop.impl.portal.Screenshot" = [
          "wlr"
        ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
