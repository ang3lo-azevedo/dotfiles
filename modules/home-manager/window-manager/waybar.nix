{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/${path}";
  scripts = "/home/ang3lo/.config/waybar/scripts";

  # Runs once at session start: enumerates all connected outputs and starts
  # a waybar-output@ and waybar-trigger@ instance for each.
  waybarAutostart = pkgs.writeShellScript "waybar-autostart" ''
    ${pkgs.niri}/bin/niri msg --json outputs | ${pkgs.jq}/bin/jq -r 'keys[]' | while IFS= read -r output; do
      systemctl --user start "waybar-output@''${output}.service"
      systemctl --user start "waybar-trigger@''${output}.service"
    done
  '';

  # Polls connected outputs every 3 seconds and reconciles waybar instances.
  # Event-stream filtering was unreliable for physical connect/disconnect since
  # Niri only emits config-change events, not plug/unplug events.
  waybarHotplug = pkgs.writeShellScript "waybar-hotplug" ''
    while true; do
      current=$(${pkgs.niri}/bin/niri msg --json outputs | ${pkgs.jq}/bin/jq -r 'keys[]' 2>/dev/null) || { sleep 3; continue; }

      # Stop services for outputs no longer connected
      systemctl --user list-units --state=active --plain --no-legend 'waybar-output@*.service' 2>/dev/null \
        | ${pkgs.gawk}/bin/awk '{print $1}' | while IFS= read -r unit; do
            output="''${unit#waybar-output@}"
            output="''${output%.service}"
            echo "''${current}" | ${pkgs.gnugrep}/bin/grep -qx "''${output}" || {
              systemctl --user stop "waybar-output@''${output}.service"
              systemctl --user stop "waybar-trigger@''${output}.service"
            }
          done

      # Start services for connected outputs that don't have waybar running
      echo "''${current}" | while IFS= read -r output; do
        [ -z "''${output}" ] && continue
        systemctl --user is-active --quiet "waybar-output@''${output}.service" || {
          systemctl --user start "waybar-output@''${output}.service"
          systemctl --user start "waybar-trigger@''${output}.service"
        }
      done

      sleep 3
    done
  '';
in {
  programs.waybar = {
    enable = true;
    # Disable the built-in systemd integration: we manage waybar instances
    # manually via per-output template services instead of a single global one.
    systemd.enable = false;
  };

  home.packages = with pkgs; [
    playerctl
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.scrollmpris
  ];

  stylix.targets.waybar.enable = false;

  # Config files are symlinked from the repo so edits take effect without rebuilding.
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
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          Type = "oneshot";
          ExecStart = "${waybarAutostart}";
          RemainAfterExit = true;
        };
      };

      # Template service: one instance per output, named by output (e.g. waybar-output@eDP-1).
      # Manually: systemctl --user start waybar-output@DP-3
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
          Environment = "GDK_TOUCH_EMULATE_POINTER=1";
        };
      };

      # Companion trigger bar per output (hidden bar used to reveal the main bar).
      "waybar-trigger@" = {
        Unit = {
          Description = "Waybar trigger bar for output %i";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${scripts}/start-waybar-trigger.sh %i";
          Restart = "always";
          RestartSec = "3";
        };
      };

      # Long-running service that reacts to Niri output connect/disconnect events
      # and starts or stops the corresponding waybar-output@ instances.
      waybar-hotplug = {
        Unit = {
          Description = "Start/stop Waybar when outputs are connected or disconnected";
          After = ["graphical-session.target" "waybar-autostart.service"];
          PartOf = ["graphical-session.target"];
        };
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          ExecStart = "${waybarHotplug}";
          Restart = "on-failure";
          RestartSec = "3";
        };
      };

      # Triggered by waybar-config.path when config files change on disk.
      waybar-reload = {
        Unit.Description = "Reload all active Waybar instances";
        Service.Type = "oneshot";
        Service.ExecStart = "${scripts}/waybar-reload.sh";
      };
    };

    # Watches the live config files in the repo and triggers a reload on save,
    # so changes to config.jsonc or style.css take effect immediately.
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
