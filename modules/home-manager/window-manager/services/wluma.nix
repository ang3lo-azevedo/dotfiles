{pkgs, ...}: let
  # Percentage taken off the brightness set by hand, from a black screen ("0") to a white one ("100"),
  # for each time-of-day name below. This works from the first start: nothing has to be learned.
  predictor.manual.thresholds = {
    night = {
      "0" = 30;
      "100" = 60;
    };
    dark = {
      "0" = 15;
      "100" = 40;
    };
    dim = {
      "0" = 0;
      "100" = 20;
    };
    normal = {
      "0" = 0;
      "100" = 15;
    };
    bright = {
      "0" = 0;
      "100" = 10;
    };
  };
in {
  services.wluma = {
    enable = true;
    # With a screen at 100%, the manual predictor can ask for more than the maximum.
    # Unpatched, wluma retries that forever: it floods the journal (hundreds of lines a
    # second) and burns CPU. The patch clamps the target to what the device accepts and
    # stops retrying a value the device refused. Drop this once nixpkgs moves past 4.11.
    #
    # wluma takes the brightness it finds at startup as set by hand at the current hour, so
    # after a night spent stopped it holds the daytime brightness the night ramp put back.
    # The second patch lets night-ramp.sh name the hour that brightness dates from
    # (WLUMA_START_HOUR): wluma then moves on to what the current hour calls for.
    package = pkgs.wluma.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          ./wluma-unreachable-target.patch
          ./wluma-start-hour.patch
        ];
    });
    settings = {
      # The laptop exposes no ambient light sensor, so the time of day stands in for it
      als.time.thresholds = {
        "0" = "night";
        "7" = "dark";
        "9" = "dim";
        "11" = "normal";
        "13" = "bright";
        "16" = "normal";
        "18" = "dark";
        "20" = "night";
      };

      output = {
        backlight = [
          {
            name = "eDP-1";
            path = "/sys/class/backlight/intel_backlight";
            capturer = "wayland";
            inherit predictor;
          }
        ];

        # Matched by model so they are found on whichever port they are plugged into.
        # A monitor that is not connected is skipped at startup.
        ddcutil = [
          {
            name = "MSI G27C4 E2";
            capturer = "wayland";
            inherit predictor;
          }
          {
            name = "MSI MP165 E6";
            capturer = "wayland";
            predictor = {
              manual.thresholds =
                predictor.manual.thresholds
                // {
                  night = {
                    "0" = 100;
                    "100" = 100;
                  };
                };
            };
          }
        ];
      };
    };
  };

  # Both MSI monitors answer DDC unreliably, so wluma gives up on direct access and polls
  # them by running ddcutil about once a second. The startup checks are most of the cost
  # of each run, and they are pointless when the bus is given explicitly.
  xdg.configFile."ddcutil/ddcutilrc".text = ''
    [global]
    options: --skip-ddc-checks
  '';

  # Created by the toggle in the swaync panel (monitor-brightness.sh) so that switching
  # automatic brightness off also holds across logins
  systemd.user.services.wluma = {
    Unit.ConditionPathExists = "!%S/wluma-disabled";
    # Notes the screens wluma can see, so output-watch.sh can tell which ones it missed
    Service.ExecStartPre = "-%h/.config/scripts/display/output-watch.sh record";
  };

  # wluma never looks for screens again after starting, and at login it starts before the
  # eGPU is up. The script is symlinked from the repo, so edits take effect without rebuilding.
  systemd.user.services.output-watch = {
    Unit = {
      Description = "Restart wluma when a screen it missed is plugged in";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "%h/.config/scripts/display/output-watch.sh";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
