{pkgs, ...}: {
  imports = [./wayland.nix];

  # greetd is a minimal Wayland-native login daemon.
  # tuigreet provides the TUI frontend; --remember saves the last username,
  # --sessions points at the system wayland-sessions dir so any installed
  # compositor (niri, etc.) shows up automatically without hardcoding store paths.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --sessions /run/current-system/sw/share/wayland-sessions";
      user = "greeter";
    };
  };

  # Unlock the GNOME keyring on login so SSH/GPG agents and secret storage work.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Register niri as a system-level Wayland session so it appears in tuigreet.
  programs.niri.enable = true;
}
