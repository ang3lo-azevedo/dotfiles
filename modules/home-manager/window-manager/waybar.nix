{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
  scripts = "/home/ang3lo/.config/waybar/scripts";
in {
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };

  home.packages = with pkgs; [
    playerctl
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.scrollmpris
  ];

  stylix.targets.waybar.enable = false;

  xdg.configFile = {
    "waybar/config.jsonc" = lib.mkForce {source = mkSymlink "waybar/config.jsonc";};
    "waybar/style.css" = lib.mkForce {source = mkSymlink "waybar/style.css";};
    "waybar/scripts" = lib.mkForce {source = mkSymlink "waybar/scripts";};
    "waybar/trigger.jsonc" = lib.mkForce {source = mkSymlink "waybar/trigger.jsonc";};
    "waybar/trigger.css" = lib.mkForce {source = mkSymlink "waybar/trigger.css";};
  };

  systemd.user = {
    services = {
      waybar-autostart = {
        Unit = {
          Description = "Start Waybar on all connected outputs";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${scripts}/waybar-autostart.sh";
          RemainAfterExit = true;
        };
      };

      # Template service for any output. Start with:
      # systemctl --user start waybar-output@DP-3
      "waybar-output@" = {
        Unit = {
          Description = "Waybar for output %i";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${scripts}/start-waybar-output.sh %i";
          Restart = "always";
          RestartSec = "3";
        };
      };

      waybar-trigger = {
        Unit = {
          Description = "Waybar trigger bar";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.waybar}/bin/waybar -c /home/ang3lo/nix-config/home/ang3lo/.config/waybar/trigger.jsonc -s /home/ang3lo/nix-config/home/ang3lo/.config/waybar/trigger.css";
          Restart = "always";
          RestartSec = "3";
        };
      };

      waybar-reload = {
        Unit.Description = "Reload all active Waybar instances";
        Service.Type = "oneshot";
        Service.ExecStart = "${scripts}/waybar-reload.sh";
      };
    };

    paths.waybar-config = {
      Unit.Description = "Watch Waybar configuration for changes";
      Path.PathModified = [
        "/home/ang3lo/nix-config/home/ang3lo/.config/waybar/config.jsonc"
        "/home/ang3lo/nix-config/home/ang3lo/.config/waybar/style.css"
      ];
      Path.Unit = "waybar-reload.service";
      Install.WantedBy = ["waybar-autostart.service"];
    };
  };
}
