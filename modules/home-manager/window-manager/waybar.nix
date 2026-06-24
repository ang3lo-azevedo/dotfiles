{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    playerctl
    inputs.self.packages.${pkgs.system}.scrollmpris
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
    services.waybar-trigger = {
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

    paths.waybar-config = {
      Unit.Description = "Watch Waybar configuration for changes";
      Path.PathModified = [
        "/home/ang3lo/nix-config/home/ang3lo/.config/waybar/config.jsonc"
        "/home/ang3lo/nix-config/home/ang3lo/.config/waybar/style.css"
      ];
      Path.Unit = "waybar-reload.service";
      Install.WantedBy = ["waybar.service"];
    };

    services.waybar-reload = {
      Unit.Description = "Reload Waybar";
      Service.Type = "oneshot";
      Service.ExecStart = "${pkgs.systemd}/bin/systemctl --user reload waybar.service";
    };
  };
}
