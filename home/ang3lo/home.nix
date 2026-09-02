{inputs, ...}: {
  home = {
    username = "ang3lo";
    homeDirectory = "/home/ang3lo";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "antigravity-ide";
      BROWSER = "zen-browser";
      TERMINAL = "ghostty";
      EXPLORER = "$TERMINAL -e yazi";
      MUSIC_PLAYER = "spotify";
      DISCORD = "equibop";
      YOUTUBE_PLAYER = "grayjay";
    };
  };

  imports = [
    inputs.stylix.homeModules.stylix
    "${inputs.self}/modules/home-manager"
  ];

  programs.home-manager.enable = true;

  # Avoid warning when using home-manager.useGlobalPkgs, since NixOS already applies the stylix overlays to the global pkgs.
  stylix.overlays.enable = false;
}
