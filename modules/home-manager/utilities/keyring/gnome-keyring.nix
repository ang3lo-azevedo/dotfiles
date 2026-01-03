{ pkgs, ... }:
{
  services.gnome-keyring.enable = true;
  home.packages = [ 
    pkgs.gcr # Provides org.gnome.keyring.SystemPrompter
    pkgs.dconf # Required for GNOME/GTK settings
  ];
}
