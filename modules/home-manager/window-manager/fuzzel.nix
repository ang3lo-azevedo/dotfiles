{
  programs.fuzzel.enable = true;
  
  xdg.configFile."fuzzel/config".source = ../../../home/ang3lo/config/fuzzel/config;

  # Deploy fuzzel helper scripts to the user's config and make them executable
  home.file.".config/fuzzel/scripts/fuzzel-powermenu.sh" = {
    source = ../../../home/ang3lo/config/fuzzel/scripts/fuzzel-powermenu.sh;
    executable = true;
  };
}