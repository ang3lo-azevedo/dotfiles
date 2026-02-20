{
  mango,
  pkgs,
  lib,
  ...
}:
let
  # Path (relative to this file) to the repo directory containing mango configs
  mangoDir = ../../../home/ang3lo/.config/mango;
in
{
  imports = [
    mango.hmModules.mango
  ];

  home.packages = with pkgs; [
    lswt
    jq
    grim
    slurp
  ];

  systemd.user.services.mango-autosave = {
    Unit = {
      Description = "Autosave Mango session";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/.config/mango/scripts/save-session.sh";
    };
  };

  systemd.user.timers.mango-autosave = {
    Unit = {
      Description = "Autosave Mango session every minute";
    };
    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  systemd.user.services.mango-shutdown-save = {
    Unit = {
      Description = "Save Mango session on shutdown/logout";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${pkgs.bash}/bin/bash %h/.config/mango/scripts/save-session.sh";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Direct symlink to repository for live config editing
  home.activation.linkMangoConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD rm -rf $HOME/.config/mango
    $DRY_RUN_CMD ln -sf ${mangoDir} $HOME/.config/mango
  '';

  # Auto-reload Mango when its config files change
  systemd.user.services.mango-reload = {
    Unit = {
      Description = "Reload Mango Window Manager";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "mmsg -d reload_config";
    };
  };

  systemd.user.paths.mango-reload = {
    Unit = {
      Description = "Watch Mango config file for changes";
    };
    Path = {
      PathModified = "%h/.config/mango/";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
