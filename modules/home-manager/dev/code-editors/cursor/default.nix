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

