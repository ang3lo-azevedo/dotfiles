{
  pkgs,
  config,
  ...
}: let
  niriConfig = config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/niri";
in {
  xdg.configFile."niri" = {
    source = niriConfig;
  };

  home.packages = with pkgs; [
    niri
    xwayland-satellite
  ];

  home.sessionVariables = {
    EDITOR = "antigravity-ide";
  };
}
