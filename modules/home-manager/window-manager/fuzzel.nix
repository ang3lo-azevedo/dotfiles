let
  fuzzelDir = ../../../home/ang3lo/.config/fuzzel;
in
{
  programs.fuzzel.enable = true;
  stylix.targets.fuzzel.enable = false;
  
  xdg.configFile."fuzzel/fuzzel.ini".source = fuzzelDir + "/fuzzel.ini";

  xdg.configFile."fuzzel/scripts/fuzzel-powermenu.sh" = {
    source = fuzzelDir + "/scripts/fuzzel-powermenu.sh";
    executable = true;
  };
}