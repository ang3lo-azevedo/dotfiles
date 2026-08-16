{pkgs, ...}: {
  home.packages = [pkgs.lisgd];

  systemd.user.services.lisgd = {
    Unit = {
      Description = "lisgd (libinput-gestures) for touchscreen swipes";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = ''
        ${pkgs.writeShellScript "start-lisgd" ''
          TOUCH_EVENT=$(grep -E 'Name=".*(Touchscreen|GXTP7936).*"' -A 4 /proc/bus/input/devices | grep -o 'event[0-9]*' | head -1)
          if [ -n "$TOUCH_EVENT" ]; then
            exec ${pkgs.lisgd}/bin/lisgd -d /dev/input/$TOUCH_EVENT \
              -g "3,RL,*,*,${pkgs.niri}/bin/niri msg action focus-column-right" \
              -g "3,LR,*,*,${pkgs.niri}/bin/niri msg action focus-column-left" \
              -g "3,DU,*,*,${pkgs.niri}/bin/niri msg action focus-workspace-down" \
              -g "3,UD,*,*,${pkgs.niri}/bin/niri msg action focus-workspace-up" \
              -g "4,DU,*,*,${pkgs.niri}/bin/niri msg action toggle-overview" \
              -g "4,UD,*,*,${pkgs.niri}/bin/niri msg action close-window"
          else
            echo "Touchscreen not found!"
            exit 1
          fi
        ''}
      '';
      Restart = "always";
      RestartSec = "3";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
