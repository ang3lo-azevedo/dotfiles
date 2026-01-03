{ mango
, ...
}:
let
  # Path (relative to this file) to the repo directory containing mango configs
  mangoDir = ../../../home/ang3lo/.config/mango;
in
{
  imports = [
    mango.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;
    #settings = builtins.readFile (mangoDir + "/config.conf");
  };

  xdg.configFile."mango" = {
    source = mangoDir;
    recursive = true;
  };

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
