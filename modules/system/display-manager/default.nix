{
  config,
  pkgs,
  ...
}: let
  theme = "text=#ffffff;time=#999999;container=#000000;border=#2a2a2a;title=#ffffff;greet=#999999;prompt=#ffffff;input=#ffffff;action=#444444;button=#ffffff";
  sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
in {
  imports = [./wayland.nix];

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions ${sessions} --theme '${theme}'";
      user = "greeter";
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  programs.niri.enable = true;
}
