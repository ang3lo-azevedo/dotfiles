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

  xdg.configFile."mango" = mangoDir;
}
