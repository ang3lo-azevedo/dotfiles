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
    settings = builtins.readFile ../../../home/ang3lo/config/mango/config.conf;
  };
}