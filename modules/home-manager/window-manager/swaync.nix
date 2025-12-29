let
  # Path (relative to this file) to the repo directory containing swaync configs
  swayncDir = ../../../home/ang3lo/.config/swaync;
in
{
  services.swaync.enable = true;

  xdg.configFile."swaync/config.json".source = "${swayncDir}/config.json";
  xdg.configFile."swaync/style.css".source = "${swayncDir}/style.css";
  xdg.configFile."swaync/widgets.css".source = "${swayncDir}/widgets.css";
}
