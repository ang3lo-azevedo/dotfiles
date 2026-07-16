{inputs, ...}: {
  home = {
    username = "ang3lo";
    homeDirectory = "/home/ang3lo";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "antigravity-ide";
      BROWSER = "zen-browser";
      EXPLORER = "ghostty -e yazi";
      MUSIC_PLAYER = "spotify";
      DISCORD = "equibop";
      YOUTUBE_PLAYER = "grayjay";
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
    inputs.binaryninja.hmModules.binaryninja
    "${inputs.self}/modules/home-manager"
  ];

  programs.home-manager.enable = true;
}
