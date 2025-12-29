{
  mango,
  ...
}:
{
  imports = [
    mango.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;
    #settings = builtins.readFile ./config/mango/config.conf;
    autostart_sh = builtins.readFile ./config/mango/autostart.sh;
  };
}