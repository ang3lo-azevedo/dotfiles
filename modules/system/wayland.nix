{
  # Enable Ozone Wayland support in Chromium and Electron based applications
  environment.sessionVariables = {
    # Chromium/Electron Wayland support
    NIXOS_OZONE_WL = "1";
    
    # Wayland-specific variables
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    
    # Session type
    XDG_SESSION_TYPE = "wayland";
  };
}