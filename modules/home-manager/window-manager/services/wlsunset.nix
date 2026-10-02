{
  pkgs,
  inputs,
  ...
}: let
  dayTemp = "6500";
  nightTemp = "2500";

  tempStateFile = ''"''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-night-temp"'';

  # Created by wlsunset-mode.sh when its toggle in the swaync panel is switched off
  rampDisabledFile = ''"''${XDG_STATE_HOME:-$HOME/.local/state}/wlsunset-auto-disabled"'';

  # Minutes over which the night light fades in and the screens dim
  rampMinutes = 90;

  # Read by night-ramp.sh so the brightness follows the same window
  sunTimesFile = ''"''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wlsunset-sun-times"'';

  get-location = pkgs.writeShellApplication {
    name = "get-location";
    runtimeInputs = with pkgs; [curl jq];
    text = builtins.readFile (inputs.self + "/home/ang3lo/.config/wlsunset/get-location.sh");
  };

  wlsunset-auto = pkgs.writeShellScriptBin "wlsunset-auto" ''
    read -r latitude longitude <<< "$(${get-location}/bin/get-location)"
    night=$(cat ${tempStateFile} 2>/dev/null || echo ${nightTemp})

    # Following the sun was switched off (night-ramp.sh): hold the night temperature all day.
    # wlsunset has no fixed mode, so give it a day temperature one step above the night one.
    if [ -e ${rampDisabledFile} ]; then
      echo "Starting wlsunset fixed at ''${night}K" >&2
      exec ${pkgs.wlsunset}/bin/wlsunset -S 07:00 -s 19:00 -T $((night + 1)) -t $night
    fi

    [[ $latitude == -* ]] && lat="''${latitude#-}S" || lat="''${latitude}N"
    [[ $longitude == -* ]] && lon="''${longitude#-}W" || lon="''${longitude}E"
    read -r sunrise sunset <<< "$(${pkgs.sunwait}/bin/sunwait list 1 daylight "$lat" "$lon" | tr -d ',')"
    [[ $sunrise == ??:?? && $sunset == ??:?? ]] || { sunrise=07:00; sunset=19:00; }

    # Center the 90-minute ramp exactly on the actual sunset
    # (starts 45 minutes before, ends 45 minutes after)
    ramp_start=$(date -d "$sunset 45 minutes ago" +%H:%M)
    ramp_end=$(date -d "$ramp_start ${toString rampMinutes} minutes" +%H:%M)
    echo "$ramp_start $ramp_end $sunrise" > ${sunTimesFile}

    echo "Starting wlsunset with lat=$latitude lon=$longitude: fading $ramp_start-$ramp_end, day again at $sunrise" >&2
    exec ${pkgs.wlsunset}/bin/wlsunset -S "$sunrise" -s "$ramp_start" -d ${toString (rampMinutes * 60)} -T ${dayTemp} -t $night
  '';
in {
  services.wlsunset.enable = false;

  systemd.user = {
    services = {
      wlsunset = {
        Unit = {
          Description = "Day/night gamma adjustments for Wayland (auto-location)";
          After = ["graphical-session.target" "network-online.target"];
          Wants = ["network-online.target"];
          PartOf = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${wlsunset-auto}/bin/wlsunset-auto";
          Restart = "on-failure";
          RestartSec = 5;
          StandardOutput = "journal";
          StandardError = "journal";
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };

      # The sun times are fixed when wlsunset starts: recompute them once a day,
      # at noon, when the screen is at day temperature and the restart is invisible.
      wlsunset-refresh = {
        Unit.Description = "Restart wlsunset to refresh its sun times";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemctl --user try-restart wlsunset.service";
        };
      };

      # The script is symlinked from the repo with the other waybar scripts, so edits take effect without rebuilding.
      night-ramp = {
        Unit.Description = "Dim the screens towards sunset and restore them at sunrise";
        Service = {
          Type = "oneshot";
          ExecStart = "%h/.config/scripts/display/night-ramp.sh";
        };
      };
    };

    timers = {
      wlsunset-refresh = {
        Unit.Description = "Refresh the wlsunset sun times daily";
        Timer.OnCalendar = "12:00";
        Install.WantedBy = ["timers.target"];
      };

      night-ramp = {
        Unit.Description = "Step the screen brightness down towards sunset";
        Timer.OnCalendar = "*:0/5";
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
