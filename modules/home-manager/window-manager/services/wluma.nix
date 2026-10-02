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
    # With a screen at 100%, the manual predictor can ask for one step past the maximum.
    # Unpatched, wluma retries that forever: it floods the journal (hundreds of lines a
    # second) and burns CPU. Drop this once nixpkgs moves past 4.11.
    package = pkgs.wluma.overrideAttrs (old: {
      patches = (old.patches or []) ++ [./wluma-unreachable-target.patch];
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
            inherit predictor;
          }
        ];
      };
    };
  };

  # Created by the toggle in the swaync panel (monitor-brightness.sh) so that switching
  # automatic brightness off also holds across logins
  systemd.user.services.wluma.Unit.ConditionPathExists = "!%S/wluma-disabled";
}
