{ pkgs, ... }:
let
  # Path (relative to this file) to the repo directory containing waybar configs
  waybarDir = ../../../home/ang3lo/.config/waybar;
in
{
  programs.waybar = {
    enable = true;
    # Disable home-manager's default systemd management to use custom service
    systemd.enable = false;
  };
  stylix.targets.waybar.enable = false;

  # Start Waybar with niri, but bind its lifetime to the active graphical session.
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      After = [
        "graphical-session.target"
        "xdg-desktop-portal.service"
      ];
      Wants = [ "xdg-desktop-portal.service" ];
      PartOf = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 3;
      Type = "simple";
    };
  };

  xdg.configFile."waybar" = {
    source = waybarDir;
    recursive = true;
  };
}
