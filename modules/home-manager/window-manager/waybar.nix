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

  # Custom systemd service with proper dependency ordering to avoid portal timeout
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      # Wait for niri and portal to be ready before starting waybar
      After = [ "niri.service" "xdg-desktop-portal.service" ];
      # Don't strictly require portal to be running, but wait for it if available
      Wants = [ "graphical-session.target" ];
      PartOf = [ "niri.service" ];
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