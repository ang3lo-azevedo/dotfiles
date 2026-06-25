{pkgs, ...}: {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    # Explicit size prevents GTK apps (e.g. waybar) from inheriting an
    # oversized default cursor on scaled displays
    size = 24;
  };
}
