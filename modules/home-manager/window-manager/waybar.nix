let
  # Path (relative to this file) to the repo directory containing waybar configs
  waybarDir = ../../../home/ang3lo/.config/waybar;
in
{
  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  xdg.configFile."waybar/config".source = "${waybarDir}/config";
  xdg.configFile."waybar/style.css".source = "${waybarDir}/style.css";
}