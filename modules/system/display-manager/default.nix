{pkgs, ...}: let
  theme = "text=#ffffff;time=#62a6ff;container=#000000;border=#62a6ff;title=#b675f1;greet=#999999;prompt=#ffffff;input=#58c760;action=#444444;button=#62a6ff";
in {
  imports = [./wayland.nix];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions /run/current-system/sw/share/wayland-sessions --theme '${theme}'";
      user = "greeter";
    };
  };

  # Unlock the GNOME keyring on login so SSH/GPG agents and secret storage work.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Register niri as a system-level Wayland session so it appears in tuigreet.
  programs.niri.enable = true;
}
