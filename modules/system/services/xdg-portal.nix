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

      # Niri screen sharing needs xdg-desktop-portal-gnome, which implements the
      # PipeWire-based ScreenCast/Screenshot portals that xdg-desktop-portal-gtk lacks.
      # mkForce overrides the common.default fallback set above.
      niri = {
        default = lib.mkForce [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = [
          "gnome"
        ];
        "org.freedesktop.impl.portal.Screenshot" = [
          "gnome"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "termfilechooser"
        ];
        "org.freedesktop.impl.portal.OpenURI" = [
          "gtk"
        ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xdg-desktop-portal-termfilechooser
    ];
  };
}
