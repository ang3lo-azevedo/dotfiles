{ pkgs, inputs, config, ... }:
let
  waybarDir = config.lib.file.mkOutOfStoreSymlink "/home/ang3lo/nix-config/home/ang3lo/.config/waybar";
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  
  home.packages = with pkgs; [
    playerctl
    inputs.self.packages.${pkgs.system}.scrollmpris
  ];
  
  stylix.targets.waybar.enable = false;

  xdg.configFile."waybar" = {
    source = waybarDir;
  };
}
