let
  niriConfig = ../../../home/ang3lo/.config/niri;
in
{
  programs.niri.enable = true;

  xdg.configFile."niri" = {
    source = niriConfig;
  };
}