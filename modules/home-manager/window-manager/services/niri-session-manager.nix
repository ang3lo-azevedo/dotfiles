{ pkgs, config, lib, ... }:
let
  niri-session-manager = pkgs.callPackage ../../../../pkgs/niri-session-manager {};
in
{
  systemd.user.services.niri-session-manager = {
    Unit = {
      Description = "Niri session manager to save/restore open windows";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${niri-session-manager}/bin/niri-session-manager";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
