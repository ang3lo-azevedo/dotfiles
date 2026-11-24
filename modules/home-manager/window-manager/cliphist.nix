{pkgs, ...}: {
  home.packages = with pkgs; [
    cliphist
  ];

  xdg.configFile."cliphist/config".text = ''
    max-items 100
    db-path $XDG_RUNTIME_DIR/cliphist/db
  '';

  systemd.user.services.cliphist-wipe = {
    Unit = {
      Description = "Periodically wipe cliphist clipboard database";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.cliphist}/bin/cliphist wipe";
    };
  };

  systemd.user.timers.cliphist-wipe = {
    Unit = {
      Description = "Timer to periodically wipe cliphist clipboard database";
    };
    Timer = {
      OnBootSec = "2h";
      OnUnitActiveSec = "2h";
      Persistent = true;
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
