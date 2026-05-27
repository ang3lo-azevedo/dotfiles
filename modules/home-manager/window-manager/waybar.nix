{ pkgs, ... }:
let
  # Path (relative to this file) to the repo directory containing waybar configs
  waybarDir = ../../../home/ang3lo/.config/waybar;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };
  stylix.targets.waybar.enable = false;

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      Wants = [ "niri.service" "xdg-desktop-portal.service" ];
      After = [ "niri.service" "xdg-desktop-portal.service" ];
      PartOf = [ "niri.service" ];
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
      Type = "simple";
    };
  };

  xdg.configFile."waybar" = {
    source = waybarDir;
    recursive = true;
  };
}