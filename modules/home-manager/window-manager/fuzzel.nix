{
  programs.fuzzel.enable = true;
  
  xdg.configFile."fuzzel/fuzzel.ini".source = ../../../home/ang3lo/config/fuzzel/fuzzel.ini;

  xdg.configFile."fuzzel/scripts/fuzzel-powermenu.sh" = {
    source = ../../../home/ang3lo/config/fuzzel/scripts/fuzzel-powermenu.sh;
    executable = true;
  };
}