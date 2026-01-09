{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./extensions.nix
  ];

  home.packages = with pkgs; [
    code-cursor
    cursor-id-modifier
  ];

  home.shellAliases = {
    code = "cursor";
  };

  # Create a wrapper script that launches zsh without the "no new privileges" flag
  # This uses systemd-run to create a new process scope
  home.file.".local/bin/cursor-zsh-wrapper" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      # Wrapper script to launch zsh without the "no new privileges" flag
      # Uses systemd-run to create a new process scope
      
      if command -v systemd-run >/dev/null 2>&1; then
        # Use systemd-run to launch in a new scope (bypasses no new privileges flag)
        exec systemd-run --user --scope --quiet ${pkgs.zsh}/bin/zsh "$@"
      else
        # Fallback: try to use setsid to create a new session
        exec ${pkgs.util-linux}/bin/setsid ${pkgs.zsh}/bin/zsh "$@"
      fi
    '';
  };

  # Systemd service to reset Cursor trial identifiers
  systemd.user.services.cursor-id-reset = {
    Unit = {
      Description = "Reset Cursor trial identifiers";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      # Close Cursor if running, then reset IDs
      ExecStart = "${pkgs.writeShellScript "cursor-id-reset" ''
        # Kill Cursor processes if running
        pkill -x cursor || true
        sleep 2
        # Run the ID modifier
        ${pkgs.cursor-id-modifier}/bin/cursor-id-modifier
      ''}";
    };
  };

  # Timer to run the reset service daily
  systemd.user.timers.cursor-id-reset = {
    Unit = {
      Description = "Daily Cursor ID reset timer";
    };
    Timer = {
      OnBootSec = "5m";  # Run 5 minutes after boot
      OnCalendar = "daily";  # Also run daily at midnight
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}

