{ pkgs, ... }:
{
  # Enable XDG Desktop Portal for niri
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = ["gtk" "wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.RemoteDesktop" = "wlr";
      };
    };
    xdgOpenUsePortal = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
