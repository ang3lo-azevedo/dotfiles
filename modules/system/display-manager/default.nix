{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  theme = "text=#${c.base05};time=#${c.base0D};container=#${c.base00};border=#${c.base0D};title=#${c.base0E};greet=#${c.base04};prompt=#${c.base05};input=#${c.base0B};action=#${c.base03};button=#${c.base0D}";
in {
  imports = [./wayland.nix];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --sessions /run/current-system/sw/share/wayland-sessions --theme '${theme}'";
      user = "greeter";
    };
  };

  # Unlock the GNOME keyring on login so SSH/GPG agents and secret storage work.
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Register niri as a system-level Wayland session so it appears in tuigreet.
  programs.niri.enable = true;
}
