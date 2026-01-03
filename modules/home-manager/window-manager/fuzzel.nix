let
  fuzzelDir = ../../../home/ang3lo/.config/fuzzel;
in
{
  programs.fuzzel.enable = true;
  stylix.targets.fuzzel.enable = false;
  
  xdg.configFile."fuzzel" = {
    source = fuzzelDir;
    recursive = true;
  };
}