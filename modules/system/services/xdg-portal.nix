{
  lib,
  pkgs,
  ...
}: {
  # Enable XDG Desktop Portal for niri
  xdg.portal = {
    enable = true;
    config = {
      common.default = [
        "gtk"
      ];

      # Niri screen sharing needs xdg-desktop-portal-wlr, which implements the
      # PipeWire-based ScreenCast/Screenshot portals that xdg-desktop-portal-gtk lacks.
      # mkForce overrides the common.default fallback set above.
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
