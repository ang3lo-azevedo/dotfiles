{pkgs, ...}: {
  home.packages = [
    pkgs.gcr # Provides org.gnome.keyring.SystemPrompter
    pkgs.dconf # Required for GNOME/GTK settings
    pkgs.seahorse # Keyring manager GUI
  ];
}
