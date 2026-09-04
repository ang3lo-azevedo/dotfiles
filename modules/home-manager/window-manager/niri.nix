{
  pkgs,
  config,
  ...
}: let
  niriConfig = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/ang3lo/.config/niri";
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
