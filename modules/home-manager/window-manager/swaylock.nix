let
  swaylockDir = ../../../home/ang3lo/.config/swaylock;
in
{
  programs.swaylock.enable = true;
  
  /* xdg.configFile."swaylock" = {
    source = swaylockDir;
    recursive = true;
  }; */
}