{pkgs, ...}: {
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
  };

  gtk = {
    enable = true;
    # No icon theme was set, so launchers (fuzzel) and GTK apps fell back to
    # Adwaita/hicolor, which lack icons for many apps (codium, android-studio,
    # nm-connection-editor, ...). Papirus covers almost everything.
    iconTheme = {
      package = pkgs.vimix-icon-theme;
      name = "Vimix-dark";
    };
    gtk3.extraConfig.gtk-enable-primary-paste = false;
    gtk4.extraConfig.gtk-enable-primary-paste = false;
  };
}
