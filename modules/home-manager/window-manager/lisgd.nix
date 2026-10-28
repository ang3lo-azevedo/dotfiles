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
            # Touchscreen swipes mirror niri's built-in touchpad gestures: 3 fingers
            # move between columns/workspaces, 4 fingers up/down open/close the overview.
            # A 1-finger swipe down from the top edge toggles the laptop's Waybar, the
            # touch equivalent of scrolling the trigger bar (touch does not emit scroll
            # events, so the on-scroll toggle alone is unreachable by finger).
            exec ${pkgs.lisgd}/bin/lisgd -d /dev/input/$TOUCH_EVENT \
              -g "3,RL,*,*,${pkgs.niri}/bin/niri msg action focus-column-right" \
              -g "3,LR,*,*,${pkgs.niri}/bin/niri msg action focus-column-left" \
              -g "3,DU,*,*,${pkgs.niri}/bin/niri msg action focus-workspace-down" \
              -g "3,UD,*,*,${pkgs.niri}/bin/niri msg action focus-workspace-up" \
              -g "4,DU,*,*,${pkgs.niri}/bin/niri msg action open-overview" \
              -g "4,UD,*,*,${pkgs.niri}/bin/niri msg action close-overview" \
              -g "1,UD,T,*,$HOME/.config/waybar/scripts/waybar-toggle.sh eDP-1"
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
